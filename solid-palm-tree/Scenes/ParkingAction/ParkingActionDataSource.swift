//
//  ParkingActionDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 23/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation


class ParkingActionDataSource {

    // MARK: - Properties
    fileprivate var parkingAction: ParkingAction
    fileprivate weak var dataService: DataService?
    fileprivate weak var vc: ListVC?
    fileprivate var data: [(String, String)]!

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()


    // MARK: - Lyfecycle
    init(parkingAction: ParkingAction, dataService: DataService, vc: ListVC) {
        self.parkingAction = parkingAction
        self.dataService = dataService
        self.vc = vc
        refreshData()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(actionsDidUpdate),
            name: DSActionsDidUpdateNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Public


    // MARK: - Private
    @objc private func actionsDidUpdate() {
        parkingAction = dataService!.parkingActions.last!
        refreshData()
        DispatchQueue.main.async { [weak self] in
            self?.vc?.refreshUI()
        }
    }

    fileprivate func numberOfActions() -> Int {
        return actions().count
    }

    fileprivate func actions() -> [ParkingAction] {
        return dataService!.parkingActions
    }

    fileprivate func action(index: Int) -> ParkingAction? {
        guard index < numberOfActions() else {return nil}
        return dataService!.parkingActions[index]
    }

    private func refreshData() {
        guard let profile = dataService?.myProfile! else {return}
        let zone = dataService!.getZone(forId: parkingAction.zoneId)
        self.data = [
            ("User name", profile.userName),
            ("Zone", zone!.address),
            ("Vehicle", parkingAction.vehicleId)
        ]
        if let startDate = parkingAction.startDate {
            data.append(("Start date",  dateFormatter.string(from: startDate)))
        }
        if let endDate = parkingAction.endDate {
            data.append(("End date",  dateFormatter.string(from: endDate)))
        }
    }
    

    // MARK: - Actions

}


extension ParkingActionDataSource: ListVCDataSource {

    func topLabelText() -> String {
        return "Parking".capitalized
    }

    func bottomButtonText() -> String? {
        return "Stop parking"
    }

    func bottomButtonPressed() {
        parkingAction.endDate = Date()
        dataService!.finishParkingAction(action: parkingAction)
    }

    func cellModel(index: Int) -> ListVCCellModel? {
        let dataPair = data[index]
        let model = ListVCCellModel(title: dataPair.0, subtitle: dataPair.1)
        return model
    }

    func cellsAmount() -> Int {
        return data.count
    }
}
