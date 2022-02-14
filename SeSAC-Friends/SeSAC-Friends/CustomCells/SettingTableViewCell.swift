//
//  SettingTableViewCell.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/02.
//

import UIKit

import SnapKit

class SettingTableViewCell: UITableViewCell {

    var settingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setUpConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.font = UIFont.CustomFont.title2R16
        
        contentView.addSubview(settingImageView)
        contentView.addSubview(label)
    }
    
    private func setUpConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settingImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(settingImageView.snp.width).multipliedBy(1.0 / 1.0)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(settingImageView.snp.right).offset(20)
            make.right.equalTo(contentView.snp.right)
        }
    }
}
