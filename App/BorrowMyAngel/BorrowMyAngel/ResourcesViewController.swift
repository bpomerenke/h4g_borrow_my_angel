import UIKit

class ResourcesViewController: UIViewController {
    var filteredResults = [ResourceType]()
    var resourceResults = LocalResources.allLocalResources
    var selectedItem: ResourceItem?
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var resourcesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Resources"
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
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowResourceDetail" {
            guard let resourceDetailViewController = segue.destination as? ResourceDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = resourcesTableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = isFiltering() ? filteredResults[indexPath.section].resources[indexPath.row] : resourceResults[indexPath.section].resources[indexPath.row]
            resourceDetailViewController.resourceItem = selectedItem
        }
    }
}

extension ResourcesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var resourceItem: ResourceItem
        if isFiltering() {
            resourceItem = filteredResults[indexPath.section].resources[indexPath.row]
        } else {
            resourceItem = resourceResults[indexPath.section].resources[indexPath.row]
        }
    }
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
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
