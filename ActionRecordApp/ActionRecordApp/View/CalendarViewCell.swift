//
//  CalendarViewCell.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/09/30.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.text = ""
        textLabel.textAlignment = .center
        colorView.backgroundColor = .clear
        
        colorView.frame = CGRect(x: 0, y: 0, width: Enlarge.x(x: 44), height: Enlarge.x(x: 44))
        colorView.layer.cornerRadius = Enlarge.x(x: 44) / 2
        colorView.frame = CGRect(x: 0, y: 0, width: Enlarge.x(x: 44), height: Enlarge.x(x: 44))
        
        textLabel.font = .systemFont(ofSize: Enlarge.x(x: 16))
        textLabel.frame = CGRect(
            x: Enlarge.x(x: 12),
            y: Enlarge.x(x: 12),
            width: Enlarge.x(x: 20),
            height: Enlarge.x(x: 20))
        
        let view = UIView(frame: bounds)
        view.backgroundColor = .tomato
        self.selectedBackgroundView = view
    }

    
    func setCell(indexPath: IndexPath, dayOfFirstWeek: Int, numberOfDays: Int, datefor: DateFormatter, today: Date, firstDate: Date) {
        let weekArray = ["日","月","火","水","木","金","土"]
        //ラベルの色分岐
        switch indexPath.row {
        case 0, 7, 14, 21, 28, 35:
            textLabel.textColor = .red
        case 6, 13, 20, 27, 34:
            textLabel.textColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        default:
            textLabel.textColor = .mainB
        }
        
        colorView.backgroundColor = .clear
        textLabel.text = ""
        
        //日付の割当
        let num = indexPath.row - dayOfFirstWeek + 2
        
        if indexPath.section == 0 {
            colorView.backgroundColor = .clear
            textLabel.text = weekArray[indexPath.row]

        } else if num >= 1 && num <= numberOfDays {
            colorView.backgroundColor = .mainLG
            textLabel.text = String(num)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: .current)
        
        if String(num) == dateFormatter.string(from: today) && datefor.string(from: firstDate) == datefor.string(from: today) && indexPath.section == 1 {
            textLabel.textColor = .mainW
            colorView.backgroundColor = .tomato
        }
        
        
    }
    
    
}
