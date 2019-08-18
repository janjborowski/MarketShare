struct WorldBankPaging: Codable {
    
    let lastUpdated: String
    let page: Int
    let pages: Int
    let perPage: Int
    let sourceId: String
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        
        case lastUpdated = "lastupdated"
        case page
        case pages
        case perPage = "per_page"
        case sourceId = "sourceid"
        case total
        
    }
    
}
