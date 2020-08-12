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
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: SearchItemReactor) {
        
        layout()
    }
    
    func layout() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
