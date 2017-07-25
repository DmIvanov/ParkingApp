//
//  HistoryDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 25/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class HistoryDataSource {

    // MARK: - Properties
    fileprivate weak var dataService: DataService?
    fileprivate weak var vc: ListVC?

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    

    // MARK: - Lyfecycle
    init(dataService: DataService, vc: ListVC) {
        self.dataService = dataService
        self.vc = vc

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
    @objc fileprivate func actionsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.vc?.refreshUI()
        }
    }

    fileprivate func numberOfActions() -> Int {
        return actions().count
    }

    fileprivate func actions() -> [ParkingAction] {
        return dataService!.finishedParkingActions()
    }

    fileprivate func action(index: Int) -> ParkingAction? {
        guard index < numberOfActions() else {return nil}
        return actions()[index]
    }


    // MARK: - Actions
}


extension HistoryDataSource: ListVCDataSource {

    func topLabelText() -> String {
        return "History".capitalized
    }

    func cellModel(index: Int) -> ListVCCellModel? {
        guard let action = action(index: index) else {return nil}
        let zoneString = dataService!.getZone(forId: action.zoneId)?.address ?? "Unknown Zone"
        let vehicleString = dataService!.getVehicle(forId: action.vehicleId)?.number ?? "Unknown Vehicle"
        let cellTitle = zoneString + " - " + vehicleString
        let cellSubtitle = (action.startDate != nil) ? dateFormatter.string(from: action.startDate!) : ""
        let model = ListVCCellModel(title: cellTitle, subtitle: cellSubtitle)
        return model
    }

    func cellsAmount() -> Int {
        return numberOfActions()
    }

    func vcViewDidAppear() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(actionsDidUpdate),
            name: DSActionsDidUpdateNotification,
            object: nil
        )
    }

    func vcViewWillDisappear() {
        NotificationCenter.default.removeObserver(
            self,
            name: DSActionsDidUpdateNotification,
            object: nil
        )
    }
}
