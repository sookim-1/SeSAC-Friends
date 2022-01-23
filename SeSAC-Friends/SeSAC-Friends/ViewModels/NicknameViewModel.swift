//
//  NicknameViewModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class NicknameViewModel {
    var nicknameText = BehaviorRelay<String>(value: "")
    var nicknameValid = BehaviorRelay<Bool>(value: false)
}
