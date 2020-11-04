//
//  ViewController.swift
//  music player
//
//  Created by Mac on 27/10/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var progressBar: UISlider!
    
    @IBOutlet weak var songDuration: UILabel!
    
    @IBOutlet weak var currentSongProgress: UILabel!
    
    @IBOutlet weak var play_pause_btn: UIButton!
    
    var currentState: PlayerState = .Stop
    var duration = 0.0
    
    private var sliderThumbWidth:CGFloat?
    private var bufferIndicator:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderThumbWidth = progressBar.thumbRect(forBounds: progressBar.bounds, trackRect: progressBar.trackRect(forBounds: progressBar.bounds), value: 0).size.width
        
        //bufferIndicator = UIView(frame: CGRect(x: stackView.frame.origin.x, y: stackView.frame.origin.y, width: 10, height: 30))
        bufferIndicator = UIView(frame: CGRect.zero)
        bufferIndicator?.backgroundColor = UIColor.lightGray
        guard let bufferView = bufferIndicator else{
            return
        }
        self.stackView.insertSubview(bufferView, belowSubview: progressBar)
        //self.view.addSubview(bufferView)
        //progressBar.addSubview(bufferView)
        
        MusicPlayer.sharedInstance.playerDelegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func togglePlayPause(_ sender: UIButton) {
        if currentState == .Stop {
            MusicPlayer.sharedInstance.setSong(url: "https://www.eclassical.com/custom/eclassical/files/BIS1447-002-flac_24.flac")
            MusicPlayer.sharedInstance.play()
        }
        else if currentState == .Pause {
            MusicPlayer.sharedInstance.play()
        }
        else if currentState == .Playing {
            MusicPlayer.sharedInstance.pause()
        }
    }
    @IBAction func seeking(_ sender: UISlider) {
        
        let second = Float((duration / 100)) * progressBar.value
        
        MusicPlayer.sharedInstance.seek(timeTo: Double(second))
    }
    
}

extension ViewController: PlayerDelegate {
    func updateBuffer(second: Double) {
        
        var frame = progressBar.frame
        
        guard let sliderThumbWidth = self.sliderThumbWidth else {
            return
        }
        
        
        let buffer = second / duration
        
        print("buffer: \(buffer)")
        
        let width = frame.size.width
        
        frame.origin.x = progressBar.frame.origin.x
        frame.size.width = CGFloat(buffer) * width
        
        let frameValue = frame
        
        bufferIndicator?.frame = frameValue
        
    }
    
    func updateProgresTime(time: Double) {
        
        let percentTime = (time / duration) * 100
        
        let minute = Int(time.truncatingRemainder(dividingBy: 3600) / 60)
        let second = Int((time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        var minuteString = "00"
        var secondString = "00"
        
        if minute < 10 {
            minuteString = "0\(minute)"
        } else {
            minuteString = "\(minute)"
        }
        
        if second < 10 {
            secondString = "0\(second)"
        } else {
            secondString = "\(second)"
        }
        
        currentSongProgress.text = "\(minuteString):\(secondString)"
        
        progressBar.value = Float(percentTime)
        
        print("percent: \(percentTime)")
        
        print("progress: \(minuteString):\(secondString)")
    }
    
    func updateDuration(time: Double) {
        duration = time
        
        let minute = Int(time.truncatingRemainder(dividingBy: 3600) / 60)
        let second = Int((time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        var minuteString = "00"
        var secondString = "00"
        
        if minute < 10 {
            minuteString = "0\(minute)"
        } else {
            minuteString = "\(minute)"
        }
        
        if second < 10 {
            secondString = "0\(second)"
        } else {
            secondString = "\(second)"
        }
        
        
        songDuration.text = "\(minuteString):\(secondString)"
        print("duration: \(Int(time.truncatingRemainder(dividingBy: 3600) / 60)):\(Int((time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)))")
    }
    
    func updateState(state: PlayerState) {
        currentState = state
        if state == .Playing {
            play_pause_btn.setTitle("Pause", for: .normal)
        }
        else if state == .Pause {
            play_pause_btn.setTitle("Play", for: .normal)
        }
    }
    
    
}
