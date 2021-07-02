//
//  Measurement.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import Foundation

class Measurement: Decodable {
    var timestamp: String
    var measurementID: Int
    var sensorID: Int
    var value: Double
    
    init(sensorID: Int, measurementID: Int, value: Double, timestamp: String) {
        self.sensorID = sensorID
        self.measurementID = measurementID
        self.value = value
        self.timestamp = timestamp
    }

}

