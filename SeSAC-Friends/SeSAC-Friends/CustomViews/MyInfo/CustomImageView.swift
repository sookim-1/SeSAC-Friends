//
//  CustomImageView.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

class CustomImageView: UIImageView {

    var sesacFaceImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sesac_face_1")
        return img
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
        layer.cornerRadius = 10
        addSubview(sesacFaceImageView)
    }
    
    func setUpLayout() {
        sesacFaceImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.4)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
