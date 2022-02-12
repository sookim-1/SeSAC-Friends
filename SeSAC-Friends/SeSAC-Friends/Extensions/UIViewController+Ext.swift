//
//  UIViewController+Ext.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/09.
//

import UIKit
import Network
import FirebaseAuth

extension UIViewController {
    func windowChangeVC(viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: viewController)
        windowScene.windows.first?.makeKeyAndVisible()
    }
    
    func centerMessageToast(message: String) {
        self.view.makeToast(message, point: self.view.center, title: nil, image: nil, completion: nil)
    }
    
    func checkNetworkStatus() {
        let monitor = NWPathMonitor()
        
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            if !(path.status == .satisfied) {
                self.centerMessageToast(message: "네트워크 연결이 원활하지 않습니다. 연결상태 확인 후 다시 시도해 주세요!")
            }
            if path.usesInterfaceType(.wifi) {
                print("wifi mode")
            }
            else if path.usesInterfaceType(.cellular) {
                print("cellular mode")
            }
        }
        monitor.cancel()
    }
    
    func refreshIdToken(completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
                           
            if let idToken = idToken {
                completion(.success(idToken))
            }
        }
    }
}
