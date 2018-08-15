//
//  HomeView.swift
//  NoteBook
//
//  Created by 张洁 on 2018/8/5.
//  Copyright © 2018年 张洁. All rights reserved.
//

import UIKit
protocol HomeButtonDelegate {
    func homeButtonClick(title: String)
}

class HomeView: UIScrollView {

    let interitemSpacing = 25
    let lineSpacing = 25
    var dataArray: [String]?
    var itemArray = [UIButton]()
    var homeButtonDelegate : HomeButtonDelegate?
    
    func updateLayout() {
        let itemWidth = (frame.size.width - CGFloat(4 * interitemSpacing))/3
        let itemHeigth = itemWidth/3*4
        
        // UI 和模型中都删除
        itemArray.forEach { (element) in
            element.removeFromSuperview()
        }
        itemArray.removeAll()
        
        // 进行布局
        guard dataArray != nil else {
            return
        }
        guard dataArray!.count > 0 else {
            return
        }
        
        for index in 0 ..< dataArray!.count {
            let btn = UIButton(type: .system)
            btn.setTitle(dataArray![index], for: .normal)
            btn.frame = CGRect(x: CGFloat(interitemSpacing) + CGFloat(index % 3)*(itemWidth + CGFloat(interitemSpacing)), y: CGFloat(lineSpacing) + CGFloat(index/3) * (itemHeigth + CGFloat(lineSpacing)), width: itemWidth, height: itemHeigth)
            btn.backgroundColor = UIColor (red: 1, green: 242/255.0, blue: 216/255.0, alpha: 1)
            
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 15
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.tag = index
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            self.addSubview(btn)
            itemArray.append(btn)
        }
        
        contentSize = CGSize(width: 0, height: itemArray.last!.frame.maxY + CGFloat(lineSpacing))
    }
    
    @objc func btnClick(btn: UIButton) {
        homeButtonDelegate?.homeButtonClick(title: dataArray![btn.tag])
    }
 
}
