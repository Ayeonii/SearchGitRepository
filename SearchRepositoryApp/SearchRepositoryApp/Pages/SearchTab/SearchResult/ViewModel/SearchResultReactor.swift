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
import ReactorKit

class SearchResultReactor : Reactor {
    private var disposeBag = DisposeBag()
  
    var dataSource = SearchResultDataSource.dataSource()
    var searchInfo : SearchRequestInfo
    
    private var pagingCount = 0
    private var perPageSize = 15
    
    enum Action {
        case callSearchList
    }
    
    enum Mutation {
        case setSearchList([SearchResultSectionModel])
        case setLoading(Bool)
    }
    
    struct State {
        var resultList : [SearchResultSectionModel] = []
        var isLoading : Bool = false
    }
    
    var initialState = State()
    
    init(_ info : SearchRequestInfo){
        searchInfo = info
        dataSource.decideViewTransition = { (_, _, _)  in return RxDataSources.ViewTransition.animated }
    }
    
    func mutate(action : SearchResultReactor.Action) -> Observable<SearchResultReactor.Mutation> {
        switch action {
        case .callSearchList :
            return Observable.concat([Observable.just(.setLoading(true)),
                                      callSearchResultApi(searchInfo),
                                      Observable.just(.setLoading(false))])
        }
    }
    
    func reduce(state : State, mutation : Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSearchList(let resultModel) :
            state.resultList = resultModel
        case .setLoading(let isLoading) :
            state.isLoading = isLoading
        }
        
        return state
    }
}

extension SearchResultReactor {
    func callSearchResultApi(_ info : SearchRequestInfo, perPage : Int? = 15) -> Observable<Mutation> {
        return Observable<Mutation>.create {[weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "SELF Deinit!", code: -1, userInfo: nil))
                return Disposables.create()
            }
            
            self.pagingCount += 1
            self.perPageSize = perPage ?? self.perPageSize
            
            var requestInfo = info
            requestInfo.page = "\(self.pagingCount)"
            requestInfo.perPage = "\(self.perPageSize)"
            
            CallApi.callSearchApi(request: requestInfo)
                .debug()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    guard let items = data.items else { return }
                    var newSection = self.currentState.resultList
                    
                    guard !items.isEmpty else { return }
                    
                    let list = items.compactMap {
                        SearchResultModel($0)
                    }
                    
                    newSection += [SearchResultSectionModel(items : list)]
                    
                    observer.onNext(.setSearchList(newSection))
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)
            
            
            return Disposables.create()
        }
    }
}
