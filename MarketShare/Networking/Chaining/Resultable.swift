protocol Resultable {
    
    associatedtype Output
    
    var result: Result<Output, Error> { get }
    
}
