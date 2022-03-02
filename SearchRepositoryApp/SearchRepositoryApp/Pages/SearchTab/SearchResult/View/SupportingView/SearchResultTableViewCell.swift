//
//  SearchResultTableViewCell.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var cellModel : SearchResultModel? {
        didSet{
            if let data = cellModel {
                self.descLabel.text = data.description
                self.nameLabel.text = data.repository
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
