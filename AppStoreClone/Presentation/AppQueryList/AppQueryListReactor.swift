//
//  AppQueryListReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

typealias AppQueryListReactorDidSelectClosure = (AppQuery) -> Void

final class AppQueryListReactor: Reactor {
    var initialState = State()
    
    enum Action {
        case select(query: String)
    }
    
    struct State {
        
    }
    
}
