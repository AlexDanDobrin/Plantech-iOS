//
//  GraphViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import UIKit

class GraphViewController: UIViewController {

    var measurements = [Measurement]()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Load all the measurements
    func loadMeasurements() {
        CallManager.shared.fetchMeasurements { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let measurements):
                self.measurements = measurements
                
                // We update the UI asynchronous as soon as the data is loaded
                DispatchQueue.main.async {
                    // Whatever UI needs to be updated here
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Last 24h")
        case 1:
            print("Last week")
        case 2:
            print("Last month")
        default:
            break
        }
    }
}
