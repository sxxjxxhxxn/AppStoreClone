//
//  Reusable.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/11.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseID: String { get }
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}

extension UIViewController: Reusable {}

extension UICollectionViewCell: Reusable {}

extension UITableView {
    func dequeueReusableCell<T>(of cellType: T.Type = T.self) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID) as? T else {
            fatalError("dequeueReusableCell fatalError - cell of \(cellType)")
        }
        return cell
    }
}

extension UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: self.reuseID, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: self.reuseID) as? Self else {
            fatalError("instantiate fatalError - \(self.reuseID) could not be instantiate")
        }
        return viewController
    }
}

extension UICollectionView {
    func dequeueReusableCell<T>(of cellType: T.Type = T.self) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: IndexPath()) as? T else {
            fatalError("dequeueReusableCell fatalError - cell of \(cellType)")
        }
        return cell
    }
}
