//
//  AmuseViewModel.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/21.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class AmuseViewModel: BaseViewModel {

}

extension AmuseViewModel {
    func loadAmuseData(finishedCallback: @escaping () -> ()) {
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishedCallback: finishedCallback)
    }
}
