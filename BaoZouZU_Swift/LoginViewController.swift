//
//  LoginViewController.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    fileprivate lazy var NavC :BaseViewController = {
        return BaseViewController(rootViewController: MainViewController())
    }()
    
    fileprivate lazy var loginView : MobsLoginVieW = {
        let nib = UINib.init(nibName: "MobsLoginVieW", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! MobsLoginVieW
        v.frame = CGRect(x: 0, y: 150, width: SCREEN_W , height: 180)
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//        addNotifition()
    }
    deinit {
//        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController{
    fileprivate func addNotifition(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func keyboardWillShow(notifi:NSNotification){
    
        UIView.animate(withDuration: 1.0, animations:{()->Void in
            self.loginView.frame = CGRect(x: 0, y: 150, width: SCREEN_W, height: 180)
        }
    )
        
    }
    @objc fileprivate func keyboardWillHidden(notifi:NSNotification){
    
        UIView.animate(withDuration: 1.0, animations:{()->Void in
            self.loginView.frame = CGRect(x: 0, y: 150, width: SCREEN_W, height: 180)
        }
    )
    }
    fileprivate func setUI(){

        let imgV : UIImageView = UIImageView(frame: view.bounds)
        imgV.image = UIImage.init(named: "login_bg")
        view.addSubview(imgV)
        let logoImgV:UIImageView = UIImageView(frame: CGRect(x: Int((SCREEN_W - 100)/2), y: 100, width: 100, height: 40))
        logoImgV.image = UIImage.init(named: "titleLogo")
        view.addSubview(logoImgV)        
        let dic : [String:Any] = Bundle.main.infoDictionary!
        let versonLabel = UILabel(frame: CGRect(x: Int((SCREEN_W - 200)/2), y: Int(SCREEN_H - 30), width: 200, height: 20))
        versonLabel.text = dic["CFBundleShortVersionString"] as! String?
        versonLabel.textAlignment = .center
        versonLabel.textColor = UIColor.white
        view.addSubview(versonLabel)
        view.addSubview(loginView)
        loginView.delegate = self
    }
}
extension LoginViewController:MobsLoginViewDelegate{
    func loginSuccess() {
       UIApplication.shared.keyWindow?.rootViewController = NavC
    }
}
