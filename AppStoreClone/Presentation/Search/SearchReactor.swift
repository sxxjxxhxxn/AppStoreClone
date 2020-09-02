//
//  SearchReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

struct SearchReactorClosures {
    let setKeywordListVisibility: () -> Void
}

final class SearchReactor: Reactor {
    let initialState = State()
    private let service: AppStoreServiceType
    private let storage: KeywordStorageType
    private let closures: SearchReactorClosures?
    
    enum Action {
        case search(keyword: String)
        case loadMore
        case keywordListVisibility
    }
    
    enum Mutation {
        case clearItems
        case setItems([SearchItemReactor])
    }
    
    struct State {
        var items: [SearchItemReactor] = []
    }
    
    init(service: AppStoreServiceType,
         storage: KeywordStorageType,
         closures: SearchReactorClosures? = nil) {
        self.service = service
        self.storage = storage
        self.closures = closures
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let keyword):
            storage.saveKeyword(keyword: Keyword(keyword))
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
        case .keywordListVisibility:
            closures?.setKeywordListVisibility()
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .clearItems:
            newState.items.removeAll()
        case let .setItems(items):
            newState.items += items
        }
        return newState
    }
    
}
