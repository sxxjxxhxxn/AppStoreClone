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
        layout.itemSize = CGSize(width: 294, height: 522)

        $0.setCollectionViewLayout(layout, animated: true)
        $0.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.reuseID)
        $0.backgroundColor = UIColor.clear
    }
    private var completeButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        completeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone(sender:)))
        navigationItem.rightBarButtonItem = completeButton
        makeConstrains()
    }

    func bind(reactor: DetailImagesReactor) {
        reactor.state
            .map { $0.screenshotUrls }
            .bind(to: collectionView.rx.items) { (collectionView, _, imageUrl) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(of: ScreenshotCollectionViewCell.self)
                cell.bind(imageUrl)
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayCell
            .take(1)
            .do(onNext: { _ in
                self.collectionView.scrollToItem(at: reactor.initialState.indexPath, at: .centeredHorizontally, animated: false)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    @objc func tapDone(sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func makeConstrains() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
