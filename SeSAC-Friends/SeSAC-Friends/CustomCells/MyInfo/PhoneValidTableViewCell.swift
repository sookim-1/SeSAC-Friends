//
//  PhoneValidTableViewCell.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit

import SnapKit

class PhoneValidTableViewCell: UITableViewCell {

    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "내 번호 검색 허용"
        lbl.font = UIFont.CustomFont.title2R16
        
        return lbl
    }()
    
    lazy var phoneValidSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(label)
        contentView.addSubview(phoneValidSwitch)
    }
    
    func setUpLayout() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(phoneValidSwitch.snp.left)
        }
        
        phoneValidSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
        }
    }
}
