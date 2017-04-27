//
//  PageTitleView.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/1/12.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit
//MARK - 定义协议
protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}
//MARK - 定义常亮
private let kScrollViewLineH: CGFloat = 2
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

//MARK - 定义PageTitleView类
class PageTitleView: UIView {

    //MARK: -- 定义属性
    fileprivate var currentIndex: Int = 0
    fileprivate var titles: [String]
    weak var delegate: PageTitleViewDelegate?
    
    //MARK: -- 懒加载属性
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    //MARK: -- 定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTitleView {
    fileprivate func setupUI() {
        //1.添加UIScrollView
        scrollView.frame = bounds
        addSubview(scrollView)
        
        //2.添加title对应Label
        setupTitleLabels()
        
        //3.设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels() {
        //0.设置label的尺寸属性
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollViewLineH
        let labelY: CGFloat = 0

        for (index, title) in titles.enumerated() {
            //1.创建label
            let label = UILabel()
            
            //2.设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //3.设置label的尺寸属性
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //4.添加label到scrollview
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 1
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        scrollView.addSubview(bottomLine)
        
        //2.添加scrollLine
        //2.1获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollViewLineH, width: firstLabel.frame.width, height: kScrollViewLineH)
        scrollView.addSubview(scrollLine)
        
    }
}

//MARK - 监听Label的点击
extension PageTitleView {
    @objc fileprivate func titleLabelClick(tapGes: UITapGestureRecognizer) {
        
       //0.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        //1.如果是重复点击同一个Title，那么直接返回
        if currentLabel.tag == currentIndex { return }
        //2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        //3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //4.保存最新的label的下标值
       currentIndex = currentLabel.tag
        
        //5.滚动条位置发生改变
        let scrollLinePosition = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollLine.frame.origin.x = scrollLinePosition
        })
        
        //6.通知代理回调方法
        if delegate != nil {
            self.delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
        }
    }
}

//MARK - 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgess(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        //1.取出sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX   
        
        //3.颜色的渐变（复杂）
        //3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        //3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        //3.3 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //4.记录最新的index
        currentIndex = targetIndex
    }
}

