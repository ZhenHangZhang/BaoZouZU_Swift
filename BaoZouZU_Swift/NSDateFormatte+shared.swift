//
//  NSDateFormatte+shared.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/28.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import Foundation

extension DateFormatter{
    static let shared:DateFormatter = {
        let instance = DateFormatter()
        return instance
    }()
}
