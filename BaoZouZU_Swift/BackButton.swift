//
//  BackButton.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class BackButton: UIButton {

    init(title:String?,normolImg:String,seletedImg:String) {
        super.init(frame: CGRect())
        if title == nil || title=="" {
            setTitle("", for: .normal)
        }else{
            setTitle(title, for: .normal)
        }
        setBackgroundImage(UIImage(named:normolImg), for: .normal)
        setBackgroundImage(UIImage(named:normolImg), for: .selected)
        layer.masksToBounds = true
        layer.cornerRadius = 13
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
