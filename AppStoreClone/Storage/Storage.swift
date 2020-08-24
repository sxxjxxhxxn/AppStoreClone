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

    func fetchRecentKeywords() -> [Keyword] {
        if let keywordsData = userDefaults.object(forKey: recentKeywordsKey) as? Data {
            if let keywords = try? JSONDecoder().decode([Keyword].self, from: keywordsData) {
                return keywords
            }
        }
        return []
    }

    func persist(keywords: [Keyword]) {
        if let encoded = try? JSONEncoder().encode(keywords) {
            userDefaults.set(encoded, forKey: recentKeywordsKey)
        }
    }

    func removeOldKeywords(_ keywords: [Keyword], _ maxStorageLimit: Int) -> [Keyword] {
        return keywords.count <= maxStorageLimit ? keywords : Array(keywords[0..<maxStorageLimit])
    }
}
