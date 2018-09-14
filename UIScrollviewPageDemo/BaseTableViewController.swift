//
//  BaseTableViewController.swift
//  UIScrollviewPageDemo
//
//  Created by 黄坤 on 2018/9/14.
//  Copyright © 2018年 jinchenshenghui. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {
    var mainScrollEnabled = false
    var subScrollEnabled = false
    var mainScrollView:UIScrollView?
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: UIScreen.main.bounds.height - 50 - 88))
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.isScrollEnabled = false;
        return tableView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.bottom;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BaseTableViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    
}
extension BaseTableViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if scrollView.contentOffset.y <= 0 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                tableView.isScrollEnabled = false
                mainScrollView?.isScrollEnabled = true
                mainScrollEnabled = true
                subScrollEnabled = false
            }
        }
    }
}
