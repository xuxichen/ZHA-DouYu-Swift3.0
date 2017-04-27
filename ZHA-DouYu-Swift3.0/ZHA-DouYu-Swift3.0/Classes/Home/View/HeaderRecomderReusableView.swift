//
//  HeaderRecomderReusableView.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/23.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

class HeaderRecomderReusableView: UICollectionReusableView {
    // MARK- 控件属性
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    
    // MARK - 定义模型
    var group: AnchorGroup? {
        didSet {
            titleLabel.text = group?.tag_name
            iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK:- 从Xib中快速创建的类方法
extension HeaderRecomderReusableView {
    class func collectionHeaderView() -> HeaderRecomderReusableView {
        return Bundle.main.loadNibNamed("HeaderRecomderReusableView", owner: nil, options: nil)?.first as! HeaderRecomderReusableView
    }
}
