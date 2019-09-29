import Foundation

extension OperationQueue {
    
    func succeed<NextOp: Operation & Inputtable, PrevOp: Operation & Resultable>(operation successor: NextOp, after predecessor: PrevOp) where NextOp.Input == PrevOp.Output {
        var edittableSuccessor = successor
        let passThroughOperation = BlockOperation {
            edittableSuccessor.inputData = predecessor.result
        }
        
        successor.addDependency(passThroughOperation)
        passThroughOperation.addDependency(predecessor)
        
        addOperation(passThroughOperation)
    }
    
    func succeed<ResultableOperation: Resultable & Operation>(operation predecessor: ResultableOperation, with completionBlock: @escaping (ResultableOperation.Output?) -> ()) {
        let blockOperation = BlockOperation {
            completionBlock(try? predecessor.result.get())
        }
        
        blockOperation.addDependency(predecessor)
        
        addOperation(blockOperation)
    }
    
}
