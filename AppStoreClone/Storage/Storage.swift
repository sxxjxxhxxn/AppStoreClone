//
//  Storage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/16.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

final class Storage {
    
    private let recentsAppQueriesKey = "recentsAppQueries"
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func fetchMoviesQuries() -> [AppQuery] {
        if let queriesData = userDefaults.object(forKey: recentsAppQueriesKey) as? Data {
            if let appQueryList = try? JSONDecoder().decode([AppQuery].self, from: queriesData) {
                return appQueryList
            }
        }
        return []
    }

    func persist(appQuries: [AppQuery]) {
        if let encoded = try? JSONEncoder().encode(appQuries) {
            userDefaults.set(encoded, forKey: recentsAppQueriesKey)
        }
    }

    func removeOldQueries(_ queries: [AppQuery], _ maxStorageLimit: Int) -> [AppQuery] {
        return queries.count <= maxStorageLimit ? queries : Array(queries[0..<maxStorageLimit])
    }
}
