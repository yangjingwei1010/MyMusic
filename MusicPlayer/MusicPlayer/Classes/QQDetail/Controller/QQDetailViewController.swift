//
//  QQDetailViewController.swift
//  MusicPlayer
//
//  Created by 杨静伟 on 2018/5/5.
//  Copyright © 2018年 firstleap. All rights reserved.
//

import UIKit

// 存放属性
class QQDetailViewController: UIViewController {
/** 歌词动画背景 */
  @IBOutlet weak var lrcScrollView: UIScrollView!
  /** 背景图片 1 */
  @IBOutlet weak var backImageView: UIImageView!
  /** 前进图片 1*/
  @IBOutlet weak var foreImageView: UIImageView!
  /** 歌曲名称 1*/
  @IBOutlet weak var songNameLabel: UILabel!
  /** 歌手名称 1*/
  @IBOutlet weak var singerNameLabel: UILabel!
  
  /** 总时长 1*/
  @IBOutlet weak var totalTimeLabel: UILabel!
  /** 歌词label n */
  @IBOutlet weak var lrcLabel: QQLrcLabel!
  /** 进度条 n*/
  @IBOutlet weak var progressSlider: UISlider!
  /** 已经播放时长 n*/
  @IBOutlet weak var costTimeLabel: UILabel!
  
  /**暂停继续按钮*/
  @IBOutlet weak var pauseOrPlay: UIButton!
  
  // 歌词的视图 1
  lazy var lrcVC: QQLrcTableViewController = {
    return QQLrcTableViewController()
  }()
  
  // 负责更新很多次的timer
  var timer: Timer?
  // 负责更新歌词的link，实现实时的更新，timer完成不了这个功能
  var updateLrcLink: CADisplayLink?
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}
// 业务逻辑
extension QQDetailViewController {
  // 即将显示界面后执行的方法
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 只需要更新一次的界面更新
    setupOnce()
    // 触发需要更新多次的界面更新方法
    addTimer()
    
