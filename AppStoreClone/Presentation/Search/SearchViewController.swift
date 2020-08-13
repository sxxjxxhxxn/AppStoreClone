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
    private var searchController = UISearchController(searchResultsController: nil)
    private var query: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let reactor = self.reactor else { return }
        
        title = reactor.initialState.title
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        bind(reactor: reactor)
    }
    
    func bind(reactor: SearchReactor) {
        guard tableView != nil else { return }
        
        setupTableView(reactor)
        setupSearchController()
        
        bindTableView(reactor)
        bindSearchController(reactor)
    }
    
    private func updateQueryListVisibility() {
        guard searchController.searchBar.isFirstResponder else {
            print("close query list")
            return
        }
        print("open query list")
    }

}

// MARK: - Table View

extension SearchViewController {
    
    private func setupTableView(_ reactor: SearchReactor) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let searchTableViewCellNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(searchTableViewCellNib, forCellReuseIdentifier: SearchTableViewCell.reuseID)
    }
    
    private func bindTableView(_ reactor: SearchReactor) {
        tableView.rx
            .contentOffset
            .flatMap { [weak self] contentOffset in
                self?.isScrolledToBottom(contentOffset) ?? false ? Observable.just(Void()) : Observable.empty()
            }
            .map { Reactor.Action.loadMore(query: self.query) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items) { (tableView, row, itemReactor) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(of: SearchTableViewCell.self, at: IndexPath.init(row: row, section: 0))
                cell.bind(reactor: itemReactor)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func isScrolledToBottom(_ contentOffset: CGPoint) -> Bool {
        return (tableView.contentSize.height - tableView.frame.size.height) == contentOffset.y
    }
    
}

// MARK: - Search Controller

extension SearchViewController: UISearchControllerDelegate {
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search Apps"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        
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
                self?.query = self?.searchController.searchBar.text ?? ""
                return !(self?.query.isEmpty ?? true)
            }
            .map { [weak self] in
                self?.searchController.isActive = false
                return Reactor.Action.search(query: self?.query ?? "")
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueryListVisibility()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueryListVisibility()
    }
    
}
