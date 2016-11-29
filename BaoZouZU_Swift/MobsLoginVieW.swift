//
//  MobsLoginVieW.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit
import SVProgressHUD

class MobsLoginVieW: UIView {
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func loginClick(_ sender: Any) {
        login(username: userName.text!, passWord: passWord.text!)
    }
   weak var delegate : MobsLoginViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        loginBtn.isEnabled = false
        userName.delegate = self;
        passWord.delegate = self;
        if (ZHZUserDefaults.object(forKey: USER_NAME) != nil) {
            userName.text = ZHZUserDefaults.object(forKey: USER_NAME) as! String?
        }else{
        userName.becomeFirstResponder()
        }
    }
}
extension MobsLoginVieW:UITextFieldDelegate{

     func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passWord {
            loginBtn.isEnabled = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userName{
        userName.resignFirstResponder()
            passWord.becomeFirstResponder()
        }else{
        passWord.resignFirstResponder()
            login(username: userName.text, passWord: passWord.text)
        }
        return true
    }
    fileprivate func login(username:String?,passWord:String?){
        self.endEditing(true)

        if username == ""||username == nil||passWord == "" || passWord == nil {
            return;
        }
        ZHZDLog("\(username)\(passWord)")
        NetWorkManager.shared.loginMethod(userName: username!, psd: passWord!, completion: {[weak self](json,success)->Void in
            if success {
                let userInfoDic  = json as!NSDictionary
                ZHZUserDefaults.set(username, forKey:USER_NAME)
                ZHZUserDefaults.set(userInfoDic, forKey: USER_INFO)
                ZHZUserDefaults.set("yes", forKey: IsLogin)
                ZHZUserDefaults.synchronize()
                self?.delegate?.loginSuccess()
                ZHZDLog("\(json)")
            }else{
              let error = json as!NSError
                
                guard let respon = error.userInfo["com.alamofire.serialization.response.error.response"] as? HTTPURLResponse else {
                SVProgressHUD.show(UIImage.init(named: "error"), status: "网络错误");                   return
                }
                let msgStr = respon.allHeaderFields["Message"] as! NSString
                let msg = msgStr.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!
                SVProgressHUD.show(UIImage.init(named: "error"), status: msg)
            ZHZDLog("\(msg)")
            }
        })
    }
}

protocol MobsLoginViewDelegate:NSObjectProtocol {
    func loginSuccess()
}
