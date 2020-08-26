//
//  SearchTableViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/12.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit

class SearchTableViewCell: UITableViewCell, View {

    var artWorkImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    var nameLabel = UILabel()
    var genreLabel = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.font = UIFont.systemFont(ofSize: 15.0)
    }
    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: SearchItemReactor) {
        let appItem = reactor.currentState
        
        DispatchQueue.global(qos: .background).async {
            if let artWorkUrl = URL(string: appItem.artworkUrl100) {
                if let artWorkData = try? Data(contentsOf: artWorkUrl) {
                    DispatchQueue.main.async {
                        self.artWorkImageView.image = UIImage(data: artWorkData)
                    }
                }
            }
        }
        nameLabel.text = appItem.trackName
        genreLabel.text = appItem.genres.joined(separator: ", ")
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
    
    func setConstraints() {
        artWorkImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(16)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(artWorkImageView.snp.centerY).offset(-13)
            make.left.equalTo(artWorkImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-16)
        }
        genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artWorkImageView.image = nil
    }
    
}
