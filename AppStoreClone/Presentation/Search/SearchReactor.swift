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
    private var latestKeyword = ""
    let selectedKeyword: PublishSubject<String> = PublishSubject<String>()
    
    enum Action {
        case loadItems(keyword: String)
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
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadItems(let keyword):
            let loadItems = service.loadItems(keyword)
                .filter { $0.isNotEmpty }
                .map { $0.map(SearchItemReactor.init) }
                .map { Mutation.setItems($0) }
            switch keyword {
            case latestKeyword:
                return loadItems
            default:
                latestKeyword = keyword
                storage.saveKeyword(keyword: Keyword(keyword))
                return .concat([.just(Mutation.clearItems),
                                loadItems])
            }
        case .keywordListVisibility:
            closures?.setKeywordListVisibility(didSelect(keyword:))
            return .empty()
        case .cancel:
            latestKeyword = ""
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
