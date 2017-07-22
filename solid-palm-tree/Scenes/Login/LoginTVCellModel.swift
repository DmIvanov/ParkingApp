//
//  LoginTVCellModel.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

struct LoginTVCellModel {

    let title: String

    init(user: User) {
        title = user.userName
    }
}
