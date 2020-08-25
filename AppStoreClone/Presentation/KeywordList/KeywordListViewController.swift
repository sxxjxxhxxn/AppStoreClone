//
//  AppQueryListViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import Then

class KeywordListViewController: UIViewController, View {

    var _tableView = UITableView().then {
        $0.register(KeywordListTableViewCell.self, forCellReuseIdentifier: KeywordListTableViewCell.reuseID)
        $0.estimatedRowHeight = 100
    }
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(_tableView)
        _tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func bind(reactor: KeywordListReactor) {
        bindTableView(reactor)
        
        Observable.just(Void())
            .map { Reactor.Action.loadKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}

// MARK: - Table View

extension KeywordListViewController {
    
    private func bindTableView(_ reactor: KeywordListReactor) {
        reactor.state
            .map { $0.keywords }
            .bind(to: _tableView.rx.items) { (tableView, _, itemReactor) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: KeywordListTableViewCell.self)
                cell.bind(reactor: itemReactor)
                return cell
            }
            .disposed(by: disposeBag)
        
        _tableView.rx
            .modelSelected(KeywordItemReactor.self)
            .map { Reactor.Action.select(keyword: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}
