//
//  Storage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/16.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift

final class Storage {
    
    private let recentKeywordsKey = "recentKeywords"
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func fetch() -> [Keyword] {
        if let keywordsData = userDefaults.object(forKey: recentKeywordsKey) as? Data {
            if let keywords = try? JSONDecoder().decode([Keyword].self, from: keywordsData) {
                return keywords
            }
        }
        return []
    }

    func save(keywords: [Keyword], _ maxStorageLimit: Int) {
        let recentKeywords = removeOldKeywords(keywords, maxStorageLimit)
        if let encoded = try? JSONEncoder().encode(recentKeywords) {
            userDefaults.set(encoded, forKey: recentKeywordsKey)
        }
    }

    private func removeOldKeywords(_ keywords: [Keyword], _ maxStorageLimit: Int) -> [Keyword] {
        return keywords.count <= maxStorageLimit ? keywords : Array(keywords[0..<maxStorageLimit])
    }
}
