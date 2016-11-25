//
//  Header.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import Foundation
import UIKit


let MAP_KEY = "850e13d8556e2b403c568be4286ce8e5"

/// 宏定义宽高；
let SCREEN_W = UIScreen.main.bounds.size.width
let SCREEN_H = UIScreen.main.bounds.size.height

let IsLogin = "IsLogin"
let USER_NAME = "USERNAME"
let USER_INFO = "USERINFO"


let ZHZUserDefaults = UserDefaults.standard

func SCREEN_WIDTH(_ object:UIView) ->CGFloat{
    
    return object.frame.size.width
}
func SCREEN_HEIGHT(_ object:UIView) ->CGFloat{
    
    return object.frame.size.height
}

func RGBColor(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(colorLiteralRed: Float(r/255), green: Float(g/255), blue: Float(b/255), alpha: Float(a))
}

func ZHZDLog<T>(_ message:T,fileName:String = #file,methodName:String = #function,lineNum:Int = #line){
    #if DEBUG
        let logStr:String = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: "swift", with: "");
        print("类\(logStr)方法\(methodName)行[\(lineNum)]数据\(message)")
    #endif
}

