import UIKit

class ConnectViewController: UIViewController {
    
    @IBOutlet weak var severitySlider: UISlider!
    @IBOutlet weak var severityInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    @IBAction func comeBack(unwindSegue: UIStoryboardSegue){
        print("did it...came back")
    }
    @IBAction func changeSeverity(_ sender: Any) {
        severityInput.text = String(Int(severitySlider.value*10.0))
    }
}
