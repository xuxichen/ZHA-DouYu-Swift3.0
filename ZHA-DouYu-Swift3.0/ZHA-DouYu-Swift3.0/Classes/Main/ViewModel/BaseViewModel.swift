//
//  BaseViewModel.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/20.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class BaseViewModel {
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
}

extension BaseViewModel {
    func loadAnchorData(isGroupData: Bool, URLString: String, parameters: [String : Any]? = nil, finishedCallback: @escaping () -> ()) {
        NetworkTools.requestData(.get, URLSting: URLString, parameters: parameters) { (result) in
            // 1. 讲result转换成字典类型
            guard let resultDict = result as? [String : Any] else { return }
            // 2. 根据data这个key 获取数组
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            //3.判断是否分组数据
            if isGroupData {
                //3.1遍历数组中的字典
                for dict in dataArray {
                    self.anchorGroups.append(AnchorGroup(dict: dict))
                }
            } else {
                //3.1创建组
                let group = AnchorGroup()
                
                //3.2遍历dataArray的所有字典
                for dict in dataArray {
                    group.anchors.append(AnchorModel(dict: dict))
                }
                //3.3将group添加到anchorGroups
                self.anchorGroups.append(group)
            }
            
            //完成回调
            finishedCallback()
        }
    }
}
