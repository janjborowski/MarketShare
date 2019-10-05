import Foundation

final class CreateWorldBankSummary: Operation, Inputtable, Resultable {

    private let asset: Asset
    
    var inputData: Result<WorldBankResponse, Error>?
    
    private(set) var result: Result<Summary, Error> = .noResult()
    
    init(asset: Asset) {
        self.asset = asset
    }
    
    override func main() {
        guard case let .success(inputData)? = inputData else {
            propagateError()
            return
        }
        
        let countries = inputData.entries.filter(filterByCodeAndAsset)
        let totalSum = countries
            .compactMap { Decimal($0.value ?? 0) }
            .reduce(Decimal(0), +)
        
        let summaryEntries = countries.map { worldBankEntry -> SummaryEntry in
                let value = Decimal(worldBankEntry.value ?? 0)
                let totalShare = value / totalSum
                return SummaryEntry(name: worldBankEntry.country.name, value: value, totalShare: totalShare)
            }
            .filter { $0.totalShare > 0 }
            .sorted { (entry1, entry2) -> Bool in
                return entry1.totalShare > entry2.totalShare
            }
        
        let summaryName = countries.first?.indicator.name ?? ""
        result = .success(Summary(name: summaryName, entries: summaryEntries))
    }
    
    private func propagateError() {
        guard case let .failure(error)? = inputData else {
            return
        }
        
        result = .failure(error)
    }
    
    private func filterByCodeAndAsset(_ entry: WorldBankEntry) -> Bool {
        let isCorrectISO3Code = countryCodes.contains(entry.countryISO3Code)
        switch asset {
        case .globalStocks:
            return isCorrectISO3Code
        case .emergingMarketStocks:
            return isCorrectISO3Code && emergingMarkets.contains(entry.country.name)
        case .frontierMarketStocks:
            return isCorrectISO3Code && frontierMarkets.contains(entry.country.name)
        }
    }
    
}

private let countryCodes = [
    "ABW",
    "AFG",
    "AGO",
    "AIA",
    "ALA",
    "ALB",
    "AND",
    "ANT",
    "ARE",
    "ARG",
    "ARM",
    "ASM",
    "ATA",
    "ATF",
    "ATG",
    "AUS",
    "AUT",
    "AZE",
    "BDI",
    "BEL",
    "BEN",
    "BFA",
    "BGD",
    "BGR",
    "BHR",
    "BHS",
    "BIH",
    "BLM",
    "BLR",
    "BLZ",
    "BMU",
    "BOL",
    "BRA",
    "BRB",
    "BRN",
    "BTN",
    "BVT",
    "BWA",
    "CAF",
    "CAN",
    "CCK",
    "CHE",
    "CHL",
    "CHN",
    "CIV",
    "CMR",
    "COD",
    "COG",
    "COK",
    "COL",
    "COM",
    "CPV",
    "CRI",
    "CUB",
    "CXR",
    "CYM",
    "CYP",
    "CZE",
    "DEU",
    "DJI",
    "DMA",
    "DNK",
    "DOM",
    "DZA",
    "ECU",
    "EGY",
    "ERI",
    "ESH",
    "ESP",
    "EST",
    "ETH",
    "FIN",
    "FJI",
    "FLK",
    "FRA",
    "FRO",
    "FSM",
    "GAB",
    "GBR",
    "GEO",
    "GGY",
    "GHA",
    "GIB",
    "GIN",
    "GLP",
    "GMB",
    "GNB",
    "GNQ",
    "GRC",
    "GRD",
    "GRL",
    "GTM",
    "GUF",
    "GUM",
    "GUY",
    "HKG",
    "HMD",
    "HND",
    "HRV",
    "HTI",
    "HUN",
    "IDN",
    "IMN",
    "IND",
    "IOT",
    "IRL",
    "IRN",
    "IRQ",
    "ISL",
    "ISR",
    "ITA",
    "JAM",
    "JEY",
    "JOR",
    "JPN",
    "KAZ",
    "KEN",
    "KGZ",
    "KHM",
    "KIR",
    "KNA",
    "KOR",
    "KWT",
    "LAO",
    "LBN",
    "LBR",
    "LBY",
    "LCA",
    "LIE",
    "LKA",
    "LSO",
    "LTU",
    "LUX",
    "LVA",
    "MAC",
    "MAF",
    "MAR",
    "MCO",
    "MDA",
    "MDG",
    "MDV",
    "MEX",
    "MHL",
    "MKD",
    "MLI",
    "MLT",
    "MMR",
    "MNE",
    "MNG",
    "MNP",
    "MOZ",
    "MRT",
    "MSR",
    "MTQ",
    "MUS",
    "MWI",
    "MYS",
    "MYT",
    "NAM",
    "NCL",
    "NER",
    "NFK",
    "NGA",
    "NIC",
    "NIU",
    "NLD",
    "NOR",
    "NPL",
    "NRU",
    "NZL",
    "OMN",
    "PAK",
    "PAN",
    "PCN",
    "PER",
    "PHL",
    "PLW",
    "PNG",
    "POL",
    "PRI",
    "PRK",
    "PRT",
    "PRY",
    "PSE",
    "PYF",
    "QAT",
    "REU",
    "ROU",
    "RUS",
    "RWA",
    "SAU",
    "SDN",
    "SEN",
    "SGP",
    "SGS",
    "SHN",
    "SJM",
    "SLB",
    "SLE",
    "SLV",
    "SMR",
    "SOM",
    "SPM",
    "SRB",
    "STP",
    "SUR",
    "SVK",
    "SVN",
    "SWE",
    "SWZ",
    "SYC",
    "SYR",
    "TCA",
    "TCD",
    "TGO",
    "THA",
    "TJK",
    "TKL",
    "TKM",
    "TLS",
    "TON",
    "TTO",
    "TUN",
    "TUR",
    "TUV",
    "TWN",
    "TZA",
    "UGA",
    "UKR",
    "UMI",
    "URY",
    "USA",
    "UZB",
    "VAT",
    "VCT",
    "VEN",
    "VGB",
    "VIR",
    "VNM",
    "VUT",
    "WLF",
    "WSM",
    "YEM",
    "ZAF",
    "ZMB",
    "ZWE"
]

private let emergingMarkets = [
    "Brazil",
    "Chile",
    "China",
    "Colombia",
    "Czech Republic",
    "Egypt",
    "Greece",
    "Hungary",
    "India",
    "Indonesia",
    "Korea",
    "Malaysia",
    "Mexico",
    "Morocco",
    "Qatar",
    "Peru",
    "Philippines",
    "Poland",
    "Russia",
    "South Africa",
    "South Korea",
    "Taiwan",
    "Thailand",
    "Turkey",
    "United Arab Emirates"
]

// World Bank data is poor here
private let frontierMarkets = [
    "Bangladesh",
    "Burkina faso",
    "Bahrain",
    "Benin",
    "Ivory coast",
    "Estonia",
    "Guinea-bissau",
    "Croatia",
    "Jordan",
    "Kenya",
    "Kuwait",
    "Kazakhstan",
    "Lebanon",
    "Sri lanka",
    "Lithuania",
    "Morocco",
    "Mali",
    "Mauritius",
    "Niger",
    "Nigeria",
    "Oman",
    "Romania",
    "Serbia",
    "Slovenia",
    "Senegal",
    "Togo",
    "Tunisia",
    "Vietnam"
]
