//
//  OptionsTableViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
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
            let addSensor = UIAlertController(title: "Add sensor", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                if let id = sensorId.text {
                    print("Sensor with id \(id) added.")
                }
            }
            
            addSensor.addTextField { (id) in
                id.placeholder = "Id of the sensor"
                sensorId = id
            }
            
            addSensor.addAction(action)
            
            addSensor.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(addSensor, animated: true, completion: nil)
        case 2:
            print(2)
        default:
            // Default case e singurul caz posibil ramas si anume apasarea Log out
            performSegue(withIdentifier: "logout", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

