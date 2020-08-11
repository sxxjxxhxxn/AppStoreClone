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
        // Do any additional setup after loading the view.
    }
    
    func bind(reactor: SearchReactor) {
        //통신 결과 확인
        Observable.just(Void())
            .map { Reactor.Action.testAction(path: "term=hakuna&country=kr&entity=software") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
