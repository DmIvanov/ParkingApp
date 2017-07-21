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
    private var navigationController = UINavigationController()


    // MARK: - Lyfecycle
    init(mainWindow: UIWindow?) {
        self.window = mainWindow
    }


    // MARK: - Public
    func appDidLaunched(options: [UIApplicationLaunchOptionsKey: Any]?) {
        let loginVC = SceneFactory.loginSceneInitialVC()
        setNavigationWithRootVC(newRootVC: loginVC)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    // MARK: - Private
    private func setNavigationWithRootVC(newRootVC: UIViewController) {
        navigationController = UINavigationController(rootViewController: newRootVC)
    }

    // MARK: - Actions


}
