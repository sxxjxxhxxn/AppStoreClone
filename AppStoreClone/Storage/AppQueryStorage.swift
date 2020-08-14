//
//  AppQueryStorage.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

protocol AppQueryStorage {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[AppQuery], Error>) -> Void)
    func saveRecentQuery(query: AppQuery, completion: @escaping (Result<AppQuery, Error>) -> Void)
}
