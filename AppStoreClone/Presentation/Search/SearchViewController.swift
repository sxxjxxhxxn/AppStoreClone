//
//  SearchViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: SearchReactor) {
        //통신 결과 확인
        Observable.just(Void())
            .map { Reactor.Action.search(query: "hakuna") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}
