import Foundation

protocol FetcherDispatcher {
    
    func download(asset: Asset, completion: @escaping (Summary?) -> Void)
    
}

final class FetcherDispatcherDefault: FetcherDispatcher {
    
    private let queue = OperationQueue()
    private let cache: NetworkingCache
    
    init(cache: NetworkingCache) {
        self.cache = cache
        queue.qualityOfService = .userInitiated
    }
    
    func download(asset: Asset, completion: @escaping (Summary?) -> Void) {
        switch asset {
        case .globalStocks, .emergingMarketStocks, .frontierMarketStocks:
            createWorldBankPipeline(asset: asset, completion: completion)
        case .crypto, .cryptoNoBitcoin:
            createCoinMarketCapPipeline(asset: asset, completion: completion)
        }
    }
    
    private func createWorldBankPipeline(asset: Asset, completion: @escaping (Summary?) -> Void) {
        let worldBankFetcher = WorldBankFetcher(cache: cache, asset: asset)
        queue.succeed(operation: worldBankFetcher, with: completion)
        queue.addOperation(worldBankFetcher)
    }
    
    private func createCoinMarketCapPipeline(asset: Asset, completion: @escaping (Summary?) -> Void) {
        let cryptoPipeline = RunCryptoPipeline(cache: cache, asset: asset)
        queue.succeed(operation: cryptoPipeline, with: completion)
        queue.addOperation(cryptoPipeline)
    }
    
}
