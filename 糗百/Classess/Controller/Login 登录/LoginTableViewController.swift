//
//  LoginTableViewController.swift
//  糗百
//
//  Created by Youcai on 16/11/17.
//  Copyright © 2016年 mm. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {
    private var  titles = [[String]]()
    private var  imgs = [String]()
    private var  colors = [[UIColor]]()
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登录/注册"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action:#selector(LoginTableViewController.clickLeftBarButton))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:Font(fontSize: 14),NSForegroundColorAttributeName:mainColor], for: .normal)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        titles = [["使用微信账号","使用QQ账号","使用微博账号"],["邮箱/糗百昵称","密码"]]
        imgs = ["icon_bind_weixin","icon_bind_qq","icon_bind_sina"]
        colors = [[RGB(r: 59, g: 166, b: 107, a: 1.0),RGB(r: 38, g: 161, b: 237, a: 1.0),RGB(r: 240, g: 81, b: 75, a: 1.0)],[RGB(r: 100, g: 100, b: 100, a: 1.0),RGB(r: 100, g: 100, b: 100, a: 1.0)]]
        tableView.sectionFooterHeight = 0.1
        //设置头部视图从 第二组开始执行
        //tableView.sectionHeaderHeight = 30
        tableView.separatorInset = .zero
        
        tableView.tableFooterView = footView
        footView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(footView.snp.centerX)
            make.height.equalTo(33)
            make.top.equalTo(footView.snp.top).offset(10)
            make.width.equalTo(SCREEN_WIDTH-80)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        indexPath.section == 0 ? (cell.imageView?.image = UIImage.init(named: imgs[indexPath.row])) : (cell.imageView?.image = nil)
        
        cell.textLabel?.textColor = colors[indexPath.section][indexPath.row]
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.contentView.addSubview(accountTextField)
                accountTextField.snp.makeConstraints({ (make) in
                    make.edges.equalTo(cell.contentView.snp.edges)
                    
                })
                accountTextField.placeholder = titles[indexPath.section][indexPath.row]
            }else {
                cell.contentView.addSubview(codeTextField)
                codeTextField.snp.makeConstraints({ (make) in
                    make.edges.equalTo(cell.contentView.snp.edges)
                    
                })
                codeTextField.placeholder = titles[indexPath.section][indexPath.row]
            }
        }else {
            cell.textLabel?.text = titles[indexPath.section][indexPath.row]
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let lbl = UILabel.init(title: section == 0 ? "  使用合作账号一键登录 / 注册" : "  使用糗百账号登录", fontSize: 12, color: RGB(r: 99, g: 99, b: 99, a: 1.0), screenInset: 10)
        return lbl
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.separatorInset = .zero
    //    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.endEditing(false)
    }
    // MARK: - action
    func clickLeftBarButton() {
        self.dismiss(animated: true, completion: nil)
        
    }
    func loginBtnClick(sender:UIButton)  {
        
        if  codeTextField.text?.ew_removeSpacesAndLineBreaks() == "" &&  accountTextField.text?.ew_removeSpacesAndLineBreaks() == "" {
            let animation = CAKeyframeAnimation.shakeAnimation(codeTextField.layer.frame)
            codeTextField.layer.add(animation!, forKey: kCATransition)
            accountTextField.layer.add(animation!, forKey: kCATransition)
        }else {
          let alert = UIAlertController.init(title: "登录失败", message: "昵称或密码不正确", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
         present(alert, animated: true, completion: nil)
        }
    
    
        
        
    }
    
    // MARK: - footView
    private lazy var footView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        view.backgroundColor = RGB(r: 235, g: 235, b: 241, a: 1.0)
        return view
    }()
    private lazy var loginBtn:UIButton = {
        let btn = UIButton.init(title: "登 录", color: WHITE_COLOR, fontSize: 15, target: self, actionName: #selector(self.loginBtnClick(sender:)))
        btn.backgroundColor = mainColor
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = true
        return btn
    }()
    //输入框
    private lazy var accountTextField:UITextField = {
        let view = UITextField.init()
        view.font = Font(fontSize: 15)
        view.keyboardType = .default
        view.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 44))
        view.leftViewMode = .always
        view.leftView?.isUserInteractionEnabled = false
        
        
        return view
    }()
    private lazy var codeTextField:UITextField = {
        let view = UITextField.init()
        view.font = Font(fontSize: 15)
        view.keyboardType = .default
        view.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 44))
        view.leftViewMode = .always
        view.leftView?.isUserInteractionEnabled = false
        view.isSecureTextEntry = true
        return view
    }()
}
