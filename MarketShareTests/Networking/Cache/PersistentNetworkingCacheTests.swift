import XCTest
@testable import MarketShare

final class PersistentNetworkingCacheTests: XCTestCase {

    func testRetrieveData_ShouldReturnSavedResponse() {
        let url = URL(string: "https://market.share")!
        let request = URLRequest(url: url)
        let sampleText = "Cached string"
        let dataToCache = sampleText.data(using: .utf8)!
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: sampleText.count, textEncodingName: nil)
        let sut = PersistentNetworkingCache()
        sut.save(response: response, data: dataToCache, for: request)
        
        let retrievedData = sut.retrieveData(for: request)
        
        XCTAssertEqual(String(data: retrievedData!, encoding: .utf8), sampleText)
    }

}
