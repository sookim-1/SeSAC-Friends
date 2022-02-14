//
//  OnboardingCollectionViewCell.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import UIKit

import SnapKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)

    lazy var slideTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: R.font.notoSansKRMedium.fontName, size: 24)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    lazy var slideImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [slideTitleLabel, slideImageView].forEach {
            contentView.addSubview($0)
        }
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = UIImage(named: slide.imageName)
        slideTitleLabel.attributedText = slide.titleText
    }
    
    private func setUpConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        slideTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
            make.top.equalTo(contentView.snp.top).offset(30)
            make.bottom.equalTo(slideImageView.snp.top).offset(-30)
        }
        
        slideImageView.snp.makeConstraints { make in
            make.height.equalTo(slideImageView.snp.width).multipliedBy(1.0 / 1.0)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}
