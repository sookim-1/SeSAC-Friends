//
//  TabBarVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        tabBar.barTintColor = .clear
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.CustomColor.green
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let homeBarItem = UITabBarItem(title: "홈", image: R.image.homeTapItem(), tag: 0)
        
        let shopVC = UINavigationController(rootViewController: ShopVC())
        let shopBarItem = UITabBarItem(title: "새싹샵", image: R.image.shopTapItem(), tag: 1)
        
        let friendsVC = UINavigationController(rootViewController: FriendsVC())
        let friendsBarItem = UITabBarItem(title: "새싹친구", image: R.image.freindTapItem(), tag: 2)
        
        let mypageVC = UINavigationController(rootViewController: MypageVC())
        let mypageBarItem = UITabBarItem(title: "내정보", image: R.image.myPageTapItem(), tag: 3)
        
        homeVC.tabBarItem = homeBarItem
        shopVC.tabBarItem = shopBarItem
        friendsVC.tabBarItem = friendsBarItem
        mypageVC.tabBarItem = mypageBarItem
        
        self.viewControllers = [homeVC, shopVC, friendsVC, mypageVC]
    }

}
