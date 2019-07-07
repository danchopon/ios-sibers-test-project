//
//  VideoLauncher.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/6/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .black
    
    let urlString = ""
    
    if let url = URL(string: urlString) {
      let player = AVPlayer(url: url)
      
      let playerLayer = AVPlayerLayer(player: player)
      self.layer.addSublayer(playerLayer)
      playerLayer.frame = self.frame
      
      player.play()
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

class VideoLauncher: NSObject {
  
  func showVideoPlayer() {
    if let keyWindow = UIApplication.shared.keyWindow {
      let view = UIView(frame: keyWindow.frame)
      
      view.backgroundColor = .white
      
      view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
      
      let height = keyWindow.frame.height * 9/16
      let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
      let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
      view.addSubview(videoPlayerView)
      
      keyWindow.addSubview(view)
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        view.frame = keyWindow.frame
      }) { (completedAnimation) in
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
      }
    }
  }
  
}
