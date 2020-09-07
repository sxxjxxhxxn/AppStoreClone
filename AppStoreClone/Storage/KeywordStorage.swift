//
//  KeywordStorage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/02.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift

protocol KeywordStorageType {
    func fetchKeywords() -> [Keyword]
    func saveKeyword(keyword: Keyword)
}

final class KeywordStorage: KeywordStorageType {
    
    @Storage(maxStorageLimit: Constants.MAX_STORAGE_LIMIT) private var storage: [Keyword]

    func fetchKeywords() -> [Keyword] {
        storage
    }
    
    func saveKeyword(keyword: Keyword) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            var keywords = self.storage.filter { $0 != keyword }
            keywords.insert(keyword, at: 0)
            self.storage = keywords
        }
    }
}

final class StorageProvider {
    func makeKeywordStorage() -> KeywordStorageType {
        return KeywordStorage()
    }
}
