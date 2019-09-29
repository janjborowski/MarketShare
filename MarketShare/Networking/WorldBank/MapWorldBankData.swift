import Foundation

final class MapWorldBankData: Operation, Inputtable, Resultable {
    
    private let decoder = JSONDecoder()
    
    var inputData: Result<Data, Error>?

    private(set) var result: Result<WorldBankResponse, Error> = .noResult()

    override func main() {
        guard case let .success(inputData)? = inputData else {
            propagateError()
            return
        }
        
        do {
            let objects = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
            let paging = try mapPaging(object: objects?.first)
            let entries = try mapEntries(object: objects?.last)
            result = .success(WorldBankResponse(paging: paging, entries: entries))
        } catch let error {
            result = .failure(error)
        }
    }
    
    private func mapPaging(object: AnyObject?) throws -> WorldBankPaging {
        guard let dictionary = object as? NSDictionary else {
            throw APIError.parsingError
        }
        let rawObject = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions())
        return try decoder.decode(WorldBankPaging.self, from: rawObject)
    }
    
    private func mapEntries(object: AnyObject?) throws -> [WorldBankEntry] {
        guard let array = object as? NSArray else {
           throw APIError.parsingError
        }
        let rawObject = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions())
        return try decoder.decode([WorldBankEntry].self, from: rawObject)
    }
    
    private func propagateError() {
        guard case let .failure(error)? = inputData else {
            return
        }
        
        result = .failure(error)
    }
    
}
