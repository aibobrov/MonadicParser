#!/usr/bin/env bash

TEMPLATE=./LinuxMain.stencil
OUTPUT=../Tests/LinuxMain.swift
SOURCES=../Tests/MonadicParserTests

sourcery --sources ${SOURCES} --templates ${TEMPLATE} --output ${OUTPUT}