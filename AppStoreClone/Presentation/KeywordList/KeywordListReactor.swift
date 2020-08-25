//
//  KeywordListReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class KeywordListReactor: Reactor {
    let initialState = State()
    
    enum Action {
        case loadKeywords
        case select(keyword: KeywordItemReactor)
    }
    
    enum Mutation {
        case setKeywords([KeywordItemReactor])
    }
    
    struct State {
        var keywords: [KeywordItemReactor] = []
    }

}
