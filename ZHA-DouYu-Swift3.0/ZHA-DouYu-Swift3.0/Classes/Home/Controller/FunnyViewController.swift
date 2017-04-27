//
//  FunnyViewController.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/23.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

private let kTopMargin : CGFloat = 8

class FunnyViewController: BaseAnchorViewController {
    //MARK： 懒加载ViewModel对象
    fileprivate lazy var funnyVM: FunnyViewModel = FunnyViewModel()
}

extension FunnyViewController {
    override func setupUI() {
        super.setupUI()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
        collectionView.contentInset = UIEdgeInsets(top: kTopMargin, left: 0, bottom: 0, right: 0)
    }
}

extension FunnyViewController {
    override func loadData() {
        //1.给父类中ViewModel进行赋值
        baseVM = funnyVM
        
        //2.请求数据
        funnyVM.loadFunnyData {
            //2.1刷新数据
            self.collectionView.reloadData()
            
            //2.2数据请求完成
            self.loadDataFinished()
        }
    }
}
