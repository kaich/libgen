LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_CFLAGS :=

LOCAL_MODULE    := libpng
LOCAL_SRC_FILES :=\
	adler32.c \
	compress.c \
	crc32.c \
	deflate.c \
	example.c \
	gzclose.c \
	gzlib.c \
	gzread.c \
	gzwrite.c \
	infback.c \
	inffast.c \
	inflate.c \
	inftrees.c \
	png.c \
	pngerror.c \
	pngget.c \
	pngmem.c \
	pngpread.c \
	pngread.c \
	pngrio.c \
	pngrtran.c \
	pngrutil.c \
	pngset.c \
	pngtest.c \
	pngtrans.c \
	pngwio.c \
	pngwrite.c \
	pngwtran.c \
	pngwutil.c \
	trees.c \
	uncompr.c \
	zutil.c  \
	arm/filter_neon_intrinsics.c \
	arm/palette_neon_intrinsics.c \
	arm/arm_init.c

#LOCAL_SHARED_LIBRARIES := -lz
LOCAL_EXPORT_LDLIBS := -lz
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/.

include $(BUILD_SHARED_LIBRARY)
# include $(BUILD_STATIC_LIBRARY)
