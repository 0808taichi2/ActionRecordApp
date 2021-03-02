//
//  CalendarViewController.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/09/24.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

/*
        //１日が何曜日か、何日までか
        //カレンダー
        var calendar = Calendar.current
        //月の日付
        private var firstDate: Date! {
            didSet {
               collectionView.reloadData()
            }
        }
        
        //Data()時点の年月を取得
        var component = calendar.dateComponents([.year, .month], from: Date())
        //多分ついたちを指定
        component.day = 1
        //日を指定
        firstDate = calendar.date(from: component)
        
        //した2つ確定でview更新
        // 月の初日の曜日
        let dayOfFirstWeek = calendar.component(.weekday, from: firstDate)
        // 月の日数
        let numberOfWeeks = calendar.range(of: .day, in: .month, for: firstDate)!.count
        
        //月を更新 理解
        func nextMonth() {
            firstDate = calendar.date(byAdding: .month, value: 1, to: firstDate)
        }
        func prevMonth() {
            firstDate = calendar.date(byAdding: .month, value: -1, to: firstDate)
        }
   */


import UIKit
import CoreData

class CalendarViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    //日付
    var dateString = String()
    //月初めの曜日
    var dayOfFirstWeek = Int()
    //月の日数
    var numberOfDays = Int()
    //今日の日付
    var today = Date()
    //カレンダー
    var calendar = Calendar.current
    let datefor = DateFormatter()
    //月の日付
    private var firstDate = Date() {
        didSet {
           setDays()
        }
    }
    
    //CoreData関連
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //表示する情報を入れる
    var recordArray: [Record] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    
   //MARK: -開始
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionViewの設定
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        //tableViewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.showsVerticalScrollIndicator = false
        
        //日付の比較で使用
        datefor.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMM", options: 0, locale: Locale(identifier: "ja_JP"))
        
        picDate(date: today)
        
        //component = 時間(年月日)の情報のまとまり(ここのDateが)
        var component = calendar.dateComponents([.year, .month], from: Date())
        //ついたちを指定
        component.day = 1
        today = Date()
        //Date型に変換
        firstDate = calendar.date(from: component)!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    //MARK: -Setting
    func setDays() {
        //ついたちの曜日
        dayOfFirstWeek = calendar.component(.weekday, from: firstDate)
        //月の日数
        numberOfDays = calendar.range(of: .day, in: .month, for: firstDate)!.count
        //タイトルの設定、変更
        self.navigationItem.title = datefor.string(from: firstDate)
        
        collectionView.reloadData()
    }
    
    
    //MARK: -FetchData
    //private
    func picDate(date: Date) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        
        DispatchQueue.main.async {
            do {
                //ここで取得
                self.recordArray = try self.managedObjectContext.fetch(fetchRequest) as! [Record]
                
                let datefor = DateFormatter()
                datefor.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
                
                if self.recordArray == [] {
                    self.dateString = "\(datefor.string(from: date)) データなし"
                } else {
                    self.dateString = datefor.string(from: date)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    //MARK: -Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let mainHeight = UIScreen.main.bounds.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        
        scrollView.frame = CGRect(
            x: 0,
            y: self.view.safeAreaInsets.top,
            width: UIScreen.main.bounds.width,
            height: mainHeight)
        
        let collectionWidth = Enlarge.x(x: 44) * 7 + 56
        let collectionHeight = Enlarge.x(x: 44) * 7 + 24
        
        collectionView.frame = CGRect(
            x: (UIScreen.main.bounds.width - collectionWidth) / 2,
            y: 0,
            width: collectionWidth,
            height: collectionHeight)

        var tableHeight = CGFloat()
        
        if collectionHeight + 430 > mainHeight {
            tableHeight = 430
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: collectionHeight + 430)
        } else {
            tableHeight = mainHeight - collectionHeight
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: mainHeight)
        }
        
        tableView.frame = CGRect(
            x: 0,
            y: collectionHeight,
            width: UIScreen.main.bounds.width,
            height: tableHeight)
        
        setItem()
    }
    
    
    //MARK: -BarItem
    func setItem() {
        var backButton: UIBarButtonItem!
        backButton = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(prevMonth))
        backButton.tintColor = .tomato
        navigationItem.leftBarButtonItem = backButton
        
        var nextButton: UIBarButtonItem!
        nextButton = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextMonth))
        nextButton.tintColor = .tomato
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc func prevMonth() {
        firstDate = calendar.date(byAdding: .month, value: -1, to: firstDate)!
    }
    
    @objc func nextMonth() {
        firstDate = calendar.date(byAdding: .month, value: 1, to: firstDate)!
    }
    
}

