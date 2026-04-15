ARCHS = arm64
TARGET = iphone:clang:latest:16.5

TWEAK_NAME = dekumenu

$(TWEAK_NAME)_FILES = Tweak.xm UI/MenuView.mm
$(TWEAK_NAME)_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/tweak.mk
