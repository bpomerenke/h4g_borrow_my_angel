import UIKit

class ResourcesViewController: UIViewController {
    struct ResourceType {
        var name: String
        var resources: [ResourceItem]
    }
    struct ResourceItem {
        var title: String
        var zip: Int
    }
    
    var filteredResults = [ResourceType]()
    var resourceResults = [ResourceType(name: "food",
                                        resources: [ResourceItem(title: "civil", zip: 65807),
                                                    
                                                    ResourceItem(title: "petes pizza", zip: 65807),
                                                    
                                                    ResourceItem(title: "waffle house", zip: 12345)]),
                           ResourceType(name: "housing", resources: [ResourceItem(title: "missouri hotel", zip: 65802)]),
                           ResourceType(name: "therapy", resources: [ResourceItem(title: "dr doe", zip: 65807),
                                                                     ResourceItem(title: "health services", zip: 00000)])]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var resourcesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resourcesTableView.delegate = self
        resourcesTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search By Zip"
        searchController.searchBar.keyboardType = .numberPad
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, we place the search bar in the table view's header.
            resourcesTableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredResults = resourceResults.compactMap { (resourceType: ResourceType) -> ResourceType? in
            let filteredResourceItems = resourceType.resources.filter {( resourceItem : ResourceItem) -> Bool in
                return String(resourceItem.zip).contains(searchText)
            }
            
            if filteredResourceItems.isEmpty {
                return nil
            }
            
            var filteredResourceType = resourceType
            filteredResourceType.resources = filteredResourceItems
            
            return filteredResourceType
        }
        
        resourcesTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ResourcesViewController: UITableViewDelegate {
}

extension ResourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredResults[section].resources.count
        }
        
        return resourceResults[section].resources.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return filteredResults.count
        }
        
        return resourceResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering() {
            return filteredResults[section].name
        }
        
        return resourceResults[section].name
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)
        let resourceItem: ResourceItem
        if isFiltering() {
            resourceItem = filteredResults[indexPath.section].resources[indexPath.row]
        } else {
            resourceItem = resourceResults[indexPath.section].resources[indexPath.row]
        }
        
        
        cell.textLabel?.text = resourceItem.title
        return cell
    }
}

extension ResourcesViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
