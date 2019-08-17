import XCTest
import OHHTTPStubs
@testable import MarketShare

class APIFetcherTests: XCTestCase {
    
    private let path = "http://someapi.com"
    private var queue: OperationQueue!
    private var sut: APIFetcher!

    override func setUp() {
        super.setUp()
        
        queue = OperationQueue()
        sut = APIFetcher(path: path)
    }

    override func tearDown() {
        queue = nil
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
        
        setUpBlockExpectation {
            expectationToBeCalled.fulfill()
            XCTAssertNil(self.sut.error)
            XCTAssertNotNil(self.sut.data)
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_ShouldFinishWithAPIError_WhenPathIsWrong() {
        let expectationToBeCalled = defaultExpectation
        sut = APIFetcher(path: "")
        
        setUpBlockExpectation {
            expectationToBeCalled.fulfill()
            
            XCTAssertNil(self.sut.data)
            XCTAssertEqual((self.sut.error as? APIError), APIError.wrongPath)
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_ShouldFinishWithError_WhenErrorIsPresent() {
        let expectationToBeCalled = defaultExpectation

        stub(condition: isAbsoluteURLString(path)) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return OHHTTPStubsResponse(error:notConnectedError)
        }
        
        setUpBlockExpectation {
            expectationToBeCalled.fulfill()
            
            XCTAssertNil(self.sut.data)
            XCTAssertNotNil(self.sut.error)
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    private func setUpBlockExpectation(blockOperationContent:@escaping () -> Void) {
        let blockOperation = BlockOperation(block: blockOperationContent)
        
        blockOperation.addDependency(sut)
        queue.addOperation(blockOperation)
        queue.addOperation(sut)
    }

}
