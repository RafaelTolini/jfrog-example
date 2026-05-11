const http = require("node:http");
const { kebabCase } = require("lodash");

const port = Number(process.env.PORT || 3000);

function createMessage() {
  return {
    service: "jfrog-example",
    packageName: kebabCase("JFrog Example"),
    status: "ok",
    artifact: "This app can be built, scanned, and published through JFrog."
  };
}

if (require.main === module) {
  const server = http.createServer((req, res) => {
    if (req.url !== "/") {
      res.writeHead(404, { "content-type": "application/json" });
      res.end(JSON.stringify({ error: "not found" }));
      return;
    }

    res.writeHead(200, { "content-type": "application/json" });
    res.end(JSON.stringify(createMessage()));
  });

  server.listen(port, () => {
    console.log(`jfrog-example listening on http://localhost:${port}`);
  });
}

module.exports = { createMessage };
