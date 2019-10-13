import Foundation

final class RunWorldBankPipeline: AsynchronousOperation, Resultable {
    
    private let path = "https://api.worldbank.org/v2/en/countries/all/indicator/CM.MKT.LCAP.CD?format=json&date=2018&per_page=300"
    
    private let queue: OperationQueue
    private let operationProvider: WorldBankPipelineOperationProvider
    private let asset: Asset
    
    private(set) var result: Result<Summary, Error> = .noResult()
    
    init(queue: OperationQueue, operationProvider: WorldBankPipelineOperationProvider, asset: Asset) {
        self.queue = queue
        self.operationProvider = operationProvider
        self.asset = asset
    }
    
    override func main() {
        let apiFetcher = operationProvider.apiFetcher()
        apiFetcher.path = path
        let worldBankMapper = operationProvider.mapWorldBankData()
        let createWorldBankSummary = operationProvider.createWorldBankSummary(asset: asset)
        
        queue.succeed(operation: worldBankMapper, after: apiFetcher)
        queue.succeed(operation: createWorldBankSummary, after: worldBankMapper)
        queue.succeed(operation: createWorldBankSummary) { [weak self] _ in
            self?.result = createWorldBankSummary.result
            self?.finish()
        }
        
        [apiFetcher, worldBankMapper, createWorldBankSummary].forEach { queue.addOperation($0) }
    }
    
}
