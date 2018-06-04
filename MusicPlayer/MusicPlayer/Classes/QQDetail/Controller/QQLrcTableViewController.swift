//
//  QQLrcTableViewController.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/8.
//  Copyright © 2018年 firstleap. All rights reserved.
//

//专门用来展示歌词的控制器
import UIKit

class QQLrcTableViewController: UITableViewController {

  // 提供给外界赋值的进度
  var progress: CGFloat = 0 {
    didSet {
      // 拿到当前正在播放的cell
      let indexPath = NSIndexPath(row: scrollRow, section: 0)
      let cell = tableView.cellForRow(at: indexPath as IndexPath) as? QQLrcCell
      // 给cell 里面label, 的进度赋值
      cell?.progress = progress
    }
  }
  
  // 提供给外界的数值, 代表需要滚动的行数
  var scrollRow = -1 {
    didSet {
//      print(scrollRow)
      // 过滤值, 降低滚动频率
      // 如果两个值相等, 代表滚动的是同一行, 没有必要滚动很多次
      if scrollRow == oldValue {
        return
      }
      
      // 先刷新, 再滚动
      let indexPaths = tableView.indexPathsForVisibleRows
      tableView.reloadRows(at: indexPaths!, with: UITableViewRowAnimation.fade)
      
      let indexPath = NSIndexPath(row: scrollRow, section: 0)
      tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.middle, animated: true)
    }
  }
  
  // 提供给外界的数据源
  var lrcMs: [QQLrcModel] = [QQLrcModel]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    // 分割线去除
    tableView.separatorStyle = .none
    // 不允许选中
    tableView.allowsSelection = false
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    //设置内边距，防止歌词开始或者结束可以滚到中间
    tableView.contentInset = UIEdgeInsets(top: tableView.height * 0.5, left: 0, bottom: tableView.height * 0.5, right: 0)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lrcMs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = QQLrcCell.cellWithTableView(tableView: tableView)
    //取出歌词模型
    let model = lrcMs[indexPath.row]
    if indexPath.row == scrollRow {
      cell.progress = progress
    } else {
      cell.progress = 0
    }
    cell.lrcContent = model.lrcContent
    return cell
    
  }

}
