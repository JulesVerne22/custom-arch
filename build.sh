#!/bin/bash

mkdir -p {work,build}

sudo mkarchiso -v -w work -o build .
