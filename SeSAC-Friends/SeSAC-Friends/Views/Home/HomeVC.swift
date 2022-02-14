//
//  HomeVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import MapKit
import CoreLocation
import UIKit

import SwiftyJSON

final class HomeVC: BaseVC, CustomSegmentControlDelegate {
    
    // MARK: - 프로퍼티
    private let mainView = HomeView()
    private let locationManager = CLLocationManager()
    private let regionInMeters: Double = 700
    private var previousLocation: CLLocation?
    private var onQueueArray: [FromQueueDB] = []
    private var filterdArray: [FromQueueDB] = []
    
    // MARK: - 뷰컨트롤러 생명주기
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        mainView.mapView.delegate = self
        mainView.customSegmentControl.delegate = self
        setUpButtonEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkNetworkStatus()
        checkLocationServices()
    }
    
    // MARK: - 버튼 이벤트
    private func setUpButtonEvent() {
        mainView.floatingButton.addTarget(self, action: #selector(touchUpFloatingButton), for: .touchUpInside)
        mainView.gpsButton.addTarget(self, action: #selector(touchUpGpsButton), for: .touchUpInside)
    }
    @objc private func touchUpFloatingButton() {
        self.navigationController?.pushViewController(HobbyVC(), animated: true)
    }

    @objc private func touchUpGpsButton() {
        print("touchUpGpsButton")
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            centerMessageToast(message: "GPS기능을 사용할 수 없어요")
        }
    }
    
    func segmentValueChanged(to index: Int) {
        onQueueNetworking { [self] result in
            switch result {
            case .success(let value):
                if value == true {
                    switch index {
                    case 0:
                        self.centerMessageToast(message: "전체클릭")
                        
                        self.mainView.mapView.removeAnnotations(self.mainView.mapView.annotations)
                        self.addCustomPin()
                    case 1:
                        self.centerMessageToast(message: "남자클릭")
                        
                        self.onQueueArray.enumerated().forEach {
                            if $0.1.gender == 1 {
                                self.filterdArray.append($0.1)
                            }
                        }
                        
                        self.onQueueArray = []
                        self.onQueueArray = self.filterdArray
                        self.filterdArray = []
                        print("남자클릭 필터링 한 배열\(self.onQueueArray)")
                        
                        self.mainView.mapView.removeAnnotations(self.mainView.mapView.annotations)
                        print("\(self.mainView.mapView.annotations)")
                        self.addCustomPin()
                        
                        print("\(self.mainView.mapView.annotations)")
                        
                    case 2:
                        self.centerMessageToast(message: "여자클릭")
                        
                        self.onQueueArray.enumerated().forEach {
                            if $0.1.gender == 0 {
                                self.filterdArray.append($0.1)
                            }
                        }
                        
                        self.onQueueArray = []
                        self.onQueueArray = self.filterdArray
                        self.filterdArray = []
                        
                        print("여자클릭 필터링 한 배열\(self.onQueueArray)")
                        
                        self.mainView.mapView.removeAnnotations(self.mainView.mapView.annotations)
                        print(self.mainView.mapView.annotations)
                        self.addCustomPin()
                        
                        print(self.mainView.mapView.annotations)
                    default:
                        break
                    }
                }
            default:
                print("필터링")
            }
        }
        
    }
    
    // MARK: - Mapview 세팅
    private func addCustomPin() {
        for i in onQueueArray.enumerated() {
            let pin = CustomAnnotation()
            pin.title = "\(i.element.nick)"
            pin.coordinate = CLLocationCoordinate2D(latitude: i.element.lat, longitude: i.element.long)
            pin.index = i.offset
            
            mainView.mapView.addAnnotation(pin)
        }
    }
    
    // MARK: - 위치권한
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 위치의 정확도 설정
    }
    
    private func centerViewOnUserLocation() {
        self.previousLocation = locationManager.location
        if let location = locationManager.location?.coordinate {
            // 지도가 보이는 반경 및 위치를 지정하기
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            let tempRegion = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mainView.mapView.setRegion(tempRegion, animated: true)
        }
    }
    
    private func checkLocationServices() {
        // 위치 서비스 활성화 상태여부 확인 - GPS기능을 사용할 수 있는지 (위치권한이 아님)
        if CLLocationManager.locationServicesEnabled() {
            // 위치서비스 활성화 중에서도 세부적인 여부를 확인가능합니다.
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            centerMessageToast(message: "GPS기능을 사용할 수 없어요")
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationAuthorizationStatus() {
        case .authorizedAlways:
            // 항상 권한 허용
            
            startTrackingUserLocation()
            print("authorizedAlways")
            break
        case .denied:
            // 위치권한이 거부된 경우
            centerMessageToast(message: "위치권한을 허용해주세요")
            locationSettingAlert()
            break
        case .notDetermined:
            // 결정이 안된 경우
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // 자녀보호 기능으로 제한 되어있는 경우
            centerMessageToast(message: "위치기능이 제한되어 있어요")
            break
        case .authorizedWhenInUse:
            // 앱 사용시 권한 허용
            startTrackingUserLocation()
            break
        @unknown default:
            break
        }
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("unknown")
            }
        }
    }
    
    private func locationAuthorizationStatus() -> CLAuthorizationStatus {
        var locationAuthorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus = locationManager.authorizationStatus
        } else {
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        return locationAuthorizationStatus
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func startTrackingUserLocation() {
        mainView.mapView.showsUserLocation = true // 지도에 사용자 위치 파란 점으로 표시하기 여부
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation() // didUpdateLocations메서드를 수행할 수 있도록 하는 메서드
        previousLocation = getCenterLocation(for: mainView.mapView)
        onQueueNetworking { _ in
            
            print("유저 트래킹 배열\(self.onQueueArray)")
        }
    }
    
    // MARK: - Helper
    private func locationSettingAlert() {
        let alert = UIAlertController(title: "위치권한 요청", message: "위치 권한이 필요합니다. 설정창으로 이동하시겠습니까?", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정하기", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(settingAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    private func setUpAnnotationImage(sesacIndex: Int) -> UIImage? {
        switch sesacIndex {
        case 0:
            return R.image.sesac_face_1()
        case 1:
            return R.image.sesac_face_2()
        case 2:
            return R.image.sesac_face_3()
        case 3:
            return R.image.sesac_face_4()
        case 4:
            return R.image.sesac_face_5()
        default:
            return R.image.sesac_face_1()
        }
    }
    
    
    // MARK: - Networking
    private func calculateRegion(region: CLLocationCoordinate2D) -> Int {
        let regionLatitude = region.latitude + 90
        let regionLongtitude = region.longitude + 180
        
        let removeDotLatitude = String(regionLatitude).replacingOccurrences(of: ".", with: "")
        let removeDotLongtitue = String(regionLongtitude).replacingOccurrences(of: ".", with: "")
        
        return Int((removeDotLatitude.prefix(5) + removeDotLongtitue.prefix(5)))!
    }
    
    private func onQueueNetworking(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let previousLocation = previousLocation else {
            return
        }

        let model: OnQueue = OnQueue(region: calculateRegion(region: previousLocation.coordinate), lat: previousLocation.coordinate.latitude, long: previousLocation.coordinate.longitude)
        let tempModel: OnQueue = OnQueue(region: 1275130688, lat: 37.517819364682694, long: 126.88647317074734)
        dump(model)
        HomeService.shared.postOnQueue(model: tempModel) { response in
            switch response.response?.statusCode {
            case 200:
                print("성공")
                switch response.result {
                case .success(let response):
                    print("네트워크 리스폰스\(response)")
                    self.onQueueArray = []
                    self.onQueueArray += response.fromQueueDB
                    self.onQueueArray += response.fromQueueDBRequested
                    completion(.success(true))
                    //self.addCustomPin()
                case .failure(let error):
                    print("get user error: \(error)")
                }
                break
            case 401:
                print("파이어베이스 토큰만료")
                self.refreshIdToken { result in
                    switch result {
                    case .success(let idToken):
                        UserDefaults.idToken = idToken
                        self.onQueueNetworking { _ in
                            print("토큰갱신")
                            completion(.success(false))
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                break
            case 406:
                print("미가입 회원입니다.")
                break
            case 500:
                print("서버에러")
                break
            case 501:
                print("클라이언트에러")
                break
            default:
                print("에러")
                break
            }
        }

    }
    
}

extension HomeVC: CLLocationManagerDelegate {
    // iOS 14.0 이상에서 사용자가 권한 부여를 변경하는 시점에 호출
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // iOS 14.0 이하에서 사용자가 권한 부여 변경하는 시점에 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension HomeVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder() // geo = 지리
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return } // 반경 거리 제한
        self.previousLocation = center
        print("center: \(center)")
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                self.centerMessageToast(message: "에러가 발생했습니다. 반경을 벗어났습니다.")
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.centerMessageToast(message: "마크표시 에러가 발생했습니다.")
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            print("streetNumber\(streetNumber) streetName: \(streetName)")
        }
    }
    
    // MARK: Custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // pin을 보여주는 뷰가 지도에 여러개가 있을 수 있으므로 효율성을 위해 테이블뷰 방식처럼 재사용뷰 생성
        
        // 사용자의 위치 확인
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        print("어노테이션?: \(annotation.description)")
        
        let annotationIdentifier = "Custom"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            if let annotation = annotation as? CustomAnnotation {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView?.canShowCallout = true

                // 이미지 리사이징
                let pinImage = setUpAnnotationImage(sesacIndex: onQueueArray[annotation.index].sesac)
                annotation.title = onQueueArray[annotation.index].nick
                let size = CGSize(width: 80, height: 80)
                UIGraphicsBeginImageContext(size)
                pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                annotationView?.image = resizedImage
            }
            
        }
        else {
            //annotationView?.image = nil
            annotationView?.annotation = annotation
            
        }
        return annotationView
    }
}

class CustomAnnotation: MKPointAnnotation {
    var index: Int!
}
