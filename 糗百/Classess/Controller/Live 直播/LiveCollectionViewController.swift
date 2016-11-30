//
//  LiveCollectionViewController.swift
//  糗百
//
//  Created by Youcai on 16/10/13.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
import MJRefresh
private let reuseIdentifier = "Cell"

class LiveCollectionViewController: UICollectionViewController,CarouselDelegate,CarouselDataSource {
    var name:String = "text"
    var page = 1
    private var dataArray = [Lives]()
     private var banners = [Banners]()
    init() {
        let layout = UICollectionViewFlowLayout.init()
        super.init(collectionViewLayout: layout)
        collectionView?.addSubview(bannerView)
        loadData()
        let refreshheader = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(LiveCollectionViewController.loadData))
        collectionView?.mj_header = refreshheader
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction:  #selector(LiveCollectionViewController.loadMoreData))
        collectionView?.mj_footer = footer
        collectionView?.mj_footer.isHidden = true
        collectionView?.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH*300/1080, 0, 0, 0)
        refreshheader?.ignoredScrollViewContentInsetTop = SCREEN_WIDTH*300/1080
        collectionView?.backgroundColor = WHITE_COLOR
       
        layout.itemSize = CGSize.init(width: (SCREEN_WIDTH-30)/2.0, height: ITEMHEIGHT*((SCREEN_WIDTH-30)/2.0)/ITEMWIDTH)
        //collectionView?.showsHorizontalScrollIndicator = false
       layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
       // layout.minimumLineSpacing = 5
      //  layout.minimumLineSpacing = 5
        //layout.minimumInteritemSpacing = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.collectionView!.register(LiveCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LiveCollectionViewCell
    
        cell.data = dataArray[indexPath.row]
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = LivePlayViewController()
      controller.url = dataArray[indexPath.row].hdl_live_url
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
     
     
    */
   
 
    //轮播
    func numberOfPages(carouselView: CarouselView) -> NSInteger {
        
        return banners.count
    }
    func carouselView(carouselView: CarouselView, index: NSInteger) -> UIView {
        
        let imageView = UIImageView(frame:bannerView.bounds)
        imageView.sd_setImage(with: URL.init(string: banners[index].url!), placeholderImage: nil)
        return imageView
    }
    func didSelectedcarouselView(carouselView: CarouselView, index: NSInteger) {
        if banners[index].redirect_type == "web" {
            let controller = WebViewController()
            controller.urlString = banners[index].redirect_url
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    // MARK: - 网络方法
    func loadData() {
        let  url = "http://live.qiushibaike.com/live/all/list?count=30&page=1&AdID=1476347531884083571B68"
//        if name == "history" {
//            url = "http://m2.qiushibaike.com/article/history?history?count=30&readarticles=%5B3965915%2C41931570%5D&page=1&AdID=1476340810383983571B68"
//        }
        NetworkTools.shardTools.requestF(method: .GET, URLString:url, parameters: nil) { (result, error) in
            self.collectionView?.mj_header.endRefreshing()
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                let model = Model.init(dict: object)
               // if self.name != "history" {
                    
                    
//                    if self.dataArray.count > 0{
//                        
//                        if (model.items?.last?.published_at)! <= (self.dataArray.first?.published_at)! {
//                            return
//                        }
//                    }
           //     }
                self.dataArray = model.lives!
                self.banners = model.banners!
                
                self.bannerView.stopAutoRun()
                self.bannerView.reloadDate()
                self.bannerView.startAutoRun()
                if self.dataArray.count > 0 {
                    self.collectionView?.mj_footer.isHidden = false
                }
                self.collectionView?.reloadData()
                
            }
            
            
        }
    }
    
    func loadMoreData() {
        page = page+1
        let  url = "http://live.qiushibaike.com/live/all/list?count=30&page=\(page)&AdID=1476347531884083571B68"
        NetworkTools.shardTools.requestF(method: .GET, URLString: url, parameters: nil) { (result, error) in
            self.collectionView?.mj_footer.endRefreshing()
            
            if error == nil {
                guard let object = result as? [String: AnyObject] else {
                    print("格式错误")
                    return
                }
                let model = Model.init(dict: object)
                self.dataArray = self.dataArray + model.lives!
                
                self.collectionView?.reloadData()
                if (model.lives?.count)! < 30 {
                  self.collectionView?.mj_footer.isHidden = true
                }
            }
            
            
        }
        
    }
 // MARK: - 轮播视图
    private lazy var bannerView:CarouselView = {
      let view = CarouselView.init(frame: CGRect.init(x: 0, y: -SCREEN_WIDTH*300/1080, width: SCREEN_WIDTH, height: SCREEN_WIDTH*300/1080))
        
        view.dataSource = self
        view.delegate = self
        view.timeInterval = 4
        return view
    }()
}
