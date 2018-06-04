//
//  QQMusicTool.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/6.
//  Copyright © 2018年 firstleap. All rights reserved.
//

// 这个类, 负责, 单首歌曲的操作, 播放, 暂停, 停止, 快进, 倍数
import UIKit
import AVFoundation

class QQMusicTool: NSObject {
  
  override init() {
    super.init()
    // 1. 获取音频会话
    let session = AVAudioSession.sharedInstance()
    
    do {
      // 2. 设置会话类别(后台播放)
      try session.setCategory(AVAudioSessionCategoryPlayback)
      // 3. 激活会话
      try session.setActive(true)
    } catch {
      print(error)
      return
    }
    
  }
  
  var player: AVAudioPlayer?
  
  func playMusic(musicName: String?) {
    guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {
      return
    }
    if player?.url == url {
      player?.play()
      return
    }
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      player?.play()
    } catch {
      print(error)
      return
    }
  }
  func pauseMusic() {
    player?.pause()
  }
}
