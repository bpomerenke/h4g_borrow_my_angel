import UIKit

class ConnectViewController: UIViewController {
   
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectDescription: UILabel!
    @IBOutlet weak var issuePicker: UIPickerView!
    
    var issueData: [String] = ["Depression", "I'm feeling sad", "I'm having a rough day", "Physical Abuse", "Mental Abuse", "Substance Abuse"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.issuePicker.delegate = self
        self.issuePicker.dataSource = self
     
    }
    
    @IBAction func comeBack(unwindSegue: UIStoryboardSegue){
        print("did it...came back")
    }
    
    @IBAction func connectNow(_ sender: Any) {

    }
}

extension ConnectViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return issueData[row]
    }
}

extension ConnectViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return issueData.count
    }
}
