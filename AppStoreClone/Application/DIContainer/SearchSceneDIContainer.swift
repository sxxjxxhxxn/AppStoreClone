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
        let keywordStorage: KeywordStorageType
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Search List
    func makeSearchViewController(closures: SearchReactorClosures) -> SearchViewController {
        let searchVC = SearchViewController()
        searchVC.reactor = makeSearchReactor(closures: closures)
        return searchVC
    }
    
    func makeSearchReactor(closures: SearchReactorClosures) -> SearchReactor {
        return SearchReactor(service: dependencies.appStoreService,
                             storage: dependencies.keywordStorage,
                             closures: closures)
    }
    
    // MARK: - Keyword List
    func makeKeywordListViewController(didSelect: @escaping KeywordListReactor.DidSelectClosure) -> KeywordListViewController {
        let keywordListVC = KeywordListViewController()
        keywordListVC.reactor = makeKeywordListReactor(didSelect: didSelect)
        return keywordListVC
    }

    func makeKeywordListReactor(didSelect: @escaping KeywordListReactor.DidSelectClosure) -> KeywordListReactor {
        return KeywordListReactor(storage: dependencies.keywordStorage,
                                  didSelectKeyword: didSelect)
    }
    
    // MARK: - Detail Page
    func makeDetailViewController(appItem: AppItem) -> DetailViewController {
        let detailVC = DetailViewController()
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
