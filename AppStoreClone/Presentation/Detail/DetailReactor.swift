//
//  DetailReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/21.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

struct DetailReactorClosure {
    let showDetailImages: (IndexPath, [String]) -> Void
}

final class DetailReactor: Reactor {
    let initialState: AppItem
    private let closure: DetailReactorClosure?
    
    enum Action {
        case showDetailImages(indexPath: IndexPath, screenshotUrls: [String])
    }
    
    init(appItem: AppItem,
         closure: DetailReactorClosure? = nil) {
        self.initialState = appItem
        self.closure = closure
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case let .showDetailImages(indexPath, screenshotUrls):
            closure?.showDetailImages(indexPath, screenshotUrls)
            return .empty()
        }
    }
}
