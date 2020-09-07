//
//  AppStoreService.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift

protocol AppStoreServiceType {
    func loadItems(_ keyword: String, _ type: AppStoreService.Search) -> Observable<[AppItem]>
}

final class AppStoreService: AppStoreServiceType {

    private let network: Network<AppItemResponse>
    private var limit: Int = Constants.BASIC_NUMBER_OF_ITEMS

    init(network: Network<AppItemResponse>) {
        self.network = network
    }
    
    func loadItems(_ keyword: String, _ type: Search) -> Observable<[AppItem]> {
        switch type {
        case .loadMore:
            return network.getItem("\(keyword)&limit=\(limit+Constants.BASIC_NUMBER_OF_ITEMS)")
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
        case .loadFirst:
            limit = Constants.BASIC_NUMBER_OF_ITEMS
            return network.getItem("\(keyword)&limit=\(limit)")
                .do(onNext: { [weak self] in
                    self?.limit = $0?.resultCount ?? 0
                })
                .map { $0?.results ?? [] }
        }
    }
}

extension AppStoreService {
    enum Search {
        case loadFirst
        case loadMore
    }
}

final class ServiceProvider {
    func makeAppStoreService(endPoint: String) -> AppStoreServiceType {
        return AppStoreService(network: Network<AppItemResponse>(endPoint))
    }
}
