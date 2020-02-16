BUILDX_VER=v0.3.1
OSMOSIS_VERSION?=0.47
IMAGE_TAG?=${OSMOSIS_VERSION}
IMAGE_BASE?=jdrouet
BUILD_PLATFORM?=linux/amd64
BUILD_ARGS?=

build:
	docker buildx build ${BUILD_ARGS} \
		--build-arg OSMOSIS_VERSION=${OSMOSIS_VERSION} \
		--platform ${BUILD_PLATFORM} \
		-t ${IMAGE_BASE}/osmosis:${IMAGE_TAG} \
		.

build-latest:
	docker buildx build ${BUILD_ARGS} \
		--build-arg OSMOSIS_VERSION=${OSMOSIS_VERSION} \
		--platform ${BUILD_PLATFORM} \
		-t ${IMAGE_BASE}/osmosis:${IMAGE_TAG} \
		-t ${IMAGE_BASE}/osmosis:latest \
		.

install-buildx:
	mkdir -vp ~/.docker/cli-plugins/ ~/dockercache
	curl --silent -L "https://github.com/docker/buildx/releases/download/${BUILDX_VER}/buildx-${BUILDX_VER}.linux-amd64" > ~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx
	docker buildx create --use --platform ${BUILD_PLATFORM}
	docker buildx inspect
