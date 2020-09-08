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
    let initialState: [URL]
    
    typealias Action = NoAction
    
    init(screenshotUrl: [URL]) {
        self.initialState = screenshotUrl
    }

}
