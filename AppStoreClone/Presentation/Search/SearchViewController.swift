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
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Apps"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let reactor = self.reactor else { return }
        
        title = "검색"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        setupTableView()
        setupSearchController()
        
        bind(reactor: reactor)
    }
    
    func bind(reactor: SearchReactor) {
        guard tableView != nil else { return }
        
        bindTableView(reactor)
        bindSearchController(reactor)
    }

}

// MARK: - Table View

extension SearchViewController {
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let searchTableViewCellNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(searchTableViewCellNib, forCellReuseIdentifier: SearchTableViewCell.reuseID)
    }
    
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
            .contentOffset
            .filter { return $0.y > .zero }
            .flatMap { [weak self] contentOffset in
                self?.isScrolledToBottom(contentOffset) ?? false ? Observable.just(Void()) : Observable.empty()
            }
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func isScrolledToBottom(_ contentOffset: CGPoint) -> Bool {
        return (tableView.contentSize.height - tableView.frame.size.height) < (contentOffset.y + tableView.estimatedRowHeight)
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
