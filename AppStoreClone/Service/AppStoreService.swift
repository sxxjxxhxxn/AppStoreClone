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
    func appItems(_ keyword: String, _ limit: Int) -> Observable<[AppItem]>
}

extension AppStoreServiceType {
    func appItems(_ keyword: String, _ limit: Int = 20) -> Observable<[AppItem]> {
        appItems(keyword, limit)
    }
}

final class AppStoreService: AppStoreServiceType {

    private let network: Network<AppItemResponse>

    init(network: Network<AppItemResponse>) {
        self.network = network
    }
    
    func appItems(_ keyword: String, _ limit: Int) -> Observable<[AppItem]> {
        network.getItem("\(keyword)&limit=\(limit)")
            .map { (response) -> [AppItem] in
                print("응답: \(response?.resultCount ?? -1)개")
                return response?.results ?? []
            }
    }
}

final class ServiceProvider {
    public func makeAppStoreService(endPoint: String) -> AppStoreServiceType {
        return AppStoreService(network: Network<AppItemResponse>(endPoint))
    }
}
