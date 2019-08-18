import Foundation

final class CreateWorldBankSummary: Operation {

    var inputData: WorldBankResponse?
    
    private(set) var summary: Summary?
    
    override func main() {
        guard let inputData = inputData else {
            return
        }
        
        let totalSum = inputData.entries
            .compactMap { Decimal($0.value ?? 0) }
            .reduce(Decimal(0), +)
        let summaryEntries = inputData.entries.map { worldBankEntry -> SummaryEntry in
            let value = Decimal(worldBankEntry.value ?? 0)
            let totalShare = value / totalSum
            return SummaryEntry(name: worldBankEntry.country.name, value: value, totalShare: totalShare)
        }
        
        let summaryName = inputData.entries.first?.indicator.name ?? ""
        summary = Summary(name: summaryName, entries: summaryEntries)
    }
    
}
