import Foundation

struct AssetInfoCellViewModel {
    
    let name: String
    let value: String
    
    init(entry: SummaryEntry) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 0
        
        self.name = entry.name
        self.value = numberFormatter.string(for: entry.totalShare) ?? "0"
    }
    
}
