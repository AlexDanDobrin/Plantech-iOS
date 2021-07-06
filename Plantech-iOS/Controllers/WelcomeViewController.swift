//
//  ViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import UIKit

class WelcomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var humdityStepper: UIStepper!
    @IBOutlet weak var humidityLabel: UILabel!
    var noDataLabel = UILabel()
    
    var selectedSensorId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorList.dataSource = self
        sensorList.delegate = self
        
        
        noDataLabel.text = "Sensor has not measured any values"
        noDataLabel.numberOfLines = 1
        noDataLabel.textAlignment = .center
        noDataLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.centerYAnchor.constraint(equalTo: (self.view.centerYAnchor)).isActive = true
        noDataLabel.centerXAnchor.constraint(equalTo: (self.view.centerXAnchor)).isActive = true
        noDataLabel.isHidden = true
        
        CallManager.shared.fetchSensors(username: Account.username) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case .success(let data):
                Account.sensors = []
                for sensor in data {
                    Account.sensors.append(String(sensor.sensorId))
                }
                
                print(Account.sensors)
                
                // We update the UI asynchronous as soon as the data is loaded
                DispatchQueue.main.async {
                    if Account.sensors.count == 0 {
                        self?.mainView.isHidden = true
                        self?.selectedSensorId = Int(Account.sensors.first!)!
                        
                        let noSensorLabel = UILabel()
                        noSensorLabel.text = "You have no sensors to display.\nGo to Options and add sensors."
                        noSensorLabel.numberOfLines = 2
                        noSensorLabel.textAlignment = .center
                        noSensorLabel.font = UIFont.boldSystemFont(ofSize: 20)
                        self?.view.addSubview(noSensorLabel)
                        noSensorLabel.translatesAutoresizingMaskIntoConstraints = false
                        noSensorLabel.centerYAnchor.constraint(equalTo: (self?.view.centerYAnchor)!).isActive = true
                        noSensorLabel.centerXAnchor.constraint(equalTo: (self?.view.centerXAnchor)!).isActive = true
                    } else {
                        self?.sensorList.reloadAllComponents()
                        self?.mainView.isHidden = false
                        if let id = Int(Account.sensors.first ?? "") {
                            self?.updateUI(for: id)
                        }
                    }
                }
                
            case .failure(let error):
                print("Linia 57 \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        sensorList.reloadAllComponents()
        
    }

    @IBOutlet weak var humidityLimitLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var mainView: UIStackView!
    @IBOutlet weak var sensorList: UIPickerView!
    
    @IBAction func humidityStepperDidChange(_ sender: UIStepper) {
        humidityValueLabel.text = String(sender.value)
        CallManager.shared.updateLimit(sensorId: selectedSensorId, newLimit: Int(sender.value)) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let message):
                let message = message
                print(message)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            // Turn on the autonomous mode -> Call the API
            CallManager.shared.updateMode(sensorId: selectedSensorId, newMode: "auto") { [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .success(let message):
                    let message = message
                    print(message)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            // Turn off the autonomous mode -> Call the API
            CallManager.shared.updateMode(sensorId: selectedSensorId, newMode: "manual") { [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .success(let message):
                    let message = message
                    print(message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateUI(for sensorId: Int) {
        CallManager.shared.fetchMeasurement(sensor_id: sensorId) { [weak self] result in
            guard let self = self else { return }
                
            switch result {
            case .success(let measurement):
                DispatchQueue.main.async {
                    self.showUI()
                    self.humidityLabel.text = "\(Int(measurement.value))%"
                    self.dateLabel.text = "Measured on \n\(measurement.timestamp.description)"
                }
            case .failure(let error):
                print("Linia 166 \(error)")
                DispatchQueue.main.async {
                    self.hideUI()
                }
            }
        }
        
        CallManager.shared.fetchSensor(sensor_id: sensorId) { [weak self] result in
            guard let self = self else { return }
                
            switch result {
            case .success(let sensor):
                DispatchQueue.main.async {
//                    self.showUI()
                    self.humidityValueLabel.text = "\(sensor.limit).0"
                    self.humdityStepper.value = Double(sensor.limit)
                    if sensor.mode == "auto" {
                        self.autoSwitch.isOn = true
                    } else {
                        self.autoSwitch.isOn = false
                    }
                }
            case .failure(let error):
                print("Linia 189 \(error)")
                DispatchQueue.main.async {
//                    self.hideUI()
                }
            }
        }
    }
    
    func showUI() {
        print("showUI apelat")
        dateLabel.isHidden = false
        humidityLabel.isHidden = false
        humidityValueLabel.isHidden = false
        humdityStepper.isHidden = false
        modeSwitch.isHidden = false
        modeLabel.isHidden = false
        humidityLimitLabel.isHidden = false
        
        noDataLabel.isHidden = true
    }
    
    func hideUI() {
        print("hideUI apelat")
        dateLabel.isHidden = true
        humidityLabel.isHidden = true
        humidityValueLabel.isHidden = true
        humdityStepper.isHidden = true
        modeSwitch.isHidden = true
        modeLabel.isHidden = true
        humidityLimitLabel.isHidden = true
        
        noDataLabel.isHidden = false
        
    }
    
    // MARK: UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Account.sensors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSensorId = Int(Account.sensors[row])!
        updateUI(for: Int(Account.sensors[row])!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Account.sensors[row]
    }
    
}


extension Date {
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }

    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

