//
//  FriendsTableViewController.swift
//  糗百
//
//  Created by Youcai on 16/11/8.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
let nearbyID = "nearby"
let videoID = "video"
let topicID = "topic"
class FriendsTableViewController: UITableViewController,FriendsCellDel {
    var name:String = "nearby"
    var tag = 0
    
    var page = 1
    var isFrineds = false
    private var dataArray = [FriendsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadData()
        let refreshheader = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(FriendsTableViewController.loadData))
        tableView.mj_header = refreshheader
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction:  #selector(FriendsTableViewController.loadMoreData))
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
        
        
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: nearbyID)
        tableView.register(FriendsVideoCell.self, forCellReuseIdentifier: videoID)
        tableView.register(FriendsTopicCell.self, forCellReuseIdentifier: topicID)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        if !isFrineds {
            
            NotificationCenter.default.addObserver(self, selector: #selector(FriendsTableViewController.noti(noti:)), name: NSNotification.Name(rawValue: "pic"), object: nil)
        }else {
            
            NotificationCenter.default.addObserver(self, selector: #selector(FriendsTableViewController.noti(noti:)), name: NSNotification.Name(rawValue: "topic"), object: nil)
        }
        if name == "topic" {
            tableView.tableHeaderView = searchView
            
        }
        //        if !isFrineds {
        //
        definesPresentationContext = true
        //        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFrineds {
            
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:Font(fontSize: 14),NSForegroundColorAttributeName:RGB(r: 85, g: 85, b: 106, a: 1.0)]
        }
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
        
        
        let vc = PhotoBrowserViewController(urls: urls, indexPath: indexPath as NSIndexPath,isColl:true)
        
        // 1. 设置modal的类型是自定义类型 Transition(转场)
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        // 2. 设置动画代理
        vc.transitioningDelegate = self.photoBrowserAnimator
        // 3. 设置 animator 的代理参数
        self.photoBrowserAnimator.setDelegateParams(presentDelegate: cell, indexPath: indexPath , dismissDelegate: vc)
        
        // 3. Modal 展现
        
        self.present(vc, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArray[indexPath.row]
        if (data.rank != 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: data.cellId, for: indexPath) as! FriendsTopicCell
            
            cell.Data(FriendsData: data, index: indexPath)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: data.cellId, for: indexPath) as! FriendsTableViewCell
            cell.Data(FriendsData: data, index: indexPath)
            cell.isFrineds = isFrineds
            cell.del = self
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
      
        return dataArray[indexPath.row].FrinedsrowHeight
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //        let controller = DeatailViewController()
        //        controller.isFrineds = true
        //        controller.hidesBottomBarWhenPushed = true
        //        controller.id = dataArray[indexPath.row].id
        //        navigationController?.pushViewController(controller, animated: true)
        
        if name == "topic" {
            
            
            
            let controller = FriendsTableViewController()
            controller.hidesBottomBarWhenPushed = true
            controller.isFrineds = true
            controller.name = "\( dataArray[indexPath.row].id)"
            controller.title = dataArray[indexPath.row].content
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchView.resignFirstResponder()
    }
    // MARK: - 网络方法
    func loadData() {
        
        var url = "http://circle.qiushibaike.com/article/\(name)/list?latitude=39.87291324420127&longitude=116.4591759582881&page=1&AdID=1478591258129283571B68"
        
        if name == "topic" {
            url = "http://circle.qiushibaike.com/article/topic/top?count=20&page=1&AdID=1478591343628383571B68"
        }
        if isFrineds {
            url = "https://circle.qiushibaike.com/article/topic/\(name)/all?topic_id=\(name)&latitude=39.87311577636352&longitude=116.4591024761955&page=1&AdID=1479698933714483571B68"
            
        }
        
        NetworkTools.shardTools.requestF(method: .GET, URLString:url, parameters: nil) {[weak self] (result, error) in
            self?.tableView.mj_header.endRefreshing()
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                
                let model = Model.init(dict: object)
                
                self?.dataArray = model.data!
                if (self?.dataArray.count)! > 0 {
                    self?.tableView.mj_footer.isHidden = false
                }
                self?.tableView.reloadData()
                
            }
        }
        
    }
    func loadMoreData() {
        page = page+1
        var url = "http://circle.qiushibaike.com/article/\(name)/list?latitude=39.87291324420127&longitude=116.4591759582881&page=\(page)&AdID=1478591258129283571B68"
        if name == "topic" {
            url = "http://circle.qiushibaike.com/article/topic/top?count=20&page=\(page)&AdID=1478591343628383571B68"
        }
        if isFrineds {
            url = "https://circle.qiushibaike.com/article/topic/\(name)/all?topic_id=\(name)&latitude=39.87311577636352&longitude=116.4591024761955&page=\(page)&AdID=1479698933714483571B68"
        }
        NetworkTools.shardTools.requestF(method: .GET, URLString: url, parameters: nil) {[weak self]  (result, error) in
            self?.tableView.mj_footer.endRefreshing()
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                
                let model = Model.init(dict: object)
                self?.dataArray = (self?.dataArray)! + model.data!
                
                self?.tableView.reloadData()
                if model.data!.count == 0 {
                    self?.tableView.mj_footer.isHidden = true
                }
            }
            
            
        }
        
    }
    // MARK: - action
    func topViewClick(uid: NSInteger) {
        
    }
    func CopyTextClick(index: IndexPath) {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction.init(title: "举报", style: .default, handler: nil)
        let action3 = UIAlertAction.init(title: "不感兴趣", style: .default, handler: nil)
        
        let action4 = UIAlertAction.init(title: "复制文字", style: .default,  handler: {[weak self] (UIAlertAction) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = self?.dataArray[index.row].content
            
            SVProgressHUD.showSuccess(withStatus: "已复制")
        })
        
        alertVC.addAction(action4)
        alertVC.addAction(action3)
        alertVC.addAction(action2)
        alertVC.addAction(action1)
        self.present(alertVC, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    /// 照片查看转场动画代理
    private lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    //搜索框
    
    private lazy var searchView:UISearchBar = {
        let view = UISearchBar.init(frame: CGRect.init(x: 5, y: 0, width: SCREEN_WIDTH-10, height: 44))
        view.placeholder = "搜索话题"
        view.searchBarStyle = .minimal
        let searchField = view.value(forKey: "_searchField") as! UITextField
        searchField.textColor = RGB(r: 100, g: 100, b: 100, a: 1.0)
        
        return view
    }()
    deinit {
        
        REMOVENOTIFICATION(sender:self)
    }
}
