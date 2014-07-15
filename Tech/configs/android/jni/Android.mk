# useful command line for regenerating this stuff
# find . -name "*.h" |sed "s|\.\/\(.*\)\/[A-Za-z0-9_.-]*$|\t\"\1\",|g" |uniq

LOCAL_PATH := $(call my-dir)

# "Engine" relative to jni directory
FITECH_ENGINE_PATH := ../../..

OUTPUT_PATH := $(NDK_APP_OUT)/local/armeabi

FITECH_OUTPUT_PATH := $(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/lib/android

FITECH_DEFINES := -DANDROID -DP_ANDROID -DP_ENGINE

ifeq ($(OPENGL), ES2) 
FITECH_DEFINES := $(FITECH_DEFINES) -DP_OPENGL_ES20
FITECH_OUTPUT_PATH := $(FITECH_OUTPUT_PATH)/ES20
$(info ...Use OpenGL ES2...)
else
FITECH_OUTPUT_PATH := $(FITECH_OUTPUT_PATH)/NOES
endif

ifeq ($(USE_STL), 1) 
FITECH_DEFINES := $(FITECH_DEFINES) -DP_USE_STL
$(info ...Use native STL...)
else
$(info ...No STL support...)
endif

ifeq ($(ENABLE_LOGGING), 1) 
FITECH_DEFINES := $(FITECH_DEFINES) -DP_ENABLE_LOGGING
$(info ...Enable logging...)
else
$(info ...Disable logging...)
endif

ifeq ($(NDK_DEBUG), 1)
CONF_FLAGS := -g -DDEBUG -D_DEBUG -DANDROID_NDK
FITECH_OUTPUT_PATH := $(FITECH_OUTPUT_PATH)_Debug
LIBPNG_OUTPUT_PATH := $(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/libpng/lib/Debug
ZLIB_OUTPUT_PATH := $(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/zlib/lib/Debug
TINYXML_OUTPUT_PATH := $(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/tinyxml/lib/Debug
$(info ...Building debug version...)
else
CONF_FLAGS := -DANDROID_NDK
FITECH_OUTPUT_PATH := $(FITECH_OUTPUT_PATH)_Release
LIBPNG_OUTPUT_PATH := $(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/libpng/lib/Release
ZLIB_OUTPUT_PATH := $(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/zlib/lib/Release
TINYXML_OUTPUT_PATH := $(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/tinyxml/lib/Release
$(info ...Building release version...)
# CONF_FLAGS := -O2  # not a good idea, -O0 is generated by ndk-build
endif

$(FITECH_OUTPUT_PATH):
	mkdir $(subst /,\,$(FITECH_OUTPUT_PATH))

$(ZLIB_OUTPUT_PATH):
	mkdir $(subst /,\,$(ZLIB_OUTPUT_PATH))

$(LIBPNG_OUTPUT_PATH):
	mkdir $(subst /,\,$(LIBPNG_OUTPUT_PATH))

$(TINYXML_OUTPUT_PATH):
	mkdir $(subst /,\,$(TINYXML_OUTPUT_PATH))

FITECH_C_FLAGS := $(FITECH_DEFINES) $(CONF_FLAGS) -fexceptions -frtti

# find sources -name "*.h" |sed "s|\(.*src\)\/.*\$|\$(LOCAL_PATH)/\$(FITECH_ENGINE_PATH)\/\1\/ \\\\|g" |uniq
FITECH_LIBRARY_INCLUDE_PATHS := \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/include

# find 3rdparty -name "*.h" |grep "include\/" |sed "s|\(.*include\)\/.*\$|\$(LOCAL_PATH)/\$(FITECH_ENGINE_PATH)\/\1\/ \\\\|g" |uniq
EXT_LIBRARY_INCLUDE_PATHS := \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/libpng/include/ \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/include \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/include \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/common/tinyxml/include 

FITECH_INCLUDE_PATHS := $(FITECH_LIBRARY_INCLUDE_PATHS) $(EXT_LIBRARY_INCLUDE_PATHS)

include $(CLEAR_VARS)


##################################################################### zlib

include $(CLEAR_VARS)

LOCAL_MODULE := z
LOCAL_CFLAGS := -Werror $(CONF_FLAGS)

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/include

LOCAL_SRC_FILES := \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/adler32.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/compress.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/crc32.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/deflate.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/gzread.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/gzwrite.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/uncompr.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/trees.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/zutil.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/inflate.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/infback.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/inftrees.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/zlib/zlib-1.2.8/inffast.c

include $(BUILD_STATIC_LIBRARY)


##################################################################### png
include $(CLEAR_VARS)

LOCAL_MODULE      := png
LOCAL_MODULE_NAME := libpng
LOCAL_CFLAGS      := -Werror $(CONF_FLAGS)

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/platforms/android/libpng/include/ \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/include/ 

LOCAL_SRC_FILES := \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/png.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngerror.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngget.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngmem.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngpread.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngread.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngrio.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngrtran.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngrutil.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngset.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngtrans.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngwio.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngwrite.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngwtran.c \
$(FITECH_ENGINE_PATH)/3rdparty/common/libpng/libpng-1.4.1/pngwutil.c 

include $(BUILD_STATIC_LIBRARY)

##################################################################### tinyxml

include $(CLEAR_VARS)

LOCAL_MODULE := tinyxml
LOCAL_CFLAGS := -Werror $(CONF_FLAGS)

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/$(FITECH_ENGINE_PATH)/3rdparty/common/tinyxml/include

LOCAL_SRC_FILES := \
$(FITECH_ENGINE_PATH)/3rdparty/common/tinyxml/tinyxml2-master/tinyxml2.cpp

include $(BUILD_STATIC_LIBRARY)


#
###################################################################### foundation
#
include $(CLEAR_VARS)

LOCAL_MODULE := foundation
LOCAL_CFLAGS := $(FITECH_C_FLAGS)
LOCAL_C_INCLUDES := $(FITECH_INCLUDE_PATHS)

# find src/foundation -name "*.cpp" |sed "s|\(^.*\$\)|\$(FITECH_ENGINE_PATH)\/\\1 \\\\|"
LOCAL_SRC_FILES := \
$(FITECH_ENGINE_PATH)/src/foundation/archive/parchivefile.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/collection/parray.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/collection/plist.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/collection/pmap.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/collection/prbtree.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/collection/pset.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/collection/pstring.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/collection/pvariant.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/debug/pabstractlogoutput.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/debug/passert.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/debug/plog.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/debug/plogoutputconsole.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/debug/plogoutputdebug.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/debug/plogoutputfile.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/environment/android/pandroidenvironment.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/environment/android/pjnihelper.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/image/pimage.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/image/pimagepng.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/image/pimagetga.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/parcball.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pbox.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pline.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pinterpolatedvalue.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pmathutility.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pmatrix3x3.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pmatrix4x4.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pplane.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pquaternion.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/prandom.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pvector2.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pvector3.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/math/pvector4.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/memory/pmemorydebugger.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/memory/pmemoryfunction.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/memory/pnew.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/object/pentity.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/object/pobject.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/opengl/es20/pglerror_es20.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/opengl/es20/pglframebuffer_es20.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/opengl/es20/pglrenderbuffer_es20.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/opengl/es20/pglshader_es20.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/opengl/es20/pglstate_es20.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/opengl/es20/pgltexture_es20.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/opengl/es20/pglvertexbuffer_es20.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/parser/ini.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/parser/pini.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/parser/pxmldocument.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/parser/pxmlelement.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/pabstractproperty.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertybool.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertycolor.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertyfloat.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertyint.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertynameindexmap.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertyprojection.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertystring.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertytransform.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertyvector3.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/property/ppropertyvector4.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/stream/pabstractstream.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/stream/pinputstream.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/stream/poutputstream.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/stream/pstreamasset.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/stream/pstreamfile.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/stream/pstreammemory.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/utility/pclock.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/utility/pcolorrgba.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/utility/pconststring.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/utility/pscroller.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/utility/pscrollersnap.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/utility/ptimeline.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/wrapper/android/pandroidasset.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/wrapper/android/pandroidcrt.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/wrapper/android/pandroiddebugutility.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/wrapper/android/pandroiddir.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/wrapper/android/pandroidpath.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/wrapper/android/pandroidtime.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/event/pevent.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/event/peventmanager.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/event/peventparameters.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/event/peventtype.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/gesture/pabstractgesture.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/gesture/pgesturefling.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/gesture/pgesturelongpress.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/gesture/pgesturemanager.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/gesture/pgesturepan.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/gesture/pgesturepinch.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/gesture/pgesturetap.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/pmodule.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/timer/ptimer.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/modules/timer/ptimermanager.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/runtime/pactivity.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/runtime/pcontext.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/runtime/pcontextproperties.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/runtime/pdevice.cpp \
$(FITECH_ENGINE_PATH)/src/foundation/runtime/pinput.cpp 


include $(BUILD_STATIC_LIBRARY)

#
###################################################################### platform
include $(CLEAR_VARS)
#
LOCAL_MODULE := platform
LOCAL_CFLAGS := $(FITECH_C_FLAGS)
LOCAL_C_INCLUDES := $(FITECH_INCLUDE_PATHS)


# find src/platform -name "*.cpp" |sed "s|\(^.*\$\)|\$(FITECH_ENGINE_PATH)\/\\1 \\\\|"

LOCAL_SRC_FILES := \
$(FITECH_ENGINE_PATH)/src/platform/android/pandroidinput.cpp \
$(FITECH_ENGINE_PATH)/src/platform/android/pandroidmain.cpp \
$(FITECH_ENGINE_PATH)/src/platform/android/pandroidpreferences.cpp 
	
include $(BUILD_STATIC_LIBRARY)

###################################################################### output .so
	
all: $(FITECH_OUTPUT_PATH) \
     $(ZLIB_OUTPUT_PATH) \
     $(LIBPNG_OUTPUT_PATH) \
     $(TINYXML_OUTPUT_PATH) \
	platform foundation \
	png z tinyxml 
	cp -f $(OUTPUT_PATH)/libpng.a $(LIBPNG_OUTPUT_PATH)/
	cp -f $(OUTPUT_PATH)/libz.a $(ZLIB_OUTPUT_PATH)/
	cp -f $(OUTPUT_PATH)/libtinyxml.a $(TINYXML_OUTPUT_PATH)/
	cp -f $(OUTPUT_PATH)/libplatform.a $(FITECH_OUTPUT_PATH)/
	cp -f $(OUTPUT_PATH)/libfoundation.a $(FITECH_OUTPUT_PATH)/

clean:
	rm -f $(LIBPNG_OUTPUT_PATH)/libpng.a
	rm -f $(ZLIB_OUTPUT_PATH)/zlib.a
	rm -f $(TINYXML_OUTPUT_PATH)/tinyxml.a
	rm -f $(FITECH_OUTPUT_PATH)/libplatform.a
	rm -f $(FITECH_OUTPUT_PATH)/libfoundation.a


