//
//  VehiclesListDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 23/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class VehiclesListDataSource: NSObject {

    // MARK: - Properties
    fileprivate weak var dataService: DataService?
    fileprivate weak var vc: ListVC?

    fileprivate var aInputMode = false
    fileprivate let inputDataUI: [(String, String)]
    fileprivate var inputDataResult: [(String, String)]?

    // MARK: - Lyfecycle
    init(dataService: DataService, vc: ListVC) {
        self.dataService = dataService
        self.vc = vc
        self.inputDataUI = [ // (field, placeholder)
            ("Number:", "1234xx"),
            ("Name", "Ford Focus")
        ]
    }


    // MARK: - Public


    // MARK: - Private


    // MARK: - Actions

}


extension VehiclesListDataSource: ListVCDataSource {

    func topLabelText() -> String {
        if inputMode() {
            return "Fill vehicle details".capitalized
        } else {
            return "Vehicles".capitalized
        }
    }

    func bottomButtonText() -> String? {
        if inputMode() {
            return "Save vehicle"
        } else {
            return "Add new vehicle"
        }

    }

    func bottomButtonPressed() {
        if inputMode() {
            if inputDataResult != nil {
                let newVehicle = Vehicle(name: inputDataResult![0].1, number: inputDataResult![1].1)
                dataService?.addNewVehicle(vehicle: newVehicle)
            }
        }
        aInputMode = !aInputMode
        vc?.refreshUI()
    }

    func cellModel(index: Int) -> ListVCCellModel? {
        var model: ListVCCellModel?
        if inputMode() {
            let pair = inputDataUI[index]
            model = ListVCCellModel(title: pair.0, subtitle: pair.1)
        } else {
            if let vehicle = dataService!.myProfile?.vehicles![index] {
                model = ListVCCellModel(title: vehicle.number, subtitle: vehicle.name)
            }
        }
        return model
    }

    func cellsAmount() -> Int {
        if inputMode() {
            return inputDataUI.count
        } else {
            if dataService!.myProfile!.vehicles == nil {
                return 0
            }
            return dataService!.myProfile!.vehicles!.count
        }
    }

    func inputMode() -> Bool {
        return aInputMode
    }

    func passInputData(data: [(String, String)]) {
        inputDataResult = data
    }
}
