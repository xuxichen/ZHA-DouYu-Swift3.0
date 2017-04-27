//
//  RecommedViewController.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/17.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

//MARK - 自定义常量
private let kCycleViewH = kScreenW * 3 / 8
private let kGameViewH : CGFloat = 90

class RecommedViewController: BaseAnchorViewController {
    
    //MARK - 懒加载属性
    fileprivate lazy var recommedVM: RecommendViewModel = RecommendViewModel()
    fileprivate lazy var cycleView: RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH-kGameViewH, width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    fileprivate lazy var gameView: RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
        
    }()
    
}

//MARK - 请求数据
extension RecommedViewController {
    override func loadData() {
        //0.给父类中的ViewModel进行赋值
        baseVM = recommedVM
        // 1.请求推荐数据
        recommedVM.requestData{
            
            //1.展示推荐数据
            self.collectionView.reloadData()
            
            //2.将数据传递个GameView
            var groups = self.recommedVM.anchorGroups
            //2.1.移除前两组数据
            groups.removeFirst()
            groups.removeFirst()
            
            //2.2.添加更多组
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)

            self.gameView.groups = groups
            
            //3.数据请求完成
            self.loadDataFinished()
        }
        
        // 2.请求轮播数据
        recommedVM.requestCycleData {
            self.cycleView.cycleModels = self.recommedVM.cycleModels
        }
    }
}

//MARK - 设置UI界面内容
extension RecommedViewController {
    //1.设置UI
    override func setupUI() {
        //1
        super.setupUI()

        //2.将cycleView添加到collectionView中
        collectionView.addSubview(cycleView)
        
        //3.将gameView添加到collectionView中
        collectionView.addSubview(gameView)
        
        //4.设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
}

extension RecommedViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            //1.取出prettyCell
            let prettyitem = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
            
            prettyitem.anchor = recommedVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            return prettyitem
        } else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
}
