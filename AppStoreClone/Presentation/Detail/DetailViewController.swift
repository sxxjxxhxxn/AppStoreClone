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
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    var contentView = UIView()
    var artWorkImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
    }
    var nameLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 21.0)
    }
    var artistNameLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 16.0)
    }
    var sellerButton = UIButton().then {
        $0.backgroundColor = UIColor.lightGray
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("열기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        $0.layer.cornerRadius = 16
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
        $0.settings.textColor = UIColor.darkGray
        $0.settings.starMargin = 1
        $0.settings.starSize = 21.0
        $0.settings.filledBorderColor = UIColor.darkGray
        $0.settings.emptyBorderColor = UIColor.darkGray
        $0.settings.filledColor = UIColor.darkGray
        $0.isUserInteractionEnabled = false
    }
    var userRatingSubLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 14.0)
    }
    var priceGenreStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
    }
    var priceLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 21.0)
    }
    var genreLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 14.0)
        $0.adjustsFontSizeToFitWidth = true
    }
    var contentRatingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .trailing
    }
    var contentRatingLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 21.0)
    }
    var contentRatingSubLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 14.0)
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
    var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(artWorkImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(sellerButton)
        contentView.addSubview(infoStackView)
        contentView.addSubview(screenshotView)
        screenshotView.addSubview(screenShotCollectionView)
        contentView.addSubview(descriptionLabel)
        
        infoStackView.addArrangedSubview(userRatingStackView)
        infoStackView.addArrangedSubview(priceGenreStackView)
        infoStackView.addArrangedSubview(contentRatingStackView)
        userRatingStackView.addArrangedSubview(userRatingBar)
        userRatingStackView.addArrangedSubview(userRatingSubLabel)
        priceGenreStackView.addArrangedSubview(priceLabel)
        priceGenreStackView.addArrangedSubview(genreLabel)
        contentRatingStackView.addArrangedSubview(contentRatingLabel)
        contentRatingStackView.addArrangedSubview(contentRatingSubLabel)
        
        setConstraints()
    }
    
    func bind(reactor: DetailReactor) {
        let appItem = reactor.initialState
        
        DispatchQueue.global(qos: .background).async {
            if let artWorkUrl = URL(string: appItem.artworkUrl512), let artWorkData = try? Data(contentsOf: artWorkUrl) {
                DispatchQueue.main.async {
                    self.artWorkImageView.image = UIImage(data: artWorkData)
                }
            }
        }
        nameLabel.text = appItem.trackName
        artistNameLabel.text = appItem.artistName
        userRatingBar.rating = appItem.averageUserRating
        userRatingBar.text = appItem.userRatingCount == 0 ? "" : "\(round(appItem.averageUserRating*10)/10)"
        userRatingSubLabel.text = appItem.userRatingCount == 0 ? "평가 부족" : "\(round(appItem.userRatingCount/100)/10)천개의 평가"
        priceLabel.text = appItem.formattedPrice
        genreLabel.text = (appItem.genres.count<4 ? appItem.genres : appItem.genres.dropLast(2)).joined(separator: ", ")
        contentRatingLabel.text = appItem.trackContentRating
        contentRatingSubLabel.text = "연령"
        descriptionLabel.text = appItem.description
        
        reactor.state
            .map { $0.screenshotUrls }
            .bind(to: screenShotCollectionView.rx.items) { (collectionView, _, imageUrl) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(of: ScreenshotCollectionViewCell.self)
                cell.bind(imageUrl)
                return cell
            }
            .disposed(by: disposeBag)
        
        sellerButton.rx
            .tap
            .subscribe { (_) in
                if let sellerUrlStr = appItem.sellerUrl, let sellerUrl = URL(string: sellerUrlStr) {
                    UIApplication.shared.open(sellerUrl)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        artWorkImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 120, height: 120))
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(16)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artWorkImageView.snp.top).inset(10)
            make.leading.equalTo(artWorkImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
        }
        artistNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(nameLabel)
        }
        sellerButton.snp.makeConstraints { (make) in
            make.leading.equalTo(artistNameLabel)
            make.bottom.equalTo(artWorkImageView)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(artWorkImageView.snp.bottom).offset(40)
            make.leading.equalTo(artWorkImageView.snp.leading)
            make.trailing.equalTo(artistNameLabel.snp.trailing)
        }
        screenshotView.snp.makeConstraints { (make) in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(infoStackView)
            make.height.equalTo(348)
        }
        screenShotCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(screenshotView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(screenshotView)
            make.bottom.equalToSuperview().inset(10)
        }
    }

}
