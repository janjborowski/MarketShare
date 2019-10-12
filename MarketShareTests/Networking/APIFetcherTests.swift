import XCTest
import OHHTTPStubs
@testable import MarketShare

class APIFetcherTests: OperationTestCase {
    
    private let path = "http://someapi.com"
    
    private var networkingCache: NetworkingCacheMock!
    private var sut: APIFetcher!

    override func setUp() {
        super.setUp()
        
        networkingCache = NetworkingCacheMock()
        sut = APIFetcher(cache: networkingCache)
        sut.path = path
    }

    override func tearDown() {
        networkingCache = nil
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
            XCTAssertNotNil(try! self.sut.result.get())
        }
        
        waitForExpectations()
    }

    func test_ShouldPassHeaders() {
        let expectationToBeCalled = defaultExpectation
        let customHeaderKey = "headerKey"
        let customHeaderValue = "headerValue"
        sut.headers = [customHeaderKey: customHeaderValue]

        stub(condition: isAbsoluteURLString(path) && hasHeaderNamed(customHeaderKey, value: customHeaderValue)) { response in
            let stubPath = OHPathForFile("worldbankresponse.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            XCTAssertNotNil(try! self.sut.result.get())
        }
        
        waitForExpectations()
    }
    
    func test_ShouldFinishWithAPIError_WhenPathIsWrong() {
        let expectationToBeCalled = defaultExpectation
        sut = APIFetcher(cache: networkingCache)
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            
            XCTAssertEqual((self.sut.result.error as? APIError), APIError.wrongPath)
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
            
            XCTAssertNotNil(self.sut.result.error)
        }
        
        waitForExpectations()
    }
    
    func test_ShouldGetDataFromCache_WhenDataIsCached() {
        let expectationToBeCalled = defaultExpectation
        networkingCache.retrievableData = Data()
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            
            XCTAssertNotNil(try! self.sut.result.get())
        }
        
        waitForExpectations()
    }
    
    func test_ShouldSaveDataInCache_WhenFinishedWithoutError() {
        let expectationToBeCalled = defaultExpectation
        
        stub(condition: isAbsoluteURLString(path)) { _ in
            let stubPath = OHPathForFile("worldbankresponse.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            
            XCTAssertTrue(self.networkingCache.saveWasCalled)
        }
        
        waitForExpectations()
    }

}
