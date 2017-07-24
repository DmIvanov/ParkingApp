//
//  ProfileDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 23/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class ProfileDataSource {

    // MARK: - Properties
    fileprivate weak var dataService: DataService?
    fileprivate weak var vc: ListVC?
    fileprivate let data: [(String, String)]


    // MARK: - Lyfecycle
    init(dataService: DataService, vc: ListVC) {
        self.dataService = dataService
        self.vc = vc
        let profile = dataService.myProfile!
        self.data = [
            ("First name", profile.firstName),
            ("Last name", profile.lastName),
            ("Email", ""),
            ("Default vehicle", profile.defaultVehicle?.name ?? "")
        ]
    }


    // MARK: - Public


    // MARK: - Private
    fileprivate func openVehiclesScreen() {
        let listVC = SceneFactory.listVC()
        let vahicleDataSource = VehiclesListDataSource(
            dataService: dataService!,
            vc: listVC
        )
        listVC.dataSource = vahicleDataSource
        vc?.navigationController?.pushViewController(listVC, animated: true)
    }
}


extension ProfileDataSource: ListVCDataSource {

    func topLabelText() -> String {
        return dataService!.myProfile!.userName.capitalized
    }

    func cellSelected(index: Int) {
        if index == 3 {
            // default vehicle
            openVehiclesScreen()
        }
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

