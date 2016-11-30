//
//  HomeTableViewCell.swift
//  糗百
//
//  Created by Youcai on 16/6/6.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
import MediaPlayer
import SDWebImage
protocol HomeCellDel:NSObjectProtocol {
    //跳转个人信息界面
    func topViewClick(uid:NSInteger)
    //分享
    func shareClcik(text:String?,img:UIImage?,id:NSInteger?)
    func bottomBtnViewClick(sender:UIButton,index:IndexPath?)
    func PlayBtnViewClick(sender:UIButton,tableView:UITableView,pictureView:UIImageView,url:String)
}
class HomeTableViewCell: UITableViewCell {
    func rowHeight(data:HomeData) -> CGFloat {
        //Homedata = data
        Homedata(Homedata: data, index: nil)
        contentView.layoutIfNeeded()
        return  grayView.frame.maxY;
    }
    func ArticlerowHeight(data:Article) -> CGFloat {
        //self.data = data
        Detaildata(data: data, isView: true)
        contentView.layoutIfNeeded()
        return  grayView.frame.maxY;
    }
    // MARK: - 模型赋值
    func Detaildata(data:Article?,isView:Bool?) {
        self.Detaildata = data
       
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
        
        typelbl.text = data!.type
        
        contentlbl.text = data!.content
        lovelbl.text = "好笑 " + "\(data!.votes!.up)" + "  ·  评论 " + "\(data!.comments_count)" + "  ·  分享 " + "\(data!.share_count)"
        
        grayView.snp.updateConstraints { (make) in
            if isView! {
            make.height.equalTo(1)
            }else {
                make.height.equalTo(0)

            }
        }

    }
func Homedata(Homedata:HomeData?,index:IndexPath?) {
        
        self.index = index
        self.Homedata = Homedata
        if Homedata?.user != nil {
            
            let iconString = "\(Homedata!.user!.id)" as NSString
            
            iconView.sd_setImage(with:  URL.init(string: "http://pic.qiushibaike.com/system/avtnew/\(iconString.substring(to: 4))/\(Homedata!.user!.id)/medium/\(Homedata!.user!.icon!)"), placeholderImage: UIImage.init(named: "default_avatar"), options: [.retryFailed,.refreshCached], completed: {[weak self] (image, error, type, url) in
                self?.iconView.addCorner(radius: 20)
            })
            
            namelbl.text = Homedata!.user!.login!
        }else {
            
            iconView.image = UIImage.init(named: "default_avatar")
            namelbl.text = "匿名用户"
        }
        
        typelbl.text = Homedata!.type
        contentlbl.text = Homedata!.content
        lovelbl.text = "好笑 " + "\(Homedata!.votes!.up)" + "  ·  评论 " + "\(Homedata!.comments_count)" + "  ·  分享 " + "\(Homedata!.share_count)"
    
    
        if ((Homedata?.hot_comment) != nil) {
            hotlbl.isHidden = false
            hotlbl.text = (Homedata?.hot_comment?.user?.login)! + "：" + (Homedata?.hot_comment?.content)!
            grayView.snp.remakeConstraints({ (make) in
               
                make.top.equalTo(hotlbl.snp.bottom).offset(10)
                make.left.equalTo(contentView.snp.left)
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(10)
            })
        hotlbl.attributedText = hotlbl.text!.SubStringColor(subString: (Homedata?.hot_comment?.user?.login!)!, color: RGB(r: 85, g: 85, b: 106, a: 1.0), font: Font(fontSize: 12))
        }else {
            hotlbl.isHidden = true
            grayView.snp.remakeConstraints({ (make) in
                make.top.equalTo(loveBtn.snp.bottom).offset(10)
                make.left.equalTo(contentView.snp.left)
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(10)
                
            })
            
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
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(HomeTableViewCell.long(long:)))
        self.addGestureRecognizer(long)
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
            del?.shareClcik(text: Homedata?.content, img: nil,id: Homedata?.id)
        }
    }
    func  topClick(tap:UITapGestureRecognizer) {
        if Homedata?.user != nil {
            
            del?.topViewClick(uid: (Homedata?.user?.uid)!)
        }
        
    }
    func btnClick(sender:UIButton) {
        currentBtn.isSelected = false
        currentBtn = sender
        sender.isSelected = true
        del?.bottomBtnViewClick(sender: sender,index: self.index)
    }
   
    // MARK: - 懒加载
   weak var del:HomeCellDel?
    var index:IndexPath?
    var Homedata:HomeData?
    var Detaildata:Article?
    lazy var topView:UIView = {
        let view = UIView.init()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewCell.topClick(tap:)))
        view.addGestureRecognizer(tap)
        view.backgroundColor = WHITE_COLOR
        return view
    }()
    //头像
    private lazy var iconView:UIImageView = {
        let img = UIImageView.init()
       
        // img.backgroundColor = WHITE_COLOR
        return img
    }()
    //昵称
    private lazy var namelbl:UILabel = {
        let lbl =  UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 10)
         lbl.backgroundColor = CLEAR_COLOR
        return lbl
    }()
    //状态
    private lazy var typelbl:UILabel = {
        let lbl =  UILabel.init(title: "", fontSize: 14, color: RGB(r: 163, g: 163, b: 155, a: 1.0), screenInset: 0)
                 lbl.backgroundColor = CLEAR_COLOR
        return lbl
    }()
    //正文
    lazy var contentlbl:UILabel = {
        let lbl =  UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 10)
        return lbl
    }()
    //图片
    lazy var pictureView:UIImageView = {
        let img = UIImageView.init()
        img.isUserInteractionEnabled = true
        img.backgroundColor = WHITE_COLOR
        return img
    }()
    //好笑 //评论
    lazy var lovelbl:UILabel = {
        //
        let lbl = UILabel.init(title: "昵称", fontSize: 14, color:  RGB(r: 212, g: 212, b: 215, a: 1.0), screenInset: 10)
        return lbl
    }()
    private lazy var currentBtn:UIButton = {
        let btn = UIButton.init()
        return btn
    }()
    lazy var loveBtn:UIButton = {
        let btn = UIButton.init(imageName: "icon_for", backImageName: nil, SelectedImageName: "icon_for_active", target: self, actionName: #selector(self.btnClick(sender:)))
        btn.tag = 0
        return btn
    }()
    lazy var againstBtn:UIButton = {
        
        let btn = UIButton.init(imageName: "icon_against", backImageName: nil, SelectedImageName: "icon_against_active", target: self, actionName: #selector(self.btnClick(sender:)))
        btn.tag = 1
        return btn
    }()
    lazy var commentBtn:UIButton = {
        let btn = UIButton.init(imageName: "icon_chat", backImageName: nil, SelectedImageName: nil, target: self, actionName:  #selector(self.btnClick(sender:)))
        btn.tag = 2
        return btn
    }()
    lazy var shareBtn:UIButton = {
        let btn = UIButton.init(imageName: "icon_fav", backImageName: nil, SelectedImageName: nil, target: self, actionName:  #selector(self.btnClick(sender:)))
        btn.tag = 3
        return btn
    }()
    //热门评论
    lazy var hotlbl:UILabel = {
        let lbl = UILabel.init(title: "昵称", fontSize: 12, color:  RGB(r: 212, g: 212, b: 215, a: 1.0), screenInset: 10)
        return lbl
    }()
    //分割线
    lazy var grayView:UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(r: 239, g: 239, b: 239, a: 1.0)
        return view
    }()

    // MARK: - 设置界面
    func setUI() {
        contentView.addSubview(topView)
        topView.addSubview(iconView)
        topView.addSubview(namelbl)
        topView.addSubview(typelbl)
        contentView.addSubview(contentlbl)
   
        contentView.addSubview(lovelbl)
        contentView.addSubview(loveBtn)
        contentView.addSubview(againstBtn)
        contentView.addSubview(commentBtn)
        contentView.addSubview(shareBtn)
        contentView.addSubview(hotlbl)
        contentView.addSubview(grayView)
       
        contentView.addSubview(pictureView)
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
        typelbl .snp.makeConstraints { (make) in
            make.top.equalTo(namelbl.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        contentlbl .snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.left.equalTo(iconView.snp.left)
            
        }
        lovelbl .snp.makeConstraints { (make) in
            make.top.equalTo(contentlbl.snp.bottom).offset(10)
            make.left.equalTo(iconView.snp.left)
            
        }
        loveBtn .snp.makeConstraints { (make) in
            make.top.equalTo(lovelbl.snp.bottom).offset(10)
            make.left.equalTo(iconView.snp.left)
            make.width.equalTo(60)
        }
        againstBtn .snp.makeConstraints { (make) in
            make.top.equalTo(lovelbl.snp.bottom).offset(10)
            make.left.equalTo(loveBtn.snp.right)
            make.width.equalTo(60)
            make.bottom.equalTo(loveBtn.snp.bottom)
        }
        commentBtn .snp.makeConstraints { (make) in
            make.top.equalTo(lovelbl.snp.bottom).offset(10)
            make.left.equalTo(againstBtn.snp.right)
            make.width.equalTo(60)
            make.bottom.equalTo(loveBtn.snp.bottom)
        }
        shareBtn .snp.makeConstraints { (make) in
            make.top.equalTo(lovelbl.snp.bottom).offset(10)
            make.right.equalTo(contentView.snp.right)
            make.width.equalTo(60)
            make.bottom.equalTo(loveBtn.snp.bottom)
        }
        hotlbl .snp.makeConstraints { (make) in
            make.top.equalTo(loveBtn.snp.bottom).offset(10)
            make.left.equalTo(iconView.snp.left)
            
        }
        grayView .snp.makeConstraints { (make) in
            make.top.equalTo(hotlbl.snp.bottom).offset(10)
            make.left.equalTo(contentView.snp.left)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(10)
            //  make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
// MARK: - 照片查看器的展现协议
extension HomeTableViewCell: PhotoBrowserPresentDelegate {
    
    /// 创建一个 imageView 在参与动画
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView {
        
        let iv = UIImageView()
        
        // 1. 设置内容填充模式
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        // 2. 设置图像（缩略图的缓存）- SDWebImage 如果已经存在本地缓存，不会发起网络请求
       
         let idString:NSString = "\((Homedata != nil) ? Homedata!.id : Detaildata!.id)" as NSString
       
        if let url =  URL.init(string:"http://pic.qiushibaike.com/system/pictures/\(idString.substring(to: 5))/\((Homedata != nil) ? Homedata!.id : Detaildata!.id)/medium/\((Homedata != nil) ? Homedata!.image! : Detaildata!.image!)?imageView2/2/w/720"){
            iv.sd_setImage(with: url)
        }
        
        return iv
    }
    
    /// 动画起始位置
    func photoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect {
        
      
       
        let rect = self.convert(pictureView.frame, to: UIApplication.shared.keyWindow)
        
        return rect
    }
    
    /// 目标位置
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect {
        
        // 根据缩略图的大小，等比例计算目标位置
        let idString:NSString = "\((Homedata != nil) ? Homedata!.id : Detaildata!.id)" as NSString
//        guard let key = "http://pic.qiushibaike.com/system/pictures/\(idString.substring(to: 5))/\(Homedata!.id)/medium/\(Homedata!.image!)?imageView2/2/w/720"
//            else {
//                return .zero
//        }
        let key = "http://pic.qiushibaike.com/system/pictures/\(idString.substring(to: 5))/\((Homedata != nil) ? Homedata!.id : Detaildata!.id)/medium/\((Homedata != nil) ? Homedata!.image! : Detaildata!.image!)?imageView2/2/w/720"
         //从 sdwebImage 获取本地缓存图片
        guard let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key) else {
            return .zero
        }
        
        // 根据图像大小，计算全屏的大小
        let w = UIScreen.main.bounds.width
        let h = image.size.height * w / image.size.width
        
        // 对高度进行额外处理
        let screenHeight = UIScreen.main.bounds.height
        var y: CGFloat = 0
        if h < screenHeight {       // 图片短，垂直居中显示
            y = (screenHeight - h) * 0.5
        }
        
        let rect = CGRect(x: 0, y: y, width: w, height: h)
        
        return rect
    }
}
