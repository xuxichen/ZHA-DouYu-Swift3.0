//
//  CycleModel.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/13.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class CycleModel: NSObject {
    //标题
    var title: String = ""
    //展示的图片地址
    var pic_url: String = ""
    //主播信息对象的模型对象
    var anchor: AnchorModel?
    
    //主播信息对应的字典
    var room: [String : NSObject]? {
        didSet {
            guard let room = room else { return }
            anchor = AnchorModel(dict: room)
        }
    }
    
    //MARK:- 自定义构造函数
    init(dict: [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
