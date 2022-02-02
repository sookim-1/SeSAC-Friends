//
//  BottomTitleView.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

class BottomTitleView: UIView {

    lazy var label = UILabel()
    lazy var arrowBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "arrow_down"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        label.text = "김새싹"
        label.font = UIFont.CustomFont.title1M16
        
        addSubview(label)
        addSubview(arrowBtn)
    }
    
    func setUpLayout() {
        arrowBtn.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.width.equalTo(arrowBtn.snp.height).multipliedBy(1.0 / 1.0)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(arrowBtn.snp.left)
        }
    }
}
