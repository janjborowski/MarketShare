struct WorldBankPaging {
    
    let lastUpdated: String
    let page: Int
    let pages: Int
    let perPage: Int
    let sourceId: String
    let total: Int
    
    private enum CodingKeys: String, CodingKey {
        
        case lastUpdated = "lastupdated"
        case page
        case pages
        case perPage = "per_page"
        case sourceId = "source_id"
        case total
        
    }
    
}
