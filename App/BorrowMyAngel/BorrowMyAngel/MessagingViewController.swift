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
    }

    func processDummyMessagesOnTestChannel(){
        SBDMain.initWithApplicationId(sbdApplicationId)
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
}

extension MessagingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageInput.resignFirstResponder()
        return true
    }
}

