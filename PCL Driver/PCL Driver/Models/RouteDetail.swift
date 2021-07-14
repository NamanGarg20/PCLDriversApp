//
//  RouteDetail.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/28/21.
//


import Foundation

// MARK: - RouteDetailElement
struct RouteDetailElement: Codable {
    let route: Route?
    let customer: [Customer]?

    enum CodingKeys: String, CodingKey {
        case route = "Route"
        case customer = "Customer"
    }
}

// MARK: - Customer
struct Customer: Codable {
    let customerID: Int?
    let customerName, streetAddress, city, state: String?
    let zip: String?
    let specimensCollected: Int?
    let pickUpTime, collectionStatus: String?
    let isSelected: Bool?
    let custLat, custLog: Double?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case customerName = "CustomerName"
        case streetAddress = "StreetAddress"
        case city = "City"
        case state = "State"
        case zip = "Zip"
        case specimensCollected = "SpecimensCollected"
        case pickUpTime = "PickUpTime"
        case collectionStatus = "CollectionStatus"
        case isSelected = "IsSelected"
        case custLat = "Cust_Lat"
        case custLog = "Cust_Log"
    }
}

// MARK: - Route
struct Route: Codable {
    let routeNo: Int?
    let routeName: String?
    let driverID: Int?
    let driverName, vehicleNo: String?
    let vehicleID: Int?

    enum CodingKeys: String, CodingKey {
        case routeNo = "RouteNo"
        case routeName = "RouteName"
        case driverID = "DriverId"
        case driverName = "DriverName"
        case vehicleNo = "VehicleNo"
        case vehicleID = "VehicleId"
    }
}

typealias RouteDetail = [RouteDetailElement]
