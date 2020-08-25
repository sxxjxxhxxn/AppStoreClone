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
    let openKeywordList: () -> Void
    let closeKeywordList: () -> Void
}

final class SearchReactor: Reactor {
    let initialState = State()
    private let service: AppStoreServiceType
    private let closures: SearchReactorClosures?
    
    enum Action {
        case search(keyword: String)
        case loadMore
        case openSearchList
        case closeSearchList
    }
    
    enum Mutation {
        case clearItems
        case setItems([SearchItemReactor])
        case setListVisibility(Bool)
    }
    
    struct State {
        var items: [SearchItemReactor] = []
        var listVisibility: Bool = false
    }
    
    init(service: AppStoreServiceType,
         closures: SearchReactorClosures? = nil) {
        self.service = service
        self.closures = closures
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let keyword):
            return .concat([
                .just(Mutation.clearItems),
                service.loadItems(keyword)
                    .map { $0.map(SearchItemReactor.init) }
                    .map { Mutation.setItems($0) }
            ])
        case .loadMore:
            return service.loadMoreItems()
                .filter { $0.isNotEmpty }
                .map { $0.map(SearchItemReactor.init) }
                .map { Mutation.setItems($0) }
        case .openSearchList:
            closures?.openKeywordList()
            return .just(.setListVisibility(true))
        case .closeSearchList:
            closures?.closeKeywordList()
            return .just(.setListVisibility(false))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .clearItems:
            newState.items.removeAll()
        case let .setItems(items):
            newState.items += items
        case let .setListVisibility(visibility):
            newState.listVisibility = visibility
        }
        return newState
    }
    
}
