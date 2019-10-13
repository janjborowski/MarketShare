@testable import MarketShare

final class CryptoPipelineOperationProviderMock: CryptoPipelineOperationProvider {
    
    var savedAPIFetcher: APIFetcher!
    var savedCreateCryptoSummary: CreateCryptoSummary!
    
    func apiFetcher() -> APIFetcher {
        savedAPIFetcher = APIFetcher(cache: NetworkingCacheMock())
        return savedAPIFetcher
    }
    
    func createCryptoSummary(asset: Asset) -> CreateCryptoSummary {
        savedCreateCryptoSummary = CreateCryptoSummary(asset: asset)
        return savedCreateCryptoSummary
    }
    
}
