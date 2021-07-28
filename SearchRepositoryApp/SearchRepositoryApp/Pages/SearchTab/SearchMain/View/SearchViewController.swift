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

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
}

extension SearchViewController {
    
    func bindView() {
        searchBtn.rx.tap
            .bind{
                self.goSearchResult()
            }
            .disposed(by: disposeBag)
        
        userField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext : {[weak self] _ in
                self?.userField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        repositoryField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext : { [weak self] _ in
                self?.repositoryField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
    }
    
    func goSearchResult() {
        let info = SearchRequestInfo(user: userField.text, repository: repositoryField.text)
        
        let resultVc = SearchResultViewController(info: info)
        resultVc.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resultVc, animated: true)
    }
}

