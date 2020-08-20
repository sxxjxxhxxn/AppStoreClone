//
//  NotEmpty.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/20.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

extension Array {
    var isNotEmpty: Bool { !self.isEmpty }
}

extension String {
    var isNotEmpty: Bool { !self.isEmpty }
}
