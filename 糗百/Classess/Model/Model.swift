//
//  CommunityModel.swift
//  快看漫画
//
//  Created by Youcai on 16/7/22.
//  Copyright © 2016年 mm. All rights reserved.
//

import Foundation
class Model: NSObject {
    
   
    var count = 0
    var items:[HomeData]?
    var date:String?
    var article:Article?
    var has_more:Bool = false
    var banners:[Banners]?
    var lives:[Lives]?
    
    var data:[FriendsData]?
    var comments:[HomeData]?
    var total = 0
    var err = 0
    var hot_comments:[HomeData]?
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "items" {
            var arr = [HomeData]()
            for data in value as! [AnyObject] {
                arr.append(HomeData.init(dict: (data as? [String : AnyObject])!))
                
            }
            items = arr
            return
        }
        if key == "comments" {
            var arr = [HomeData]()
            for data in value as! [AnyObject] {
                arr.append(HomeData.init(dict: (data as? [String : AnyObject])!))
                
            }
            comments = arr
            return
        }
        if key == "hot_comments" {
            var arr = [HomeData]()
            for data in value as! [AnyObject] {
                arr.append(HomeData.init(dict: (data as? [String : AnyObject])!))
                
            }
            hot_comments = arr
            return
        }
        if key == "banners" {
            var arr = [Banners]()
            for data in value as! [AnyObject] {
                arr.append(Banners.init(dict: (data as? [String : AnyObject])!))
                
            }
            banners = arr
            return
        }
        if key == "lives" {
            var arr = [Lives]()
            for data in value as! [AnyObject] {
                arr.append(Lives.init(dict: (data as? [String : AnyObject])!))
                
            }
            lives = arr
            return
        }
        if key == "data" {
            var arr = [FriendsData]()
            for data in value as! [AnyObject] {
                arr.append(FriendsData.init(dict: (data as? [String : AnyObject])!))
                
            }
            data = arr
            return
        }
        if key == "article" {
            
            if let dict = value as? [String: AnyObject] {
                
                article = Article.init(dict: dict)
                
            }
            return
            
        }

       
        
        super.setValue(value, forKey: key)
    }
    

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
       
    }
    override var description: String {
        let keys = ["items"]
        
        return dictionaryWithValues(forKeys: keys).description
    }

}

// MARK: - 首页糗事
class HomeData:NSObject {
    
    var high_url:String?
    var format:String?
    var image:String?
    var published_at = 0
    var tag:String?
    var user:User?
    var image_size:SizeData?
    var pic_size:[AnyObject]?
    var pic_url:String?
    var id = 0
    var votes:Votes?
    var created_at = 0
    var content:String?
    var state:String?
    var comments_count = 0
    var low_url:String?
    var allow_comment:Bool = false
    var share_count = 0
    var loop = 0
    var parent_id = 0
    var like_count = 0
    var at_infos:NSDictionary?
    var floor = 0
    var liked:Bool = false
    var refer:Refer?
    var hot_comment:Hot_comment?
    var type:String?{
        didSet {
            if type == "fresh" {
                type = "新鲜"
            }else if type == "hot" {
                
                type = "热门"
            }else {
                type = ""
            }
        }
    }
    //可重用表示符号
    var cellId: String {
        var ID = "word"
      
        switch format! as NSString {
        case "word":
            ID = textID
            break
        case "image":
            ID = ImageID
            break
        case "video":
            ID = VideoID
            break
        default:
            break
        }
        return ID
        
    }

    lazy var rowHeight: CGFloat = {
        
        var cell:HomeTableViewCell
        
        if self.format == "image"  {
            cell = HomeImageTableViewCell.init(style: .default, reuseIdentifier: ImageID)
            
        }else if self.format == "word" {
           cell = HomeTableViewCell.init(style: .default, reuseIdentifier: textID)
        }else  {
        cell = HomeVideoTableViewCell.init(style: .default, reuseIdentifier: VideoID)
        }
        
        
        return cell.rowHeight(data: self)
        
    }()
    lazy var CommentrowHeight: CGFloat = {
        
        var cell:DetailTableViewCell
        
       
            cell = DetailTableViewCell.init(style: .default, reuseIdentifier: commetnID)
        
        
        
        return cell.CommentrowHeight(data: self)
        
    }()
    init(dict:[String:AnyObject]) {
        super.init()
        //if (dict != nil) {
            
            setValuesForKeys(dict)
      //  }
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            
            if let dict = value as? [String: AnyObject] {
                
                user = User.init(dict: dict)
                
            }
            return
            
        }
        if key == "votes" {
            
            if let dict = value as? [String: AnyObject] {
                
                votes = Votes.init(dict: dict)
                
            }
            return
            
        }
        if key == "hot_comment" {
            
            if let dict = value as? [String: AnyObject] {
                
                hot_comment = Hot_comment.init(dict: dict)
                
            }
            return
            
        }

