//
//  SearchFlowCoordinator.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import RxSwift

protocol SearchFlowCoordinatorDependencies {
    func makeSearchViewController(closures: SearchReactor.Closures) -> SearchViewController
    func makeKeywordListViewController(didSelect: @escaping KeywordListReactor.DidSelectClosure) -> KeywordListViewController
    func makeDetailViewController(appItem: AppItem, closure: DetailReactorClosure) -> DetailViewController
    func makeDetailImagesViewController(indexPath: IndexPath, screenshotUrls: [String]) -> DetailImagesViewController
}

final class SearchFlowCoordinator {
    
    private let navigationController: UINavigationController
    private let dependencies: SearchFlowCoordinatorDependencies

    private weak var searchVC: SearchViewController?
    private weak var keywordListVC: KeywordListViewController?

    init(navigationController: UINavigationController,
         dependencies: SearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let closures = SearchReactor.Closures(setKeywordListVisibility: setKeywordListVisibility,
                                             showDetail: showDetail,
                                             alertDisconnected: alertDisconnected)
        let vc = dependencies.makeSearchViewController(closures: closures)
        navigationController.pushViewController(vc, animated: false)
        searchVC = vc
    }

    private func setKeywordListVisibility(_ didSelect: @escaping (Keyword) -> Void) {
        guard let searchViewController = searchVC else { return }
        if keywordListVC == nil {
            let keywordListViewController = dependencies.makeKeywordListViewController(didSelect: didSelect)
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
        
        let closure = DetailReactorClosure(showDetailImages: showDetailImages)
        let detailVC = dependencies.makeDetailViewController(appItem: appItem, closure: closure)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func showDetailImages(indexPath: IndexPath, screenshotUrls: [String]) {
        let detailImagesVC = dependencies.makeDetailImagesViewController(indexPath: indexPath, screenshotUrls: screenshotUrls)
        let navigation = UINavigationController(rootViewController: detailImagesVC)
        navigation.modalPresentationStyle = .fullScreen
        navigationController.present(navigation, animated: true)
    }
}
