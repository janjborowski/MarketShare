import XCTest
@testable import MarketShare

class CreateWorldBankSummaryTests: OperationTestCase {
    
    private var sut: CreateWorldBankSummary!

    override func setUp() {
        super.setUp()
        
        sut = CreateWorldBankSummary(asset: .globalStocks)
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func test_ShouldNotMapSummary_WhenNoData() {
        let expectationToBeCalled = defaultExpectation
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            XCTAssertNil(try? self.sut.result.get())
        }
        
        waitForExpectations()
    }
    
    func test_ShouldMapSummary_WhenDataIsPresent() {
        let expectationToBeCalled = defaultExpectation
        sut.inputData = .success(WorldBankResponse.sample)
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            let summary = try! self.sut.result.get()
            XCTAssertEqual(summary.name, WorldBankIndicator.indicator.name)
            XCTAssertEqual(summary.entries.count, 2)

            XCTAssertEqual(summary.entries.first?.name, WorldBankCountry.big.name)
            XCTAssertEqual(summary.entries.first?.value, 90)
            XCTAssertEqual(summary.entries.first?.totalShare, Decimal(0.9))
            
            XCTAssertEqual(summary.entries.last?.name, WorldBankCountry.small.name)
            XCTAssertEqual(summary.entries.last?.value, 10)
            XCTAssertEqual(summary.entries.last?.totalShare, Decimal(0.1))
        }
        
        waitForExpectations()
    }

    func test_ShouldFilterCountryByName_WhenAssetIsEmergingMarketStocks() {
        sut = CreateWorldBankSummary(asset: .emergingMarketStocks)
        sut.inputData = .success(WorldBankResponse.sample)
        let expectationToBeCalled = defaultExpectation
        
        setUpBlockExpectation(sut: sut) {
            expectationToBeCalled.fulfill()
            let summary = try! self.sut.result.get()
            XCTAssertEqual(summary.entries.count, 1)

            XCTAssertEqual(summary.entries.first?.name, WorldBankCountry.small.name)
            XCTAssertEqual(summary.entries.first?.value, 10)
            XCTAssertEqual(summary.entries.first?.totalShare, Decimal(1))
        }
        
        waitForExpectations()
    }

}

private extension WorldBankResponse {
    
    static var sample: WorldBankResponse {
        let paging = WorldBankPaging(lastUpdated: "", page: 0, pages: 0, perPage: 0, sourceId: "", total: 0)
        
        let entries: [WorldBankEntry] = [
            WorldBankEntry(
                country: .small,
                countryISO3Code: "USA",
                date: "2018",
                decimal: 0,
                indicator: .indicator,
                obsStatus: "",
                unit: "",
                value: 10
            ),
            WorldBankEntry(
                country: .big,
                countryISO3Code: "POL",
                date: "2018",
                decimal: 0,
                indicator: .indicator,
                obsStatus: "",
                unit: "",
                value: 90
            ),
            WorldBankEntry(
                country: .no,
                countryISO3Code: "",
                date: "2018",
                decimal: 0,
                indicator: .indicator,
                obsStatus: "",
                unit: "",
                value: 90
            ),
            WorldBankEntry(
                country: .tiny,
                countryISO3Code: WorldBankCountry.tiny.id,
                date: "2018",
                decimal: 0,
                indicator: .indicator,
                obsStatus: "",
                unit: "",
                value: 0
            )
        ]
        
        return WorldBankResponse(paging: paging, entries: entries)
    }
    
}

private extension WorldBankCountry {
    
    static var small: WorldBankCountry {
        return WorldBankCountry(id: "1", name: "South Korea")
    }
    
    static var big: WorldBankCountry {
        return WorldBankCountry(id: "2", name: "Canada")
    }
    
    static var no: WorldBankCountry {
        return WorldBankCountry(id: "3", name: "No country")
    }
    
    static var tiny: WorldBankCountry {
        return WorldBankCountry(id: "4", name: "Tiny country without share")
    }
    
}

private extension WorldBankIndicator {
    
    static var indicator: WorldBankIndicator {
        return WorldBankIndicator(id: "aaaa", name: "Pierogi indictor")
    }
    
}
