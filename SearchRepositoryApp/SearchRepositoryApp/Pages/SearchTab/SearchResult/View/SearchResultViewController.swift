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
            tableView.estimatedRowHeight = 50
            tableView.scrollsToTop = false
            tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        }
    }
    
    let viewModel : SearchResultViewModel
    var isFetching = false
    private var disposeBag = DisposeBag()
    
    init(info : SearchRequestInfo) {
        self.viewModel = SearchResultViewModel(info)
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
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.resultSubject
            .do(onNext: {[weak self] _ in
                
                self?.isFetching = false
            })
            .bind(to:
                tableView.rx.items(dataSource: self.viewModel.dataSource)
            )
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

extension SearchResultViewController : UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - (scrollView.frame.height){
            if !viewModel.isEndPaging, !isFetching {
                isFetching = true
                viewModel.callSearchResultApi(viewModel.searchInfo)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

