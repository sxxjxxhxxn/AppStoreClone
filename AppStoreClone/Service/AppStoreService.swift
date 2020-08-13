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
    func appItems(_ path: String) -> Observable<[AppItem]>
}

final class AppStoreService: AppStoreServiceType {

    private let network: Network<AppItemResponse>

    init(network: Network<AppItemResponse>) {
        self.network = network
    }
    
    func appItems(_ query: String) -> Observable<[AppItem]> {
        network.getItem(query)
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
