//
//  GenderVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import RxCocoa
import RxSwift

final class GenderVC: BaseVC {

    private var genderIndex: Int = -1
    private let mainView = GenderView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.doneButton.addTarget(self, action: #selector(authComplete), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        mainView.manView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap2(sender:)))
        mainView.womanView.addGestureRecognizer(tapGesture2)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        mainView.manView.backgroundColor = UIColor.CustomColor.green.withAlphaComponent(0.5)
        if mainView.womanView.backgroundColor == UIColor.CustomColor.green.withAlphaComponent(0.5) {
            mainView.womanView.backgroundColor = .clear
        }
        genderIndex = 1
        mainView.doneButton.buttonStatus = .fill
        print("man")
        
    }
    @objc func handleTap2(sender: UITapGestureRecognizer) {
        mainView.womanView.backgroundColor = UIColor.CustomColor.green.withAlphaComponent(0.5)
        if mainView.manView.backgroundColor == UIColor.CustomColor.green.withAlphaComponent(0.5) {
            mainView.manView.backgroundColor = .clear
        }
        genderIndex = 0
        mainView.doneButton.buttonStatus = .fill
        print("woman")
    }
    
    
    @objc func authComplete() {
        SignUpService.shared.postSignUp(gender: genderIndex) { response in
            switch response.response?.statusCode {
            case 200:
                UserDefaults.isUser = true
                print("성공")
                switch response.result {
                case .success(let response):
                    print("\(response)")
                    self.windowChangeVC(viewController: TabBarVC())
                case .failure(let error):
                    print("get user error: \(error)")
                }
            case 201:
                UserDefaults.isUser = true
                print("이미 가입한 유저입니다.")
                self.view.makeToast("이미 등록된 회원입니다.", point: self.view.center, title: nil, image: nil) { didTap in
                    self.windowChangeVC(viewController: TabBarVC())
                }
            case 202:
                print("사용할 수 없는 닉네임입니다.")
                self.view.makeToast("사용할 수 없는 닉네임입니다.", point: self.view.center, title: nil, image: nil) { didTap in
                    self.navigationController?.popToRootViewController(animated: true) // 닉네임화면으로 이동
                }
            case 401:
                print("파이어베이스 토큰만료")
            case 500:
                print("서버에러")
            case 501:
                print("클라이언트에러")
            default:
                print("에러")
            }
        }
    }
    
    
}
