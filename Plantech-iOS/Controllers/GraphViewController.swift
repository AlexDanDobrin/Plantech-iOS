//
//  GraphViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import UIKit
import Charts

class GraphViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var measurements: [Measurement] = [Measurement]()
    var today: String = Date().date()
    
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(7, force: false)
        yAxis.axisLineColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
        
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.axisLineColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
        
        return chartView
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sensorPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorPicker.delegate = self
        sensorPicker.dataSource = self
        
        view.addSubview(barChartView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        barChartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        barChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sensorPicker.reloadAllComponents()
        
        if Account.sensors.count == 0 {
            
            barChartView.isHidden = true
            segmentedControl.isHidden = true
            
            let noSensorLabel = UILabel()
            noSensorLabel.text = "You have no sensors to display.\nGo to Options and add sensors."
            noSensorLabel.numberOfLines = 2
            noSensorLabel.textAlignment = .center
            noSensorLabel.font = UIFont.boldSystemFont(ofSize: 20)
            self.view.addSubview(noSensorLabel)
            noSensorLabel.translatesAutoresizingMaskIntoConstraints = false
            noSensorLabel.centerYAnchor.constraint(equalTo: (self.view.centerYAnchor)).isActive = true
            noSensorLabel.centerXAnchor.constraint(equalTo: (self.view.centerXAnchor)).isActive = true
            

        } else {
            barChartView.isHidden = false
            segmentedControl.isHidden = false
            
            DispatchQueue.main.async {
                self.loadMeasurements(for: Int(Account.sensors.first!)!)
                self.setDataForLastDay()
            }
        }
        
        
    }
    
    // Load all the measurements
    func loadMeasurements(for sensor_id: Int) {
        CallManager.shared.fetchMeasurements(sensor_id: sensor_id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let measurements):
                self.measurements = measurements

                // We update the UI asynchronous as soon as the data is loaded
                DispatchQueue.main.async {
                    print("Measurements for id: \(sensor_id) are")
                    for measurement in self.measurements {
                        print("\(measurement.value) at \(measurement.timestamp)")
                    }
                    switch self.segmentedControl.selectedSegmentIndex {
                    case 0:
                        self.setDataForLastDay()
                    case 1:
                        self.setDataForLastWeek()
                    case 2:
                        self.setDataForLastMonth()
                    default:
                        break
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setDataForLastDay()
        case 1:
            setDataForLastWeek()
        case 2:
            setDataForLastMonth()
        default:
            break
        }
    }
    
    func setDataForLastDay() {
        
        
        var values: [Double] = []
        
        for measurement in measurements.reversed() {
            let data = measurement.timestamp.split(separator: " ")
            let day = Int(data[1])
            let month = monthToInteger(from: String(data[2]))
            if day == Int(today.split(separator: "-")[0]) && month == Int(today.split(separator: "-")[1]) {
                values.insert(measurement.value, at: 0)
            } else {
                break
            }
        }
        
        var chartValues: [BarChartDataEntry] = []
        
        for value in values {
            chartValues.append(BarChartDataEntry(x: Double(chartValues.count + 1), y: value))
        }
            
        let dataSet = BarChartDataSet(entries: chartValues, label: "Procentaj de umiditate")
        
        dataSet.colors = [.blue]
        
        let data = BarChartData(dataSet: dataSet)
        
        barChartView.xAxis.setLabelCount(24, force: false)
        
        barChartView.data = data
    }
    
    func setDataForLastWeek() {
        var values: [Double] = []
        
        let currentDay = Int(today.split(separator: "-")[0])!
        
        guard let lastDayString = (measurements.last?.timestamp.split(separator: " ")[1]) else {
            print("There are no measurements for this id.")
            return
        }
        
        let lastDay = Int(lastDayString)!
        
        var lastMonth = monthToInteger(from: String((measurements.last?.timestamp.split(separator: " ")[2])!)) - 1
        
        // Daca luna curenta este prima luna, atunci ii atribuim valoarea 12 pentru ca luna dinainte de Ianuarie este Decembrie
        if lastMonth == 0 {
            lastMonth = 12
        }
        
        var firstDay = 0
        
        if lastDay >= 7 {
            firstDay = lastDay - currentDay + 1
        } else {
            var monthDays = 0
            switch lastMonth {
                case 1, 3, 5, 7, 8, 10, 12:
                    monthDays = 31
                case 4, 6, 9, 11:
                    monthDays = 30
                case 2:
                    monthDays = 28
                default:
                    break
            }
            firstDay = monthDays + lastDay - currentDay + 1
        }
        for measurement in measurements.reversed() {
            let data = measurement.timestamp.split(separator: " ")
            let day = Int(data[1])!
            
            if day != firstDay - 1 {
                values.insert(measurement.value, at: 0)
            } else {
                break
            }
        }
        
        var chartValues: [BarChartDataEntry] = []
        
        for value in values {
            chartValues.append(BarChartDataEntry(x: Double(chartValues.count + 1), y: value))
        }
        
        let dataSet = BarChartDataSet(entries: chartValues, label: "Procentaj de umiditate")
        
        dataSet.colors = [.blue]
        
        let data = BarChartData(dataSet: dataSet)
        
        barChartView.xAxis.setLabelCount(21, force: false)
        barChartView.data = data
    }
    
    func setDataForLastMonth() {
        var values: [BarChartDataEntry] = []
        
        for measurement in self.measurements {
            let data = measurement.timestamp.split(separator: " ")
            let month = String(data[2])
            
            if monthToInteger(from: month) == Int(today.split(separator: "-")[1]) {
                values.append(BarChartDataEntry(x: Double(values.count + 1), y: measurement.value))
            } else {
                break
            }
        }
        
        let dataSet = BarChartDataSet(entries: values, label: "Procentaj de umiditate")
        
        dataSet.colors = [.blue]
        
        let data = BarChartData(dataSet: dataSet)
        
        barChartView.xAxis.setLabelCount(30, force: false)
        barChartView.data = data
    }
    
    func monthToInteger(from month: String) -> Int {
        switch month {
            case "Jan":
                return 1
            case "Feb":
                return 2
            case "Mar":
                return 3
            case "Apr":
                return 4
            case "May":
                return 5
            case "Jun":
                return 6
            case "Jul":
                return 7
            case "Aug":
                return 8
            case "Sep":
                return 9
            case "Oct":
                return 10
            case "Nov":
                return 11
            case "Dec":
                return 12
            default:
                break
        }
        return 0
    }
    
    // MARK: UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Account.sensors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadMeasurements(for: Int(Account.sensors[row])!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Account.sensors[row]
    }
}

