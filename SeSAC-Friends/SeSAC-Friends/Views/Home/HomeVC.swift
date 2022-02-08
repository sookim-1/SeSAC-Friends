//
//  HomeVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

class HomeVC: BaseVC {
    lazy var genderSegmentControl: UISegmentedControl = {
       let segmentControl = UISegmentedControl(items: ["전체", "남자", "여자"])
        
        segmentControl.selectedSegmentIndex = 1
        segmentControl.tintColor = UIColor.CustomColor.green
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        //segmentControl.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        

        return segmentControl
    }()
    
    lazy var mapView = MKMapView()
    let regionRadius: CLLocationDistance = 1000 // 이 지역은 1000m의 거리에 따라 동서남북 걸쳐있다.
    let locationManager = CLLocationManager()
    
    private let floatingButton: UIButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        let twoLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661)
        
        let threeLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.2846511, longitude: -157.831661)
        //findMyLocation()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        //addCustomPin(coordinate: twoLocation)
        let annotation = AnnotationModel(title: "새싹1", locationName: "전체 3층짜리 건물", discipline: "red", coordinate: twoLocation)
        mapView.addAnnotation(annotation)
        let twoannotation = AnnotationModel(title: "새싹2", locationName: "전체 3층짜리 건물", discipline: "blue", coordinate: threeLocation)
        mapView.addAnnotation(twoannotation)
        
    }
    
    override func viewDidLayoutSubviews() {
        floatingButton.frame = CGRect(x: view.frame.size.width - 70, y: view.frame.size.height - 100, width: 64, height: 64)
    }
    
    override func configure() {
        view.addSubview(mapView)
        view.addSubview(floatingButton)
        
        floatingButton.addTarget(self, action: #selector(tapFloatingButton), for: .touchUpInside)
    }
    
    @objc func tapFloatingButton() {
        print("플로팅 버튼 클릭")
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setUpLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

//    func setupMapView() {
//        var region = MKCoordinateRegion()
//
//        region.center.latitude = location.coordinate.latitude
//        region.center.longitude = location.coordinate.longitude
//
//        region.span.latitudeDelta = 0.01
//        region.span.longitudeDelta = 0.01
//
//        mapView.setRegion(region, animated: false)
//        mapView.showsUserLocation = true
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        mapView.addAnnotation(annotation)
//    }
    
    @objc func segmentValueChanged() {
        print("값변경, \(genderSegmentControl.selectedSegmentIndex)")
    }
    


                        
}
extension UISegmentedControl {
    func goVertical() {
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        for segment in self.subviews {
            for segmentSubview in segment.subviews {
                if segmentSubview is UILabel {
                    (segmentSubview as! UILabel).transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
                }
            }
        }
    }
    func restoreHorizontal() {
        self.transform = CGAffineTransform.identity
        for segment in self.subviews {
            for segmentSubview in segment.subviews {
                if segmentSubview is UILabel {
                    (segmentSubview as! UILabel).transform = CGAffineTransform.identity
                }
            }
        }
    }
}

extension HomeVC: MKMapViewDelegate, CLLocationManagerDelegate {
    private func addCustomPin(coordinate: CLLocationCoordinate2D) {
        // MKAnnotation은 프로토콜이기 떄문에 직접 채택하여 구현해야함
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate
        pin.title = "새싹 영등포캠퍼스"
        pin.subtitle = "전체 3층짜리 건물"
        mapView.addAnnotation(pin)
        
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = AnnotationModel(title: "새싹 영등포캠퍼스", locationName: "전체 3층짜리 건물", discipline: "건물상", coordinate: coordinate)
        mapView.addAnnotation(annotation)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? AnnotationModel else {
//            return nil
//        }
//        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
//
//        var view: MKMarkerAnnotationView
//
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "Custom") as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: -5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
//            annotationView?.canShowCallout = true
//
//
//            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
//            miniButton.tintColor = .blue
//            annotationView?.rightCalloutAccessoryView = miniButton
//
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        //annotationView?.image = UIImage(named: "sesac_face_1")
//
//
//        return annotationView

//    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! AnnotationModel
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    func findMyLocation() {
        guard locationManager.location != nil
        else {
            checkUserLocationServicesAuthorization()
            return
        }
        print(locationManager.location)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
            goSetting()
        case .denied:
            print("denided")
            goSetting()
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("wheninuse")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func goSetting() {
        
        let alert = UIAlertController(title: "위치권한 요청", message: "위치 권한이 필요합니다.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in
            
        }
        
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
}

class CustomAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? AnnotationModel else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = annotation.markerTintColor
            glyphText = String(annotation.discipline.first!)
            glyphImage = UIImage(named: "sesac_face_1")
        }
    }
}
