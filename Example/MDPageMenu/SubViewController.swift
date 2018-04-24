//
//  SubViewController.swift
//  MDPageMenu
//
//  Created by Alan on 2018/4/12.
//  Copyright © 2018年 MD. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {

    var text:String?
    var textLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: mainW, height: mainH - 64 - 40))
        textLabel.textAlignment = .center
        textLabel.text = text
        self.view.addSubview(textLabel)
        // Do any additional setup after loading the view.
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
