//
//  BaseViewController.swift
//  仿漫漫
//
//  Created by Youcai on 16/5/18.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WHITE_COLOR
        automaticallyAdjustsScrollViewInsets = false
//        let image = UIImage.init().ImageWithColor(color:RED_COLOR)
//        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage.init()
       
    }
    func setTopView()  {
      view.addSubview(topView)
    }
    override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
 }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 懒加载
     lazy var topView:TopScrollView = {
        let view = TopScrollView.init(frame: CGRect.init(x: 0, y: 20, width: SCREEN_WIDTH, height: 44))
        
        return view
    }()
    
    
}
