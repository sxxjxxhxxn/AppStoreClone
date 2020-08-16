//
//  AppQueryListReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

typealias QueryListReactorDidSelectClosure = (AppQuery) -> Void

final class QueryListReactor: Reactor {
    let initialState = State()
    private let storage: AppQueryStorageType
    
    enum Action {
        case loadQueries
//        case select(query: String)
    }
    
    enum Mutation {
        case setQueries([QueryItemReactor])
    }
    
    struct State {
        var queries: [QueryItemReactor] = []
    }
    
    init(storage: AppQueryStorageType) {
        self.storage = storage
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadQueries:
            return storage.fetchQueries()
                .map { $0.map { QueryItemReactor(appQuery: $0) } }
                .map { Mutation.setQueries($0) }
        }
    }
    
}
