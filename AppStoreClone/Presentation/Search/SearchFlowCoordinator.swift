//
//  SearchFlowCoordinator.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

protocol SearchFlowCoordinatorDependencies {
    func makeSearchViewController(closures: SearchReactorClosures) -> SearchViewController
//    func makeAppDetailsViewController
//    func makeAppQueryListViewController
}

class SearchFlowCoordinator {
    
    private let navigationController: UINavigationController
    private let dependencies: SearchFlowCoordinatorDependencies

    private weak var searchVC: SearchViewController?
    private weak var appQueryListVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: SearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let closures = SearchReactorClosures(showAppDetails: showAppDetails,
                                             openAppQueryList: openAppQueryList,
                                             closeAppQueryList: closeAppQueryList)
        let vc = dependencies.makeSearchViewController(closures: closures)
        
        navigationController.pushViewController(vc, animated: false)
        searchVC = vc
    }

    private func showAppDetails(appItem: AppItem) {
    }

    private func openAppQueryList(didSelect: @escaping (AppQuery) -> Void) {
    }

    private func closeAppQueryList() {
    }
}
