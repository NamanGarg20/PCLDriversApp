//
//  DriverLogin.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/28/21.
//

import Foundation


class DriverLogin{
    
    let resourceApi = "https://pclwebapi.azurewebsites.net/api/Driver/"
    
    init(){
        
    }
    
    func createAccount(_ phone: String, _ password: String, _ confirm: String, _ completion: @escaping ((Completion) -> Void)){
        
        let resource = resourceApi + "DriverSignUp"
        
        guard let resourceURL = URL(string: resource) else{
            fatalError()
        }
        
        let driverModel = NewDriver(confirmPassword: confirm, password: password, phoneNumber: phone)
        guard let driverData = try? JSONEncoder().encode(driverModel) else {
                        print("Error: Trying to convert model to JSON data")
                        return
                    }
        
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = driverData
        
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
        
    
    func login(_ phone: String, _ password: String, _ completion: @escaping ((DriverRoute) -> Void)){
        
        let resource = resourceApi + "DriverLogin"
        
        guard let resourceURL = URL(string: resource) else{
            fatalError()
        }
        
        let driverModel = Driver(password: password, phoneNumber: phone)
        guard let driverData = try? JSONEncoder().encode(driverModel) else {
                        print("Error: Trying to convert model to JSON data")
                        return
                    }
        
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = driverData
        
        URLSession.shared.dataTask(with:request) { data, response, error in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let routeNum = try JSONDecoder().decode(DriverRoute.self, from: data)
                print("Response data:\n \(routeNum)")
                    completion(routeNum)
                    
            }catch let jsonErr{
                print(jsonErr)
           }
           }.resume()
        }
        
}
