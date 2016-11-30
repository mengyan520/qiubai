//
//  EmoticonView.swift
//  01-表情键盘
//
//  Created by male on 15/10/23.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 可重用 Cell Id
private let EmoticonViewCellId = "EmoticonViewCellId"

// MARK: 表情键盘视图
class EmoticonView: UIView {
    
    /// 选中表情回调
     var selectedEmoticonCallBack: (_ emoticon: Emoticon)->()
    
    // MARK: - 监听方法
    @objc private func clickItem(item: UIBarButtonItem) {
        print("选中分类 \(item.tag)")
        
        let indexPath = IndexPath.init(item: 0, section: item.tag)
        
        // 滚动 collectionView 
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    // MARK: - 构造函数
    init(selectedEmoticon: @escaping (_ emoticon: Emoticon)->()) {
        // 记录闭包属性
        selectedEmoticonCallBack = selectedEmoticon
        
        // 调用父类的构造函数
        var rect = UIScreen.main.bounds
        rect.size.height = 226
        
        super.init(frame: rect)
        
        backgroundColor = UIColor.white
        
        setupUI()
        
        // 滚动到第一页
        let indexPath = IndexPath.init(item: 0, section: 1)
        
//        dispatch_get_main_queue().asynchronously() { () -> Void in
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 懒加载控件
     lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.init(), collectionViewLayout: EmoticonLayout())
    lazy var toolbar = UIToolbar()
    
    /// 表情包数组
     lazy var packages = EmoticonManager.sharedManager.packages
    
    // MARK: - 表情布局(类中类－只允许被包含的类使用)
    private class EmoticonLayout: UICollectionViewFlowLayout {
        
        // collectionView 第一次布局的时候被自动调用
        // collectionView 的尺寸已经设置好 216 toolbar 36，如果在 iPhone 6+ 屏幕宽度是 414
        // 如果 toolbar 设置为 44，同样只能显示两行
       
         override func prepare() {
            super.prepare()
            
            let col: CGFloat = 7
            let row: CGFloat = 3
            
            let w = collectionView!.bounds.width / col
            // 如果在 iPhone 4 的屏幕，只能显示两行
            let margin = (collectionView!.bounds.height - row * w) * 0.499
            
            itemSize = CGSize(width: w, height: w)
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

// MARK: - 设置界面
// private 修饰的 extension 内部的所有函数都是私有的
private extension EmoticonView {
    
    /// 设置界面
    func setupUI() {
        // 1. 添加控件
        addSubview(toolbar)
        addSubview(collectionView)
        
        // 2. 自动布局
        toolbar.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(toolbar.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        // 3. 准备控件
        prepareToolbar()
        prepareCollectionView()
    }
    
    /// 准备工具栏
    private func prepareToolbar() {
        // 0. tintColor
        toolbar.tintColor = UIColor.white
        
        // 1. 设置按钮内容
        var items = [UIBarButtonItem]()
        
        // toolbar 中，通常是一组功能相近的操作，只是操作的类型不同，通常利用 tag 来区分
        var index = 0
        for p in packages {
            
            items.append(UIBarButtonItem(title: p.group_name_cn, style: .plain, target: self, action: Selector(("clickItem:"))))
            index += 1
            items.last?.tag = index
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        
        // 2. 设置 items
        toolbar.items = items
    }
    
    /// 准备 collectionView
    private func prepareCollectionView() {
        collectionView.backgroundColor = UIColor.white
        
        // 注册 cell
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
        
        // 设置数据源
        collectionView.dataSource = self
        // 设置代理
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension EmoticonView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 获取表情模型
        let em = packages[indexPath.section].emoticons[indexPath.item]
        
        // 执行`回调`
        selectedEmoticonCallBack(em)
        
        // 添加最近表情
        // 第0个分组不参加排序
        if indexPath.section > 0 {
            EmoticonManager.sharedManager.addFavorite(em: em)
        }
    }
    
    /// 返回分组数量 － 表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return packages.count
    }
    
    /// 返回每个表情包中的表情数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonViewCellId, for: indexPath as IndexPath) as! EmoticonViewCell
        
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        
        return cell
    }
}

// MARK: - 表情视图 Cell
private class EmoticonViewCell: UICollectionViewCell {
    
    /// 表情模型
    var emoticon: Emoticon? {
        didSet {
            emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), for: UIControlState.normal)
            emoticonButton.setTitle(emoticon?.emoji, for: UIControlState.normal)
            
            // 设置删除按钮
            if emoticon!.isRemoved {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal)
            }
            
            // 设置 emoji，千万不要加上判断，否则显示会不正常
            if emoticon?.emoji != nil {
            }
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoticonButton)
        
        emoticonButton.backgroundColor = UIColor.white
        emoticonButton.setTitleColor(UIColor.black, for: .normal)
        emoticonButton.frame = bounds.insetBy(dx: 4, dy: 4)
        
        // 字体的大小和高度相近
        emoticonButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        emoticonButton.isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    private lazy var emoticonButton: UIButton = UIButton()
}

