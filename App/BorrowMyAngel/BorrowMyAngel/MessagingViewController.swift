//
//  FirstViewController.swift
//  BorrowMyAngel
//
//  Created by Jordan McAdoo on 11/2/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var connectionStatus: UILabel!
    
    
    var timer = Timer()
    var progressVal = 00.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.messageInput.delegate = self
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            self.progressVal += 1
            self.progressBar.progress = Float(self.progressVal / 100.0)
            
            if self.progressVal >= 100 {
                Timer   .invalidate()
                self.connectionStatus.text = "Connected"
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
        self.messageView.isHidden = false
        self.messageInput.isHidden = false
        self.progressBar.isHidden = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageInput.resignFirstResponder()
        return true
    }
}


