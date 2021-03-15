#!/usr/bin/env bash
# Chonky Base!
# This directory is for making a chonky base image... rather than mounting in libraries from the hosting xavier, everything is copied here (so the docker file has everything contained).
# This should mean that hosting dockers don't actually need the libraries installed (yay), and the libs will also be in the docker so other libraries that depend on things in aarch64-linux-gnu/ can also be built in the `docker build`
# But of course the image will be larger... (~3 GB!!!??, maybe less compressed).
# Very open to alternative ways to do this.
# Joshua Spisak <joshs333@live.com> July 21, 2020

# Make the folder if it does not already exist...
mkdir -p aarch64-linux-gnu
# Go into aarch64-linux-gnu
cd aarch64-linux-gnu
# Copy over opencv 3.3.1
cp /usr/lib/libopencv* .
# Copy over everything else...
cp -r /usr/lib/aarch64-linux-gnu/* .
