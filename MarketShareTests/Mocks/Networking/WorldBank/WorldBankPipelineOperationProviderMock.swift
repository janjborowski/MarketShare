@testable import MarketShare

final class WorldBankPipelineOperationProviderMock: WorldBankPipelineOperationProvider {
    
    var savedAPIFetcher: APIFetcher!
    var savedMapWorldBankData: MapWorldBankData!
    var savedCreateWorldBankSummary: CreateWorldBankSummary!
    
    var savedAsset: Asset!
    
    func apiFetcher() -> APIFetcher {
        savedAPIFetcher = APIFetcher(cache: NetworkingCacheMock())
        return savedAPIFetcher
    }
    
    func mapWorldBankData() -> MapWorldBankData {
        savedMapWorldBankData = MapWorldBankData()
        return savedMapWorldBankData
    }
    
    func createWorldBankSummary(asset: Asset) -> CreateWorldBankSummary {
        savedAsset = asset
        savedCreateWorldBankSummary = CreateWorldBankSummary(asset: asset)
        return savedCreateWorldBankSummary
    }
    
}
