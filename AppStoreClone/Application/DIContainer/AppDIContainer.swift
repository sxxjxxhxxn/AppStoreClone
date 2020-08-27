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
    lazy var keywordStorage: KeywordStorageType = {
        let storage = Storage()
        return StorageProvider().makeKeywordStorage(maxStorageLimit: Constants.MAX_STORAGE_LIMIT)
    }()
    
    // MARK: - DIContainers of scenes
    func makeSearchSceneDIContainer() -> SearchSceneDIContainer {
        let dependencies = SearchSceneDIContainer.Dependencies(appStoreService: appStoreService,
                                                               keywordStorage: keywordStorage)
        return SearchSceneDIContainer(dependencies: dependencies)
    }
}
