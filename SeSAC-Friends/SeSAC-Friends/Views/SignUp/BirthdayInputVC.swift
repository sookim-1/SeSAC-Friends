//
//  BirthdayInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import RxSwift
import RxCocoa

final class BirthdayInputVC: BaseVC {
    
    private let mainView = BirthdayInputView()
    private var age = 0
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.yearTextField.setInputViewDatePicker(target: self, selector: #selector(tapYearDone))
        mainView.monthTextField.setInputViewDatePicker(target: self, selector: #selector(tapMonthDone))
        mainView.dayTextField.setInputViewDatePicker(target: self, selector: #selector(tapDayDone))
        
        mainView.yearTextField.becomeFirstResponder()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        [mainView.yearTextField, mainView.monthTextField, mainView.dayTextField].forEach { textField in
            textField.textFieldStatus = .inactive
        }
    }
    
    @objc func tapYearDone() {
        setDatePicker(mainView.yearTextField)
        mainView.doneButton.buttonStatus = .fill
    }
    @objc func tapMonthDone() {
        setDatePicker(mainView.monthTextField)
        mainView.doneButton.buttonStatus = .fill
    }
    @objc func tapDayDone() {
        setDatePicker(mainView.dayTextField)
        mainView.doneButton.buttonStatus = .fill
    }
    
    private func setDatePicker(_ sender: UITextField) {
        guard let datePicker = sender.inputView as? UIDatePicker
        else {
            return
        }

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy"
        self.mainView.yearTextField.text = dateformatter.string(from: datePicker.date)
        dateformatter.dateFormat = "MM"
        self.mainView.monthTextField.text = dateformatter.string(from: datePicker.date)
        dateformatter.dateFormat = "dd"
        self.mainView.dayTextField.text = dateformatter.string(from: datePicker.date)
        
        age = datePicker.date.age
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateformatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        UserDefaults.birthday = dateformatter.string(from: datePicker.date)
        
        sender.resignFirstResponder()
    }
    
    private func bind() {
        mainView.doneButton.rx.tap
            .bind {
                if !(self.age >= 17) {
                    self.centerMessageToast(message: "새싹친구는 만17세 이상만 사용할 수 있습니다.")
                } else {
                    self.navigationController?.pushViewController(EmailInputVC(), animated: true)
                }
            }
    }
}

