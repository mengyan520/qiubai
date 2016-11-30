//
//  PunchesView.swift
//  糗百
//
//  Created by Youcai on 16/11/23.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class PunchesView: UIView {
    var punches:[TimeInterval]? {
        didSet {
            namelbl.text = "最近\(punches!.count)次打卡"
            
            let dd:NSMutableArray = NSMutableArray.init()
            let ddd:NSMutableArray = NSMutableArray.init()
            var m = 1
            
            for time in punches! {
                dd.add((NSDate.ew_formatAbssTime(withInterval: time) as NSString).substring(to: 2))
                ddd.add(NSDate.ew_formatAbssTime(withInterval: time)  )
                var Bomlbl = viewWithTag(m) as? UILabel
                if Bomlbl == nil {
                   
                    
                    if m <= punches!.count - 1 {
                        
                        Bomlbl = UILabel.init(title: "\(m+1)", fontSize: 14, color: WHITE_COLOR, screenInset: 10)
                        Bomlbl?.tag = m
                        
                        addSubview(Bomlbl!)
                        Bomlbl!.snp.makeConstraints({ (make) in
                            make.left.equalTo(currentlbl.snp.right)
                            make.width.equalTo(currentlbl.snp.width)
                            if m == punches!.count - 1 {
                                
                                make.right.equalTo(bottomLine.snp.right).offset(-5)
                            }
                            make.bottom.equalTo(snp.bottom).offset(-5)
                        })
                        currentlbl = Bomlbl!
                    }
                }
                m = m + 1
               
            }
            
            let top = dd.value(forKeyPath: "@max.self") as! String
            let bom = dd.value(forKeyPath: "@min.self") as! String
            var  i = 0
            for value in ddd {
                if (value as! String).hasPrefix(top) {
                    if (value as! String).hasPrefix("23")  {
                        topTimelbl.text =  NSDate.ew_formatAbssTime(withInterval: punches![i] )
                    }else {
                        topTimelbl.text =  NSDate.ew_formatAbssTime(withInterval: punches![i] + 3600)
                    }
                }
                if (value as! String).hasPrefix(bom){
                    if (value as! String).hasPrefix("00")  {
                        bottomTimelbl.text = NSDate.ew_formatAbssTime(withInterval: punches![i] )
                    }else {
                        bottomTimelbl.text = NSDate.ew_formatAbssTime(withInterval: punches![i] - 3600)
                    }
                    
                }
                i = i + 1
            }
            
            for lbl in subviews {
                if lbl.isKind(of: UILabel.self) {
                    lbl.isHidden = false
                    if lbl.tag + 1 > punches!.count   {
                        lbl.isHidden = true
                    }
                }
            }
        }
    }
    // MARK: - init
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 5
        backgroundColor = RGB(r: 253, g: 177, b: 31, a: 1.0)
        addSubview(namelbl)
        addSubview(topTimelbl)
        addSubview(bottomTimelbl)
        addSubview(bottomlbl)
        addSubview(topLine)
        addSubview(bottomLine)
        currentlbl = bottomlbl
        namelbl.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10)
            make.top.equalTo(snp.top).offset(5)
        }
        topTimelbl.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-5)
            make.top.equalTo(namelbl.snp.bottom).offset(5)
            
        }
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(namelbl.snp.bottom).offset(10)
            make.left.equalTo(namelbl.snp.left)
            make.right.equalTo(topTimelbl.snp.left).offset(-5)
            make.height.equalTo(1)
        }
        bottomlbl.snp.makeConstraints { (make) in
            make.left.equalTo(namelbl.snp.left).offset(15)
            make.bottom.equalTo(snp.bottom).offset(-5)
            //make.width.equalTo(20)
        }
        
        bottomTimelbl.snp.makeConstraints { (make) in
            
            make.left.equalTo(topTimelbl.snp.left)
            make.bottom.equalTo(bottomlbl.snp.top).offset(-10)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomlbl.snp.top).offset(-15)
            make.left.equalTo(namelbl.snp.left)
            make.right.equalTo(bottomTimelbl.snp.left).offset(-5)
            make.height.equalTo(1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 懒加载
    private lazy var namelbl:UILabel = {
        let lbl = UILabel.init(title: "最近7次打卡", fontSize: 14, color: WHITE_COLOR, screenInset: 10)
        
        return lbl
    }()
    private lazy var topTimelbl:UILabel = {
        let lbl = UILabel.init(title: "00:00", fontSize: 10, color: WHITE_COLOR, screenInset: 10)
        return lbl
    }()
    private lazy var bottomTimelbl:UILabel = {
        let lbl = UILabel.init(title: "00:00", fontSize: 10, color: WHITE_COLOR, screenInset: 10)
        return lbl
    }()
    private lazy var currentlbl = UILabel.init()
    private lazy var bottomlbl:UILabel = {
        let lbl = UILabel.init(title: "1", fontSize: 14, color: WHITE_COLOR, screenInset: 10)
        lbl.tag = 0
        
        return lbl
    }()
    
    private lazy var topLine:UIView = {
        let view = UIView.init()
        view.backgroundColor = WHITE_COLOR
        return view
    }()
    private lazy var bottomLine:UIView = {
        let view = UIView.init()
        view.backgroundColor = WHITE_COLOR
        return view
        
    }()
}
