//
//  FindTableViewCell.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/21.
//

import UIKit

import SnapKit

class FindTableViewCell: UITableViewCell {
    let cardView: ExpandableCardView = ExpandableCardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
