import Foundation

class SearchResultsController {
    
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    var searchResults: [SearchResult] = []
    
    static let shared = SearchResultsController()
    
    typealias completetionHandler = (Error?) -> Void
    
    init() {
        
    }
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping completetionHandler ) {
        
        var urlComplonents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchQueryItems = URLQueryItem(name: "term", value: searchTerm)
        let resultTypeQueryItem = URLQueryItem(name: "entity", value: resultType.rawValue)
        urlComplonents?.queryItems = [searchQueryItems, resultTypeQueryItem]
        
        guard let request = urlComplonents?.url else {
            NSLog("Bad URL request")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Couldn'tload JSON: \(error)")
                completion(NSError())
            }
            
            guard let data = data else {
                NSLog("No data found.")
                completion(NSError())
                return
            }
            
            do {
                let searchResults = try JSONDecoder().decode(ResultsList.self, from: data)
                self.searchResults = searchResults.results
                completion(NSError())
            } catch {
                NSLog("unable to decode JSON.")
                completion(NSError())
            }
        } .resume()
        
    }
    
}
