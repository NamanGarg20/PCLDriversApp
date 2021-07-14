//
//  Routes.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/28/21.
//

import Foundation

class Routes{
     
    init(){
        
    }
    
    func getRoute(_ routeNum: Int, completion: @escaping ((RouteDetail) -> Void)){
        let resourceApi = "https://pclwebapi.azurewebsites.net/api/Route/GetRouteDetail/?RouteNumber=\(routeNum)"
        
        guard let resourceURL = URL(string: resourceApi) else{
            fatalError()
        }
        
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpBody = driverData
        
        URLSession.shared.dataTask(with:request) { data, response, error in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let routeDetail = try JSONDecoder().decode(RouteDetail.self, from: data)
                //print("Response data:\n \(routeDetail)")
                    completion(routeDetail)
                    
            }catch let jsonErr{
                print(jsonErr)
           }
           }.resume()
        }
    
}
