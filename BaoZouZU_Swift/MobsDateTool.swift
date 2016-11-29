
//
//  MobsDateTool.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/28.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class MobsDateTool: NSObject {
    static let manager:MobsDateTool = {
        let instance = MobsDateTool()
        return instance
    }()
    /// 上个月
    ///
    /// - Parameter date: 时间
    /// - Returns: 返回上个月的时间
    func lastMonth(date:Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month! -= 1
        let newDate = NSCalendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    /// 下个月
    ///
    /// - Parameter date: 时间
    /// - Returns: 返回下个月的时间
    func nestMonth(date:Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month! += 1
        
        let newDate = NSCalendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    func year(date:Date) -> NSInteger{
        let components = NSCalendar.current.component(Calendar.Component.year, from: date)
        return components
    }
    func month(date:Date) -> NSInteger{
        let components = NSCalendar.current.component(Calendar.Component.month, from: date)
        return components
    }
    func day(date:Date) -> NSInteger{
        let components = NSCalendar.current.component(Calendar.Component.day, from: date)
        return components
    }
    
    func totaldaysInMonth(date:Date) -> NSInteger {
        let daysInLastMonth = NSCalendar.current.range(of: .day, in: .month, for: date) as? NSRange
        return daysInLastMonth!.length
    }
    
    /// "1419055200" -> 转化 日期字符串
    ///时间计算  类似： 1419055200 ----> 2016.09.01
    
    /// - Parameter timerStr: 时间字符串
    /// - Returns: yyyy_MM_dd字符串
    func dateStringFromNumberTimer(timerStr:String) -> String {
        let t = (timerStr as NSString).doubleValue
        let date = NSDate.init(timeIntervalSinceReferenceDate: t/1000.0)
        let df = DateFormatter.shared
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: date as Date)
    }
    
    /// 将日期格式化成字符串
    ///
    /// - Parameters:
    ///   - date: 时间
    ///   - format: 格式，例如 @"yyyy-MM-dd HH:mm:ss"
    /// - Returns: 字符串时间
    func stringWithDate(date:NSDate,format:String) -> String {
        let df = DateFormatter.shared
        df.dateFormat = format
        df.locale = NSLocale.current
        return df.string(from: date as Date)
    }
    
    /// yyyy-MM-dd格式的时间字符串
    ///
    /// - Parameter date: 某一时刻的时间
    /// - Returns: yyyy-MM-dd格式的时间字符串
    
    
    func stringDateFromDate( date:NSDate) -> String {
        var date = date
        let df = DateFormatter.shared
        df.dateFormat = "yyyy-MM-dd"
        let zone = NSTimeZone.system
        df.timeZone = zone
        let seconds = zone.secondsFromGMT(for: date as Date)
        date = date.addingTimeInterval(TimeInterval(seconds))
        return df.string(from: date as Date)
    }
    
    /// 此刻的时间2016-11-11
    ///
    /// - Returns: 时间字符串
    func getCurrentTime() -> String{
        let df = DateFormatter.shared
        df.dateFormat = "YYYY-MM-dd"
        return df.string(from: Date())
    }
    func getCurrentTimeToMinutes() -> String {
        let df = DateFormatter.shared
        df.dateFormat = "YYYY-MM-dd HH:mm"
        return df.string(from: Date())
    }
}
