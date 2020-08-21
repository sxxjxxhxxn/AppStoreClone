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
    @IBOutlet weak var label: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: SearchItemReactor) {
        let appItem = reactor.currentState
        label.text = appItem.trackName
    }
    
    func layout() {
//        selectionStyle = .none
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
