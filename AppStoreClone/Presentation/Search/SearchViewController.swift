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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            print("tableView is set")
        }
    }
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: self.reactor!)
    }
    
    func bind(reactor: SearchReactor) {
        guard let tableView = tableView else { return }
        
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items) { (tableView, row, itemReactor) -> UITableViewCell in
                print("check")
                let cell = tableView.dequeueReusableCell(of: SearchTableViewCell.self, at: IndexPath.init(row: row, section: 0))
                cell.bind(reactor: itemReactor)
                return cell
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isFetching }
            .map { !$0 }
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] finished in
                if finished {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        configureTableView(reactor)
    }
    
    private func configureTableView(_ reactor: SearchReactor) {
        tableView.refreshControl = UIRefreshControl()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let searchTableViewCellNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(searchTableViewCellNib, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        
        tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { Reactor.Action.pull(path: "term=hakuna&country=kr&entity=software") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx
            .contentOffset
            .flatMap { [weak self] contentOffset in
                self?.isScrolledToBottom(contentOffset) ?? false ? Observable.just(Void()) : Observable.empty()
            }
            .map { Reactor.Action.loadMore(path: "term=hakuna&country=kr&entity=software") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func isScrolledToBottom(_ contentOffset: CGPoint) -> Bool {
        return (tableView.contentSize.height - tableView.frame.size.height) == contentOffset.y
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
