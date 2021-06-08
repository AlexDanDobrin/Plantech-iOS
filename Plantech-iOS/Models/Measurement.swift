//
//  Measurement.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import Foundation

class Measurement: Decodable {
    var timestamp: Date
    var sensorID: Int
    var value: Double
    
    init(timestamp: Date, sensorID: Int, value: Double) {
        self.timestamp = timestamp
        self.sensorID = sensorID
        self.value = value
    }
    
//    init(timestamp: String, sensorID: Int, value: Double) {
//        self.timestamp = Date(d)
//        self.sensorID = sensorID
//        self.value = value
//    }
}
