//
//  RecommendGameView.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/14.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

private let kGameCellID = "kGameCellID"
private let kEdgeInsetMargin : CGFloat = 10

class RecommendGameView: UIView {

    //MARK: 定义数据的属性
    var groups: [BaseGameModel]? {
        didSet {
            //1.刷新表格
            collectionView.reloadData()
        }
    }
    //MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //让控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        
        //注册item
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kGameCellID)
        
        //给collectionView添加内边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: kEdgeInsetMargin, bottom: 0, right: kEdgeInsetMargin)
    }

}

//MARK: -提供快速创建实例对象的类方法
extension RecommendGameView {
    class func recommendGameView() -> RecommendGameView {
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}

//MARK: -遵守UICollectionView的数据源协议
extension RecommendGameView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        let group = groups![indexPath.item]
        item.baseGame = group
        return item
    }
}
