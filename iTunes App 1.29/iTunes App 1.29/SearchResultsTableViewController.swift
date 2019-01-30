import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    @IBAction func screenChange(_ sender: Any) {
        tableView.reloadData()
        updateViews()
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchResultsController = SearchResultController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsController.searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "iTunesCell", for: indexPath)

            let text = searchResultsController.searchResults[indexPath.row]
                cell.textLabel?.text = text.title
                cell.detailTextLabel?.text = text.creator

            return cell
    }
    
    func updateViews() {
        
        guard let search = searchBar.text, search.count > 0 else { return }
        
        var resultType: ResultType!
        let index = segmentedControl.selectedSegmentIndex
        
        if index == 0 {
            resultType = .software
        } else if index == 1 {
            resultType = .musicTrack
        } else if index == 2 {
            resultType = .movie
        }
        
        searchResultsController.performSearch(searchTerm: search, resultType: resultType) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateViews()
    }

}
