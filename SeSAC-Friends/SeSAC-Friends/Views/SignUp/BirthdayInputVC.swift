//
//  BirthdayInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit

class BirthdayInputVC: UIViewController {
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(text: "생년월일을 알려주세요", labelList: .birthdayLabel)

    let doneButton: CustomButton = CustomButton(text: "다음")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, textFieldStackView, doneButton])
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var yearTextField = CustomTextField()
    var monthTextField = CustomTextField()
    var dayTextField = CustomTextField()
    var yearLabel = UILabel()
    var monthLabel = UILabel()
    var dayLabel = UILabel()
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearTextField, yearLabel, monthTextField, monthLabel, dayTextField, dayLabel])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configure()
        setUpConstraints()
        setUpNavigationBar()
        doneButton.rx.tap
            .bind {
                self.navigationController?.pushViewController(EmailInputVC(), animated: true)
            }
    }
    
    override func viewDidLayoutSubviews() {
        [yearTextField, monthTextField, dayTextField].forEach { textField in
            textField.textFieldStatus = .inactive
        }
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")

        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.tintColor = .label
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        doneButton.buttonStatus = .disable
        yearLabel.text = "년"
        monthLabel.text = "월"
        dayLabel.text = "일"
        
        yearTextField.setInputViewDatePicker(target: self, selector: #selector(tapYearDone))
        monthTextField.setInputViewDatePicker(target: self, selector: #selector(tapMonthDone))
        dayTextField.setInputViewDatePicker(target: self, selector: #selector(tapDayDone))
        
        yearTextField.becomeFirstResponder()
    }
    
    @objc func tapYearDone() {
        setDatePicker(yearTextField)
        doneButton.buttonStatus = .fill
    }
    @objc func tapMonthDone() {
        setDatePicker(monthTextField)
        doneButton.buttonStatus = .fill
    }
    @objc func tapDayDone() {
        setDatePicker(dayTextField)
        doneButton.buttonStatus = .fill
    }
    
    func setDatePicker(_ sender: UITextField) {
        guard let datePicker = sender.inputView as? UIDatePicker
        else {
            return
        }

        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateFormat = "yyyy"
        self.yearTextField.text = dateformatter.string(from: datePicker.date) //2-4
        dateformatter.dateFormat = "MM"
        self.monthTextField.text = dateformatter.string(from: datePicker.date) //2-4
        dateformatter.dateFormat = "dd"
        self.dayTextField.text = dateformatter.string(from: datePicker.date) //2-4
        
        print(datePicker.date.age)
        if datePicker.date.age >= 17 {
            print("17세이상")
        }
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateformatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        UserDefaults.standard.set(dateformatter.string(from: datePicker.date), forKey: "birthday")
        
        sender.resignFirstResponder()
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    }

