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
import Alamofire
import RxAlamofire

class SearchViewController: UIViewController, View {
    
    typealias Reactor = SearchReactor
    var disposeBag = DisposeBag()
    private let tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
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
    private let networkReachabilityManager = NetworkReachabilityManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func setUp() {
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
    }
    
    func bind(reactor: Reactor) {
        bindTableView(reactor)
        bindSearchController(reactor)
        
        reactor.selectedKeyword
            .do(onNext: { [weak self] in
                self?.keywordListContainer.isHidden = true
                self?.searchController.searchBar.endEditing(true)
                self?.searchController.searchBar.text = $0
            })
            .map { Reactor.Action.loadItems(keyword: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFetching }
            .bind(to: spinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        networkReachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                Observable.just(Void())
                    .map { Reactor.Action.disconnected }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            default:
                break
            }
        }
        networkReachabilityManager?.startListening()
    }

}

// MARK: - Table View

extension SearchViewController {
    
    private func bindTableView(_ reactor: SearchReactor) {
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items) { (tableView, _, appItem) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: SearchTableViewCell.self)
                cell.reactor = SearchItemReactor(appItem: appItem)
                cell.onTapAppItem = { [weak self] appItem in
                    if let appItem = appItem {
                        self?.reactor?.action.onNext(.showDetail(appItem: appItem))
                    }
                }
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .reachedBottom()
            .map { [weak self] in
                Reactor.Action.loadItems(keyword: self?.searchController.searchBar.text ?? "")
            }
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
            .do(onNext: { [weak self] in
                self?.keywordListContainer.isHidden = true
            })
            .map { [weak self] in
                Reactor.Action.loadItems(keyword: self?.searchController.searchBar.text ?? "")
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx
            .cancelButtonClicked
            .do(onNext: { [weak self] in
                self?.keywordListContainer.isHidden = true
            })
            .map { Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx
            .textDidBeginEditing
            .map { Reactor.Action.keywordListVisibility }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}
