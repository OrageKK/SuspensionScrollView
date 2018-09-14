//
//  subLeftViewController.swift
//  UIScrollviewPageDemo
//
//  Created by 黄坤 on 2018/9/14.
//  Copyright © 2018年 jinchenshenghui. All rights reserved.
//

import UIKit

class LeftViewController: BaseTableViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LeftViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "你管我")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier:"你管我")
            cell?.textLabel?.text = "这是🦁列表第\(indexPath.row)行"
        }
        return cell!;
    }
    
}

