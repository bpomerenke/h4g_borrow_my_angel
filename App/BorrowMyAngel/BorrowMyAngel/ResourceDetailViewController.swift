import UIKit

class ResourceDetailViewController: UIViewController {
    var resourceItem: ResourceItem? = nil
    @IBOutlet weak var resourceTitle: UILabel!
    @IBOutlet weak var phoneNumber: UITextView!
    @IBOutlet weak var urlTextView: UITextView!
    
    override func viewDidLoad() {
        resourceTitle.text = resourceItem?.title
        phoneNumber.text = resourceItem?.phone
        urlTextView.text = resourceItem?.url
    }
}
