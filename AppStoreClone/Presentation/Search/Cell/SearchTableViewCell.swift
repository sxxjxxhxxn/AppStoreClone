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

final class SearchTableViewCell: UITableViewCell, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    private let nameLabel = UILabel()
    
    func bind(reactor: SearchItemReactor) {
        let appItem = reactor.currentState
        nameLabel.text = appItem.trackName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    private func setConstraints() {
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}
