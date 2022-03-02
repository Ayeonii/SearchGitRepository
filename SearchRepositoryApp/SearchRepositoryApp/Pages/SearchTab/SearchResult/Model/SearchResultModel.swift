//
//  ResultModel.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import Foundation
import RxDataSources

struct SearchRequestInfo : Encodable {
    var q : String?
    var perPage : String? = "15"
    var page : String? = "1"
    
    init(user : String?, repository : String?) {
        
        var query = ""
        if let userQ = user , !userQ.isEmpty {
            query.append("user:\(userQ)")
        }
        
        if let repoQ = repository, !repoQ.isEmpty {
            query.append("\(repoQ) in:name")
        }
        
        self.q = query
    }
    
}

struct SearchResultModel {
    var id : String
    var repository : String
    var url : String
    var description : String
    
    init(_ data : ResultItems) {
        self.id = data.node_id ?? ""
        self.repository = data.full_name ?? ""
        self.url = data.html_url ?? ""
        self.description = data.description ?? ""
    }
}

extension SearchResultModel: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: Identity {
        return id
    }
    
    static func ==(lhs: SearchResultModel, rhs: SearchResultModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SearchResultSectionModel {
    var items: [Item]
    
    var identity: String {
        return UUID().uuidString
    }
}

extension SearchResultSectionModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = SearchResultModel
    
    init(original: SearchResultSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

struct SearchResultDataSource {
    typealias DataSource = RxTableViewSectionedAnimatedDataSource
    
    static func dataSource() -> DataSource<SearchResultSectionModel> {
        return .init(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .left),
                     configureCell: { dataSource, tableView, indexPath, sectionItem -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
            cell.cellModel = sectionItem
            return cell
        })
    }
}
