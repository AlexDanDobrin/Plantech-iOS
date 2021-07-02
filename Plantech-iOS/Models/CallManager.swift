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
    
    func fetchMeasurements(sensor_id: Int, completed: @escaping (Result<[Measurement], NSError>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/getMeasurements/\(sensor_id)") else {
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
    func fetchMeasurement(sensor_id: Int, completed: @escaping (Result<Measurement, NSError>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/lastMeasurement/\(sensor_id)") else {
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
    
    func createUser(username: String, password: String , completed: @escaping (Result<String, NSError>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/register") else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["username": username,
                                         "password": password]
        
        let paramsString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let bodyData = paramsString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func loginUser(username: String, password: String , completed: @escaping (Result<String, NSError>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["username": username,
                                         "password": password]
        
        let paramsString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let bodyData = paramsString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func requestDEMO(completed: @escaping (Result<String, NSError>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/requestDEMO") else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
}



