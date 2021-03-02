//
//  SaveViewController.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/08/27.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

/*
coredata
NSPersistentContainerでセットアップ
NSPersistentStoreCoordinatorで保存、フェッチ
NSManagedObjectModelは.xcdatamodeldを表す
NSManagedObjectContextで保存、取得

Containerを設定して

var container: NSPersistentContainer!
guard container != nil else {
    fatalError("This view needs a persistent container.")
}
*/

import UIKit
import CoreData

class SaveViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var startTimeString = String()
    var stopTimeString = String()
    var nowDate = Date()
    var memoString: String = ""
    //ジャンル選択ボタン
    var checkedButtonTag: Int = 9
    //フェッチ用
    var id = Int64()
    //保存方法の変更
    var isFirst: Bool = true
    var genreArray: [String] = ["プログラミング", "ギター", "昼寝", "食事", "テレビ", "ゲーム", "ネット"]
    
    //CoreData
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        //タップでキーボードを閉じる
        let tap = UITapGestureRecognizer(target: self, action: #selector(endKeyboard(_:)))
        scrollView.addGestureRecognizer(tap)
        //キーボードにDoneボタンを追加
        setDone()
        //ジャンル
        if UserDefaults.standard.stringArray(forKey: "arr") != nil {
            genreArray = UserDefaults.standard.stringArray(forKey: "arr")!
        }
        
        appDelegate.saveId = Int64(UserDefaults.standard.integer(forKey: "id"))
        
        textView.text = memoString
        let sSec = String(format: "%02d", appDelegate.sec)
        let sMin = String(format: "%02d", appDelegate.min)
        let sHour = String(format: "%02d", appDelegate.hour)
        timeLabel.text = "\(sHour):\(sMin):\(sSec)"
    }
    
    //キーボードを閉じる
    @objc func endKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func butttonClicked(_ sender: Any) {
        //スイッチ文で分岐、画像を変更、選択された値を持つ
        for i in 0...7 {
            guard let view = self.scrollView.subviews[i] as? UIButton else {return}
            if view.tag == checkedButtonTag {
                view.setTitleColor(.mainB, for: .normal)
                view.backgroundColor = .mainLG
            }
        }
        //本当は↓
//        for v in view.subviews {
//            if let v = v as? UIButton, v.tag == checkedButtonTag {
//                v.setTitleColor(.mainB, for: .normal)
//                v.backgroundColor = .mainLG
//            }
//        }
        
        let button = sender as! UIButton
        if button.tag != checkedButtonTag {
            button.setTitleColor(.mainW, for: .normal)
            button.backgroundColor = .tomato
            checkedButtonTag = button.tag
        } else {
            checkedButtonTag = 9
        }
        
    }
    
    
    //MARK: -Save
    //更新するには日付と開始時間で
    @IBAction func save(_ sender: Any) {
        saveData(isFirst: isFirst)
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData(isFirst: Bool) {
        if isFirst {
            //初保存時
            let record = Record(context: self.managedObjectContext)
            record.date = nowDate
            
            if checkedButtonTag <= genreArray.count {
                record.genreString = genreArray[checkedButtonTag - 1]
                record.genre = Int64(checkedButtonTag)
            } else {
                record.genreString = "その他"
                record.genre = 9
            }
            
            memoString = textView.text
            record.memo = memoString
            record.startTime = startTimeString
            record.stopTime = stopTimeString
            record.sec = Int64(appDelegate.sec)
            record.min = Int64(appDelegate.min)
            record.hour = Int64(appDelegate.hour)
            
            record.id = appDelegate.saveId
            appDelegate.saveId += 1
            UserDefaults.standard.set(appDelegate.saveId, forKey: "id")
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        } else {
            //formatを調べる
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
           fetchRequest.predicate = NSPredicate(format: "id = \(id)", id)
            
            //複数の要素で調べる
//            let datePredicate = NSPredicate(format: "date = %@", yDate as CVarArg)
//            let startPredicate = NSPredicate(format: "startTime = %@", startTimer)
//            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, startPredicate])
            
            DispatchQueue.main.async {
                do {
                    
                    let records = try self.managedObjectContext.fetch(fetchRequest) as! [Record]
                    for record in records {
                        self.memoString = self.textView.text
                        record.memo = self.memoString
                        if self.checkedButtonTag <= self.genreArray.count {
                            record.genreString = self.genreArray[self.checkedButtonTag - 1]
                            record.genre = Int64(self.checkedButtonTag)
                        } else {
                            record.genreString = "その他"
                            record.genre = 9
                        }
                    }
                    //recordを詳細ページに渡してページ更新
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
    //MARK: -Keyboard
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
        guard let toolbarHeight = textView.inputAccessoryView?.frame.height else {return}
        let liftY = textView.frame.maxY - keyboardFrame.minY + toolbarHeight
        if liftY > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: liftY + 10), animated: true)
        }
    }
    
    @objc func closeKeyboard() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    //キーボードのdoneボタン
    func setDone() {
        //初期化しないとオートレイアウトの警告が出る
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        let flexibleitem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleitem,doneButton], animated: true)
        textView.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    //MARK: -Layout
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var memoTitle: UILabel!
    @IBOutlet weak var genreTitle: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.backgroundColor = .mainW
        scrollView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.view.safeAreaInsets.top)
        
        genreTitle.frame = Enlarge.rect(x: 29, y: 28, width: 100, height: 16)
        genreTitle.setTitleFont()
        
        timeTitle.frame = Enlarge.rect(x: 29, y: (Enlarge.y(y: 44) + 8) * 4 + Enlarge.x(x: 16) + 52, width: 80, height: 16)
        timeTitle.setTitleFont()
       
        timeLabel.frame = Enlarge.rect(x: 29, y: timeTitle.frame.maxY + 8, width: 191, height: 24)
        timeLabel.setMainFont()
        
        memoTitle.frame = Enlarge.rect(x: 29, y: timeLabel.frame.maxY + 24, width: 40, height: 16)
        memoTitle.setTitleFont()
        
        textView.frame = Enlarge.rect(x: 29, y: memoTitle.frame.maxY + 8, width: 318, height: 84)
        textView.backgroundColor = .mainLG
        textView.layer.cornerRadius = Enlarge.y(y: 4)
        
        saveButton.frame = Enlarge.rect(x: 55, y: textView.frame.maxY + 56, width: 266, height: 75)
        saveButton.layer.cornerRadius = Enlarge.y(y: 38)
        saveButton.backgroundColor = .tomato
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Enlarge.x(x: 20))
        saveButton.setTitleColor(.mainW, for: .normal)
        
        for i in 0...7 {
            guard let button = self.scrollView.subviews[i] as? UIButton else {return}
            button.setGenreButton(array: genreArray)
        }
        
        if isFirst == false {
            guard let button = self.scrollView.subviews[checkedButtonTag - 1] as? UIButton else {return}
            button.setTitleColor(.mainW, for: .normal)
            button.backgroundColor = .tomato
        }
        
    }

}

