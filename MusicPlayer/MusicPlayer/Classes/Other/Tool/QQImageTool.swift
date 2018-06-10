//
//  QQImageTool.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/6/9.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {

  class func getNewImage(sourceImage: UIImage?, str: String?) -> UIImage? {
    //0.容错处理
    guard let image = sourceImage else {
      return nil
    }
    guard let resultStr = str else {
      return image
    }
    let size = image.size
    
    //1.开启图片上下午
    UIGraphicsBeginImageContext(size)
    //2.绘制图片
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    //3.绘制文字
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    let textRect = CGRect(x: 0, y: 0, width: size.width, height: 18)
    let textDict = [
      NSAttributedStringKey.foregroundColor: UIColor.white,
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
      NSAttributedStringKey.paragraphStyle: style
    ]
    (resultStr as NSString).draw(in: textRect, withAttributes: textDict)
    //4. 取出图片
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    
    //5.关闭上下文
    UIGraphicsEndImageContext()
    
    return resultImage
  }
  
}
