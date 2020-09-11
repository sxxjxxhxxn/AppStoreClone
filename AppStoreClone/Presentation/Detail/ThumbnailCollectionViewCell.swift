//
//  ThumbnailCollectionViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import SnapKit

final class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(_ imageUrl: String) {
        if let imageUrl = URL(string: imageUrl) {
            imageView.kf.setImage(with: imageUrl, options: [.loadDiskFileSynchronously])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