//MARK: -Extensions
extension SaveViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)
        let newLines = text.components(separatedBy: .newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        return linesAfterChange <= 5 && textView.text.count + (text.count - range.length) <= 100
    }
}

extension UILabel {
    func setTitleFont() {
        self.textColor = .mainG
        self.font = .systemFont(ofSize: Enlarge.x(x: 16))
    }
    
    func setMainFont() {
        self.textColor = .mainB
        self.font = .systemFont(ofSize: Enlarge.x(x: 24))
    }
}

extension UIButton{
    func setGenreButton(array: [String]) {
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        switch self.tag {
        case 3,4:
            y = 1
        case 5,6:
            y = 2
        case 7,8:
            y = 3
        default:
            y = 0
        }
        
        if tag % 2 == 0 {
            x = 192
        } else {
            x = 29
        }
        
        self.frame = CGRect(
            x: Enlarge.x(x: x),
            y: (Enlarge.y(y: 44) + 8) * y + 28 + Enlarge.x(x: 16) + 8,
            width: Enlarge.x(x: 155),
            height: Enlarge.y(y: 44))
        
        if self.tag <= array.count {
            self.setTitle(array[self.tag - 1], for: .normal)
        } else {
            self.setTitle("", for: .normal)
            self.isHidden = true
        }
        
        self.layer.cornerRadius = Enlarge.y(y: 20)
        self.backgroundColor = .mainLG
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: Enlarge.x(x: 16))
        self.setTitleColor(.mainB, for: .normal)
    }
}



