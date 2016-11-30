//
//  DeatailViewController.swift
//  糗百
//
//  Created by Youcai on 16/9/30.
//  Copyright © 2016年 mm. All rights reserved.
// 糗友圈  详情 //https://circle.qiushibaike.com/article/8789925/info?longitude=116.4593160460782&latitude=39.87300024288396&count=30&page=1&AdID=1479699034788483571B68
//https://circle.qiushibaike.com/article/8789925/user/comment/list?count=30&page=1&AdID=1479699035067583571B68
//楼主回复
//https://m2.qiushibaike.com/article/118013626/comment/author?count=30&page=1&AdID=1479700492143883571B68
//https://m2.qiushibaike.com/article/118013626/hot/comments?count=30&page=1&AdID=1479700490604083571B68
//https://m2.qiushibaike.com/article/118013626/latest/comments?article=1&count=50&page=1&AdID=1479700490605083571B68

import UIKit
let commetnID = "comment"
//let hotcommetnID = "hotcommetnID"
class DeatailViewController: BaseViewController {
    var id = 0
    var dataArray = [Article]()
    
    var commetnsArray = [[HomeData]]()
    var isFrineds = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "糗事\(id)"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:Font(fontSize: 14),NSForegroundColorAttributeName:RGB(r: 85, g: 85, b: 106, a: 1.0)]
        
        loadCommentData()
        
        
        
        
        
        //添加键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(DeatailViewController.keyboardChanged(noti:)), name:NSNotification.Name.UIKeyboardWillChangeFrame , object: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - 网络方法
    func loadData() {
        var url  =  "/article/\(id)/latest/comments?article=1&count=50&page=1&AdID=1474965093760583571B68"
        if isFrineds {
            url = "https://circle.qiushibaike.com/article/8789925/info?longitude=116.4593160460782&latitude=39.87300024288396&count=30&page=1&AdID=1479699034788483571B68"
        }
        NetworkTools.shardTools.requestF(method: .GET, URLString: url, parameters: nil) { (result, error) in
            //  print(self.id)
            if error == nil {
                if error == nil {
                    guard let object = result as? [String: AnyObject] else {
                        print("格式错误")
                        return
                    }
                    let model = Model.init(dict: object)
                    
                    
                    self.dataArray.append(model.article!)
                    
                    self.commetnsArray.append(model.items!)
                    
                    
                    self.view.addSubview(self.tableView)
                    self.view.addSubview(self.bottomView)
                    self.bottomView.snp.makeConstraints { (make) in
                        make.bottom.equalTo(self.view.snp.bottom)
                        make.left.right.equalTo(self.view)
                        make.height.equalTo(49)
                    }
                }
                
                
            }
            
            
        }
    }
    
    func loadCommentData() {
        var url  = "/article/\(id)/hot/comments?count=30&page=1&AdID=1474965275245283571B68"
        if isFrineds {
            url = "https://circle.qiushibaike.com/article/\(id)/info?longitude=116.4593160460782&latitude=39.87300024288396&count=30&page=1&AdID=1479699034788483571B68"
        }
        
        NetworkTools.shardTools.requestF(method: .GET, URLString: url, parameters: nil) { (result, error) in
            
            if error == nil {
                if error == nil {
                    guard let object = result as? [String: AnyObject] else {
                        print("格式错误")
                        return
                    }
                    
                    let model = Model.init(dict: object)
                    
                    if self.isFrineds {
                        print(model.article!)
                        self.dataArray.append(model.article!)
                        self.commetnsArray.append(model.hot_comments!)
                        self.commetnsArray.append(model.comments!)
                        self.view.addSubview(self.tableView)
                    }else {
                        self.commetnsArray.append(model.items!)
                        self.loadData()
                    }
                }
                
                
            }
            
            
        }
    }
    
    // MARK: - 懒加载
    lazy var tableView:UITableView = {
        let view = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-49-64), style: .grouped)
        view.backgroundColor = RGB(r: 249, g: 249, b: 249, a: 1.0)
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: textID)
        view.register(HomeImageTableViewCell.self, forCellReuseIdentifier: ImageID)
        view.register(HomeVideoTableViewCell.self, forCellReuseIdentifier: VideoID)
        view.register(DetailTableViewCell.self, forCellReuseIdentifier: commetnID)
        // view.register(DetailTableViewCell.self, forCellReuseIdentifier: hotcommetnID)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.estimatedRowHeight = 200
        return view
    }()
    lazy var bottomView:BottomCommentView = {
        let view = BottomCommentView.init(frame:CGRect.init())
        return view
    }()
}
// MARK: - 数据源/代理方法
extension DeatailViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return dataArray.count
            
        }else {
            
            return commetnsArray[section-1].count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return dataArray[indexPath.row].ArticlerowHeight
            
        }
        return commetnsArray[indexPath.section-1][indexPath.row].CommentrowHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if    section == 0  {
            return 0.1
        }
        if commetnsArray[section-1].count == 0  {
            return 0.1
        }
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if  section == 0  {
            return nil
        }
        if commetnsArray[section-1].count == 0 {
            return nil
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        let lbl = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_WIDTH, height: 20))
        view.addSubview(lbl)
        if section == 1 {
            lbl.text = "热门评论 \(commetnsArray[section-1].count)"
            view.backgroundColor = WHITE_COLOR
        }else {
            lbl.text = "最新评论 \(commetnsArray[section-1].count)"
            view.backgroundColor = RGB(r: 249, g: 249, b: 249, a: 1.0)
        }
        lbl.font = Font(fontSize: 12)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let data = dataArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: data.cellId, for: indexPath) as! HomeTableViewCell
            
            if self.commetnsArray[0].count == 0 {
                cell.Detaildata(data: data, isView: false)
            }else {
                cell.Detaildata(data: data, isView: true)
            }
            return cell
        }else  if indexPath.section == 1 {
            
            let data = commetnsArray[indexPath.section-1][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: commetnID, for: indexPath) as! DetailTableViewCell
            cell.data = data
            cell.backgroundColor = WHITE_COLOR
            return cell
            
        }
        else {
            let data = commetnsArray[indexPath.section-1][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: commetnID, for: indexPath) as! DetailTableViewCell
            cell.data = data
            cell.backgroundColor = RGB(r: 249, g: 249, b: 249, a: 1.0)
            return cell
            
            
        }
        
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomView.textView.resignFirstResponder()
    }
}
// MARK: - 评论
extension DeatailViewController {
    //键盘处理
    func keyboardChanged(noti:NSNotification) {
        // print(noti)
        // 1. 获取目标的 rect - 字典中的`结构体`是 NSValue
        let rect = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 获取目标的动画时长 - 字典中的数值是 NSNumber
        let duration = (noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // 动画曲线数值
        let curve = (noti.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        
        let    offset = rect.origin.y - SCREEN_HEIGHT
        // 2. 更新约束
        //print(offset)
        
        // print(rect.origin.y)
        bottomView.snp.updateConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp.bottom).offset(offset)
        }
        //    bottomView.frame = CGRect.init(x: 0, y: -offset, width: SCREEN_WIDTH, height: 49)
        //     self.bottomView.frame = CGRect.init(x: 0, y:offset , width: SCREEN_WIDTH, height: 49)
        // 3. 动画 － UIView 块动画 本质上是对 CAAnimation 的包装
        UIView.animate(withDuration: duration) { () -> Void in
            // 设置动画曲线
            /**
             曲线值 = 7
             － 如果之前的动画没有完成，有启动了其他的动画，让动画的图层直接运动到后续动画的目标位置
             － 一旦设置了 `7`，动画时长无效，动画时长统一变成 0.5s
             */
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            
            self.view.layoutIfNeeded()
            
        }
        
        // 调试动画时长 － keyPath 将动画添加到图层
        // let anim = toolbar.layer.animationForKey("position")
        //  print("动画时长 \(anim?.duration)")
    }
    
}
