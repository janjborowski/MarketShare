import Foundation

final class WorldBankFetcher: AsynchronousOperation, Resultable {
    
    private let path = "https://api.worldbank.org/v2/en/countries/all/indicator/CM.MKT.LCAP.CD?format=json&date=2018&per_page=300"
    private let queue = OperationQueue()
    
    private let cache: NetworkingCache
    private let asset: Asset
    
    private(set) var result: Result<Summary, Error> = .noResult()
    
    init(cache: NetworkingCache, asset: Asset) {
        self.cache = cache
        self.asset = asset
        queue.qualityOfService = .userInitiated
    }
    
    override func main() {
        let apiFetcher = APIFetcher(path: path, cache: cache)
        let worldBankMapper = MapWorldBankData()
        let createWorldBankSummary = CreateWorldBankSummary(asset: asset)
        
        queue.succeed(operation: worldBankMapper, after: apiFetcher)
        queue.succeed(operation: createWorldBankSummary, after: worldBankMapper)
        queue.succeed(operation: createWorldBankSummary) { [weak self] _ in
            self?.result = createWorldBankSummary.result
            self?.finish()
        }
        
        [apiFetcher, worldBankMapper, createWorldBankSummary].forEach { queue.addOperation($0) }
    }
    
}
