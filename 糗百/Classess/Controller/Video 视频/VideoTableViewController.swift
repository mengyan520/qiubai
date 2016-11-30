//
//  VideoTableViewController.swift
//  糗百
//
//  Created by Youcai on 16/11/24.
//  Copyright © 2016年 mm. All rights reserved.
//https://m2.qiushibaike.com/article/list/video?count=30&page=1&AdID=1479973697518783571B68

import UIKit
import MJRefresh
class VideoTableViewController: UITableViewController {
    private var dataArray = [HomeData]()
    var page = 1
    var data:HomeData?
    override func viewDidLoad() {
        super.viewDidLoad()
        setNAV()
        view.backgroundColor = BLACK_COLOR
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction:  #selector(VideoTableViewController.loadMoreData))
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
        tableView.register(HomeVideoTableViewCell.self, forCellReuseIdentifier: VideoID)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        loadData()
    }
    func setNAV()  {
        let image = UIImage.init().ImageWithColor(color:CLEAR_COLOR)
        
        
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.init()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return dataArray[indexPath.row].rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoID, for: indexPath) as! HomeTableViewCell
        cell.Homedata(Homedata: data, index: indexPath)
        cell.backgroundColor = BLACK_COLOR
        for view in cell.contentView.subviews {
            view.backgroundColor = BLACK_COLOR
        }
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - 网络方法
    func loadData() {
        
        NetworkTools.shardTools.requestF(method: .GET, URLString:"https://m2.qiushibaike.com/article/list/video?count=30&page=1&AdID=1479973697518783571B68", parameters: nil) {[weak self] (result, error) in
            
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                let model = Model.init(dict: object)
                
                self?.dataArray = model.items!
                if self?.data?.high_url != model.items?[0].high_url {
                    self?.dataArray.insert((self?.data)!, at: 0)
                }
                if (self?.dataArray.count)! > 0 {
                    self?.tableView.mj_footer.isHidden = false
                }
                self?.tableView.reloadData()
                
            }
            
            
        }
    }
    
    func loadMoreData() {
        page = page+1
       
        NetworkTools.shardTools.requestF(method: .GET, URLString: "https://m2.qiushibaike.com/article/list/video?count=30&page=\(page)&AdID=1479973697518783571B68", parameters: nil) {[weak self] (result, error) in
            self?.tableView.mj_footer.endRefreshing()
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                let model = Model.init(dict: object)
                self?.dataArray = (self?.dataArray)! + model.items!
                
                self?.tableView.reloadData()
                if model.items!.count == 0 {
                    self?.tableView.mj_footer.isHidden = true
                }
            }
            
            
        }
        
    }

}
