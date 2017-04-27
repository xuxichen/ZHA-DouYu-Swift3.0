//
//  CollectionNormalCell.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/23.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {

    // MARK:- 控件属性
    @IBOutlet weak var roomNameLabel: UILabel!
    
    // MARK:- 定义模型属性
    override var anchor: AnchorModel? {
        didSet {
            // 0.将属性传递个父类
            super.anchor = anchor
            
            // 1. 房间名称
            roomNameLabel.text = anchor?.room_name
        }
    }

}
