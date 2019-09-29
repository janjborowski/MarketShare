import XCTest
import OHHTTPStubs
@testable import MarketShare

class APIFetcherTests: OperationTestCase {
    
    private final class NetworkingCacheMock: NetworkingCache {
        
        var retrievableData: Data?
        var saveWasCalled = false
        
        func retrieveData(for request: URLRequest) -> Data? {
            return retrievableData
        }
        
        func save(response: URLResponse, data: Data, for request: URLRequest) {
            saveWasCalled = true
        }
        
    }
    
    private let path = "http://someapi.com"
    
    private var networkingCache: NetworkingCacheMock!
    private var sut: APIFetcher!

    override func setUp() {
        super.setUp()
        
        networkingCache = NetworkingCacheMock()
        sut = APIFetcher(path: path, cache: networkingCache)
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
    
    func test_ShouldFinishWithAPIError_WhenPathIsWrong() {
        let expectationToBeCalled = defaultExpectation
        sut = APIFetcher(path: "", cache: networkingCache)
        
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
