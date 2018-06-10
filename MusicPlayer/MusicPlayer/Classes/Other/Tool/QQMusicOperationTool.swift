//
//  QQMusicOperationTool.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/6.
//  Copyright © 2018年 firstleap. All rights reserved.
//
// 控制的是播放的业务逻辑, 具体的播放, 暂停功能实现(QQMusicTool)
import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {
  
  var lastRow = -1
  
  private var musicModel = QQMusicMessageModel()
  var artWork : MPMediaItemArtwork?
  
  // 在这里, 保持, 数据的最新状态, 就可以
  // 当前正在播放的歌曲信息
  func getMusicMessageModel() -> QQMusicMessageModel {
    musicModel.musicM = musicMs[currentPlayIndex]
    musicModel.costTime = (tool.player?.currentTime) ?? 0
    print("costTime:\(musicModel.costTime)")
    musicModel.totalTime = (tool.player?.duration) ?? 0
    
    musicModel.isPlaying = (tool.player?.isPlaying) ?? false
    
    return musicModel
  }
  
  //熟悉监听器，实现上一首和下一首
  var currentPlayIndex = -1 {
    didSet {
      if currentPlayIndex < 0 {
        currentPlayIndex = musicMs.count - 1
      }
      
      if currentPlayIndex > musicMs.count - 1 {
        currentPlayIndex = 0
      }
    }
  }

  static let shareInstance = QQMusicOperationTool()
  //封装的播放器
  let tool = QQMusicTool()
  
  // 播放的音乐列表
  var musicMs: [QQMusicModel] = [QQMusicModel]()
  
  //播放
  func playMusic(musicM: QQMusicModel) {
    // 播放数据模型对应的音乐
    tool.playMusic(musicName: musicM.filename)
    currentPlayIndex = musicMs.index(of: musicM)!
  }
  
  //播放
  func playCurrentMusic() {
    // 取出需要播放的音乐数据模型
    let model = musicMs[currentPlayIndex]
    // 播放音乐模型
    playMusic(musicM: model)
  }
  
  //暂停
  func pauseCurrentMusic() {
    // 根据音乐模型, 进行暂停
    tool.pauseMusic()
  }
  
  //下一首
  func nextMusic() {
    currentPlayIndex += 1
    // 取出需要播放的音乐数据模型
    let model = musicMs[currentPlayIndex]
    // 根据音乐模型, 进行播放
    playMusic(musicM: model)
    
  }
  
  //上一首
  func preMusic() {
    currentPlayIndex -= 1
    // 取出需要播放的音乐数据模型
    let model = musicMs[currentPlayIndex]
    // 根据音乐模型, 进行播放
    playMusic(musicM: model)
  }
  
  func setupLockMessage() {
    //取出需要展示的数据模型
    let musicMessageM = getMusicMessageModel()
    
    //1.获取锁屏中心
    let center = MPNowPlayingInfoCenter.default()
    
    //2.给锁屏中心赋值
    //歌名
    let musicName = musicMessageM.musicM?.name ?? ""
    //歌手
    let singerName = musicMessageM.musicM?.singer ?? ""
    //播放时间
    let costTime = musicMessageM.costTime
    //总时间
    let totalTime = musicMessageM.totalTime
    //图片
    let imageName = musicMessageM.musicM?.icon ?? ""
    let image = UIImage(named: imageName)
    
    //1.获取当前正在播放的歌词
    let lrcFileName = musicMessageM.musicM?.lrcname
    let lrcMs = QQMusicDataTool.getLrcMs(lrcName: lrcFileName)
    let lrcMRow = QQMusicDataTool.getCurrentLrcM(currentTime: musicMessageM.costTime, lrcMs: lrcMs)
    let lrcM = lrcMRow.lrcM
    
    //2.绘制到图片，生产一个新的突破
    var resultImage: UIImage?
    if lastRow != lrcMRow.row {
      lastRow = lrcMRow.row
      resultImage = QQImageTool.getNewImage(sourceImage: image, str: lrcM?.lrcContent)
    }
    
    //3.设置专辑图片
    if resultImage != nil {
      artWork = MPMediaItemArtwork(boundsSize: (resultImage?.size)!, requestHandler: { (_) -> UIImage in
        resultImage!
      })
    }
    let dic: NSMutableDictionary = [
      MPMediaItemPropertyAlbumTitle: musicName,
      MPMediaItemPropertyAlbumArtist: singerName,
      MPMediaItemPropertyPlaybackDuration: totalTime,
      MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime
    ]
    if artWork != nil {
      dic.setValue(artWork, forKey: MPMediaItemPropertyArtwork)
    }
    
    let dictCopy = dic.copy()
    center.nowPlayingInfo = dictCopy as? [String: AnyObject]
    
    //3.接收远程事件
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
  }
  
  func seekToTime(time: TimeInterval) {
    tool.seekToTime(time: time)
  }
  
}
