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
    let setKeywordListVisibility: (@escaping (Keyword) -> Void) -> Void
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
    
    deinit {
        selectedKeyword.onCompleted()
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
                                .just(.setFetching(true)),
                                loadItems,
                                .just(.setFetching(false))])
            }
        case .keywordListVisibility:
            closures?.setKeywordListVisibility(didSelectKeyword(keyword:))
            return .empty()
        case .cancel:
            latestKeyword = ""
            return .just(.clearItems)
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
    
    private func didSelectKeyword(keyword: Keyword) {
        selectedKeyword.onNext(keyword.text)
    }
    
}
