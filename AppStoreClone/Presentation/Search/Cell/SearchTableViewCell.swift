//
//  SearchTableViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/12.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit
import Kingfisher

final class SearchTableViewCell: UITableViewCell, ReactorKit.View {

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
        $0.font = UIFont.systemFont(ofSize: 15.0)
    }
    
    func bind(reactor: SearchItemReactor) {
        reactor.state
            .do(onNext: { (appItem) in
                if let url = URL(string: appItem.artworkUrl100) {
                    self.artWorkImageView.kf.setImage(with: url)
                }
                self.nameLabel.text = appItem.trackName
                self.genreLabel.text = appItem.genres.joined(separator: ", ")
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(artWorkImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(genreLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        artWorkImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(16)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(artWorkImageView.snp.centerY).offset(-13)
            make.leading.equalTo(artWorkImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
        }
        genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artWorkImageView.image = nil
    }
    
}
