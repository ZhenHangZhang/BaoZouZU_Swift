//
//  CustomTableViewCell.swift
//  BaoZouZU_Swift
//
//  Created by zhanghangzhen on 2016/11/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    let PI =  3.14159265358979323846

    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var lonLabel: UILabel!
    
    var model :LocationDataModel?{
        didSet{
            self.latLabel.text = model?.latitude
            self.lonLabel.text = model?.longitude
            if model?.issuccess == "success" {
                self.statusImg.image = UIImage.init(named: "success")
            }else{
                self.statusImg.image = UIImage.init(named: "fail")
            }
            let timeA = model!.currenttimeminute!.components(separatedBy: " ") as NSArray
            self.timeLabel.text = timeA.lastObject as! String?
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func draw(_ rect: CGRect) {
        drawLine(rect: rect)
        drawCircle(point: CGPoint(x: 20, y: 30), radius: 8)
    }
    
}
extension CustomTableViewCell{

    fileprivate func drawLine(rect:CGRect){
        let context = UIGraphicsGetCurrentContext()
        //边缘样式
        context!.setLineCap(.round);
        // 线的宽度
        context!.setLineWidth(1);
        context!.setAllowsAntialiasing(true);
        //线的颜色
        context!.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0.2);
        context!.beginPath();
        //起点
        context?.move(to: CGPoint(x: 18, y: 0))
        //终点坐标
        context?.addLine(to: CGPoint(x: CGFloat(18), y: rect.size.height))
        context!.strokePath()
    }
    
    fileprivate func drawCircle(point:CGPoint,radius:CGFloat){
        
        //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
        let context = UIGraphicsGetCurrentContext();
        /*画圆*/
        let aColor = RGBColor(255, g: 255, b: 255, a: 1.0)
        
        context!.setStrokeColor(red: 255, green: 194, blue: 0, alpha: 1.0);
        context!.setFillColor(aColor.cgColor);//填充颜色
        context!.setLineWidth(5);//线的宽度
        
        context?.addArc(center: CGPoint(x: CGFloat(18), y: point.y), radius: radius, startAngle: 0, endAngle: CGFloat(2.0*PI), clockwise: true)
        //添加一个圆
        //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
        context!.drawPath(using: .fillStroke); //绘制路径加填充
    }
    
    
}
