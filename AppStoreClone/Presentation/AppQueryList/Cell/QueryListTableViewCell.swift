//
//  QueryListTableViewCell.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/16.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit

class QueryListTableViewCell: UITableViewCell, View {
    @IBOutlet weak var label: UILabel!

    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: QueryItemReactor) {
        let appQuery = reactor.currentState
        label.text = appQuery.query
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
