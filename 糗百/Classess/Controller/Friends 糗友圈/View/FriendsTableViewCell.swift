//
//  FriendsTableViewCell.swift
//  糗百
//
//  Created by Youcai on 16/11/8.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol FriendsCellDel:NSObjectProtocol {
    //跳转个人信息界面
    func topViewClick(uid:NSInteger)
    func CopyTextClick(index:IndexPath)
}
class FriendsTableViewCell: UITableViewCell,TTTAttributedLabelDelegate {
    func rowHeight(data:FriendsData) -> CGFloat {
        
       
        Data(FriendsData: data, index: nil)
        contentView.layoutIfNeeded()
        return  grayView.frame.maxY;
    }
    // MARK: - 模型赋值
    var isFrineds:Bool? {
        didSet {
            pictureView.isFrineds = isFrineds!
        }
    }
    func Data(FriendsData:FriendsData?,index:IndexPath?) {
        //http://pic.qiushibaike.com/system/avtnew/2222/22225573/medium/20141030234259.jpg
        self.index = index
        self.Friendsdata = FriendsData
        if FriendsData?.user != nil {
            
            let iconString = "\(FriendsData!.user!.id)" as NSString
            
            
            iconView.sd_setImage(with:  URL.init(string: "http://pic.qiushibaike.com/system/avtnew/\(iconString.substring(to: 4))/\(FriendsData!.user!.id)/medium/\(FriendsData!.user!.icon!)"), placeholderImage: UIImage.init(named: "default_avatar"), options: [.retryFailed,.refreshCached], completed: {[weak self] (image, error, type, url) in
                
                self?.iconView.addCorner(radius: 20)
            })
            namelbl.text = FriendsData!.user!.login!
        }else {
            
            iconView.image = UIImage.init(named: "default_avatar")
            namelbl.text = "匿名用户"
        }
        
        if (FriendsData?.is_me)! {
            namelbl.textColor =  RGB(r: 220, g: 33, b: 36, a: 1.0)
        }else {
            namelbl.textColor =  RGB(r: 99, g: 99, b: 99, a: 1.0)
        }
        contentlbl.text = FriendsData!.content
        
        pictureView.imgData = FriendsData?.pic_urls
        pictureView.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(pictureView.bounds.height)
            // 直接设置宽度数值
            make.width.equalTo(pictureView.bounds.width)
            let offset = (FriendsData?.pic_urls?.count)! > 0 ? 10 : 0
            make.top.equalTo(contentlbl.snp.bottom).offset(offset)
        }
        timeBtn.setTitle(Date.init().timeStringWithInterval(time: (FriendsData?.created_at)!), for: .normal)
        distancelbl.text = FriendsData?.distance
        if ((FriendsData?.topic) != nil) {
            
            let range =  (contentlbl.text! as NSString).range(of: (FriendsData?.topic?.content)!)
            
            contentlbl.addLink(to: URL.init(string: "http://github.com/mattt/"), with: range)
            
            
        }
        
