FROM nvcr.io/nvidia/l4t-ml:r32.4.2-py3

ADD thirdparty-software/opencv/* /usr/share/OpenCV/
# RUN mkdir /usr/lib/aarch64-linux-gnu
ADD /thirdparty-software/aarch64-linux-gnu /usr/lib/aarch64-linux-gnu
ADD /thirdparty-software/cuda /usr/local/cuda
