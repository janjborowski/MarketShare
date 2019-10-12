import Foundation

struct CoinTicker {

    let id: Int
    let name: String
    let symbol: String
    let circulatingSupply: Decimal?
    let maxSupply: Decimal?
    let quotes: [Quote]

    init(id: Int, name: String, symbol: String, circulatingSupply: Decimal?, maxSupply: Decimal?, quotes: [Quote]) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.circulatingSupply = circulatingSupply
        self.maxSupply = maxSupply
        self.quotes = quotes
    }

}

extension CoinTicker: Decodable {

    enum CoinTickerCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case circulatingSupply = "circulating_supply"
        case maxSupply = "max_supply"
        case quote = "quote"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoinTickerCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let symbol = try container.decode(String.self, forKey: .symbol)
        let circulatingSupply = try? container.decode(Decimal.self, forKey: .circulatingSupply)
        let maxSupply = try? container.decode(Decimal.self, forKey: .maxSupply)

        let dictionaryOfQuotes = try? container.decode([String: Quote].self, forKey: .quote)
        let quotes = dictionaryOfQuotes?.compactMap { $0.1 } ?? []

        self.init(
            id: id,
            name: name,
            symbol: symbol,
            circulatingSupply: circulatingSupply,
            maxSupply: maxSupply,
            quotes: quotes
        )
    }

}
