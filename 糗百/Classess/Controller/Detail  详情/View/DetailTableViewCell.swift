//
//  DetailTableViewCell.swift
//  糗百
//
//  Created by Youcai on 16/9/27.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    func CommentrowHeight(data:HomeData) -> CGFloat {
        self.data = data
        contentView.layoutIfNeeded()
        return  grayView.frame.maxY;
    }
    
    // MARK: - 模型赋值
    var data:HomeData? {
        didSet {
            
            if data?.user != nil {
                
                let iconString = "\(data!.user!.id)" as NSString
                
                iconView.sd_setImage(with:  URL.init(string: "http://pic.qiushibaike.com/system/avtnew/\(iconString.substring(to: 4))/\(data!.user!.id)/medium/\(data!.user!.icon!)"), placeholderImage: UIImage.init(named: "default_avatar"), options: [.retryFailed,.refreshCached], completed: {[weak self] (image, error, type, url) in
                    self?.iconView.addCorner(radius: 20)
                })
                
                namelbl.text = data!.user!.login!
            }else {
                
                iconView.image = UIImage.init(named: "default_avatar")
                namelbl.text = "匿名用户"
            }
            
            contentlbl.text = data!.content?.components(separatedBy: "楼：").last
            
            if (((data?.content)?.range(of: "回复")) != nil) {
                referView.isHidden = false
                referNamelbl.text = data?.refer?.user?.login
                referText.text = data?.refer?.content
                grayView.snp.remakeConstraints({ (make) in
                    make.top.equalTo(referView.snp.bottom).offset(10)
                    make.left.equalTo(contentlbl.snp.left)
                    make.right.equalTo(contentView.snp.right)
                    make.height.equalTo(0.5)
                })
            }else {
                referView.isHidden = true
                grayView.snp.remakeConstraints({ (make) in
                    make.top.equalTo(contentlbl.snp.bottom).offset(10)
                    make.left.equalTo(contentlbl.snp.left)
                    make.right.equalTo(contentView.snp.right)
                    make.height.equalTo(0.5)
                })
            }
            
        }
        
    }
    // MARK: - 构造方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.shouldRasterize = true
        layer.rasterizationScale =  UIScreen.main.scale
        layer.drawsAsynchronously = true
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    // MARK: - 设置界面
    func setUI() {
        
        contentView.addSubview(iconView)
        contentView.addSubview(namelbl)
        
        contentView.addSubview(contentlbl)
        contentView.addSubview(referView)
        referView.addSubview(referNamelbl)
        referView.addSubview(referText)
        
        contentView.addSubview(grayView)
        
        iconView .snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(10)
            make.width.height.equalTo(40)
        }
        namelbl .snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.top)
            make.left.equalTo(iconView.snp.right).offset(10)
            
        }
        
        contentlbl .snp.makeConstraints { (make) in
            make.top.equalTo(namelbl.snp.bottom).offset(10)
            make.left.equalTo(namelbl.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        referView .snp.makeConstraints { (make) in
            make.left.equalTo(contentlbl.snp.left)
            make.top.equalTo(contentlbl.snp.bottom).offset(5)
            
        }
        referNamelbl .snp.makeConstraints { (make) in
            make.top.equalTo(referView.snp.top).offset(5)
            make.left.equalTo(referView.snp.left).offset(5)
            
        }
        referText .snp.makeConstraints { (make) in
            make.top.equalTo(referNamelbl.snp.bottom).offset(5)
            make.left.equalTo(referNamelbl.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.bottom.equalTo(referView.snp.bottom).offset(-5)
        }
        
        
        
        grayView .snp.makeConstraints { (make) in
            make.top.equalTo(referView.snp.bottom).offset(10)
            make.left.equalTo(contentlbl.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0.5)
            //  make.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    // MARK: - 懒加载
    //回复
    private lazy var referView:UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(r: 239, g: 239, b: 239, a: 1.0)
        return view
    }()
    //
    private lazy var referNamelbl:UILabel = {
        let lbl = UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0),screenInset: 10)
        return lbl
    }()
    //
    private lazy var referText:UILabel = {
        let lbl =  UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 0)
        lbl.textAlignment = .left
        return lbl
    }()
    //头像
    private lazy var iconView:UIImageView = {
        let img = UIImageView.init()
        img.backgroundColor = WHITE_COLOR
        return img
    }()
    //昵称
    private lazy var namelbl:UILabel = {
        let lbl = UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0),screenInset: 10)
        return lbl
    }()
    
    //正文
    fileprivate lazy var contentlbl:UILabel = {
        let lbl =  UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 10)
        lbl.textAlignment = .left
        return lbl
    }()
   
    //分割线
    private lazy var grayView:UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(r: 231, g: 231, b: 231, a: 231)
        return view
    }()
}
