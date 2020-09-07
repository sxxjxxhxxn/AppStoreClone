//
//  AppDIContainer.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    private lazy var appStoreService: AppStoreServiceType = {
        let iTunesSearchAPI = "https://itunes.apple.com/search?country=kr&entity=software&term="
        return ServiceProvider().makeAppStoreService(endPoint: iTunesSearchAPI)
    }()
    
    // MARK: - Storage
    private lazy var keywordStorage: KeywordStorageType = {
        StorageProvider().makeKeywordStorage()
    }()
    
    // MARK: - DIContainers of scenes
    func makeSearchSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer.Dependencies(appStoreService: appStoreService,
                                                         keywordStorage: keywordStorage)
        return SceneDIContainer(dependencies: dependencies)
    }
}
