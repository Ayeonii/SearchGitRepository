//
//  ResultModel.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import Foundation

struct SearchRequestInfo {
    var user : String
    var repository : String?
    
    init(user : String, repository : String?) {
        self.user = user
        self.repository = repository
    }
}

struct SearchResultModel {
    var user : String
    var repository : String
    var url : String
    var description : String
    
  
}

