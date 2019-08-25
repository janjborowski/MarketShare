import Foundation

final class CreateWorldBankSummary: Operation {

    var inputData: WorldBankResponse?
    
    private(set) var summary: Summary?
    
    override func main() {
        guard let inputData = inputData else {
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
        summary = Summary(name: summaryName, entries: summaryEntries)
    }
    
}
