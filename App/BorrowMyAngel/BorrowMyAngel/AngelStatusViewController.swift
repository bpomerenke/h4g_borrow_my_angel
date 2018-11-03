//
//  AngelStatusViewController.swift
//  BorrowMyAngel
//
//  Created by James O Gillenwaters on 11/2/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class AngelStatusViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var statusOptions: [String] = ["Available", "Unavailable", "Do Not Disturb"]
    

    @IBOutlet weak var StatusPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StatusPicker.delegate = self
        self.StatusPicker.dataSource = self
        print("on this view")
        // Do any additional setup after loading the view.
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
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
