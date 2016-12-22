"use strict";
var nsAppium = require("nativescript-dev-appium");

describe("button tap", function () {
    this.timeout(600000);
    var driver;

    before(function () {
        var caps = nsAppium.caps.ios10();
        caps.showIOSLog = true;
        caps.launchTimeout = 600000;
        driver = nsAppium.createDriver(caps);
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
            .elementByAccessibilityId("tapButton")
                .should.eventually.exist
            .tap()
            .elementByAccessibilityId("message")
                .text().should.eventually.equal("15 taps left")
    });
});
