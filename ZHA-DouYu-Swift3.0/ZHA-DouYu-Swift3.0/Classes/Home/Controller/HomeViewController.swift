//
//  HomeViewController.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/11.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit


private let kTitleViewH: CGFloat = 40
class HomeViewController: UIViewController {

    // MARK: - 
    // MARK: - 懒加载属性
    fileprivate lazy var pageTitleView: PageTitleView = { [weak self] in
        let titles: [String] = ["推荐","手游","娱乐","游戏","趣玩"]
        let titileViewFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titleView = PageTitleView(frame: titileViewFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView: PageContentView = { [weak self] in
        //1.确定内容的Frame
        let contentViewH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBarH
        let contentViewFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentViewH)
        
        //2.确定所以得自控制器
        var childVCs = [UIViewController]()
        childVCs.append(RecommedViewController())
        childVCs.append(GameViewController())
        childVCs.append(AmuseViewController())
        childVCs.append(FunnyViewController())
        for _ in 0..<1 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        let contentView = PageContentView(frame: contentViewFrame, childVCs: childVCs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK : --设置UI界面
extension HomeViewController {
    fileprivate func setupUI() {
        //0.不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        //1.设置导航栏
        setupNavgationBar()
        
        //2.添加titleView
        view.addSubview(pageTitleView)
        
        //3.添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.blue
        
    }
    
    private func setupNavgationBar() {
        // 2.设置导航栏左侧的Item
    /*********************************************************************************************/
        /*
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "homeLogoIcon"), for: .normal)
        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        */
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "homeLogoIcon")
    /*********************************************************************************************/
        //3.设置导航栏右侧的Items
        let itemSize = CGSize(width: 40, height: 40)
        //第一种最粗糙的方法
        /*
        let historyBtn = UIButton(type: .custom)
        historyBtn.setImage(UIImage(named: "btn_search"), for: .normal)
        historyBtn.setImage(UIImage(named: "btn_search_clicked"), for: .highlighted)
        historyBtn.frame = CGRect(origin: CGPoint.zero, size: itemSize)
        let historyItem = UIBarButtonItem(customView: historyBtn)
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.setImage(UIImage(named: "image_my_history"), for: .normal)
        searchBtn.setImage(UIImage(named: "Image_my_history_click"), for: .highlighted)
        searchBtn.frame = CGRect(origin: CGPoint.zero, size: itemSize)
        let searchItem = UIBarButtonItem(customView: searchBtn)
        
        let qrcodeBtn = UIButton(type: .custom)
        qrcodeBtn.setImage(UIImage(named: "Image_scan"), for: .normal)
        qrcodeBtn.setImage(UIImage(named: "Image_scan_click"), for: .highlighted)
        qrcodeBtn.frame = CGRect(origin: CGPoint.zero, size: itemSize)
        let qrcodeItem = UIBarButtonItem(customView: qrcodeBtn)
        */
    /*********************************************************************************************/
        //第二种类方法
        /*
        let historyItem = UIBarButtonItem.createItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: itemSize)
        let searchItem = UIBarButtonItem.createItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: itemSize)
        let qrcodeItem = UIBarButtonItem.createItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: itemSize)
        */
    /*********************************************************************************************/
        //第三种构造函数方法
        let historyItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: itemSize)
        let searchItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: itemSize)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: itemSize)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
        
    }
}

//MARK - 遵守PageTitleViewDelagate协议并实现代理方法
extension HomeViewController: PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//MARK - 遵守PageContentViewDelegate协议并实现代理方法
extension HomeViewController: PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgess(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
