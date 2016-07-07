"use strict";
var nsAppium = require("nativescript-dev-appium");

describe("android simple", function () {
    this.timeout(30000);
    var driver;

    before(function () {
        var caps = nsAppium.caps.android19();
        caps.avd = "x86-19-bundle-ns";
        caps.avdArgs = "-port 18002 -no-skin -no-window";
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
            .elementByAccessibilityId("messageLabel")
                .text().should.eventually.equal("41 taps left")
    });
});
