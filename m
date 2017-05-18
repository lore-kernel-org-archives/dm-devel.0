From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH v7 1/2] init: add support to directly boot to a mapped device
Date: Thu, 18 May 2017 18:29:10 +0200
Message-ID: <20170518162911.15538-2-enric.balletbo@collabora.com>
References: <20170518162911.15538-1-enric.balletbo@collabora.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170518162911.15538-1-enric.balletbo@collabora.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-Id: dm-devel.ids

From: Will Drewry <wad@chromium.org>

Add a dm= kernel parameter modeled after the md= parameter from
do_mounts_md. It allows for device-mapper targets to be configured at
boot time for use early in the boot process (as the root device or
otherwise).

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
[rework to use dm_ioctl calls]
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 Documentation/admin-guide/kernel-parameters.rst |   1 +
 Documentation/admin-guide/kernel-parameters.txt |   3 +
 Documentation/device-mapper/dm-boot.txt         |  65 ++++
 init/Makefile                                   |   1 +
 init/do_mounts.c                                |   1 +
 init/do_mounts.h                                |  10 +
 init/do_mounts_dm.c                             | 459 ++++++++++++++++++++++++
 7 files changed, 540 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-boot.txt
 create mode 100644 init/do_mounts_dm.c

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index 33b90e27..9de2984 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -93,6 +93,7 @@ parameter is applicable::
 	BLACKFIN Blackfin architecture is enabled.
 	CLK	Common clock infrastructure is enabled.
 	CMA	Contiguous Memory Area support is enabled.
+	DM	Device mapper support is enabled.
 	DRM	Direct Rendering Management support is enabled.
 	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 33a3b54..4415254 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -830,6 +830,9 @@
 
 	dis_ucode_ldr	[X86] Disable the microcode loader.
 
+	dm=		[DM] Allows early creation of a device-mapper device.
+			See Documentation/device-mapper/boot.txt.
+
 	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
 			this option disables the debugging code at boot.
 