        if let punches = FriendsData?.punches {
            if punches.count > 0 {
                punchesView.isHidden = false
                punchesView.punches = punches
                punchesView.snp.makeConstraints({ (make) in
                    make.top.equalTo(pictureView.snp.bottom).offset(10)
                    make.left.equalTo(contentlbl.snp.left)
                    make.right.equalTo(contentView.snp.right).offset(-10)
                    make.height.equalTo(200)
                })
                distancelbl.snp.remakeConstraints({ (make) in
                    
                    make.top.equalTo(punchesView.snp.bottom).offset(10)
                    
                    make.left.equalTo(contentlbl.snp.left)
                    make.width.equalTo(100)
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
        backgroundColor = WHITE_COLOR
        setUI()
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(self.long(long:)))
        self.addGestureRecognizer(long)
        
    }
    // MARK: - 设置界面
    func setUI() {
        contentView.addSubview(topView)
        topView.addSubview(iconView)
        topView.addSubview(namelbl)
        topView.addSubview(sexlbl)
        topView.addSubview(timeBtn)
        contentView.addSubview(contentlbl)
        contentView.addSubview(distancelbl)
        contentView.addSubview(pictureView)
        contentView.addSubview(viedeoView)
        contentView.addSubview(grayView)
        contentView.addSubview(punchesView)
        
        topView .snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(60)
        }
        iconView .snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(10)
            make.width.height.equalTo(40)
        }
        namelbl .snp.makeConstraints { (make) in
            
            make.left.equalTo(iconView.snp.right).offset(10)
            
            make.centerY.equalTo(iconView.snp.centerY)
        }
        timeBtn .snp.makeConstraints { (make) in
            
            make.right.equalTo(contentView.snp.right).offset(-10)
            
            make.centerY.equalTo(namelbl.snp.centerY)
        }
        sexlbl .snp.makeConstraints { (make) in
            make.top.equalTo(namelbl.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        contentlbl .snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.left.equalTo(namelbl.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        pictureView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentlbl.snp.bottom).offset(10)
            make.left.equalTo(contentlbl.snp.left)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        distancelbl .snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(10)
            make.left.equalTo(contentlbl.snp.left)
            make.width.equalTo(100)
        }
        grayView .snp.makeConstraints { (make) in
            make.top.equalTo(distancelbl.snp.bottom).offset(10)
            make.left.equalTo(contentView.snp.left)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(5)
          //  make.bottom.equalTo(contentView.snp.bottom)
        }
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
    // MARK: - action
    func long(long:UILongPressGestureRecognizer)  {
        if long.state == .began {
            del?.CopyTextClick(index: index!)
        }
    }
    func btnClick(sender:UIButton) {
        
        del?.CopyTextClick(index: index!)
    }
    func  topClick(tap:UITapGestureRecognizer) {
        
        
    }
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
    }
    // MARK: - 懒加载
    weak var del:FriendsCellDel?
    var index:IndexPath?
    
    var Friendsdata:FriendsData?
    private var imgArray = [UIImageView]()
    lazy var topView:UIView = {
        let view = UIView.init()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(FriendsTableViewCell.topClick(tap:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    //头像
    private lazy var iconView:UIImageView = {
        let img = UIImageView.init()
        img.backgroundColor = WHITE_COLOR
        
        return img
    }()
    //昵称
    private lazy var namelbl:UILabel = {
        //
        let lbl = UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 10)
        return lbl
    }()
    //状态
    private lazy var sexlbl:UILabel = {
        
        let lbl =  UILabel.init(title: "", fontSize: 14, color: RGB(r: 163, g: 163, b: 155, a: 1.0), screenInset: 0)
        return lbl
    }()
    //正文
    lazy var contentlbl:TTTAttributedLabel = {
        
        let lbl = TTTAttributedLabel.init(frame: .zero)
        lbl.textColor = RGB(r: 99, g: 99, b: 99, a: 1.0)
        lbl.font = Font(fontSize: 14)
        lbl.delegate = self
        lbl.numberOfLines = 0
        return lbl
    }()
    //时间
    private lazy var timeBtn:UIButton = {
        let btn = UIButton.init(title: "1小时之前", color: RGB(r: 99, g: 99, b: 99, a: 1.0), fontSize: 12, target: self, actionName: #selector(self.btnClick(sender:)))
        return btn
    }()
    //地点
    lazy var distancelbl:UILabel = {
        let lbl = UILabel.init(title: "昵称", fontSize: 12, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 10)
        return lbl
    }()
    /// 配图视图
    lazy var pictureView: FriendsPictureView = FriendsPictureView()
    //视频图片
    lazy var viedeoView:UIImageView = {
        let img = UIImageView.init()
        img.isUserInteractionEnabled = true
        img.backgroundColor = WHITE_COLOR
        return img
    }()
    
    //分割线
    lazy var grayView:UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(r: 239, g: 239, b: 239, a: 1.0)
        return view
    }()
    private lazy var punchesView:PunchesView = {
        let view = PunchesView.init()
        view.isHidden = true
        return view
    }()
}
