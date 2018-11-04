import UIKit

class ConnectViewController: UIViewController {
    
    @IBOutlet weak var severitySlider: UISlider!
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var severityInput: UITextField!
    @IBOutlet weak var pickerInput: UIPickerView!
    @IBOutlet weak var issueLabel: UILabel!
    
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    
    var statusOptions: [String] = ["Available", "Unavailable", "Do Not Disturb"]
    
    var issueOptions: [String] = ["I'm feeling sad", "I'm having a rough day", "Physical Abuse", "Mental Abuse", "Substance Abuse", "I'm here to help someone else in need", "Other"]
    
    var pickerOptions: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerInput.delegate = self
        self.pickerInput.dataSource = self
        updateView()
    }
    func updateView(){
        let isAngel = UserSession.sharedInstance.isAngel()
        
        pickerOptions = isAngel ? statusOptions : issueOptions
        severitySlider.isHidden = isAngel
        severityLabel.isHidden = isAngel
        severityInput.isHidden = isAngel
        issueLabel.isHidden = isAngel
        methodLabel.isHidden = isAngel
        typeSegment.isHidden = isAngel
    }
    @IBAction func comeBack(unwindSegue: UIStoryboardSegue){
        print("did it...came back")
    }
    @IBAction func changeSeverity(_ sender: Any) {
        severityInput.text = String(Int(severitySlider.value*10.0))
    }
}

extension ConnectViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("picked: \(self.pickerOptions[row])")
    }
}
