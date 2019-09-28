import Foundation

protocol NetworkingCache {
    
    func retrieveData(for request: URLRequest) -> Data?
    
    func save(response: URLResponse, data: Data, for request: URLRequest)
    
}
