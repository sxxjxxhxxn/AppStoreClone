//
//  SearchReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class SearchReactor: Reactor {
    let initialState = State()
    private let service: AppStoreServiceType
    
    enum Action {
        case search(query: String)
    }
    
    enum Mutation {
        case setItems([SearchItemReactor])
    }
    
    struct State {
        let title = "검색"
        var items: [SearchItemReactor] = []
    }
    
    init(service: AppStoreServiceType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let query):
            return service.appItems(query)
                .map { $0.map { SearchItemReactor(appItem: $0) } }
                .map { Mutation.setItems($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setItems(items):
            var newState = state
            newState.items = items
            return newState
        }
    }
    
}
