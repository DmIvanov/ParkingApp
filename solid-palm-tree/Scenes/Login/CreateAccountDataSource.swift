//
//  CreateAccountDataSource.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 25/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class CreateAccountDataSource: NSObject {

    // MARK: - Properties
    fileprivate weak var dataService: DataService?
    fileprivate weak var vc: ListVC?

    fileprivate let inputDataUI: [(String, String)]
    fileprivate var inputDataResult: [(String, String)]?

    
    // MARK: - Lyfecycle
    init(dataService: DataService, vc: ListVC) {
        self.dataService = dataService
        self.vc = vc
        self.inputDataUI = [ // (field, placeholder)
            ("First Name:", "John"),
            ("Last Name", "Smith"),
            ("Username", "mr.Smith")
        ]
    }


    // MARK: Private
    @objc fileprivate func usersDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.vc?.refreshUI()
        }
    }
}


extension CreateAccountDataSource: ListVCDataSource {

    func topLabelText() -> String {
        return "Fill new user details".capitalized
    }

    func bottomButtonText() -> String? {
        return "Save user"
    }

    func bottomButtonPressed() {
        if inputDataResult != nil {
            let user = User(userName: inputDataResult![2].1, firstName: inputDataResult![0].1, lastName: inputDataResult![1].1)
            dataService!.addNewUser(user: user)
        }
        vc?.navigationController?.popViewController(animated: true)
    }

    func cellModel(index: Int) -> ListVCCellModel? {
        let pair = inputDataUI[index]
        let model = ListVCCellModel(title: pair.0, subtitle: pair.1)
        return model
    }

    func cellsAmount() -> Int {
        return inputDataUI.count
    }

    func passInputData(data: [(String, String)]) {
        inputDataResult = data
    }

    func inputMode() -> Bool {
        return true
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
