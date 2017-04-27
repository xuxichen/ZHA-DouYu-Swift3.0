//
//  GameViewController.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/15.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 10
private let kItemW : CGFloat = (kScreenW - 2 * kEdgeMargin) / 3
private let kItemH : CGFloat = kItemW * 6 / 5
private let kHeaderViewH : CGFloat = 50

private let kGameViewH : CGFloat = 90

private let kGameCellID = "kGameCellID"
private let kHeaderViewID = "kHeaderViewID"

class GameViewController: BaseViewController {

    //MARK: -懒加载属性
    fileprivate lazy var gameVM: GameViewModel = GameViewModel()
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        // 1.创建布局对象
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: kEdgeMargin, bottom: 0, right: kEdgeMargin)
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.register(UINib(nibName: "HeaderRecomderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        collectionView.dataSource = self
        return collectionView
    }()
    
    fileprivate lazy var topHeaderView: HeaderRecomderReusableView = {
        let headerView = HeaderRecomderReusableView.collectionHeaderView()
        headerView.frame = CGRect(x: 0, y: -(kHeaderViewH + kGameViewH), width: kScreenW, height: kHeaderViewH)
        headerView.iconImageView.image = UIImage(named: "Img_orange")
        headerView.titleLabel.text = "常见"
        headerView.moreBtn.isHidden = true
        return headerView
    }()
    
    fileprivate lazy var gameView: RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        gameView.backgroundColor = UIColor.red
        return gameView
    }()
    
    //MARK: -系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
        
        
    }
    
}

//MARK: -设置UI界面
extension GameViewController {
    override func setupUI() {
        // 0.给ContentView进行赋值
        contentView = collectionView
        
        // 1.添加UICollectionView
        view.addSubview(collectionView)
        
        //2.添加顶部的HeaderView
        collectionView.addSubview(topHeaderView)
        
        //3.将常用游戏的View。添加到collectionView中
        collectionView.addSubview(gameView)
        
        //4.设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kHeaderViewH + kGameViewH, left: 0, bottom: 0, right: 0)
        
        super.setupUI()
    }
}

//MARK: -请求网络数据
extension GameViewController {
    fileprivate func loadData() {
        gameVM.loadAllGameData {
            //1.展示全部游戏
            self.collectionView.reloadData()
        
            //2.展示常用游戏
            self.gameView.groups = Array(self.gameVM.games[0..<10])

            //3.数据请求完成
            self.loadDataFinished()
        }
    }
}
//MARK: -实现UICollectionView的DataSource协议
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameVM.games.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        item.baseGame = gameVM.games[indexPath.item]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! HeaderRecomderReusableView
        
        //2.给HeaderView设置属性
        headerView.titleLabel.text = "全部"
        headerView.iconImageView.image = UIImage(named: "Img_orange")
        headerView.moreBtn.isHidden = true
        
        return headerView
    }
}
