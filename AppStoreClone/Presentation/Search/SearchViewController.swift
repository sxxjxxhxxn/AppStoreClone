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
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    private var searchController = UISearchController(searchResultsController: nil)
    let testString = "ha"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        bind(reactor: self.reactor!)
        setupSearchController()
    }
    
    func bind(reactor: SearchReactor) {
        guard let tableView = tableView else { return }
        
        Observable.just(Void())
            .map { Reactor.Action.search(query: self.testString) }
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

        setupTableView(reactor)
    }
    
    func isScrolledToBottom(_ contentOffset: CGPoint) -> Bool {
        return (tableView.contentSize.height - tableView.frame.size.height) == contentOffset.y
    }
    
    private func updateQueryListVisibility() {
        guard searchController.searchBar.isFirstResponder else {
            print("close query list")
            return
        }
        print("open query list")
    }

}

// MARK: - Setup Table View

extension SearchViewController {
    private func setupTableView(_ reactor: SearchReactor) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let searchTableViewCellNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(searchTableViewCellNib, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        
        tableView.rx
            .contentOffset
            .flatMap { [weak self] contentOffset in
                self?.isScrolledToBottom(contentOffset) ?? false ? Observable.just(Void()) : Observable.empty()
            }
        .map { Reactor.Action.loadMore(query: self.testString) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        searchController.isActive = false
        print("serach query: ", searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }
}

extension SearchViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueryListVisibility()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueryListVisibility()
    }
}

// MARK: - Setup Search Controller

extension SearchViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
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
}
