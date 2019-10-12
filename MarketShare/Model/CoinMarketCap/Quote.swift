import Foundation

struct Quote: Decodable {

    let marketCap: Decimal

    enum CodingKeys: String, CodingKey {
        case marketCap = "market_cap"
    }

}
