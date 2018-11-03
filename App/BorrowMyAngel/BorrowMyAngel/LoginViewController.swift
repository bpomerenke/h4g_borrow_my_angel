import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var userHandle: UITextField!
    @IBOutlet weak var typeSelector: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.layer.cornerRadius = 10
        typeSelector.backgroundColor = .clear
        typeSelector.tintColor = .clear
        
        typeSelector.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        typeSelector.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.underlineColor: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue
            ], for: .selected)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: MessagingViewController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: MessagingViewController.keyboardWillHideNotification, object: nil)

    }
    
    @IBAction func gotoCauseMomentum(_ sender: Any) {
        if let link = URL(string: "https://4agc.com/donation_pages/c9252832-caf3-4cf1-99eb-7450c0dc4699?gift_id=3fbcc69f-54aa-4581-b01b-93106c58b131") {
            UIApplication.shared.open(link)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        if self.typeSelector.selectedSegmentIndex == 0 {
            UserSession.sharedInstance.setHandle(handle: self.userHandle.text)
            self.performSegue(withIdentifier: "angelSegue", sender: self)
        } else {
            UserSession.sharedInstance.setHandle()
            self.performSegue(withIdentifier: "personInNeedSegue", sender: self)
        }
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
