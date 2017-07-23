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
    fileprivate let dataSource = LoginVCDataSource()
    @IBOutlet private var usersTV: UITableView!


    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(usersDidUpdate),
            name: DSUsersDidUpdateNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public
    func setSceneDelegate(delegate: LoginSceneDelegate) {
        dataSource.setSceneDelegate(delegate: delegate)
    }

    func setDataService(service: DataService) {
        dataSource.setDataService(service: service)
    }

    // MARK: - Private
    @objc private func usersDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.usersTV.reloadData()
        }
    }


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
