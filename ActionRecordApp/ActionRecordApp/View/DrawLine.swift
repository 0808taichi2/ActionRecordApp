//
//  DrawLine.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/09/20.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

import UIKit

class DrawLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 線
        let line = UIBezierPath()
        // 最初の位置
        line.move(to: CGPoint(x: 20, y: 0))
        // 次の位置
        line.addLine(to:CGPoint(x: 20, y: self.frame.height))
        // 終わる
        line.close()
        // 線の色
        UIColor.mainLG.setStroke()
        // 線の太さ
        line.lineWidth = 2.0
        // 線を塗りつぶす
        line.stroke()
    }
}
