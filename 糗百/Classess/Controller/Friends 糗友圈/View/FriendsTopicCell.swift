//
//  FriendsTopicCell.swift
//  糗百
//
//  Created by Youcai on 16/11/16.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class FriendsTopicCell: UITableViewCell {
    // MARK: - 模型赋值
    func rowHeight(data:FriendsData) -> CGFloat {
        
        
        Data(FriendsData: data, index: nil)
        contentView.layoutIfNeeded()
        return  grayView.frame.maxY;
    }
    func Data(FriendsData:FriendsData?,index:IndexPath?) {
       // iconView.sd_setImage(with: URL.init(string:(FriendsData?.avatar_urls?.first?.pic_url)! ), placeholderImage: nil)
        iconView.sd_setImage(with:  URL.init(string:(FriendsData?.avatar_urls?.first?.pic_url)! ), placeholderImage: UIImage.init(named: "default_avatar"), options: [.retryFailed,.refreshCached], completed: {[weak self] (image, error, type, url) in
            self?.iconView.addCorner(radius: 5)
        })
        titlelbl.text = FriendsData?.content
        contentlbl.text = FriendsData?.abstract
        countlbl.text = "动态 \(FriendsData!.article_count)  今日\(FriendsData!.today_article_count)"
        // rowlbl.text = "\(index!.row + 1)"
        
        typelbl.isHidden = !FriendsData!.is_anonymous
        guard index != nil  else {
            
            return
        }
        switch index!.row {
            
        case 0:
            rowlbl.text = "  "
            rowlbl.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "nearby_group_top_gold")!)
            break
        case 1:
            rowlbl.text = "  "
            rowlbl.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "nearby_group_top_silver")!)
            break
        case 2:
            rowlbl.text = "  "
            rowlbl.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "nearby_group_top_brone")!)
            break
        default:
            rowlbl.text = "\(index!.row + 1)"
            rowlbl.backgroundColor = WHITE_COLOR
            break
            
        }
        //折线图
        
    }
    // MARK: - 构造方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = WHITE_COLOR
        setUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 设置界面
    func setUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(titlelbl)
        contentView.addSubview(typelbl)
        contentView.addSubview(contentlbl)
        contentView.addSubview(countlbl)
        contentView.addSubview(rowlbl)
        contentView.addSubview(grayView)
        
        iconView .snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(10)
            make.width.height.equalTo(60)
        }
        titlelbl .snp.makeConstraints { (make) in
            
            make.left.equalTo(iconView.snp.right).offset(10)
           
            make.top.equalTo(iconView.snp.top)
        }
        typelbl.snp.makeConstraints { (make) in
            
            make.left.equalTo(titlelbl.snp.right).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(16)
            make.top.equalTo(titlelbl.snp.top)
        }
        contentlbl .snp.makeConstraints { (make) in
            make.top.equalTo(titlelbl.snp.bottom).offset(5)
            make.left.equalTo(titlelbl.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-50)
        }
        countlbl .snp.makeConstraints { (make) in
            make.top.equalTo(contentlbl.snp.bottom).offset(5)
            make.left.equalTo(titlelbl.snp.left)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        rowlbl .snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.width.equalTo(20)
        }
        grayView .snp.makeConstraints { (make) in
            make.top.equalTo(countlbl.snp.bottom).offset(10)
            make.left.equalTo(contentView.snp.left)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(5)
          //  make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    // MARK: - 懒加载
    //头像
    fileprivate lazy var iconView:UIImageView = {
        let img = UIImageView.init()
        
        img.backgroundColor = WHITE_COLOR
        return img
    }()
    
    fileprivate lazy var titlelbl:UILabel = {
        let lbl = UILabel.init(title: "昵称", fontSize: 14, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 10)
        lbl.numberOfLines = 1
        return lbl
    }()
    fileprivate lazy var typelbl:UILabel = {
        let lbl = UILabel.init(title: "匿名", fontSize: 10, color: WHITE_COLOR, screenInset: 0)
        lbl.backgroundColor = UIColor.purple
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 4
        return lbl
    }()
    
    lazy var contentlbl:UILabel = {
        
        let lbl = UILabel.init(title: "标题", fontSize: 12, color: RGB(r: 163, g: 163, b: 155, a: 1.0), screenInset: 35)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    fileprivate lazy var rowlbl:UILabel = {
        let lbl = UILabel.init(title: "标题", fontSize: 14, color: RGB(r: 163, g: 163, b: 155, a: 1.0), screenInset: 0)
        return lbl
    }()
    
    fileprivate lazy var countlbl:UILabel = {
        let lbl = UILabel.init(title: "标题", fontSize: 14, color: RGB(r: 163, g: 163, b: 155, a: 1.0), screenInset: 0)
        return lbl
    }()
   
        
    //分割线
    lazy var grayView:UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(r: 239, g: 239, b: 239, a: 1.0)
        return view
    }()
}
