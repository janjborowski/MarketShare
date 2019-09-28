import Foundation

final class PersistentNetworkingCache: NetworkingCache {
    
    private let urlCache = URLCache.shared
    
    func retrieveData(for request: URLRequest) -> Data? {
        return urlCache.cachedResponse(for: request)?.data
    }
    
    func save(response: URLResponse, data: Data, for request: URLRequest) {
        let cachedURLResponse = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedURLResponse, for: request)
    }
    
}
