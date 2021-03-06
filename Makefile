BUILDX_VER=v0.3.1
OSMOSIS_VERSION?=0.47
IMAGE_TAG?=${OSMOSIS_VERSION}
IMAGE_BASE?=jdrouet
BUILD_PLATFORM?=linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/386,linux/amd64
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

test-build:
	docker build -t ${IMAGE_BASE}/osmosis:test .

test-download:
	curl -k -L --output input.osm.pbf https://download.geofabrik.de/europe/france/guadeloupe-latest.osm.pbf

test: test-build test-download
	docker run --rm \
		-v ${PWD}/input.osm.pbf:/input.osm.pbf \
		${IMAGE_BASE}/osmosis:test \
		--read-pbf file=/input.osm.pbf \
		--log-progress \
		--tf accept-ways highway=* \
		--tf reject-ways highway=motorway,motorway_link \
		--tf reject-relations \
		--used-node \
		--write-pbf file=/output.osm.pbf
