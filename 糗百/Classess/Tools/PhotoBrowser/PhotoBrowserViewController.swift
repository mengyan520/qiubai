//
//  PhotoBrowserViewController.swift
//  Weibo10
//
//  Created by male on 15/10/26.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 可重用 Cell 标示符号
private let PhotoBrowserViewCellId = "PhotoBrowserViewCellId"

/// 照片浏览器
class PhotoBrowserViewController: UIViewController {

    /// 照片 URL 数组
     var urls: [NSURL]
    /// 当前选中的照片索引
    private var currentIndexPath: NSIndexPath
    var isColl:Bool = false
    // MARK: - 监听方法
     func close() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 保存照片
     func save() {
        // 1. 拿到图片
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        // imageView 中很可能会因为网络问题没有图片 -> 下载需要提示
        guard let image = cell.imageView.image else {
            return
        }
        
        // 2. 保存图片
       
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // Adds a photo to the saved photos album.  The optional completionSelector should have the form:
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
     func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        
        let message = (error == nil) ? "保存成功" : "保存失败"
        
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    // MARK: - 构造函数 属性都可以是必选，不用在后续考虑解包的问题
    init(urls: [NSURL], indexPath: NSIndexPath,isColl:Bool) {
        self.urls = urls
        self.currentIndexPath = indexPath
        self.isColl = isColl
        // 调用父类方法
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 和 xib & sb 等价的，主要职责创建视图层次结构，loadView 函数执行完毕，view 上的元素要全部创建完成
    // 如果 view == nil，系统会在调用 view 的 getter 方法时，自动调用 loadView，创建 view
    override func loadView() {
        // 1. 设置根视图
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        
        view = UIView(frame: rect)
        
        // 2. 设置界面
        setupUI()
    }
    
    // 是视图加载完成被调用，loadView 执行完毕被执行
    // 主要做数据加载，或者其他处理
    // 但是：目前市场上很多程序，没有实现 loadView，所有建立子控件的代码都在 viewDidLoad 中
    override func viewDidLoad() {
        super.viewDidLoad()

        // 让 collectionView 滚动到指定位置
        if isColl {
            collectionView.scrollToItem(at: currentIndexPath as IndexPath, at: .centeredHorizontally, animated: false)
            urls.count > 1 ? (rowLabel.text = "\(currentIndexPath.row + 1) / \(urls.count)") : (rowLabel.isHidden = true)
        } 
       
    }

    // MARK: - 懒加载控件
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoBrowserViewLayout())
    /// 关闭按钮
     lazy var closeButton: UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
    /// 保存按钮
     lazy var saveButton: UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
    /// 保存按钮
    lazy var rowLabel: UILabel = {
      let lbl = UILabel.init(title: "", fontSize: 14, color: WHITE_COLOR, screenInset: 0)
        return lbl
    }()
    // MARK: - 自定义流水布局
    private class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
        
         override func prepare() {
            super.prepare()
            
            itemSize = collectionView!.bounds.size
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

// MARK: - 设置 UI
 extension PhotoBrowserViewController {
    
     func setupUI() {
        // 1. 添加控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
         view.addSubview(rowLabel)
        // 2. 设置布局
        collectionView.frame = view.bounds
        
        closeButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.left.equalTo(view.snp.left).offset(8)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        saveButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.right.equalTo(view.snp.right).offset(-28)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        rowLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(saveButton.snp.centerY)        }
        // 3. 监听方法
        closeButton.addTarget(self, action: #selector(PhotoBrowserViewController.close), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(PhotoBrowserViewController.save), for: .touchUpInside)
        
        // 4. 准备控件
        prepareCollectionView()
    }
    
    /// 准备 collectionView
    private func prepareCollectionView() {
        // 1. 注册可重用 cell
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserViewCellId)
        
        // 2. 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self

    }
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserViewCellId, for: indexPath) as! PhotoBrowserCell
        
        cell.imageURL = urls[indexPath.item]
        // 设置代理
        cell.photoDelegate = self
        
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX:Int = Int(scrollView.contentOffset.x) / Int(SCREEN_WIDTH)
        rowLabel.text = "\(offsetX + 1) / \(urls.count)"
    }
    
}

// MARK: - PhotoBrowserCellDelegate
extension PhotoBrowserViewController: PhotoBrowserCellDelegate {
    
    func photoBrowserCellShouldDismiss() {
        close()
        
         //dismiss(animated: false, completion: nil)
    }
    
    func photoBrowserCellDidZoom(scale: CGFloat) {
        
       // let isHidden = (scale < 1)
       // hideControls(isHidden: isHidden)
        
//        if isHidden {
//            // 1. 根据 scale 修改根视图的透明度 & 缩放比例
//            view.alpha = scale
//            view.transform = CGAffineTransform(scaleX: scale, y: scale)
//        } else {
//            view.alpha = 1.0
//            view.transform = .identity
//        }
    }
    
    /// 隐藏或者显示控件
    private func hideControls(isHidden: Bool) {
        closeButton.isHidden = isHidden
        saveButton.isHidden = isHidden
        
        collectionView.backgroundColor = isHidden ? UIColor.clear : UIColor.black
    }
}

// MARK: - 解除转场动画协议
extension PhotoBrowserViewController: PhotoBrowserDismissDelegate {
    
    func imageViewForDismiss() -> UIImageView {
        let iv = UIImageView()
        
        // 设置填充模式
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        // 设置图像 - 直接从当前显示的 cell 中获取
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        iv.image = cell.imageView.image
        
        // 设置位置 - 坐标转换(由父视图进行转换)
       
        
       iv.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
        
        return iv
    }
    
    func indexPathForDismiss() -> IndexPath {
       
        return collectionView.indexPathsForVisibleItems[0]     }
}

