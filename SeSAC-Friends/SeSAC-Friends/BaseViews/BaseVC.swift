//
//  BaseSignViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import Network
import Toast_Swift

class BaseVC: UIViewController {
    let monitor = NWPathMonitor()
    var checkNetworkValue = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        configure()
        hideKeyboard()
        checkNetworkStart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.checkNetworkValue {
            self.view.makeToast("네트워크 연결이 원활하지 않습니다. 연결상태 확인 후 다시 시도해 주세요!",
                                duration: 1.5,
                                point: view.center,
                                title: nil,
                                image: nil,
                                style: .init()) { _ in
                                    self.checkNetworkStop()
                                }
        }
    }
    
    func checkNetworkStart() {
        self.monitor.start(queue: DispatchQueue.global())
        self.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.checkNetworkValue = true
            } else {
                self.checkNetworkValue = false
            }
        }
    }
    
    func checkNetworkStop() {
        self.monitor.cancel()
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.tintColor = .label
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
