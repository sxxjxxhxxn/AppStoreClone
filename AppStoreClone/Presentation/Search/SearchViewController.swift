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
import Reachability
import RxReachability
import SnapKit
import Then

final class SearchViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    private let tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
        $0.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "Search Apps"
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.barStyle = .default
    }
    let keywordListContainer = UIView().then {
        $0.isHidden = true
    }
    private let spinner = UIActivityIndicatorView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        $0.style = .whiteLarge
    }
    private let reachability: Reachability? = Reachability()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        view.addSubview(tableView)
        view.addSubview(keywordListContainer)
        view.addSubview(spinner)
        
        setupSearchController()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        keywordListContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        try? reachability?.startNotifier()
    }
    
    func bind(reactor: SearchReactor) {
        bindTableView(reactor)
        bindSearchController(reactor)
        
        reactor.selectedKeyword
            .map { [weak self] in
                self?.searchController.isActive = false
                return Reactor.Action.search(keyword: $0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFetching }
            .bind(to: spinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reachability?.rx
            .isDisconnected
            .map { Reactor.Action.disconnected }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}

// MARK: - Table View

extension SearchViewController {
    
    private func bindTableView(_ reactor: SearchReactor) {
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items) { (tableView, _, itemReactor) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: SearchTableViewCell.self)
                cell.reactor = itemReactor
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .reachedBottom()
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(SearchItemReactor.self)
            .map { $0.initialState }
            .map { Reactor.Action.showDetail(appItem: $0) }
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
            .willDismiss
            .merge(with: searchController.rx.willPresent)
            .map { Reactor.Action.keywordListVisibility }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}
