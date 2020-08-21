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

class SearchViewController: UIViewController, View, BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var queryListContainer: UIView!
    
    var _reactor: SearchReactor?
    var disposeBag = DisposeBag()
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Apps"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        return searchController
    }()
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: UIScreen.main.bounds)
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        spinner.style = .whiteLarge
        return spinner
    }()
    private var reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        setReactor()
        
        queryListContainer.isHidden = true
        title = "검색"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        setupTableView()
        setupSearchController()
        view.addSubview(spinner)
        try? reachability?.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
    }
    
    func bind(reactor: SearchReactor) {
        bindTableView(reactor)
        bindSearchController(reactor)
        
        reactor.state
            .map { !$0.listVisibility }
            .bind(to: queryListContainer.rx.isHidden)
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
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
