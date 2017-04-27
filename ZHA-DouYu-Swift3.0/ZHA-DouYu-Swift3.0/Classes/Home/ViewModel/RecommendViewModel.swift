//
//  RecommendViewModel.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/6.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class RecommendViewModel: BaseViewModel {
    //MARK - 懒加载属性
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    fileprivate lazy var bigDataGroup: AnchorGroup = AnchorGroup()
    fileprivate lazy var prettyGroup: AnchorGroup = AnchorGroup()
}

//MARK -- 发送网路请求
extension RecommendViewModel {
    
    //请求推荐数据
    func requestData(finishCallBack:@escaping ()->()) {
        //1.n定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : Date.getCurrentTime()]
        // 2.创建Group
        let dispatchgroup = DispatchGroup()
 
        // 3. 请求第一部分推荐数据
        dispatchgroup.enter()
        NetworkTools.requestData(.get, URLSting: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : Date.getCurrentTime()], finishedCallback: { (result) in
            // 1. 讲result转换成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2. 根据data这个key 获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            // 3.遍历字典，并且转成模型对象
            // 3.1.设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            // 3.3 离开组
            dispatchgroup.leave()
        })
        // 4. 请求第二部分颜值数据
        dispatchgroup.enter()
        NetworkTools.requestData(.get, URLSting: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters, finishedCallback: { (result) in
            // 1. 讲result转换成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2. 根据data这个key 获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历字典，并且转成模型对象
            // 3.1.设置组的属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            // 3.3 离开组
            dispatchgroup.leave()
        })
        // 5. 请求2-12部分游戏数据
        dispatchgroup.enter()
        // http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1474252024
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate",parameters: parameters) {
            dispatchgroup.leave()
        }
        
//        NetworkTools.requestData(.get, URLSting: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters, finishedCallback: {
//            (result) in
//            // 1. 讲result转换成字典类型
//            guard let resultDict = result as? [String : NSObject] else { return }
//            
//            // 2. 根据data这个key 获取数组
//            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
//            
//            //3.遍历数组获取字典，并将字典转成模型对象
//            for dict in dataArray {
//                let group = AnchorGroup(dict: dict)
//                self.anchorGroups.append(group)
//            }
////            for group in self.anchorGroups {
////                print(group.tag_name)
////            }
////            for group in self.anchorGroups {
////                for anchor in group.anchors {
////                    print(anchor.nickname)
////                }
////                print("----------------------")
////            }
//            dispatchgroup.leave()
//        })
        
        // 6.所有数据都请求到，之后排序
        dispatchgroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            finishCallBack()
            
        }
    }
    
    //请求无线轮播的数据
    func requestCycleData(finishCallBack:@escaping ()->()) {
        NetworkTools.requestData(.get, URLSting: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"],finishedCallback: { (result) in
            
            // 1.获取整体字典数据
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }
            finishCallBack()
        
        })
    
    }
}
