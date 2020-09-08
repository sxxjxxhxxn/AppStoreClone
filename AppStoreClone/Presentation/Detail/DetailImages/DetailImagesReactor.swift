//
//  DetailImagesReactor.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/08.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import ReactorKit

final class DetailImagesReactor: Reactor {
    var initialState: State
    
    typealias Action = NoAction
    
    struct State {
        let indexPath: IndexPath
        let screenshotUrls: [String]
    }
    
    init(indexPath: IndexPath, screenshotUrls: [String]) {
        initialState = State(indexPath: indexPath, screenshotUrls: screenshotUrls)
    }

}
