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
        let movieFavoriteImageView = findElement(in: app.images, with: .movieFavoriteImageView)
        let favoriteBarButton = findElement(in: app.buttons, with: .favoriteBarButton)
        
        XCTAssert(tableView.waitForExistence(timeout: 1))
        XCTAssert(tableViewCell.waitForExistence(timeout: 1))
        XCTAssert(movieTitleLabel.waitForExistence(timeout: 1))
        XCTAssert(movieDescriptionLabel.waitForExistence(timeout: 1))
        XCTAssert(movieImageView.waitForExistence(timeout: 1))
        XCTAssert(movieFavoriteImageView.waitForExistence(timeout: 1))
        XCTAssert(favoriteBarButton.waitForExistence(timeout: 1))
    }
}
