struct WorldBankEntry: Codable {
    
    let country: WorldBankCountry
    let countryISO3Code: String
    let date: String
    let decimal: Int
    let indicator: WorldBankIndicator
    let obsStatus: String
    let unit: String
    let value: String?
    
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
    
}
