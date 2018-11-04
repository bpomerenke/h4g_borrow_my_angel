import UIKit
import SendBirdSDK

class MessagingViewController: UIViewController {
    
    
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    
    private var channel: SBDOpenChannel?
    private var sbdApplicationId = ProcessInfo.processInfo.environment["SENDBIRD_APP_ID"] ?? ""
    private var channelUrl = "test"
    private var timer = Timer()
    private var progressVal = 00.0
    
    
    struct MessageItem {
        var sender: String
        var text: String
    }
    var messages: [MessageItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        self.messageTableView.layer.cornerRadius = 10
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
    }

    func processDummyMessagesOnTestChannel(){
        SBDMain.initWithApplicationId(sbdApplicationId)
        SBDMain.add(self, identifier: "messagingVC")
        SBDMain.connect(withUserId: UserSession.sharedInstance.getHandle()) { (user, error) in
            guard error == nil else {
                print("error connecting: \(String(describing: error?.description))")
                return
            }

            UserSession.sharedInstance.setSBDUser(user: SBDMain.getCurrentUser())

            SBDOpenChannel.getWithUrl(self.channelUrl) { (channel, error) in
                guard error == nil else {
                    print("error getting channel with url: \(String(describing: error?.description))")
                    return
                }

                channel?.enter(completionHandler: { (error) in
                    guard error == nil else {
                        print("error entering channel: \(String(describing: error?.description))")
                        return
                    }

                    let previousMessageQuery = channel?.createPreviousMessageListQuery()
                    previousMessageQuery?.loadPreviousMessages(withLimit: 200, reverse: false, completionHandler: { (messages, error) in
                        guard error == nil else {
                            print("error loading previous messages: \(String(describing: error?.description))")
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
    
    func addMessageToView(with: SBDBaseMessage) {
        switch with {
        case let userMessage as SBDUserMessage:
            print("error adding message: \(String(describing: userMessage.message))")
            let messageSender = UserSession.sharedInstance.getHandle() == userMessage.sender!.userId ? "you" : UserSession.sharedInstance.isAngel() ? "PIN" : userMessage.sender!.userId
            
            messages.append(MessageItem(sender: messageSender, text: userMessage.message!))
            self.messageTableView.reloadData()
            self.messageTableView.scrollToRow(at: IndexPath(item:messages.count-1, section: 0), at: .bottom, animated: true)
        default:
            print("Error")
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        let messageText = messageInput.text!
        messageInput.text = ""
        self.channel?.sendUserMessage(messageText, data: "", customType: "", completionHandler: { (message, error) in
            guard error == nil else {
                print("error sending message: \(String(describing: error?.description))")
                return
            }
            
            self.messages.append(MessageItem(sender: "you", text: messageText))
            self.messageTableView.reloadData()
            self.messageTableView.scrollToRow(at: IndexPath(item:self.messages.count-1, section: 0), at: .bottom, animated: true)
        })
    }
    
    private func showMessageView()->Void{
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

extension MessagingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = messages[indexPath.row].sender == "you" ? "messageCellViewPerson" : "messageCellViewAngel"
        let cell = tableView.dequeueReusableCell(withIdentifier: type) as! MessageTableViewCell
        
        cell.messageText.text = messages[indexPath.row].text
        cell.messageText.layer.cornerRadius = 15
        cell.messageText.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let calculatedMax = (CGFloat(messages[indexPath.row].text.count / 20) + 1) * 20
        return calculatedMax > 60 ? calculatedMax : 60
    }
}

