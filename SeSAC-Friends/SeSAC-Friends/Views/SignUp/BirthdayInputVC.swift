//
//  BirthdayInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//
import UIKit
import RxSwift
import RxCocoa

class BirthdayInputVC: BaseSignVC {
    
    let mainView = BirthdayInputView()
    var age = 0
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.yearTextField.setInputViewDatePicker(target: self, selector: #selector(tapYearDone))
        mainView.monthTextField.setInputViewDatePicker(target: self, selector: #selector(tapMonthDone))
        mainView.dayTextField.setInputViewDatePicker(target: self, selector: #selector(tapDayDone))
        
        mainView.yearTextField.becomeFirstResponder()
        mainView.doneButton.rx.tap
            .bind {
                if !(self.age >= 17) {
                    self.view.makeToast("새싹친구는 만17세 이상만 사용할 수 있습니다.")
                } else {
                    self.navigationController?.pushViewController(EmailInputVC(), animated: true)
                }
            }
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
    
    func setDatePicker(_ sender: UITextField) {
        guard let datePicker = sender.inputView as? UIDatePicker
        else {
            return
        }

        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateFormat = "yyyy"
        self.mainView.yearTextField.text = dateformatter.string(from: datePicker.date) //2-4
        dateformatter.dateFormat = "MM"
        self.mainView.monthTextField.text = dateformatter.string(from: datePicker.date) //2-4
        dateformatter.dateFormat = "dd"
        self.mainView.dayTextField.text = dateformatter.string(from: datePicker.date) //2-4
        
        age = datePicker.date.age
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateformatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        UserDefaults.birthday = dateformatter.string(from: datePicker.date)
        
        sender.resignFirstResponder()
    }
    

}

