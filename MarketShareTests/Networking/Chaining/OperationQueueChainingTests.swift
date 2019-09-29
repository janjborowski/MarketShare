import XCTest
@testable import MarketShare

final class OperationQueueChainingTests: XCTestCase {

    private final class InputtableOperation: Operation, Inputtable {
        
        var inputData: Result<String, Error>?
        
    }
    
    private final class ResultableOperation: Operation, Resultable {
        
        var result: Result<String, Error> = .noResult()
        
    }
    
    private var sampleText = "Test"
    private var inputtableOperation: InputtableOperation!
    private var resultableOperation: ResultableOperation!
    private var sut: OperationQueue!
    
    override func setUp() {
        super.setUp()
        
        inputtableOperation = InputtableOperation()
        resultableOperation = ResultableOperation()
        resultableOperation.result = .success(sampleText)
        sut = OperationQueue.main
    }
    
    override func tearDown() {
        inputtableOperation = nil
        resultableOperation = nil
        sut = nil
        
        super.tearDown()
    }
    
    func testSucceedAfter_ShouldAddOperationWithDependency() {
        sut.succeed(operation: inputtableOperation, after: resultableOperation)
        let addedOperation = sut.operations.first!
        
        XCTAssertEqual(inputtableOperation.dependencies, [addedOperation])
        XCTAssertEqual(sut.operationCount, 1)
        XCTAssertEqual(addedOperation.dependencies, [resultableOperation])
    }
    
    func testSucceedAfter_ShouldPassDataWhenExecuted() {
        let expectationToFulfill = defaultExpectation
        let lastOperation = BlockOperation {
            XCTAssertEqual(try! self.inputtableOperation.inputData!.get(), self.sampleText)
            expectationToFulfill.fulfill()
        }
        lastOperation.addDependency(inputtableOperation)
        
        sut.succeed(operation: inputtableOperation, after: resultableOperation)
        [inputtableOperation, resultableOperation, lastOperation].forEach { sut.addOperation($0) }
        
        waitForExpectations()
    }
    
    func testSucceedWith_ShouldExecuteClosure() {
        let expectationToFulfill = defaultExpectation
        sut.succeed(operation: resultableOperation) { (output) in
            XCTAssertEqual(try! self.resultableOperation.result.get(), output)
            expectationToFulfill.fulfill()
        }
        
        sut.addOperation(resultableOperation)
        
        waitForExpectations()
    }

}
