//
//  KeywordListTableViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import SnapKit

final class KeywordListTableViewCell: UITableViewCell, View {

    typealias Reactor = KeywordItemReactor
    var disposeBag: DisposeBag = DisposeBag()
    private let keywordLabel = UILabel()
    fileprivate var keyword: Keyword?
    var onTapKeyword: ((Keyword?) -> Void)?
    
    func bind(reactor: Reactor) {
        keyword = reactor.initialState
        keywordLabel.text = keyword?.text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            onTapKeyword?(keyword)
        }
    }
    
    private func setUp() {
        contentView.addSubview(keywordLabel)
        
        keywordLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
}
