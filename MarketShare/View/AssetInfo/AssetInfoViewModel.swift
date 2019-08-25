protocol AssetInfoViewModelProtocol {
    
    var state: Observable<AssetInfoViewModelState> { get }
    var cellViewModels: [AssetInfoCellViewModel] { get }

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
            weakSelf.state.update(value: .fetched)
        }
    }
    
}
