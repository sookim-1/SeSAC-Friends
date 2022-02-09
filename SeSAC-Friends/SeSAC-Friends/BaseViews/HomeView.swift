//
//  HomeView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import SnapKit
import MapKit

final class HomeView: UIView {
    lazy var mapView = MKMapView()
    
    lazy var floatingButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        btn.backgroundColor = .CustomColor.black

        let setImg = UIImage(named: "defaultFloatingImage")
        btn.setImage(setImg, for: .normal)
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 1
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 32
        
        return btn
    }()
    
    lazy var gpsButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .CustomColor.white
        btn.setImage(UIImage(named: "place.png"), for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = false
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowRadius = 3
        btn.layer.shadowOffset = .zero
        
        return btn
    }()
    
    lazy var centerPinImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "map_marker")
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    lazy var customSegmentControl = CustomSegmentControl()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        floatingButton.frame = CGRect(x: self.frame.size.width - 70, y: self.frame.size.height - 100, width: 64, height: 64)
        
        customSegmentControl.frame.size = CGSize(width: 144, height: 144)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(mapView)
        addSubview(gpsButton)
        addSubview(floatingButton)
        addSubview(customSegmentControl)
        addSubview(centerPinImageView)
    }
    
    private func setUpLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gpsButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 48, height: 48))
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(customSegmentControl.snp.bottom).offset(20)
        }
    
        customSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalTo(gpsButton.snp.left)
        }
        
        centerPinImageView.snp.makeConstraints { make in
            make.center.equalTo(mapView.snp.center)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    
}
