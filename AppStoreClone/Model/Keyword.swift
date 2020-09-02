//
//  Keyword.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

struct Keyword: Equatable, Codable {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
}
