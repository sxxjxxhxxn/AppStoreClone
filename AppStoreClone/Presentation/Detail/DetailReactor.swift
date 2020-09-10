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
    
    enum Action {
        case showDetailImages(indexPath: IndexPath, screenshotUrls: [String])
    }
    
    init(appItem: AppItem) {
        self.initialState = appItem
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case let .showDetailImages(_, _):
            return .empty()
        }
    }
}
