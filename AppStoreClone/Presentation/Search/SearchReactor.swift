//
//  SearchReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

struct SearchReactorClosures {
    let showAppDetails: (AppItem) -> Void
    let openAppQueryList: () -> Void
    let closeAppQueryList: () -> Void
}

final class SearchReactor: Reactor {
    let initialState = State()
    private let service: AppStoreServiceType
    private let closures: SearchReactorClosures?
    
    enum Action {
        case search(query: String)
        case loadMore(query: String)
        case openQueryList
        case closeQueryList
    }
    
    enum Mutation {
        case setFetching(Bool)
        case setItems([SearchItemReactor])
        case appendItems([SearchItemReactor])
        case setQueryListVisibility(Bool)
    }
    
    struct State {
        let title = "검색"
        var isFetching: Bool = false
        var items: [SearchItemReactor] = []
        var numberOfItems = 20
        var queryListVisibility: Bool = false
    }
    
    init(service: AppStoreServiceType,
         closures: SearchReactorClosures? = nil) {
        self.service = service
        self.closures = closures
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
        case .openQueryList:
            closures?.openAppQueryList()
            return BehaviorSubject<Mutation>.init(value: Mutation.setQueryListVisibility(true)).asObservable()
        case .closeQueryList:
            closures?.closeAppQueryList()
            return BehaviorSubject<Mutation>.init(value: Mutation.setQueryListVisibility(false)).asObservable()
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
        case let .setQueryListVisibility(visibility):
            var newState = state
            newState.queryListVisibility = visibility
            return newState
        }
    }
    
}
