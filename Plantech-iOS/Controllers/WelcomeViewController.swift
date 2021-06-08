//
//  ViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var humdityStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the switch to the option from account plist.
        autoSwitch.isOn = true
        // Set the value to the option from account plist.
        humdityStepper.value = 40.0
        humidityValueLabel.text = String(humdityStepper.value)
        percentageImage.image = UIImage(systemName: "30.circle.fill")
        dateLabel.text = "Watered on \n\(Date().date())\nat \(Date().time())"
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var percentageImage: UIImageView!
    @IBOutlet weak var humidityValueLabel: UILabel!
    
    @IBAction func humidityStepperDidChange(_ sender: UIStepper) {
        humidityValueLabel.text = String(sender.value)
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            // Turn on the autonomous mode -> Call the API
            print("Switch is on")
        } else {
            // Turn off the autonomous mode -> Call the API
            print("Switch is off")
        }
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

