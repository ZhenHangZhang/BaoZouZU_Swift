//
//  DataCacheTool.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/28.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit
import FMDB


class DataCacheTool: NSObject {

    var dataArr = [Any?]()
    
    
    static let manager:DataCacheTool = {
        let instance = DataCacheTool()
        return instance
    }()
    
    
    /// 创建表格
    ///
    /// - Parameters:
    ///   - dataBase: 数据库
    ///   - model: 数据模型
    /// - Returns: 是否成功
    func createTable(dataBase:FMDatabase) -> Bool {
        if dataBase.open() {
            if dataBase.tableExists(TABLE_NAME) {
                
            }else{
                let sql = "create table \(TABLE_NAME)" + " (" + "key integer primary key,  username text, currenttime text, currenttimeminute text, longitude text, latitude text, issuccess text" + ")"
                ZHZDLog(sql)
                
                let res = dataBase.executeUpdate(sql, withArgumentsIn: nil)
                if res {
                    ZHZDLog("创建成功")
                }else{
                    ZHZDLog("创建失败")
                }
                return res
            }
        }
        return true
    }
    
    
    /// 插入数据
    ///
    /// - Parameters:
    ///   - model: 数据模型
    ///   - db: 数据库
    /// - Returns: 是否成功
    func insertModelDate(model:LocationDataModel,db:FMDatabase) -> Bool {
    
        if db.open() {
            let sql = "insert into BOSO (currenttime, currenttimeminute, username, longitude, latitude, issuccess) values (" + "?, ?, ?, ?, ?, ?)"
            
            ZHZDLog("\(sql)")
            let  resss = db.executeUpdate(sql, withArgumentsIn: [model.currenttime!,model.currenttimeminute!,model.username!,model.longitude!,model.latitude!,model.issuccess!])
            if resss {
                ZHZDLog("插入成功")
            }else{
                ZHZDLog("插入失败")
            }
            return resss
        }
        return false
    }
    /// 查询所有数据库
    ///
    /// - Parameter db: 数据库
    /// - Returns: 查询的数据
    func findAllData(db:FMDatabase) -> NSArray? {
        if db.open() {
            
            let sql = "select * from \(TABLE_NAME)"

            let rs = db.executeQuery(sql, withArgumentsIn: nil)
            return getResult(db: db, rs: rs!)
        }else{
        return nil
        }
    }
    
    /// 查询特定条件的数据
    ///
    /// - Parameters:
    ///   - db: 数据
    ///   - userName: 名称
    ///   - currenttime: 时间
    /// - Returns: 返回数据
    func findsomeSeletedData(db:FMDatabase,userName:String,currenttime:String) -> NSArray? {
        
        let sql = "select * from \(TABLE_NAME) where (username = ? and currenttime = ?)"
        if db.open() {
            let rs = db.executeQuery(sql, withArgumentsIn: [userName,currenttime])
            if rs == nil {
                return [Any?]() as NSArray?
            }
        return getResult(db: db, rs: rs)
        }
        return nil
    }
    private func getResult(db:FMDatabase,rs:FMResultSet?
        ) -> NSArray{
        dataArr.removeAll()
        while (rs?.next())! {
            let model = LocationDataModel()
            model.currenttimeminute = rs?.object(forColumnName: "currenttimeminute") as! String?
            model.currenttime = rs?.object(forColumnName: "currenttime") as! String?
            model.issuccess = rs?.object(forColumnName: "issuccess") as! String?
            model.longitude = rs?.object(forColumnName: "longitude") as! String?
            model.latitude = rs?.object(forColumnName: "latitude") as! String?
            model.longitude = rs?.object(forColumnName: "longitude") as! String?
            model.username = rs?.object(forColumnName: "username")as!String?
            dataArr.append(model)
        }
        return dataArr as NSArray
    }
    
    /// 更新数据
    ///
    /// - Parameters:
    ///   - db: 数据库
    ///   - key: 主键
    ///   - value: 修改的值
    /// - Returns: 是否成功
    func updateToKey(db:FMDatabase,key:String,value:String) -> Bool {
        
        let updateSql = "update BOSO set issuccess = '\(value)' where currenttimeminute = '\(key)'"
        let succe = db.executeUpdate(updateSql, withArgumentsIn: nil)

        if succe {
            ZHZDLog("更新成功")
        }else{
            ZHZDLog("更新shibai")
        }
     return succe
    }
    
    /// 添加字段
    ///
    /// - Parameters:
    ///   - db: 数据库
    ///   - tableName: 数据库表明
    ///   - column: 新字段信息
    /// - Returns: 是否成功
    func addTableColumn(db:FMDatabase,tableName:String,column:String) -> Bool {
        if db.open() {
            let addSql = "ALTER TABLE \(tableName) ADD COLUMN \(column) text"
            let res = db.executeUpdate(addSql, withArgumentsIn: nil)

            if res  {
                ZHZDLog("表添加字段成功");
            }else{
                ZHZDLog("表添加字段失败");
            }
            return res
        }
        return false
    }
    
    /// 删除表
    ///
    /// - Parameters:
    ///   - db: 数据库
    ///   - tableName: 表明
    /// - Returns: 是否成功
    func deletateTable(db:FMDatabase,tableName:String) -> Bool {
        if db.open() {
            let delegateSql = "DROP TABLE \(tableName)"
            
            
            let res = db.executeUpdate(delegateSql, withArgumentsIn: nil)
            if res  {
                ZHZDLog("shanbiao成功");
            }else{
                ZHZDLog("shanbiao失败");
            }
            return res
        }
        return false
    }
}
