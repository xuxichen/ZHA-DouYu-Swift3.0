//
//  PageContentView.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/16.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

private let contentViewCellID = "contentViewCellID"

class PageContentView: UIView {
    
    //MARK：定义属性
    fileprivate var childVCs: [UIViewController]
    fileprivate weak var parentViewController: UIViewController?
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForBidScrollDelegate: Bool = false
    weak var delegate: PageContentViewDelegate?
    
    //MARK : 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentViewCellID)
        return collectionView
    }()
    //MARK : 自定义构造函数
    init(frame: CGRect, childVCs: [UIViewController], parentViewController: UIViewController?) {
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK - 设置UI界面
extension PageContentView {
    
    //设置UI
    fileprivate func setupUI() {
        
        //1.将所有控制器添加到父控制器中
        for childVC in childVCs {
            parentViewController?.addChildViewController(childVC)
        }
    
        //2. 添加UICollectionView，用于在collectionViewcell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK - 遵守UICollectionView的DataSource代理协议
extension PageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1.创建cell
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: contentViewCellID, for: indexPath)
        
        //2.给cell赋值
        for view in item.contentView.subviews {
            view.removeFromSuperview()  
        }
        let childVC = childVCs[indexPath.item]
        item.contentView.addSubview(childVC.view)
        childVC.view.frame = item.contentView.bounds
        return item
    }
}

//MARK - 遵守UICollectionView的delegate代理协议 
extension PageContentView: UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForBidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0 判断是否是点击事件
        if isForBidScrollDelegate { return }
        //1.获取所以需要的数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        //判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX {      //左滑
            //1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            //2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            //4.如果完全划过去了
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else {     //右滑
            //1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
            
            //4.如果完全划过去了
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }
        
        //3.将progress，targetIndex，sourceIndex 传递给titleView
        if delegate != nil {
            delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        }
    }
}
//MARK - 暴露给外部的方法
extension PageContentView {
    func setCurrentIndex(currentIndex: Int) {
        
        // 1.记录需要禁止执行代理方法
        isForBidScrollDelegate = true
        //2.滚动到指定位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offsetX, y: 0), animated: false)
    }
}

