//
//  MainViewController.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/11.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC(storyBoradName: "Home")
        addChildVC(storyBoradName: "Live")
        addChildVC(storyBoradName: "Follow")
        addChildVC(storyBoradName: "Find")
        addChildVC(storyBoradName: "Profile")
        // Do any additional setup after loading the view.
    }
    
    private func addChildVC(storyBoradName: String) {
        
        let childVC = UIStoryboard(name: storyBoradName, bundle: nil).instantiateInitialViewController()!
        
        addChildViewController(childVC)
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
