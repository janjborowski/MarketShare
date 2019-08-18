import XCTest
import OHHTTPStubs
@testable import MarketShare

class APIFetcherTests: OperationTestCase {
    
    private let path = "http://someapi.com"
    private var sut: APIFetcher!

    override func setUp() {
        super.setUp()
        
        sut = APIFetcher(path: path)
    }

    override func tearDown() {
        sut = nil
        OHHTTPStubs.removeAllStubs()
        
        super.tearDown()
    }

    func test_ShouldDownloadData_WhenFinishedWithoutError() {
        let expectationToBeCalled = defaultExpectation

        stub(condition: isAbsoluteURLString(path)) { _ in
            let stubPath = OHPathForFile("worldbankresponse.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            XCTAssertNil(self.sut.error)
            XCTAssertNotNil(self.sut.data)
        }
        
        waitForExpectations()
    }
    
    func test_ShouldFinishWithAPIError_WhenPathIsWrong() {
        let expectationToBeCalled = defaultExpectation
        sut = APIFetcher(path: "")
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            
            XCTAssertNil(self.sut.data)
            XCTAssertEqual((self.sut.error as? APIError), APIError.wrongPath)
        }
        
        waitForExpectations()
    }
    
    func test_ShouldFinishWithError_WhenErrorIsPresent() {
        let expectationToBeCalled = defaultExpectation

        stub(condition: isAbsoluteURLString(path)) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return OHHTTPStubsResponse(error:notConnectedError)
        }
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            
            XCTAssertNil(self.sut.data)
            XCTAssertNotNil(self.sut.error)
        }
        
        waitForExpectations()
    }

}
