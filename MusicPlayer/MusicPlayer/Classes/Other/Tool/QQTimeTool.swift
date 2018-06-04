//
//  QQTimeTool.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/6.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {
  //格式化时间
  class func getFormatTime(timeInterval: TimeInterval) -> String {
    let min = Int(timeInterval) / 60
    let sec = Int(timeInterval) % 60
    return String(format: "%02d: %02d", min,sec)
  }
  
  class func getTimeInterval(formatTime: String) -> TimeInterval {
    //00:00.91转换成秒
    let minSec = formatTime.components(separatedBy: ":")
    if minSec.count != 2 {
      return 0
    }
    let min = TimeInterval(minSec[0]) ?? 0
    let sec = TimeInterval(minSec[1]) ?? 0
    
    return min * 60.0 + sec
    
  }
  
}
