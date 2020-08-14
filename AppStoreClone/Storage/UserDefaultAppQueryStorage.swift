//
//  UserDefaultAppQueryStorage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

final class UserDefaultAppQueryStorage {
    private let maxStorageLimit: Int
    private let recentsAppQueriesKey = "recentsAppQueries"
    private var userDefaults: UserDefaults
    
    init(maxStorageLimit: Int, userDefaults: UserDefaults = UserDefaults.standard) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
    }

    private func fetchMoviesQuries() -> [AppQuery] {
        if let queriesData = userDefaults.object(forKey: recentsAppQueriesKey) as? Data {
            if let appQueryList = try? JSONDecoder().decode([AppQuery].self, from: queriesData) {
                return appQueryList
            }
        }
        return []
    }

    private func persist(appQuries: [AppQuery]) {
        if let encoded = try? JSONEncoder().encode(appQuries) {
            userDefaults.set(encoded, forKey: recentsAppQueriesKey)
        }
    }

    private func removeOldQueries(_ queries: [AppQuery]) -> [AppQuery] {
        return queries.count <= maxStorageLimit ? queries : Array(queries[0..<maxStorageLimit])
    }
}

extension UserDefaultAppQueryStorage: AppQueryStorage {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[AppQuery], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            var queries = self.fetchMoviesQuries()
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }
    func saveRecentQuery(query: AppQuery, completion: @escaping (Result<AppQuery, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            var queries = self.fetchMoviesQuries()
            queries = queries.filter { $0 != query }
            queries.insert(query, at: 0)
            self.persist(appQuries: self.removeOldQueries(queries))
            completion(.success(query))
        }
    }
}
