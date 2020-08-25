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
    func makeKeywordListViewController(didSelect: @escaping KeywordListReactorDidSelectClosure) -> UIViewController
    func makeDetailViewController(appItem: AppItem) -> DetailViewController
}

class SearchFlowCoordinator {
    
    private let navigationController: UINavigationController
    private let dependencies: SearchFlowCoordinatorDependencies

    private weak var searchVC: SearchViewController?
    private weak var keywordListVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: SearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let closures = SearchReactorClosures(showDetail: showDetail,
                                             openKeywordList: openKeywordList,
                                             closeKeywordList: closeKeywordList,
                                             alertDisconnected: alertDisconnected)
        let vc = dependencies.makeSearchViewController(closures: closures)
        navigationController.pushViewController(vc, animated: false)
        searchVC = vc
    }

    private func openKeywordList(_ didSelect: @escaping (Keyword) -> Void) {
        guard let searchViewController = searchVC, keywordListVC == nil else { return }

        let vc = dependencies.makeKeywordListViewController(didSelect: didSelect)
        searchViewController.add(child: vc, container: searchViewController.keywordListContainer)
        keywordListVC = vc
    }

    private func closeKeywordList() {
        keywordListVC?.remove()
        keywordListVC = nil
    }
    
    private func alertDisconnected() {
        let alert: UIAlertController = UIAlertController(title: "Network error",
                                                         message: "Disconnected",
                                                         preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "확인",
                                                       style: .default)
        alert.addAction(alertAction)
        navigationController.present(alert, animated: true)
    }
    
    private func showDetail(appItem: AppItem) {
        let detailVC = dependencies.makeDetailViewController(appItem: appItem)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
