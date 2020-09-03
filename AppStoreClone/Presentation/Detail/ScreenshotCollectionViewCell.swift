//
//  ScreenshotCollectionViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/26.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import SnapKit

final class ScreenshotCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ imageUrl: String) {
        if let imageUrl = URL(string: imageUrl) {
            self.imageView.kf.setImage(with: imageUrl)
        }
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
