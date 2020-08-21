//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/21.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit

class DetailViewController: UIViewController, StoryboardView {
    @IBOutlet weak var label: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: DetailReactor) {
        label.text = reactor.initialState.trackName
    }

}
