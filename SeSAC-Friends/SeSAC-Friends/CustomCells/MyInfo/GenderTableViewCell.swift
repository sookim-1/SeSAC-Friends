//
//  GenderTableViewCell.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

class GenderTableViewCell: UITableViewCell {

    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "내 성별"
        lbl.font = UIFont.CustomFont.title2R16
        
        return lbl
    }()
    
    lazy var btnStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [manBtn, womanBtn])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    lazy var manBtn = CustomButton(text: "남자")
    lazy var womanBtn = CustomButton(text: "여자")
    
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
        contentView.addSubview(btnStackView)
    }
    
    func setUpLayout() {
        manBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.left.bottom.equalToSuperview()
        }
        womanBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.right.bottom.equalToSuperview()
        }
        
        btnStackView.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.width.equalTo(120)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
            make.right.equalTo(btnStackView.snp.left)
        }
    }
}
