//
//  FriednsViewController.swift
//  糗百
//
//  Created by Youcai on 16/10/20.
//  Copyright © 2016年 mm. All rights reserved.
// 隔壁： http://circle.qiushibaike.com/article/nearby/list?latitude=39.87291324420127&longitude=116.4591759582881&page=1&AdID=1478591258129283571B68


//已粉：http://circle.qiushibaike.com/article/follow/list?latitude=39.8729351673003&longitude=116.4591167321213&page=1&AdID=1478591318596983571B68
//视频: http://circle.qiushibaike.com/article/video/list?latitude=39.8729351673003&longitude=116.4591167321213&page=1&AdID=1478591331681283571B68
//话题: http://circle.qiushibaike.com/article/topic/top?count=20&page=1&AdID=1478591343628383571B68
//话题详情 https://circle.qiushibaike.com/article/topic/3205/all?topic_id=3205&latitude=39.87311577636352&longitude=116.4591024761955&page=1&AdID=1479698933714483571B68

//https://circle.qiushibaike.com/article/8785991/like?article_id=8785991
import UIKit

class FriendsViewController: BaseViewController {
var currentTag = 0
    override func viewDidLoad() {
        super.viewDidLoad()

       setUI()
         NotificationCenter.default.addObserver(self, selector: #selector(FriendsViewController.RefreshFrineds), name: NSNotification.Name(rawValue: "RefreshFrineds"), object: nil)
       
    }
    func setUI() {
        
        setTopView()
         view.addSubview(scrollView)
        let titles  = ["nearby","follow","video","topic"]
        topView.titles = ["隔壁","已粉","视频","话题"]
        topView.del = self
        for i in 0..<4 {
            
            let vc = FriendsTableViewController()
            vc.name = titles[i]
            self.addChildViewController(vc)
            if i == 0 {
                vc.view.frame = scrollView.bounds
                
                scrollView.addSubview(vc.view)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MMPlayerView.shardTools.resetPlayer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 懒加载
    lazy var scrollView:UIScrollView =  {
        let view = UIScrollView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64-49))
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true;
        view.bounces = false
        view.delegate = self
        view.contentSize = CGSize.init(width: SCREEN_WIDTH * 4, height: 0)
        return view
    }()
    func RefreshFrineds() {
        let vc = self.childViewControllers[currentTag] as! FriendsTableViewController
         vc.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
        vc.tableView.mj_header.beginRefreshing()
    
    }
}
    // MARK: - 代理方法/自定义方法
extension FriendsViewController:TopScrollViewDel,UIScrollViewDelegate {
        //代理
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if scrollView == self.scrollView {
                scrollViewDidEndScrollingAnimation(scrollView)
            }
            
        }
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            let index = scrollView.contentOffset.x / scrollView.bounds.size.width
            let btn = (self.topView.scrollView.subviews[NSInteger(index)] as! UIButton)
            self.topView.isScroll = false
            self.topView.BtnClick(sender: btn)
            self.topView.isScroll = true
            addChildView(index: index)
            //topViewOffset(sender: btn)
        }
        func topBtnClick(sender: UIButton) {
            let offsetX = CGFloat(sender.tag) * SCREEN_WIDTH
            
            scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
            
                
                addChildView(index: CGFloat(sender.tag))
            
           
        }
        //自定义方法
        func addChildView(index:CGFloat)  {
             MMPlayerView.shardTools.resetPlayer()
            let vc = self.childViewControllers[NSInteger(index)]
             currentTag = Int(index)
            if (vc.view.superview != nil) {
                return
            }
            let vcW = scrollView.frame.size.width
            let vcH = scrollView.frame.size.height
            let vcY:CGFloat = 0
            let vcX = index * vcW
            vc.view.frame = CGRect.init(x: vcX, y: vcY, width: vcW, height: vcH)
            scrollView.addSubview(vc.view)
        }
}
