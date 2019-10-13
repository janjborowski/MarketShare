protocol WorldBankPipelineOperationProvider {
    
    func apiFetcher() -> APIFetcher
    func mapWorldBankData() -> MapWorldBankData
    func createWorldBankSummary(asset: Asset) -> CreateWorldBankSummary
    
}

final class WorldBankPipelineOperationProviderDefault: WorldBankPipelineOperationProvider {

    private let cache: NetworkingCache
    
    init(cache: NetworkingCache) {
        self.cache = cache
    }
    
    func apiFetcher() -> APIFetcher {
        return APIFetcher(cache: cache)
    }
    
    func mapWorldBankData() -> MapWorldBankData {
        return MapWorldBankData()
    }
    
    func createWorldBankSummary(asset: Asset) -> CreateWorldBankSummary {
        return CreateWorldBankSummary(asset: asset)
    }
    
}
