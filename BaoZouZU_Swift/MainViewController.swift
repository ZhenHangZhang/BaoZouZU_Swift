//
//  MainViewController.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit
import FMDB
import SVProgressHUD
import AFNetworking

private let cellId = "CustomTableViewCell"
class MainViewController: UIViewController {
    
    
    
    
    /// 数据补发的标记
    private var sendCircleTag = 0
    
    /// 定位标记，定位成功开启定时器
    private var isFirstLoaction : Bool?
    
    /// 当前定位的时间
    fileprivate var currentLocationStr : String?
    private let timeCount : TimeInterval = 300.0
    
    /// 定时器，
    fileprivate var timer : Timer?
    
    /// 数据数组包括从数据库读取的数组
    fileprivate var dataArr : [LocationDataModel] = [LocationDataModel]()
    
    /// 上传失败的数据数组
    fileprivate var noSuccessArr : [LocationDataModel] = [LocationDataModel]()

    /// tableView
    private lazy var tableview : UITableView = { [weak self] in
        let tab = UITableView(frame:CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H) , style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        return tab
    }()
    
    /// 提示框
    fileprivate lazy var alertVC : UIAlertController = {
        let av = UIAlertController(title: "提示", message: "有网了，抓紧时间补发数据", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: {[weak self](Action) in
           self?.DataReissue()
        })
        av.addAction(action)
        return av
    }()
    
    /// 数据库
    fileprivate lazy var db : FMDatabase = {
        let datab = FMDatabase(path: BOSOZOKU_DATA_PATH)
        return datab!
    }()
    
    /// 定位管理者
    fileprivate lazy var locationM : MobsLocationManager = {
        let manag = MobsLocationManager.managerLoc
        manag.canLocationFlag = true
        return manag
    }()
    
    /// tableView的头视图
    fileprivate lazy var header : TableViewHeader = {
        let nib = UINib.init(nibName: "TableViewHeader", bundle: nil)
        let hea = nib.instantiate(withOwner: nil, options: nil)[0] as! TableViewHeader
        hea.frame = CGRect(x: 0, y: 0, width: SCREEN_W , height: 150)
        hea.timeStr = MobsDateTool.manager.getCurrentTime()
        return hea
    }()
    
    /// 尾部视图
    fileprivate lazy var footer : TableViewFooter = {
        let nib = UINib.init(nibName: "TableViewFooter", bundle: nil)
        let foo = nib.instantiate(withOwner: nil, options: nil)[0] as! TableViewFooter
        foo.frame = CGRect(x: 0, y: 0, width: SCREEN_W , height: 40)
        return foo
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setBackgroundColor(UIColor.darkGray)
       _ = DataCacheTool.manager.createTable(dataBase: db)
        self.isFirstLoaction = true
        //读取数据库
        for  model : LocationDataModel in (DataCacheTool.manager.findsomeSeletedData(db: db, userName: ZHZUserDefaults.object(forKey: USER_NAME) as! String, currenttime: MobsDateTool.manager.getCurrentTime()) as! Array).reversed() {
            dataArr.append(model)
        }
        tableview.tableFooterView = footer
        view.addSubview(tableview)
        initBtn()
        NetWorkManager.shared.networkStatus()
        addNotifition()
        initnav()
        initTimer()
        locationBlock()
        locationM.startSerialLocation()
    }
    deinit {
               ZHZDLog("\("释放了")")
    }
    
