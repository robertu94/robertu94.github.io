JEKYLL_VERSION=3.8
build:
	sudo docker run --rm \
		--env JEKYLL_VERSION="$(JEKYLL_VERSION)" \
		--volume="$(PWD):/srv/jekyll" \
		--publish 4000:4000/tcp \
		-it jekyll/builder:$(JEKYLL_VERSION) \
		jekyll build
watch:
	sudo docker run --rm \
		--env JEKYLL_VERSION="$(JEKYLL_VERSION)" \
		--volume="$(PWD):/srv/jekyll" \
		--publish 4000:4000/tcp \
		-it jekyll/builder:$(JEKYLL_VERSION) \
		jekyll build --incremental --watch

