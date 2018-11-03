import UIKit

class ResourceDetailViewController: UIViewController {
    @IBOutlet weak var resourceTitle: UILabel!
    var resourceItem: ResourceItem? = nil

    override func viewDidLoad() {
        resourceTitle.text = resourceItem?.title
    }
}
