import Foundation

protocol FetcherDispatcher {
    
    func download(asset: Asset, completion: @escaping (Summary?) -> Void)
    
}

final class FetcherDispatcherDefault: FetcherDispatcher {
    
    public typealias CryptoProvider = (OperationQueue, Asset) -> RunCryptoPipeline
    public typealias WorldBankProvider = (OperationQueue, Asset) -> RunWorldBankPipeline
    
    private let queue: OperationQueue
    
    private let createCryptoPipeline: CryptoProvider
    private let createWorldBankPipeline: WorldBankProvider
    
    init(queue: OperationQueue,
        createCryptoPipeline: @escaping CryptoProvider,
         createWorldBankPipeline: @escaping WorldBankProvider) {
        self.queue = queue
        self.createCryptoPipeline = createCryptoPipeline
        self.createWorldBankPipeline = createWorldBankPipeline
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
        let worldBankFetcher = createWorldBankPipeline(queue, asset)
        queue.succeed(operation: worldBankFetcher, with: completion)
        queue.addOperation(worldBankFetcher)
    }
    
    private func createCoinMarketCapPipeline(asset: Asset, completion: @escaping (Summary?) -> Void) {
        let cryptoPipeline = createCryptoPipeline(queue, asset)
        queue.succeed(operation: cryptoPipeline, with: completion)
        queue.addOperation(cryptoPipeline)
    }
    
}