        if key == "image_size" {
            
            if let dict = value as? [String: AnyObject] {
                
                image_size = SizeData.init(dict: dict)
                
            }
            return
            
        }
        if key == "refer" {
            
            if let dict = value as? [String: AnyObject] {
                
                refer = Refer.init(dict: dict)
                
            }
            return
            
        }

        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["content"]
        
        return dictionaryWithValues(forKeys: keys).description
    }

}
// MARK: - Hot_comment
class Hot_comment:NSObject {
    var user_id = 0
    var floor = 0
    var user:User?
    var ip = 0
    var created_at = 0
    var comment_id = 0
    //var score:String?
    var pos = 0
    var content:String?
    var source:String?
    var like_count = 0
    var parent_id = 0
    
    var anonymous = 0
    var neg = 0
    var article_id = 0
    
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            
            if let dict = value as? [String: AnyObject] {
                
                user = User.init(dict: dict)
                
            }
            return
            
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["content"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}

// MARK: - article
class Article:NSObject {
    var high_url:String?
    var format:String?
    var image:String?
    var published_at = 0
    var tag:String?
    var user:User?
    var image_size:SizeData?
    var pic_size:[AnyObject]?
    var pic_url:String?
    var id = 0
    var votes:Votes?
    var created_at = 0
    var content:String?
    var is_mine:Bool = false
    var anonymous = 0
    var comments_count = 0
    
    var allow_comment:Bool = false
    var share_count = 0
    var state:String?
    var type:String?{
        didSet {
            if type == "fresh" {
                type = "新鲜"
            }else if type == "hot" {
                
                type = "热门"
            }else {
                type = ""
            }
        }
    }

    //可重用表示符号
    var cellId: String {
        var ID = "word"
        switch format! as NSString {
        case "word":
            ID = textID
        case "image":
            ID = ImageID
        case "video":
            ID = VideoID
        default:
            break
        }
        return ID
        
    }
    
