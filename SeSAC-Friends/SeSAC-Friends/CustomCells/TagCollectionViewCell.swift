//
//  TagCollectionViewCell.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/15.
//

import UIKit

import SnapKit

class TagCollectionViewCell: UICollectionViewCell {
    lazy var recommendLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .CustomFont.title4R14
        lbl.textColor = .CustomColor.black
        
        return lbl
    }()
    
    lazy var deleteButton: DeleteButton = {
        let btn = DeleteButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendLabel, deleteButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(stackView)
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = recommendLabel.frame.size.height / 2.0
        self.backgroundColor = .lightGray
        self.recommendLabel.textColor = .white
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
        
        recommendLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.right.equalTo(deleteButton.snp.left)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
