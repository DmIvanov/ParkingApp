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


    // MARK: - Lyfecycle
    init(mainWindow: UIWindow?) {
        window = mainWindow

    }


    // MARK: - Public
    func appDidLaunched(options: [UIApplicationLaunchOptionsKey: Any]?) {
        let loginVC = SceneFactory.loginSceneInitialVC()
        loginVC.setDataService(service: dataService)
        loginVC.setSceneDelegate(delegate: self)
        setNavigationWithRootVC(newRootVC: loginVC)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


    // MARK: - Private
    private func setNavigationWithRootVC(newRootVC: UIViewController) {
        navigationController = UINavigationController(rootViewController: newRootVC)
    }

    // MARK: - Scene switching
    func goToParking() {
        let startParkingVC = SceneFactory.parkingSceneInitialVC()
        navigationController.pushViewController(startParkingVC, animated: true)
    }


}


extension Interactor: LoginSceneDelegate {
    func userPicked(user: User) {
        dataService.myProfile = user
        goToParking()
    }
}
