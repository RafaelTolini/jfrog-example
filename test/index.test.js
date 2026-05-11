const test = require("node:test");
const assert = require("node:assert/strict");
const { createMessage } = require("../src/index");

test("createMessage returns the service status", () => {
  assert.deepEqual(createMessage(), {
    service: "jfrog-example",
    packageName: "j-frog-example",
    status: "ok",
    artifact: "This app can be built, scanned, and published through JFrog."
  });
});
