import Foundation

final class CreateWorldBankSummary: Operation {

    var inputData: Result<WorldBankResponse, Error>?
    
    private(set) var result: Result<Summary, Error> = .noResult()
    
    override func main() {
        guard case let .success(inputData)? = inputData else {
            propagateError()
            return
        }
        
        let countries = inputData.entries.filter { $0.countryISO3Code.count > 0 }
        
        let totalSum = countries
            .compactMap { Decimal($0.value ?? 0) }
            .reduce(Decimal(0), +)
        
        let summaryEntries = countries.map { worldBankEntry -> SummaryEntry in
                let value = Decimal(worldBankEntry.value ?? 0)
                let totalShare = value / totalSum
                return SummaryEntry(name: worldBankEntry.country.name, value: value, totalShare: totalShare)
            }
            .filter { $0.totalShare > 0 }
            .sorted { (entry1, entry2) -> Bool in
                return entry1.totalShare > entry2.totalShare
            }
        
        let summaryName = countries.first?.indicator.name ?? ""
        result = .success(Summary(name: summaryName, entries: summaryEntries))
    }
    
    private func propagateError() {
        guard case let .failure(error)? = inputData else {
            return
        }
        
        result = .failure(error)
    }
    
}
