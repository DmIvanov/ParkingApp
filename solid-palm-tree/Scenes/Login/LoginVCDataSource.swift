//
//  LoginVCDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class LoginVCDataSource {

    // MARK: - Properties
    fileprivate weak var sceneDelegate: LoginSceneDelegate?
    fileprivate weak var dataService: DataService?
    fileprivate weak var vc: ListVC?

    // MARK: - Lyfecycle
    init(dataService: DataService, sceneDelegate: LoginSceneDelegate, vc: ListVC) {
        self.dataService = dataService
        self.sceneDelegate = sceneDelegate
        self.vc = vc
    }


    // MARK: - Public


    // MARK: - Private
    fileprivate func user(index: Int) -> User? {
        guard index < numberOfUsers() else {return nil}
        return dataService?.users[index]
    }

    @objc fileprivate func usersDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.vc?.refreshUI()
        }
    }

    fileprivate func numberOfUsers() -> Int {
        guard let service = dataService else {return 0}
        return service.users.count
    }
}


extension LoginVCDataSource: ListVCDataSource {

    func topLabelText() -> String {
        return "Users".capitalized
    }

    func bottomButtonText() -> String? {
        return "Add new user"
    }

    func bottomButtonPressed() {

    }

    func cellSelected(index: Int) {
        guard let user = user(index: index) else {return}
        sceneDelegate?.userPicked(user: user)
    }

    func cellModel(index: Int) -> ListVCCellModel? {
        guard let user = user(index: index) else {return nil}
        let model = ListVCCellModel(title: user.userName, subtitle: nil)
        return model
    }

    func cellsAmount() -> Int {
        return numberOfUsers()
    }

    func vcViewDidAppear() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(usersDidUpdate),
            name: DSUsersDidUpdateNotification,
            object: nil
        )
    }

    func vcViewWillDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
}


protocol LoginSceneDelegate: class {
    func userPicked(user: User)
}
