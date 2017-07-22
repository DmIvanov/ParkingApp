//
//  MenuOperator.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class MenuOperator {

    private var menuIsOpen = false
    private let openBlock: ()->()
    private let closeBlock: ()->()

    init(openBlock: @escaping ()->(), closeBlock:@escaping ()->()) {
        self.openBlock = openBlock
        self.closeBlock = closeBlock
    }

    func menuButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(named: "menu_button"),
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(menuButtonPressed))
    }

    @objc private func menuButtonPressed() {
        if menuIsOpen {
            closeBlock()
        } else {
            openBlock()
        }
    }
}
