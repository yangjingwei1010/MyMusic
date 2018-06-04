//
//  QQMusicCell.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/5.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

enum AnimationType {
  case Rotation
  case Transition
  case Scale
}

class QQMusicCell: UITableViewCell {

  @IBOutlet weak var singerIconImageView: UIImageView!
  
  @IBOutlet weak var songNameLabel: UILabel!
  
  @IBOutlet weak var singerNameLabel: UILabel!
  
  var musicM: QQMusicModel? {
    didSet{
      singerIconImageView.image = UIImage(named: (musicM?.singerIcon)!)
      songNameLabel.text = musicM?.name
      singerNameLabel.text = musicM?.singer
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    singerIconImageView.layer.cornerRadius = singerIconImageView.width * 0.5
    singerIconImageView.layer.masksToBounds = true
  }
  class func cellWithTableView(tableView: UITableView) -> QQMusicCell {
    let cellID = "music"
    var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQMusicCell
    
    if cell == nil {
      cell = Bundle.main.loadNibNamed("QQMusicCell", owner: nil, options: nil)?.first as? QQMusicCell
    }
    return cell!
  }
  
  func animation(type: AnimationType) {
    switch type {
    case .Rotation:
      self.layer.removeAnimation(forKey: "rotation")
      let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      animation.values = [-1/6 * Double.pi, 0, 1/6 * Double.pi, 0]
      animation.duration = 0.2
      animation.repeatCount = 3
      self.layer.add(animation, forKey: "rotation")
      break
    case .Scale:
      // 在这里, 做一些特殊动画
      self.layer.removeAnimation(forKey: "scale")
      let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
      animation.values = [0.5, 1, 0.5, 1]
      animation.duration = 0.2
      animation.repeatCount = 2
      self.layer.add(animation, forKey: "scale")
    default:
      break
    }
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
