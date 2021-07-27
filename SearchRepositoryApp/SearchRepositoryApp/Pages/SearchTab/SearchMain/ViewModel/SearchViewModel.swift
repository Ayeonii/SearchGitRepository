//
//  SearchViewModel.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import RxSwift

class SearchViewModel {
    
    func checkUserNameisValid(_ name : String) -> Bool {
        if !name.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
}
