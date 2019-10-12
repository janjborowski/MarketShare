protocol CryptoPipelineOperationProvider {
    
    func apiFetcher() -> APIFetcher
    func createCryptoSummary(asset: Asset) -> CreateCryptoSummary
    
}

final class CryptoPipelineOperationProviderDefault: CryptoPipelineOperationProvider {
    
    private let cache: NetworkingCache
    
    init(cache: NetworkingCache) {
        self.cache = cache
    }
    
    func apiFetcher() -> APIFetcher {
        return APIFetcher(cache: cache)
    }
    
    func createCryptoSummary(asset: Asset) -> CreateCryptoSummary {
        return CreateCryptoSummary(asset: asset)
    }
    
}
