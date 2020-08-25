//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/21.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit

class DetailViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    var label = UILabel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func bind(reactor: DetailReactor) {
        label.text = reactor.initialState.trackName
    }

}
