//
//  DetailImagesViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/08.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit

final class DetailImagesViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    private let collectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize(width: 196, height: 348)

        $0.setCollectionViewLayout(layout, animated: true)
        $0.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.reuseID)
        $0.backgroundColor = UIColor.clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstrains()
    }
    
    func bind(reactor: DetailImagesReactor) {
//        reactor.state
//        .bind
    }
    
    private func makeConstrains() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
