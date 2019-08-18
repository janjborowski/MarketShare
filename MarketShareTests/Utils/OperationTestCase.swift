import XCTest

class OperationTestCase: XCTestCase {
    
    private var queue: OperationQueue!
    
    override func setUp() {
        super.setUp()
        
        queue = OperationQueue.main
    }
    
    override func tearDown() {
        queue = nil
        
        super.tearDown()
    }
    
    func setUpBlockExpectation(sut: Operation, blockOperationContent: @escaping () -> Void) {
        let blockOperation = BlockOperation(block: blockOperationContent)
        
        blockOperation.addDependency(sut)
        queue.addOperation(blockOperation)
        queue.addOperation(sut)
    }
    
}

