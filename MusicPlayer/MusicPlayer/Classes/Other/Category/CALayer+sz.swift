//
//  CALayer+sz.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/7.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

extension CALayer {
  //暂停动画
  func pauseAnimate() {
    let pausedTime: TimeInterval = convertTime(CACurrentMediaTime(), from: nil)
    speed = 0.0
    timeOffset = pausedTime
  }
  
  //恢复动画
  func resumeAnimation() {
    let pausedTime: TimeInterval = timeOffset
    speed = 1.0
    timeOffset = 0.0
    beginTime = 0.0
    let timeSincePause: TimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    beginTime = timeSincePause
    
  }
}
