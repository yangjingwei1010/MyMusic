//
//  QQLrcLabel.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/14.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

  var radio: CGFloat = 0.0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    super.drawText(in: rect)
    
    // 设置一个颜色
    UIColor.red.set()
    let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * radio, height: rect.size.height)
    //歌词变色
    UIRectFillUsingBlendMode(fillRect, CGBlendMode.sourceIn)
  }
  
}
