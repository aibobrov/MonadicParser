#!/usr/bin/env bash

docker pull swift

docker run --security-opt seccomp=unconfined -it -v "$(pwd)"/..:/MonadicParser swift /bin/bash
