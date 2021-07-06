//
//  Sensor.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 24/06/2021.
//

import Foundation


class Sensor: Decodable {
    var sensorId: Int
    var userId: Int
    var mode: String
    var limit: Int
    
    init(sensorID: Int, mode: String, limit: Int, userId: Int)  {
        self.sensorId = sensorID
        self.mode = mode
        self.limit = limit
        self.userId = userId
    }

}
