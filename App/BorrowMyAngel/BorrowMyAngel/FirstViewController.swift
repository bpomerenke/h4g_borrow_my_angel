//
//  FirstViewController.swift
//  BorrowMyAngel
//
//  Created by Jordan McAdoo on 11/2/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectDescription: UILabel!
    
    var timer = Timer()
    var progressVal = 00.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.progress.progress = 00.75
    }
    
    @IBAction func connectNow(_ sender: Any) {
        self.progress.isHidden = false
        self.connectionStatus.isHidden = false
        self.connectButton.isHidden = true
        self.connectDescription.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (Timer) in
            self.progressVal += 1
            self.progress.progress = Float(self.progressVal / 100.0)
            
            if self.progressVal >= 100 {
                Timer   .invalidate()
                self.connectionStatus.text = "Found"
            }
        })
    }
}


