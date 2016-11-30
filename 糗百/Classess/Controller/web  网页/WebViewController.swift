//
//  WebViewController.swift
//  糗百
//
//  Created by Youcai on 16/10/14.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController,WKNavigationDelegate {
    var webView:WKWebView?
    var urlString:String?
    override func loadView() {
        super.loadView()
         webView = WKWebView.init(frame: UIScreen.main.bounds)
        webView?.backgroundColor = WHITE_COLOR
        webView?.navigationDelegate = self
        self.view = webView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // title = webView?.title
        let url = NSURL(string: urlString!)
        // 根据URL创建请求
        let requst = NSURLRequest(url: url! as URL)
        // WKWebView加载请求
        webView!.load(requst as URLRequest)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
  
    
    // MARK: - weview delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }

}
