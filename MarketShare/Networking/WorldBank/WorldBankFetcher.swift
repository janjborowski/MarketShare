import Foundation

protocol WorldBankFetcherProtocol {
    
    func download(asset: Asset, completion: @escaping (Summary?) -> Void)
    
}

final class WorldBankFetcher: WorldBankFetcherProtocol {
    
    private let path = "https://api.worldbank.org/v2/en/countries/all/indicator/CM.MKT.LCAP.CD?format=json&date=2018&per_page=300"
    private let queue = OperationQueue()
    
    private let cache: NetworkingCache
    
    init(cache: NetworkingCache) {
        self.cache = cache
        queue.qualityOfService = .userInitiated
    }
    
    func download(asset: Asset, completion: @escaping (Summary?) -> Void) {
        let apiFetcher = APIFetcher(path: path, cache: cache)
        let worldBankMapper = MapWorldBankData()
        let createWorldBankSummary = CreateWorldBankSummary(asset: asset)
        
        queue.succeed(operation: worldBankMapper, after: apiFetcher)
        queue.succeed(operation: createWorldBankSummary, after: worldBankMapper)
        queue.succeed(operation: createWorldBankSummary, with: completion)
        
        [apiFetcher, worldBankMapper, createWorldBankSummary].forEach { queue.addOperation($0) }
    }
    
}
