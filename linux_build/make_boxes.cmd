@echo off
SET BUILD_UBUNTU14_32=1
SET BUILD_UBUNTU14_64=1
SET BUILD_CENTOS6_32=1
SET BUILD_CENTOS6_64=1
which packer
if %errorlevel% neq 0 (
    echo Packer not found. Make sure it is installed or its tools are in your PATH
    exit /b 1
)
pushd packer
if "%BUILD_CENTOS6_64%" == "1" (
echo [packer]: Build CentOS6 64-bit base box
packer build -force centos6-amd64.json | tee packer_centos6_64.log
echo [vagrant]: Export centos6-amd64 base box
rem call vagrant package --base "centos6-amd64" --output centos6-amd64.box
call vagrant box add "env-centos6-amd64" centos6-amd64.box --force
)
if "%BUILD_CENTOS6_32%" == "1" (
echo [packer]: Build CentOS6 32-bit base box
packer build -force centos6-i386.json | tee packer_centos6_32.log
echo [vagrant]: Export centos6-i386 base box
rem call vagrant package --base "centos6-i386" --output centos6-i386.box
call vagrant box add "env-centos6-i386" centos6-i386.box --force
)
if "%BUILD_UBUNTU14_64%" == "1" (
echo [packer]: Build Ubuntu14 64-bit base box
packer build -force ubuntu14-amd64.json | tee packer_ubuntu14_64.log
echo [vagrant]: Export ubuntu14-amd64 base box
rem call vagrant package --base "ubuntu14-amd64" --output ubuntu14-amd64.box
call vagrant box add "env-ubuntu14-amd64" ubuntu14-amd64.box --force
)
if "%BUILD_UBUNTU14_32%" == "1" (
echo [packer]: Build Ubuntu14 32-bit base box
packer build -force ubuntu14-i386.json | tee packer_ubuntu14_32.log
echo [vagrant]: Export ubuntu14-i386 base box
rem call vagrant package --base "ubuntu14-i386" --output ubuntu14-i386.box
call vagrant box add "env-ubuntu14-i386" ubuntu14-i386.box --force
)
popd