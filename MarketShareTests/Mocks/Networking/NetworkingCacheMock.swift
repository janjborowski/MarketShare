import Foundation
@testable import MarketShare

final class NetworkingCacheMock: NetworkingCache {
    
    var retrievableData: Data?
    var saveWasCalled = false
    
    func retrieveData(for request: URLRequest) -> Data? {
        return retrievableData
    }
    
    func save(response: URLResponse, data: Data, for request: URLRequest) {
        saveWasCalled = true
    }
    
}
