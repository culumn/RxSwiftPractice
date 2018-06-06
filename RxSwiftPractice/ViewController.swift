//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by Matsuoka Yoshiteru on 2018/06/06.
//  Copyright © 2018年 culumn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: Lifecycle
final class ViewController: UIViewController {

    @IBOutlet weak var strTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!

    let disposeBag = DisposeBag()

    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 38))
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: nil,
                                            action: nil)
        doneBarButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        toolbar.setItems([flexBarButton, doneBarButton], animated: false)

        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextFields()
    }
}

// MARK: - Helper
extension ViewController {

    func configureTextFields() {
        configureStrTextField()
        configureGenderTextField()
    }

    func configureStrTextField() {
        let strPickerView = UIPickerView()
        strTextField.inputView = strPickerView
        strTextField.inputAccessoryView = toolbar

        let strs = ["abc", "def", "ghi"]
        Observable.just(strs)
            .bind(to: strPickerView.rx.itemTitles) { _, str in
                return str
            }
            .disposed(by: disposeBag)
        strPickerView.rx.modelSelected(String.self)
            .map { strs in
                return strs.first
            }
            .bind(to: strTextField.rx.text)
            .disposed(by: disposeBag)
    }

    func configureGenderTextField() {
        let genderPickerView = UIPickerView()
        genderTextField.inputView = genderPickerView
        genderTextField.inputAccessoryView = toolbar

        Observable.just(Gender.all)
            .bind(to: genderPickerView.rx.itemTitles) { _, gender in
                return gender.text
            }
            .disposed(by: disposeBag)
        genderPickerView.rx.modelSelected(Gender.self)
            .map { genders in
                return genders.first?.text
            }
            .bind(to: genderTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard textField.inputView as? UIPickerView == nil else {
            return false
        }

        return true
    }
}
