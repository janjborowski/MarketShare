import Foundation

struct CoinMarketCapResponse: Decodable {
    
    let data: [CoinTicker]
    
}
