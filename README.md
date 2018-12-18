# SwiftyRestKit

A simple, protocol-oriented way, to simplify REST requests on iOS. 

This library is a mix of a few different ideas you might find in tutorials around the web, added together into a single, ready to use library.

## Installation

### Cocoapods

```ruby
pod 'SwiftyRestKit'
```

### Manually

This project has no dependencies, so, you can just download and add the swift files to your project if you want to.

## How to use it 

First create an enum for API, or for your endpoints if you have many different ones for the same API. We'll use TMDb's API and create requests for trending movies and search in this example.

```swift
enum TMDbAPI {
    case trendingMovies(page: Int)
    case searchMovies(searchTerm: String, page: Int)
}
```

Then, create an extension and adopt the EndPointType protocol.

```swift
extension TMDbAPI: EndPointType {

}
```

Now, let's conform to the protocol.

```swift
    extension TMDbAPI: EndPointType {
        var apiClientKey: String? {
            return "Your API Key"
        }
        
        var apiClientSecret: String? {
            return nil
        }
        
        var baseURLString : String {
            return "https://api.themoviedb.org/3/"
        }
        
        var baseURL: URL {
            guard let url = URL(string: baseURLString) else {
                fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
                case .trendingMovies:
                    return "trending/movie/day"
                
                case .searchMovies:
                    return "search/movie"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
                default:
                    return .get
            }
        }
        
        var task: HTTPTask {
            switch self {
                case .trendingMovies(let page):
                    let urlParameters: Parameters = ["language" : defaultLanguage, "api_key" : apiClientKey!, "page" : "\(page)"]
                    return .requestWith(bodyParameters: nil, urlParameters: urlParameters)
                
                case .searchMovies(let searchTerm, let page):
                    let urlParameters: Parameters = ["language" : defaultLanguage, "api_key" : apiClientKey!, "query" : searchTerm, "page" : "\(page)"]
                    return .requestWith(bodyParameters: nil, urlParameters: urlParameters)
            }
        }
        
        var headers: HTTPHeader? {
            switch self {
                
                default:
                    return nil
            }
        }
    }
```

So, what do we have here:
* apiClientKey and apiClientSecret: Depending on the API you are accessing, you may have to set one or both of these, if not, just return nil
* baseURLString and baseURL: Pretty self explanatory, just set them like in the example
* path: return the path for each case in your enum.
* httpMethod: return the method, there is support for .get, .post, .put, .patch and .delete
* task: set your url or body parameters and return:
    * .request (for no parameters)
    * .requestWith(bodyParameters: bodyParameters, urlParameters: urlParameters) in case you have either or both
    * .requestWithHeaders(bodyParameters: bodyParameters, urlParameters: urlParameters, additionalHeaders: headers) if you have something to pass on your header. Note that you should pass here the value "headers" from your headers variable.
* headers: Set any additional headers to be passed in each case or nil.

Your endpoint is ready, now, let's create a service. Create a struct for your service and extend it to adopt the Service protocol. Then, set your endpoint.

```swift
struct SearchService {

}

extension SearchService: Service {
    typealias EndPoint = TMDbAPI
}
```

Add another extension and conform to one or more of the following protocols: Gettable, Createable, Updateable and Deleteable. In this case, since we only have methods that get something, we'll only adopt Gettable.

```swift
    extension SearchService: Gettable { }
```

When you adopt the Service protocol and set its' EndPoint, you get a network manager, which itself has a dispatcher ready to perform requests from your endpoint. There is also a Result type that you can use to return an object if the request was successful, or a SwiftyRestKitError in case of failure. Here is what it looks like:

```swift
struct SearchService {
    
    func fetchTrendingMovies(page: Int, completion: @escaping (Result<MovieCollection>) -> Void) {
        manager.dispatcher.request(.trendingMovies(page: page)) { (data, response, error) in
            let result = self.processResult(data, response, error)
            completion(result)
        }
        
    }
    
    func searchMoviesByTitle(searchTerm: String, page: Int, completion: @escaping (Result<MovieCollection>) -> Void) {
        manager.dispatcher.request(.searchMovies(searchTerm: searchTerm, page: page)) { (data, response, error) in
            
            let result = self.processResult(data, response, error)
            completion(result)
            
        }
    }
    
    private func processResult(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<MovieCollection> {
        if let error = error {
            return Result.Failure(error)
        }
        
        guard let response = response as? HTTPURLResponse else {
            return Result.Failure(SwiftyRestKitError.decodingFailed)
        }
        
        let result = self.manager.handleNetworkResponse(response)
        
        switch result {
        case .Success:
            let decoder = JSONDecoder()
            guard let responseData = data, let movieCollection = try? decoder.decode(MovieCollection.self, from: responseData) else {
                return Result.Failure(InternalError.decodingError)
            }
            
            return Result.Success(movieCollection)
            
        case .Failure(let error):
            print(error.localizedDescription)
            return Result.Failure(SwiftyRestKitError.lostConnection)
        }
    }
    
}
```

Finally, in your view controller, create a method that injects the service as a dependency and fetch the data. 

```swift
class TrendingMoviesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTrendingMovies(fromService: SearchService())
    }

    func fetchTrendingMovies<S: Gettable>(fromService service: S) {
        guard let service = service as? SearchService else {
            return
        }
        
        service.fetchTrendingMovies(page: 1) { (result) in
            DispatchQueue.main.async { [unowned self] in
                switch result {
                    case .Success(let movieCollection):
                        // Show results

                    case .Failure(let error):
                        // Show alert for error
                }
            }
        }
    }

    ...

}
```