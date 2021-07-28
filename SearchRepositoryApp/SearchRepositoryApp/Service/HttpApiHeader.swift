//
//  HttpApiHeader.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import Foundation
import Alamofire

struct HttpApiHeader {
    
    public static func headers() -> HTTPHeaders {
        let headers : HTTPHeaders = ["Accept": "application/vnd.github.v3+json"]
        return headers
    }
    
}
