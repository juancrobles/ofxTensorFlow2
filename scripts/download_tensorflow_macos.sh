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

TF_X86_64_URL=https://storage.googleapis.com/tensorflow/libtensorflow/
TF_X86_64_FILE=libtensorflow-${TYPE}-${OS}-${ARCH}-${VER}.${EXT}

TFMETAL_X86_64_URL=https://files.pythonhosted.org/packages/7f/17/a2a2ac269e00032b722efbbbee2924f77d93857f2773edded9829faeeaec/
TFMETAL_X86_64_FILE=tensorflow_metal-0.5.1-cp310-cp310-macosx_12_0_x86_64.whl

TF_ARM64_URL=https://files.pythonhosted.org/packages/77/29/b3a46ade07623f29d64cb43433aa1c6ba2bfe7419daee76f0cc9a6f7213a/
TF_ARM64_FILE=tensorflow_macos-2.13.0-cp310-cp310-macosx_12_0_arm64.whl

TFMETAL_ARM64_URL=https://files.pythonhosted.org/packages/f3/3d/0796dda099a84e166aacb493f8a161c8816175e514e79012b940364787d4/
TFMETAL_ARM64_FILE=tensorflow_metal-1.0.1-cp310-cp310-macosx_12_0_arm64.whl

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
# unzip -o downloads/${TF_X86_64_FILE} tensorflow/libtensorflow_framework.dylib tensorflow/include/tensorflow* -d $DEST/x86_64
tar -xvf downloads/${TF_X86_64_FILE} -C libs/$SRC

unzip -o downloads/${TFMETAL_X86_64_FILE} tensorflow-plugins/libmetal_plugin.dylib -d $DEST/x86_64

echo "extracting tensorflow arm64 libraries"
unzip -o downloads/${TF_ARM64_FILE} tensorflow/libtensorflow_framework.2.dylib tensorflow/libtensorflow_cc.2.dylib tensorflow/include/tensorflow* -d $DEST/arm64

unzip -o downloads/${TFMETAL_ARM64_FILE} tensorflow-plugins/libmetal_plugin.dylib -d $DEST/arm64

# copy libmetal python dependencies
unzip -o downloads/${TF_ARM64_FILE} tensorflow/python/_pywrap_tensorflow_internal.so -d $DEST/python

unzip -o downloads/${TF_ARM64_FILE} tensorflow/tsl/python/lib/core/libbfloat16.so.so -d $DEST/python

# copy x86_64 libraries for compatibility

# Using TensorFlow package
# create dirs 
mkdir -p $DEST2/lib

# copy licenses
cp -f libs/$SRC/LICENSE $DEST2/
cp -f libs/$SRC/THIRD_PARTY_TF_C_LICENSES $DEST2/

# copy headers
cp -Rf libs/$SRC/include $DEST2/

# copy libs to subdir using OF OS naming so ProjectGenerator finds them
mkdir -p $DEST2/lib/${OF_OS}
cp -Rf libs/${SRC}/lib/* $DEST2/lib/${OF_OS}/

mkdir -p $DEST/x86_64/tensorflow
cp -Rf libs/$SRC/include $DEST/x86_64/tensorflow/include
cp -f libs/$SRC/lib/libtensorflow_framework.2.9.2.dylib $DEST/x86_64/tensorflow/libtensorflow_framework.2.dylib
cp -f libs/$SRC/lib/libtensorflow.2.9.2.dylib $DEST/x86_64/tensorflow/libtensorflow.2.dylib

# arm64
echo $ADDON_DIR
cd $ADDON_DIR
cp -f $DEST/arm64/tensorflow/libtensorflow_cc.2.dylib $DEST/arm64/tensorflow/libtensorflow.2.dylib 
