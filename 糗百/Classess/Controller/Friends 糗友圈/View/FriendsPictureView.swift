//
//  FriendsPictureView.swift
//  糗百
//
//  Created by Youcai on 16/11/9.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
import SDWebImage
class FriendsPictureView: UICollectionView {
    var isFrineds:Bool = false
    /// 微博视图模型
    var imgData: [Pic_urls]? {
        didSet {
           
            sizeToFit()
            // 刷新数据 － 如果不刷新，后续的 collectionView 一旦被复用，不再调用数据源方法
            reloadData()
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
     // MARK: -  init
    init() {
        let layout = UICollectionViewFlowLayout()
        // 设置间距 － 默认 itemSize 50 * 50
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        super.init(frame: CGRect.init(), collectionViewLayout: layout)
        backgroundColor = WHITE_COLOR
       
        
        // 设置数据源 - 自己当自己的数据源
        dataSource = self
        // 设置代理
        delegate = self
        
        // 注册可重用 cell
        register(PictureViewCell.self, forCellWithReuseIdentifier: "dd")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 计算视图大小
    private func calcViewSize() -> CGSize {
        
        // 1. 准备
        // 每行的照片数量
        let rowCount: CGFloat = 3
        // 最大宽度
        let maxWidth = UIScreen.main.bounds.width - 2 * 10 - 50
        let itemWidth = (maxWidth - 2 * 10) / rowCount
        
        // 2. 设置 layout 的 itemSize
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        // 3. 获取图片数量
        let count = (imgData?.count)! > 3 ? 3 : (imgData?.count)!
        
        // 计算开始
        // 1> 没有图片
        if count == 0 {
            return CGSize.init()
        }
        

        let row = CGFloat((count - 1) / Int(3) + 1)
        let h = row * itemWidth + (row - 1) * 10 + 1
        let w = 3 * itemWidth + (3 - 1) * 10 + 1
        
        return CGSize(width: w, height: h)
}
}
 // MARK: - 数据源/代理
extension FriendsPictureView:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData != nil ? ((imgData?.count)! > 3 ? 3 : (imgData?.count)!) : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dd", for: indexPath) as! PictureViewCell
      
        cell.imageURL = URL.init(string: (imgData?[indexPath.item].pic_url)!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var urls = [NSURL]()
        for Pic_urls in imgData! {
            urls.append(NSURL.init(string: Pic_urls.pic_url!)!)
        }
        let userInfo:NSDictionary = ["key": indexPath,
                       "url": urls ]

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: !isFrineds ? "pic" : "topic"), object: self, userInfo: userInfo as? [AnyHashable : Any])

    }
}
// MARK: - 照片查看器的展现协议
extension FriendsPictureView: PhotoBrowserPresentDelegate {
    
    /// 创建一个 imageView 在参与动画
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView {
        
        let iv = UIImageView()
        
        // 1. 设置内容填充模式
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        // 2. 设置图像（缩略图的缓存）- SDWebImage 如果已经存在本地缓存，不会发起网络请求
        if let url =  URL.init(string: (imgData?[indexPath.item].pic_url)!){
            iv.sd_setImage(with: url)
        }
        
        return iv
    }
    
    /// 动画起始位置
    func photoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect {
       
        // 1. 根据 indexPath 获得当前用户选择的 cell
        let cell = self.cellForItem(at: indexPath)!
        
        // 2. 通过 cell 知道 cell 对应在屏幕上的准确位置
        // 在不同视图之间的 `坐标系的转换` self. 是 cell 都父视图
        // 由 collectionView 将 cell 的 frame 位置转换的 keyWindow 对应的 frame 位置
        
        let rect = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
               
        return rect
    }
    
    /// 目标位置
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect {
        
        // 根据缩略图的大小，等比例计算目标位置
        guard let key =  imgData?[indexPath.item].pic_url
            else {
            return .zero
        }

        // 从 sdwebImage 获取本地缓存图片
        guard let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key) else {
            return .zero
        }
        
        // 根据图像大小，计算全屏的大小
        let w = UIScreen.main.bounds.width
        let h = image.size.height * w / image.size.width
        
        // 对高度进行额外处理
        let screenHeight = UIScreen.main.bounds.height
        var y: CGFloat = 0
        if h < screenHeight {       // 图片短，垂直居中显示
            y = (screenHeight - h) * 0.5
        }
        
        let rect = CGRect(x: 0, y: y, width: w, height: h)
        
        return rect
    }
}
// MARK: - 配图 cell

class PictureViewCell: UICollectionViewCell {
    var imageURL: URL? {
        didSet {
          
            iconView.sd_setImage(with: imageURL, placeholderImage: UIImage.init().ImageWithColor(color:WHITE_COLOR), options: [.retryFailed,.refreshCached])
            
        }
    }

    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 懒加载控件
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        
        // 设置填充模式
        iv.contentMode = UIViewContentMode.scaleAspectFill
        // 需要裁切图片
        iv.clipsToBounds = true
        iv.backgroundColor = WHITE_COLOR
        return iv
    }()
   
}
