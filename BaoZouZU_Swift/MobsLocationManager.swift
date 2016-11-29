//
//  MobsLocationManager.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

let mUserCurrentLatitude = "mUserCurrentLatitude"
let mUserCurrentLongitude = "mUserCurrentLongitude"


class MobsLocationManager: NSObject {

    var canLocationFlag :Bool?{
        set{

        }
        get{
            if CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                return true
            }else{
            return false
            }
            
        }
    }
    var hasLocation : Bool?{
    
        get{
            if ZHZUserDefaults.object(forKey: mUserCurrentLatitude) != nil && ZHZUserDefaults.object(forKey: mUserCurrentLongitude) != nil {
                return true
            }else{
                return false
            }
         }
    }
    var isLocationing : Bool?
    
    typealias LocationManagerDidUpdateLocationHandle = (_ newLocation:CLLocation?,_ newLatitude:String?,_ newLongitude:String?,_ error:NSError?)->Void
    
    var locationBlock : LocationManagerDidUpdateLocationHandle?
    
    fileprivate lazy var locationManager : AMapLocationManager = {[weak self] in
        
        let manager = AMapLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.locationTimeout = 10
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = false
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    static let managerLoc:MobsLocationManager = {
        let instance = MobsLocationManager()
        return instance
    }()
    
    func startSerialLocation(){
        if canLocationFlag == false{
        return
        }
        isLocationing = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    func stopSerialLocation(){
        isLocationing = false
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
}

extension MobsLocationManager:AMapLocationManagerDelegate{

    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        locationBlock!(nil,nil,nil,error as NSError?)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        let currentLatitude = String(location.coordinate.latitude)
        let currentLongitude = String(location.coordinate.longitude)
        ZHZUserDefaults.set(currentLatitude, forKey: mUserCurrentLatitude)
        ZHZUserDefaults.set(currentLongitude, forKey: mUserCurrentLongitude)
        ZHZUserDefaults .synchronize()
        if (locationBlock != nil)  {
            locationBlock!(location,currentLatitude,currentLongitude,nil)
        }
    }
    func amapLocationManager(_ manager: AMapLocationManager!, didChange status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            if (locationBlock != nil) {
                locationBlock!(nil,"决定是否使用定位服务",nil,nil)
            }
        case .restricted:
            
            if (locationBlock != nil) {
                locationBlock!(nil,"定位服务授权状态是受限制的",nil,nil)
            }
        case .authorizedAlways:
            
            if (locationBlock != nil) {
                locationBlock!(nil,"许在任何状态下获取位置信息",nil,nil)
            }
        case .authorizedWhenInUse:
            if (locationBlock != nil) {
                locationBlock!(nil,"允许在使用应用程序的时候",nil,nil)
            }
        default:
            break
        }
    }
}
















