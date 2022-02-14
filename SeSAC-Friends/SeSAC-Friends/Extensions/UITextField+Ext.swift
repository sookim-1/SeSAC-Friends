//
//  UITextField+Ext.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit

import AnyFormatKit

extension UITextField {
    func formatPhoneNumber(range: NSRange, string: String) {
        
        guard let text = self.text else {
            return
        }
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return
        }
        
        let formatter = DefaultTextInputFormatter(textPattern: "###-####-####")
        let result = formatter.formatInput(currentText: text, range: range, replacementString: string)
        self.text = result.formattedText
        let position = self.position(from: self.beginningOfDocument, offset: result.caretBeginOffset)!
        self.selectedTextRange = self.textRange(from: position, to: position)

    }
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date

        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.locale = Locale(identifier: "ko-KR")
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
