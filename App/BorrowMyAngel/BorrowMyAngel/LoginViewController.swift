import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var userHandle: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var typeSelector: UISegmentedControl!
    @IBOutlet weak var signinButton: UIButton!
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

        userHandle.delegate = self
        userPassword.delegate = self

        userHandle.tag = 0
        userPassword.tag = 1
        signinButton.isEnabled = false
    }
    
    @IBAction func handleEntered(_ sender: Any) {
        signinButton.isEnabled = true
    }
    @IBAction func signIn(_ sender: Any) {
        if self.typeSelector.selectedSegmentIndex == 0 {
            UserSession.sharedInstance.setHandle(handle: self.userHandle.text)
        } else {
            UserSession.sharedInstance.setHandle()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userHandle.resignFirstResponder()
        userPassword.resignFirstResponder()

        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            return true
        }
        // Do not add a line break
        return false
    }
}
