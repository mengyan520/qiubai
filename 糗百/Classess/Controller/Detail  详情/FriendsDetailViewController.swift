//
//  FriendsDetailViewController.swift
//  糗百
//
//  Created by Youcai on 16/12/5.
//  Copyright © 2016年 mm. All rights reserved.
//糗友圈
//https://circle.qiushibaike.com/article/9191116/user/comment/list?count=30&page=1&AdID=1480923564608083571B68

//https://circle.qiushibaike.com/article/9191116/info?longitude=116.4592811435692&latitude=39.87269973558644&count=30&page=1&AdID=1480923564411683571B68
import UIKit

class FriendsDetailViewController: BaseViewController {
    fileprivate  var commetnsArray = [HomeData]()
    var dataArray = [Article]()
    var isVideo = false
    var height:CGFloat = 0
    var id = 0
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "详情"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:Font(fontSize: 14),NSForegroundColorAttributeName:RGB(r: 85, g: 85, b: 106, a: 1.0)]
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(49)
        }
        loadCommentData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isVideo {
            
            MMPlayerView.shardTools.resetPlayer()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 网络方法
    
    
    func loadCommentData() {
        
        let  url = "https://circle.qiushibaike.com/article/\(id)/info?longitude=116.4592811435692&latitude=39.87269973558644&count=30&page=1&AdID=1480923564411683571B68"
        
        
        NetworkTools.shardTools.requestF(method: .GET, URLString: url, parameters: nil) { (result, error) in
            
            if error == nil {
                
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                
                let model = Model.init(dict: object)
                self.dataArray = [model.article!]
                self.commetnsArray = model.comments!
                self.tableView.reloadData()
                
                
                
                
            }
            
            
        }
    }
    
    
    
    // MARK: - 懒加载
    fileprivate lazy var tableView:UITableView = {
        let view = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-49-64), style: .grouped)
        view.backgroundColor = RGB(r: 249, g: 249, b: 249, a: 1.0)
        
        view.register(FriendsTableViewCell.self, forCellReuseIdentifier: nearbyID)
        view.register(FriendsVideoCell.self, forCellReuseIdentifier: videoID)
        view.register(DetailTableViewCell.self, forCellReuseIdentifier: commetnID)
        
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.estimatedRowHeight = 200
        view.sectionFooterHeight = 0.1
        return view
    }()
    fileprivate   lazy var bottomView:BottomCommentView = {
        let view = BottomCommentView.init(frame:CGRect.init())
        return view
    }()
    
}
// MARK: - 数据源/代理方法
extension FriendsDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return dataArray.count
        }
        return commetnsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let data = dataArray[indexPath.row]
           
            let cell = tableView.dequeueReusableCell(withIdentifier: data.cellId, for: indexPath) as! FriendsTableViewCell
          
            cell.DeatailData(data: data, index: indexPath)
            cell.selectionStyle = .none
            
            return cell
        }else {
            
            let data = commetnsArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: commetnID, for: indexPath) as! DetailTableViewCell
            
            cell.data = data
            cell.backgroundColor = RGB(r: 249, g: 249, b: 249, a: 1.0)
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if    section == 0  {
            return 0.1
        }
        
        return 20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return height-5
        }
        return commetnsArray[indexPath.row].CommentrowHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if  section == 0 || commetnsArray.count == 0 {
            return nil
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        let lbl = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_WIDTH, height: 20))
        view.addSubview(lbl)
        
        lbl.text = "最新评论 \(commetnsArray.count)"
        view.backgroundColor = RGB(r: 249, g: 249, b: 249, a: 1.0)
        
        lbl.font = Font(fontSize: 12)
        
        return view
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomView.textView.resignFirstResponder()
    }
}
