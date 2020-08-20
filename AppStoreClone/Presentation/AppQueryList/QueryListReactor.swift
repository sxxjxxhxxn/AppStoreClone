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
    private let didSelect: QueryListReactorDidSelectClosure?
    
    enum Action {
        case loadQueries
        case select(keyword: QueryItemReactor)
    }
    
    enum Mutation {
        case setQueries([QueryItemReactor])
        case void
    }
    
    struct State {
        var queries: [QueryItemReactor] = []
    }
    
    init(storage: AppQueryStorageType,
         didSelect: QueryListReactorDidSelectClosure? = nil) {
        self.storage = storage
        self.didSelect = didSelect
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadQueries:
            return storage.fetchQueries()
                .map { $0.map { QueryItemReactor(appQuery: $0) } }
                .map { Mutation.setQueries($0) }
        case .select(let queryItemReactor):
            didSelect(queryItemReactor)
            return .just(Mutation.void)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setQueries(queries):
            newState.queries = queries
            return newState
        case .void:
            return newState
        }
    }
    
    func didSelect(_ item: QueryItemReactor) {
        didSelect?(AppQuery(query: item.initialState.query))
    }
    
}
