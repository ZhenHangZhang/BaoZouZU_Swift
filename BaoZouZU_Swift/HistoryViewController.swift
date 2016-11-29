//
//  HistoryViewController.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit


class HistoryViewController: UIViewController {
   fileprivate let annotationIdentifier = "locationIdentifiter"

    private var polyline : MAMultiPolyline?
    private var count = 0
    private var annArr : [MobsAnnotation] = [MobsAnnotation]()
    
    var DataARR : [LocationDataModel]?{
        didSet{
//            ZHZDLog("\(DataARR)")
            if (DataARR?.count)! <= 1 {
                
            }else{
                for model in (DataARR?.enumerated())! {
                    if model.offset % 12 == 0 {
                        let anno = MobsAnnotation()
                        let titleArr = model.element.currenttimeminute?.components(separatedBy: " ")
                        let coor = CLLocationCoordinate2D(latitude: Double(model.element.latitude!)!, longitude: Double(model.element.longitude!)!)
                        anno.coordinate = coor
                        anno.name = titleArr?.last
                        annArr.append(anno)
//                        mapView?.addAnnotation(anno)
                    }
                }
                mapView?.addAnnotations(annArr)
            }
        }
    }
    fileprivate var mapView : MAMapView?
    deinit {
        ZHZDLog("HistoryViewController释放了")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapview()
        
        
        
        
        
        
        
        
        
        
        
    }
}



// MARK: - UI
extension HistoryViewController{

    
    fileprivate func initMapview(){
                if (mapView == nil)
                {
                  mapView = MAMapView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H))
                }
                mapView?.delegate = self;
                mapView?.showsScale = true;
                //罗盘的位置
                mapView?.compassOrigin = CGPoint(x: 5, y: 10)
                mapView?.scaleOrigin = CGPoint(x:5, y:SCREEN_H - 20);
                mapView?.logoCenter = CGPoint(x:50, y:20);
                view.addSubview(mapView!)
    }
    
}

// MARK: - MAMapViewDelegate
extension HistoryViewController :MAMapViewDelegate{
    
    /// 地图加载完成
    ///
    /// - Parameter mapView:
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        
    }
//    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
//    return nil
//    }
    
    /// 区域即将改变
    ///
    /// - Parameters:
    ///   - mapView:
    ///   - animated:
    func mapView(_ mapView: MAMapView!, regionWillChangeAnimated animated: Bool) {
        
    }
    
    /// 区域发生改变
  
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        
    }
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MobsAnnotation.self) {
            var annView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? CustomAnnotationView
            if annView == nil {
                annView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annView?.canShowCallout = false;
                annView?.isDraggable = false;
                annView?.calloutOffset = CGPoint(x:0, y:-5);
            }
            annView?.name = (annotation as! MobsAnnotation).name
//            annView?.portrait = UIImage.init(named: "location_g")
           return annView
        }
        return nil
    }
}

class MobsAnnotation: NSObject,MAAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var name : String?
    private var Subtitle: String?
    var tag : NSInteger = 0
    
}
