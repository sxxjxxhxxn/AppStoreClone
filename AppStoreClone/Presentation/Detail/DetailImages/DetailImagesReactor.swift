//
//  DetailImagesReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class DetailImagesReactor: Reactor {
    var initialState: State
    
    typealias Action = NoAction
    
    struct State {
        let indexPath: IndexPath
        let screenshotURLs: [String]
    }
    
    init(indexPath: IndexPath, screenshotURLs: [String]) {
        initialState = State(indexPath: indexPath, screenshotURLs: screenshotURLs)
    }

}
