//
//  DataService.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation


let DSUsersDidUpdateNotification = NSNotification.Name(rawValue: "DSUsersDidUpdateNotification")
let DSZonesDidUpdateNotification = NSNotification.Name(rawValue: "DSZonesDidUpdateNotification")


class DataService {

    // MARK: - Properties
    var myProfile: User?
    private(set) var users = [User]()
    private(set) var zones = [ParkingZone]()
    private let apiCLient = APIClient()

    // MARK: - Lyfecycle
    init() {
        updateUsers()
    }


    // MARK: - Public
    func updateUsers() {
        apiCLient.getUsers { [weak self] (usersFromResponse, error) in
            if error != nil {
                //process error
            } else if usersFromResponse != nil {
                self?.users = usersFromResponse!
                NotificationCenter.default.post(name: DSUsersDidUpdateNotification, object: nil)
            }
        }
    }

    func updateZones() {
        apiCLient.getZones { [weak self] (zonesFromResponse, error) in
            if error != nil {
                //process error
            } else if zonesFromResponse != nil {
                self?.zones = zonesFromResponse!
                NotificationCenter.default.post(name: DSZonesDidUpdateNotification, object: nil)
            }
        }
    }

    func addNewVehicle(vehicle: Vehicle) {
        myProfile!.vehicles!.append(vehicle)
        if myProfile!.vehicles!.count == 1 {
            myProfile?.defaultVehicle = myProfile!.vehicles![0]
        }
    }


    // MARK: - Private

}
