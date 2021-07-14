//
//  TransactionStatus.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/28/21.
//

import Foundation

// MARK: - TransactionStatus
struct TransactionStatus: Codable {
    let customerID, numberOfSpecimens, routeID, status: Int?
    let updateBy: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case numberOfSpecimens = "NumberOfSpecimens"
        case routeID = "RouteId"
        case status = "Status"
        case updateBy = "UpdateBy"
    }
}
