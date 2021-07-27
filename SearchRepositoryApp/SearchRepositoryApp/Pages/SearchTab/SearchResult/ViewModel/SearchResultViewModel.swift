//
//  SearchResultViewModel.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import Foundation
import RxSwift

class SearchResultViewModel {
    private var disposeBag = DisposeBag()
    var resultSubject = BehaviorSubject<[SearchResultModel]>(value : [])
    
    init(_ info : SearchRequestInfo){
        callSearchResultApi(info)
    }
    
}

extension SearchResultViewModel {
    func callSearchResultApi(_ info : SearchRequestInfo){
        
    }
}
