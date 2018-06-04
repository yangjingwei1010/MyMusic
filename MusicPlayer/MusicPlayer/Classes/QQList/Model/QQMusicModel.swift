//
//  QQMusicModel.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/5.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {

  /** 歌曲名称 */
  @objc var name: String?
  /** 歌曲文件名称 */
  @objc var filename: String?
  /** 歌词文件名称 */
  @objc var lrcname: String?
  /** 歌手名称 */
  @objc var singer: String?
  /** 歌手头像名称 */
  @objc var singerIcon: String?
  /** 专辑头像图片 */
  @objc var icon: String?
  
  override init() {
    super.init()
  }
  
  init(dic: [String: AnyObject]) {
    super.init()
    setValuesForKeys(dic)
//    name = dic["name"] as? String
//    filename = dic["filename"] as? String
//    lrcname = dic["lrcname"] as? String
//    singer = dic["singer"] as? String
//    singerIcon = dic["singerIcon"] as? String
//    icon = dic["icon"] as? String
  }
  
  override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
  }
  
}
