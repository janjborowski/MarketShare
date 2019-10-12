import Foundation

final class RunCryptoPipeline: AsynchronousOperation, Resultable {
    
    private let queue: OperationQueue
    private let operationProvider: CryptoPipelineOperationProvider
    private let asset: Asset
    
    private(set) var result: Result<Summary, Error> = .noResult()
    
    init(queue: OperationQueue, operationProvider: CryptoPipelineOperationProvider, asset: Asset) {
        self.queue = queue
        self.asset = asset
        self.operationProvider = operationProvider
    }
    
    override func main() {
        let apiFetcher = createAPIFetcher()
        let cryptoSummary = operationProvider.createCryptoSummary(asset: asset)
        
        queue.succeed(operation: cryptoSummary, after: apiFetcher)
        queue.succeed(operation: cryptoSummary) { [weak self] _ in
            self?.result = cryptoSummary.result
            self?.finish()
        }
        
        [apiFetcher, cryptoSummary].forEach { queue.addOperation($0) }
    }
    
    private func createAPIFetcher() -> APIFetcher {
        let apiFetcher = operationProvider.apiFetcher()
        apiFetcher.path = createAPIPath()
        apiFetcher.headers = createAPIHeaders()
        return apiFetcher
    }
    
    private func createAPIPath() -> String? {
        let path = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
        let urlComponents = NSURLComponents(string: path)!
        urlComponents.queryItems = [URLQueryItem(name: "limit", value: "100"), URLQueryItem(name: "convert", value: "USD")]
        return urlComponents.url?.absoluteString
    }
    
    private func createAPIHeaders() -> [String: String] {
        return [
            "X-CMC_PRO_API_KEY": "dcd6b420-1044-45a6-baa6-b4e1f26934ba",
            "Accept": "application/json"
        ]
    }
    
}
