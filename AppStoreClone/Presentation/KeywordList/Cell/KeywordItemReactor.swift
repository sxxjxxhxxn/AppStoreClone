//
//  KeywordItemReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class KeywordItemReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: Keyword
    
    init(keyword: Keyword) {
        self.initialState = keyword
    }
}
