//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import SnapKit
import Then
import Cosmos

final class DetailViewController: UIViewController, View {

    typealias Reactor = DetailReactor
    var disposeBag = DisposeBag()
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    private let artWorkImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
    }
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 21.0)
    }
    private let artistNameLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 16.0)
    }
    private let sellerButton = UIButton().then {
        $0.backgroundColor = UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("열기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        $0.layer.cornerRadius = 16
    }
    private var actionButton = UIButton().then {
        if #available(iOS 13.0, *) {
            $0.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        } else {
            $0.setBackgroundImage(UIImage(named: "square.and.arrow.up"), for: .normal)
        }
    }
    private let infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private let userRatingStackView = UIStackView().then {
        $0.axis = .vertical
    }
    private let userRatingBar = CosmosView().then {
        $0.settings.textFont = UIFont.boldSystemFont(ofSize: 21)
        $0.settings.textColor = UIColor.darkGray
        $0.settings.starMargin = 1
        $0.settings.starSize = 21.0
        $0.settings.filledBorderColor = UIColor.darkGray
        $0.settings.emptyBorderColor = UIColor.darkGray
        $0.settings.filledColor = UIColor.darkGray
        $0.isUserInteractionEnabled = false
    }
    private let userRatingSubLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 14.0)
    }
    private let priceGenreStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    private let priceLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 21.0)
    }
    private let genreLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 14.0)
        $0.adjustsFontSizeToFitWidth = true
    }
    private let contentRatingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    private let contentRatingLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 21.0)
    }
    private let contentRatingSubLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 14.0)
    }
    private let screenshotView = UIView()
    private let screenShotCollectionView = UICollectionView(frame: CGRect.zero,
                                                            collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize(width: 196, height: 348)

        $0.setCollectionViewLayout(layout, animated: true)
        $0.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.reuseID)
        $0.backgroundColor = UIColor.clear
    }
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 5
    }
    private let readMoreButton = UIButton().then {
        $0.setTitleColor(.blue, for: .normal)
        $0.setTitle("더 보기", for: .normal)
    }
    private let transition = AnimationTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(artWorkImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(sellerButton)
        contentView.addSubview(actionButton)
        contentView.addSubview(infoStackView)
        contentView.addSubview(screenshotView)
        screenshotView.addSubview(screenShotCollectionView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(readMoreButton)
        
        infoStackView.addArrangedSubview(userRatingStackView)
        infoStackView.addArrangedSubview(priceGenreStackView)
        infoStackView.addArrangedSubview(contentRatingStackView)
        userRatingStackView.addArrangedSubview(userRatingBar)
        userRatingStackView.addArrangedSubview(userRatingSubLabel)
        priceGenreStackView.addArrangedSubview(priceLabel)
        priceGenreStackView.addArrangedSubview(genreLabel)
        contentRatingStackView.addArrangedSubview(contentRatingLabel)
        contentRatingStackView.addArrangedSubview(contentRatingSubLabel)
        
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
            make.leading.equalToSuperview().inset(24)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artWorkImageView.snp.top).inset(10)
            make.leading.equalTo(artWorkImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(24)
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
        actionButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.bottom.equalTo(artWorkImageView)
            make.trailing.equalTo(artistNameLabel)
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
        }
        readMoreButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.trailing.equalTo(descriptionLabel)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func bind(reactor: Reactor) {
        let appItem = reactor.initialState

        if let imageUrl = URL(string: appItem.artworkUrl512) {
            artWorkImageView.kf.setImage(with: imageUrl, options: [.loadDiskFileSynchronously])
        }
        nameLabel.text = appItem.trackName
        artistNameLabel.text = appItem.artistName
        if appItem.sellerUrl == nil {
            sellerButton.backgroundColor = UIColor.lightGray
            actionButton.tintColor = UIColor.lightGray
        }
        userRatingBar.rating = appItem.averageUserRating
        userRatingBar.text = appItem.userRatingCount == 0 ? "" : "\(round(appItem.averageUserRating*10)/10)"
        userRatingSubLabel.text = appItem.userRatingCount == 0 ? "평가 부족" : "\(round(appItem.userRatingCount/100)/10)천개의 평가"
        priceLabel.text = appItem.formattedPrice
        genreLabel.text = (appItem.genres.count<4 ? appItem.genres : appItem.genres.dropLast(2)).joined(separator: ", ")
        contentRatingLabel.text = appItem.trackContentRating
        contentRatingSubLabel.text = "연령"
        descriptionLabel.text = appItem.description
        
        sellerButton.rx
            .tap
            .subscribe { _ in
                if let sellerUrlStr = appItem.sellerUrl, let sellerUrl = URL(string: sellerUrlStr) {
                    UIApplication.shared.open(sellerUrl)
                }
            }
            .disposed(by: disposeBag)
        
        actionButton.rx
            .tap
            .subscribe { [weak self] _ in
                if let sellerUrlStr = appItem.sellerUrl, let sellerUrl = URL(string: sellerUrlStr) {
                    let activityViewController = UIActivityViewController(activityItems: [sellerUrl], applicationActivities: nil)
                    self?.present(activityViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.screenshotUrls }
            .bind(to: screenShotCollectionView.rx.items) { (collectionView, _, imageUrl) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(of: ThumbnailCollectionViewCell.self)
                cell.bind(imageUrl)
                return cell
            }
            .disposed(by: disposeBag)
        
        screenShotCollectionView.rx
            .itemSelected
            .do(onNext: { [weak self] indexPath in
                if let cell = self?.screenShotCollectionView.cellForItem(at: indexPath) {
                    let cellOriginFrame = cell.superview?.convert(cell.frame, to: nil)
                    self?.transition.setFrame(frame: cellOriginFrame)
                }
            })
            .map { Reactor.Action.showDetailImages(indexPath: $0, screenshotURLs: appItem.screenshotUrls) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        readMoreButton.rx
            .tap
            .subscribe { [weak self] _ in
                self?.descriptionLabel.numberOfLines = 0
                self?.readMoreButton.isHidden = true
            }
            .disposed(by: disposeBag)
    }

}

extension DetailViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DisMissAnimationTransition()
    }
}
