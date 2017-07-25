//
//  DataService.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation


let DSUsersDidUpdateNotification        = NSNotification.Name(rawValue: "DSUsersDidUpdateNotification")
let DSZonesDidUpdateNotification        = NSNotification.Name(rawValue: "DSZonesDidUpdateNotification")
let DSActionsDidUpdateNotification      = NSNotification.Name(rawValue: "DSActionsDidUpdateNotification")
let DSProfileDidUpdateNotification      = NSNotification.Name(rawValue: "DSProfileDidUpdateNotification")


class DataService {

    // MARK: - Properties
    var myProfile: User?
    private(set) var users = [User]()
    private(set) var zones = [ParkingZone]()
    private(set) var parkingActions = [ParkingAction]()
    private let apiCLient = APIClient()

    // MARK: - Lyfecycle
    init() {
        updateUsers()
        updateParkingActions()
    }


    // MARK: - Public
    func updateUsers() {
        apiCLient.getUsers { [weak self] (usersFromResponse, error) in
            if error != nil {
                //process error
            } else if usersFromResponse != nil {
                self?.users = usersFromResponse!
                NotificationCenter.default.post(name: DSUsersDidUpdateNotification, object: self)
            }
        }
    }

    func updateZones() {
        apiCLient.getZones { [weak self] (zonesFromResponse, error) in
            if error != nil {
                //process error
            } else if zonesFromResponse != nil {
                self?.zones = zonesFromResponse!
                NotificationCenter.default.post(name: DSZonesDidUpdateNotification, object: self)
            }
        }
    }

    func updateParkingActions() {
        apiCLient.getParkingActions { [weak self] (actionsFromResponse, error) in
            if error != nil {
                //process error
            } else if actionsFromResponse != nil {
                self?.parkingActions = actionsFromResponse!
                NotificationCenter.default.post(name: DSActionsDidUpdateNotification, object: self)
            }
        }
    }

    func addNewUser(user: User) {
        apiCLient.postUser(user: user) { [weak self] (userId, error) in
            var user = user
            user.userId = userId
            self?.users.append(user)
            NotificationCenter.default.post(name: DSUsersDidUpdateNotification, object: self)
        }
    }

    func addNewVehicle(vehicle: Vehicle) {
        myProfile!.vehicles!.append(vehicle)
        if myProfile!.vehicles!.count == 1 {
            myProfile?.defaultVehicle = myProfile!.vehicles![0]
        }
    }

    func startParkingAction(action: ParkingAction) {
        apiCLient.postParkingAction(action: action) { [weak self] (actionId, error) in
            var action = action
            action.actionId = actionId
            self?.parkingActions.append(action)
            NotificationCenter.default.post(name: DSActionsDidUpdateNotification, object: self)
        }
    }

    func finishParkingAction(action: ParkingAction) {
        guard action.actionId != nil else {return}
        apiCLient.patchParkingAction(action: action) { [weak self] (error) in
            if error == nil {
                self?.updateActions(withAction: action)
                NotificationCenter.default.post(name: DSActionsDidUpdateNotification, object: self)
            } else {
                // process the error
            }
        }
    }

    func finishedParkingActions() -> [ParkingAction] {
        let finishedActions = parkingActions.filter({ (action) -> Bool in
            return action.endDate != nil
        })
        return finishedActions
    }

    func getZone(forId zoneId: String) -> ParkingZone? {
        return zones.filter({ (zone) -> Bool in
            return zone.zoneId == zoneId
        }).first
    }

    func getVehicle(forId vehicleId: String) -> Vehicle? {
        return myProfile?.vehicles?.filter({ (vehicle) -> Bool in
            return vehicle.vehicleId == vehicleId
        }).first
    }

    func getAction(forId actionId: String) -> ParkingAction? {
        return parkingActions.filter({ (action) -> Bool in
            return action.actionId == actionId
        }).first
    }


    // MARK: - Private
    fileprivate func updateActions(withAction action: ParkingAction) {
        if let index = parkingActions.index(where: {$0.actionId == action.actionId}) {
            parkingActions.remove(at: index)
            parkingActions.append(action)
        }
    }
}
