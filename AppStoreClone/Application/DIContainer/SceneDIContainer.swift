//
//  SearchSceneDIContainer.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

final class SceneDIContainer {
    
    struct Dependencies {
        let appStoreService: AppStoreServiceType
        let keywordStorage: KeywordStorageType
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Search List
    func makeSearchViewController(closures: SearchReactorClosures) -> SearchViewController {
        let searchVC = SearchViewController.init()
        searchVC.reactor = makeSearchReactor(closures: closures)
        return searchVC
    }
    
    func makeSearchReactor(closures: SearchReactorClosures) -> SearchReactor {
        return SearchReactor(service: dependencies.appStoreService,
                             storage: dependencies.keywordStorage,
                             closures: closures)
    }
    
    // MARK: - Keyword List
    func makeKeywordListViewController(didSelect: @escaping KeywordListReactorDidSelectClosure) -> KeywordListViewController {
        let keywordListVC = KeywordListViewController.init()
        keywordListVC.reactor = makeKeywordListReactor(didSelect: didSelect)
        return keywordListVC
    }

    func makeKeywordListReactor(didSelect: @escaping KeywordListReactorDidSelectClosure) -> KeywordListReactor {
        return KeywordListReactor(storage: dependencies.keywordStorage,
                                  didSelect: didSelect)
    }
    
    // MARK: - Flow Coordinators
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SceneFlowCoordinator {
        return SceneFlowCoordinator(navigationController: navigationController,
                                     dependencies: self)
    }
}

extension SceneDIContainer: SceneFlowCoordinatorDependencies {}
