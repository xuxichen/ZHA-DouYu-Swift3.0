//
//  BaseAnchorViewController.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/16.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kHeaderViewH : CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"

let kPrettyCellID = "kPrettyCellID"
let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4
let kPrettyItemH = kNormalItemW * 4 / 3

class BaseAnchorViewController: BaseViewController {

    
    //MARK: 定义属性
    var baseVM: BaseViewModel!
    lazy var collectionView: UICollectionView = { [unowned self] in
        //1.创建布局对象
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "HeaderRecomderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    //MARK: -系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }
}

//MARK: 设置UI界面
extension BaseAnchorViewController {

    override func setupUI() {
        //1.给父类中内容View的引用进行赋值
        contentView = collectionView
        
        //2.添加collectionView
        view.addSubview(collectionView)
        
        //3.调用super.setupUI()
        super.setupUI()
    }
}

//MARK: 请求数据
extension BaseAnchorViewController {
    func loadData() {
    }
}

//MARK: 遵守UICollectionView数据源协议
extension BaseAnchorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM.anchorGroups[section].anchors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.取出item
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        
        //2.个item设置数据
        item.anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        return item
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! HeaderRecomderReusableView
        //2.给HeatherView设置数据
        headerView.group = baseVM.anchorGroups[indexPath.section]
        
        return headerView
    }
}

//MARK:遵守UICollectionView的代理协议
extension BaseAnchorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1.取出对应的主播信息
        let anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        //2.判断是秀场房间&普通房间
        anchor.isVertical == 0 ? pushNormalRoomVC() : presentShowRoomVC()
    }
    
    private func presentShowRoomVC() {
        //1.创建ShowRoomVC
        let showRoomVC = RoomShowViewController()
        //2.以模态的形式弹出
        present(showRoomVC, animated: true, completion: nil)
    }
    
    private func pushNormalRoomVC() {
        // 1.创建NormalRoomVc
        let normalRoomVc = RoomNormalViewController()
        
        // 2.以Push方式弹出
        navigationController?.pushViewController(normalRoomVc, animated: true)
    }
}
