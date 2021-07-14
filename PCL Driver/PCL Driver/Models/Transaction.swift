//
//  Transaction.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/28/21.
//

import Foundation

class Transaction{
    
    let resourceApi = "https://pclwebapi.azurewebsites.net/api/Admin/AddUpdateTransactionStatus"
    
    init(){
        
    }
    
    
    func updateTransaction(_ id: Int, _ route: Int,_ specimen: Int, _ status: Int, _ value: String, completion: @escaping ((Completion)-> Void)){
        
        let resource = resourceApi
        
        guard let resourceURL = URL(string: resource) else{
            fatalError()
        }
        
        let TransactionModel = TransactionStatus(customerID: id, numberOfSpecimens: specimen, routeID: route, status: status, updateBy: value)
        guard let transactionData = try? JSONEncoder().encode(TransactionModel) else {
                        print("Error: Trying to convert model to JSON data")
                        return
                    }
        
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = transactionData
        
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
}
