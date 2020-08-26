//
//  AppFlowCoordinator.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

class AppFlowCoordinator {

    private var navigationController: UINavigationController
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
