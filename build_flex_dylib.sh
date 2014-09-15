#!/usr/bin/env bash

echo "Cleaning up..."
rm -rf bin/
rm -rf src/
rm -rf FLEX/

echo "Clonning sources..."
git clone https://github.com/Flipboard/FLEX.git

echo "Copying sources..."
mkdir src/
find FLEX/Classes -type f \( -name "*.h" -o -name "*.m" \) -exec cp {} src/ \;

echo "Copying DKFLEXLoader..."
cp DKFLEXLoader/{DKFLEXLoader.h,DKFLEXLoader.m} src/

BIN_NAME="libFLEX.dylib"
IOS_VERSION_MIN=7.1

SDK_ROOT_OS=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
SDK_ROOT_SIMULATOR=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk

ARCHS="i386 x86_64 armv7 armv7s arm64"

INPUT=`find src -type f -name "*.m"`

for ARCH in ${ARCHS}
do
	DIR=bin/${ARCH}
	mkdir -p ${DIR}
	echo "Building for ${ARCH}..."
	if [[ "${ARCH}" == "i386" || "${ARCH}" == "x86_64" ]];
	then
		SDK_ROOT=${SDK_ROOT_SIMULATOR}
		IOS_VERSION_MIN_FLAG=-mios-simulator-version-min
	else
		SDK_ROOT=${SDK_ROOT_OS}
		IOS_VERSION_MIN_FLAG=-mios-version-min
	fi
		FRAMEWORKS=${SDK_ROOT}/System/Library/Frameworks/
		INCLUDES=${SDK_ROOT}/usr/include/

		clang -I${INCLUDES} -F${FRAMEWORKS} -dynamiclib -isysroot ${SDK_ROOT} -arch ${ARCH} -fobjc-arc ${IOS_VERSION_MIN_FLAG}=${IOS_VERSION_MIN} -framework Foundation -framework UIKit -framework CoreGraphics ${INPUT} -o ${DIR}/${BIN_NAME}
done

echo "Creating universal binary..."
FAT_BIN_DIR="bin/universal"
mkdir -p ${FAT_BIN_DIR}
lipo -create bin/**/${BIN_NAME} -output ${FAT_BIN_DIR}/${BIN_NAME}

echo "Done."