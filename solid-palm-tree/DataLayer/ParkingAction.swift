//
//  ParkingAction.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 23/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

struct ParkingAction {
    let user: User
    let zone: ParkingZone
    let vehicle: Vehicle
    var startDate: Date?
    var endDate: Date?
}
