//
//  ParkingStartVCDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

class ParkingStartVCDataSource {

    private let noVehiclePlaceholder = "No vehicle set as default"
    private let noZonePlaceholder = "No zone selected"

    // MARK: - Properties
    weak var dataService: DataService?
    private var selectedZone: ParkingZone?

    // MARK: - Lyfecycle


    // MARK: - Public
    func defaultVehicleText() -> String {
        guard let dataService = dataService else {return ""}
        guard let profile = dataService.myProfile else {return ""}
        guard let defVehicle = profile.defaultVehicle else {return noVehiclePlaceholder}
        return defVehicle.name
    }

    func selectedZoneText() -> String {
        guard let zone = selectedZone else {return noZonePlaceholder}
        return "Selected zone - \(zone.address)"
    }

    func setDataService(service: DataService) {
        dataService = service
    }

    func updateZones() {
        dataService?.updateZones()
    }

    func zones() -> [ParkingZone] {
        guard let dataService = dataService else {return [ParkingZone]()}
        return dataService.zones
    }

    func setSelectedZone(withTitle title: String) {
        let foundZone = zones().first(where: {$0.address == title})
        selectedZone = foundZone
    }

    func parkingAction() -> (action: ParkingAction?, error: String?) {
        guard let profile = dataService?.myProfile else {return (nil, "User's profile isn't specified!")}
        guard let zone = selectedZone else {return (nil, "Zone is not selected!")}
        guard let vehicle = profile.defaultVehicle else {return (nil, "Default vehicle is not specified!")}
        let action = ParkingAction(
            user: profile,
            zone: zone,
            vehicle: vehicle,
            startDate: Date(),
            endDate: nil
        )
        return (action, nil)
    }

    // MARK: - Private


}
