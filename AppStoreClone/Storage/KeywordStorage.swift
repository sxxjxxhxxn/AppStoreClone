//
//  UserDefaultAppQueryStorage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift

protocol KeywordStorageType {
    func fetchKeywords() -> Observable<[Keyword]>
    func saveKeyword(keyword: Keyword)
}

final class KeywordStorage: KeywordStorageType {
    
    private let maxStorageLimit: Int
    private let storage: Storage

    init(maxStorageLimit: Int, storage: Storage) {
        self.maxStorageLimit = maxStorageLimit
        self.storage = storage
    }
    
    func fetchKeywords() -> Observable<[Keyword]> {
        return BehaviorSubject.init(value: storage.fetchRecentKeywords()).asObservable()
    }
    
    func saveKeyword(keyword: Keyword) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            var keywords = self.storage.fetchRecentKeywords()
            keywords = keywords.filter { $0 != keyword }
            keywords.insert(keyword, at: 0)
            self.storage.persist(keywords: self.storage.removeOldKeywords(keywords, self.maxStorageLimit))
        }
    }
}

final class StorageProvider {
    public func makeKeywordStorage(maxStorageLimit: Int) -> KeywordStorageType {
        return KeywordStorage(maxStorageLimit: maxStorageLimit, storage: Storage())
    }
}