    lazy var ArticlerowHeight: CGFloat = {
        
        var cell:HomeTableViewCell
        
        if self.format == "image"  {
            cell = HomeImageTableViewCell.init(style: .default, reuseIdentifier: ImageID)
            
        }else if self.format == "word" {
            cell = HomeTableViewCell.init(style: .default, reuseIdentifier: textID)
        }else  {
            cell = HomeVideoTableViewCell.init(style: .default, reuseIdentifier: VideoID)
        }
        
        
        return cell.ArticlerowHeight(data: self)
        
    }()
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            
            if let dict = value as? [String: AnyObject] {
                
                user = User.init(dict: dict)
                
            }
            return
            
        }
        if key == "votes" {
            
            if let dict = value as? [String: AnyObject] {
                
                votes = Votes.init(dict: dict)
                
            }
            return
            
        }
        if key == "image_size" {
            
            if let dict = value as? [String: AnyObject] {
                
                image_size = SizeData.init(dict: dict)
                
            }
            return
            
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["content"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
// MARK: - Refer
class Refer:NSObject {
    
   
    var user:User?
   
    var id = 0
    
    var created_at = 0
    var content:String?
    
   
   
  
    var parent_id = 0
    var like_count = 0
    var at_infos:NSDictionary?
    var floor = 0
    
    
   
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            
            if let dict = value as? [String: AnyObject] {
                
                user = User.init(dict: dict)
                
            }
            return
            
        }
        
    super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["content"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
// MARK: - Votes
class Votes:NSObject {
    var down = 0
    var up = 0
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["up"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
    
}
// MARK: - 首页图片Size
class SizeData:NSObject {
    var s:[CGFloat]?
    var m:[CGFloat]?
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["m"]
        
        return dictionaryWithValues(forKeys: keys).description
    }

    
}
// MARK: - User
class User:NSObject {
    var gender:String?
    var age = 0
    
    var nick_status = 0
    var astrology:String?
    var avatar_updated_at = 0
    var uid = 0
    var last_visited_at = 0
    var created_at = 0
    var state:String?
    var last_device:String?
    var role:String?
    var login:String?
    var id = 0
    var icon:String?
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["login"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
// MARK: - 糗友圈
class FriendsData:NSObject {
    //隔壁
    var status = 0
    var created_at:TimeInterval = 0
    var distance:String?
    var is_me: Bool = false
    //at_users
    var content:String?
    var comment_count = 0
    var like_count = 0
    var avatar_urls:[Avatar_urls]?
    var pic_urls:[Pic_urls]?
    var topic:Topic?
    var topic_id = 0
    //vote
    var type = 0
    var id = 0
    var user:User?
    //视频
    var video:Video?
    //话题
    var rank = 0
    var is_anonymous:Bool = false
    var color = 0
    var is_punch = false
    var abstract:String?
    var article_count = 0
    var is_article_allowed = false
    var creator_id = 0
    var today_article_count = 0
    var master_id = 0
    //打卡
    var punches:[TimeInterval]?
    var is_top = false
    //可重用表示符号
    var cellId: String {
        var ID = "nearby"
        if (video != nil) {
            ID = "video"
        
        } else if (rank != 0){
            ID = "topic"
        }
        return ID
    }
    lazy var FrinedsrowHeight: CGFloat = {
        
        var cell:FriendsTableViewCell
        
        if (self.video != nil)  {
            cell = FriendsVideoCell.init(style: .default, reuseIdentifier: videoID)
            
        }else if  (self.rank != 0) {
           let  cell = FriendsTopicCell.init(style: .default, reuseIdentifier: topicID)
            return  cell.rowHeight(data: self)
        }else  {
            cell = FriendsTableViewCell.init(style: .default, reuseIdentifier: nearbyID)
        }
        
        
        return cell.rowHeight(data: self)
        
    }()
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "video" {
            
            if let dict = value as? [String: AnyObject] {
                
                video = Video.init(dict: dict)
                
            }
            return
            
        }
        if key == "user" {
            
            if let dict = value as? [String: AnyObject] {
                
                user = User.init(dict: dict)
                
            }
            return
            
        }
        if key == "topic" {
            
            if let dict = value as? [String: AnyObject] {
                
                topic = Topic.init(dict: dict)
                
            }
            return
            
        }
        if key == "pic_urls" {
            var arr = [Pic_urls]()
            for data in value as! [AnyObject] {
                arr.append(Pic_urls.init(dict: (data as? [String : AnyObject])!))
                
            }
            pic_urls = arr
            return
        }
        if key == "avatar_urls" {
            var arr = [Avatar_urls]()
            for data in value as! [AnyObject] {
                arr.append(Avatar_urls.init(dict: (data as? [String : AnyObject])!))
                
            }
            avatar_urls = arr
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["content"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}

class Video: NSObject {
    var height:CGFloat = 0
    var width:CGFloat = 0
    var high_url:String?
    var low_url:String?
    var duration = 0
    var pic_url:String?
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["pic_url"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
class Pic_urls: NSObject {
    var status = 0
    
    var pic_url:String?
    var format:String?
    
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["pic_url"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
class Topic: NSObject {
    var status = 0
    var has_top_article = false
    var rank = 0
    var users: NSArray?
    var today_article_count = 0
    var master:Master?
    var article_count = 0
    var is_anonymous:Bool = false
    var color = 0
    var is_punch:Bool = false
    
    var created_at = 0
    var abstract:String?
    var content:String?
    var is_article_allowed:Bool = false
    var creator_id = 0
    var avatar_urls:[Avatar_urls]?
    var pic_urls:[Pic_urls]?
    var master_id = 0
    var id = 0
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "pic_urls" {
            var arr = [Pic_urls]()
            for data in value as! [AnyObject] {
                arr.append(Pic_urls.init(dict: (data as? [String : AnyObject])!))
                
            }
            pic_urls = arr
            return
        }
        if key == "master" {
            
            if let dict = value as? [String: AnyObject] {
                
                master = Master.init(dict: dict)
                
            }
            return
            
        }
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["content"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
// MARK: - master
class Master:NSObject {
    var gender:String?
    var age = 0
    
    var nick_status = 0
    var astrology:String?
   
    
    var created_at = 0
    
    var login:String?
    var id = 0
    var icon:String?
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["login"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
class Avatar_urls: NSObject {
    var status = 0
    
    var pic_url:String?
    
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["pic_url"]
        
        return dictionaryWithValues(forKeys: keys).description
    }

}
// MARK: - 直播
//轮播
class Banners:NSObject {
    var ratio = 0
    
    var url:String?
    var redirect_url:String?
    var redirect_type:String?
    var redirect_source = 0
    var platform_id = 0
    var redirect_id = 0
   
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["url"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
class Lives:NSObject {
    var status = 0
    var author:Author?
    var is_follow:Bool = false
    var update_at = 0
    var created_at = 0
    var rtmp_live_url:String?
    var share:Share?
    var accumulated_count = 0
    var content:String?
    var stream_id = 0
    var thumbnail_url:String?
    var room_id = 0
    var hdl_live_url:String?
    var visitors_count = 0
    var id = 0
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "author" {
            
            if let dict = value as? [String: AnyObject] {
                
                author = Author.init(dict: dict)
                
            }
            return
            
        }
        if key == "share" {
            
            if let dict = value as? [String: AnyObject] {
                
                share = Share.init(dict: dict)
                
            }
            return
            
        }
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["content"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}

class Author:NSObject {
    var origin = 0
  
    var name:String?
    
    var gender:String?
    var intro:String?
    var is_follow:Bool = false
    var headurl:String?
    var nick_id = 0
    
    var id = 0
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["name"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
class Share:NSObject {
    
    var url:String?
    
    var caption:String?
    
    var web_info:String?
    
    var title:String?
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["url"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
