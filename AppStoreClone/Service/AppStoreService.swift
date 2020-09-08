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
    func loadItems(_ keyword: String) -> Observable<[AppItem]>
    func cancel()
}

final class AppStoreService: AppStoreServiceType {

    private let network: Network<AppItemResponse>
    private var cursor: Int = Constants.BASIC_NUMBER_OF_ITEMS
    private var latestKeyword: String?

    init(network: Network<AppItemResponse>) {
        self.network = network
    }
    
    func loadItems(_ keyword: String) -> Observable<[AppItem]> {
        guard let latestKeyword = latestKeyword,
            latestKeyword.elementsEqual(keyword) else {
                return network.getItem("\(keyword)&limit=\(Constants.BASIC_NUMBER_OF_ITEMS)")
                    .do(onNext: { [weak self] in
                        self?.cursor = $0?.resultCount ?? 0
                        self?.latestKeyword = keyword
                    })
                    .map { $0?.results ?? [] }
        }

        return network.getItem("\(keyword)&limit=\(cursor + Constants.BASIC_NUMBER_OF_ITEMS)")
            .map { [weak self] (response) -> [AppItem] in
                guard let self = self else { return [] }
                guard let results = response?.results, results.count > self.cursor else { return [] }

                return results
            }
            .map { [weak self] (appItems) -> [AppItem] in
                guard let self = self else { return [] }
                guard appItems.isNotEmpty else { return [] }

                var items = appItems
                items.removeSubrange(0 ..< self.cursor)
                self.cursor = appItems.count
                return items
        }
    }
    
    func cancel() {
        latestKeyword = nil
    }
}

final class ServiceProvider {
    func makeAppStoreService(endPoint: String) -> AppStoreServiceType {
        return AppStoreService(network: Network<AppItemResponse>(endPoint))
    }
}
