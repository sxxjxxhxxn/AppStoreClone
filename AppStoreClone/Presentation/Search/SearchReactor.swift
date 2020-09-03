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
    let setKeywordListVisibility: (@escaping (Keyword) -> Void) -> Void
    let showDetail: (AppItem) -> Void
    let alertDisconnected: () -> Void
}

final class SearchReactor: Reactor {
    let initialState = State()
    private let service: AppStoreServiceType
    private let storage: KeywordStorageType
    private let closures: SearchReactorClosures?
    let selectedKeyword: PublishSubject<String>
    
    enum Action {
        case search(keyword: String)
        case loadMore
        case keywordListVisibility
        case cancel
        case disconnected
        case showDetail(appItem: AppItem)
    }
    
    enum Mutation {
        case clearItems
        case setItems([SearchItemReactor])
        case setFetching(Bool)
    }
    
    struct State {
        var items: [SearchItemReactor] = []
        var isFetching: Bool = false
    }
    
    init(service: AppStoreServiceType,
         storage: KeywordStorageType,
         closures: SearchReactorClosures? = nil) {
        self.service = service
        self.storage = storage
        self.closures = closures
        selectedKeyword = PublishSubject.init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let keyword):
            storage.saveKeyword(keyword: Keyword(keyword))
            return .concat([
                .just(.clearItems),
                .just(.setFetching(true)),
                service.loadItems(keyword)
                    .map { $0.map(SearchItemReactor.init) }
                    .map { .setItems($0) },
                .just(.setFetching(false))
            ])
        case .loadMore:
            return service.loadMoreItems()
                .filter { $0.isNotEmpty }
                .map { $0.map(SearchItemReactor.init) }
                .map { .setItems($0) }
        case .keywordListVisibility:
            closures?.setKeywordListVisibility(didSelect(keyword:))
            return .empty()
        case .cancel:
            service.cancel()
            return .just(.clearItems)
        case .disconnected:
            closures?.alertDisconnected()
            return .empty()
        case .showDetail(let appItem):
            closures?.showDetail(appItem)
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
        case let .setFetching(isFetching):
            newState.isFetching = isFetching
        }
        return newState
    }
    
    private func didSelect(keyword: Keyword) {
        selectedKeyword.onNext(keyword.text)
    }
    
}
