"use strict";
var nsAppium = require("nativescript-dev-appium");

describe("button tap", function () {
    this.timeout(60000);
    var driver;

    before(function () {
        driver = nsAppium.createDriver();
    });

    after(function () {
        return driver
        .quit()
        .finally(function () {
            console.log("Driver quit successfully");
        });
    });

    it("should find an element", function () {
        return driver
            .waitForElementByAccessibilityId("tapButton", 50000)
            .elementByAccessibilityId("tapButton")
                .should.eventually.exist
            .tap()
            .elementByAccessibilityId("messageLabel")
                .text().should.eventually.equal("15 taps left")
    });
});
