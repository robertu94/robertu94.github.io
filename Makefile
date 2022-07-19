JEKYLL_VERSION=latest
serve:
	podman run --rm \
		--env JEKYLL_VERSION="$(JEKYLL_VERSION)" \
		--env JEKYLL_ROOTLESS="1" \
		--volume="$(PWD):/srv/jekyll:Z" \
		--publish 4000:4000/tcp \
		-it jekyll/jekyll:$(JEKYLL_VERSION) \
		jekyll serve
build:
	podman run --rm \
		--env JEKYLL_VERSION="$(JEKYLL_VERSION)" \
		--env JEKYLL_ROOTLESS="1" \
		--volume="$(PWD):/srv/jekyll:Z" \
		--publish 4000:4000/tcp \
		-it jekyll/jekyll:$(JEKYLL_VERSION) \
		jekyll build
watch:
	podman run --rm \
		--env JEKYLL_VERSION="$(JEKYLL_VERSION)" \
		--env JEKYLL_ROOTLESS="1" \
		--volume="$(PWD):/srv/jekyll:Z" \
		--publish 4000:4000/tcp \
		-it jekyll/jekyll:$(JEKYLL_VERSION) \
		jekyll build --incremental --watch

