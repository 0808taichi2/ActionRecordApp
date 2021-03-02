//
//  SettingViewController.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/10/19.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var genreArray: [String] = ["プログラミング", "ギター", "昼寝", "食事", "テレビ", "ゲーム", "ネット"]
    
    var activeTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endKeyboard(_:)))
        scrollView.addGestureRecognizer(tap)
        
        if UserDefaults.standard.stringArray(forKey: "arr") != nil {
            genreArray = UserDefaults.standard.stringArray(forKey: "arr")!
        }
        
        for i in 0...7 {
            guard let view = self.scrollView.subviews[i] as? UITextField else {return}
            view.delegate = self
            if view.tag <= genreArray.count {
                view.text = genreArray[view.tag - 1]
            }
        }
    }
    
    
    //MARK: -Keyboard
    //キーボードを閉じる
    @objc func endKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(openKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func openKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {return}
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        //textFieldの底の座標とキーボードの上の座標の差分上げる
        let liftY = activeTextField.frame.maxY - keyboardFrame.minY + self.view.safeAreaInsets.top
        if liftY > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: liftY + 10), animated: true)
        }
    }
    
    @objc func closeKeyboard() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    //MARK: -Layout
    override func viewDidLayoutSubviews() {
        setBarItem()
        
        scrollView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.view.safeAreaInsets.top)
        scrollView.backgroundColor = .mainW
        
        for i in 0...7 {
            guard let view = self.scrollView.subviews[i] as? UITextField else {return}
            view.placeholder = "やったこと\(view.tag)"
            view.frame = CGRect(
                x: ((UIScreen.main.bounds.width) / 2) - Enlarge.x(x: 166),
                y: 28 + (Enlarge.y(y: 34) + 24) * CGFloat(i),
                width: Enlarge.x(x: 332),
                height: Enlarge.y(y: 34))
//                CGRect(
//                x: (Int(UIScreen.main.bounds.width) / 2) - 166,
//                y: 28 + (58 * i),
//                width: 332,
//                height: 34)
        }
    }
    
    
    //MARK: -BarButtonItem
    func setBarItem() {
        var saveButton: UIBarButtonItem!
        saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(save))
        saveButton.tintColor = .tomato
        navigationItem.rightBarButtonItem = saveButton
        
        var backButton: UIBarButtonItem!
        backButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(back))
        backButton.tintColor = .tomato
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "やったこと"
    }
    
    @objc func save() {
        var array: [String] = []
        for i in 0...7 {
            guard let view = self.scrollView.subviews[i] as? UITextField else {return}
            if view.text != "" {
                guard let text = view.text else {return}
                array.append(text)
            }
        }
        UserDefaults.standard.set(array, forKey: "arr")
        dismiss(animated: true, completion: nil)
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: -TextFieldDelegate
extension SettingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField.resignFirstResponder()
        return true
    }
}
