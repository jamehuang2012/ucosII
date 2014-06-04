#
# This file contains rules which are shared between multiple Makefiles.
#

#
# False targets.
#
.PHONY: dummy

#
# Special variables which should not be exported
#
unexport EXTRA_AFLAGS
unexport EXTRA_CFLAGS
unexport EXTRA_LDFLAGS
unexport EXTRA_ARFLAGS
unexport SUBDIRS
unexport SUB_DIRS
unexport ALL_SUB_DIRS
unexport MOD_SUB_DIRS
unexport O_TARGET
unexport ALL_MOBJS

unexport obj-y
unexport obj-m
unexport obj-n
unexport obj-
unexport export-objs
unexport subdir-y
unexport subdir-m
unexport subdir-n
unexport subdir-

#
# Get things started.
#
first_rule: sub_dirs
	$(MAKE) all_targets

both-m          := $(filter $(mod-subdirs), $(subdir-y))
SUB_DIRS	:= $(subdir-y)
MOD_SUB_DIRS	:= $(sort $(subdir-m) $(both-m))
ALL_SUB_DIRS	:= $(sort $(subdir-y) $(subdir-m) $(subdir-n) $(subdir-))


#
# Common rules
#

%.s: %.c
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@) -S $< -o $@

%.i: %.c
	$(CPP) $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@) $< > $@

%.o: %.c
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@) -c -o $@ $<
	@ ( \
	    echo 'ifeq ($(strip $(subst $(comma),:,$(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@))),$$(strip $$(subst $$(comma),:,$$(CFLAGS) $$(EXTRA_CFLAGS) $$(CFLAGS_$@))))' ; \
	    echo 'FILES_FLAGS_UP_TO_DATE += $@' ; \
	    echo 'endif' \
	) > $(dir $@)/.$(notdir $@).flags

%.o: %.s
	$(AS) $(AFLAGS) $(EXTRA_CFLAGS) -o $@ $<

%.s: %.S
	$(CPP) $(AFLAGS) $(EXTRA_AFLAGS) $(AFLAGS_$@) $< > $@

%.o: %.S
	$(CC) $(AFLAGS) $(EXTRA_AFLAGS) $(AFLAGS_$@) -c -o $@ $<

#
all_targets: $(O_TARGET) $(L_TARGET)

#
# Rule to compile a set of .o files into one .o file
#
ifdef O_TARGET
$(O_TARGET): $(obj-y)
	rm -f $@
    ifneq "$(strip $(obj-y))" ""
	$(LD) $(EXTRA_LDFLAGS) -r -o $@ $(filter $(obj-y), $^)
    else
	$(AR) rcs $@
    endif
	@ ( \
	    echo 'ifeq ($(strip $(subst $(comma),:,$(EXTRA_LDFLAGS) $(obj-y))),$$(strip $$(subst $$(comma),:,$$(EXTRA_LDFLAGS) $$(obj-y))))' ; \
	    echo 'FILES_FLAGS_UP_TO_DATE += $@' ; \
	    echo 'endif' \
	) > $(dir $@)/.$(notdir $@).flags
endif # O_TARGET

#
# Rule to compile a set of .o files into one .a file
#
ifdef L_TARGET
$(L_TARGET): $(obj-y)
	rm -f $@
	$(AR) $(EXTRA_ARFLAGS) rcs $@ $(obj-y)
	@ ( \
	    echo 'ifeq ($(strip $(subst $(comma),:,$(EXTRA_ARFLAGS) $(obj-y))),$$(strip $$(subst $$(comma),:,$$(EXTRA_ARFLAGS) $$(obj-y))))' ; \
	    echo 'FILES_FLAGS_UP_TO_DATE += $@' ; \
	    echo 'endif' \
	) > $(dir $@)/.$(notdir $@).flags
endif

subdir-list = $(sort $(patsubst %,_subdir_%,$(SUB_DIRS)))
sub_dirs: dummy $(subdir-list)

ifdef SUB_DIRS
$(subdir-list) : dummy
	$(MAKE) -C $(patsubst _subdir_%,%,$@)
endif

#
# A rule to make modules
#


ifneq ($(wildcard .depend),)
include .depend
endif

ifneq ($(wildcard $(TOPDIR)/.hdepend),)
include $(TOPDIR)/.hdepend
endif
