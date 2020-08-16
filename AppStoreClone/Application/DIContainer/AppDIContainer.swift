//
//  AppDIContainer.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/13.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    lazy var appStoreService: AppStoreServiceType = {
        let iTunesSearchAPI = "https://itunes.apple.com/search?country=kr&entity=software&term="
        return ServiceProvider().makeAppStoreService(endPoint: iTunesSearchAPI)
    }()
    
    // MARK: - Storage
    lazy var appQueryStorage: AppQueryStorageType = {
        let storage = Storage()
        return StorageProvider().makeAppQueryStorage(maxStorageLimit: 10)
    }()
    
    // MARK: - DIContainers of scenes
    func makeSearchSceneDIContainer() -> SearchSceneDIContainer {
        let dependencies = SearchSceneDIContainer.Dependencies(appStoreService: appStoreService,
                                                               appQueryStorage: appQueryStorage)
        return SearchSceneDIContainer(dependencies: dependencies)
    }
}
