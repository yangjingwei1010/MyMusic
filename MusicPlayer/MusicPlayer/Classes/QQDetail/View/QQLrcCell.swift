//
//  QQLrcCell.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/14.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

  @IBOutlet weak var lrcLabel: QQLrcLabel!
  
  var progress: CGFloat = 0 {
    didSet {
      lrcLabel.radio = progress
    }
  }
  
  var lrcContent: String = "" {
    didSet {
      lrcLabel.text = lrcContent
    }
  }
  
  class func cellWithTableView(tableView: UITableView) -> QQLrcCell {
    let cellId = "lrc"
    var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? QQLrcCell
    if cell == nil {
      cell = Bundle.main.loadNibNamed("QQLrcCell", owner: nil, options: nil)?.first as? QQLrcCell
    }
    return cell!
  }
    
}
