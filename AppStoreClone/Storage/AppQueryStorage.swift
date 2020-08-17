//
//  UserDefaultAppQueryStorage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift

protocol AppQueryStorageType {
    func fetchQueries() -> Observable<[AppQuery]>
    func saveQuery(query: AppQuery)
}

final class AppQueryStorage: AppQueryStorageType {
    
    private let maxStorageLimit: Int
    private let storage: Storage

    init(maxStorageLimit: Int, storage: Storage) {
        self.maxStorageLimit = maxStorageLimit
        self.storage = storage
    }
    
    func fetchQueries() -> Observable<[AppQuery]> {
        return BehaviorSubject.init(value: storage.fetchMoviesQuries()).asObservable()
    }
    
    func saveQuery(query: AppQuery) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            var queries = self.storage.fetchMoviesQuries()
            queries = queries.filter { $0 != query }
            queries.insert(query, at: 0)
            self.storage.persist(appQuries: self.storage.removeOldQueries(queries, self.maxStorageLimit))
        }
    }
}

final class StorageProvider {
    public func makeAppQueryStorage(maxStorageLimit: Int) -> AppQueryStorageType {
        return AppQueryStorage(maxStorageLimit: maxStorageLimit, storage: Storage())
    }
}
