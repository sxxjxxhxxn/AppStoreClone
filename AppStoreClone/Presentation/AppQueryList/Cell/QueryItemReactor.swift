//
//  QueryItemReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/16.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

class QueryItemReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: AppQuery
    
    init(appQuery: AppQuery) {
        self.initialState = appQuery
        print(appQuery.query)
    }
}
