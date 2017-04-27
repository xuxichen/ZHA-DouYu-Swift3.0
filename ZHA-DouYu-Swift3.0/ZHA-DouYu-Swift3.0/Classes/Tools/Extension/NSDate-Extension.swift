//
//  NSDate-Extension.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/6.
//  Copyright © 2017年 xxc. All rights reserved.
//

import Foundation

extension Date {

    static func getCurrentTime() -> String {
        let nowDate = NSDate()
        
        let interval = nowDate.timeIntervalSince1970
        
        return "\(interval)"
    }
}
