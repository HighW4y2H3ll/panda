# Note: We will be run from target directory. (build/target)

include ../config-host.mak
include config-devices.mak
include config-target.mak
include $(SRC_PATH)/rules.mak

$(call set-vpath, $(SRC_PATH):$(BUILD_DIR))

PLUGIN_TARGET_DIR=panda/plugins
PLUGIN_OBJ_DIR=panda/plugins/$(PLUGIN_NAME)

PLUGIN_SRC_ROOT=$(SRC_PATH)/panda/plugins
PLUGIN_SRC_DIR=$(PLUGIN_SRC_ROOT)/$(PLUGIN_NAME)

TARGET_PATH=$(SRC_PATH)/target-$(TARGET_BASE_ARCH)

QEMU_CFLAGS+=-DNEED_CPU_H -fPIC
QEMU_CXXFLAGS+=-DNEED_CPU_H -fPIC

QEMU_CXXFLAGS+=-fpermissive -std=c++11

# These are all includes. I think.
QEMU_CFLAGS+=$(GLIB_CFLAGS)
QEMU_CXXFLAGS+=$(GLIB_CFLAGS)

QEMU_INCLUDES+=-I$(BUILD_DIR)/$(TARGET_DIR) -I$(BUILD_DIR)
QEMU_INCLUDES+=-I$(PLUGIN_SRC_DIR) -I$(PLUGIN_SRC_ROOT) -I$(TARGET_PATH)
QEMU_INCLUDES+=-I$(PLUGIN_TARGET_DIR)

# These should get generated automatically and include dependency information.
-include $(wildcard $(PLUGIN_OBJ_DIR)/*.d)

# You can override this recipe by using the full name of the plugin in a
# plugin Makefile. (e.g. $(PLUGIN_TARGET_DIR)/panda_$(PLUGIN_NAME).so).
$(PLUGIN_TARGET_DIR)/panda_%.so:
	$(call quiet-command,$(CXX) $(QEMU_CFLAGS) $(LDFLAGS_SHARED) -o $@ $^ $(LIBS),"  PLUG  $(TARGET_DIR)$@")

all: $(PLUGIN_TARGET_DIR)/panda_$(PLUGIN_NAME).so