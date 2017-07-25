//
//  Interactor.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 21/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class Interactor {

    // MARK: - Properties
    private weak var window: UIWindow?
    fileprivate let dataService = DataService()
    private var navigationController = UINavigationController()
    private var menuOperator: MenuOperator?


    // MARK: - Lyfecycle
    init(mainWindow: UIWindow?) {
        window = mainWindow

    }


    // MARK: - Public
    func appDidLaunched(options: [UIApplicationLaunchOptionsKey: Any]?) {
        goToLogin()
        window?.makeKeyAndVisible()
    }


    // MARK: - Private
    private func setNewNavigationWithRootVC(newRootVC: UIViewController) {
        guard let window = window else {return}
        navigationController = UINavigationController(rootViewController: newRootVC)
        navigationController.navigationBar.tintColor = UIColor.black
        setMenuButton(toController: newRootVC)
//        UIView.transition(
//            with: window,
//            duration: 0.5,
//            options: UIViewAnimationOptions.transitionCrossDissolve,
//            animations: {
                window.rootViewController = self.navigationController
//        }, completion: nil
//        )
    }

    private func setMenuButton(toController controller:UIViewController) {
        menuOperator = MenuOperator(openBlock:openMenu, closeBlock: closeMenu)
        controller.navigationItem.leftBarButtonItem = menuOperator?.menuButton()
    }

    private func openMenu() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(parkingAction())
        alert.addAction(profileAction())
        alert.addAction(historyAction())
        alert.addAction(logOutAction())
        alert.addAction(closeAction())
        navigationController.present(
            alert,
            animated: true,
            completion: nil
        )
    }

    private func closeMenu() {

    }

    private func logOutAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Log out",
            style: .default) { (action) in
                self.goToLogin()
        }
    }

    private func parkingAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Start parking",
            style: .default) { (action) in
                self.goToParking()
        }
    }

    private func historyAction() -> UIAlertAction {
        let logOut = UIAlertAction(
            title: "History",
            style: .default) { (action) in
                self.goToHistory()
        }
        return logOut
    }

    private func profileAction() -> UIAlertAction {
        return UIAlertAction(
            title: "User profile",
            style: .default) { (action) in
                self.goToProfile()
        }
    }

    private func closeAction() -> UIAlertAction {
        let cancel = UIAlertAction(
            title: "Close",
            style: .cancel) { (action) in

        }
        return cancel
    }


    // MARK: - Scene switching
    func goToLogin() {
        let listVC = SceneFactory.listVC()
        let loginDataSource = LoginVCDataSource(
            dataService: dataService,
            sceneDelegate: self,
            vc: listVC
        )
        listVC.dataSource = loginDataSource
        setNewNavigationWithRootVC(newRootVC: listVC)
        navigationController.isNavigationBarHidden = true
    }

    func goToParking() {
        let startParkingVC = SceneFactory.parkingSceneInitialVC()
        startParkingVC.setDataService(service: dataService)
        setNewNavigationWithRootVC(newRootVC: startParkingVC)
    }

    func goToProfile() {
        let listVC = SceneFactory.listVC()
        let profileDataSource = ProfileDataSource(
            dataService: dataService,
            vc: listVC
        )
        listVC.dataSource = profileDataSource
        setNewNavigationWithRootVC(newRootVC: listVC)
    }

    func goToHistory() {
        let listVC = SceneFactory.listVC()
        let historyDataSource = HistoryDataSource(
            dataService: dataService,
            vc: listVC
        )
        listVC.dataSource = historyDataSource
        setNewNavigationWithRootVC(newRootVC: listVC)
    }
}


extension Interactor: LoginSceneDelegate {
    func userPicked(user: User) {
        dataService.myProfile = user
        goToParking()
    }
}
