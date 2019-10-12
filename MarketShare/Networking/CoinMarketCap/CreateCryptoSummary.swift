import Foundation

final class CreateCryptoSummary: Operation, Inputtable, Resultable {
    
    private let asset: Asset
    
    var inputData: Result<Data, Error>?
    
    private(set) var result: Result<Summary, Error> = .noResult()
    
    init(asset: Asset) {
        self.asset = asset
    }
    
    override func main() {
        guard case let .success(data) = inputData else {
            return
        }
        guard let response = try? JSONDecoder().decode(CoinMarketCapResponse.self, from: data) else {
            return
        }
        
        let tickers = response.data.filter(assetFilter)
        let totalSum = tickers.compactMap { $0.quotes.first?.marketCap }
            .reduce(Decimal(0), +)
        
        let summaryEntries = tickers.map { ticker -> SummaryEntry in
                let value = ticker.quotes.first?.marketCap ?? 0
                let totalShare = value / totalSum
                return SummaryEntry(name: ticker.name, value: value, totalShare: totalShare)
            }
            .filter { $0.totalShare > 0 }
            .sorted { (entry1, entry2) -> Bool in
                return entry1.totalShare > entry2.totalShare
            }
        
        result = .success(Summary(name: "Crypto", entries: summaryEntries))
    }
    
    private func assetFilter(coinTicker: CoinTicker) -> Bool {
        switch asset {
        case .crypto:
            return true
        case .cryptoNoBitcoin:
            return coinTicker.symbol != "BTC"
        default:
            return false
        }
    }
    
}
