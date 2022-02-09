//
//  CustomSegmentControl.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/10.
//

import UIKit
import SnapKit

protocol CustomSegmentControlDelegate: AnyObject {
    func segmentValueChanged(to index: Int)
}

class CustomSegmentControl: UIView {
    private var buttonTitles: [String] = ["전체", "남자", "여자"]
    private var buttons: [UIButton]!
    
    var textColor: UIColor = .CustomColor.black
    var selectedColor : UIColor = .CustomColor.green
    var selectedIndex: Int = 0
    
    weak var delegate : CustomSegmentControlDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    private func updateView(){
        createBtn()
        configStackView()
    }
    
    private func createBtn(){
        self.buttons = [UIButton]()
        self.buttons.removeAll()
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        for bunttonTitleItem in buttonTitles {
            let button = UIButton()
            button.backgroundColor = .CustomColor.white
            button.titleLabel?.textColor = .CustomColor.black
            button.titleLabel?.font = .CustomFont.title4R14
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            button.setTitle(bunttonTitleItem, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(CustomSegmentControl.buttonAction(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        buttons[0].setTitleColor(.CustomColor.white, for: .normal)
        buttons[0].backgroundColor = selectedColor
    }
    
    private func configStackView(){
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true
        self.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func buttonAction(_ sender: UIButton){
        for(buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                self.selectedIndex = buttonIndex
                delegate?.segmentValueChanged(to: self.selectedIndex)
                btn.backgroundColor = selectedColor
                btn.setTitleColor(.white, for: .normal)
            } else {
                btn.backgroundColor = .white
                btn.setTitleColor(textColor, for: .normal)
            }
        }
        print("selectedIndex : \(self.selectedIndex)")
    }
    
}
