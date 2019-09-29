extension Result {
    
    var error: Error? {
        guard case let .failure(error) = self else {
            return nil
        }
        
        return error
    }
    
}
