//
//  ExpandableCardView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/21.
//

import UIKit

class ExpandableCardView: UIView {

    // 배경 이미지뷰
    lazy var backgroundImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sesac_background_1")
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        
        return img
    }()

    // 새싹 프로필 이미지뷰
    lazy var sesacImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sesac_face_1")
        
        return img
    }()
    
    // 요청하기, 수락하기 버튼
    lazy var decisionButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .CustomFont.title3M14
        btn.backgroundColor = .CustomColor.error
        btn.setTitle("요청하기", for: .normal)
        
        return btn
    }()
    
    
    // 바텀뷰
    private let bottomView = CardBottomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(backgroundImageView)
        addSubview(sesacImageView)
        addSubview(decisionButton)
        addSubview(bottomView)
        
        bottomView.layer.cornerRadius = 8
        decisionButton.addTarget(self, action: #selector(touchDecisionButton), for: .touchUpInside)
    }
    
    func setUpLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(200)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImageView.snp.centerX)
            make.height.equalTo(backgroundImageView.snp.height).multipliedBy(0.8)
            make.width.equalTo(sesacImageView.snp.height)
            make.bottom.equalTo(backgroundImageView.snp.bottom)
        }
        
        decisionButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.equalTo(backgroundImageView.snp.top).offset(12)
            make.right.equalTo(backgroundImageView.snp.right).offset(-12)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView.snp.left)
            make.right.equalTo(backgroundImageView.snp.right)
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func touchDecisionButton() {
        print("터치")
    }
}

class CardBottomView: UIView {
    lazy var titleLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "뭉치뭉치" // 닉네임
        lbl.font = .CustomFont.title1M16
        return lbl
    }()
    
    lazy var arrowButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        btn.setImage(UIImage(systemName: "arrow.down"), for: .selected)
        
        btn.tintColor = .CustomColor.gray4
        return btn
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLable, arrowButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        return stackView
    }()
    
    // 서브 제목
    
    lazy var sesacTitleLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "새싹 타이틀"
        lbl.font = .CustomFont.title6R12
        return lbl
    }()
    
    lazy var titleView = TitleView()
    
    lazy var hobbyLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "하고 싶은 취미"
        lbl.font = .CustomFont.title6R12
        return lbl
    }()
    
    lazy var hobbyView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        
        return view
    }()
    
    lazy var sesacReviewLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "새싹 리뷰"
        lbl.font = .CustomFont.title6R12
        return lbl
    }()
    
    lazy var reviewView: UITextView = {
        let view = UITextView()
        view.text = "첫 리뷰를 기다리는 중이에요!"
        view.textColor = .CustomColor.gray6
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        addSubview(titleStackView)
        addSubview(sesacTitleLable)
        addSubview(titleView)
        addSubview(hobbyLable)
        addSubview(hobbyView)
        addSubview(sesacReviewLable)
        addSubview(reviewView)
    }
    
    func setUpLayout() {
        titleLable.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(arrowButton.snp.left)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(16)
            make.right.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        sesacTitleLable.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
        }
        
        titleView.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(sesacTitleLable.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(50).priority(.low)
        }
        
        hobbyLable.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(titleView.snp.bottom)
        }
        
        hobbyView.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(hobbyLable.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(50).priority(.high)
        }
        
        sesacReviewLable.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(hobbyView.snp.bottom)
        }
        
        reviewView.snp.makeConstraints { make in
            make.left.equalTo(titleStackView.snp.left)
            make.right.equalTo(titleStackView.snp.right)
            make.top.equalTo(sesacReviewLable.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

class TitleView: UIView {
    lazy var mannerButton: CustomButton = CustomButton(text: "좋은 매너")
    lazy var clockButton: CustomButton = CustomButton(text: "정확한 시간 약속")
    lazy var fastButton: CustomButton = CustomButton(text: "빠른 응답")
    lazy var kindButton: CustomButton = CustomButton(text: "친절한 성격")
    lazy var hobbyButton: CustomButton = CustomButton(text: "능숙한 취미 실력")
    lazy var timeButton: CustomButton = CustomButton(text: "유익한 시간")
    
    var buttons: [CustomButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        buttons = [mannerButton, clockButton, fastButton, kindButton, hobbyButton, timeButton]
        
        buttons.forEach { btn in
            addSubview(btn)
            btn.buttonStatus = .inactive
        }
    }
    
    func setUpLayout() {
        // 1
        mannerButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalTo(clockButton.snp.left).offset(-20)
        }
        
        clockButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(mannerButton.snp.width)
        }
        
        // 2
        fastButton.snp.makeConstraints { make in
            make.left.equalTo(mannerButton.snp.left)
            make.top.equalTo(mannerButton.snp.bottom).offset(20)
            make.right.equalTo(kindButton.snp.left).offset(-20)
            make.width.equalTo(mannerButton.snp.width)
        }
        
        kindButton.snp.makeConstraints { make in
            make.right.equalTo(clockButton.snp.right)
            make.top.equalTo(fastButton.snp.top)
            make.width.equalTo(mannerButton.snp.width)
        }
        
        // 3
        hobbyButton.snp.makeConstraints { make in
            make.left.equalTo(mannerButton.snp.left)
            make.top.equalTo(fastButton.snp.bottom).offset(20)
            make.right.equalTo(timeButton.snp.left).offset(-20)
            make.width.equalTo(mannerButton.snp.width)
            make.bottom.equalToSuperview()
        }
        
        timeButton.snp.makeConstraints { make in
            make.right.equalTo(kindButton.snp.right)
            make.top.equalTo(hobbyButton.snp.top)
            make.bottom.equalTo(hobbyButton.snp.bottom)
            make.width.equalTo(mannerButton.snp.width)
        }
    }
}
