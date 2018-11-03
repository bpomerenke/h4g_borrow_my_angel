//
//  FirstViewController.swift
//  BorrowMyAngel
//
//  Created by Jordan McAdoo on 11/2/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit
import SendBirdSDK

class MessagingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var connectionStatus: UILabel!
    
    var channel: SBDOpenChannel?
    
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
        self.processDummyMessagesOnTestChannel()
    }

    func processDummyMessagesOnTestChannel(){
        SBDMain.initWithApplicationId("secret here")
        SBDMain.connect(withUserId: "PERSON_IN_NEED") { (user, error) in
            guard error == nil else {    // Error.
                print(error?.description)
                return
            }
        }
        //        SBDOpenChannel.createChannel { (channel, error) in
        SBDOpenChannel.getWithUrl("test") { (channel, error) in
            guard error == nil else {    // Error.
                return
            }

            channel?.enter(completionHandler: { (error) in
                guard error == nil else {    // Error.
                    print(error?.description)
                    return
                }

                let previousMessageQuery = channel?.createPreviousMessageListQuery()
                previousMessageQuery?.loadPreviousMessages(withLimit: 30, reverse: true, completionHandler: { (messages, error) in
                    guard error == nil else {    // Error.
                        return
                    }

                    for message in messages! {
                        switch message {
                        case let userMessage as SBDUserMessage:
                            print(userMessage.message)
                            self.messageView.text.append(contentsOf: "\n\(userMessage.sender!.userId): \(userMessage.message!)")
                        default:
                            print("Error")
                        }
                    }
                })

                self.channel = channel
            })
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        let messageText = self.messageInput.text!
        self.messageView.text.append("\nme: \(messageText)")
        self.messageInput.text = ""
        self.channel?.sendUserMessage(messageText, data: "", customType: "", completionHandler: { (message, error) in
            guard error == nil else {    // Error.
                return
            }            
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


