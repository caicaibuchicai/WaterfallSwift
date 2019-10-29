//
//  WaterfallLayout.swift
//  WaterfallSwift
//
//  Created by admin on 2019/10/11.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

/// 瀑布流代理
@objc protocol WaterfallLayoutDataSource : class {
    
    /// 指定ITEM的高度
    ///
    /// - Parameters:
    ///   - layout: 布局
    ///   - indexPath: 位置
    /// - Returns: 高度比例
    func waterfallLayout(_ layout : WaterfallLayout, indexPath : IndexPath) -> CGFloat
    
    /// 瀑布流一共有多少列，默认时三列
    /// - Parameter layout: 布局
    /// - Returns: 列数
    @objc optional func numberOfColsInWaterfallLayout(_ layout : WaterfallLayout) -> Int
}

class WaterfallLayout: UICollectionViewFlowLayout {
    
    // MARK: 对外提供属性
    // 瀑布流数据源代理
    weak var dataSource : WaterfallLayoutDataSource?
    
    // MARK: 私有属性
    // 布局属性数组
    private lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    // 最高的高度
    private var maxH : CGFloat = 0
    
    //索引
    private var startIndex = 0
}

extension WaterfallLayout {
    
    override func prepare() {
        super.prepare()
        
        //获取item的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        //获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        //每一列的高度累计
         var colHeights = Array(repeating: self.sectionInset.top, count: cols)
        
        //计算Item的宽度（屏幕宽度铺满）
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        attrsArray = Array.init()
        //计算所有的item的属性
        for i in 0..<itemCount {
            // 设置每一个Item位置相关的属性
            let indexPath = IndexPath(item: i, section: 0)
            
            // 根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 获取CELL的高度
            guard var height = dataSource?.waterfallLayout(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            height = height * itemW
            //取出当前列所属的列索引
            let index = i % cols
            
            //获取当前列的总高度
            var colH = colHeights[index]
            
            //将当前列的高度在加载当前ITEM的高度
            colH = colH + height + minimumLineSpacing
            
            //重新设置当前列的高度
            colHeights[i % cols] = colH
            
            // 5.设置item的属性
            attrs.frame = CGRect(x: self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index), y: colH - height - self.minimumLineSpacing, width: itemW, height: height)
            
            attrsArray.append(attrs)
        }
        
        // 4.记录最大值
        maxH = colHeights.max()!
        
        // 5.给startIndex重新复制
        startIndex = itemCount
    }
}

extension WaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }
}
