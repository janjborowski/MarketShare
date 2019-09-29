import XCTest
import OHHTTPStubs
@testable import MarketShare

final class MapWorldBankDataTests: OperationTestCase {
    
    private var sut: MapWorldBankData!

    override func setUp() {
        super.setUp()
        
        sut = MapWorldBankData()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func test_ShouldMapWorldBankData() {
        let expectationToBeCalled = defaultExpectation
        let path = OHPathForFile("worldbankresponse.json", type(of: self))!
        let rawData = try! Data(contentsOf: URL(fileURLWithPath: path))
        sut.inputData = .success(rawData)
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            let worldBankResponse = try! self.sut.result.get()
            XCTAssertEqual(worldBankResponse.paging.perPage, 50)
            XCTAssertEqual(worldBankResponse.paging.sourceId, "2")
            XCTAssertEqual(worldBankResponse.entries.count, 14)
        })
        
        waitForExpectations()
    }
    
    func test_ShouldNotMapWorldBankData_WhenDataIsNotArray() {
        let sampleString = """
        {"id": 1}
        """
        executeParsingFailure(with: sampleString)
    }
    
    func test_ShouldNotMapWorldBankData_WhenFirstElementIsNotDictionary() {
        let sampleString = """
        [[{"id": 1}], {"value": "test"}]
        """
        executeParsingFailure(with: sampleString)
    }
    
    func test_ShouldNotMapWorldBankData_WhenFirstElementNotMatchWorldBankPaging() {
        let sampleString = """
        [{"id": 1}, {"value": "test"}]
        """
        executeParsingFailure(with: sampleString)
    }
    
    func test_ShouldNotMapWorldBankData_WhenLastElementIsNotArray() {
        let sampleString = """
        [
            {
                "lastupdated": "2019-07-10",
                "page": 6,
                "pages": 6,
                "per_page": 50,
                "sourceid": "2",
                "total": 264
            },
            {"value": "test"}
        ]
        """
        executeParsingFailure(with: sampleString)
    }
    
    func test_ShouldNotMapWorldBankData_WhenLastElementNotMatchWorldBankEntryArray() {
        let sampleString = """
        [
            {
                "lastupdated": "2019-07-10",
                "page": 6,
                "pages": 6,
                "per_page": 50,
                "sourceid": "2",
                "total": 264
            },
            [
                {"value": "test"}
            ]
        ]
        """
        executeParsingFailure(with: sampleString)
    }
    
    private func executeParsingFailure(with sampleString: String) {
        let expectationToBeCalled = defaultExpectation
        let sampleStringData = sampleString.data(using: .utf8)!
        sut.inputData = .success(sampleStringData)
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            XCTAssertNotNil(self.sut.result.error)
        })
        
        waitForExpectations()
    }
    
}
