import Foundation

final class APIFetcher: AsynchronousOperation, Resultable {
    
    private let path: String
    private let cache: NetworkingCache
    
    private let session = URLSession.shared
    
    var headers = [String: String]()

    private(set) var result: Result<Data, Error> = .noResult()
    
    init(path: String, cache: NetworkingCache) {
        self.path = path
        self.cache = cache
        super.init()
    }
    
    override func main() {
        guard let url = URL(string: path) else {
            finish(with: APIError.wrongPath)
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        if let data = cache.retrieveData(for: request) {
            finish(with: data)
        } else {
            executeNetworkingTask(with: request)
        }
    }
    
    private func executeNetworkingTask(with request: URLRequest) {
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil else {
                self?.finish(with: error!)
                return
            }
            
            guard let response = response,
                let data = data else {
                self?.finish(with: APIError.noData)
                return
            }
            
            self?.cache.save(response: response, data: data, for: request)
            self?.finish(with: data)
        }
        task.resume()
    }
    
    private func finish(with error: Error) {
        result = .failure(error)
        finish()
    }
    
    private func finish(with data: Data) {
        result = .success(data)
        finish()
    }
    
}