//MARK: -UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //cellの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 :42
    }
    
    //cellの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
        return CGSize(width: Enlarge.x(x: 44), height: Enlarge.x(x: 44))
    }
    
    //横の間の幅
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    //縦の間の幅
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var bool = Bool()
        let num = indexPath.row - dayOfFirstWeek + 2
        
        if indexPath.section == 0 {
            bool = false
        } else if num < 1 || num > numberOfDays {
            bool = false
        } else {
            bool = true
        }
        
        return bool
    }
    
    //cellがタップされたとき
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let SelectedDateFormatter = DateFormatter()
        SelectedDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        
        var component = calendar.dateComponents([.year, .month], from: firstDate)
        component.day = indexPath.row - dayOfFirstWeek + 2
        guard let date: Date = calendar.date(from: component) else { return }
        
        picDate(date: date)
    }
    
    //cellの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarViewCell
        
        cell.setCell(
            indexPath: indexPath,
            dayOfFirstWeek: dayOfFirstWeek,
            numberOfDays: numberOfDays,
            datefor: datefor,
            today: today,
            firstDate: firstDate)
        
        return cell
    }
}

//MARK: -UITableViewDelegate
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
//        return false
//    }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //ヘッダーのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateString
    }
    
    //ヘッダーの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArray.count
    }

    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //DetailViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = (storyboard?.instantiateViewController(identifier: "detailVC"))! as DetailViewController
        detailVC.record = recordArray[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.setCell()
        
        let doGenre = recordArray[indexPath.row].genre
        cell.genreLabel.text = recordArray[indexPath.row].genreString
        
        switch doGenre {
        case 1:
            cell.circle.backgroundColor = UIColor(red: 255/255, green: 127/255, blue: 127/255, alpha: 1)
        case 2:
            cell.circle.backgroundColor = UIColor(red: 255/255, green: 127/255, blue: 255/255, alpha: 1)
        case 3:
            cell.circle.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 255/255, alpha: 1)
        case 4:
            cell.circle.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 255/255, alpha: 1)
        case 5:
            cell.circle.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 127/255, alpha: 1)
        case 6:
            cell.circle.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 127/255, alpha: 1)
        case 7:
            cell.circle.backgroundColor = UIColor(red: 255/255, green: 127/255, blue: 0, alpha: 1)
        case 8:
            cell.circle.backgroundColor = UIColor(red: 255/255, green: 10/255, blue: 132/255, alpha: 1)
        default:
            cell.genreLabel.text = "その他"
            cell.circle.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        }
        
        let sSec = String(format: "%02d", Int(recordArray[indexPath.row].sec))
        let sMin = String(format: "%02d", Int(recordArray[indexPath.row].min))
        let sHour = String(format: "%02d", Int(recordArray[indexPath.row].hour))
        cell.timeLabel.text = "\(sHour):\(sMin):\(sSec)"

        cell.startLabel.text = recordArray[indexPath.row].startTime
        cell.stopLabel.text = recordArray[indexPath.row].stopTime
        
        if recordArray[indexPath.row].memo == "" {
            cell.memoLabel.text = "メモなし"
        } else {
            cell.memoLabel.text = recordArray[indexPath.row].memo
        }
        
        return cell
    }


}
