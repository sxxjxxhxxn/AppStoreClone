//
//  AppFlowCoordinator.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/13.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

final class AppFlowCoordinator {

    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let searchSceneDIContainer = appDIContainer.makeSearchSceneDIContainer()
        let flow = searchSceneDIContainer.makeSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
