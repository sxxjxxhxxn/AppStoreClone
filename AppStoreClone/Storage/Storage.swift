//
//  Storage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/16.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift

@propertyWrapper
struct Storage {
    
    private let recentKeywordsKey = "recentKeywords"
    let maxStorageLimit: Int
    
    var wrappedValue: [Keyword] {
        get {
            if let keywordsData = UserDefaults.standard.object(forKey: recentKeywordsKey) as? Data {
                if let keywords = try? JSONDecoder().decode([Keyword].self, from: keywordsData) {
                    return keywords
                }
            }
            return []
        }
        set {
            let recentKeywords = removeOldKeywords(newValue, maxStorageLimit)
            if let encoded = try? JSONEncoder().encode(recentKeywords) {
                UserDefaults.standard.set(encoded, forKey: recentKeywordsKey)
            }
        }
    }

    private func removeOldKeywords(_ keywords: [Keyword], _ maxStorageLimit: Int) -> [Keyword] {
        return keywords.count <= maxStorageLimit ? keywords : Array(keywords[0..<maxStorageLimit])
    }
}