    /// 数据补发
    private func DataReissue(){
        if sendCircleTag >=  noSuccessArr.count {
            SVProgressHUD.show(UIImage.init(named: "success"), status: "补发了\(sendCircleTag)条数据")
            sendCircleTag = 0
            return
        }
        let model = noSuccessArr[sendCircleTag] 
        let sendCircleTime = model.currenttimeminute! + ":00"
        let user_info = ZHZUserDefaults.object(forKey: USER_INFO) as! NSDictionary
        let user_id = user_info.object(forKey: "id")
        let dic = ["userId":user_id as AnyObject,"coordinate":currentLocationStr as AnyObject,"createTime":sendCircleTime as AnyObject] as [String : AnyObject]?
        NetWorkManager.shared.sendCircle(parameters: dic) {[weak self](result, succ) in
            if succ {
            let primaryKey = model.currenttimeminute
            _ = DataCacheTool.manager.updateToKey(db: (self?.db)!, key: primaryKey!, value: "success")
                let index = self?.dataArr.index(of: model)
                model.issuccess = "success"
                self?.dataArr.insert(model, at: index!)
                self?.dataArr.remove(at: index! + 1)
                self?.tableview.reloadData()
            self?.sendCircleTag += 1
            self?.DataReissue()
            }else{
               SVProgressHUD.show(UIImage.init(named: "fail"), status: "补发失败")
            }
        }
    }
    /// 增加网络监测的通知
    private func addNotifition(){
        NotificationCenter.default.addObserver(self, selector: #selector(networkChange), name:NSNotification.Name(rawValue: NET_NOTIFITION) , object: nil)
        
    }
    ///判断是否有没有上传的数据
    private func checkOutDataWithNoLoadSuccess() -> Bool {
        noSuccessArr.removeAll()
        //读取数据库
        for  model : LocationDataModel in dataArr {
            if model.issuccess == "fail" {
                noSuccessArr.append(model)
            }
        }
        if noSuccessArr.count != 0 {
            return true
        }else{
        return false
        }
    }
    /// 网络状态改变
    ///
    /// - Parameter noti: 传参
    @objc private func networkChange(noti:Notification){
        let status = noti.object as! AFNetworkReachabilityStatus
         ZHZDLog("\(status)")
        switch status {
        case .unknown:
            SVProgressHUD.show(UIImage.init(named: "fail"), status: "无网络服务")
        case .notReachable:
            SVProgressHUD.show(UIImage.init(named: "fail"), status: "没有网络")
            alertVC.dismiss(animated: true, completion: nil)
        case .reachableViaWiFi,.reachableViaWWAN:
            let res = checkOutDataWithNoLoadSuccess()
            if res {
                present(alertVC, animated: true, completion: nil)
            }
        }
    }
    /// 定位的回调
    private func locationBlock(){
        locationM.locationBlock = {[weak self](newLocation,newLatitude, newLongitude, error)in
            if (error != nil){
                if error?.domain == kCLErrorDomain{
                    SVProgressHUD.show(UIImage.init(named: "fail"), status: "定位失败，请检查定位设置")
                    return
                }
            }else{
                if (newLocation != nil) {
                    self?.currentLocationStr = newLongitude! + "," +  newLatitude!
                    
                    let speed = (newLocation?.speed)! as Double
                    if speed <= 0 {
                        self?.header.speedStr = "\(0.00)"
                    }else{
                        self?.header.speedStr = "\(speed)"
                    }
                    if (self?.isFirstLoaction!)! {
                        self?.timer?.fire()
                        self?.isFirstLoaction = false
                    }
                }else{
                    SVProgressHUD.show(UIImage.init(named: "fail"), status: newLatitude)
                }
            }
        }
    }
    /// 初始化定时器
    private func initTimer(){
        timer = Timer(timeInterval: timeCount, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    /// 定时器的事件
    @objc private func updateLocation(){
        ZHZDLog("\(currentLocationStr)")
        let user_info = ZHZUserDefaults.object(forKey: USER_INFO) as! NSDictionary
        let user_id = user_info.object(forKey: "id")
        let dic = ["userId":user_id,"coordinate":currentLocationStr]
        let model = initLocationModel(currentLocationStr!)
        
        NetWorkManager.shared.sendData(parameters: dic as [String : AnyObject]?) { [weak self](result:AnyObject?, complition:Bool?) in
            if complition! {
                model.issuccess = "success"
            ZHZDLog("success\(result)")
            }else{
                model.issuccess = "fail"
            ZHZDLog("error")
            }
          _ = DataCacheTool.manager.insertModelDate(model: model, db: (self?.db)!)
            self?.dataArr.insert(model, at: 0)
            self?.tableview.reloadData()
        }
    }
    
    /// 创建model对象
    ///
    /// - Parameter cuttentStr: 定位的当前时间
    fileprivate func initLocationModel(_ cuttentStr:String)->LocationDataModel{
        let model = LocationDataModel()
        model.currenttimeminute = MobsDateTool.manager.getCurrentTimeToMinutes()
        model.currenttime = MobsDateTool.manager.getCurrentTime()
        model.username = ZHZUserDefaults.object(forKey: USER_NAME) as! String?
        let arr = cuttentStr.components(separatedBy: ",")
        model.latitude = arr.last
        model.longitude = arr.first
        return model
    }
}
// MARK: - tableView的代理方法
extension MainViewController:UITableViewDelegate,UITableViewDataSource{

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as!CustomTableViewCell
        cell.model = dataArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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


// MARK: - UI
extension MainViewController{

    fileprivate func initBtn(){
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: SCREEN_W - 60, y: 100, width: 44, height: 44)
        rightBtn.layer.masksToBounds = true
        rightBtn.layer.cornerRadius = 22
        rightBtn.setBackgroundImage(UIImage.init(named: "record"), for: .normal)
        rightBtn.addTarget(self, action: #selector(pushRecordVC), for: .touchUpInside)
        view.addSubview(rightBtn)
    }
    
    @objc private func pushRecordVC(){
        let recordVC = HistoryViewController()
        recordVC.view.backgroundColor = UIColor.white
        recordVC.title = "历史记录"
        recordVC.DataARR = dataArr
        navigationController?.pushViewController(recordVC, animated: true)
    }
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
        alert.addAction(UIAlertAction(title: "退出", style: .default, handler: { [weak self](action) in
            
            NotificationCenter.default.removeObserver(self!)
            self?.timer?.invalidate()
            self?.timer = nil
            self?.locationM.stopSerialLocation()
            ZHZUserDefaults.set("no", forKey: IsLogin)
            ZHZUserDefaults.synchronize()
            UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        present(alert, animated: true, completion: nil)
    }
}
