//
//  NetWorkManager+Gategroy.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import Foundation

extension NetWorkManager{
    func loginMethod(userName:String,psd:String,completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) ->Void) -> () {
    let URLStr = "http://rtpi.ezparking.com.cn/rtpi/userCoordinate/login.do?name=\(userName)&password=\(psd)"
    request(method: .GET, URLString: URLStr, parameters: nil, completion: completion)
    }
}
extension NetWorkManager{
    func sendData(parameters: [String:AnyObject]?,completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) ->Void) -> () {
        let URLStr = "http://rtpi.ezparking.com.cn/rtpi/userCoordinate/update.do"
        request(method: .GET, URLString: URLStr, parameters: parameters, completion: completion)
    }
}
extension NetWorkManager{
    func sendCircle(parameters: [String:AnyObject]?,completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) ->Void) -> () {
        let URLStr = "http://rtpi.ezparking.com.cn/rtpi/userCoordinate/update.do"
        request(method: .GET, URLString: URLStr, parameters: parameters, completion: completion)
    }
}
