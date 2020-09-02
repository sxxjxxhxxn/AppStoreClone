//
//  AddChild.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/31.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
