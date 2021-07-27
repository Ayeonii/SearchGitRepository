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

class SearchResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        }
    }
  
    let requestInfo : SearchRequestInfo
    lazy var viewModel = SearchResultViewModel(requestInfo)
    private var disposeBag = DisposeBag()
    
    init(info : SearchRequestInfo) {
        self.requestInfo = info
        super.init(nibName: "SearchResultViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

}

extension SearchResultViewController {
    private func bindView() {
        self.viewModel.resultSubject
            .bind(to: tableView.rx.items(cellIdentifier : "SearchResultTableViewCell")){ indexPath, data, cell in
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(SearchResultModel.self)
            .subscribe(onNext: { model in
                if let url = URL(string: model.url) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
    }
}
