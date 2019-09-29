protocol Inputtable {
    
    associatedtype Input
    
    var inputData: Result<Input, Error>? { get set }
    
}
