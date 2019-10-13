import XCTest
@testable import MarketShare

class FetcherDispatcherDefaultTests: XCTestCase {
    
    private var queue: OperationQueue!
    private var sut: FetcherDispatcherDefault!
    
    private var cryptoProvider: FetcherDispatcherDefault.CryptoProvider!
    private var cryptoOperation: RunCryptoPipeline!
    private var worldBankProvider: FetcherDispatcherDefault.WorldBankProvider!
    private var worldBankOperation: RunWorldBankPipeline!

    override func setUp() {
        super.setUp()
        
        queue = OperationQueue()
        queue.isSuspended = true
        cryptoProvider = { (queue, asset) -> RunCryptoPipeline in
            self.cryptoOperation = RunCryptoPipeline(queue: queue, operationProvider: CryptoPipelineOperationProviderMock(), asset: asset)
            return self.cryptoOperation!
        }
        worldBankProvider = { (queue, asset) -> RunWorldBankPipeline in
            self.worldBankOperation = RunWorldBankPipeline(queue: queue, operationProvider: WorldBankPipelineOperationProviderMock(), asset: asset)
            return self.worldBankOperation!
        }
        sut = FetcherDispatcherDefault(queue: queue,
                                       createCryptoPipeline: cryptoProvider,
                                       createWorldBankPipeline: worldBankProvider)
    }

    override func tearDown() {
        queue = nil
        cryptoProvider = nil
        cryptoOperation = nil
        worldBankProvider = nil
        worldBankOperation = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_shouldAddRunCryptoPipeline_forCryptoAsset() {
        sut.download(asset: .crypto) { _ in }
        
        XCTAssertEqual(queue.operations.count, 2)
        XCTAssertTrue(queue.operations.contains(cryptoOperation))
        XCTAssertNotNil(cryptoOperation)
        XCTAssertEqual(cryptoOperation.dependencies.count, 0)
        XCTAssertNil(worldBankOperation)
    }
    
    func test_shouldAddRunWorldBankPipeline_forStocksAsset() {
        sut.download(asset: .globalStocks) { _ in }
        
        XCTAssertEqual(queue.operations.count, 2)
        XCTAssertTrue(queue.operations.contains(worldBankOperation))
        XCTAssertNotNil(worldBankOperation)
        XCTAssertEqual(worldBankOperation.dependencies.count, 0)
        XCTAssertNil(cryptoOperation)
    }

}
