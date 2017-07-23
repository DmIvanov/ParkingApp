//
//  LoginVCDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class LoginVCDataSource: NSObject {

    // MARK: - Properties
    private weak var sceneDelegate: LoginSceneDelegate?
    private weak var dataService: DataService?

    // MARK: - Lyfecycle


    // MARK: - Public
    func setSceneDelegate(delegate: LoginSceneDelegate) {
        sceneDelegate = delegate
    }

    func setDataService(service: DataService) {
        dataService = service
    }

    func numberOfUsers() -> Int {
        guard let service = dataService else {return 0}
        let number = service.users.count
        return number
    }

    func cellModel(index: Int) -> LoginTVCellModel? {
        guard let user = self.user(index: index) else {return nil}
        return LoginTVCellModel(user: user)
    }

    func selectUser(index: Int) {
        guard let user = user(index: index) else {return}
        sceneDelegate?.userPicked(user: user)
    }


    // MARK: - Private
    func user(index: Int) -> User? {
        guard index < numberOfUsers() else {return nil}
        return dataService?.users[index]
    }


    // MARK: - Actions
}
