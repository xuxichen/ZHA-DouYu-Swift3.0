//
//  FunnyViewModel.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/23.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class FunnyViewModel: BaseViewModel {

}

extension FunnyViewModel {
    func loadFunnyData(finishedCallback: @escaping () -> ()) {
        loadAnchorData(isGroupData: false, URLString: "http://capi.douyucdn.cn/api/v1/getColumnRoom/3", parameters: ["limit" : 30, "offset" : 0], finishedCallback: finishedCallback)
    }
}
