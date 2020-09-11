//
//  SearchTableViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/18.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import SnapKit
import Kingfisher
import Cosmos

final class SearchTableViewCell: UITableViewCell, ReactorKit.View {
    
    typealias Reactor = SearchItemReactor
    var disposeBag: DisposeBag = DisposeBag()
    private let artWorkImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
    }
    private let nameLabel = UILabel()
    private let genreLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 14.0)
    }
    private let userRatingBar = CosmosView().then {
        $0.settings.textFont = UIFont.systemFont(ofSize: 14)
        $0.settings.textColor = UIColor.darkGray
        $0.settings.starMargin = 1
        $0.settings.starSize = 16.0
        $0.settings.filledBorderColor = UIColor.darkGray
        $0.settings.emptyBorderColor = UIColor.darkGray
        $0.settings.filledColor = UIColor.darkGray
        $0.isUserInteractionEnabled = false
    }
    private let thumbnailStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 9
    }
    private var thumbnailViews: [UIImageView] = []
    fileprivate var appItem: AppItem?
    var onTapAppItem: ((AppItem?) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(artWorkImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(thumbnailStackView)
        
        artWorkImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(16)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artWorkImageView.snp.top).inset(1)
            make.leading.equalTo(artWorkImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
        }
        genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(nameLabel)
        }
        thumbnailStackView.snp.makeConstraints { (make) in
            make.top.equalTo(artWorkImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        appItem = reactor.initialState
        if let artworkUrl100 = appItem?.artworkUrl100, let url = URL(string: artworkUrl100) {
            artWorkImageView.kf.setImage(with: url, options: [.loadDiskFileSynchronously])
        }
        nameLabel.text = appItem?.trackName
        genreLabel.text = appItem?.genres.joined(separator: ", ")
        
        if let userRatingCount = appItem?.userRatingCount, userRatingCount > 0 {
            contentView.addSubview(userRatingBar)
            userRatingBar.snp.makeConstraints { (make) in
                make.top.equalTo(genreLabel.snp.bottom).offset(5)
                make.leading.trailing.equalTo(genreLabel)
            }
            userRatingBar.rating = appItem?.averageUserRating ?? 0
            userRatingBar.text = userRatingCount<1000 ? "\(Int(userRatingCount))" : "\(round(userRatingCount/100)/10)천"
        }
        
        for index in 0 ..< min((appItem?.screenshotUrls.count ?? 3), 3) {
            let thumbnailView = UIImageView().then {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
                $0.snp.makeConstraints { (make) in
                    make.size.equalTo(CGSize(width: 107, height: 191))
                }
            }
            if let thumbnailStr = appItem?.screenshotUrls[index], let thumbnailUrl = URL(string: thumbnailStr) {
                thumbnailView.kf.setImage(with: thumbnailUrl, options: [.loadDiskFileSynchronously])
                thumbnailViews.append(thumbnailView)
            }
        }
        thumbnailViews.forEach {
            thumbnailStackView.addArrangedSubview($0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            onTapAppItem?(appItem)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artWorkImageView.image = nil
        thumbnailStackView.arrangedSubviews
            .filter({ $0 is UIImageView })
            .forEach({ $0.removeFromSuperview() })
        thumbnailViews.forEach {
            $0.image = nil
        }
        thumbnailViews.removeAll()
    }
    
}
