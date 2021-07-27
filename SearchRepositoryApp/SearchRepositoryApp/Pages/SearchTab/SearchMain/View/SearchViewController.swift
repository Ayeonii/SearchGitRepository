//
//  SearchViewController.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var repositoryField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!

    var disposeBag = DisposeBag()
    var viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchViewController {
    func bindView() {
        userField.rx.text.orEmpty
            .map(viewModel.checkUserNameisValid)
            .subscribe(onNext: {[weak self] isValid in
                self?.userField.layer.borderColor = isValid ? UIColor.black.cgColor : UIColor.red.cgColor
                self?.searchBtn.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        searchBtn.rx.tap
            .bind{
                self.goSearchResult()
            }
            .disposed(by: disposeBag)
    }
    
    func goSearchResult() {
        let info = SearchRequestInfo(user: userField.text!, repository: repositoryField.text ?? "")
        
        let resultVc = SearchResultViewController(info: info)
        resultVc.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resultVc, animated: true)
    }
}

