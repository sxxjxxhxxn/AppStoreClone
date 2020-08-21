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
    func makeQueryListViewController(didSelect: @escaping QueryListReactorDidSelectClosure) -> UIViewController
    func makeDetailViewController(appItem: AppItem) -> UIViewController
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
        let closures = SearchReactorClosures(showDetail: showDetail,
                                             openAppQueryList: openAppQueryList,
                                             closeAppQueryList: closeAppQueryList,
                                             alertDisconnected: alertDisconnected)
        let vc = dependencies.makeSearchViewController(closures: closures)
        navigationController.pushViewController(vc, animated: false)
        searchVC = vc
    }

    private func openAppQueryList(_ didSelect: @escaping (AppQuery) -> Void) {
        guard let searchViewController = searchVC, queryListVC == nil,
            let container = searchViewController.queryListContainer else { return }

        let vc = dependencies.makeQueryListViewController(didSelect: didSelect)
        searchViewController.add(child: vc, container: container)
        queryListVC = vc
    }

    private func closeAppQueryList() {
        queryListVC?.remove()
        queryListVC = nil
    }
    
    private func alertDisconnected() {
        let alert: UIAlertController = UIAlertController(title: "Network error",
                                                         message: "Disconnected",
                                                         preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "확인",
                                                       style: .default)
        alert.addAction(alertAction)
        navigationController.pushViewController(alert, animated: true)
    }
    
    private func showDetail(appItem: AppItem) {
        let detailVC = dependencies.makeDetailViewController(appItem: appItem)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
