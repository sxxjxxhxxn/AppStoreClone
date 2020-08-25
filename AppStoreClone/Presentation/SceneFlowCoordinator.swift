//
//  SceneFlowCoordinator.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

protocol SceneFlowCoordinatorDependencies {
    func makeSearchViewController(closures: SearchReactorClosures) -> SearchViewController
    func makeKeywordListViewController() -> KeywordListViewController
}

class SceneFlowCoordinator {
    
    private let navigationController: UINavigationController
    private let dependencies: SceneFlowCoordinatorDependencies

    private weak var searchVC: SearchViewController?
    private weak var keywordListVC: KeywordListViewController?

    init(navigationController: UINavigationController,
         dependencies: SceneFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let closures = SearchReactorClosures(openKeywordList: openKeywordList,
                                             closeKeywordList: closeKeywordList)
        let vc = dependencies.makeSearchViewController(closures: closures)
        navigationController.pushViewController(vc, animated: false)
        searchVC = vc
    }

    private func openKeywordList() {
        guard let searchViewController = searchVC, keywordListVC == nil else { return }

        let vc = dependencies.makeKeywordListViewController()
        searchViewController.add(child: vc, container: searchViewController.keywordListContainer)
        keywordListVC = vc
    }

    private func closeKeywordList() {
        keywordListVC?.remove()
        keywordListVC = nil
    }
    
}
