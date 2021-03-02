//
//  TableViewCell.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/08/30.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var circle: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setCell() {
        let drowLine = DrawLine(frame: CGRect(x: self.frame.maxX - 60, y: 26, width: 40, height: self.frame.height - 52))
        self.addSubview(drowLine)
        
        self.circle.layer.cornerRadius = 7
        
        self.genreLabel.textColor = .mainB
        self.genreLabel.font = .boldSystemFont(ofSize: 16)
        
        self.timeLabel.textColor = .mainB
        self.timeLabel.font = .systemFont(ofSize: 20)
        
        self.startLabel.textColor = .mainG
        self.startLabel.font = .systemFont(ofSize: 14)
        self.startLabel.textAlignment = .center
        self.startLabel.frame = CGRect(x: self.frame.width - 60, y: 12, width: 40, height: 14)
        
        self.stopLabel.textColor = .mainG
        self.stopLabel.font = .systemFont(ofSize: 14)
        self.stopLabel.textAlignment = .center
        self.stopLabel.frame = CGRect(x: self.frame.width - 60, y: 74, width: 40, height: 14)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
