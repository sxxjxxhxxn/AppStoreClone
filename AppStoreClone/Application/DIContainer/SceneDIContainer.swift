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
    func makeSearchViewController(closures: SearchReactor.Closures) -> SearchViewController {
        let searchVC = SearchViewController.init()
        searchVC.reactor = makeSearchReactor(closures: closures)
        return searchVC
    }
    
    func makeSearchReactor(closures: SearchReactor.Closures) -> SearchReactor {
        return SearchReactor(service: dependencies.appStoreService,
                             storage: dependencies.keywordStorage,
                             closures: closures)
    }
    
    // MARK: - Keyword List
    func makeKeywordListViewController(didSelectKeyword: @escaping KeywordListReactor.DidSelectClosure) -> KeywordListViewController {
        let keywordListVC = KeywordListViewController.init()
        keywordListVC.reactor = makeKeywordListReactor(didSelectKeyword: didSelectKeyword)
        return keywordListVC
    }

    func makeKeywordListReactor(didSelectKeyword: @escaping KeywordListReactor.DidSelectClosure) -> KeywordListReactor {
        return KeywordListReactor(storage: dependencies.keywordStorage,
                                  didSelectKeyword: didSelectKeyword)
    }
    
    // MARK: - Detail Page
    func makeDetailViewController(appItem: AppItem, closure: DetailReactor.Closure) -> DetailViewController {
        let detailVC = DetailViewController()
        detailVC.reactor = makeDetailReactor(appItem: appItem, closure: closure)
        return detailVC
    }
    
    func makeDetailReactor(appItem: AppItem, closure: DetailReactor.Closure) -> DetailReactor {
        return DetailReactor(appItem: appItem, closure: closure)
    }
    
    // MARK: - Detail Images Page
    func makeDetailImagesViewController(indexPath: IndexPath, screenshotUrls: [String]) -> DetailImagesViewController {
        let detailImagesVC = DetailImagesViewController()
        detailImagesVC.reactor = makeDetailImagesReactor(indexPath: indexPath, screenshotUrls: screenshotUrls)
        return detailImagesVC
    }
    
    func makeDetailImagesReactor(indexPath: IndexPath, screenshotUrls: [String]) -> DetailImagesReactor {
        return DetailImagesReactor(indexPath: indexPath, screenshotUrls: screenshotUrls)
    }
    
    // MARK: - Flow Coordinators
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SceneFlowCoordinator {
        return SceneFlowCoordinator(navigationController: navigationController,
                                     dependencies: self)
    }
}

extension SceneDIContainer: SceneFlowCoordinatorDependencies {}
