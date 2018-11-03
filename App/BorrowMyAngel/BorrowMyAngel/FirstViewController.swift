//
//  FirstViewController.swift
//  BorrowMyAngel
//
//  Created by Jordan McAdoo on 11/2/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectDescription: UILabel!
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var messageSend: UIButton!
    
    var timer = Timer()
    var progressVal = 00.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.messageInput.delegate = self
        self.progress.progress = 00.75
    }
    
    @IBAction func connectNow(_ sender: Any) {
        self.progress.isHidden = false
        self.connectionStatus.isHidden = false
        self.connectButton.isHidden = true
        self.connectDescription.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            self.progressVal += 1
            self.progress.progress = Float(self.progressVal / 100.0)
            
            if self.progressVal >= 100 {
                Timer   .invalidate()
                self.connectionStatus.text = "Found"
                self.showMessageView()
            }
        })
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let messageText = self.messageInput.text!
        self.messageView.text.append("\nme: \(messageText)")
        self.messageInput.text = ""
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (Timer) in
            
            self.messageView.text.append("\nangel: I hear you...how can I help?")
        })
    }
    
    func showMessageView()->Void{
        self.messageSend.isHidden = false
        self.messageView.isHidden = false
        self.messageInput.isHidden = false
        self.progress.isHidden = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageInput.resignFirstResponder()
        return true
    }
}


