//
//  AppStoreService.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift

public protocol AppStoreServiceType {
    func loadItems(_ keyword: String) -> Observable<[AppItem]>
    func loadMoreItems() -> Observable<[AppItem]>
}

final class AppStoreService: AppStoreServiceType {

    private let network: Network<AppItemResponse>
    var recentKeyword: String = ""
    var limit: Int = 20

    init(network: Network<AppItemResponse>) {
        self.network = network
    }
    
    func loadItems(_ keyword: String) -> Observable<[AppItem]> {
        recentKeyword = keyword
        limit = 20
        return network.getItem("\(keyword)&limit=\(limit)")
            .map { [weak self] (response) -> [AppItem] in
                self?.limit = response?.resultCount ?? 0
                return response?.results ?? []
            }
    }
    
    func loadMoreItems() -> Observable<[AppItem]> {
        return network.getItem("\(recentKeyword)&limit=\(limit+20)")
            .map { [weak self] (response) -> [AppItem] in
                guard let self = self else { return [] }
                guard let results = response?.results, results.count > self.limit else { return [] }
                
                return results
            }
            .map { [weak self] (appItems) -> [AppItem] in
                guard let self = self else { return [] }
                guard appItems.isNotEmpty else { return [] }
            
                var items = appItems
                items.removeSubrange(0 ..< self.limit)
                self.limit = appItems.count
                return items
            }
    }
}

final class ServiceProvider {
    public func makeAppStoreService(endPoint: String) -> AppStoreServiceType {
        return AppStoreService(network: Network<AppItemResponse>(endPoint))
    }
}
