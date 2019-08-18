import XCTest

extension XCTestCase {
    
    var defaultExpectation: XCTestExpectation {
        return expectation(description: "This should be called")
    }
    
    func waitForExpectations() {
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
}
