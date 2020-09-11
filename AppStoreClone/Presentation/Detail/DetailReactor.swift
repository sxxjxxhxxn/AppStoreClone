//
//  DetailReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

final class DetailReactor: Reactor {
    let initialState: AppItem
    private let closure: Closure?
    
    enum Action {
        case showDetailImages(indexPath: IndexPath, screenshotURLs: [String])
    }
    
    init(appItem: AppItem,
         closure: Closure? = nil) {
        self.initialState = appItem
        self.closure = closure
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case let .showDetailImages(indexPath, screenshotURLs):
            closure?.showDetailImages(indexPath, screenshotURLs)
            return .empty()
        }
    }
}

extension DetailReactor {
    struct Closure {
        let showDetailImages: (IndexPath, [String]) -> Void
    }
}
