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
    func makeKeywordListViewController(didSelectKeyword: @escaping KeywordListReactor.DidSelectClosure) -> KeywordListViewController
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
        let closures = SearchReactorClosures(setKeywordListVisibility: setKeywordListVisibility)
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
    
}
