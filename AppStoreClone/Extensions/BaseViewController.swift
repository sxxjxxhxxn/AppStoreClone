//
//  BaseViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/21.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

protocol BaseViewController: class {
    associatedtype Reactor
    
    var _reactor: Reactor? { get set }
    
    func setReactor()
}

extension BaseViewController where Self: View {
    func setReactor() {
        guard _reactor != nil else { return }
        reactor = _reactor
        _reactor = nil
    }
}
