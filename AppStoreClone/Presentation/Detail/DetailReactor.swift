//
//  DetailReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/21.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

struct DetailReactorClosures {
    let showDetail: (IndexPath) -> Void
}

final class DetailReactor: Reactor {
    let initialState: AppItem
    private let closures: DetailReactorClosures?
    
    enum Action {
        case showDetailImages(indexPath: IndexPath)
    }
    
    init(appItem: AppItem,
         closures: DetailReactorClosures? = nil) {
        self.initialState = appItem
        self.closures = closures
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .showDetailImages(let indexPath):
            closures?.showDetail(indexPath)
            return .empty()
        }
    }
}
