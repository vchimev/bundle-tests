if (global.TNS_WEBPACK) {
    global.registerModule("main-page", () => require("main-page"));
    global.registerModule("main-view-model", () => require("main-view-model"));
}
