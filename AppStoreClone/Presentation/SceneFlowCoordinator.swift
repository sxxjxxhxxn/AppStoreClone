//
//  SceneFlowCoordinator.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

protocol SceneFlowCoordinatorDependencies {
    func makeSearchViewController(closures: SearchReactor.Closures) -> SearchViewController
    func makeKeywordListViewController(didSelectKeyword: @escaping KeywordListReactor.DidSelectClosure) -> KeywordListViewController
    func makeDetailViewController(appItem: AppItem, closure: DetailReactor.Closure) -> DetailViewController
    func makeDetailImagesViewController(indexPath: IndexPath, screenshotURLs: [String]) -> DetailImagesViewController
}

final class SceneFlowCoordinator {
    
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
        let closures = SearchReactor.Closures(setKeywordListVisibility: setKeywordListVisibility,
                                              alertDisconnected: alertDisconnected,
                                              showDetail: showDetail)
        let vc = dependencies.makeSearchViewController(closures: closures)
        navigationController.pushViewController(vc, animated: false)
        searchVC = vc
    }

    private func setKeywordListVisibility(_ didSelectKeyword: @escaping (Keyword) -> Void) {
        guard let searchViewController = searchVC else { return }
        if keywordListVC == nil {
            let keywordListViewController = dependencies.makeKeywordListViewController(didSelectKeyword: didSelectKeyword)
            searchViewController.add(child: keywordListViewController, container: searchViewController.keywordListContainer)
            keywordListVC = keywordListViewController
        }
        
        searchViewController.keywordListContainer.isHidden.toggle()
        if !searchViewController.keywordListContainer.isHidden {
            keywordListVC?.loadKeywords()
        }
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
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = false
        }
        
        let closure = DetailReactor.Closure(showDetailImages: showDetailImages)
        let detailVC = dependencies.makeDetailViewController(appItem: appItem, closure: closure)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func showDetailImages(indexPath: IndexPath, screenshotURLs: [String]) {
        guard let detailVC = navigationController.topViewController as? DetailViewController else { return }
        
        let detailImagesVC = dependencies.makeDetailImagesViewController(indexPath: indexPath, screenshotURLs: screenshotURLs)
        let navigation = UINavigationController(rootViewController: detailImagesVC)
        navigation.modalPresentationStyle = .fullScreen
        navigation.transitioningDelegate = detailVC
        detailVC.present(navigation, animated: true)
    }
}
