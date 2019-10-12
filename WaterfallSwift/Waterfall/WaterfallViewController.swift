//
//  WaterfallViewController.swift
//  WaterfallSwift
//
//  Created by admin on 2019/10/11.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
private let kContentCellID = "kContentCellID"

class WaterfallViewController: UIViewController{
    private lazy var collectionView : UICollectionView = {
        let layout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.dataSource = self
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "NewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kContentCellID)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    private lazy var cellCount : Int = 10
    var date: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.InitData()
        
    }
    
    func InitData(){
        let arr: [String] = ["http://ww1.sinaimg.cn/large/0065oQSqly1g2pquqlp0nj30n00yiq8u.jpg","https://ww1.sinaimg.cn/large/0065oQSqly1g2hekfwnd7j30sg0x4djy.jpg","https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg","https://ws1.sinaimg.cn/large/0065oQSqly1fytdr77urlj30sg10najf.jpg","https://ws1.sinaimg.cn/large/0065oQSqly1fymj13tnjmj30r60zf79k.jpg","https://ws1.sinaimg.cn/large/0065oQSqgy1fy58bi1wlgj30sg10hguu.jpg","https://ws1.sinaimg.cn/large/0065oQSqgy1fxno2dvxusj30sf10nqcm.jpg","https://ws1.sinaimg.cn/large/0065oQSqgy1fxd7vcz86nj30qo0ybqc1.jpg","https://ws1.sinaimg.cn/large/0065oQSqgy1fwyf0wr8hhj30ie0nhq6p.jpg"]
              for a in 0..<arr.count {
                  let temModel = Model.init()
                  temModel.imageUrl = arr[a]
                  date.append(temModel)
              }
        for  index in 0 ..< self.date.count {
            let _imageView = UIImageView()
            let url = URL.init(string: self.date[index].imageUrl )
            _imageView.kf.setImage(with: url, completionHandler: { (image, error, nil, imageUrl) in
                self.date[index].image = image
                self.collectionView.reloadData()
            })
        }
   
    }
   
    
    
}
extension WaterfallViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.date.count
    }
    
 
    //MARK: - --- 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath) as! NewCollectionViewCell
        if let temimage = self.date[indexPath.row].image {
            cell.imgeView.image = temimage
        } else {
            cell.imgeView.image = Image.init(named: "head.jpg")
        }
        if indexPath.item == self.date.count - 1 {
            for _ in 0...5 {
                let index: Int = Int(arc4random_uniform(UInt32(6)))
                self.date.append(self.date[index])
            }
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.2) {
                     DispatchQueue.main.sync {
                        self.InitData()
                     }
                 }
                 print("加载更多")
             }
        return cell
    }
}


extension WaterfallViewController : WaterfallLayoutDataSource {
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        let temSize = self.date[indexPath.row]
        
        if (temSize.image != nil) {
            let Image = temSize.image
            let scale:CGFloat = (Image?.size.height ?? 200) / (Image?.size.width ?? 1)
            
            return  scale
        }
        return 1
    }
    
    func numberOfColsInWaterfallLayout(_ layout : WaterfallLayout) -> Int{
        return 3
    }
}


extension UIColor{
    // 在extension中给系统的类扩充构造函数,只能扩充`便利构造函数`
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
