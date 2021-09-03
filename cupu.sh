# Buildbomt

MANIFEST_LINK=git://github.com/ProjectSakura/android.git
BRANCH=11
ROM_NAME=lineage
DEVICE_CODENAME=ulysse
GITHUB_USER=jagaddhita
GITHUB_EMAIL=jaguarexify@gmail.com
WORK_DIR=$(pwd)/${ROM_NAME}
JOBS=nproc

# Set up git!
git config --global user.name ${GITHUB_USER}
git config --global user.email ${GITHUB_EMAIL}

# Make directories
mkdir ${WORK_DIR}

# Tool
apt-get update
apt-get upgrade
apt-get install openjdk-11-jdk
apt-get install git-core gnupg ccache lzop flex bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 libc6-dev lib32ncurses5 lib32z1 lib32bz2-1.0 lib32ncurses5-dev x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 lib32z-dev libgl1-mesa-glx:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc readline-common libreadline6-dev libreadline6 lib32readline-gplv2-dev libncurses5-dev lib32readline5 lib32readline6 libreadline-dev libreadline6-dev:i386 libreadline6:i386 bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev lib32bz2-dev libsdl1.2-dev libesd0-dev squashfs-tools pngcrush schedtool libwxgtk2.8-dev python
mkdir ~/bin && PATH=~/bin:$PATH && curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo

# Set up rom repo
cd ${WORK_DIR}
repo init --depth=1 -u ${MANIFEST_LINK} -b ${BRANCH}
repo sync --current-branch --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune -j${JOBS}

# clone device sources
git clone -b lineage-18.1 --depth=1 https://github.com/jagaddhita/android_device_xiaomi_ulysse device/xiaomi/ulysse
git clone -b eleven --depth=1 https://github.com/mgs28-mh/device_xiaomi_ulysse-common device/xiaomi/ulysse-common
git clone -b 11 --depth=1 https://github.com/mgs28-mh/kernel_xiaomi_ulysse-4.9 kernel/xiaomi/ulysse 
git clone -b lineage-18.1 --depth=1 https://github.com/mi-msm8937/proprietary_vendor_xiaomi_ulysse vendor/xiaomi/ulysse

# Start building!
. build/envsetup.sh
lunch lineage_${DEVICE_CODENAME}-userdebug
mka bacon -j${JOBS}

# Upload
curl --upload-file out/target/product/ulysse/*zip http://transfer.sh/sakura-ulysse.zip
