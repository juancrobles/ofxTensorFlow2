#! /bin/sh
#
# script to download pre-built tensorflow C library and metals support from
# * https://pypi.org/project/tensorflow-macos/
# * https://pypi.org/project/tensorflow-metal/
#
# 

# defines for osx x86_64
TYPE=cpu
OS=darwin
ARCH=x86_64
VER=2.9.2
EXT=tar.gz
OF_OS=osx

SRC=libtensorflow
# TF_X86_64_URL=https://files.pythonhosted.org/packages/da/61/e4d2c3426cfc5d2999ed0b16e2cae916936270f6cb35538200e36c6a8ec5/
# TF_X86_64_FILE=tensorflow_macos-2.9.2-cp310-cp310-macosx_11_0_x86_64.whl

# https://files.pythonhosted.org/packages/21/12/58883264d7aa488cd92374c019985378ccfdbe975527975a8040ce4e5be0/tensorflow-2.9.2-cp310-cp310-macosx_10_14_x86_64.whl
# TF_X86_64_URL=https://files.pythonhosted.org/packages/21/12/58883264d7aa488cd92374c019985378ccfdbe975527975a8040ce4e5be0/
# TF_X86_64_FILE=tensorflow-2.9.2-cp310-cp310-macosx_10_14_x86_64.whl

# TF_X86_64_URL=https://storage.googleapis.com/tensorflow/libtensorflow/
# TF_X86_64_FILE=libtensorflow-${TYPE}-${OS}-${ARCH}-${VER}.${EXT}

# TFMETAL_X86_64_URL=https://files.pythonhosted.org/packages/7f/17/a2a2ac269e00032b722efbbbee2924f77d93857f2773edded9829faeeaec/
# TFMETAL_X86_64_FILE=tensorflow_metal-0.5.1-cp310-cp310-macosx_12_0_x86_64.whl

TF_X86_64_URL=https://files.pythonhosted.org/packages/67/4a/a39d10a1f2f3b13bc845a13d7f7f771fa93ee67fc36c697ade5c203727b3/
TF_X86_64_FILE=tensorflow_macos-2.12.0-cp311-cp311-macosx_12_0_x86_64.whl

TFMETAL_X86_64_URL=https://files.pythonhosted.org/packages/20/7f/042d5becc70e9b17fb0f594581a9a288e3c4cb547aae96c8e2e1b1d75f77/
TFMETAL_X86_64_FILE=tensorflow_metal-1.0.0-cp311-cp311-macosx_12_0_x86_64.whl

TF_ARM64_URL=https://files.pythonhosted.org/packages/d2/e6/94748fedae940a7095ac3acb821e613f72513cf9fa8ea0cf6fe734ef8c8f/
TF_ARM64_FILE=tensorflow_macos-2.12.0-cp311-cp311-macosx_12_0_arm64.whl

TFMETAL_ARM64_URL=https://files.pythonhosted.org/packages/dc/db/da1be4108826084af796b27b46b45ca421521f8cce111f1d4ed05b5a6ef3/
TFMETAL_ARM64_FILE=tensorflow_metal-1.0.0-cp311-cp311-macosx_12_0_arm64.whl

DEST=libs
DEST2=libs/tensorflow
ADDON_DIR=`pwd`
mkdir downloads

if [ -f "downloads/${TF_X86_64_FILE}" ] ; then
    echo "${TF_X86_64_FILE} already downloaded"
else
    echo "downloading tensorflow macos x86_64: ${TF_X86_64_URL}${TF_X86_64_FILE}"
    RETCODE=$(curl -L -w "%{http_code}" ${TF_X86_64_URL}${TF_X86_64_FILE} -o downloads/${TF_X86_64_FILE})
    if [ "$RETCODE" != "200" ] ; then
        echo "download failed: HTTP $RETCODE"
        exit 1
    fi
fi

if [ -f "downloads/${TFMETAL_X86_64_FILE}" ] ; then
    echo "${TF_X86_64_FILE} already downloaded"
else
    echo "downloading tensorflow metal x86_64"
    RETCODE=$(curl -L -w "%{http_code}" ${TFMETAL_X86_64_URL}${TFMETAL_X86_64_FILE} -o downloads/${TFMETAL_X86_64_FILE})
    if [ "$RETCODE" != "200" ] ; then
        echo "download failed: HTTP $RETCODE"
        exit 1
    fi
fi

if [ -f "downloads/${TF_ARM64_FILE}" ] ; then
    echo "${TF_X86_64_FILE} already downloaded"
else
    echo "downloading tensorflow macos arm64"
    RETCODE=$(curl -L -w "%{http_code}" ${TF_ARM64_URL}${TF_ARM64_FILE} -o downloads/${TF_ARM64_FILE})
    if [ "$RETCODE" != "200" ] ; then
        echo "download failed: HTTP $RETCODE"
        exit 1
    fi
fi

if [ -f "downloads/${TFMETAL_ARM64_FILE}" ] ; then
    echo "${TF_X86_64_FILE} already downloaded"
