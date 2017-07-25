//
//  ParkingAction.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 23/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

struct ParkingAction {
    let userId: String
    let zoneId: String
    let vehicleId: String
    var startDate: Date?
    var endDate: Date?
    var actionId: String?

    init(apiId: String, apiDictionary: NSDictionary) {
        self.actionId = apiId;
        self.userId = apiDictionary["userId"] as? String ?? ""
        self.vehicleId = apiDictionary["vehicleId"] as? String ?? ""
        self.zoneId = apiDictionary["zoneId"] as? String ?? ""
        if let startString = apiDictionary["startDate"] as? String {
            let timeInt = TimeInterval(startString)
            self.startDate = Date(timeIntervalSince1970: timeInt!)
        }
        if let endString = apiDictionary["stopDate"] as? String {
            let timeInt = TimeInterval(endString)
            self.endDate = Date(timeIntervalSince1970: timeInt!)
        }
    }

    init(userId: String, zoneId: String, vehicleId: String, startDate: Date) {
        self.userId = userId
        self.zoneId = zoneId
        self.vehicleId = vehicleId
        self.startDate = startDate
    }

    func dict() -> NSDictionary {
        let dict = [
            "userId" : userId,
            "vehicleId" : vehicleId,
            "zoneId" : zoneId,
            "startDate" : "\(startDate!.timeIntervalSince1970)"
        ]
        return NSDictionary(dictionary: dict)
    }

    func endDateDict() -> NSDictionary {
        let dict = [
            "stopDate" : "\(endDate!.timeIntervalSince1970)"
        ]
        return NSDictionary(dictionary: dict)
    }
}
