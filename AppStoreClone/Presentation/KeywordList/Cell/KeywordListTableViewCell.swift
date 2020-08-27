//
//  QueryListTableViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/16.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import Then

class KeywordListTableViewCell: UITableViewCell, View {

    var label = UILabel()
    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: KeywordItemReactor) {
        let keyword = reactor.initialState
        label.text = keyword.text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //
    }
    
}
