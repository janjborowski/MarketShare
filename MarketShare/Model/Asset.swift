enum Asset {
    
    case globalStocks
    case emergingMarketStocks
    case frontierMarketStocks
    case crypto
    case cryptoNoBitcoin
 
    var name: String {
        switch self {
        case .globalStocks:
            return "global_stocks".localized
        case .emergingMarketStocks:
            return "emerging_stocks".localized
        case .frontierMarketStocks:
            return "frontier_stocks".localized
        case .crypto:
            return "all_crypto".localized
        case .cryptoNoBitcoin:
            return "crypto_ex_btc".localized
        }
    }
    
}
