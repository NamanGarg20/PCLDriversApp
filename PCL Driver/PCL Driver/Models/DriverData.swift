//
//  DriverData.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import Foundation

struct DriverElement: Codable {
    let driverID: Int?
    let driverName, phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case driverID = "DriverId"
        case driverName = "DriverName"
        case phoneNumber = "PhoneNumber"
    }
}

typealias DriverData = [DriverElement]

