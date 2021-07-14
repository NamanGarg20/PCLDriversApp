//
//  Driver.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import Foundation

struct Driver: Codable {
    let password, phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case password = "Password"
        case phoneNumber = "PhoneNumber"
    }
}

struct NewDriver: Codable {
    let confirmPassword, password, phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case confirmPassword = "ConfirmPassword"
        case password = "Password"
        case phoneNumber = "PhoneNumber"
    }
}

struct DriverRoute: Codable {
    let routeNo: Int?
    let result: String?

    enum CodingKeys: String, CodingKey {
        case routeNo = "RouteNo"
        case result = "Result"
    }
}



struct Completion: Codable {
    let result: String?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}
