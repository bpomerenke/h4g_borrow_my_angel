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
    private var channelUrl = ""
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
        registerUser()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (Timer) in
            self.progressVal += 1
            self.progressBar.progress = Float(self.progressVal / 100.0)
            
            if self.progressVal >= 100 {
                Timer   .invalidate()
                self.channelUrl = UserSession.sharedInstance.getRoomUrl()
                self.connectionStatus.text = "Connected"
                self.showMessageView()
                self.processDummyMessagesOnTestChannel()
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: MessagingViewController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: MessagingViewController.keyboardWillHideNotification, object: nil)
    }

    func registerUser(){
        SBDMain.initWithApplicationId(sbdApplicationId)
        SBDMain.add(self, identifier: "messagingVC")
        SBDMain.connect(withUserId: UserSession.sharedInstance.getHandle()) { (user, error) in
            guard error == nil else {
                print("error connecting: \(String(describing: error?.description))")
                return
            }

            UserSession.sharedInstance.setSBDUser(user: SBDMain.getCurrentUser())
        }
    }

    func processDummyMessagesOnTestChannel(){
        SBDOpenChannel.getWithUrl(self.channelUrl) { (channel, error) in
            guard error == nil else {
                print("error getting channel with DummyMessages url: \(String(describing: error?.description))")
                return
            }

            channel?.enter(completionHandler: { (error) in
                guard error == nil else {
                    print("error entering channel: \(String(describing: error?.description))")
                    return
                }

                let previousMessageQuery = channel?.createPreviousMessageListQuery()
                previousMessageQuery?.loadPreviousMessages(withLimit: 0, reverse: false, completionHandler: { (messages, error) in
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

    func addMessageToView(with: SBDBaseMessage) {
        switch with {
        case let userMessage as SBDUserMessage:
            //todo: sender is angel if the sender is your angel
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
        let type = UserSession.sharedInstance.isAngel() ? "messageCellViewAngel" : "messageCellViewPerson"
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

