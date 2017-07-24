//
//  ParkingActionDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 23/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation


class ParkingActionDataSource: NSObject {

    // MARK: - Properties
    var parkingAction: ParkingAction
    weak var dataService: DataService?

    // MARK: - Lyfecycle
    init(parkingAction: ParkingAction, dataService: DataService) {
        self.parkingAction = parkingAction
        self.dataService = dataService
    }


    // MARK: - Public


    // MARK: - Private


    // MARK: - Actions

}


extension ParkingActionDataSource: ListVCDataSource {

    func topLabelText() -> String {
        return "Parking".capitalized
    }

    func bottomButtonText() -> String? {
        return "Stop parking"
    }

    func cellSelected(index: Int) {

    }

    func bottomButtonPressed() {

    }

    func cellModel(index: Int) -> ListVCCellModel? {
        //guard let user = user(index: index) else {return nil}
        let model = ListVCCellModel(title: "", subtitle: nil)
        return model
    }

    func cellsAmount() -> Int {
        return 0
    }
}
