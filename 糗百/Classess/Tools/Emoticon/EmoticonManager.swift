//
//  EmoticonViewModel.swift
//  01-表情键盘
//
//  Created by male on 15/10/23.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

// MARK: - 表情包管理器 - emoticon.plist
/**
    1. emoticons.plist 定义表情包数组
        packages 字典数组中，每一个 id 对应不同表情包的目录
    2. 从 每一个表情包目录中，加载 info.plist 可以获得不同的表情内容
    id	目录名
    group_name_cn	表情分组名称- 显示在 toolbar 上
    emoticons	 数组
    字典
    chs		发送给服务器的字符串
    png		在本地显示的图片名称
    code	emoji 的字符串编码

*/
class EmoticonManager {

    /// 单例
    static let sharedManager = EmoticonManager()
    
    /// 表情包模型
    lazy var packages = [EmoticonPackage]()
    
    // MARK: - 最近表情
    /// 添加最近表情 -> 表情模型添加到 packages[0] 的表情数组
    /// 内存排序的处理方法！
    func addFavorite(em: Emoticon) {
        // 0. 表情次数 +1
        em.times += 1
        
        // 1. 判断表情是否被添加
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.insert(em, at: 0)
            
            // 删除倒数第二个按钮
            packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
        }
        
        // 2. 排序当前数组
//        packages[0].emoticons.sortInPlace { (em1, em2) -> Bool in
//            em1.times > em2.times
//        }
        packages[0].emoticons.sort { $0.times > $1.times }
    }
    
    // MARK: - 生成属性字符串
    /// 将字符串转换成属性字符串
    func emoticonText(string: String, font: UIFont) -> NSAttributedString {
        
        let strM = NSMutableAttributedString(string: string)
        
        // 1. 正则表达式 [] 是正则表达式关键字，需要转义
        let pattern = "\\[.*?\\]"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // 2. 匹配多项内容
        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count))
        // 3. 得到匹配的数量
        var count = results.count
        
        // 4. 倒着遍历查找到的范围
        while count > 0 {
           count -= 1
            let range = results[count].rangeAt(0)
            
            // 1> 从字符串中获取表情子串
            let emStr = (string as NSString).substring(with: range)
            
            // 2> 根据 emStr 查找对应的表情模型
            if let em = emoticonWithString(string: emStr) {
                
                // 3> 根据 em 建立一个图片属性文本
                let attrText = EmoticonAttachment(emoticon: em).imageText(font: font)
                
                // 4> 替换属性字符串中的内容
                strM.replaceCharacters(in: range, with: attrText)
            }
        }
        
        return strM
    }
    
    /// 根据表情字符串，在表情包中查找对应的表情
    ///
    /// - parameter string: 表情字符串
    ///
    /// - returns: 表情模型
    private func emoticonWithString(string: String) -> Emoticon? {
        
        // 1. 遍历表情包数组
        for package in packages {
            
            // 过滤 emoticons 数组，查找 em.chs == string 的表情模型
            // 1> 如果闭包有返回值，闭包代码只有一句，可以省略 return
            // 2> 如果有参数，参数可以使用 $0 $1...替代
            // 3> $0 对应的就是数组中的元素
            if let emoticon = package.emoticons.filter({ $0.chs == string }).last {
                
                return emoticon
            }
        }
        
        return nil
    }
    
    // MARK: - 构造函数
    private init() {
        loadPlist()
    }
    
    /// 从 emoticons.plist 加载表情包数据
    private func loadPlist() {
        // 0. 添加最近的分组
        packages.append(EmoticonPackage(dict: ["group_name_cn": "最近A" as AnyObject]))
        
        // 1. 加载 emoticon.plist － 如果文件不存在，path == nil
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
       
        // 2. 加载`字典`
        let dict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        
        // 3. 从字典中获得 id 的数组 - valueForKey 直接获取字典数组中的 key 对应的数组
        let array = (dict["packages"] as! NSArray).value(forKey: "id")
        
        // 4. 遍历 id 数组，准备加载 info.plist
        for id in array as! [String] {
            loadInfoPlist(id: id)
        }
        
        print(packages)
        
    }
    
    /// 加载每一个 id 目录下的 info.plist
    private func loadInfoPlist(id: String) {
        // 1. 建立路径
        let path = Bundle.main.path(forResource: "info.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
        
        // 2. 加载字典 - 一个独立的表情包
        let dict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        
        // 3. 字典转模型追加到 packages 数组
        packages.append(EmoticonPackage(dict: dict))
    }
}