diff --git a/Documentation/device-mapper/dm-boot.txt b/Documentation/device-mapper/dm-boot.txt
new file mode 100644
index 0000000..50f08ec
--- /dev/null
+++ b/Documentation/device-mapper/dm-boot.txt
@@ -0,0 +1,65 @@
+Boot time creation of mapped devices
+====================================
+
+It is possible to configure a device mapper device to act as the root
+device for your system in two ways.
+
+The first is to build an initial ramdisk which boots to a minimal
+userspace which configures the device, then pivot_root(8) in to it.
+
+The second is to possible when the device-mapper and any targets are
+compiled into the kernel (not a module), one or more device-mappers may
+be created and used as the root device at boot time with the parameters
+given with the boot line dm=...
+
+The format is specified as a simple string of data separated by commas and
+optionally semi-colons, where:
+ - a comma is used to separate fields like name, uuid, flags and table (specifies
+   one device)
+ - a semi-colon is used to separate devices.
+
+So the format will look like this:
+
+ dm=<dev_name>,<uuid>,<flags>,<table>[,<table>+][;<dev_name>,<uuid>,<flags>,<table>[,<table>+]]+
+
+Where,
+	<dev_name>	::= The device name.
+	<uuid>		::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
+	<flags>		::= "ro" | "rw"
+	<table>		::= <start> <length> <type> <options>
+	<type>		::= "verity" | "bootcache" | ...
+
+The dm line may be as normal when using the dmsetup tool when using the
+--bootformat argument.
+
+Unless renamed by udev, the device node created will be dm-0 as the
+first minor number for the device-mapper is used during early creation.
+
+Examples
+========
+An example of booting to a linear array made up of user-mode linux block
+devices:
+
+  dm="lroot,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" \
+  root=/dev/dm-0
+
+This will boot to a rw dm-linear target of 8192 sectors split across two
+block devices identified by their major:minor numbers.  After boot, udev
+will rename this target to /dev/mapper/lroot (depending on the rules).
+No uuid was assigned.
+
+An example of multiple device-mappers, with the dm="..." contents shown
+here split on multiple lines for readability:
+
+    vboot,,ro,
+      0 1768000 bootcache
+        aa55b119-2a47-8c45-946a-5ac57765011f+1
+        76e9be054b15884a9fa85973e9cb274c93afadb6
+        1768000 100000 23 20000;
+    vroot,,ro,
+      0 1740800 verity 254:0 254:0 1740800 sha1
+        76e9be054b15884a9fa85973e9cb274c93afadb6
+        5b3549d54d6c7a3837b9b81ed72e49463a64c03680c47835bef94d768e5646fe;
+    vram,,rw,
+      0 32768 linear 1:0 0,
+      32768 32768 linear 1:1 0
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
index 282d65b..4e71c29 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -60,3 +60,13 @@ void md_run_setup(void);
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
index 0000000..87c4300
--- /dev/null
+++ b/init/do_mounts_dm.c
@@ -0,0 +1,459 @@
+/*
+ * do_mounts_dm.c
+ * Copyright (C) 2017 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ * Based on do_mounts_md.c
+ *
+ * This file is released under the GPLv2.
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
+#define DM_MAX_NAME 32
+#define DM_MAX_UUID 129
+
+#define DM_MSG_PREFIX "init"
+
+#define is_even(a) (((a) & 1) == 0)
+
+/* See Documentation/device-mapper/dm-boot.txt for dm="..." format details. */
+
+struct target {
+	sector_t start;
+	sector_t length;
+	char *type;
+	char *params;
+	/* simple singly linked list */
+	struct target *next;
+};
+
+struct dm_device {
+	int minor;
+	int ro;
+	char name[DM_MAX_NAME];
+	char uuid[DM_MAX_UUID];
+	struct target *table;
+	int table_count;
+	/* simple singly linked list */
+	struct dm_device *next;
+};
+
+static struct {
+	unsigned long num_devices;
+	char *str;
+} dm_setup_args __initdata;
+
+static int dm_early_setup __initdata;
+
+static void __init *_align(void *ptr, unsigned int a)
+{
+	register unsigned long agn = --a;
+
+	return (void *) (((unsigned long) ptr + agn) & ~agn);
+}
+
+/*
+ * Unescape characters in situ, it replaces all occurrences of "\c"
+ * with 'c'. This is normally used to unescape colons and semi-colons used
+ * in boot format.
+ */
+static char __init *_unescape_char(char *str, const char c)
+{
+	int i = 0, j = 0;
+	int len = strlen(str);
+
+	if (len < 2)
+		return str;
+
+	while (j < len - 1) {
+		if (str[j] == '\\' && str[j + 1] == c) {
+			j = j + 2;
+			str[i++] = c;
+			continue;
+		}
+		str[i++] = str[j++];
+	}
+
+	if (j == len - 1)
+		str[i++] = str[j];
+
+	str[i] = '\0';
+
+	return str;
+}
+
+static void __init dm_setup_cleanup(struct dm_device *devices)
+{
+	struct dm_device *dev = devices;
+
+	while (dev) {
+		struct dm_device *old_dev = dev;
+		struct target *table = dev->table;
+
+		while (table) {
+			struct target *old_table = table;
+
+			kfree(table->type);
+			kfree(table->params);
+			table = table->next;
+			kfree(old_table);
+			dev->table_count--;
+		}
+		WARN_ON(dev->table_count);
+		dev = dev->next;
+		kfree(old_dev);
+	}
+}
+
+/*
+ * Splits a string into tokens ignoring escaped chars
+ *
+ * Updates @s to point after the token, ready for the next call.
+ *
+ * @str: The string to be searched
+ * @c: The character to search for
+ *
+ * Returns:
+ *   The string found or NULL.
+ */
+static char __init *dm_find_unescaped_char(char **str, const char c)
+{
+	char *s = *str;
+	char *p = strchr(*str, c);
+
+	/* loop through all the characters */
+	while (p != NULL) {
+		/* scan backwards through preceding escapes */
+		char *q = p;
+
+		while (q > s && *(q - 1) == '\\')
+			--q;
+		/* even number of escapes so c is a token */
+		if (is_even(p - q)) {
+			*p = '\0';
+			*str = p + 1;
+			return s;
+		}
+		/* else odd escapes so c is escaped, keep going */
+		p = strchr(p + 1, c);
+	}
+
+	if (strlen(*str)) {
+		*str += strlen(*str);
+		return s;
+	}
+
+	return NULL;
+}
+
+static struct target __init *dm_parse_table(struct dm_device *dev, char *str)
+{
+	char type[DM_MAX_TYPE_NAME], *ptr;
+	struct target *table;
+	int n;
+
+	/* trim trailing space */
+	for (ptr = str + strlen(str) - 1; ptr >= str; ptr--)
+		if (!isspace((int) *ptr))
+			break;
+	ptr++;
+	*ptr = '\0';
+
+	/* trim leading space */
+	for (ptr = str; *ptr && isspace((int) *ptr); ptr++)
+		;
+
+	if (!*ptr)
+		return NULL;
+
+	table = kzalloc(sizeof(struct target), GFP_KERNEL);
+	if (!table)
+		return NULL;
+
+	if (sscanf(ptr, "%llu %llu %s %n", &table->start, &table->length,
+		   type, &n) < 3) {
+		DMERR("invalid format of table \"%s\"", str);
+		goto parse_fail;
+	}
+
+	table->type = kstrndup(type, strlen(type), GFP_KERNEL);
+	if (!table->type) {
+		DMERR("invalid type of table");
+		goto parse_fail;
+	}
+
+	ptr += n;
+	table->params = kstrndup(ptr, strlen(ptr), GFP_KERNEL);
+	if (!table->params) {
+		DMERR("invalid params for table");
+		goto parse_fail;
+	}
+
+	dev->table_count++;
+
+	return table;
+
+parse_fail:
+	kfree(table);
+	return NULL;
+}
+
+static int __init dm_parse_device(struct dm_device *dev, char *dev_info)
+{
+	int field = 0;
+	char *str = dev_info, *ptr = dev_info;
+	struct target *table;
+	struct target **tail = &dev->table;
+
+	while ((str = dm_find_unescaped_char(&ptr, ',')) != NULL) {
+		str = _unescape_char(str, ',');
+		switch (field) {
+		case 0: /* set device name */
+			strncpy(dev->name, str, strlen(str));
+			break;
+		case 1: /* set uuid if any */
+			strncpy(dev->uuid, str, strlen(str));
+			break;
+		case 2:
+			/* set as read-only if flags = "ro" | "" */
+			if (!strncmp(str, "ro", strlen(str)) || !strlen(str))
+				dev->ro = 1;
+			else if (!strncmp(str, "rw", strlen(str)))
+				dev->ro = 0;
+			else
+				return -EINVAL;
+			break;
+		default:
+			table = dm_parse_table(dev, str);
+			if (!table)
+				goto parse_fail;
+
+			*tail = table;
+			tail = &table->next;
+
+			break;
+		}
+		field++;
+	}
+
+	if (field < 4)
+		goto parse_fail;
+
+	return 0;
+
+parse_fail:
+	return -EINVAL;
+}
+
+static struct dm_device __init *dm_parse_args(void)
+{
+	struct dm_device *devices = NULL;
+	struct dm_device **tail = &devices;
+	struct dm_device *dev;
+	char *dev_info, *str = dm_setup_args.str;
+
+	while ((dev_info = dm_find_unescaped_char(&str, ';')) != NULL) {
+		dev_info = _unescape_char(dev_info, ';');
+		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+		if (!dev)
+			goto error;
+
+		if (dm_parse_device(dev, dev_info))
+			goto error;
+
+		*tail = dev;
+		tail = &dev->next;
+		/*
+		 * devices are given minor numbers 0 - n-1 in the order they are
+		 * found in the arg string.
+		 */
+		dev->minor = dm_setup_args.num_devices++;
+
+		if (dm_setup_args.num_devices > DM_MAX_DEVICES) {
+			DMERR("too many devices %lu > %d",
+			      dm_setup_args.num_devices, DM_MAX_DEVICES);
+			goto error;
+		}
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
+ * Because dm minor numbers are assigned in ascending order starting with 0,
+ * You can assume the first device is /dev/dm-0, the next device is /dev/dm-1,
+ * and so forth.
+ */
+static int __init dm_setup(char *str)
+{
+	if (!str) {
+		DMERR("Invalid arguments supplied to dm=.");
+		return 0;
+	}
+
+	DMDEBUG("Want to parse \"%s\"", str);
+
+	dm_setup_args.num_devices = 0;
+	dm_setup_args.str = str;
+
+	dm_early_setup = 1;
+
+	return 1;
+}
+
+static char __init *dm_add_target(struct target *table, char *out, char *end)
+{
+	char *out_sp = out;
+	struct dm_target_spec sp;
+	size_t sp_size = sizeof(struct dm_target_spec);
+	int len;
+	char *pt;
+
+	if (strlen(table->type) >= sizeof(sp.target_type)) {
+		DMERR("target type name %s is too long.", table->type);
+		return NULL;
+	}
+
+	sp.status = 0;
+	sp.sector_start = table->start;
+	sp.length = table->length;
+	strncpy(sp.target_type, table->type, sizeof(sp.target_type) - 1);
+	sp.target_type[sizeof(sp.target_type) - 1] = '\0';
+
+	out += sp_size;
+	pt = table->params;
+	len = strlen(table->params);
+
+	if ((out >= end) || (out + len + 1) >= end) {
+		DMERR("ran out of memory building ioctl parameter");
+		return NULL;
+	}
+
+	strcpy(out, table->params);
+	out += len + 1;
+	/* align next block */
+	out = _align(out, 8);
+
+	sp.next = out - out_sp;
+	memcpy(out_sp, &sp, sp_size);
+
+	return out;
+}
+
+static struct dm_ioctl __init *dm_setup_ioctl(struct dm_device *dev, int flags)
+{
+	const size_t min_size = 16 * 1024;
+	size_t len = sizeof(struct dm_ioctl);
+	struct dm_ioctl *dmi;
+	struct target *table = dev->table;
+	char *b, *e;
+
+	if (len < min_size)
+		len = min_size;
+
+	dmi = kzalloc(len, GFP_KERNEL);
+	if (!dmi)
+		return NULL;
+
+	dmi->version[0] = 4;
+	dmi->version[1] = 0;
+	dmi->version[2] = 0;
+	dmi->data_size = len;
+	dmi->data_start = sizeof(struct dm_ioctl);
+	dmi->flags = flags;
+	dmi->dev = dev->minor;
+	dmi->target_count = dev->table_count;
+	dmi->event_nr = 1;
+
+	strncpy(dmi->name, dev->name, sizeof(dmi->name));
+
+	b = (char *) (dmi + 1);
+	e = (char *) dmi + len;
+
+	while (table != NULL) {
+		DMDEBUG("device %s adding table '%llu %llu %s %s'",
+			dev->name,
+			(unsigned long long) table->start,
+			(unsigned long long) table->length,
+			table->type, table->params);
+		b = dm_add_target(table, b, e);
+		if (!b)
+			return NULL;
+		table = table->next;
+	}
+
+	return dmi;
+}
+
+static void __init dm_setup_drives(void)
+{
+	struct dm_device *dev;
+	int flags;
+	struct dm_device *devices;
+	struct dm_ioctl *io = NULL;
+
+	devices = dm_parse_args();
+
+	for (dev = devices; dev; dev = dev->next) {
+		io = dm_setup_ioctl(dev, 0);
+		if (!io)
+			return;
+		/* create a new device */
+		if (dm_ioctl_cmd(DM_DEV_CREATE, io)) {
+			DMERR("failed to create device %s", dev->name);
+			goto out_free;
+		}
+		kfree(io);
+
+		flags = DM_STATUS_TABLE_FLAG;
+		if (dev->ro)
+			flags |= DM_READONLY_FLAG;
+
+		io = dm_setup_ioctl(dev, flags);
+		if (!io)
+			return;
+		/* load a table into the 'inactive' slot for the device. */
+		if (dm_ioctl_cmd(DM_TABLE_LOAD, io)) {
+			DMERR("failed to load device %s tables", dev->name);
+			goto out_free;
+		}
+		kfree(io);
+
+		io = dm_setup_ioctl(dev, 0);
+		if (!io)
+			return;
+		/* resume and the device should be ready. */
+		if (dm_ioctl_cmd(DM_DEV_SUSPEND, io)) {
+			DMERR("failed to resume device %s", dev->name);
+			goto out_free;
+		}
+
+		DMINFO("dm-%d (%s) is ready", dev->minor, dev->name);
+	}
+
+out_free:
+	kfree(io);
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

