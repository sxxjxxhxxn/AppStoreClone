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

    var label = UILabel()
    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: SearchItemReactor) {
        let appItem = reactor.currentState
        label.text = appItem.trackName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
