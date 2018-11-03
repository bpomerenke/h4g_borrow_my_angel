import UIKit

class AngelStatusViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var statusOptions: [String] = ["Available", "Unavailable", "Do Not Disturb"]

    @IBOutlet weak var StatusPicker: UIPickerView!
    @IBOutlet weak var acceptConnectionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.StatusPicker.delegate = self
        self.StatusPicker.dataSource = self
    }

    @IBAction func comeBack(unwindSegue: UIStoryboardSegue){
        print("did it...came back")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.statusOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.statusOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("picked: \(self.statusOptions[row])")
    }
}
