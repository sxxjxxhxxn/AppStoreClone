//
//  DetailReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/21.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class DetailReactor: Reactor {
    let initialState: AppItem
    
    typealias Action = NoAction
    
    init(appItem: AppItem) {
        self.initialState = appItem
    }
}
