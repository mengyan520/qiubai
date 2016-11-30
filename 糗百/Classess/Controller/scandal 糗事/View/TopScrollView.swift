//
//  TopScrollView.swift
//  内涵段子
//
//  Created by Youcai on 16/9/23.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
import SnapKit
protocol TopScrollViewDel:NSObjectProtocol {
    func topBtnClick(sender:UIButton)
}

class TopScrollView: UIView {
    var isScroll:Bool = true
    var titles:[String]? {
        didSet {
           
            scrollView.contentSize = CGSize.init(width: 60*titles!.count, height: 0)
            switch titles!.count {
            case 6:
                scrollView.contentSize = CGSize.init(width: 60*titles!.count, height: 0)
                break
             case 4:
                scrollView.frame = CGRect.init(x: 40+20, y: 0, width: SCREEN_WIDTH-80-40, height:44)
                scrollView.contentSize = CGSize.init(width: 60*titles!.count+20, height: 0)
                leftBtn.setImage(UIImage.init(named: "qbf_foot"), for: .normal)
                 rightBtn.setImage(UIImage.init(named: "nearby_group_add"), for: .normal)
                break
            case 2:
                scrollView.frame = CGRect.init(x: (SCREEN_WIDTH-120)/2, y: 0, width: 120, height:44)
                scrollView.contentSize = CGSize.init(width: 130, height: 0)
                leftBtn.isHidden = true
                rightBtn.setImage(UIImage.init(named: "nearby_group_add"), for: .normal)
                break
            default:
                break
                
            }
            for i in 0..<titles!.count {
                let btn = UIButton.setBackImageName(nil, imgName: nil, title: titles?[i], color: RGB(r: 142, g: 142, b: 142, a: 1.0), selectedlcolor: mainColor, action: #selector(self.BtnClick(sender:)), target: self)
                btn?.titleLabel?.font = Font(fontSize: 16)
                let width:CGFloat  =  60
                btn?.tag = i
                if i == 0 {
                    BtnClick(sender: btn!)
                }
                btn?.frame = CGRect.init(x: width * CGFloat(i), y: 0, width: width, height: scrollView.height)
                scrollView.addSubview(btn!)
                
            }
            
        }
    }
    // MARK: - 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(bottomView)
        leftBtn.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(self)
            make.width.equalTo(40)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(self)
            make.width.equalTo(40)
        }
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 点击事件
    func BtnClick(sender:UIButton) {
      
        currentBtn.isSelected = false
        currentBtn = sender
        sender.isSelected = true
        if isScroll {
             //print("dfs")
            del?.topBtnClick(sender: sender)
        }
    }
    // MARK: - 懒加载
    var del:TopScrollViewDel?
    private lazy var currentBtn:UIButton = {
        let btn = UIButton.init()
        return btn
    }()
    lazy var scrollView:UIScrollView = {
        let view = UIScrollView.init(frame: CGRect.init(x: 40, y: 0, width: self.bounds.size.width-80, height: self.bounds.size.height))
        view.showsHorizontalScrollIndicator = false
        return view
    }()
   private lazy var bottomView:UIView = {
        let view = UIView.init(frame: CGRect.init(x:0, y: 43, width: self.bounds.size.width, height: 1))
          view.backgroundColor = WHcolor
        return view
    }()
    private lazy var leftBtn:UIButton = {
        let btn = UIButton.setBackImageName(nil, imgName: "icon_review", title: nil, color: nil, selectedlcolor: nil, action: nil, target: nil)
        return btn!
    }()
    private lazy var rightBtn:UIButton = {
        let btn = UIButton.setBackImageName(nil, imgName: "nearby_group_add", title: nil, color: nil, selectedlcolor: nil, action: nil, target: nil)
        return btn!
    }()
}
