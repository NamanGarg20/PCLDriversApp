//
//  Location.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import Foundation

// MARK: - LocationElement
struct LocationElement: Codable {
    let lat, log: Double?
    let geofence: Bool?

    enum CodingKeys: String, CodingKey {
        case lat = "Lat"
        case log = "Log"
        case geofence = "Geofence"
    }
}

typealias Location = [LocationElement]

struct newLocation: Codable {
    let driverID: Int?
    let lat, log: Double?
    let geofence: Bool?

    enum CodingKeys: String, CodingKey {
        case driverID = "DriverId"
        case lat = "Lat"
        case log
        case geofence = "Geofence"
    }
}
