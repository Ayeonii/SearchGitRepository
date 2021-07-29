//
//  SearchResultViewModel.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SearchResultViewModel {
    private var disposeBag = DisposeBag()
    var dataSource = SearchResultDataSource.dataSource()
    var resultRelay = BehaviorRelay<[SearchResultSectionModel]>(value: [])
    var isEndPaging = false
    var searchInfo : SearchRequestInfo
    
    private var pagingCount = 0
    private var perPageSize = 15
    
    init(_ info : SearchRequestInfo){
        searchInfo = info
        callSearchResultApi(info)
        dataSource.decideViewTransition = { (_, _, _)  in return RxDataSources.ViewTransition.reload }
    }
}

extension SearchResultViewModel {
    func callSearchResultApi(_ info : SearchRequestInfo, perPage : Int? = 15){
        
            pagingCount += 1
            perPageSize = perPage ?? perPageSize
            
            var requestInfo = info
            requestInfo.page = "\(pagingCount)"
            requestInfo.perPage = "\(perPageSize)"
            
            CallApi.callSearchApi(request: requestInfo)
                .debug()
                .subscribe(onNext: { [weak self] data in
                    self?.emitEvent(data)
                })
                .disposed(by: disposeBag)
    }
    
    func emitEvent(_ res : SearchResultCodable) {
        guard let items = res.items else {return}
        var newSection = resultRelay.value
        
        if items.count < perPageSize {
            isEndPaging = true
        }
        
        let list = items.compactMap {
            SearchResultModel($0)
        }
        
        newSection += [SearchResultSectionModel(items : list)]
        self.resultRelay.accept(newSection)

    }
}
