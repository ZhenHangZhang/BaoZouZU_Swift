//
//  TableViewHeader.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class TableViewHeader: UIView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
   
    
    var speedStr : String? {
        didSet{
        speedLabel.text = speedStr
        }
    }
    var timeStr : String?{
        didSet{
            timeLabel.text = timeStr
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = RGBColor(242, g: 248, b: 255, a: 1)
    }
    override func draw(_ rect: CGRect) {
        
    }
}
