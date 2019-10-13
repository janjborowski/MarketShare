import XCTest
@testable import MarketShare

final class RunWorldBankPipelineTests: OperationTestCase {
    
    private var queue: OperationQueue!
    private var provider: WorldBankPipelineOperationProviderMock!

    override func setUp() {
        super.setUp()
        
        queue = OperationQueue()
        queue.isSuspended = true
        provider = WorldBankPipelineOperationProviderMock()
    }

    override func tearDown() {
        provider = nil
        queue = nil
        
        super.tearDown()
    }

    func test_main_shouldSetupOperationChain() {
        let asset = Asset.globalStocks
        let sut = RunWorldBankPipeline(queue: queue, operationProvider: provider, asset: asset)
        
        sut.main()
        
        XCTAssertEqual(queue.operations.count, 6)
        XCTAssertTrue(queue.operations.contains(provider.savedAPIFetcher))
        XCTAssertTrue(queue.operations.contains(provider.savedMapWorldBankData))
        XCTAssertTrue(queue.operations.contains(provider.savedCreateWorldBankSummary))
        XCTAssertEqual(provider.savedAPIFetcher.dependencies.count, 0)
        XCTAssertEqual(provider.savedMapWorldBankData.dependencies.count, 1)
        XCTAssertEqual(provider.savedCreateWorldBankSummary.dependencies.count, 1)
        XCTAssertEqual(provider.savedAsset, asset)
    }
    
    func test_main_shouldSetupAPIFetcher() {
        let sut = RunWorldBankPipeline(queue: queue, operationProvider: provider, asset: .globalStocks)
        
        sut.main()
        
        let apiFetcher = provider.savedAPIFetcher
        XCTAssertEqual(apiFetcher?.path, "https://api.worldbank.org/v2/en/countries/all/indicator/CM.MKT.LCAP.CD?format=json&date=2018&per_page=300")
        XCTAssertEqual(apiFetcher?.headers.count, 0)
    }

}
