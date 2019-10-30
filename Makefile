ARCHS = armv7 arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TimeUnlockXI
TimeUnlockXI_FILES = Tweak.xm
TimeUnlockXI_FRAMEWORKS = Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += timeunlockxiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
