//
//  BaseViewController.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class BaseViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self;
    }

    @objc fileprivate func titleBtnAction(){
        popViewController(animated: true)
    }
}


extension BaseViewController:UINavigationControllerDelegate,UIGestureRecognizerDelegate{

     func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count > 1
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
 
            let backBtn = BackButton(title: "", normolImg: "Close", seletedImg: "Close")
            backBtn.addTarget(self, action: #selector(titleBtnAction), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
        super.pushViewController(viewController, animated: animated)
        
    }
}
