//
//  AppQueryListViewController.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/14.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import ReactorKit

class QueryListViewController: UIViewController, View {
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let reactor = self.reactor else { return }

        bind(reactor: reactor)
    }

    func bind(reactor: QueryListReactor) {
        guard tableView != nil else { return }
        
        bindTableView(reactor)
        
        Observable.just(Void())
            .map { Reactor.Action.loadQueries }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}

// MARK: - Table View

extension QueryListViewController {
    
    private func setupTableView() {
//        let searchTableViewCellNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
//        tableView.register(searchTableViewCellNib, forCellReuseIdentifier: SearchTableViewCell.reuseID)
    }
    
    private func bindTableView(_ reactor: QueryListReactor) {
        reactor.state
            .map { $0.queries }
            .bind(to: tableView.rx.items) { (tableView, row, itemReactor) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(at: IndexPath.init(row: row, section: 0))
//                cell.bind(reactor: itemReactor)
                cell.textLabel?.text = itemReactor.initialState.query
                return cell
            }
            .disposed(by: disposeBag)
    }
    
}
