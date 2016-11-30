//
//  BottomCommentView.swift
//  糗百
//
//  Created by Youcai on 16/9/30.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
protocol BottomCommentViewDel {
    func bottomClick(view:BottomCommentView)
    
    
}
class BottomCommentView: UIView {
     // MARK: - 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = WHITE_COLOR
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     // MARK: - 设置界面
    func setUI()  {
        addSubview(emoticonBtn)
        addSubview(textView)
        addSubview(commentBtn)
        emoticonBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(45)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(45)
        }
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.left.equalTo(emoticonBtn.snp.right)
            make.right.equalTo(commentBtn.snp.left)
        }
    }
    // MARK: - 点击事件
     func BtnClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
      textView.resignFirstResponder()
        if sender.tag == 0 {
        textView.inputView = textView.inputView == nil ? emoticonView: nil
        textView.becomeFirstResponder()
        }
    }
    // MARK: - 懒加载
    //im_img_for_emoticon_icon
    var del:BottomCommentViewDel?
    private lazy var emoticonBtn:UIButton = {
        let btn = UIButton.init(imageName: "im_img_for_emoticon_icon", backImageName: nil, SelectedImageName: "im_img_for_text_icon", target: self, actionName: #selector(self.BtnClick(sender:)))
        btn.tag = 0
    return btn
    }()
     lazy var textView:UITextView = {
        
        let view = UITextView.init()
        view.backgroundColor = RGB(r: 241, g: 241, b: 246, a: 1.0)
        view.layer.borderColor = WHITE_COLOR.cgColor
        
        view.layer.borderWidth = 1
        
        view.layer.cornerRadius = 5
        return view
    }()
    private lazy var commentBtn:UIButton = {
        
        let btn = UIButton.init(title: "评论", color:mainColor,fontSize:14,target: self, actionName: #selector(self.BtnClick(sender:)))
         btn.tag = 1
        return btn
    }()
    /// 表情键盘视图
    private lazy var emoticonView: EmoticonView = EmoticonView { [weak self] (emoticon) -> () in
        
        self?.textView.insertEmoticon(em: emoticon)
    }
}
