//
//  HomeTableViewController.swift
//  糗百
//
//  Created by Youcai on 16/9/26.
//  Copyright © 2016年 mm. All rights reserved.

import UIKit

import  MJRefresh
let textID = "textID"
let ImageID = "imageID"
let VideoID = "VideoID"

class HomeTableViewController: UITableViewController,HomeCellDel {
    var name:String = "text"
    var tag = 0
    var date = "2014-03-05"
    
    var page = 1
    
    var dataArray = [HomeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = WHITE_COLOR
        let refreshheader = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadData))
        tableView.mj_header = refreshheader
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction:  #selector(HomeTableViewController.loadMoreData))
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: textID)
        tableView.register(HomeImageTableViewCell.self, forCellReuseIdentifier: ImageID)
        tableView.register(HomeVideoTableViewCell.self, forCellReuseIdentifier: VideoID)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.noti(noti:)), name: NSNotification.Name(rawValue: "picHome"), object: nil)
        
        loadData()
    }
    
    func noti(noti:NSNotification) {
        
        guard let indexPath = noti.userInfo?["key"] as? IndexPath else {
            return
        }
        guard let urls = noti.userInfo?["url"] as? [NSURL] else {
            return
        }
        // 判断 cell 是否遵守了展现动画协议！
        guard let cell = noti.object as? PhotoBrowserPresentDelegate else {
            
            return
        }
        
        
        let vc = PhotoBrowserViewController(urls: urls, indexPath: indexPath as NSIndexPath,isColl:false)
        
        // 1. 设置modal的类型是自定义类型 Transition(转场)
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        // 2. 设置动画代理
        vc.transitioningDelegate = self.photoBrowserAnimator
        // 3. 设置 animator 的代理参数
        self.photoBrowserAnimator.setDelegateParams(presentDelegate: cell, indexPath: indexPath , dismissDelegate: vc)
        
        // 3. Modal 展现
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return dataArray.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return dataArray[indexPath.row].rowHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArray[indexPath.row]
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: data.cellId, for: indexPath) as! HomeTableViewCell
        
        
        cell.Homedata(Homedata: data, index: indexPath)
        cell.del = self
        
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if name == "history" {
            let view = UIView.init()
            
            let rightlbl = UILabel.init(title: "换一天", fontSize: 12, color: mainColor, screenInset: 0)
            view.backgroundColor = WHITE_COLOR
            view.addSubview(rightlbl)
            rightlbl.snp.makeConstraints({ (make) in
                make.centerY.equalTo(view.snp.centerY)
                make.right.equalTo(view.snp.right).offset(-10)
            })
            
            let leftlbl = UILabel.init(title: date, fontSize: 12, color: BLACK_COLOR, screenInset: 0)
            
            view.addSubview(leftlbl)
            leftlbl.snp.makeConstraints({ (make) in
                make.centerY.equalTo(view.snp.centerY)
                make.left.equalTo(view.snp.left).offset(10)
            })
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewController.Refresh))
            view.addGestureRecognizer(tap)
            return view
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if name == "history" {
            
            return 20
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if name == "video" {
            //            let controller = VideoTableViewController()
            //            controller.hidesBottomBarWhenPushed = true
            //           controller.data = dataArray[indexPath.row]
            //            navigationController?.pushViewController(controller, animated: true)
        }else {
            
            let controller = DeatailViewController()
            controller.hidesBottomBarWhenPushed = true
            controller.id = dataArray[indexPath.row].id
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    func bottomBtnViewClick(sender: UIButton,index:IndexPath?) {
        switch sender.tag {
        case 2:
            let controller = DeatailViewController()
            controller.hidesBottomBarWhenPushed = true
            controller.id = dataArray[(index?.row)!].id
            navigationController?.pushViewController(controller, animated: true)
            
            break
        default: break
            
        }
    }
    func topViewClick(uid: NSInteger) {
        
        let controller = UserViewController()
        controller.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    func shareClcik(text: String?, img: UIImage?, id: NSInteger?) {
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) -> Void in
            //创建分享消息对象
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.text = "社会化组件UShare将各大社交平台接入您的应用，快速武装App。"//分享的文本
            
            /*
             //1.分享图片
             var shareObject:UMShareImageObject = UMShareImageObject.init()
             shareObject.title = "Umeng分享"//显不显示有各个平台定
             shareObject.descr = "描述信息"//显不显示有各个平台定
             shareObject.thumbImage = UIImage.init(named: "icon")//显不显示有各个平台定
             shareObject.shareImage = "http://dev.umeng.com/images/tab2_1.png"
             messageObject.shareObject = shareObject;
             */
            
            //2.分享分享网页
            let shareObject:UMShareWebpageObject = UMShareWebpageObject.init()
            shareObject.title = "分享标题"//显不显示有各个平台定
            shareObject.descr = "描述信息"//显不显示有各个平台定
            shareObject.thumbImage = UIImage.init(named: "icon")//缩略图，显不显示有各个平台定
            shareObject.webpageUrl = "http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html"
            messageObject.shareObject = shareObject;
             //调用分享接口
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) -> Void in
                if error != nil {
                    print("Share Fail with error ：%@", error)
                }else{
                    print("Share succeed")
                }
                
            })
            
        }

    }
    func PlayBtnViewClick(sender: UIButton, tableView: UITableView, pictureView: UIImageView,url:String) {
        
        MMPlayerView.shardTools.placeholderImage =  pictureView.image
        MMPlayerView.shardTools.setVideoURLwithTableViewAtIndexPathwithImageViewTag(videoURL: URL.init(string: url)!, tableView:tableView,superView: pictureView, tag: 101)
        MMPlayerView.shardTools.autoPlayTheVideo()
    }
    @objc private  func Refresh() {
        tableView.mj_header.beginRefreshing()
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
        
    }
    // MARK: - 网络方法
    func loadData() {
        var url = name + "?count=30&page=1"
        if name == "history" {
            url = "http://m2.qiushibaike.com/article/history?history?count=30&readarticles=%5B3965915%2C41931570%5D&page=1&AdID=1476340810383983571B68"
        }
        // print(url)
        NetworkTools.shardTools.requestF(method: .GET, URLString:url, parameters: nil) { (result, error) in
            self.tableView.mj_header.endRefreshing()
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                SQLiteManager.sharedManager.createTable(name: self.name)
                SQLiteManager.sharedManager.saveCacheData(array: object["items"] as! [[String : AnyObject]],name:self.name)
                let model = Model.init(dict: object)
                if  (model.date != nil) {
                    self.date = model.date!
                }
                if self.name != "history" {
                    
                    
                    if self.dataArray.count > 0{
                        
                        if (model.items?.last?.published_at)! <= (self.dataArray.first?.published_at)! {
                            return
                        }
                    }
                }
                
                self.dataArray = model.items!
                if self.dataArray.count > 0 {
                    self.tableView.mj_footer.isHidden = false
                }
                self.tableView.reloadData()
                
            }else {
                var arr = [HomeData]()
                for data in SQLiteManager.sharedManager.checkChacheData(name:self.name)! {
                    arr.append(HomeData.init(dict: (data )))
                    
                }
                self.dataArray = arr
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    func loadMoreData() {
        page = page+1
        var url = name + "?count=30&page=\(page)&AdID=1474965093760583571B68"
        if name == "history" {
            url = "http://m2.qiushibaike.com/article/history?history?count=30&readarticles=%5B3965915%2C41931570%5D&page=1&AdID=1476340810383983571B68"
        }
        NetworkTools.shardTools.requestF(method: .GET, URLString: url, parameters: nil) { (result, error) in
            self.tableView.mj_footer.endRefreshing()
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                SQLiteManager.sharedManager.saveCacheData(array: object["items"] as! [[String : AnyObject]],name:self.name)
                let model = Model.init(dict: object)
                self.dataArray = self.dataArray + model.items!
                
                self.tableView.reloadData()
                if model.items!.count == 0 {
                    self.tableView.mj_footer.isHidden = true
                }
            }else {
                var arr = [HomeData]()
                for data in SQLiteManager.sharedManager.checkChacheData(name:self.name)! {
                    arr.append(HomeData.init(dict: (data )))
                    
                }
                self.dataArray = arr
                self.tableView.reloadData()
            }
            
            
            
        }
        
    }
    
    /// 照片查看转场动画代理
    private lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
}

