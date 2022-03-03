//
//  SearchResultViewController.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

class SearchResultViewController: UIViewController {
    private var disposeBag = DisposeBag()
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 50
            tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        }
    }
    
    let reactor : SearchResultReactor
    
    init(info : SearchRequestInfo) {
        self.reactor = SearchResultReactor(info)
        super.init(nibName: "SearchResultViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: reactor)
        reactor.action.onNext(.callSearchList)
    }
    
    func bind(reactor : SearchResultReactor) {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map{$0.resultList}
            .bind(to: tableView.rx.items(dataSource: reactor.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map{$0.isLoading}
            .subscribe(onNext: {[weak self] isLoading in
                self?.showIndicator(isShow: isLoading)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchResultModel.self)
            .subscribe(onNext: { model in
                if let url = URL(string: model.url) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .willDisplayCell
            .filter {[weak self, weak reactor] ( _ , indexPath) in
                guard let self = self else { return false }
                
                let translation = self.tableView.panGestureRecognizer.translation(in: self.tableView.superview)
                let maxCount = reactor?.currentState.resultList[indexPath.section].items.count ?? 0
                let isLoading = reactor?.currentState.isLoading ?? false
                
                return translation.y < 0 && (indexPath.row >= maxCount - 4 && maxCount > 4) && !isLoading
            }
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak reactor] _ in
                reactor?.action.onNext(.callSearchList)
            })
            .disposed(by: disposeBag)
        
    }
    
    func showIndicator(isShow : Bool) {
        self.indicator.isHidden = !isShow
        
        if isShow {
            self.indicator.startAnimating()
        } else {
            self.indicator.stopAnimating()
        }
    }
    
}

extension SearchResultViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

