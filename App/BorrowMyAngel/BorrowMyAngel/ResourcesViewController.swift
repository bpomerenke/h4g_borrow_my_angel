import UIKit

class ResourcesViewController: UIViewController {
    
    struct resourceType {
        var name: String
        var resources: [resouceItem]
    }
    struct resouceItem {
        var title: String
    }
    
    var resourceResults: [resourceType] = []
    var resultsB: [resourceType] = [resourceType(name: "food", resources: [resouceItem(title: "mcdonalds"),
                                                                           resouceItem(title: "kitchen"),
                                                                           resouceItem(title: "pizza hut")]),
                                    resourceType(name: "clothing", resources: [resouceItem(title: "good will")]),
                                    resourceType(name: "financial", resources: [resouceItem(title: "bank of america"),
                                                                              resouceItem(title: "commerce bank")])]
    
    var resultsA: [resourceType] = [resourceType(name: "food", resources: [resouceItem(title: "civil"),
                                                                                  resouceItem(title: "petes pizza"),
                                                                                  resouceItem(title: "waffle house")]),
                                           resourceType(name: "housing", resources: [resouceItem(title: "missouri hotel")]),
                                           resourceType(name: "therapy", resources: [resouceItem(title: "dr doe"),
                                                                                     resouceItem(title: "health services")])]

    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var searchResults: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults.delegate = self
        self.searchResults.dataSource = self
        self.searchInput.delegate = self
    }

    @IBAction func search(_ sender: Any) {
        searchInput.resignFirstResponder()
        let searchTerm = self.searchInput.text!
        
        resourceResults = []
        if searchTerm == "a"{
            resourceResults = resultsA
        }
        if searchTerm == "b"{
            resourceResults = resultsB
        }
        
        if resourceResults.count == 0 {
            self.searchResults.isHidden = true
            self.noResultsLabel.text = "No Results"
            self.noResultsLabel.isHidden = false
        } else {
            self.searchResults.isHidden = false
            self.noResultsLabel.isHidden = true
        }
        
        self.searchResults.reloadData()
    }
}

extension ResourcesViewController: UITableViewDelegate {
}

extension ResourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceResults[section].resources.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return resourceResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return resourceResults[section].name
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)
        
        cell.textLabel?.text = resourceResults[indexPath.section].resources[indexPath.row].title
        return cell
    }
}

extension ResourcesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchInput.resignFirstResponder()
        return true
    }
}
