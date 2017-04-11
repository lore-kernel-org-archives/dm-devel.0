From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 4/5] init: add support to directly boot to a mapped device
Date: Tue, 11 Apr 2017 17:33:43 +0200
Message-ID: <20170411153344.27092-5-enric.balletbo@collabora.com>
References: <20170411153344.27092-1-enric.balletbo@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170411153344.27092-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Will Drewry <wad@chromium.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Will Drewry <wad@chromium.org>

Add a dm= kernel parameter modeled after the md= parameter from
do_mounts_md. It allows for device-mapper targets to be configured at
boot time for use early in the boot process (as the root device or
otherwise).

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 Documentation/admin-guide/kernel-parameters.rst |   1 +
 Documentation/admin-guide/kernel-parameters.txt |   3 +
 Documentation/device-mapper/boot.txt            |  42 +++
 init/Makefile                                   |   1 +
 init/do_mounts.c                                |   1 +
 init/do_mounts.h                                |  10 +
 init/do_mounts_dm.c                             | 478 ++++++++++++++++++++++++
 7 files changed, 536 insertions(+)
 create mode 100644 Documentation/device-mapper/boot.txt
 create mode 100644 init/do_mounts_dm.c

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index b516164..ecb58d6 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -91,6 +91,7 @@ parameter is applicable::
 	BLACKFIN Blackfin architecture is enabled.
 	CLK	Common clock infrastructure is enabled.
 	CMA	Contiguous Memory Area support is enabled.
+	DM	Device mapper support is enabled.
 	DRM	Direct Rendering Management support is enabled.
 	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2ba45ca..686453d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -830,6 +830,9 @@
 
 	dis_ucode_ldr	[X86] Disable the microcode loader.
 
+	dm=		[DM] Allows early creation of a device-mapper device.
+			See Documentation/device-mapper/boot.txt.
+
 	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
 			this option disables the debugging code at boot.
 
diff --git a/Documentation/device-mapper/boot.txt b/Documentation/device-mapper/boot.txt
new file mode 100644
index 0000000..76ea6ac
--- /dev/null
+++ b/Documentation/device-mapper/boot.txt
@@ -0,0 +1,42 @@
+Boot time creation of mapped devices
+===================================
+
+It is possible to configure a device mapper device to act as the root
+device for your system in two ways.
+
+The first is to build an initial ramdisk which boots to a minimal
+userspace which configures the device, then pivot_root(8) in to it.
+
+For simple device mapper configurations, it is possible to boot directly
+using the following kernel command line:
+
+dm="<name> <uuid> <ro>,table line 1,...,table line n"
+
+name = the name to associate with the device
+	after boot, udev, if used, will use that name to label
+	the device node.
+uuid = may be 'none' or the UUID desired for the device.
+ro = may be 'ro' or 'rw'.  If 'ro', the device and device table will be
+	marked read-only.
+
+Each table line may be as normal when using the dmsetup tool except for
+two variations:
+1. Any use of commas will be interpreted as a newline
+2. Quotation marks cannot be escaped and cannot be used without
+   terminating the dm= argument.
+
+Unless renamed by udev, the device node created will be dm-0 as the
+first minor number for the device-mapper is used during early creation.
+
+Example
+=======
+
+- Booting to a linear array made up of user-mode linux block devices:
+
+  dm="lroot none 0, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" \
+  root=/dev/dm-0
+
+Will boot to a rw dm-linear target of 8192 sectors split across two
+block devices identified by their major:minor numbers.  After boot, udev
+will rename this target to /dev/mapper/lroot (depending on the rules).
+No uuid was assigned.
diff --git a/init/Makefile b/init/Makefile
index c4fb455..30424d7 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -20,6 +20,7 @@ mounts-y			:= do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
 mounts-$(CONFIG_BLK_DEV_INITRD)	+= do_mounts_initrd.o
 mounts-$(CONFIG_BLK_DEV_MD)	+= do_mounts_md.o
+mounts-$(CONFIG_BLK_DEV_DM)	+= do_mounts_dm.o
 
 # dependencies on generated files need to be listed explicitly
 $(obj)/version.o: include/generated/compile.h
