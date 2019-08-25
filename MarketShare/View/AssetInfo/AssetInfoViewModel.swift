import Charts

protocol AssetInfoViewModelProtocol {
    
    var state: Observable<AssetInfoViewModelState> { get }
    var cellViewModels: [AssetInfoCellViewModel] { get }
    var pieChartEntries: [PieChartDataEntry] { get }

    func downloadSummaries()
    
}

enum AssetInfoViewModelState {
    
    case loading
    case fetched
    case error
    
}

final class AssetInfoViewModel: AssetInfoViewModelProtocol {
    
    private var summary: Summary = Summary(name: "", entries: [])
    private let worldBankFetcher: WorldBankFetcherProtocol
    
    let state = Observable(value: AssetInfoViewModelState.loading)
    private(set) var cellViewModels = [AssetInfoCellViewModel]()
    private(set) var pieChartEntries = [PieChartDataEntry]()
    
    init(worldBankFetcher: WorldBankFetcherProtocol) {
        self.worldBankFetcher = worldBankFetcher
    }
    
    func downloadSummaries() {
        worldBankFetcher.download { [weak self] (summary) in
            guard let summary = summary,
                let weakSelf = self else {
                self?.state.update(value: .error)
                return
            }
            
            weakSelf.summary = summary
            weakSelf.cellViewModels = summary.entries.map { AssetInfoCellViewModel(entry: $0) }
            weakSelf.pieChartEntries = weakSelf.createPieChartEntries()
            weakSelf.state.update(value: .fetched)
        }
    }
    
    private func createPieChartEntries() -> [PieChartDataEntry] {
        let topEntries = summary.entries[0..<10]
        let topChartEntries = summary.entries[0..<10].map { (entry) -> PieChartDataEntry in
            return PieChartDataEntry(
                value: (entry.totalShare as NSDecimalNumber).doubleValue,
                label: entry.name
            )
        }
        
        let restShare = topEntries.map { $0.totalShare }.reduce(1, -)
        let remainingEntry = PieChartDataEntry(
            value: (restShare as NSDecimalNumber).doubleValue,
            label: "others".localized
        )
        
        return topChartEntries + [remainingEntry]
    }
    
}
