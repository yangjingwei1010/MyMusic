//
//  QQMusicDataTool.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/5.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {

  class func getMusics(result:([QQMusicModel]) -> ()) {
    // 1. 获取文件路径
    guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
      result([QQMusicModel]())
      return
    }
    
    // 2. 读取文件内容
    guard let array = NSArray(contentsOfFile: path) else {
      result([QQMusicModel]())
      return
    }
    // 3. 解析: 转换成歌曲模型
    var models = [QQMusicModel]()
    for dic in array {
    
      let model = QQMusicModel(dic: dic as! [String : AnyObject])
//      print(model.name ?? "123")
      models.append(model)
    }
    // 4. 返回结果
    result(models)
  }
  
  class func getLrcMs(lrcName: String?) -> [QQLrcModel] {
    if lrcName == nil {
      return [QQLrcModel]()
    }
    
    // 1. 获取文件的路径
    guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else {
      return [QQLrcModel]()
    }
    
    //2. 读取文件内容
    var lrcContent = ""
    
    do {
      lrcContent = try String (contentsOfFile: path)
    } catch {
      print(error)
      return [QQLrcModel]()
    }
    
    // 3. 解析字符串(转换成为QQLrcModel 组成的数组)
    
    // 3.1 先按照换行符, 分割成每一行字符串来处理
    let timeContentArray = lrcContent.components(separatedBy: "\n")
    var resultMs = [QQLrcModel]()
    
    // 3.2 遍历每个字符串, 单独进行解析一个字符串
    for timeContentStr in timeContentArray {
      if timeContentStr.contains("[ti:") ||
         timeContentStr.contains("[ar:") ||
        timeContentStr.contains("[al:") {
        continue
      }
      // 在这里, 可以拿到真正对的格式的数据
      // [00:00.89]传奇
      // 取出左中括号
      let resultLrcStr = timeContentStr.replacingOccurrences(of: "[", with: "")
      // 00:00.91]简单爱 resultLrcStr
      let timeAndContent = resultLrcStr.components(separatedBy: "]")
      // 容错处理, 防止解析错误格式的数据, 造成崩溃
      if timeAndContent.count != 2 {
        continue
      }
      
      let time = timeAndContent[0]
      let content = timeAndContent[1]
      
      // 创建歌词数据模型, 赋值
      let lrcM = QQLrcModel()
      resultMs.append(lrcM)
      lrcM.beginTime = QQTimeTool.getTimeInterval(formatTime: time)
      lrcM.lrcContent = content
      
    }
    
    // 遍历数组, 给每个模型的结束时间赋值
    let count = resultMs.count
    for i in 0..<count{
    //加个判断防止数字越界
    if i == count - 1 {
      continue
    }
    let lrcM = resultMs[i]
    let nextLrcM = resultMs[i + 1]
    lrcM.endTime = nextLrcM.beginTime
  }
    // 4. 返回结果
    return resultMs
    
  }
  //返回当前对应的歌词
  class func getCurrentLrcM(currentTime: TimeInterval, lrcMs: [QQLrcModel]) -> (row: Int, lrcM: QQLrcModel?) {
    var index = 0
    
    for lrcM in lrcMs {
      if currentTime >= lrcM.beginTime && currentTime < lrcM.endTime {
        return (index, lrcM)
      }
      index += 1
    }
    return (0, nil)
  }
}
