    //
    //  HomeVideoTableViewCell.swift
    //  糗百
    //
    //  Created by Youcai on 16/6/8.
    //  Copyright © 2016年 mm. All rights reserved.
    //
    
    import UIKit
    
    class HomeVideoTableViewCell: HomeTableViewCell {
//        override func ArticlerowHeight(data:Article) -> CGFloat {
//            // self.data = data
//            Detaildata(data: data, isView: true)
//            contentView.layoutIfNeeded()
//            return  grayView.frame.maxY;
//        }
        
        // MARK: - 模型赋值
        override func Detaildata(data: Article?, isView: Bool?) {
            
            super.Detaildata(data: data, isView: isView)
            let h = data?.image_size?.m![1]
            let w = data?.image_size?.m![0]
            let height = CGFloat(h!) * (SCREEN_WIDTH-20) / CGFloat(w!)
            
            pictureView.sd_setImage(with: NSURL.init(string: (data?.pic_url)!)! as URL, placeholderImage: UIImage.init().ImageWithColor(color:WHITE_COLOR))
            pictureView.snp.updateConstraints { (make) in
                
                
                make.height.equalTo(height)
                
            }
            lovelbl.snp.remakeConstraints({ (make) in
                make.top.equalTo(pictureView.snp.bottom).offset(10)
                make.left.equalTo(pictureView.snp.left)
            })    }
//        override func rowHeight(data:HomeData) -> CGFloat {
//            //Homedata = data
//            Homedata(Homedata: data, index: nil)
//            contentView.layoutIfNeeded()
//            return  grayView.frame.maxY;
//        }
        // MARK: - 模型赋值
        override func Homedata(Homedata: HomeData?, index: IndexPath?) {
            
            super.Homedata(Homedata: Homedata, index: index)
            if ((Homedata?.image_size) != nil) {
                
                let h = Homedata?.image_size!.m![1]
                let w = Homedata?.image_size!.m![0]
                let height = h! * (SCREEN_WIDTH-20) / w!
                
                pictureView.sd_setImage(with: NSURL.init(string: (Homedata?.pic_url)!)! as URL, placeholderImage: UIImage.init().ImageWithColor(color:WHITE_COLOR))
                
                
                pictureView.snp.updateConstraints { (make) in
                    
                    
                    make.height.equalTo(height)
                    
                }
                lovelbl.snp.remakeConstraints({ (make) in
                    make.top.equalTo(pictureView.snp.bottom).offset(10)
                    make.left.equalTo(pictureView.snp.left)
                })
            }
        }
        
        
        override func setUI() {
            super.setUI()
            pictureView.addSubview(playBtn)
            playBtn.snp.makeConstraints { (make) in
                make.center.equalTo(pictureView)
            }
            // 3> 配图视图
            
            pictureView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(contentlbl.snp.bottom).offset(10)
                make.left.equalTo(contentView.snp.left).offset(10)
                make.right.equalTo(contentView.snp.right).offset(-10)
                make.height.equalTo(100)
            }
            
            
        }
        @objc private func BtnClick(sender:UIButton) {
            
          
           del?.PlayBtnViewClick(sender: sender, tableView: self.superview?.superview as! UITableView, pictureView: pictureView,url:(Homedata != nil) ? Homedata!.high_url! : Detaildata!.high_url!)
        
        }
        private lazy var playBtn:UIButton = {
            
            let view = UIButton.init(type: UIButtonType.custom)
            
            view.setImage(MMPlayerImage(file: "Player_play_btn"), for: .normal)
            
            view.addTarget(self, action: #selector(self.BtnClick(sender:)), for: .touchUpInside)
            
            return view
        }()
        
        
        
    }
