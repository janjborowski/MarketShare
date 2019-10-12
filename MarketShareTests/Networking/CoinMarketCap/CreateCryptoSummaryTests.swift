import XCTest
@testable import MarketShare

final class CreateCryptoSummaryTests: OperationTestCase {
    
    private var sut: CreateCryptoSummary!
    
    override func setUp() {
        super.setUp()
        
        sut = CreateCryptoSummary(asset: .crypto)
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_ShouldDoNothing_WhenNoInputData() {
        let expectationToBeCalled = defaultExpectation
        sut.inputData = nil
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            XCTAssertNotNil(self.sut.result.error as? NoResult)
        })
        
        waitForExpectations()
    }
    
    func test_ShouldDoNothing_WhenInvalidInputData() {
        let expectationToBeCalled = defaultExpectation
        sut.inputData = .success(Data())
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            XCTAssertNotNil(self.sut.result.error as? NoResult)
        })
        
        waitForExpectations()
    }
    
    func test_ShouldCreateSummary_WhenDataIsValid() {
        let expectationToBeCalled = defaultExpectation
        sut.inputData = .success(.sample)
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            let summary = try! self.sut.result.get()
            XCTAssertEqual(summary.entries.count, 100)
            XCTAssertEqual(summary.entries.first!.name, "Bitcoin")
            XCTAssertTrue(summary.entries.first!.totalShare.diffCompare(0.68150000))
            XCTAssertEqual(summary.entries.first!.value, 150376378509.4489)
        })
        
        waitForExpectations()
    }
    
    func test_ShouldCreateSummaryWithoutBitcoin_WhenAssetTypeIsCryptoNoBitcoin() {
        let expectationToBeCalled = defaultExpectation
        sut = CreateCryptoSummary(asset: .cryptoNoBitcoin)
        sut.inputData = .success(.sample)
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            let summary = try! self.sut.result.get()
            XCTAssertEqual(summary.entries.count, 99)
            XCTAssertEqual(summary.entries.first!.name, "Ethereum")
            XCTAssertTrue(summary.entries.first!.totalShare.diffCompare(0.284436))
            XCTAssertEqual(summary.entries.first!.value, 19988229571.38424)
        })
        
        waitForExpectations()
    }

}

private extension Data {
    
    static var sample: Data {
        let testBundle = Bundle(for: CreateCryptoSummaryTests.self)
        let fileURL = testBundle.url(forResource: "coinmarketcapresponse", withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
        print(String(data: data, encoding: .utf8)!)
        return data
    }
    
}

private extension Decimal {
    
    func diffCompare(_ number: Decimal) -> Bool {
        return abs(self - number) < 0.0001
    }
    
}
