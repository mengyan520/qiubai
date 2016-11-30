//
//  String+Regex.swift
//  测试-04-正则
//
//  Created by male on 15/10/31.
//  Copyright © 2015年 itheima. All rights reserved.
//

import Foundation

extension String {
    
    /// 从当前字符串中，过滤链接和文字
    /// 元组，可以允许一个函数返回多个数值
    func href() -> (link: String, text: String)? {
        
        // 1. 创建正则表达式
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        // throws 针对 pattern 是否正确的异常处理
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // firstMatchInString 在 指定的字符串中，查找第一个和 pattern 符合字符串
        guard let result = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.characters.count)) else {
            print("没有匹配项目")
            return nil
        }
        
        let str = self as NSString
        
        let r1 = result.rangeAt(1)
        let link = str.substring(with: r1)
        
        let r2 = result.rangeAt(2)
        let text = str.substring(with: r2)
        
        return (link, text)
    }
    func SubStringColor(subString:String,color:UIColor,font:UIFont) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString.init(string: self)
          let range =  (self as NSString).range(of: subString)
        
        if range.location != NSNotFound {
            attributeString.setAttributes([NSForegroundColorAttributeName:color,NSFontAttributeName:font], range: range)
        
        }
        return attributeString
    }
}
