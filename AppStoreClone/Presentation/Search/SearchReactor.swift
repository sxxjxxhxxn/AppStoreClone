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
    var numberOfItems = 20
    private let service: AppStoreServiceType
    
    enum Action {
        case pull(path: String)
        case loadMore(path: String)
    }
    
    enum Mutation {
        case setFetching(Bool)
        case setItems([SearchItemReactor])
        case appendItems([SearchItemReactor])
    }
    
    struct State {
        var isFetching: Bool = false
        var items: [SearchItemReactor] = []
    }
    
    init(service: AppStoreServiceType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pull(var path):
            numberOfItems = 20
            path += "&limit=\(numberOfItems)"
            return Observable.concat([
                Observable.just(Mutation.setFetching(true)),

                service.appItems(path)
                    .do(onNext: { self.numberOfItems = $0.count })
                    .map { $0.map { SearchItemReactor(appItem: $0) } }
                    .map { Mutation.setItems($0) },
                    
                Observable.just(Mutation.setFetching(false))
            ])
        case .loadMore(var path):
            numberOfItems += 20
            path += "&limit=\(numberOfItems)"
            return service.appItems(path)
                .map { (appItems) -> [AppItem] in
                    let numberOfMoreItems = appItems.count
                    var items = appItems
                    items.removeSubrange(0 ..< self.numberOfItems)
                    self.numberOfItems = numberOfMoreItems
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
            return newState
        case let .appendItems(items):
            guard !items.isEmpty else {
                return state
            }
            var newState = state
            newState.items += items
            numberOfItems += 20
            return newState
        case let .setFetching(isFetching):
            var newState = state
            newState.isFetching = isFetching
            return newState
        }
    }
    
}
