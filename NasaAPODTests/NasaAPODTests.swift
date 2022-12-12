//
//  NasaAPODTests.swift
//  NasaAPODTests
//
//  Created by Shivakumar, Sushma on 09/12/22.
//

import XCTest
@testable import NasaAPOD

final class NasaAPODDataManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddAPODData() throws {
        let APODManager = NasaAPODDataManager.shared
        let context = TestCoreDataStack().mainContext
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        APODManager.addAPODData(APODModel: APOD(date: "2022-12-11", explanation: "Test Description", hdurl: nil, serviceVersion: nil, mediaType: "image", title: "Test", url: "https://example.com"), image: UIImage())
        try! context.save()
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testFavouriteAPOD() throws {
        let APODManager = NasaAPODDataManager.shared
        let context = TestCoreDataStack().mainContext
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        APODManager.addAPODData(APODModel: APOD(date: "2022-12-11", explanation: "Test Description", hdurl: nil, serviceVersion: nil, mediaType: "image", title: "Test", url: "https://example.com"), image: UIImage())
        try! context.save()
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        XCTAssertTrue(APODManager.favouritePic(day: "2022-12-11", favourite: true), "Favouriting the pic data failed")
        XCTAssertTrue(APODManager.isPicFavourite(day: "2022-12-11"), "The pic data is not favourite")
    }
    
    func testUnFavouriteAPOD() throws {
        let APODManager = NasaAPODDataManager.shared
        let context = TestCoreDataStack().mainContext
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        APODManager.addAPODData(APODModel: APOD(date: "2022-12-11", explanation: "Test Description", hdurl: nil, serviceVersion: nil, mediaType: "image", title: "Test", url: "https://example.com"), image: UIImage())
        try! context.save()
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        XCTAssertTrue(APODManager.favouritePic(day: "2022-12-11", favourite: false), "UnFavouriting the pic data failed")
        XCTAssertFalse(APODManager.isPicFavourite(day: "2022-12-11"), "The pic data is not favourite")
    }
}
