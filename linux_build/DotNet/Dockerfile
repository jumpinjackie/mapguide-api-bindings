FROM ubuntu:14.04 as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    cmake \
    dos2unix \
    p7zip-full \
    libpcre3-dev

# Install .net Core SDK
RUN wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get install -y apt-transport-https && apt-get update && apt-get install -y dotnet-sdk-2.1
# We don't need to download the full set of MapGuide packages, this should be sufficient
RUN wget -q https://download.osgeo.org/mapguide/releases/3.1.1/Final/ubuntu14_x64/mapguideopensource-platformbase_3.1.1-9378_amd64.deb
RUN wget -q https://download.osgeo.org/mapguide/releases/3.1.1/Final/ubuntu14_x64/mapguideopensource-common_3.1.1-9378_amd64.deb
RUN wget -q https://download.osgeo.org/mapguide/releases/3.1.1/Final/ubuntu14_x64/mapguideopensource-webextensions_3.1.1-9378_amd64.deb
RUN dpkg -i mapguideopensource-platformbase_3.1.1-9378_amd64.deb
RUN dpkg -i mapguideopensource-common_3.1.1-9378_amd64.deb
RUN dpkg -i mapguideopensource-webextensions_3.1.1-9378_amd64.deb
ADD src/ ./src/
ADD thirdparty/ ./thirdparty/
ADD CMakeLists.txt ./CMakeLists.txt
ADD envsetupsdk.sh ./envsetupsdk.sh
RUN dos2unix ./envsetupsdk.sh
RUN bash ./envsetupsdk.sh --with-dotnet
RUN mkdir -p ./build
WORKDIR ./build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DMG_CPU=64 -DWITH_JAVA=0 -DWITH_PHP=0 -DWITH_DOTNET=1 ..
RUN make