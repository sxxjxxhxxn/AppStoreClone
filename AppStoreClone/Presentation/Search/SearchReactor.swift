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
        case testAction(path: String)
    }
    
    enum Mutation {
        case testItems([AppItem])
    }
    
    struct State {
        var items: [AppItem] = []
    }
    
    init(service: AppStoreServiceType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .testAction(let path):
            return service.appItems(path)
                .map { Mutation.testItems($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .testItems(items):
            print(items)
            var newState = state
            newState.items = items
            return newState
        }
    }
    
}
