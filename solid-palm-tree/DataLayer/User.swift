//
//  User.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation


struct User {
    let userId: String
    let userName: String
    let firstName: String
    let lastName: String
    var vehicles: [Vehicle]?
    var defaultVehicle: Vehicle?

    init(userId: String, userName: String, firstName: String, lastName: String) {
        self.userId = userId
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
    }

    init(apiId: String, apiDictionary: NSDictionary) {
        self.userId = apiId;
        self.userName = apiDictionary["userName"] as? String ?? ""
        self.firstName = apiDictionary["firstName"] as? String ?? ""
        self.lastName = apiDictionary["lastName"] as? String ?? ""

        // temporary
        fillDefaultVehicles()
    }

    private mutating func fillDefaultVehicles() {
        vehicles = [
            Vehicle(name: "Ford Mustang", number: "3425gt", vehicleId: "vehicleId0"),
            Vehicle(name: "Chery Tiggo", number: "8756th", vehicleId: "vehicleId1")
        ]
        defaultVehicle = vehicles![0]
    }
}
