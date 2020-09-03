//
//  KeywordListReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

typealias KeywordListReactorDidSelectClosure = (Keyword) -> Void

final class KeywordListReactor: Reactor {
    let initialState = State()
    private let storage: KeywordStorageType
    private let didSelect: KeywordListReactorDidSelectClosure?
    
    enum Action {
        case loadKeywords
        case select(keyword: KeywordItemReactor)
    }
    
    enum Mutation {
        case setKeywords([KeywordItemReactor])
    }
    
    struct State {
        var keywords: [KeywordItemReactor] = []
    }
    
    init(storage: KeywordStorageType,
         didSelect: KeywordListReactorDidSelectClosure? = nil) {
        self.storage = storage
        self.didSelect = didSelect
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadKeywords:
            let keyword = storage.fetchKeywords().map { KeywordItemReactor(keyword: $0) }
            return .just(.setKeywords(keyword))
        case .select(let keywordItemReactor):
            didSelect(keywordItemReactor)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setKeywords(keywords):
            newState.keywords = keywords
        }
        return newState
    }
    
    private func didSelect(_ item: KeywordItemReactor) {
        didSelect?(Keyword(item.initialState.text))
    }

}
