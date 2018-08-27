#Download base image ubuntu 16.04
FROM ubuntu:16.04

RUN echo "root:root!" | chpasswd

# Update proxy for apt-get
# RUN echo "Acquire::http::proxy \"http://10.0....:1508/\";" > /etc/apt/apt.conf
# RUN echo "Acquire::http::proxy \"https://10.0....:1508/\";" >> /etc/apt/apt.conf

RUN apt-get update

RUN apt-get -y install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get -y install python3.5-dev python3-numpy libtbb2 libtbb-dev
RUN apt-get -y install libjpeg-dev libpng-dev libtiff5-dev libjasper-dev libdc1394-22-dev libeigen3-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev sphinx-common libtbb-dev yasm libfaac-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenexr-dev libgstreamer-plugins-base1.0-dev libavutil-dev libavfilter-dev libavresample-dev
RUN apt-get install -y apt-utils
RUN apt-get -y install wget unzip

RUN apt-get update && \
        apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
        cmake

RUN apt-get -f install

# RUN echo "https_proxy = https://10.0....:1508/" >> /etc/wgetrc
# RUN echo "http_proxy = http://10.0....:1508/" >> /etc/wgetrc

RUN mkdir -p  /media/
RUN mkdir -p /media/DATA/

WORKDIR /media/DATA/
ENV OPENCV_VERSION="3.4.2"

RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O /media/DATA/opencv-${OPENCV_VERSION}.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O /media/DATA/opencv_contrib-${OPENCV_VERSION}.zip

RUN unzip /media/DATA/opencv-${OPENCV_VERSION}.zip -d /media/DATA/
RUN unzip /media/DATA/opencv_contrib-${OPENCV_VERSION}.zip -d /media/DATA/

RUN mkdir -p /media/DATA/release
RUN mkdir -p /media/DATA/opencv-${OPENCV_VERSION}/cmake_binary \
RUN cd /media/DATA/opencv-${OPENCV_VERSION}/cmake_binary \
&& cmake -D BUILD_TIFF=ON \
    -DBUILD_opencv_java=OFF \
    -DWITH_CUDA=OFF \
    -DWITH_OPENGL=ON \
    -DWITH_OPENCL=ON \
    -DWITH_IPP=ON \
    -DWITH_TBB=ON \
    -DWITH_EIGEN=ON \
    -DWITH_V4L=ON \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=$(python3.5 -c "import sys; print(sys.prefix)") \
    -DPYTHON_EXECUTABLE=$(which python3.5) \
    -DPYTHON_INCLUDE_DIR=$(python3.5 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -DPYTHON_PACKAGES_PATH=$(python3.5 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    -D OPENCV_EXTRA_MODULES_PATH=/media/DATA/opencv_contrib-${OPENCV_VERSION}/modules \
    /media/DATA/opencv-${OPENCV_VERSION}/ \
    && make install \
    && rm /media/DATA/opencv-${OPENCV_VERSION}.zip \
    && rm -r /media/DATA/opencv-${OPENCV_VERSION} \
    && rm /media/DATA/opencv_contrib-${OPENCV_VERSION}.zip \
    && rm -r /media/DATA/opencv_contrib-${OPENCV_VERSION}
