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

final class KeywordListReactor: Reactor {
    let initialState = State()
    private let storage: KeywordStorageType
    
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
    
    init(storage: KeywordStorageType) {
        self.storage = storage
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadKeywords:
            return storage.fetchKeywords()
                .map { $0.map(KeywordItemReactor.init) }
                .map { Mutation.setKeywords($0) }
        case .select(let keywordItemReactor):
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

}
