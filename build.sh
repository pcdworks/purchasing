#!/bin/bash

VERSION=$(git describe --tags --abbrev=0)
docker build . -f docker/Dockerfile -t pcdworks/purchasing:latest -t "pcdworks/purchasing:${VERSION}"
