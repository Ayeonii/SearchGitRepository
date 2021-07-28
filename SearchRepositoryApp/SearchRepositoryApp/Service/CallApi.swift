//
//  CallApi.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import Foundation
import RxSwift

class CallApi {
    
    open class func callSearchApi(request : SearchRequestInfo) -> Observable<SearchResultCodable> {
        
        return Observable.create{ observer -> Disposable in
            
            let apiUrl = "https://api.github.com/search/repositories"
        
            HttpAPIManager.call(api: apiUrl, method: .get, encodable : request, headers: HttpApiHeader.headers(), responseClass: SearchResultCodable.self) { (result, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let res = result{
                        observer.onNext(res)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}
