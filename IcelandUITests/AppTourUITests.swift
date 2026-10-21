import XCTest

/// Walks through the app at a human pace. CI records the simulator screen while this runs,
/// so the pauses are there to make the video easy to follow.
final class AppTourUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-resetFavorites"]
    }

    func testAppTour() throws {
        app.launch()
        XCTAssertTrue(app.otherElements["hero"].waitForExistence(timeout: 15) || app.images.firstMatch.waitForExistence(timeout: 5))
        pause(3)

        // Explore tab: browse the featured carousel.
        let carousel = app.scrollViews["featuredCarousel"]
        let mainScroll = app.scrollViews.firstMatch
        mainScroll.swipeUp(velocity: .slow)
        pause(1.5)
        if carousel.exists {
            carousel.swipeLeft(velocity: .slow)
            pause(1.2)
            carousel.swipeLeft(velocity: .slow)
            pause(1.2)
            carousel.swipeRight(velocity: .fast)
            pause(1)
        }

        // Scroll through the regions and open Skógafoss.
        let skogafoss = app.buttons["row-skogafoss"]
        scrollUntilHittable(skogafoss, in: mainScroll)
        pause(1)
        skogafoss.tap()
        pause(2.5)

        // Read the detail page, then favorite it.
        app.swipeUp(velocity: .slow)
        pause(2)
        app.swipeUp(velocity: .slow)
        pause(2)
        app.swipeDown(velocity: .fast)
        pause(1)
        let favorite = app.buttons["favoriteButton"]
        XCTAssertTrue(favorite.waitForExistence(timeout: 5))
        favorite.tap()
        pause(1.5)
        goBack()
        pause(1.5)

        // Keep exploring further down and open the glacier lagoon.
        let lagoon = app.buttons["row-jokulsarlon"]
        scrollUntilHittable(lagoon, in: mainScroll)
        pause(1)
        lagoon.tap()
        pause(2.5)
        app.swipeUp(velocity: .slow)
        pause(2)
        goBack()
        pause(1)
        scrollUntilHittable(app.buttons["row-dettifoss"], in: mainScroll)
        pause(1.5)

        // Map tab: jump between attractions.
        tab("地圖").tap()
        pause(3)
        for id in ["gullfoss", "skogafoss", "jokulsarlon"] {
            let chip = app.buttons["chip-\(id)"]
            var swipes = 0
            while chip.exists && !chip.isHittable && swipes < 4 {
                app.scrollViews.firstMatch.swipeLeft(velocity: .slow)
                swipes += 1
            }
            if chip.waitForExistence(timeout: 3) {
                chip.tap()
                pause(3)
            }
        }
        let mapCard = app.buttons["mapCard"]
        if mapCard.waitForExistence(timeout: 3) {
            mapCard.tap()
            pause(2.5)
            app.swipeUp(velocity: .slow)
            pause(1.5)
            goBack()
            pause(1)
        }
        let overview = app.buttons["overviewButton"]
        if overview.exists {
            overview.tap()
            pause(2.5)
        }

        // About tab: facts, tips and photo credits.
        tab("關於冰島").tap()
        pause(2.5)
        for _ in 0..<4 {
            app.swipeUp(velocity: .slow)
            pause(1.5)
        }
        app.swipeDown(velocity: .fast)
        app.swipeDown(velocity: .fast)
        pause(1)

        tab("探索").tap()
        pause(2)
    }

    // MARK: - Helpers

    private func pause(_ seconds: TimeInterval) {
        Thread.sleep(forTimeInterval: seconds)
    }

    private func tab(_ title: String) -> XCUIElement {
        let tabButton = app.tabBars.buttons[title]
        return tabButton.waitForExistence(timeout: 3) ? tabButton : app.buttons[title].firstMatch
    }

    private func scrollUntilHittable(_ element: XCUIElement, in scrollView: XCUIElement, maxSwipes: Int = 10) {
        var swipes = 0
        while !(element.exists && element.isHittable && element.frame.maxY < app.frame.maxY - 140), swipes < maxSwipes {
            scrollView.swipeUp(velocity: .slow)
            pause(0.6)
            swipes += 1
        }
        XCTAssertTrue(element.isHittable, "\(element) never became hittable")
    }

    private func goBack() {
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.exists && backButton.isHittable {
            backButton.tap()
        } else {
            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
            start.press(forDuration: 0.05, thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.5)))
        }
    }
}
