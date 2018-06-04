//
//  QQMusicMessageModel.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/6.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {

  var musicM: QQMusicModel?
  
  // 已经播放时间
  var costTime: TimeInterval = 0
  // 总时长
  var totalTime: TimeInterval = 0
  // 播放状态
  var isPlaying: Bool = false
  
}
