extension Result {
    
    static func noResult<T>() -> Result<T, Error> {
        return Result<T, Error>.failure(NoResult())
    }
    
}

struct NoResult: Error {}
