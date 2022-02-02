//
//  BottomView.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

class BottomView: UIView {
    
    // MARK: 새싹타이틀 버튼
    lazy var mannerBtn: CustomButton = CustomButton(text: "좋은 매너")
    lazy var timeCheckBtn: CustomButton = CustomButton(text: "정확한 시간 약속")
    lazy var answerBtn: CustomButton = CustomButton(text: "빠른 응답")
    lazy var kindBtn: CustomButton = CustomButton(text: "친절한 성격")
    lazy var hobbyBtn: CustomButton = CustomButton(text: "능숙한 취미 실력")
    lazy var timeSetBtn: CustomButton = CustomButton(text: "유익한 시간")
    
    lazy var firstBtnStackView: UIStackView = {
        let btnStackView = UIStackView(arrangedSubviews: [mannerBtn, timeCheckBtn])
        btnStackView.axis = .horizontal
        btnStackView.alignment = .fill
        btnStackView.distribution = .fillEqually
        btnStackView.spacing = 2
        
        return btnStackView
    }()
    
    lazy var secondBtnStackView: UIStackView = {
        let btnStackView = UIStackView(arrangedSubviews: [answerBtn, kindBtn])
        btnStackView.axis = .horizontal
        btnStackView.alignment = .fill
        btnStackView.distribution = .fillEqually
        btnStackView.spacing = 2
        
        return btnStackView
    }()
    
    lazy var thirdBtnStackView: UIStackView = {
        let btnStackView = UIStackView(arrangedSubviews: [hobbyBtn, timeSetBtn])
        btnStackView.axis = .horizontal
        btnStackView.alignment = .fill
        btnStackView.distribution = .fillEqually
        btnStackView.spacing = 2
        
        return btnStackView
    }()
    
    lazy var fullBtnStackView: UIStackView = {
        let btnStackView = UIStackView(arrangedSubviews: [firstBtnStackView, secondBtnStackView, thirdBtnStackView])
        btnStackView.axis = .vertical
        btnStackView.alignment = .fill
        btnStackView.distribution = .fillEqually
        btnStackView.spacing = 2
        
        return btnStackView
    }()
    
    // MARK: 레이블
    lazy var sesacTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "새싹 타이틀"
        lbl.font = UIFont.CustomFont.title6R12
        
        return lbl
    }()
    
    lazy var sesacReviewTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "새싹 리뷰"
        lbl.font = UIFont.CustomFont.title6R12
        
        return lbl
    }()
    
    lazy var sesacReviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "첫 리뷰를 기다리는 중이에요!"
        lbl.textColor = .lightGray
        lbl.font = UIFont.CustomFont.body3R14
        
        return lbl
    }()
    
    lazy var fullCardStackView: UIStackView = {
        let cardStackView = UIStackView(arrangedSubviews: [sesacTitleLabel, fullBtnStackView, sesacReviewTitleLabel, sesacReviewLabel])
        cardStackView.axis = .vertical
        cardStackView.alignment = .fill
        cardStackView.distribution = .fillProportionally
        cardStackView.spacing = 15
        
        return cardStackView
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
        addSubview(fullCardStackView)
    }
    
    func setUpLayout() {
        fullCardStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        sesacReviewTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        sesacReviewLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        fullBtnStackView.snp.makeConstraints { make in
            make.height.equalTo(115)
        }
        
        [mannerBtn, timeCheckBtn, answerBtn, kindBtn, hobbyBtn, timeSetBtn].forEach { btn in
            btn.snp.makeConstraints { make in
                make.height.equalTo(37)
            }
        }
    }
}