    addLink()
  }
  
  // 即将不显示界面后执行的方法
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // 移除更新的timer
    removeTimer()
    removeLink()
  }
  
  // 一般这个方法里面, 只存放, 执行一次的方法
  // 注意: 如果通过XIB拖出来的控制器, 在这个方法里面, 获取到的frame大小是没有调整好的, 也就是不是最后的frame, 所以, 布局的一些方法, 千万不要放在这里, 放在viewwilllayoutsubviews方法里面
  override func viewDidLoad() {
    super.viewDidLoad()
    // 添加歌词视图
    addLrcView()
    // 设置做歌词动画的滚动视图
    setupLrcScrollView()
    // 设置进度条
    setSlider()
    
     /** 注意: 以上涉及到的控件布局, 都是在另外一个方法viewWillLayoutSubviews */
    
    NotificationCenter.default.addObserver(self, selector: #selector(QQDetailViewController.nextMusic), name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
  }
  
  // 执行多次更新方法的定时器
  func addTimer() {
    timer = Timer(timeInterval: 1, target: self, selector: #selector(QQDetailViewController.setupTimes), userInfo: nil, repeats: true)
    RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
  }
  // 移除定时器
  func removeTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  func addLink() {
    updateLrcLink = CADisplayLink(target: self, selector: #selector(QQDetailViewController.updateLrc))
    updateLrcLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    
  }
  
  func removeLink() {
    updateLrcLink?.invalidate()
    updateLrcLink = nil
  }
  
  @IBAction func tap(sender: UITapGestureRecognizer) {
    print("tap")
    //获取手指在slider上的x
    let point = sender.location(in: sender.view)
    let x = point.x
    
    let value = x / (sender.view?.width)!
    progressSlider.value = Float(value)
    
    //修改播放时间，设置歌曲播放的某个时间点
    let musicMessegeM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
    let totalTime = musicMessegeM.totalTime
    //计算已经播放的时长
    let costTime = totalTime * TimeInterval(value)
    
    //设置歌曲播放到对应的时间点
    QQMusicOperationTool.shareInstance.seekToTime(time: costTime)
    
  }
  @objc func touchDown() {
    // 移除timer
    removeTimer()
    
  }
  @objc func touchUp() {
  //添加timer
    addTimer()
    //设置歌曲播放某个时间点
    let value = progressSlider.value
    //获取总时长
    let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
    let totalTime = musicMessageM.totalTime
    
    //计算已经播发的时长
    let costTime = totalTime * TimeInterval(value)
   //设置歌曲播放到对应的时间点
    QQMusicOperationTool.shareInstance.seekToTime(time: costTime)
    
  }
  
  @objc func valueChange() {
    // 修改已经播放的时间
    
    // 0.0 - 1.0
    let value = progressSlider.value
    
    //获取总时长
    let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
    let totalTime = musicMessageM.totalTime
    let costTime = totalTime * TimeInterval(value)
    let timeStr = QQTimeTool.getFormatTime(timeInterval: costTime)
    costTimeLabel.text = timeStr
    
  }
  
  // 关闭控制器
  @IBAction func close() {
    navigationController?.popViewController(animated: true)
  }
  // 播放或者暂停
  @IBAction func playOrPause(sender: UIButton) {
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      QQMusicOperationTool.shareInstance.playCurrentMusic()
      resumeRotationAnimation()
    } else {
      QQMusicOperationTool.shareInstance.pauseCurrentMusic()
      pauseRotationAnimation()
    }
    
    
  }
  // 上一首
  @IBAction func preMusic() {
    QQMusicOperationTool.shareInstance.preMusic()
    // 切换一次更新界面的操作
    setupOnce()
  }
  
  // 下一首
  @IBAction func nextMusic() {
    QQMusicOperationTool.shareInstance.nextMusic()
    // 切换一次更新界面的操作
    setupOnce()
  }
  
  // 当歌曲切换时, 需要更新一次的操作
  func setupOnce() {
    let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
    guard let musicM = musicMessageM.musicM else {
      return
    }
    
    /** 背景图片 1 */
    if musicM.icon != nil {
      backImageView.image = UIImage(named: musicM.icon!)
      /** 前景图片 1*/
      foreImageView.image = UIImage(named: musicM.icon!)
    }
    
    /** 歌曲名称 1*/
    songNameLabel.text = musicM.name
    /** 歌手名称 1*/
    singerNameLabel.text = musicM.singer
    /** 总时长 1*/
    totalTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageM.totalTime)
    
    //切换最新歌词
    let lrcMs = QQMusicDataTool.getLrcMs(lrcName: musicM.lrcname)
    lrcVC.lrcMs = lrcMs
    
    //添加旋转动画
    addRotationAnimation()
    
    if musicMessageM.isPlaying {
      resumeRotationAnimation()
    } else {
      pauseRotationAnimation()
    }
    
  }
  
  // 当歌曲切换时, 需要更新N次的操作
  @objc func setupTimes() {
    /** 歌词label n */
//    lrcLabel.text = ""
    let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
    
    /** 进度条 n*/
    progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
    /** 已经播放时长 n*/
    costTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageM.costTime)
    //实时监测暂停播放按钮的状态
    pauseOrPlay.isSelected = musicMessageM.isPlaying
  }
  
  //更新歌词
  @objc func updateLrc() {
    let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
    
    // 拿到歌词
    // 当前时间
    let time = musicMessageM.costTime
    // 歌词数组
    let lrcMs = lrcVC.lrcMs
    
    let rowLrcM = QQMusicDataTool.getCurrentLrcM(currentTime: time, lrcMs: lrcMs)
    let lrcM = rowLrcM.lrcM
    
    // 赋值
    lrcLabel.text = lrcM?.lrcContent
    
    // 进度
    if lrcM != nil {
      let time1 = time - lrcM!.beginTime
      let time2 = lrcM!.endTime - lrcM!.beginTime
      lrcLabel.radio = CGFloat(time1 / time2)
    }
    lrcVC.progress = lrcLabel.radio
    
    // 滚动歌词
    // 滚到哪一行
    let row = rowLrcM.row
    // 赋值lrcVC, 让它来负责具体怎么滚
    lrcVC.scrollRow = row
    //进入后台才进行锁屏设置
    if UIApplication.shared.applicationState == .background {
      //锁屏
      QQMusicOperationTool.shareInstance.setupLockMessage()
    }
  }
}

