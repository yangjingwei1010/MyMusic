//
//  QQListViewController.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/5.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQListViewController: UITableViewController {

  var musicMs: [QQMusicModel] = [QQMusicModel]() {
    didSet {
      tableView.reloadData()
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // 界面处理
      setupUI()
      
      // 取出数据
      QQMusicDataTool.getMusics { (models: [QQMusicModel]) in
        
        self.musicMs = models
        
        QQMusicOperationTool.shareInstance.musicMs = models
      }
    }

}

extension QQListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return musicMs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = QQMusicCell.cellWithTableView(tableView: tableView)
    let model = musicMs[indexPath.row]
    cell.musicM = model
    
    cell.animation(type: .Rotation)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = musicMs[indexPath.row]
    QQMusicOperationTool.shareInstance.playMusic(musicM: model)
    performSegue(withIdentifier: "listToDetail", sender: nil)
  }
}

extension QQListViewController {
  func setupUI() {
    setTableView()
    // 隐藏导航栏
    navigationController?.isNavigationBarHidden = true
  }
  
  func setTableView() {
    let imageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
    tableView.backgroundView = imageView
    tableView.rowHeight = 60
    tableView.separatorStyle = .none
  }
  
}
