LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
 
prebuilt_stdcxx_PATH :=prebuilts/ndk/current/sources/cxx-stl/gnu-libstdc++

LOCAL_SRC_FILES :=\
$(prebuilt_stdcxx_PATH)/include \
$(prebuilt_stdcxx_PATH)/libs/$(TARGET_CPU_ABI)/include/
 
LOCAL_CPPFLAGS += -frtti
LOCAL_LDFLAGS += -L$(prebuilt_stdcxx_PATH)/libs/$(TARGET_CPU_ABI) -lgnustl_static -lsupc++
 
LOCAL_MODULE := liblive555
 
live555_groupsock := $(wildcard $(LOCAL_PATH)/live/groupsock/*.cpp)
live555_groupsock := $(live555_groupsock:$(LOCAL_PATH)/live/groupsock/%=%)
 
live555_BasicUsageEnvironment := $(wildcard $(LOCAL_PATH)/live/BasicUsageEnvironment/*.cpp)
live555_BasicUsageEnvironment := $(live555_BasicUsageEnvironment:$(LOCAL_PATH)/live/BasicUsageEnvironment/%=%)
 
live555_UsageEnvironment := $(wildcard $(LOCAL_PATH)/live/UsageEnvironment/*.cpp)
live555_UsageEnvironment := $(live555_UsageEnvironment:$(LOCAL_PATH)/live/UsageEnvironment/%=%)
 
live555_liveMedia := $(wildcard $(LOCAL_PATH)/live/liveMedia/*.cpp)
live555_liveMedia := $(live555_liveMedia:$(LOCAL_PATH)/live/liveMedia/%=%)
 
 
LOCAL_SRC_FILES :=\
        $(live555_groupsock:%=live/groupsock/%) \
        $(live555_BasicUsageEnvironment:%=live/BasicUsageEnvironment/%) \
        $(live555_UsageEnvironment:%=live/UsageEnvironment/%) \
        $(live555_liveMedia:%=live/liveMedia/%) \
        live/groupsock/inet.c \
        live/liveMedia/rtcp_from_spec.c

LOCAL_C_INCLUDES += \
        $(LOCAL_PATH)/live/BasicUsageEnvironment/include \
        $(LOCAL_PATH)/live/liveMedia/include \
        $(LOCAL_PATH)/live/BasicUsageEnvironment/include \
        $(LOCAL_PATH)/live/groupsock/include \
        $(LOCAL_PATH)/live/UsageEnvironment/include

LOCAL_SHARED_LIBRARIES := \
        libcutils
 
 
LOCAL_CPPFLAGS += -fexceptions -DLOCALE_NOT_USED=1 -DNULL=0 -DNO_SSTREAM=1 -UIP_ADD_SOURCE_MEMBERSHIP
LOCAL_CPPFLAGS += -lstdc++
 
 
include $(BUILD_SHARED_LIBRARY)
 

include $(CLEAR_VARS)
 
 
LOCAL_SRC_FILES:=\
        live/proxyServer/live555ProxyServer.cpp
 
 
LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/live/BasicUsageEnvironment/include \
        $(LOCAL_PATH)/live/liveMedia/include \
        $(LOCAL_PATH)/live/BasicUsageEnvironment/include \
        $(LOCAL_PATH)/live/groupsock/include \
        $(LOCAL_PATH)/live/UsageEnvironment/include
 
 
LOCAL_MODULE:= rtsp_proxy
 
 
LOCAL_SHARED_LIBRARIES := liblive555
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
 
 
LOCAL_SRC_FILES:=\
        live/mediaServer/live555MediaServer.cpp \
        live/mediaServer/DynamicRTSPServer.cpp
 
LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/live/BasicUsageEnvironment/include \
        $(LOCAL_PATH)/live/liveMedia/include \
        $(LOCAL_PATH)/live/BasicUsageEnvironment/include \
        $(LOCAL_PATH)/live/groupsock/include \
        $(LOCAL_PATH)/live/UsageEnvironment/include
 
 
LOCAL_MODULE:= rtsp_server
 
 
LOCAL_SHARED_LIBRARIES := liblive555
include $(BUILD_EXECUTABLE)
