//
//  ViewController.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/08/25.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//


import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    var timer = Timer()
    //AppDelegateで宣言した変数を使う
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.saveId = Int64(UserDefaults.standard.integer(forKey: "id"))
        appDelegate.time.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        appDelegate.date.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        
        timeLabel.text = "00:00:00"
        button.setTitle("スタート", for: .normal)
    }
    
    
    @IBAction func tapButton(_ sender: Any) {
        if button.tag == 0 {
            appDelegate.activeTimer = true
            button.setTitle("ストップ", for: .normal)
            startTimer()
            button.tag = 1
        } else {
            appDelegate.activeTimer = false
            button.setTitle("スタート", for: .normal)
            stopTimer()
            button.tag = 0
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
        timeInterval: 0.01,
        target: self,
        selector: #selector(timeCount),
        userInfo: nil,
        repeats: true)
        //ここの時点から
        appDelegate.startTime = Date()
    }
    
    @objc func timeCount() {
        
        let currenTime = Date().timeIntervalSince(appDelegate.startTime)
        appDelegate.sec = Int(fmod(currenTime, 60))
        appDelegate.min = Int(fmod((currenTime / 60), 60))
        appDelegate.hour = Int(fmod((currenTime / 3600), 100))
        
        let secString = String(format: "%02d", appDelegate.sec)
        let minString = String(format: "%02d", appDelegate.min)
        let hourString = String(format: "%02d", appDelegate.hour)
        
        timeLabel.text = "\(hourString):\(minString):\(secString)"
    }
    
    func stopTimer() {
        appDelegate.stopTime = Date()
        timer.invalidate()
        timeLabel.text = "00:00:00"
        let saveVC = (storyboard?.instantiateViewController(identifier: "SaveVC"))! as SaveViewController
    
        saveVC.nowDate = appDelegate.date.dateToDate(data: appDelegate.startTime)
        saveVC.startTimeString = appDelegate.time.string(from: appDelegate.startTime)
        saveVC.stopTimeString = appDelegate.time.string(from: appDelegate.stopTime)
        
        self.present(saveVC, animated: true, completion: nil)
    }
    
    
    //MARK: -Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = .mainW
        
        
        
        timeLabel.frame = Enlarge.fullRect(x: 31, y: 267, width: 314, height: 71)
        timeLabel.font = timeLabel.font.withSize(Enlarge.x(x: 70))
        
        button.frame = Enlarge.fullRect(x: 55, y: 448, width: 266, height: 75)
            
        button.layer.cornerRadius = Enlarge.y(y: 38)
            
        button.backgroundColor = .tomato
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Enlarge.x(x: 20))
        button.setTitleColor(.mainW, for: .normal)
        
        var settingButton: UIBarButtonItem!
        settingButton = UIBarButtonItem(title: "設定", style: .plain, target: self, action: #selector(self.setButton))
        settingButton.tintColor = .tomato
        navigationItem.rightBarButtonItem = settingButton
    }
    
    @objc func setButton() {
        let settingVC = (storyboard?.instantiateViewController(identifier: "nav"))! as UINavigationController
        self.present(settingVC, animated: true)
    }
    
}

class Enlarge {
    //enlargeFloat
    class func x(x: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        var magnificationX = CGFloat()
        switch screenWidth {
        case 390:
            magnificationX = 1.04
        case 414:
            magnificationX = 1.104
        case 428:
            magnificationX = 1.141
        default:
            magnificationX = 1
        }
        return x * magnificationX
    }
    
    class func y(y: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        var magnificationY = CGFloat()
        switch screenHeight {
        case 736:
            magnificationY = 1.103
        case 812:
            magnificationY = 1.217
        case 844:
            magnificationY = 1.265
        case 896:
            magnificationY = 1.343
        case 926:
            magnificationY = 1.388
        default:
            magnificationY = 1
        }
        return y * magnificationY
    }
    
    class func rect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {

        return CGRect(
            x: self.x(x: x),
            y: y,
            width: self.x(x: width),
            height: self.y(y: height))
    }
    
    class func fullRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        
        return CGRect(
            x: self.x(x: x),
            y: self.y(y: y),
            width: self.x(x: width),
            height: self.y(y: height))
    }
}


extension DateFormatter {
    func dateToDate(data: Date) -> Date {
        var chedDate = Date()
        chedDate = self.date(from: self.string(from: data))!
        return chedDate
    }
}

/*
 やること
 
 
 
 やりたいこと
 バナー広告
 枠なしテキストフィールド
 累計時間
 
 
 いつどこ
 なにかに打ち込んでいるとき
 だれなぜ
 自制したいけど、なかなかできない人
 行動を記録したい人
 なに
 時間とやったことを記録
 スクリーンタイムの感じ
 
 できたこと
 カウンター
 ラジオボタンでジャンルを分ける
 https://qiita.com/bohebohechan/items/49aa25ed9a24b04619a0
 https://qiita.com/hhddaakk/items/1e0d1e00f013a2b5967a
 coredataの使い方（データを保存）
 indexの検索
 カレンダー
 線の描画の仕方
 ロック中も動く
 タスクキル時に保存
 
 
 やりたいこと
 配列のかぶり要素の個数
    https://ja.stackoverflow.com/questions/53754/%E9%85%8D%E5%88%97%E3%81%8B%E3%82%89%E9%87%8D%E8%A4%87%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E5%9B%9E%E6%95%B0%E3%82%92%E5%87%BA%E5%8A%9B
 https://teratail.com/questions/139896
 indexの検索
 
 日付のかぶりなし個数を数えてその分セクションを作る
 for文で日付ごとに配列に入れる
 
 
 
 整列,近接,強調,反復
 
 文字の大きさ
 20,16,14
 
 メイン　オレンジ?
 トマトR:255 G:99 B:71 良さげ
 白  R:250 G:250 B:250
 黒  R:33 G:33 B:33
 G  R:246 G:246 B:246
 LG R:246 G:246 B:246
 */
