//
//  CallManager.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 07/06/2021.
//

import Foundation

class CallManager {
    static let shared = CallManager()
    
    private init() {}
    
    
    // MARK:- GET REQUEST -> FETCH MEASUREMENTS FOR SENSOR
    func fetchMeasurements(completed: @escaping (Result<[Measurement], NSError>) -> Void) {
        guard let url = URL(string: "https://localhost:8000/api/measurements/") else {
            completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL!"])))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Task Session failed!"])))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard let data = data else {
                completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // At this point there are no errors and data is valid
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let measurements = try decoder.decode([Measurement].self, from: data)
                completed(.success(measurements))
            } catch {
                print("Measurements array failed to decode!")
            }
        }.resume()
    }
    
    // MARK:- GET REQUEST -> FETCH LAST MEASUREMENT FOR SENSOR
    func fetchMeasurement(completed: @escaping (Result<Measurement, NSError>) -> Void) {
        guard let url = URL(string: "https://localhost:8000/api/measurements/") else {
            completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL!"])))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Task Session failed!"])))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard let data = data else {
                completed(.failure(.init(domain: "" , code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // At this point there are no errors and data is valid
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let measurement = try decoder.decode(Measurement.self, from: data)
                completed(.success(measurement))
            } catch {
                print("Measurements array failed to decode!")
            }
        }.resume()
    }
    
    func sendWaterRequest() -> Void {
        
    }
}
