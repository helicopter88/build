# Configuration for Linux on ARM.
# Generating binaries for the ARMv7-a architecture and higher
#
ARCH_ARM_HAVE_THUMB_SUPPORT     := true
ARCH_ARM_HAVE_FAST_INTERWORKING := true
ARCH_ARM_HAVE_64BIT_DATA        := true
ARCH_ARM_HAVE_HALFWORD_MULTIPLY := true
ARCH_ARM_HAVE_CLZ               := true
ARCH_ARM_HAVE_FFS               := true
ARCH_ARM_HAVE_ARMV7A            := true
ARCH_ARM_HAVE_TLS_REGISTER      := true
ARCH_ARM_HAVE_VFP               := true
ifeq ($(TARGET_ARCH_VARIANT_FPU), neon)
ARCH_ARM_HAVE_VFP_D32           := true
ARCH_ARM_HAVE_NEON              := true
endif

mcpu-arg = $(shell sed 's/^-mcpu=//' <<< "$(call cc-option,-mcpu=$(1),-mcpu=$(2))")

ifeq ($(TARGET_CPU_VARIANT), cortex-a15)
TARGET_CPU_VARIANT := $(call mcpu-arg,cortex-a15,cortex-a9)
ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS    := true
ARCH_ARM_NEON_MEMSET_DIVIDER           := 132
#ARCH_ARM_NEON_MEMCPY_ALIGNMENT_DIVIDER := 224
endif
ifeq ($(TARGET_CPU_VARIANT), krait)
TARGET_CPU_VARIANT := $(call mcpu-arg,cortex-a9,cortex-a8)
ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS    := true
ARCH_ARM_NEON_MEMSET_DIVIDER           := 132
ARCH_ARM_NEON_MEMCPY_ALIGNMENT_DIVIDER := 224
endif
ifeq ($(TARGET_CPU_VARIANT), cortex-a9)
TARGET_CPU_VARIANT := $(call mcpu-arg,cortex-a9,cortex-a8)
ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS    := true
ARCH_ARM_NEON_MEMSET_DIVIDER           := 132
ARCH_ARM_NEON_MEMCPY_ALIGNMENT_DIVIDER := 224
endif
ifeq ($(TARGET_CPU_VARIANT), cortex-a8)
TARGET_CPU_VARIANT := $(call mcpu-arg,cortex-a8,)
ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS    := true
ARCH_ARM_NEON_MEMSET_DIVIDER           := 132
ARCH_ARM_NEON_MEMCPY_ALIGNMENT_DIVIDER := 224
endif

# Note: Hard coding the 'tune' value here is probably not ideal,
# and a better solution should be found in the future.
#
arch_variant_cflags := \
    -march=armv7-a \
    -mfloat-abi=softfp

ifneq ($(TARGET_ARCH_VARIANT_FPU), neon)
arch_variant_cflags := \
    -mfpu=vfpv3-d16
endif

ifneq (,$(findstring cpu=cortex-a9,$(TARGET_EXTRA_CFLAGS)))
arch_variant_ldflags := \
        -Wl,--no-fix-cortex-a8
else
arch_variant_ldflags := \
        -Wl,--fix-cortex-a8
endif
