//
//  SQLiteManager.swift

//

//

import Foundation

/// 数据库名称 - 关于数据名称 readme.txt
private let dbName = "readme.db"

class SQLiteManager {
    
    /// 单例
    static let sharedManager = SQLiteManager()
    
    /// 全局数据库操作队列
    let queue: FMDatabaseQueue
    
    private init() {
        
        // 0. 数据库路径 - 全路径(可读可写)
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库路径 " + path)
        
        // 1. 打开数据库队列
        // 如果数据库不存在，会建立数据库，然后，再创建队列并且打开数据库
        // 如果数据库存在，会直接创建队列并且打开数据库
        queue = FMDatabaseQueue(path: path)
        
        // createTable()
    }
    
    /// 执行 SQL 返回字典数组
    ///
    /// - parameter sql: SQL
    ///
    /// - returns: 字典数组
    func execRecordSet(sql: String) -> [[String: AnyObject]] {
        
        // 定义结果[字典数组]
        var result = [[String: AnyObject]]()
        
        // `同步`执行数据库查询 - FMDB 默认情况下，都是在主线程上执行的
        SQLiteManager.sharedManager.queue.inDatabase { (db) -> Void in
            
            
            
            guard let rs = try? db?.executeQuery(sql: sql) else {
                print("没有结果")
                
                return
            }
            
            while rs!.next() {
                // 1. 列数
                let colCount = rs!.columnCount()
                
                // 创建字典
                var dict = [String: AnyObject]()
                
                // 2. 遍历每一列
                for col in 0..<colCount {
                    // 1> 列名
                    let name = rs!.columnName(for: col)
                    // 2> 值
                    let obj = rs!.object(forColumnIndex: col)
                    
                    // 3> 设置字典
                    dict[name!] = obj as AnyObject?
                }
                // 将字典插入数组
                result.append(dict)
            }
        }
        
        // 返回结果
        return result
    }
    
    func createTable(name:String) {
        
        // 1. 准备 SQL(只读，创建应用程序时，准备的素材)
        let sql =  "CREATE TABLE IF NOT EXISTS \(name) ('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,json text );"
        
        
        // 2. 执行 SQL
        queue.inDatabase { (db) -> Void in
            
            // 创建数据表的时候，最好选择 executeStatements，可以执行多个 SQL
            // 保证能够一次性创建所有的数据表！
            if (db?.executeStatements(sql))! {
                // print("创表成功")
            } else {
                // print("创表失败")
            }
        }
    }
    
    //    /// 目标：将网络返回的数据保存至本地数据库
    //    /// 参数：网络返回的字典数组
    //    /// 对现有函数不做大的改动，找到合适的`切入点`，尽快测试！
    //    /**
    //     数据库开发，难点：SQL 的编写
    //
    //     1> 确认并且测试 SQL
    //     2> 根据 SQL 的需求，确认参数
    //     3> 如果 SQL 比较复杂，提前测试 SQL 能够正常执行
    //     4> 调用 数据库方法 -> 如果是插入数据，应该使用事务！安全/快速
    //     5> 测试！
    //     */
    func saveCacheData(array: [[String: AnyObject]],name:String) {
        
        
        
        // 1. 准备 SQL
        /**
         1. 微博 id -> 通过字典获取
         2. 微博 json -> 字典序列化
         3. userId -> 登录的用户
         */
        let sql = "INSERT OR REPLACE INTO \(name) (id, json) VALUES (?,  ?)"
        
        // 2. 遍历数组 - 如果不能确认数据插入的消耗时间，可以在实际开发中，写测试代码
        SQLiteManager.sharedManager.queue.inTransaction { (db, rollback) -> Void in
            
            for dict in array {
                
                let statusId = dict["id"] as! Int
                
                // 2> 序列化字典 -> 二进制数据
                let json = try! JSONSerialization.data(withJSONObject: dict, options: [])
                
                do {
                    try db?.executeUpdate(sql: sql, statusId as AnyObject,json as AnyObject)
                } catch {
                    
                    print("插入数据失败")
                }
            }
        }
        print("数据插入完成！")
    }
    /// 目标：检查本地数据库中，是否存在需要的数据
    
    func checkChacheData(name:String) -> [[String: AnyObject]]? {
       
        let sql = "SELECT id, json FROM \(name) "
        
        // 2. 执行 SQL -> 返回结果集合
        let array = SQLiteManager.sharedManager.execRecordSet(sql: sql)
        
        var arrayM = [[String: AnyObject]]()
        for dict in array {
            
            let jsonData = dict["json"] as! Data
            let result = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // 添加到数组
            arrayM.append(result as! [String : AnyObject] )
        }
        
        
        
        // 返回结果 － 如果没有查询到数据，会返回一个空的数组
        return arrayM
    }
    
}
