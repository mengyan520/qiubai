//
//  BaseTableViewController.swift
//  起点阅读
//
//  Created by Youcai on 16/9/22.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = WHITE_COLOR
        automaticallyAdjustsScrollViewInsets = false
//        let image = UIImage.init().ImageWithColor(color:RED_COLOR)
//        
//        
//        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage.init()
        tableView.separatorStyle = .none
        
        
        }
     func setNavTitle(titleString:String) {
        self.title = titleString;
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:WHITE_COLOR]
    }
    func setNavButton(right:String?,leftTile:String?,left:String?,target: Any?, action: Selector?) {
        if (left != nil)  {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: left!), style: .plain, target: nil, action: nil)
        }else
        if (leftTile != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: leftTile,style: .plain, target: target, action: action)
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:WHITE_COLOR], for: .normal)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: right!), style: .plain, target: target, action: action)
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 懒加载
    private lazy var topView:TopScrollView = {
        let view = TopScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
    
        return view
    }()
}
