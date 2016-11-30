//
//  UserViewController.swift
//  糗百
//
//  Created by Youcai on 16/11/29.
//  Copyright © 2016年 mm. All rights reserved.
//https://m2.qiushibaike.com/user/13483791/recent?AdID=1480405939040783571B68

import UIKit

class UserViewController: UIViewController {
    var timer:Timer?
    var count:CGFloat = 5
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = WHITE_COLOR
        view.addSubview(bottomView)
        
        progressView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-50, width: 0, height: 50)
        view.addSubview(progressView)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    func long(long:UILongPressGestureRecognizer)  {
        if long.state == .began {
            
              timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.start), userInfo: nil, repeats: true)
        }else if long.state == .ended {
           
           resetTimer()
        }
    }
    func start()  {
       progressView.width = SCREEN_WIDTH / count
        UIView.animate(withDuration: 0.5) {
            
            self.progressView.progress = SCREEN_WIDTH / self.count
        }
        count = count - 1
        if count == 0 {
            resetTimer()
        }
    }
    func resetTimer() {
        if  ((timer?.isValid) != nil) {
            timer!.invalidate()
            timer = nil
        }
        
    }
    private lazy var bottomView:UIView = {
     let view = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT-50, width: SCREEN_WIDTH, height: 50))
        view.backgroundColor = WHITE_COLOR
      let topLine = UIView.init(frame: CGRect.init(x: 0, y:0, width: SCREEN_WIDTH, height: 0.5))
        topLine.backgroundColor = RGB(r: 199, g: 199, b: 199, a: 1.0)
        view.addSubview(topLine)
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(self.long(long:)))
        view.addGestureRecognizer(long)
        return view
    }()
   private lazy var progressView: ProgressView = ProgressView()
}
private class ProgressView: UIView {
    
    /// 内部使用的进度值 0~1
    var progress: CGFloat = 0 {
        didSet {
            print("df")
            // 重绘视图
            setNeedsDisplay()
        }
    }
    fileprivate override func draw(_ rect: CGRect) {
          print("d")
                let path = UIBezierPath.init(rect: CGRect.init(x: rect.origin.x, y: rect.origin.y, width: progress, height:  rect.size.height))
                path.lineWidth = 1
                path.lineCapStyle = .round
                path.lineJoinStyle = .bevel
                let fillColor = mainColor
                fillColor.set()
                path.fill()
                let strokeColor = UIColor.blue
                strokeColor.set()
                path.stroke()
    }

}
