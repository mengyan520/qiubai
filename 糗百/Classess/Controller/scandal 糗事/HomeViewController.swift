//
//  HomeViewController.swift
//  内涵段子
//
//  Created by Youcai on 16/9/23.
//  Copyright © 2016年 mm. All rights reserved.
//https://m2.qiushibaike.com/mainpage/list?latitude=39.87274643723634&readarticles=%5B118005272%2C118021884%5D&count=30&type=refresh&longitude=116.4592265185696&page=1&AdID=1479798528698383571B68 专享



//https://m2.qiushibaike.com/119.29.47.97/mainpage/list?latitude=39.87274643723634&readarticles=%5B14632838%2C118028941%5D&count=30&type=refresh&longitude=116.4592265185696&page=1&AdID=1479799292067383571B68

//https://119.29.47.97/article/list/video?count=30&readarticles=%5B117973296%2C117972662%2C118005272%5D&page=1&AdID=1479798459310383571B68 视频
//https://m2.qiushibaike.com/article/list/text?count=30&readarticles=%5B118025754%2C117973296%2C117972662%5D&page=1&AdID=1479798436558883571B68  纯文
//https://119.29.47.97/article/list/imgrank?count=30&readarticles=%5B118023611%2C117967774%5D&page=1&AdID=1479799080423383571B68 图片
//https://119.29.47.97/article/list/day?count=30&readarticles=%5B117967774%2C118028253%2C118021457%2C118021664%2C118022033%5D&page=1&AdID=1479799148555483571B68 精华
//https://119.29.47.97/article/history?count=30&readarticles=%5B14632838%5D&page=1&AdID=1479799170331183571B68 穿越
import UIKit

class HomeViewController: BaseViewController {
   var currentTag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       setUI()
         NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.RefreshHome), name: NSNotification.Name(rawValue: "RefreshHome"), object: nil)
           }
    func setUI() {
        
        setTopView()
        view.addSubview(scrollView)
        let titles  = ["suggest","video","text","imgrank","day","history"]
        topView.titles = ["专享","视频","纯文","纯图","精华","穿越"]
        topView.del = self
        for i in 0..<6 {
          let vc = HomeTableViewController()
            vc.name = titles[i]
            vc.tag = i
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
        view.contentSize = CGSize.init(width: SCREEN_WIDTH * 6, height: 0)
        return view
    }()
    func RefreshHome() {
         let vc = self.childViewControllers[currentTag] as! HomeTableViewController
        vc.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
        vc.tableView.mj_header.beginRefreshing()
    }
}
// MARK: - 代理方法/自定义方法
extension HomeViewController:TopScrollViewDel,UIScrollViewDelegate {
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
        topViewOffset(sender: btn)
    }
    func topBtnClick(sender: UIButton) {
        let offsetX = CGFloat(sender.tag) * SCREEN_WIDTH
        
        scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        addChildView(index: CGFloat(sender.tag))
        topViewOffset(sender: sender)
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
    func topViewOffset(sender:UIButton) {
        var offset = sender.center.x - topView.scrollView.bounds.size.width*0.6
    let maxoffset = topView.scrollView.contentSize.width - 60 - topView.scrollView.bounds.size.width
        if offset < 0 {
        offset = 0
        }else if offset > maxoffset  {
          offset = maxoffset + 60
        }
        topView.scrollView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: true)
    }
}
