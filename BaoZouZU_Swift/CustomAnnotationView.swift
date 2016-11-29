//
//  CustomAnnotationView.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/29.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class CustomAnnotationView: MAAnnotationView {
    
    private var upImageView : UIImageView?
    private var annImageView : UIImageView?
    private var nameLabel : UILabel?

    private let kWidth = 100.0
    private let kHeight = 152.0

    var name : String?{
        didSet{
        nameLabel?.text = name
        }
    }
   
    var calloutView : UIView?
    
    
    override init!(annotation:MAAnnotation!,reuseIdentifier:String!){
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(kWidth), height: CGFloat(kHeight))
        self.backgroundColor = UIColor.clear
        /* Create portrait image view and add to view hierarchy. */
        self.upImageView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(0), width: CGFloat(90), height: CGFloat(28)))
        self.upImageView?.image = UIImage(named: "annotationView")!
        self.annImageView = UIImageView(frame: CGRect(x: CGFloat((self.upImageView?.frame.size.width)! / 2 + 5 - 18), y: CGFloat(28), width: CGFloat(36), height: CGFloat(48)))
        self.annImageView?.image = UIImage(named: "location_g")!.withRenderingMode(.automatic)
        self.addSubview(self.upImageView!)
        self.addSubview(self.annImageView!)
        /* Create name label. */
        self.nameLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(0), width: CGFloat(90), height: CGFloat(25)))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
