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
        var isFetching: Bool = false
        var items: [SearchItemReactor] = []
        var queryListVisibility: Bool = false
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
            return Observable.concat([
                Observable.just(Mutation.setFetching(true)),

                service.loadItems(keyword)
                    .map { $0.map { SearchItemReactor(appItem: $0) } }
                    .map { Mutation.setItems($0) },
                    
                Observable.just(Mutation.setFetching(false))
            ])
        case .loadMore:
            return service.loadMoreItems()
                .map { $0.map { SearchItemReactor(appItem: $0) } }
                .map { Mutation.appendItems($0) }
        case .openQueryList:
            closures?.openAppQueryList(didSelect(keyword:))
            return .just(Mutation.setQueryListVisibility(true))
        case .closeQueryList:
            closures?.closeAppQueryList()
            return .just(Mutation.setQueryListVisibility(false))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setItems(items):
            newState.items = items
        case let .appendItems(items):
            guard items.isNotEmpty else {
                return state
            }
            newState.items += items
        case let .setFetching(isFetching):
            newState.isFetching = isFetching
        case let .setQueryListVisibility(visibility):
            newState.queryListVisibility = visibility
        }
        return newState
    }
    
    func didSelect(keyword: AppQuery) {
        selectedKeyword.onNext(keyword.query)
    }
    
}
