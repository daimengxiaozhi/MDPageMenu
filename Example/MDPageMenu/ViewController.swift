//
//  ViewController.swift
//  MDPageMenu
//
//  Created by Alan on 2018/3/29.
//  Copyright © 2018年 MD. All rights reserved.
//

import UIKit
import MDPageMenu

let mainW = UIScreen.main.bounds.size.width
let mainH = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    var pageMenu: MDPageMenu!
    @IBOutlet weak var containView: UIScrollView!
    
    @IBOutlet weak var v_pageMeun: UIView!
    
    var myChildViewControllers = NSMutableArray.init(capacity: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MDPageMenu"
        
        pageMenu = MDPageMenu.init(frame: CGRect(x: 0, y: 0, width:mainW , height: 40))
        pageMenu.tracker?.image = UIImage.creatImageWithColor(color: .red)
        pageMenu.dividingLine?.image = UIImage.creatImageWithColor(color: UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1))
        pageMenu.permutationWay = .notScrollAdaptContent
        pageMenu.selectedItemTitleColor = .red
        pageMenu.isTextZoom = true
        pageMenu.setItems(items: ["推荐","生活","影视中心","交通"], selectedItemIndex: 2)
        

        
        v_pageMeun.addSubview(pageMenu)
        
        pageMenu.delegate = self
        
        for i in 0...3{
            let vc = SubViewController()
            vc.text = "这是第\(i+1)个VC"
            self.addChildViewController(vc)
            self.myChildViewControllers.add(vc)
        }
        
        
        pageMenu.setBridgeScrollView(bridgeScrollView: containView)
        
        if self.pageMenu.selectedItemIndex <
            self.myChildViewControllers.count{
            let vc = self.myChildViewControllers[self.pageMenu.selectedItemIndex] as!SubViewController
            self.containView.addSubview(vc.view)
            vc.view.frame = CGRect(x: mainW * CGFloat(self.pageMenu.selectedItemIndex), y: 0, width: mainW, height: self.containView.height)
            containView.contentOffset = CGPoint(x: mainW * CGFloat(self.pageMenu.selectedItemIndex) , y: 0)
            containView.contentSize = CGSize(width: 4*mainW, height: 0)
        }
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:MDPageMenuDelegate{
    func itemSelectedAtIndex(index: Int) {
        print(index)
    }
    func itemSelectedFromIndexToIndex(fromIndex: Int, toIndex: Int) {
         print(pageMenu.tracker.frame)
        if labs(toIndex - fromIndex) >= 2{
            self.containView.setContentOffset(CGPoint(x: mainW * CGFloat(toIndex), y: 0), animated: false)
        }else{
            self.containView.setContentOffset(CGPoint(x: mainW * CGFloat(toIndex), y: 0), animated: true)
        }
        
        if self.myChildViewControllers.count <= toIndex{return}
        let targetViewController = self.myChildViewControllers[toIndex]as!SubViewController
        if targetViewController.isViewLoaded{return}
        
        targetViewController.view.frame = CGRect(x: mainW * CGFloat(toIndex) , y: 0, width: mainW, height: containView.height)
        
        containView.addSubview(targetViewController.view)
        
       
    }
}

