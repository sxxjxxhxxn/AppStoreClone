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
    func makeQueryListViewController() -> UIViewController
    //    func makeAppDetailsViewController
}

class SearchFlowCoordinator {
    
    private let navigationController: UINavigationController
    private let dependencies: SearchFlowCoordinatorDependencies

    private weak var searchVC: SearchViewController?
    private weak var queryListVC: UIViewController?

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

    private func openAppQueryList() {
        guard let searchViewController = searchVC, queryListVC == nil,
            let container = searchViewController.queryListContainer else { return }

        let vc = dependencies.makeQueryListViewController()
        searchViewController.add(child: vc, container: container)
        
        queryListVC = vc
//        container.isHidden = false
        
    }

    private func closeAppQueryList() {
        queryListVC?.remove()
        queryListVC = nil
//        searchVC?.queryListContainer.isHidden = true
    }
}
