import XCTest

extension XCTestCase {
    
    var defaultExpectation: XCTestExpectation {
        return expectation(description: "This should be called")
    }
    
}
