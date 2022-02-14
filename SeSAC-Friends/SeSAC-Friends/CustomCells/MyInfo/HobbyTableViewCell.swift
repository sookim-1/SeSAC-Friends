//
//  HobbyTableViewCell.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit

import SnapKit

class HobbyTableViewCell: UITableViewCell {

    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "자주 하는 취미"
        lbl.font = UIFont.CustomFont.title2R16
        
        return lbl
    }()
    lazy var textField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "취미를 입력해 주세요"
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        textField.textFieldStatus = .inactive
    }
    
    func configure() {
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }
    
    func setUpLayout() {
        textField.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.width.equalTo(180)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
        }
    }
}