diff --git a/init/do_mounts.c b/init/do_mounts.c
index c2de510..8b9182b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -566,6 +566,7 @@ void __init prepare_namespace(void)
 	wait_for_device_probe();
 
 	md_run_setup();
+	dm_run_setup();
 
 	if (saved_root_name[0]) {
 		root_device_name = saved_root_name;
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 067af1d..ecb2757 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -74,3 +74,13 @@ void md_run_setup(void);
 static inline void md_run_setup(void) {}
 
 #endif
+
+#ifdef CONFIG_BLK_DEV_DM
+
+void dm_run_setup(void);
+
+#else
+
+static inline void dm_run_setup(void) {}
+
+#endif
diff --git a/init/do_mounts_dm.c b/init/do_mounts_dm.c
new file mode 100644
index 0000000..54c3299
--- /dev/null
+++ b/init/do_mounts_dm.c
@@ -0,0 +1,478 @@
+/* do_mounts_dm.c
+ * Copyright (C) 2010 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ * Based on do_mounts_md.c
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/async.h>
+#include <linux/ctype.h>
+#include <linux/device-mapper.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+
+#include "do_mounts.h"
+
+#define DM_MAX_DEVICES 256
+#define DM_MAX_TARGETS 256
+#define DM_MAX_NAME 32
+#define DM_MAX_UUID 129
+#define DM_NO_UUID "none"
+
+#define DM_MSG_PREFIX "init"
+
+/* Separators used for parsing the dm= argument. */
+#define DM_FIELD_SEP " "
+#define DM_LINE_SEP ","
+#define DM_ANY_SEP DM_FIELD_SEP DM_LINE_SEP
+
+/*
+ * When the device-mapper and any targets are compiled into the kernel
+ * (not a module), one or more device-mappers may be created and used
+ * as the root device at boot time with the parameters given with the
+ * boot line dm=...
+ *
+ * Multiple device-mappers can be stacked specifying the number of
+ * devices. A device can have multiple targets if the the number of
+ * targets is specified.
+ *
+ * In the future, the <num> field will be mandatory.
+ *
+ * <device>        ::= [<num>] <device-mapper>+
+ * <device-mapper> ::= <head> "," <target>+
+ * <head>          ::= <name> <uuid> <mode> [<num>]
+ * <target>        ::= <start> <length> <type> <options> ","
+ * <mode>          ::= "ro" | "rw"
+ * <uuid>          ::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | "none"
+ * <type>          ::= "verity" | "bootcache" | ...
+ *
+ * Example:
+ * 2 vboot none ro 1,
+ *     0 1768000 bootcache
+ *       device=aa55b119-2a47-8c45-946a-5ac57765011f+1
+ *       signature=76e9be054b15884a9fa85973e9cb274c93afadb6
+ *       cache_start=1768000 max_blocks=100000 size_limit=23 max_trace=20000,
+ *   vroot none ro 1,
+ *     0 1740800 verity payload=254:0 hashtree=254:0 hashstart=1740800 alg=sha1
+ *       root_hexdigest=76e9be054b15884a9fa85973e9cb274c93afadb6
+ *       salt=5b3549d54d6c7a3837b9b81ed72e49463a64c03680c47835bef94d768e5646fe
+ *
+ * Notes:
+ *  1. uuid is a label for the device and we set it to "none".
+ *  2. The <num> field will be optional initially and assumed to be 1.
+ *     Once all the scripts that set these fields have been set, it will
+ *     be made mandatory.
+ */
+
+struct dm_setup_target {
+	sector_t begin;
+	sector_t length;
+	char *type;
+	char *params;
+	/* simple singly linked list */
+	struct dm_setup_target *next;
+};
+
+struct dm_device {
+	int minor;
+	int ro;
+	char name[DM_MAX_NAME];
+	char uuid[DM_MAX_UUID];
+	unsigned long num_targets;
+	struct dm_setup_target *target;
+	int target_count;
+	struct dm_device *next;
+};
+
+struct dm_option {
+	char *start;
+	char *next;
+	size_t len;
+	char delim;
+};
+
+static struct {
+	unsigned long num_devices;
+	char *str;
+} dm_setup_args __initdata;
+
+static int __initdata dm_early_setup;
+
+static int __init get_dm_option(struct dm_option *opt, const char *accept)
+{
+	char *str = opt->next;
+	char *endp;
+
+	if (!str)
+		return 0;
+
+	str = skip_spaces(str);
+	opt->start = str;
+	endp = strpbrk(str, accept);
+	if (!endp) {  /* act like strchrnul */
+		opt->len = strlen(str);
+		endp = str + opt->len;
+	} else {
+		opt->len = endp - str;
+	}
+	opt->delim = *endp;
+	if (*endp == 0) {
+		/* Don't advance past the nul. */
+		opt->next = endp;
+	} else {
+		opt->next = endp + 1;
+	}
+	return opt->len != 0;
+}
+
+static int __init dm_setup_cleanup(struct dm_device *devices)
+{
+	struct dm_device *dev = devices;
+
+	while (dev) {
+		struct dm_device *old_dev = dev;
+		struct dm_setup_target *target = dev->target;
+
+		while (target) {
+			struct dm_setup_target *old_target = target;
+
+			kfree(target->type);
+			kfree(target->params);
+			target = target->next;
+			kfree(old_target);
+			dev->target_count--;
+		}
+		BUG_ON(dev->target_count);
+		dev = dev->next;
+		kfree(old_dev);
+	}
+	return 0;
+}
+
+static char * __init dm_parse_device(struct dm_device *dev, char *str)
+{
+	struct dm_option opt;
+	size_t len;
+
+	/* Grab the logical name of the device to be exported to udev */
+	opt.next = str;
+	if (!get_dm_option(&opt, DM_FIELD_SEP)) {
+		DMERR("failed to parse device name");
+		goto parse_fail;
+	}
+	len = min(opt.len + 1, sizeof(dev->name));
+	strlcpy(dev->name, opt.start, len);  /* includes nul */
+
+	/* Grab the UUID value or "none" */
+	if (!get_dm_option(&opt, DM_FIELD_SEP)) {
+		DMERR("failed to parse device uuid");
+		goto parse_fail;
+	}
+	len = min(opt.len + 1, sizeof(dev->uuid));
+	strlcpy(dev->uuid, opt.start, len);
+
+	/* Determine if the table/device will be read only or read-write */
+	get_dm_option(&opt, DM_ANY_SEP);
+	if (!strncmp("ro", opt.start, opt.len)) {
+		dev->ro = 1;
+	} else if (!strncmp("rw", opt.start, opt.len)) {
+		dev->ro = 0;
+	} else {
+		DMERR("failed to parse table mode");
+		goto parse_fail;
+	}
+
+	/* Optional number field */
+	if (opt.delim == DM_FIELD_SEP[0]) {
+		if (!get_dm_option(&opt, DM_LINE_SEP))
+			return NULL;
+		if (kstrtoul(opt.start, 10, &dev->num_targets))
+			dev->num_targets = 1;
+	} else {
+		dev->num_targets = 1;
+	}
+	if (dev->num_targets > DM_MAX_TARGETS) {
+		DMERR("too many targets %lu > %d",
+		      dev->num_targets, DM_MAX_TARGETS);
+	}
+	return opt.next;
+
+parse_fail:
+	return NULL;
+}
+
+static char * __init dm_parse_targets(struct dm_device *dev, char *str)
+{
+	struct dm_option opt;
+	struct dm_setup_target **target = &dev->target;
+	unsigned long num_targets = dev->num_targets;
+	unsigned long i;
+
+	/* Targets are defined as per the table format but with a
+	 * comma as a newline separator.
+	 */
+	opt.next = str;
+	for (i = 0; i < num_targets; i++) {
+		*target = kzalloc(sizeof(*target), GFP_KERNEL);
+		if (!*target) {
+			DMERR("failed to allocate memory for target %s<%ld>",
+			      dev->name, i);
+			goto parse_fail;
+		}
+		dev->target_count++;
+
+		if (!get_dm_option(&opt, DM_FIELD_SEP)) {
+			DMERR("failed to parse starting sector"
+			      " for target %s<%ld>", dev->name, i);
+			goto parse_fail;
+		}
+
+		if (kstrtoull(opt.start, 10, &(*target)->begin))
+			goto parse_fail;
+
+		if (!get_dm_option(&opt, DM_FIELD_SEP)) {
+			DMERR("failed to parse length for target %s<%ld>",
+			      dev->name, i);
+			goto parse_fail;
+		}
+
+		if (kstrtoull(opt.start, 10, &(*target)->length))
+			goto parse_fail;
+
+		if (get_dm_option(&opt, DM_FIELD_SEP))
+			(*target)->type = kstrndup(opt.start, opt.len,
+						   GFP_KERNEL);
+		if (!((*target)->type)) {
+			DMERR("failed to parse type for target %s<%ld>",
+			      dev->name, i);
+			goto parse_fail;
+		}
+		if (get_dm_option(&opt, DM_LINE_SEP))
+			(*target)->params = kstrndup(opt.start, opt.len,
+						     GFP_KERNEL);
+		if (!((*target)->params)) {
+			DMERR("failed to parse params for target %s<%ld>",
+			      dev->name, i);
+			goto parse_fail;
+		}
+		target = &((*target)->next);
+	}
+	DMDEBUG("parsed %d targets", dev->target_count);
+
+	return opt.next;
+
+parse_fail:
+	return NULL;
+}
+
+static struct dm_device * __init dm_parse_args(void)
+{
+	struct dm_device *devices = NULL;
+	struct dm_device **tail = &devices;
+	struct dm_device *dev;
+	char *str = dm_setup_args.str;
+	unsigned long num_devices = dm_setup_args.num_devices;
+	unsigned long i;
+
+	if (!str)
+		return NULL;
+	for (i = 0; i < num_devices; i++) {
+		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+		if (!dev) {
+			DMERR("failed to allocated memory for dev");
+			goto error;
+		}
+		*tail = dev;
+		tail = &dev->next;
+		/*
+		 * devices are given minor numbers 0 - n-1
+		 * in the order they are found in the arg
+		 * string.
+		 */
+		dev->minor = i;
+		str = dm_parse_device(dev, str);
+		if (!str)	/* NULL indicates error in parsing, bail */
+			goto error;
+
+		str = dm_parse_targets(dev, str);
+		if (!str)
+			goto error;
+	}
+	return devices;
+error:
+	dm_setup_cleanup(devices);
+	return NULL;
+}
+
+/*
+ * Parse the command-line parameters given our kernel, but do not
+ * actually try to invoke the DM device now; that is handled by
+ * dm_setup_drives after the low-level disk drivers have initialised.
+ * dm format is described at the top of the file.
+ *
+ * Because dm minor numbers are assigned in assending order starting with 0,
+ * You can assume the first device is /dev/dm-0, the next device is /dev/dm-1,
+ * and so forth.
+ */
+static int __init dm_setup(char *str)
+{
+	struct dm_option opt;
+	unsigned long num_devices;
+
+	if (!str) {
+		DMDEBUG("str is NULL");
+		goto parse_fail;
+	}
+	opt.next = str;
+	if (!get_dm_option(&opt, DM_FIELD_SEP))
+		goto parse_fail;
+	if (isdigit(opt.start[0])) {	/* Optional number field */
+		if (kstrtoul(opt.start, 10, &num_devices))
+			num_devices = 1;
+		str = opt.next;
+	} else {
+		num_devices = 1;
+		/* Don't advance str */
+	}
+	if (num_devices > DM_MAX_DEVICES) {
+		DMDEBUG("too many devices %lu > %d",
+			num_devices, DM_MAX_DEVICES);
+	}
+	dm_setup_args.str = str;
+	dm_setup_args.num_devices = num_devices;
+	DMINFO("will configure %lu devices", num_devices);
+	dm_early_setup = 1;
+	return 1;
+
+parse_fail:
+	DMWARN("Invalid arguments supplied to dm=.");
+	return 0;
+}
+
+static void __init dm_setup_drives(void)
+{
+	struct mapped_device *md = NULL;
+	struct dm_table *table = NULL;
+	struct dm_setup_target *target;
+	struct dm_device *dev;
+	char *uuid;
+	fmode_t fmode = FMODE_READ;
+	struct dm_device *devices;
+
+	devices = dm_parse_args();
+
+	for (dev = devices; dev; dev = dev->next) {
+		if (dm_create(dev->minor, &md)) {
+			DMDEBUG("failed to create the device");
+			goto dm_create_fail;
+		}
+		DMDEBUG("created device '%s'", dm_device_name(md));
+
+		/*
+		 * In addition to flagging the table below, the disk must be
+		 * set explicitly ro/rw.
+		 */
+		set_disk_ro(dm_disk(md), dev->ro);
+
+		if (!dev->ro)
+			fmode |= FMODE_WRITE;
+		if (dm_table_create(&table, fmode, dev->target_count, md)) {
+			DMDEBUG("failed to create the table");
+			goto dm_table_create_fail;
+		}
+
+		dm_lock_md_type(md);
+
+		for (target = dev->target; target; target = target->next) {
+			DMINFO("adding target '%llu %llu %s %s'",
+			       (unsigned long long) target->begin,
+			       (unsigned long long) target->length,
+			       target->type, target->params);
+			if (dm_table_add_target(table, target->type,
+						target->begin,
+						target->length,
+						target->params)) {
+				DMDEBUG("failed to add the target"
+					" to the table");
+				goto add_target_fail;
+			}
+		}
+		if (dm_table_complete(table)) {
+			DMDEBUG("failed to complete the table");
+			goto table_complete_fail;
+		}
+
+		/* Suspend the device so that we can bind it to the table. */
+		if (dm_suspend(md, 0)) {
+			DMDEBUG("failed to suspend the device pre-bind");
+			goto suspend_fail;
+		}
+
+		/* Initial table load: acquire type of table. */
+		dm_set_md_type(md, dm_table_get_type(table));
+
+		/* Setup md->queue to reflect md's type. */
+		if (dm_setup_md_queue(md, table)) {
+			DMWARN("unable to set up device queue for new table.");
+			goto setup_md_queue_fail;
+		}
+
+		/*
+		 * Bind the table to the device. This is the only way
+		 * to associate md->map with the table and set the disk
+		 * capacity directly.
+		 */
+		if (dm_swap_table(md, table)) {  /* should return NULL. */
+			DMDEBUG("failed to bind the device to the table");
+			goto table_bind_fail;
+		}
+
+		/* Finally, resume and the device should be ready. */
+		if (dm_resume(md)) {
+			DMDEBUG("failed to resume the device");
+			goto resume_fail;
+		}
+
+		/* Export the dm device via the ioctl interface */
+		if (!strcmp(DM_NO_UUID, dev->uuid))
+			uuid = NULL;
+		if (dm_ioctl_export(md, dev->name, uuid)) {
+			DMDEBUG("failed to export device with given"
+				" name and uuid");
+			goto export_fail;
+		}
+
+		dm_unlock_md_type(md);
+
+		DMINFO("dm-%d is ready", dev->minor);
+	}
+	dm_setup_cleanup(devices);
+	return;
+
+export_fail:
+resume_fail:
+table_bind_fail:
+setup_md_queue_fail:
+suspend_fail:
+table_complete_fail:
+add_target_fail:
+	dm_unlock_md_type(md);
+	dm_table_destroy(table);
+dm_table_create_fail:
+	dm_put(md);
+dm_create_fail:
+	DMWARN("starting dm-%d (%s) failed",
+	       dev->minor, dev->name);
+	dm_setup_cleanup(devices);
+}
+
+__setup("dm=", dm_setup);
+
+void __init dm_run_setup(void)
+{
+	if (!dm_early_setup)
+		return;
+	DMINFO("attempting early device configuration.");
+	dm_setup_drives();
+}
-- 
2.9.3
