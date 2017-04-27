//
//  CollectionPrettyCell.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/23.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class CollectionPrettyCell: CollectionBaseCell {

    //MARK:- 控件属性
    @IBOutlet weak var cityBtn: UIButton!
    
    //MARK:- 定义模型属性
    override var anchor: AnchorModel? {
        didSet {
            
            // 0.将属性传递个父类
            super.anchor = anchor
            
            // 1. 所在的城市
            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
            
        }
    }
}