else
    echo "downloading tensorflow metal arm64"
    RETCODE=$(curl -L -w "%{http_code}" ${TFMETAL_ARM64_URL}${TFMETAL_ARM64_FILE} -o downloads/${TFMETAL_ARM64_FILE})
    if [ "$RETCODE" != "200" ] ; then
        echo "download failed: HTTP $RETCODE"
        exit 1
    fi
fi

echo "extracting tensorflow x86_64 libraries"
mkdir -p libs/$SRC
## unzip -o downloads/${TF_X86_64_FILE} tensorflow/libtensorflow_framework.dylib tensorflow/include/tensorflow* -d $DEST/x86_64
##tar -xvf downloads/${TF_X86_64_FILE} -C libs/$SRC
# unzip -o downloads/${TF_X86_64_FILE} tensorflow/libtensorflow_framework.2.dylib tensorflow/libtensorflow_cc.2.dylib tensorflow/include/tensorflow* -d $DEST/x86_64

# unzip -o downloads/${TFMETAL_X86_64_FILE} tensorflow-plugins/libmetal_plugin.dylib -d $DEST/x86_64

# unzip -o downloads/${TF_X86_64_FILE} tensorflow/python/_pywrap_tensorflow_internal.so -d $DEST/x86_64/python

# unzip -o downloads/${TF_X86_64_FILE} tensorflow/tsl/python/lib/core/libbfloat16.so.so -d $DEST/x86_64/python

# echo "extracting tensorflow arm64 libraries"
# unzip -o downloads/${TF_ARM64_FILE} tensorflow/libtensorflow_framework.2.dylib tensorflow/libtensorflow_cc.2.dylib tensorflow/include/tensorflow* -d $DEST/arm64

# unzip -o downloads/${TFMETAL_ARM64_FILE} tensorflow-plugins/libmetal_plugin.dylib -d $DEST/arm64

# # copy libmetal python dependencies
# unzip -o downloads/${TF_ARM64_FILE} tensorflow/python/_pywrap_tensorflow_internal.so -d $DEST/arm64/python

# unzip -o downloads/${TF_ARM64_FILE} tensorflow/tsl/python/lib/core/libbfloat16.so.so -d $DEST/arm64/python

## Build xcframeworks
## libtensor_cc
lipo -create $DEST/x86_64/tensorflow/libtensorflow_cc.2.dylib $DEST/arm64/tensorflow/libtensorflow_cc.2.dylib -output $DEST/tensorflow/libtensorflow_cc.2.dylib
lipo -create $DEST/x86_64/tensorflow/libtensorflow_framework.2.dylib $DEST/arm64/tensorflow/libtensorflow_framework.2.dylib -output $DEST/tensorflow/libtensorflow_framework.2.dylib

lipo -create $DEST/x86_64/tensorflow-plugins/libmetal_plugin.dylib $DEST/arm64/tensorflow-plugins/libmetal_plugin.dylib -output $DEST/tensorflow/libmetal_plugin.dylib
lipo -create $DEST/x86_64/python/tensorflow/python/_pywrap_tensorflow_internal.so $DEST/arm64/python/tensorflow/python/_pywrap_tensorflow_internal.so -output $DEST/tensorflow/_pywrap_tensorflow_internal.so

# Copy header files
cp -Rf $DEST/x86_64/tensorflow/include $DEST/tensorflow

#xcodebuild -create-xcframework -library $DEST/x86_64/tensorflow/libtensorflow_cc.2.dylib -headers $DEST/x86_64/tensorflow/include -library $DEST/arm64/tensorflow/libtensorflow_cc.2.dylib -headers $DEST/arm64/tensorflow/include -output $DEST/TensorFlowCC.xcframework


# # copy x86_64 libraries for compatibility


# # Using TensorFlow package
# # create dirs 
# mkdir -p $DEST2/lib

# # copy licenses
# cp -f libs/$SRC/LICENSE $DEST2/
# cp -f libs/$SRC/THIRD_PARTY_TF_C_LICENSES $DEST2/

# # copy headers
# cp -Rf libs/$SRC/include $DEST2/

# # copy libs to subdir using OF OS naming so ProjectGenerator finds them
# mkdir -p $DEST2/lib/${OF_OS}
# cp -Rf libs/${SRC}/lib/* $DEST2/lib/${OF_OS}/

# mkdir -p $DEST/x86_64/tensorflow
# cp -Rf libs/$SRC/include $DEST/x86_64/tensorflow/include
# cp -f libs/$SRC/lib/libtensorflow_framework.2.9.2.dylib $DEST/x86_64/tensorflow/libtensorflow_framework.2.dylib
# cp -f libs/$SRC/lib/libtensorflow.2.9.2.dylib $DEST/x86_64/tensorflow/libtensorflow.2.dylib

# # arm64
# echo $ADDON_DIR
# cd $ADDON_DIR
# cp -f $DEST/arm64/tensorflow/libtensorflow_cc.2.dylib $DEST/arm64/tensorflow/libtensorflow.2.dylib 
