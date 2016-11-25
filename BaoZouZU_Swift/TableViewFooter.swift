//
//  TableViewFooter.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class TableViewFooter: UIView {
    @IBOutlet weak var titlelabel: UILabel!
    var titleStr : String? {
        didSet{
        titlelabel.text = titleStr
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = RGBColor(242, g: 248, b: 255, a: 1)
    }
}
