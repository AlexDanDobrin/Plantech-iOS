//
//  OptionsTableViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedSensor: String = ""
    var pickerView = UIPickerView()
    
    var optionsArray: NSArray {
        if let path = Bundle.main.path(forResource: "Options", ofType: "plist") {
            return NSArray(contentsOfFile: path)!
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = self.optionsArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Cazul in care se face click pe start DEMO
            CallManager.shared.requestDEMO { [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .success(let message):
                    let message = message
                    print(message)
                case .failure(let error):
                    print(error)
                    
                }
            }
            
        case 1:
            var sensorId = UITextField()
            var limit = UITextField()
            let addSensor = UIAlertController(title: "Add sensor", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                if let id = Int(sensorId.text!), let safeLimit = Int(limit.text!) {
                    CallManager.shared.addSensor(sensorId: id, limit: safeLimit) { [weak self] result in
                        guard self != nil else { return }
                        
                        switch result {
                        case .success(let message):
                            let message = message
                            Account.sensors.append(String(id))
                            print(message)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            
            addSensor.addTextField { (id) in
                id.placeholder = "Id of the sensor"
                sensorId = id
            }
            
            addSensor.addTextField { (limitTextField) in
                limitTextField.placeholder = "Limit of the sensor"
                limit = limitTextField
            }
            
            addSensor.addAction(action)
            
            addSensor.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(addSensor, animated: true, completion: nil)
        case 2:
            let alert = UIAlertController(title: "Car Choices", message: "\n\n\n\n\n\n", preferredStyle: .alert)
                    
            let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
                    
            alert.view.addSubview(pickerFrame)
            pickerFrame.dataSource = self
            pickerFrame.delegate = self
                    
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        
            print("You selected " + self.selectedSensor )
            
                CallManager.shared.removeSensor(sensor_id: Int(self.selectedSensor)!) { [weak self] result in
                    guard self != nil else { return }
                        
                    switch result {
                    case .success(let message):
                        let message = message
                        print(message)
                        Account.removeSensor(with: self!.selectedSensor)
                    case .failure(let error):
                        print(error)
                    }
                }
            
            
            }))
            self.present(alert, animated: true, completion: nil )
        default:
            // Default case e singurul caz posibil ramas si anume apasarea Log out
            performSegue(withIdentifier: "logout", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: PickerView protocol methods
extension OptionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Account.sensors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Account.sensors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSensor = Account.sensors[row]
    }
}
