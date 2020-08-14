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
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
//    lazy var AppQueryStorage: AppQueryStorage = CoreDataAppQueryStorage(maxStorageLimit: 10)

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
                             closures: closures)
    }
    
    // MARK: - App Query List
//    func makeAppQueryListViewController(didSelect: @escaping AppQueryListReactorDidSelectClosure) -> UIViewController {
//        return AppQueryTableViewController.create(with: makeAppQueryListReactor(didSelect: didSelect))
//    }
//
//    func makeAppQueryListReactor(didSelect: @escaping AppQueryListReactorDidSelectClosure) -> AppQueryListReactor {
//        return AppQueryListReactor(numberOfQueriesToShow: 10,
//                                   fetchRecentAppQueryUseCaseFactory: makeFetchRecentAppQueryUseCase,
//                                   didSelect: didSelect)
//    }

    // MARK: - Flow Coordinators
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
        return SearchFlowCoordinator(navigationController: navigationController,
                                     dependencies: self)
    }
}

extension SearchSceneDIContainer: SearchFlowCoordinatorDependencies {}
