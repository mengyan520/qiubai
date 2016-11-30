//
//  MeTableViewController.swift
//  仿66
//
//  Created by Youcai on 16/6/21.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

private let ID = "cell"
class MeTableViewController: UITableViewController {
    private var titleArray:[[String]]?
    private var imageArray:[[String]]?
    private lazy var headerView:HeaerView = {
        let view = HeaerView.init(frame:CGRect.init(x:0, y:0,width: SCREEN_WIDTH,height: 200))
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutNavigationBar()
        setTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 设置导航栏
    func layoutNavigationBar() {
        title = "我"
      //  let image = UIImage.setImageWith(RGB(r: 248, g: 201, b: 0, a: 1.0))
     //   navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.init()
    }
    // MARK: - tableView
    func setTableView() {
        
        titleArray = [["收到的评论"],["赞过的帖子","我的评论"],["设置"]]
        imageArray = [["pinlun"],["zantiezi","pingluntiezi"],["shezhi"]]
        tableView.tableHeaderView = headerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = RGB(r: 242, g: 242, b: 242, a: 1.0)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
        return (titleArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray![section].count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
   
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath)
        cell.textLabel?.text = titleArray![indexPath.section][indexPath.row]
       cell.selectionStyle = .none
        cell.imageView?.image = UIImage.init(named:imageArray![indexPath.section][indexPath.row])
         cell.accessoryType = .disclosureIndicator;
        if indexPath.section == 1  && indexPath.row == 0 {
            
            let grayView = UIView.init()
            grayView.backgroundColor = WHcolor;
            cell.contentView.addSubview(grayView)
         
            //grayView.frame = CGRect.init(x: 0, y: cell.contentView.bottom, width: SCREEN_WIDTH, height: 1)
            grayView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint.init(item:grayView , attribute: .left, relatedBy: .equal, toItem: cell.textLabel, attribute: .left, multiplier: 1, constant: 0))
            cell.contentView.addConstraint(NSLayoutConstraint.init(item:grayView , attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottom, multiplier: 1, constant: 0))
            cell.contentView.addConstraint(NSLayoutConstraint.init(item:grayView , attribute: .right, relatedBy: .equal, toItem: cell.contentView, attribute: .right, multiplier: 1, constant: 19))
            cell.contentView.addConstraint(NSLayoutConstraint.init(item:grayView , attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 1))
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
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: - 头部视图
private class HeaerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var backView:UIView = {
        let view = UIView.init()
        
        return view
    }()
    private lazy var iconView:UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = true
        img.layer.cornerRadius = 25
        img.image = UIImage.init(named: "morentouxiang_images02")
        return img
    }()
    private lazy var namelbl:UILabel = {
        let lbl = UILabel.setLabelTitle("梦之记忆", textColor: BLACK_COLOR, labelFont: 14, screenInset: 0)
        
        return lbl!
    }()
    private lazy var sublbl:UILabel = {
        let lbl = UILabel.setLabelTitle("主人很懒，还木有签名！", textColor: BLACK_COLOR, labelFont: 12, screenInset: 0)
        
        return lbl!
    }()
    private lazy var grayView:UIView = {
        let view = UIView.init()
        view.backgroundColor = WHcolor
        return view
    }()
    func setUI()  {
        addSubview(backView)
        backView.addSubview(iconView)
        backView.addSubview(namelbl)
        backView.addSubview(sublbl)
        addSubview(grayView)
        for view in self.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        for view in backView.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        //backView
        addConstraint(NSLayoutConstraint.init(item:backView , attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item:backView , attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item:backView , attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant:0))
        addConstraint(NSLayoutConstraint.init(item:backView , attribute: .top, relatedBy: .equal, toItem: self, attribute:.top, multiplier: 1, constant: 0))
        //iconView
        backView.addConstraint(NSLayoutConstraint.init(item:iconView , attribute: .left, relatedBy: .equal, toItem: backView, attribute: .left, multiplier: 1, constant: 10))
         backView.addConstraint(NSLayoutConstraint.init(item:iconView , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        backView.addConstraint(NSLayoutConstraint.init(item:iconView , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        backView.addConstraint(NSLayoutConstraint.init(item:iconView , attribute: .top, relatedBy: .equal, toItem: backView, attribute:.top, multiplier: 1, constant: 10))
        //namelbl
        backView.addConstraint(NSLayoutConstraint.init(item:namelbl , attribute: .left, relatedBy: .equal, toItem: iconView, attribute: .right, multiplier: 1, constant: 10))
      
        backView.addConstraint(NSLayoutConstraint.init(item:namelbl , attribute: .top, relatedBy: .equal, toItem: iconView, attribute:.top, multiplier: 1, constant: 5))
        //sublbl
        backView.addConstraint(NSLayoutConstraint.init(item:sublbl , attribute: .left, relatedBy: .equal, toItem: namelbl, attribute: .left, multiplier: 1, constant: 0))
        
        backView.addConstraint(NSLayoutConstraint.init(item:sublbl , attribute: .top, relatedBy: .equal, toItem: namelbl, attribute:.bottom, multiplier: 1, constant: 5))
    }
}
