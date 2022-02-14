#!/bin/bash

docker build . -f docker/Dockerfile -t pcdworks/purchasing:latest -t "pcdworks/purchasing:`git describe`"
