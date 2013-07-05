# Compatibility configuration for Linux on ARM.
# Included by core/combo/TARGET_linux-arm.mk

# This is intended to set compatiblity compiler flags
# for some difficult devices so that we may otherwise
# globally keep the all optimizations globally enabled
#

# Only set -O3 for thumb cflags if explicitly specified
ifeq ($(ARCH_ARM_HIGH_OPTIMIZATION),true)
    TARGET_thumb_CFLAGS := -O3
else
    TARGET_thumb_CFLAGS := -Os
endif

# A clean way of only disabling a few optimizations that
# cause problems on devices such as Grouper
ifeq ($(ARCH_ARM_HIGH_OPTIMIZATION_COMPAT),true)
    TARGET_arm_CFLAGS :=    -fno-tree-vectorize \
                            -fno-aggressive-loop-optimizations

    TARGET_thumb_CFLAGS :=  -fno-tree-vectorize \
                            -fno-aggressive-loop-optimizations

endif

# Use -O2 for TARGET_arm_CFLAGS for the following devices due to
# "problem" modules until they're discovered
ifneq ($(filter m7att m7spr m7tmo m7wls,$(PRODUCT_DEVICE)),)
    TARGET_arm_CFLAGS := -O2
else
    ifeq ($(TARGET_BUILD_SMALL_SYSTEM),true)
        TARGET_arm_CFLAGS := -O2
    else
        TARGET_arm_CFLAGS := -O3
    endif
endif

# Turn off strict-aliasing if we're building an AOSP variant without the
# patchset...
ifeq ($(DEBUG_NO_STRICT_ALIASING),yes)
TARGET_arm_CFLAGS += -fno-strict-aliasing -Wno-error=strict-aliasing
TARGET_thumb_CFLAGS += -fno-strict-aliasing -Wno-error=strict-aliasing
endif

# Do not use ISOC++11 mode with gnuism support if we're building on an
# AOSP variant without the patchset
TARGET_GLOBAL_CPPFLAGS += -fvisibility-inlines-hidden
ifneq ($(DEBUG_NO_STDCXX11),yes)
TARGET_GLOBAL_CPPFLAGS += $(call cc-option,-std=gnu++11)
endif

