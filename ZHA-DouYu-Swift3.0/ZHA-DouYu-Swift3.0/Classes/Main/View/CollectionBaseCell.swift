//
//  CollectionBaseCell.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/8.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionBaseCell: UICollectionViewCell {
    //MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlineBtn: UIButton!
    
    //MARK:- 定义模型属性
    var anchor: AnchorModel? {
        didSet {
            // 0.校验模型是否有值
            guard let anchor = anchor else { return }
            
            // 1.取出在线人数显示的文字
            var onlineStr: String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online / 10000))万人在线"
            } else {
                onlineStr = "\(anchor.online)人在线"
            }
            onlineBtn.setTitle(onlineStr, for: .normal)
            
            // 2. 昵称的显示
            nickNameLabel.text = anchor.nickname
            
            // 3. 设置封面图片
            guard let inconURL = URL(string:anchor.vertical_src) else { return }
            iconImageView.kf.setImage(with: ImageResource(downloadURL: inconURL))
        }
    }

}
