//
//  ScreenshotCollectionViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/26.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import SnapKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView().then {
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
        DispatchQueue.global(qos: .background).async {
            if let imageUrl = URL(string: imageUrl), let imageData = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
