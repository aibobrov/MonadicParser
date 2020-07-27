#!/usr/bin/env bash

TEMPLATE=./LinuxMain.stencil
OUTPUT=../Tests/LinuxMain.swift
SOURCES=../Tests/MonadicParserTests
TEST_IMPORT='@testable import MonadicParserTests'

sourcery --sources ${SOURCES} \
         --templates ${TEMPLATE} \
         --output ${OUTPUT} \
         --args testimports="${TEST_IMPORT}"
