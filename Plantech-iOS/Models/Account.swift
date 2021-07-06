//
//  Account.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 04/07/2021.
//

import Foundation

struct Account {
    static var username: String = "Empty"
    static var sensors: [String] = [String]()
    
    static func removeSensor(with sensorId: String) {
        if let index = Account.sensors.firstIndex(of: sensorId){
            Account.sensors.remove(at: index)
        }
    }
}
