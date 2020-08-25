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
import RxSwiftExt
import SnapKit
import Then

class SearchViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    var tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Apps"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        setupSearchController()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        title = "검색"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    func bind(reactor: SearchReactor) {
        bindTableView(reactor)
        bindSearchController(reactor)
    }

}

// MARK: - Table View

extension SearchViewController {
    
    private func bindTableView(_ reactor: SearchReactor) {
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items) { (tableView, _, itemReactor) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: SearchTableViewCell.self)
                cell.bind(reactor: itemReactor)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .reachedBottom()
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}

// MARK: - Search Controller

extension SearchViewController {
    
    private func setupSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    private func bindSearchController(_ reactor: SearchReactor) {
        searchController.searchBar.rx
            .searchButtonClicked
            .filter { [weak self] in
                self?.searchController.searchBar.text?.isNotEmpty ?? true
            }
            .map { [weak self] in
                let searchAction = Reactor.Action.search(keyword: self?.searchController.searchBar.text ?? "")
                self?.searchController.isActive = false
                return searchAction
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.rx
            .willPresent
            .map { Reactor.Action.openSearchList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.rx
            .willDismiss
            .map { Reactor.Action.closeSearchList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}
