//
//  LoginVC.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 21/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: - Properties
    let dataSource = LoginVCDataSource()


    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Public
    func setSceneDelegate(delegate: LoginSceneDelegate) {
        dataSource.setSceneDelegate(delegate: delegate)
    }

    func setDataService(service: DataService) {
        dataSource.setDataService(service: service)
    }

    // MARK: - Private


    // MARK: - Actions
}


extension LoginVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfUsers()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")!
        if let model = dataSource.cellModel(index: indexPath.row) {
            cell.textLabel?.text = model.title
        }
        return cell;
    }
}


extension LoginVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.selectUser(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
