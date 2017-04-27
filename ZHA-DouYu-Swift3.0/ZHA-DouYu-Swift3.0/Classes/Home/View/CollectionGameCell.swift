//
//  CollectionGameCell.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/14.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionGameCell: UICollectionViewCell {

    //MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: 定义模型属性
    var baseGame : BaseGameModel? {
        didSet {
            titleLabel.text = baseGame?.tag_name
            if let iconURL = URL(string: baseGame?.icon_url ?? "") {
                iconImageView.kf.setImage(with: iconURL)
            }else {
                iconImageView.image = UIImage(named: "home_more_btn")
            }
            
            
        }
    }

}
