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
    let openAppQueryList: (@escaping (AppQuery) -> Void) -> Void
    let closeAppQueryList: () -> Void
    let alertDisconnected: () -> Void
}

final class SearchReactor: Reactor {
    let initialState = State()
    private let service: AppStoreServiceType
    private let storage: AppQueryStorageType
    private let closures: SearchReactorClosures?
    
    var selectedKeyword: PublishSubject<String>
    
    enum Action {
        case search(keyword: String)
        case loadMore
        case openSearchList
        case closeSearchList
        case disconnected
    }
    
    enum Mutation {
        case clearItems
        case setItems([SearchItemReactor])
        case setListVisibility(Bool)
        case setFetching(Bool)
    }
    
    struct State {
        var items: [SearchItemReactor] = []
        var listVisibility: Bool = false
        var isFetching: Bool = false
    }
    
    init(service: AppStoreServiceType,
         storage: AppQueryStorageType,
         closures: SearchReactorClosures? = nil) {
        self.service = service
        self.storage = storage
        self.closures = closures
        selectedKeyword = PublishSubject.init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let keyword):
            storage.saveQuery(query: AppQuery(query: keyword))
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
        case .openSearchList:
            closures?.openAppQueryList(didSelect(keyword:))
            return .just(.setListVisibility(true))
        case .closeSearchList:
            closures?.closeAppQueryList()
            return .just(.setListVisibility(false))
        case .disconnected:
            closures?.alertDisconnected()
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
        case let .setListVisibility(visibility):
            newState.listVisibility = visibility
        }
        return newState
    }
    
    func didSelect(keyword: AppQuery) {
        selectedKeyword.onNext(keyword.query)
    }
    
}
