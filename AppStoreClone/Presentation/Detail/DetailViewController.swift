//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/21.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import Then
import Cosmos

class DetailViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    var scrollView = UIScrollView().then {
//        $0.showsHorizontalScrollIndicator = false
//        $0.showsVerticalScrollIndicator = true
        $0.isScrollEnabled = true
    }
    var contentView = UIView()
    var artWorkImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    var nameLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 21.0)
    }
    var genreLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
    }
    var infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    var userRatingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    var userRatingBar = CosmosView().then {
        $0.settings.textFont = UIFont.boldSystemFont(ofSize: 21)
        $0.settings.textColor = UIColor.lightGray
        $0.settings.starMargin = 1
        $0.settings.starSize = 21.0
        $0.settings.filledBorderColor = UIColor.lightGray
        $0.settings.emptyBorderColor = UIColor.lightGray
        $0.settings.filledColor = UIColor.lightGray
        $0.isUserInteractionEnabled = false
    }
    var userRatingSubLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
    }
    var priceStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .trailing
    }
    var priceLabel = UILabel().then {
        $0.textColor = UIColor.lightGray
        $0.font = UIFont.boldSystemFont(ofSize: 21.0)
    }
    var priceSubLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
    }
    var contentRatingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .trailing
    }
    var contentRatingLabel = UILabel().then {
        $0.textColor = UIColor.lightGray
        $0.font = UIFont.boldSystemFont(ofSize: 21.0)
    }
    var contentRatingSubLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
    }
    var screenshotView = UIView()
    var screenShotCollectionView = UICollectionView(frame: CGRect.zero,
                                                    collectionViewLayout: UICollectionViewFlowLayout.init()).then {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize(width: 196, height: 348)

        $0.setCollectionViewLayout(layout, animated: true)
        $0.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.reuseID)
        $0.backgroundColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(artWorkImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(infoStackView)
        contentView.addSubview(screenshotView)
        screenshotView.addSubview(screenShotCollectionView)
        
        infoStackView.addArrangedSubview(userRatingStackView)
        infoStackView.addArrangedSubview(priceStackView)
        infoStackView.addArrangedSubview(contentRatingStackView)
        userRatingStackView.addArrangedSubview(userRatingBar)
        userRatingStackView.addArrangedSubview(userRatingSubLabel)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceSubLabel)
        contentRatingStackView.addArrangedSubview(contentRatingLabel)
        contentRatingStackView.addArrangedSubview(contentRatingSubLabel)
        
        setConstraints()
    }
    
    func bind(reactor: DetailReactor) {
        let appItem = reactor.initialState
        
        DispatchQueue.global(qos: .background).async {
            if let artWorkUrl = URL(string: appItem.artworkUrl512) {
                if let artWorkData = try? Data(contentsOf: artWorkUrl) {
                    DispatchQueue.main.async {
                        self.artWorkImageView.image = UIImage(data: artWorkData)
                    }
                }
            }
        }
        nameLabel.text = appItem.trackName
        genreLabel.text = appItem.genres.joined(separator: ", ")
        userRatingBar.rating = appItem.averageUserRating
        userRatingBar.text = appItem.userRatingCount == 0 ? "" : "\(round(appItem.averageUserRating*10)/10)"
        userRatingSubLabel.text = appItem.userRatingCount == 0 ? "평가 부족" : "\(round(appItem.userRatingCount/100)/10)천개의 평가"
        priceLabel.text = "$\(appItem.price ?? 0.0)"
        priceSubLabel.text = appItem.formattedPrice
        contentRatingLabel.text = appItem.trackContentRating
        contentRatingSubLabel.text = "연령"
        
        reactor.state
            .map { $0.screenshotUrls }
            .bind(to: screenShotCollectionView.rx.items) { (collectionView, _, imageUrl) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(of: ScreenshotCollectionViewCell.self)
                cell.bind(imageUrl)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width)
//            make.height.equalTo(UIScreen.main.bounds.height + 100)
        }
        artWorkImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 120, height: 120))
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artWorkImageView.snp.top).offset(10)
            make.left.equalTo(artWorkImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-16)
        }
        genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameLabel.snp.right)
        }
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(artWorkImageView.snp.bottom).offset(20)
            make.left.equalTo(artWorkImageView.snp.left)
            make.right.equalTo(genreLabel.snp.right)
        }
        screenshotView.snp.makeConstraints { (make) in
            make.top.equalTo(infoStackView.snp.bottom).offset(10)
            make.left.equalTo(infoStackView.snp.left)
            make.right.equalTo(infoStackView.snp.right)
            make.height.equalTo(348)
            make.bottom.equalToSuperview()
        }
        screenShotCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}
