//
//  DriverLocation.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/28/21.
//

import Foundation

class DriverLocation{
    let resourceApi = "https://pclwebapi.azurewebsites.net/api/Driver/"
    
    init(){
        
    }
    
    func updateDriverLocation(_ id: Int,_ lat: Double,_ log: Double, _ geofence: Bool, completion: @escaping ((Completion)->Void)){
        let resource = resourceApi + "AddDriverLocation"
        guard let resourceURL = URL(string: resource) else{
            fatalError()
        }
        
        let locationModel = newLocation(driverID: id, lat: lat, log: log, geofence: geofence)
        guard let locationData = try? JSONEncoder().encode(locationModel) else {
                        print("Error: Trying to convert model to JSON data")
                        return
                    }
        
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = locationData
        
        URLSession.shared.dataTask(with:request) { data, response, error in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let completionModel = try JSONDecoder().decode(Completion.self, from: data)
                print("Response data:\n \(completionModel.result!)")
                    completion(completionModel)
                    
            }catch let jsonErr{
                print(jsonErr)
           }
           }.resume()
        
    }
    
    func getLocation(_ id: Int, completion: @escaping ((Location) -> Void)){
        let resource = resourceApi + "GetDriverLocation?DriverId=\(id)"
        
        guard let resourceURL = URL(string: resource) else{
            fatalError()
        }
        
        
        let request = URLRequest(url: resourceURL)
        
        
        URLSession.shared.dataTask(with:request) { data, response, error in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let driverLoc = try JSONDecoder().decode(Location.self, from: data)
                print("Response data:\n \(driverLoc)")
                completion(driverLoc)
                    
            }catch let jsonErr{
                print(jsonErr)
           }
           }.resume()
        }
    
    
}
