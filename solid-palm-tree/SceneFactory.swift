//
//  SceneFactory.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 21/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class SceneFactory {

    class func loginSceneInitialVC() -> UIViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC")
    }

    class func parkingSceneInitialVC() -> UIViewController {
        return UIViewController()
    }

    private class func mainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
