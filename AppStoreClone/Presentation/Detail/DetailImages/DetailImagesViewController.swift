//
//  DetailImagesViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

final class DetailImagesViewController: UIViewController, View {
    
    typealias Reactor = DetailImagesReactor
    var disposeBag = DisposeBag()
    private let collectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize(width: 294, height: 522)

        $0.setCollectionViewLayout(layout, animated: true)
        $0.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.reuseID)
        $0.backgroundColor = UIColor.clear
    }
    private var completeButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        completeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone(sender:)))
        navigationItem.rightBarButtonItem = completeButton
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func bind(reactor: Reactor) {
        reactor.state
            .map { $0.screenshotURLs }
            .bind(to: collectionView.rx.items) { (collectionView, _, imageUrl) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(of: ThumbnailCollectionViewCell.self)
                cell.bind(imageUrl)
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayCell
            .take(1)
            .subscribe({ [weak self] _ in
                self?.collectionView.scrollToItem(at: reactor.initialState.indexPath, at: .centeredHorizontally, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func tapDone(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
