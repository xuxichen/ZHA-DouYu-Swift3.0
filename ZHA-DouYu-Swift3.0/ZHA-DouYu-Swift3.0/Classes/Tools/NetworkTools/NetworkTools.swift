//
//  NetworkTools.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/24.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    class func requestData(_ type: MethodType, URLSting: String, parameters: [String : Any]? = nil, finishedCallback: @escaping (_ result: Any) -> ()) {
        
        //1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        //2.发送网络请求
        Alamofire.request(URLSting, method: method, parameters: parameters).responseJSON { (response) in
            
            //3.获取结果
            guard let result = response.result.value else {
                print(response.result.error ?? "打印错误信息----失败")
                return
            }
            //4.将结果回调出去
            finishedCallback(result as AnyObject)
        }
    }
}
