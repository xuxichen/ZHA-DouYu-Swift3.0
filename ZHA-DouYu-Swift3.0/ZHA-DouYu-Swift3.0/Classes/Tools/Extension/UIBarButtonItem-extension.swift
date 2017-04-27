//
//  UIBarButtonItem-extension.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/11.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func createItem(imageName: String, highImageName: String, size: CGSize) -> UIBarButtonItem{
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:highImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: btn)
    }
    
    //便利构造函数：1.convenience开头 2.在构造函数中必须明确调用一个系统的构造函数
    convenience init(imageName: String, highImageName: String = "", size: CGSize = CGSize.zero) {
        //创建btn
        let btn = UIButton(type: .custom)
        //设置btn常态图片
        btn.setImage(UIImage(named:imageName), for: .normal)
        //设置btn高亮图片
        if highImageName != "" {
            btn.setImage(UIImage(named:highImageName), for: .highlighted)
        }
        //设置btn的尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        }else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView: btn)
    }
}
