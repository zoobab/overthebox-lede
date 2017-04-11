PKG_VERSION:=2.02~rc2
PKG_RELEASE:=1

PKG_SOURCE:=grub-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://alpha.gnu.org/gnu/grub \
	http://gnualpha.uib.no/grub/ \
	http://mirrors.fe.up.pt/pub/gnu-alpha/grub/ \
	http://www.nic.funet.fi/pub/gnu/alpha/gnu/grub/
PKG_HASH:=053bfcbe366733e4f5a1baf4eb15e1efd977225bdd323b78087ce5fa172fc246

PKG_FIXUP:=autoreconf
HOST_BUILD_PARALLEL:=1

PKG_SSP:=0

PKG_FLAGS:=nonshared

PATCH_DIR := ../patches
HOST_PATCH_DIR := ../patches

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/grub2/Default
  CATEGORY:=Boot Loaders
  SECTION:=boot
  TITLE:=GRand Unified Bootloader
  URL:=http://www.gnu.org/software/grub/
  DEPENDS:=@TARGET_x86||TARGET_x86_64
endef

HOST_BUILD_PREFIX := $(STAGING_DIR_HOST)

CONFIGURE_VARS += \
	grub_build_mkfont_excuse="don't want fonts"

CONFIGURE_ARGS += \
	--target=$(REAL_GNU_TARGET_NAME) \
	--disable-werror \
	--disable-nls \
	--disable-device-mapper \
	--disable-libzfs \
	--disable-grub-mkfont

HOST_CONFIGURE_VARS += \
	grub_build_mkfont_excuse="don't want fonts"

HOST_CONFIGURE_ARGS += \
	--disable-grub-mkfont \
	--target=$(REAL_GNU_TARGET_NAME) \
	--sbindir="$(STAGING_DIR_HOST)/bin" \
	--disable-werror \
	--disable-libzfs \
	--disable-nls

HOST_MAKE_FLAGS += \
	TARGET_RANLIB=$(TARGET_RANLIB) \
	LIBLZMA=$(STAGING_DIR_HOST)/lib/liblzma.a

define Host/Configure
	$(SED) 's,(RANLIB),(TARGET_RANLIB),' $(HOST_BUILD_DIR)/grub-core/Makefile.in
	$(Host/Configure/Default)
endef

