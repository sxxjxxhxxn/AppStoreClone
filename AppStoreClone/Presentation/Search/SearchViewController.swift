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

class SearchViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    var tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
        $0.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    private var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "Search Apps"
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.barStyle = .default
    }
    var keywordListContainer = UIView().then {
        $0.isHidden = true
    }
    private var spinner = UIActivityIndicatorView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        $0.style = .whiteLarge
    }
    private var reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        title = "검색"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        try? reachability?.startNotifier()
    }
    
    func bind(reactor: SearchReactor) {
        bindTableView(reactor)
        bindSearchController(reactor)
        
        reactor.state
            .map { !$0.listVisibility }
            .bind(to: keywordListContainer.rx.isHidden)
            .disposed(by: disposeBag)
        
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
                cell.bind(reactor: itemReactor)
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
        
        tableView.rx
            .itemSelected
            .map { [weak self] in self?.tableView.deselectRow(at: $0, animated: true) }
            .subscribe()
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
