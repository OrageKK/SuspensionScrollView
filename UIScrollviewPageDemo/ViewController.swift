//
//  ViewController.swift
//  UIScrollviewPageDemo
//
//  Created by 黄坤 on 2018/9/14.
//  Copyright © 2018年 jinchenshenghui. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var mainScrollEnabled = false
    var subScrollEnabled = false
    let maxOffsetY: CGFloat = 150
    var currentPanY: CGFloat = 0
    
    var buttonArr = [UIButton]()
    let controllerArr:[UIViewController] = [LeftViewController(),RightViewController()]
    
    var currentVC:BaseTableViewController?
    
    // MARK:Lazy
    lazy var mainScrollView:UIScrollView = {
        let mainScrollView = UIScrollView.init(frame: view.bounds);
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(recognizer:)))
        pan.delegate = self
        mainScrollView.addGestureRecognizer(pan)
        mainScrollView.contentSize = CGSize(width: view.bounds.width, height: maxOffsetY + 50 + 44*22) // 如采用自动布局SnapKit等，可不写死
        mainScrollView.delegate = self;
        return mainScrollView;
    }()
    
    lazy var headView:UIView = {
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: maxOffsetY));
        headView.backgroundColor = UIColor.red;
        return headView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "嵌套测试";
        setupUI();
        addChildController(controllerArr[0])
        selectSettingWithIndex(selectedIndex: 0)
    }
    func setupUI() -> Void {
        view.backgroundColor = UIColor.white;
        self.edgesForExtendedLayout = UIRectEdge.bottom;
        if #available(iOS 11.0, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never;
        }else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        
        mainScrollView.addSubview(headView);
        view.addSubview(mainScrollView);
        
        let menuView:UIView = UIView.init(frame: CGRect(x: 0, y: maxOffsetY, width: view.bounds.width, height: 50));
        menuView.backgroundColor = UIColor.white;
        
        let leftBtn:UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: 50));
        leftBtn.tag = 1001;
        leftBtn.setTitle("左边", for: UIControlState.normal);
        leftBtn.setTitleColor(UIColor.black, for: UIControlState.normal);
        leftBtn.addTarget(self, action: Selector.btnAction, for: .touchUpInside);
        
        
        let rightBtn:UIButton = UIButton.init(frame: CGRect(x: view.bounds.width/2, y: 0, width: view.bounds.width/2, height: 50));
        rightBtn.tag = 1002;
        rightBtn.setTitle("右边", for: UIControlState.normal);
        rightBtn.setTitleColor(UIColor.black, for: UIControlState.normal);
        rightBtn.addTarget(self, action: Selector.btnAction, for: .touchUpInside);
        
        menuView.addSubview(leftBtn);
        menuView.addSubview(rightBtn);
        buttonArr.append(leftBtn);
        buttonArr.append(rightBtn);
        mainScrollView .addSubview(menuView);
        
    }
    // 切换相关
    @objc func titleClicked(_ sender:UIButton) -> Void {
        switch sender.tag - 1001 {
        case 0:
            selectSettingWithIndex(selectedIndex: 0);
            removeChildController(controllerArr[1])
            addChildController(controllerArr[0])
            break;
        case 1:
            selectSettingWithIndex(selectedIndex: 1);
            removeChildController(controllerArr[0])
            addChildController(controllerArr[1])
            break;
        default:
            break;
        }
        if (mainScrollView.contentOffset.y == maxOffsetY) {
            currentVC?.tableView.isScrollEnabled = true;
        }
    }
    private func selectSettingWithIndex(selectedIndex index:NSInteger) {
        for (idx , item) in buttonArr.enumerated()
        {
            if idx == index {
                item.setTitleColor(UIColor.red, for:.normal);
            }else {
                item.setTitleColor(UIColor.black, for:.normal);
            }
        }
    }
    func addChildController(_ childController: UIViewController) {
        currentVC = childController as? BaseTableViewController;
        currentVC?.mainScrollView = mainScrollView;
        self.addChildViewController(childController)
        mainScrollView.insertSubview(childController.view, at: 0)
        childController.view.frame = CGRect(x: 0, y: maxOffsetY+50, width: view.bounds.size.width, height: view.bounds.size.height - 50 - 88)
        childController.didMove(toParentViewController: self)
    }
    func removeChildController(_ childController: UIViewController) {
        childController.willMove(toParentViewController: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
    }
    
    
    
}
extension ViewController:UIGestureRecognizerDelegate {
    // MARK: 手势相关
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func panGestureRecognizerAction(recognizer: UIPanGestureRecognizer) {
        if recognizer.state != .changed{
            currentPanY = 0
            // 每次滑动结束都清空状态
            mainScrollEnabled = false
            subScrollEnabled = false
        }else {
            let currentY = recognizer.translation(in: mainScrollView).y
            // 说明在这次滑动过程中经过了临界点
            if mainScrollEnabled || subScrollEnabled {
                if currentPanY == 0 {
                    currentPanY = currentY  //记录下经过临界点是的 y
                }
                let offsetY = currentPanY - currentY //计算在临界点后的 offsetY
                
                if mainScrollEnabled {
                    let supposeY = maxOffsetY + offsetY
                    if supposeY >= 0 {
                        mainScrollView.contentOffset = CGPoint(x: 0, y: supposeY)
                    }else {
                        mainScrollView.contentOffset = CGPoint.zero
                    }
                }else {
                    // 计算tableview底部边界的y
                    let tableviewMaxY = (currentVC?.tableView.contentSize.height)! - (UIScreen.main.bounds.height - 88 - 50);
                    if (offsetY > tableviewMaxY) {
                        // 当滑动Y到达tableview底部边界时，设定不在滑动
                        currentVC?.tableView.contentOffset = CGPoint(x: 0, y: tableviewMaxY)
                    }else {
                        currentVC?.tableView.contentOffset = CGPoint(x: 0, y: offsetY)
                    }
                    
                }
            }
        }
    }
    
}
extension ViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            if scrollView.contentOffset.y >= maxOffsetY {
                scrollView.setContentOffset(CGPoint(x: 0, y: maxOffsetY), animated: false)
                mainScrollView.isScrollEnabled = false
                currentVC?.tableView.isScrollEnabled = true
                subScrollEnabled = true
                mainScrollEnabled = false
                currentVC?.mainScrollEnabled = mainScrollEnabled;
                currentVC?.subScrollEnabled = subScrollEnabled;
                
            }
        }
    }
}
private extension Selector {
    static let btnAction = #selector(ViewController.titleClicked(_:))
}
