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
}

class SceneFlowCoordinator {
    
    private let navigationController: UINavigationController
    private let dependencies: SceneFlowCoordinatorDependencies

    private weak var searchVC: SearchViewController?
    private weak var keywordListVC: UIViewController?

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
        // TODO: open KeywordListVC
    }

    private func closeKeywordList() {
        // TODO: close KeywordListVC
    }
    
}
