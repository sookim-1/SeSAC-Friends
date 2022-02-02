//
//  AgeTableViewCell.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

class AgeTableViewCell: UITableViewCell {

    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "상대방 연령대"
        lbl.font = UIFont.CustomFont.title2R16
        return lbl
    }()
    
    lazy var ageLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "18 - 65"
        lbl.textColor = .systemGreen
        return lbl
    }()
    
    lazy var ageSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 65
        slider.minimumValue = 18
        slider.value = 1
        
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setUpLayout()
        
        ageSlider.addTarget(self, action: #selector(ageChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(label)
        contentView.addSubview(ageLabel)
        contentView.addSubview(ageSlider)
    }
    
    func setUpLayout() {
        label.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(ageLabel.snp.left)
            make.height.equalTo(contentView).multipliedBy(0.5)
        }
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.top)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(label.snp.height)
        }
        
        ageSlider.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.left.equalTo(label.snp.left)
            make.right.equalTo(ageLabel.snp.right)
        }
    }
    
    @objc func ageChanged() {
        ageLabel.text = "18 - \(Int(ageSlider.value))"
    }
}
