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
    private let didSelectKeyword: DidSelectClosure?
    
    enum Action {
        case loadKeywords
        case selectKeyword(keyword: Keyword)
    }
    
    enum Mutation {
        case setKeywords([Keyword])
    }
    
    struct State {
        var keywords: [Keyword] = []
    }
    
    init(storage: KeywordStorageType,
         didSelectKeyword: DidSelectClosure? = nil) {
        self.storage = storage
        self.didSelectKeyword = didSelectKeyword
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadKeywords:
            let keywords = storage.fetchKeywords()
            return .just(.setKeywords(keywords))
        case .selectKeyword(let keyword):
            didSelectKeyword(keyword)
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
    
    private func didSelectKeyword(_ keyword: Keyword) {
        didSelectKeyword?(keyword)
    }

}

extension KeywordListReactor {
    typealias DidSelectClosure = (Keyword) -> Void
}
