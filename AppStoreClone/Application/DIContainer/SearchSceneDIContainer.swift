//
//  SearchSceneDIContainer.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/13.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

final class SearchSceneDIContainer {
    
    struct Dependencies {
        let appStoreService: AppStoreServiceType
        let appQueryStorage: AppQueryStorageType
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Search List
    func makeSearchViewController(closures: SearchReactorClosures) -> SearchViewController {
        let searchVC = SearchViewController.instantiate()
        searchVC.reactor = makeSearchReactor(closures: closures)
        return searchVC
    }
    
    func makeSearchReactor(closures: SearchReactorClosures) -> SearchReactor {
        return SearchReactor(service: dependencies.appStoreService,
                             storage: dependencies.appQueryStorage,
                             closures: closures)
    }
    
    // MARK: - App Query List
    func makeQueryListViewController(didSelect: @escaping QueryListReactorDidSelectClosure) -> UIViewController {
        let queryListVC = QueryListViewController.instantiate()
        queryListVC.reactor = makeQueryListReactor(didSelect: didSelect)
        return queryListVC
    }

    func makeQueryListReactor(didSelect: @escaping QueryListReactorDidSelectClosure) -> QueryListReactor {
        return QueryListReactor(storage: dependencies.appQueryStorage,
                                didSelect: didSelect)
    }
    
    // MARK: - Detail Page
    func makeDetailViewController(appItem: AppItem) -> UIViewController {
        let detailVC = DetailViewController.instantiate()
        detailVC.reactor = makeDetailReactor(appItem: appItem)
        return detailVC
    }
    
    func makeDetailReactor(appItem: AppItem) -> DetailReactor {
        return DetailReactor(appItem: appItem)
    }

    // MARK: - Flow Coordinators
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
        return SearchFlowCoordinator(navigationController: navigationController,
                                     dependencies: self)
    }
}

extension SearchSceneDIContainer: SearchFlowCoordinatorDependencies {}
