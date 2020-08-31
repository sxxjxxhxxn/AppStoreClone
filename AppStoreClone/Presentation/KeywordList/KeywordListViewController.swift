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

    var disposeBag = DisposeBag()
    var tableView = UITableView().then {
        $0.register(KeywordListTableViewCell.self, forCellReuseIdentifier: KeywordListTableViewCell.reuseID)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func bind(reactor: KeywordListReactor) {
        bindTableView(reactor)
    }
    
    func loadKeywords() {
        guard let reactor = reactor else { return }
        
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
            .bind(to: tableView.rx.items) { (tableView, _, itemReactor) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: KeywordListTableViewCell.self)
                cell.bind(reactor: itemReactor)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(KeywordItemReactor.self)
            .map { Reactor.Action.select(keyword: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}