// 界面操作
extension QQDetailViewController {
  // 系统重新布局子控件的方法(在这个方法里面, 可以获取到最后正确的frame, 所以, 一般把控件的布局, 写到这个位置)
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    // 设置歌词frame
    setLrcFrame()
    // 设置前景图片圆角
    setupForeImageView()
  }
  
  // 设置进度条图标
  func setSlider() {
    progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
    
    progressSlider.addTarget(self, action: #selector(QQDetailViewController.touchDown), for: .touchDown)
    progressSlider.addTarget(self, action: #selector(QQDetailViewController.touchUp), for: .touchUpInside)
    progressSlider.addTarget(self, action: #selector(QQDetailViewController.valueChange), for: .valueChanged)
  }
  // 设置前景图片的圆角效果
  func setupForeImageView() {
    foreImageView.layer.cornerRadius = foreImageView.width * 0.5
    foreImageView.layer.masksToBounds = true
  }
  
  // 添加歌词视图
  func addLrcView() {
//    lrcView = UIView()
//    lrcView?.backgroundColor = UIColor.clear
//    lrcScrollView.addSubview(lrcView!)
    
    lrcVC.tableView.backgroundColor = UIColor.clear
    lrcScrollView.addSubview(lrcVC.tableView)
  }
  
  // 调整歌词frame
  func setLrcFrame() {
//    lrcView?.frame = lrcScrollView.bounds
//    lrcView?.x = lrcScrollView.width
//    lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)
    
    lrcVC.tableView.frame = lrcScrollView.bounds
    lrcVC.tableView.x = lrcScrollView.width
    lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)
  }
  
  // 设置scrollView的contentSize
  func setupLrcScrollView() {
    // 设置代理, 监听滚动--> 做动画用的
    lrcScrollView.delegate = (self as UIScrollViewDelegate)
    // 设置分页
    lrcScrollView.isPagingEnabled = true
    // 隐藏水平滚动条
    lrcScrollView.showsHorizontalScrollIndicator = false
  }
  
}

// 做动画
extension QQDetailViewController: UIScrollViewDelegate {
  // 监听滚动视图的滚动, 做透明动画效果
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // 获取当前的移动量
    let x = scrollView.contentOffset.x
    // 计算移动的比例
    let ratio = 1 - x / scrollView.width
    foreImageView.alpha = ratio
    lrcLabel.alpha = ratio
    
  }
  
  //添加旋转动画
  func addRotationAnimation() {
    foreImageView.layer.removeAnimation(forKey: "rotation")
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.fromValue = 0
    animation.toValue = Double.pi * 2
    animation.duration = 30
    //后台进来不让移除
    animation.isRemovedOnCompletion = false
    animation.repeatCount = MAXFLOAT
    foreImageView.layer.add(animation, forKey: "rotation")
  }
  
  //暂停旋转动画
  func pauseRotationAnimation() {
    foreImageView.layer.pauseAnimate()
  }
  
  //继续旋转动画
  func resumeRotationAnimation() {
    foreImageView.layer.resumeAnimation()
  }
}

extension QQDetailViewController {
  //锁屏界面远程控制
  override func remoteControlReceived(with event: UIEvent?) {
    let type = event?.subtype
    switch type! {
    case .remoteControlPlay:
      print("播放")
      QQMusicOperationTool.shareInstance.playCurrentMusic()
    case .remoteControlPause:
      print("暂停")
      QQMusicOperationTool.shareInstance.pauseCurrentMusic()
    case .remoteControlNextTrack:
      print("下一首")
      QQMusicOperationTool.shareInstance.nextMusic()
    case .remoteControlPreviousTrack:
      print("上一首")
      QQMusicOperationTool.shareInstance.preMusic()
    default:
      print("错误")
    }
    setupOnce()
    
  }
  
  //摇一摇下一首
  override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
    QQMusicOperationTool.shareInstance.nextMusic()
    setupOnce()
  }
}
