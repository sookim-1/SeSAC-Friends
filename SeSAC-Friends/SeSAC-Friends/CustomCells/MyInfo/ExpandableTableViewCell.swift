//
//  ExpandableTableViewCell.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit
class ExpandableTableViewCell: UITableViewCell {
    
    lazy var customImageView = CustomImageView(frame: .zero)
    lazy var bottomTitleView = BottomTitleView(frame: .zero)
    var bottomView = BottomView(frame: .zero) {
        didSet {
            bottomView.isHidden = true
        }
    }
    
    lazy var cellHeaderView = UIView()
    
    lazy var fullStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerStackView, bottomView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [customImageView, bottomTitleView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(fullStackView)
    }
    
    func setUpLayout() {
        fullStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(220)
            make.left.right.equalTo(contentView)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.left.right.equalTo(contentView)
        }
        
        customImageView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.top.equalTo(headerStackView.snp.top)
        }
        
        bottomTitleView.snp.makeConstraints { make in
            make.bottom.equalTo(headerStackView.snp.bottom)
            make.height.equalTo(customImageView.snp.height)
            make.top.equalTo(customImageView.snp.bottom)
        }
    }
}
