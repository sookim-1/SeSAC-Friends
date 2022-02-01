//
//  ProfileTableViewCell.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {

    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sesacFace")
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
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.CustomColor.gray3.cgColor
        profileImageView.layer.cornerRadius = contentView.frame.width * 0.2 / 2
        
        label.font = UIFont.CustomFont.title1M16
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
    }
    
    private func setUpConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
            make.height.equalTo(profileImageView.snp.width).multipliedBy(1.0 / 1.0)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(profileImageView.snp.right).offset(20)
            make.right.equalTo(contentView.snp.right)
        }
    }
}
