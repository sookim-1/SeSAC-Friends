//
//  UIViewController+Ext.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/09.
//

import UIKit

extension UIViewController {
    func windowChangeVC(viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: viewController)
        windowScene.windows.first?.makeKeyAndVisible()
    }
    
    func centerMessageToast(message: String) {
        self.view.makeToast(message, point: self.view.center, title: nil, image: nil, completion: nil)
    }
}
