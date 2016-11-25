//
//  MainViewController.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

private let cellId = "CustomTableViewCell"


class MainViewController: UIViewController {

    private lazy var tableview : UITableView = {
        let tab = UITableView(frame:CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H) , style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        return tab
    }()
    
    fileprivate lazy var header : TableViewHeader = {
        let nib = UINib.init(nibName: "TableViewHeader", bundle: nil)
        let hea = nib.instantiate(withOwner: nil, options: nil)[0] as! TableViewHeader
        hea.frame = CGRect(x: 0, y: 0, width: SCREEN_W , height: 150)
        return hea
    }()
    fileprivate lazy var footer : TableViewFooter = {
        let nib = UINib.init(nibName: "TableViewFooter", bundle: nil)
        let foo = nib.instantiate(withOwner: nil, options: nil)[0] as! TableViewFooter
        foo.frame = CGRect(x: 0, y: 0, width: SCREEN_W , height: 40)
        return foo
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = footer
        view.addSubview(tableview)
        // Do any additional setup after loading the view.
        initnav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - tableView的代理方法
extension MainViewController:UITableViewDelegate,UITableViewDataSource{

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UINib.init(nibName: "CustomTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTableViewCell
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
}

extension MainViewController{

    
    
    
    
    fileprivate func initnav(){
        let imgV = UIImageView(image: UIImage.init(named: "icon"))
        self.navigationItem.titleView = imgV
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.setTitleColor(UIColor.gray, for: .normal)
        rightBtn.setTitle("注销", for: .normal)
        rightBtn.setImage(UIImage.init(named: "Signout"), for: .normal)
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2.5)
        rightBtn.showsTouchWhenHighlighted = true
        rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        rightBtn.addTarget(self, action: #selector(loginOut), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    @objc private func loginOut(){
        let alert = UIAlertController(title: "提示", message: "是否退出", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "退出", style: .default, handler: { (action) in
            
            ZHZUserDefaults.set("no", forKey: IsLogin)
            ZHZUserDefaults.synchronize()
            UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
