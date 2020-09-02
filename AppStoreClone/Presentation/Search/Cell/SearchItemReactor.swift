//
//  SearchItemReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/18.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class SearchItemReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: AppItem
    
    init(appItem: AppItem) {
        self.initialState = appItem
    }
}
