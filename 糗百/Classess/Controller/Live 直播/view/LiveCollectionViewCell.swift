//
//  LiveCollectionViewCell.swift
//  糗百
//
//  Created by Youcai on 16/10/13.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class LiveCollectionViewCell: UICollectionViewCell {
    var data:Lives? {
        didSet {
          iconView.sd_setImage(with: URL.init(string: (data?.thumbnail_url!)!), placeholderImage: nil)
        }
    }
     // MARK: - 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     // MARK: - UI 
   private  func setUI()  {
        contentView.addSubview(iconView)
    contentView.addSubview(namelbl)
    contentView.addSubview(titlelbl)
    contentView.addSubview(countlbl)
    iconView .snp.makeConstraints { (make) in
        make.edges.equalTo(contentView)
    }

    }
     // MARK: - 懒加载
    //头像
    private lazy var iconView:UIImageView = {
        let img = UIImageView.init()
       
        return img
    }()
    //昵称
    private lazy var namelbl:UILabel = {
        let lbl = UILabel.setLabelTitle(nil, textColor: RGB(r: 99, g: 99, b: 99, a: 1.0), labelFont: 12, screenInset: 10)
        return lbl!
    }()
    //人数
    private lazy var countlbl:UILabel = {
        let lbl = UILabel.setLabelTitle(nil, textColor: RGB(r: 163, g: 163, b: 155, a: 1.0), labelFont: 14, screenInset: 0)
        return lbl!
    }()
    //标题
    lazy var titlelbl:UILabel = {
        let lbl = UILabel.setLabelTitle(nil, textColor: RGB(r: 99, g: 99, b: 99, a: 1.0), labelFont: 16, screenInset: 10)
        return lbl!
    }()
}
