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
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()

    private var query: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let reactor = self.reactor else { return }
        
        title = reactor.initialState.title
        bind(reactor: reactor)
    }
    
    func bind(reactor: SearchReactor) {
        guard tableView != nil else { return }
        
        setupTableView()
        bindTableView(reactor)
        
        Observable.just(Void())
            .map { Reactor.Action.search(query: "hakuna") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}

// MARK: - Table View

extension SearchViewController {
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let searchTableViewCellNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(searchTableViewCellNib, forCellReuseIdentifier: SearchTableViewCell.reuseID)
    }
    
    private func bindTableView(_ reactor: SearchReactor) {
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items) { (tableView, row, itemReactor) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: SearchTableViewCell.self, at: IndexPath.init(row: row, section: 0))
                cell.bind(reactor: itemReactor)
                return cell
            }
            .disposed(by: disposeBag)
    }

}
