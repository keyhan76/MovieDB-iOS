//
//  MoviesListUITest.swift
//  DaresayChallengeUITests
//
//  Created by Keihan Kamangar on 2022-06-30.
//

import XCTest

class MoviesListUITest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
    
    func testUIElementsExists() {
        let tableView = findElement(in: app.tables, with: .moviesTableView)
        let tableViewCell = findElement(in: app.cells, with: .moviesTableViewCell)
        let movieTitleLabel = findElement(in: app.staticTexts, with: .movieTitleLabel)
        let movieDescriptionLabel = findElement(in: app.staticTexts, with: .movieDescriptionLabel)
        let movieImageView = findElement(in: app.images, with: .movieImageView)
        
        XCTAssert(tableView.exists)
        XCTAssert(tableViewCell.exists)
        XCTAssert(movieTitleLabel.exists)
        XCTAssert(movieDescriptionLabel.exists)
        XCTAssert(movieImageView.exists)
    }
}
