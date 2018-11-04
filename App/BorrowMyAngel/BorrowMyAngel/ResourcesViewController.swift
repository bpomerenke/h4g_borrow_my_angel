import UIKit

class ResourcesViewController: UIViewController {
    private var filteredResults = [ResourceType]()
    private var resourceResults = LocalResources.allLocalResources
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        
        fetchResources()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = resourcesTableView.indexPathForSelectedRow {
            resourcesTableView.deselectRow(at: index, animated: true)
        }
    }
    
    func fetchResources() {
        let todosUrl = URL(string: "https://arcane-citadel-61571.herokuapp.com/api/resources")!
        let todosUrlRequest = URLRequest(url: todosUrl)
        let session = URLSession.shared
        DispatchQueue.global().async {
            let task = session.dataTask(with: todosUrlRequest) {
                (data, response, error) in
                guard error == nil else {
                    print("error calling POST on /todos/1")
                    print(error!)
                    return
                }
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                // parse the result as JSON, since that's what the API provides
                do {
                    let apiResponse = String(data:responseData, encoding: .utf8)!
                    let wrappedApiResponse = "{ \"resources\": " + apiResponse + "}"
                    var serviceResources: [ResourceItem] = []
                    var contacts: [String] = []
                        let allContacts = try JSONSerialization.jsonObject(with: wrappedApiResponse.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : NSArray]
                    
                    if let arrJSON = allContacts["resources"] {
                        for index in 0...arrJSON.count-1 {
                            
                            let aObject = arrJSON[index] as! [String : AnyObject]

                            serviceResources.append(ResourceItem(title: aObject["name"] as! String, phone: aObject["phone"] as! String, zip: 11111, url: aObject["email"] as! String))
                        }
                    }
                    
                    self.resourceResults.append(ResourceType(name: "Recently Added", resources: serviceResources))
                    
                } catch  {
                    print("error parsing response from POST on /todos")
                    return
                }
            }
            
            task.resume()
            
        }
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String) {
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
                fatalError("Unexpected sender: \(sender ?? "")")
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
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.lightPink
        cell.selectedBackgroundView = bgColorView
        return cell
    }
}

extension ResourcesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
