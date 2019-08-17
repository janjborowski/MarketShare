import Foundation

final class APIFetcher: AsynchronousOperation {
    
    private let path: String
    private let session = URLSession.shared
    
    private(set) var data: Data?
    private(set) var error: Error?
    
    init(path: String) {
        self.path = path
        super.init()
    }
    
    override func main() {
        guard let url = URL(string: path) else {
            finish(with: APIError.wrongPath)
            return
        }
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil else {
                self?.finish(with: error!)
                return
            }
            
            guard let data = data else {
                self?.finish(with: APIError.noData)
                return
            }
            
            self?.finish(with: data)
//            self?.result = .success(data)
//            guard let deserialized = try? JSONDecoder().decode(T.self, from: data) else {
//                self?.result = .failure(APIError.parsingError)
//                return
//            }
//
//            self?.result = .success(deserialized)
//            self?.finish()
        }
        task.resume()
    }
    
    private func finish(with error: Error) {
        self.error = error
        finish()
    }
    
    private func finish(with data: Data) {
        self.data = data
        finish()
    }
    
}
