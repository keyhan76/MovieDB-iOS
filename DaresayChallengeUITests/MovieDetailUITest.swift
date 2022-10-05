//
//  MovieDetailUITest.swift
//  DaresayChallengeUITests
//
//  Created by Keihan Kamangar on 2022-06-30.
//

import XCTest

class MovieDetailUITest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
    
    func testTitleLabelExists() {
        goToMovieDetailVC()
        
        let movieDetailTitleLabel = findElement(in: app.staticTexts, with: .movieDetailTitleLabel)
        let movieDetailRatingLabel = findElement(in: app.staticTexts, with: .movieDetailRatingLabel)
        let movieDetailContainerView = findElement(in: app.otherElements, with: .movieDetailContainerView)
        let movieDetailFavoriteButton = findElement(in: app.buttons, with: .movieDetailFavoriteButton)
        let movieDetailDescLabel = findElement(in: app.staticTexts, with: .movieDetailDescLabel)
        let movieDetailBackgroundImageView = findElement(in: app.images, with: .movieDetailBackgroundImageView)
        
        
        XCTAssert(movieDetailTitleLabel.exists)
        XCTAssert(movieDetailRatingLabel.exists)
        XCTAssert(movieDetailContainerView.exists)
        XCTAssert(movieDetailFavoriteButton.exists)
        XCTAssert(movieDetailDescLabel.exists)
        XCTAssert(movieDetailBackgroundImageView.exists)
    }
}

extension MovieDetailUITest {
    func goToMovieDetailVC() {
        let tableViewCell = findElement(in: app.cells, with: .moviesTableViewCell).firstMatch
        tableViewCell.tap()
    }
}
