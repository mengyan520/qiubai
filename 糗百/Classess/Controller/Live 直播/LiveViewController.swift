//
//  LiveViewController.swift
//  糗百
//
//  Created by Youcai on 16/10/13.
//  Copyright © 2016年 mm. All rights reserved.
//http://live.qiushibaike.com/live/all/list?count=30&page=1&AdID=1476347531884083571B68

import UIKit

class LiveViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = RGB(r: 242, g: 242, b: 242, a: 1.0)
        setUI()
    }
    func setUI() {
        
        setTopView()
        
        view.addSubview(scrollView)
        // let titles  = ["nearby","nearby","nearby","nearby"]
        topView.titles = ["全部","已粉"]
        topView.del = self
        for i in 0..<2 {
            
            let vc = LiveCollectionViewController()
            // vc.name = titles[i]
            self.addChildViewController(vc)
            if i == 0 {
                vc.view.frame = scrollView.bounds
                
                scrollView.addSubview(vc.view)
            }
        }
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
        view.contentSize = CGSize.init(width: SCREEN_WIDTH * 2, height: 0)
        return view
    }()


}
// MARK: - 代理方法/自定义方法
extension LiveViewController:TopScrollViewDel,UIScrollViewDelegate {
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
       // topViewOffset(sender: sender)
    }
    //自定义方法
    func addChildView(index:CGFloat)  {
        let vc = self.childViewControllers[NSInteger(index)]
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
//    func topViewOffset(sender:UIButton) {
//        var offset = sender.center.x - topView.scrollView.bounds.size.width*0.6
//        let maxoffset = topView.scrollView.contentSize.width - 60 - topView.scrollView.bounds.size.width
//        if offset < 0 {
//            offset = 0
//        }else if offset > maxoffset  {
//            offset = maxoffset + 60
//        }
//        topView.scrollView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: true)
//    }
}
