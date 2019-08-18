import Foundation

final class MapWorldBankData: Operation {
    
    private let decoder = JSONDecoder()
    
    var inputData: Data?

    private(set) var error: Error?
    private(set) var worldBankResponse: WorldBankResponse?

    override func main() {
        guard let inputData = inputData else {
            error = APIError.noData
            return
        }
        do {
            let objects = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
            let paging = try mapPaging(object: objects?.first)
            let entries = try mapEntries(object: objects?.last)
            worldBankResponse = WorldBankResponse(paging: paging, entries: entries)
        } catch let error {
            self.error = error
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
    
}
