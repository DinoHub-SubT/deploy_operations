# OpenCV Cmake
This is a nasty hack to make Nvidia's base image to be compatible with the opencv version on all of our xaviers.

To get these I added in the opencv libraries from our current xavier setup (in /usr/lib/libopencv*) to /usr/lib/aarch..../libopencv* in docker, then modified the dockerfiles cmake files to match what was mounted in.
I'm sure better ways exist to do this (copying in the current xaviers cmake files instead of modifying the dockers cmake files probably would have worked..)... very open to alternative setups, but this should hopefully work.

If we can upgrade our xavier's to ALL come with the newer opencv (3.4) then use the correct nvidia l4t dockerfile that would be optimal I think.

- Josh Spisak <jjs231@pitt.edu> July 21, 2020
