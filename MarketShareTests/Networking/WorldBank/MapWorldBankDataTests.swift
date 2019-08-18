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
        sut.inputData = try? Data(contentsOf: URL(fileURLWithPath: path))
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            XCTAssertEqual(self.sut.worldBankResponse!.paging.perPage, 50)
            XCTAssertEqual(self.sut.worldBankResponse!.paging.sourceId, "2")
            XCTAssertEqual(self.sut.worldBankResponse!.entries.count, 14)
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
        sut.inputData = sampleString.data(using: .utf8)
        
        setUpBlockExpectation(sut: sut, blockOperationContent: {
            expectationToBeCalled.fulfill()
            XCTAssertNotNil(self.sut.error)
            XCTAssertNil(self.sut.worldBankResponse)
        })
        
        waitForExpectations()
    }
    
}
