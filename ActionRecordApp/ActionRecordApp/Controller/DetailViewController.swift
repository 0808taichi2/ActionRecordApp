//
//  DetailViewController.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/10/08.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    lazy var record = Record()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sSec = String(format: "%02d", record.sec)
        let sMin = String(format: "%02d", record.min)
        let sHour = String(format: "%02d", record.hour)
        timeLabel.text = "\(sHour):\(sMin):\(sSec)"
        startLabel.text = record.startTime
        stopLabel.text = record.stopTime
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        genreLabel.text = record.genreString
        if record.memo == "" {
            memoLabel.text = "メモなし"
        } else {
            memoLabel.text = record.memo
        }
    }
    
    
    @IBAction func pushButton(_ sender: Any) {
        let saveVC = (storyboard?.instantiateViewController(identifier: "SaveVC"))! as SaveViewController
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        saveVC.isFirst = false
        saveVC.checkedButtonTag = Int(record.genre)
        saveVC.memoString = record.memo!
        saveVC.nowDate = record.date!
        saveVC.startTimeString = record.startTime!
        saveVC.stopTimeString = record.stopTime!
        saveVC.id = record.id
        
        appDelegate.sec = Int(record.sec)
        appDelegate.min = Int(record.min)
        appDelegate.hour = Int(record.hour)
        
        
        self.present(saveVC, animated: true, completion: nil)
    }
    
    
    //MARK: -Layout
    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var startTitleLabel: UILabel!
    @IBOutlet weak var stopTitleLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        genreTitleLabel.frame = Enlarge.rect(x: 28, y: 40, width: 318, height: 16)
        genreTitleLabel.setTitleFont()
        
        genreLabel.frame = Enlarge.rect(x: 28, y: genreTitleLabel.frame.maxY + 8, width: 318, height: 20)
        genreLabel.textColor = .mainB
        genreLabel.font = .systemFont(ofSize: Enlarge.x(x: 20))
        
        timeTitleLabel.frame = Enlarge.rect(x: 28, y: genreLabel.frame.maxY + 24, width: 318, height: 16)
        timeTitleLabel.setTitleFont()
        
        timeLabel.frame = Enlarge.rect(x: 28, y: timeTitleLabel.frame.maxY + 8, width: 318, height: 20)
        timeLabel.setMainFont()
        
        memoTitleLabel.frame = Enlarge.rect(x: 28, y: timeLabel.frame.maxY + 24, width: 318, height: 16)
        memoTitleLabel.setTitleFont()
        
        memoLabel.numberOfLines = 0
        memoLabel.textColor = .mainB
        memoLabel.font = .systemFont(ofSize: Enlarge.x(x: 20))
        
        let size = memoLabel.sizeThatFits(CGSize(width: Enlarge.x(x: 318), height: CGFloat.greatestFiniteMagnitude))
        memoLabel.frame = Enlarge.rect(x: 28, y: memoTitleLabel.frame.maxY + 8, width: size.width, height: size.height)
        
        startTitleLabel.frame = Enlarge.rect(x: 28, y: memoLabel.frame.maxY + 24, width: 159, height: 16)
        startLabel.setMainFont()
        startTitleLabel.setTitleFont()
        
        startLabel.frame = Enlarge.rect(x: 28, y: startTitleLabel.frame.maxY + 8, width: 159, height: 24)
        startLabel.setMainFont()
        
        stopTitleLabel.frame = Enlarge.rect(x: 187, y: memoLabel.frame.maxY + 24, width: 159, height: 16)
        stopTitleLabel.setTitleFont()
        
        stopLabel.frame = Enlarge.rect(x: 187, y: stopTitleLabel.frame.maxY + 8, width: 159, height: 24)
        stopLabel.setMainFont()
        
        editButton.frame =
            //Enlarge.rect(x: 55, y: startLabel.frame.maxY + 56, width: 266, height: 75)
            Enlarge.fullRect(x: 55, y: 468, width: 266, height: 75)
        
        editButton.layer.cornerRadius = Enlarge.y(y: 38)
        editButton.backgroundColor = .tomato
        editButton.setTitle("編集", for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Enlarge.x(x: 20))
        editButton.setTitleColor(.mainW, for: .normal)
    }
    
}
