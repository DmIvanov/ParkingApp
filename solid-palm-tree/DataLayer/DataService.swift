//
//  DataService.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

class DataService {

    // MARK: - Properties
    var myProfile: User?

    private(set) var users: [User]


    // MARK: - Lyfecycle
    init() {
        let firstTestUser = User(
            userId: "",
            userName: "test first",
            firstName: "",
            lastName: ""
        )
        users = [firstTestUser]
    }


    // MARK: - Public


    // MARK: - Private

}
