import Foundation

struct WorldBankEntry: Codable {
    
    let country: WorldBankCountry
    let countryISO3Code: String
    let date: String
    let decimal: Int
    let indicator: WorldBankIndicator
    let obsStatus: String
    let unit: String
    let value: Double?
    
    private enum CodingKeys: String, CodingKey {
        
        case country
        case countryISO3Code = "countryiso3code"
        case date
        case decimal
        case indicator
        case obsStatus = "obs_status"
        case unit
        case value
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country = try container.decode(WorldBankCountry.self, forKey: .country)
        countryISO3Code = try container.decode(String.self, forKey: .countryISO3Code)
        date = try container.decode(String.self, forKey: .date)
        decimal = try container.decode(Int.self, forKey: .decimal)
        indicator = try container.decode(WorldBankIndicator.self, forKey: .indicator)
        obsStatus = try container.decode(String.self, forKey: .obsStatus)
        unit = try container.decode(String.self, forKey: .unit)
        
        if let value = try? container.decode(String.self, forKey: .value) {
            self.value = Double(value)
        } else if let value = try? container.decode(Double.self, forKey: .value) {
            self.value = value
        } else {
            self.value = nil
        }
    }
    
}
