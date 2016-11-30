//
//  HomeImageTableViewCell.swift
//  糗百
//
//  Created by Youcai on 16/6/7.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class HomeImageTableViewCell: HomeTableViewCell {
//    override func ArticlerowHeight(data:Article) -> CGFloat {
//      // self.data = data
//        Detaildata(data: data, isView: true)
//        contentView.layoutIfNeeded()
//        return  grayView.frame.maxY;
//    }
    
    // MARK: - 模型赋值
    override func Detaildata(data: Article?, isView: Bool?) {
        super.Detaildata(data: data, isView: isView)
        let h = data?.image_size?.m![1]
        let w = data?.image_size?.m![0]
        let dd = CGFloat(h!) * (SCREEN_WIDTH-20) / CGFloat(w!)
        let idString:NSString = "\(data!.id)" as NSString
        
        pictureView.sd_setImage(with: URL.init(string:"http://pic.qiushibaike.com/system/pictures/\(idString.substring(to: 5))/\(data!.id)/medium/\(data!.image!)?imageView2/2/w/720")!, placeholderImage: UIImage.init().ImageWithColor(color:WHITE_COLOR))
        
        pictureView.snp.updateConstraints { (make) in
            make.height.equalTo(dd)
        }
        lovelbl.snp.remakeConstraints({ (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(10)
            make.left.equalTo(pictureView.snp.left)
        })

    }
//       override func rowHeight(data:HomeData) -> CGFloat {
//        //Homedata = data
//         Homedata(Homedata: data, index: nil)
//        contentView.layoutIfNeeded()
//        return  grayView.frame.maxY;
//    }
    
    // MARK: - 模型赋值
    override func Homedata(Homedata: HomeData?, index: IndexPath?) {
        super.Homedata(Homedata: Homedata, index: index)
        if ((Homedata?.image_size) != nil) {
            
            let h = Homedata?.image_size!.m![1]
            let w = Homedata?.image_size!.m![0]
            let dd = h! * (SCREEN_WIDTH-20) / w!
            let idString:NSString = "\(Homedata!.id)" as NSString
            
            pictureView.sd_setImage(with: URL.init(string:"http://pic.qiushibaike.com/system/pictures/\(idString.substring(to: 5))/\(Homedata!.id)/medium/\(Homedata!.image!)?imageView2/2/w/720")!, placeholderImage: UIImage.init().ImageWithColor(color:WHITE_COLOR))
            
            pictureView.snp.updateConstraints { (make) in
                make.height.equalTo(dd)
            }
            lovelbl.snp.remakeConstraints({ (make) in
                make.top.equalTo(pictureView.snp.bottom).offset(10)
                make.left.equalTo(pictureView.snp.left)
            })
        }

    }

    override func setUI() {
        super.setUI()
        
        // 3> 配图视图
     
        pictureView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentlbl.snp.bottom).offset(10)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
           make.height.equalTo(100)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapClick))
        pictureView.addGestureRecognizer(tap)
    
    }
    func tapClick()  {
        
        let idString:NSString = "\((Homedata != nil) ? Homedata!.id : Detaildata!.id)" as NSString
        
        var urls = [NSURL]()
        
        urls.append(NSURL.init(string:"http://pic.qiushibaike.com/system/pictures/\(idString.substring(to: 5))/\((Homedata != nil) ? Homedata!.id : Detaildata!.id)/medium/\((Homedata != nil) ? Homedata!.image! : Detaildata!.image!)?imageView2/2/w/720")!)
        
        let userInfo:NSDictionary = ["key": IndexPath.init(item: 0, section: 0),
                                     "url": urls ]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "picHome"), object: self, userInfo: userInfo as? [AnyHashable : Any])
    }
    override func long(long: UILongPressGestureRecognizer) {
        if long.state == .began {
            del?.shareClcik(text: Homedata?.content, img: pictureView.image,id: Homedata?.id)
        }
    }
}
