//
//  ParkingZone.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

struct ParkingZone {
    let zoneId: String
    let address: String
    let lat: Double
    let long: Double

    init(apiId: String, apiDictionary: NSDictionary) {
        self.zoneId = apiId;
        self.address = apiDictionary["address"] as? String ?? ""
        self.lat = apiDictionary["lat"] as? Double ?? 0
        self.long = apiDictionary["lon"] as? Double ?? 0
    }
}
