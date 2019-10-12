import XCTest
@testable import MarketShare

class RunCryptoPipelineTests: XCTestCase {
    
    private final class CryptoPipelineOperationProviderMock: CryptoPipelineOperationProvider {
        
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
    
    private var operationQueue: OperationQueue!
    private var provider: CryptoPipelineOperationProviderMock!
    private var sut: RunCryptoPipeline!

    override func setUp() {
        super.setUp()
        
        operationQueue = OperationQueue()
        operationQueue.isSuspended = true
        provider = CryptoPipelineOperationProviderMock()
        sut = RunCryptoPipeline(queue: operationQueue, operationProvider: provider, asset: .crypto)
    }

    override func tearDown() {
        operationQueue = nil
        provider = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_main_shouldSetupOperationChain() {
        sut.main()
        
        XCTAssertEqual(operationQueue.operations.count, 4)
        XCTAssertTrue(operationQueue.operations.contains(provider.savedAPIFetcher))
        XCTAssertTrue(operationQueue.operations.contains(provider.savedCreateCryptoSummary))
        XCTAssertEqual(provider.savedAPIFetcher.dependencies.count, 0)
        XCTAssertEqual(provider.savedCreateCryptoSummary.dependencies.count, 1)
    }
    
    func test_main_shouldSetupAPIFetcher() {
        sut.main()
        
        let apiFetcher = provider.savedAPIFetcher
        XCTAssertEqual(apiFetcher?.path, "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?limit=100&convert=USD")
        XCTAssertNotNil(apiFetcher?.headers)
    }

}
