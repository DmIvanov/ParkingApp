//
//  SceneFactory.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 21/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class SceneFactory {

    // MARK: Public

    class func listVC() -> ListVC {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ListVC") as! ListVC
    }

    class func parkingSceneInitialVC() -> ParkingStartVC {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ParkingStartVC") as! ParkingStartVC
    }


    // MARK: Private

    private class func mainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
