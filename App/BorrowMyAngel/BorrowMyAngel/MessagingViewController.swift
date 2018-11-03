import UIKit
import SendBirdSDK

class MessagingViewController: UIViewController {
    
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var connectionStatus: UILabel!
    
    private var channel: SBDOpenChannel?
    private var sbdApplicationId = ProcessInfo.processInfo.environment["SENDBIRD_APP_ID"] ?? ""
    private var channelUrl = "test"
    private var timer = Timer()
    private var progressVal = 00.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        processDummyMessagesOnTestChannel()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: MessagingViewController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: MessagingViewController.keyboardWillHideNotification, object: nil)
        messageView.layoutManager.allowsNonContiguousLayout = false
        messageView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    func processDummyMessagesOnTestChannel(){
        SBDMain.initWithApplicationId(sbdApplicationId)
        SBDMain.add(self, identifier: "messagingVC")
        SBDMain.connect(withUserId: UserSession.sharedInstance.getHandle()) { (user, error) in
            guard error == nil else {    // Error.
                print(error?.description)
                return
            }
            //        SBDOpenChannel.createChannel { (channel, error) in
            SBDOpenChannel.getWithUrl(self.channelUrl) { (channel, error) in
                guard error == nil else {    // Error.
                    print(error?.description)
                    return
                }

                channel?.enter(completionHandler: { (error) in
                    guard error == nil else {    // Error.
                        print(error?.description)
                        return
                    }

                    let previousMessageQuery = channel?.createPreviousMessageListQuery()
                    previousMessageQuery?.loadPreviousMessages(withLimit: 200, reverse: false, completionHandler: { (messages, error) in
                        guard error == nil else {    // Error.
                            print(error?.description)
                            return
                        }

                        messages?.forEach { message in
                            self.addMessageToView(with:message)
                        }
                    })

                    self.channel = channel
                })
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var bottom = messageView.contentSize.height - messageView.frame.size.height
        if bottom < 0 {
            bottom = 0
        }
        if messageView.contentOffset.y != bottom {
            messageView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        }
    }

    func addMessageToView(with: SBDBaseMessage) {
        switch with {
        case let userMessage as SBDUserMessage:
            print(userMessage.message)
            messageView.text.append(contentsOf: "\n\(userMessage.sender!.userId): \(userMessage.message!)")
        default:
            print("Error")
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        let messageText = self.messageInput.text!
        self.messageView.text.append("\nme: \(messageText)")
        self.messageInput.text = ""
        self.channel?.sendUserMessage(messageText, data: "", customType: "", completionHandler: { (message, error) in
            guard error == nil else {    // Error.
                print(error?.description)
                return
            }            
        })
    }
    
    private func showMessageView()->Void{
        self.messageView.isHidden = false
        self.messageInput.isHidden = false
        self.progressBar.isHidden = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= (keyboardFrame.height + 10)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
}

extension MessagingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageInput.resignFirstResponder()
        return true
    }
}

extension MessagingViewController: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        addMessageToView(with: message)
    }
}

