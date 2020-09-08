//
//  KeywordListViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/25.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import SnapKit
import Then

class KeywordListViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    private let tableView = UITableView().then {
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
        reactor?.action.onNext(.loadKeywords)
    }

}

// MARK: - Table View

extension KeywordListViewController {
    
    private func bindTableView(_ reactor: KeywordListReactor) {
        reactor.state
            .map { $0.keywords }
            .bind(to: tableView.rx.items) { (tableView, _, keyword) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: KeywordListTableViewCell.self)
                let itemReactor = KeywordItemReactor(keyword: keyword)
                cell.reactor = itemReactor
                cell.onTapKeyword = { [weak self] keyword in
                    if let keyword = keyword {
                        self?.reactor?.action.onNext(.selectKeyword(keyword: keyword))
                    }
                }
                return cell
            }
            .disposed(by: disposeBag)
    }
    
}
