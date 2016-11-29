//
//  NetWorkManager.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit
import AFNetworking

enum HttpMethodType {
    case GET
    case POST
}

class NetWorkManager: AFHTTPSessionManager {
    
    static let shared:NetWorkManager = {
        let instance = NetWorkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("application/json")
        instance.responseSerializer.acceptableContentTypes?.insert("text/json")
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        instance.requestSerializer.timeoutInterval = 8
        return instance
    }()
    
    /// 封装AFN 的的GET /POST请求
    ///
    /// - parameter method:     GET /POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 回调json、是否成功
    func request(method:HttpMethodType,URLString:String,parameters: [String:AnyObject]?,completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool) ->Void){
        //成功回调
        let success = {(task: URLSessionDataTask, json: Any?) ->() in
            completion(json as AnyObject?, true)
        }
        //失败回调
        let failure = {(task: URLSessionDataTask?, error: Error) ->() in
//            print("网络请求错误\(error)")
            completion(error as AnyObject?, false)
        }
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    func networkStatus(){
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (Status) in
            ZHZDLog("\(Status)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NET_NOTIFITION), object:Status)
        }
    }
    
}
