//
//  SearchReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class SearchReactor: Reactor {
    let initialState = State()
    private let service: AppStoreServiceType
    
    enum Action {
        case search(query: String)
        case loadMore(query: String)
    }
    
    enum Mutation {
        case setFetching(Bool)
        case setItems([SearchItemReactor])
        case appendItems([SearchItemReactor])
    }
    
    struct State {
        let title = "검색"
        var isFetching: Bool = false
        var items: [SearchItemReactor] = []
        var numberOfItems = 20
    }
    
    init(service: AppStoreServiceType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(var query):
            query += "&limit=20"
            return Observable.concat([
                Observable.just(Mutation.setFetching(true)),

                service.appItems(query)
                    .map { $0.map { SearchItemReactor(appItem: $0) } }
                    .map { Mutation.setItems($0) },
                    
                Observable.just(Mutation.setFetching(false))
            ])
        case .loadMore(var query):
            query += "&limit=\(self.currentState.numberOfItems + 20)"
            return service.appItems(query)
                .map { (appItems) -> [AppItem] in
                    var items = appItems
                    items.removeSubrange(0 ..< self.currentState.numberOfItems)
                    return items
                }
                .map { $0.map { SearchItemReactor(appItem: $0) } }
                .map { Mutation.appendItems($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setItems(items):
            var newState = state
            newState.items = items
            newState.numberOfItems = items.count
            return newState
        case let .appendItems(items):
            guard !items.isEmpty else {
                return state
            }
            var newState = state
            newState.items += items
            newState.numberOfItems += items.count
            return newState
        case let .setFetching(isFetching):
            var newState = state
            newState.isFetching = isFetching
            return newState
        }
    }
    
}
