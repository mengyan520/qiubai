//
//  NetworkTools.swift

//
//  Created by Youcai on 16/3/4.
//  Copyright © 2016年 mm. All rights reserved.


import Foundation
import AFNetworking
//import Alamofire

//MARK:-网络工具

enum MMRequestMethod:String {
case GET = "GET"
case POST = "POST"
}
class NetworkTools:AFHTTPSessionManager {
    //定义回调
    typealias MMRequestCallBack = (_ result:Any?,_ error:Error?)->()
    //单例
    static let shardTools :NetworkTools = {
    
        let tools = NetworkTools(baseURL:URL.init(string: "http://m2.qiushibaike.com/article/list/"))
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.operationQueue.maxConcurrentOperationCount = 5;
        tools.requestSerializer.timeoutInterval = 10
        tools.requestSerializer.httpShouldHandleCookies = true
        tools.requestSerializer.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        tools.requestSerializer.setValue("deflate", forHTTPHeaderField: "Accept-Encoding")
        tools.requestSerializer.setValue(tools.userAgent(), forHTTPHeaderField: "User-Agent")
        return tools
    }()
    
}

// MARK: - 封装 AFN 网络方法
extension NetworkTools {
   
    /// 网络请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter finished:   完成回调
    func requestF(method: MMRequestMethod, URLString: String, parameters: [String: AnyObject]?, finished: @escaping MMRequestCallBack) {
        // 定义成功回调
        let success = { (task: URLSessionDataTask, result: Any?) -> Void in
            finished(result , nil)
            
            
        }
        
        // 定义失败回调
        let failure = { (task: URLSessionDataTask?, error: Error?) -> Void in
            
            finished(nil, error )
        }
        
        if method == MMRequestMethod.GET {
            get(URLString, parameters: parameters,progress: nil,success: success, failure: failure)
        
        } else {
            post(URLString, parameters: parameters,progress: nil, success: success, failure: failure)
           
        }
       
    }
    func userAgent() -> String {
        
        return "QiuBai/10.5.9 (iPhone; iOS 10.1.1; zh_CN) PLHttpClient/1_WIFI"
    }
}
//// MARK: - 封装 Alamofire 网络方法
//extension NetworkTools {
//    
//    /// 网络请求
//    ///
//    /// - parameter method:     GET / POST
//    /// - parameter URLString:  URLString
//    /// - parameter parameters: 参数字典
//    /// - parameter finished:   完成回调
//     func requestL(method: Alamofire.Method, URLString: String, parameters: [String: AnyObject]?, finished: MMRequestCallBack) {
//        
//        // 显示网络指示菊花
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        
//        Alamofire.request(method, URLString, parameters: parameters).responseJSON { (response) -> Void in
//            
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            
//            // 判断是否失败
//            if response.result.isFailure {
//                // 在开发网络应用的时候，错误不要提示给用户，但是错误一定要输出！
//               finished(result: nil, error: response.result.error)
//            }
//            // 完成回调
//            finished(result: response.result.value, error: response.result.error)
//        }
//    }
//    
//   }
