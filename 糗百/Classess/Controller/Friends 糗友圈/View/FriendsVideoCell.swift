//
//  FriendsVideoCell.swift
//  糗百
//
//  Created by Youcai on 16/11/16.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class FriendsVideoCell: FriendsTableViewCell {
//    override func rowHeight(data:FriendsData) -> CGFloat {
//        
//        
//        Data(FriendsData: data, index: nil)
//        contentView.layoutIfNeeded()
//        return  grayView.frame.maxY;
//    }
    // MARK: - 模型赋值
    override func Data(FriendsData: FriendsData?, index: IndexPath?) {
        super.Data(FriendsData: FriendsData, index: index)
        
        let h = FriendsData?.video?.height
        let w = FriendsData?.video?.width
        let height = h! * (SCREEN_WIDTH-60-10) / w!
        
        viedeoView.sd_setImage(with: URL.init(string: (FriendsData?.video?.pic_url)!)! , placeholderImage: UIImage.init().ImageWithColor(color:WHITE_COLOR))
        
        
        viedeoView.snp.updateConstraints { (make) in
            
            
            make.height.equalTo(height)
            
        }
        distancelbl.snp.remakeConstraints({ (make) in
            make.top.equalTo(viedeoView.snp.bottom).offset(10)
            
            
            
            make.left.equalTo(contentlbl.snp.left)
            make.width.equalTo(100)
        })
        
    }
    // MARK: - init
    override func setUI() {
        super.setUI()
        viedeoView.addSubview(playBtn)
        playBtn.snp.makeConstraints { (make) in
            make.center.equalTo(viedeoView)
        }
        viedeoView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentlbl.snp.bottom).offset(10)
            make.left.equalTo(contentlbl.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.height.equalTo(100)
        }
    }
    @objc private func BtnClick(sender:UIButton) {
        MMPlayerView.shardTools.placeholderImage =  viedeoView.image
        
        MMPlayerView.shardTools.setVideoURLwithTableViewAtIndexPathwithImageViewTag(videoURL: URL.init(string: (Friendsdata?.video?.high_url)!)!, tableView:self.superview?.superview as! UITableView,superView: viedeoView, tag: 101)
        MMPlayerView.shardTools.autoPlayTheVideo()
        
        
        
    }
    private lazy var playBtn:UIButton = {
        
        let view = UIButton.init(type: UIButtonType.custom)
        
        view.setImage(MMPlayerImage(file: "Player_play_btn"), for: .normal)
        
        view.addTarget(self, action: #selector(self.BtnClick(sender:)), for: .touchUpInside)
        
        return view
    }()
    
}
