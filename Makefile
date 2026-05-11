.PHONY: install test start-app start-jfrog stop-jfrog package publish clean

install:
	npm install

test:
	npm test

start-app:
	npm start

start-jfrog:
	./scripts/init-artifactory.sh
	docker compose up -d artifactory
	./scripts/wait-for-artifactory.sh

stop-jfrog:
	docker compose down

package:
	./scripts/package-app.sh

publish: test package
	./scripts/publish-to-artifactory.sh

clean:
	rm -rf dist
