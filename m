From: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH v10 2/2] init: add support to directly boot to a mapped device
Date: Sat,  3 Nov 2018 00:53:41 -0300
Message-ID: <20181103035341.16893-3-helen.koike@collabora.com>
References: <20181103035341.16893-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181103035341.16893-1-helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, enric.balletbo@collabora.com, wad@chromium.org, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com, richard.weinberger@gmail.com, keescook@chromium.org
List-Id: dm-devel.ids

From: Will Drewry <wad@chromium.org>

Add a dm= kernel parameter.
It allows device-mapper targets to be configured at boot time for use early
in the boot process (as the root device or otherwise).

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
[rework to use dm_ioctl calls]
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
[rework to use concise format | rework for upstream]
Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Hello,

In this patch, I constrained the targets allowed to be used by dm=, but
I am not entirely familiar with all the targets. I blacklisted the ones
mentioned previously and some other that I think doesn't make much sense, but
please let me know if you think there are others I should blacklist.

Changes since v9:
 - https://www.redhat.com/archives/linux-lvm/2018-September/msg00016.html
 - new file: drivers/md/dm-boot.c
 - most of the parsing code was moved from init/do_mounts_dm.c to drivers/md/dm-boot.c
 - parsing code was in essence replaced by the concise parser from dmsetup
 _create_concise function:
https://sourceware.org/git/?p=lvm2.git;a=blob;f=libdm/dm-tools/dmsetup.c;h=835fdcdc75e8f0f0f7c4ed46cc9788a6616f58b8;hb=7498f8383397a93db95655ca227257836cbcac82#l1265
 the main reason is that this code is already being used/tested by dmsetup, so
 we can have some level of confidence that it works as expected. Besides this,
 it also looks more efficient.
 - Not all targets are allowed to be used by dm=, as pointed previously, there
 are some risks in creating a mapped device without some validation from
 userspace (see documentation from the patch listing which targets are allowed).
 - Instead of using a simple singly linked list (for devices and tables), use
 the struct list_head. This occupies unnecessary space in the code, but it makes
 the code cleaner and easier to read and less prone to silly errors.
 - Documentation and comments were reviewed and refactored, e.g.:
	* "is to possible" was removed
	* s/specified as a simple string/specified as a string/
 - Added docs above __align function, make it clear that the second parameter @a
 must be a power of two.
 - Clean ups: removal of unnecessary includes, macros, variables, some redundant
 checks and warnings.
 - when calling ioctls, the code was allocating and freeing the same structure
 a couple of times. So instead of executing kzalloc/kfree 3 times, execute
 kmalloc once and reuse the structure after a memset, then finally kfree it once.
 - update commit message

Thanks
---
 .../admin-guide/kernel-parameters.rst         |   1 +
 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/device-mapper/dm-boot.txt       |  87 ++++
 drivers/md/Makefile                           |   2 +-
 drivers/md/dm-boot.c                          | 433 ++++++++++++++++++
 include/linux/device-mapper.h                 |   6 +
 init/Makefile                                 |   1 +
 init/do_mounts.c                              |   1 +
 init/do_mounts.h                              |  10 +
 init/do_mounts_dm.c                           |  46 ++
 10 files changed, 589 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/device-mapper/dm-boot.txt
 create mode 100644 drivers/md/dm-boot.c
 create mode 100644 init/do_mounts_dm.c

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index b8d0bc07ed0a..bd628865f66f 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -91,6 +91,7 @@ parameter is applicable::
 	AX25	Appropriate AX.25 support is enabled.
 	CLK	Common clock infrastructure is enabled.
 	CMA	Contiguous Memory Area support is enabled.
+	DM	Device mapper support is enabled.
 	DRM	Direct Rendering Management support is enabled.
 	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 92eb1f42240d..a3ff7192b980 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -880,6 +880,9 @@
 
 	dis_ucode_ldr	[X86] Disable the microcode loader.
 
+	dm=		[DM] Allows early creation of a device-mapper device.
+			See Documentation/device-mapper/dm-boot.txt.
+
 	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
 			this option disables the debugging code at boot.
 
diff --git a/Documentation/device-mapper/dm-boot.txt b/Documentation/device-mapper/dm-boot.txt
new file mode 100644
index 000000000000..14f756b34328
--- /dev/null
+++ b/Documentation/device-mapper/dm-boot.txt
@@ -0,0 +1,87 @@
+Boot time creation of mapped devices
+====================================
+
+It is possible to configure a device-mapper device to act as the root device for
+your system in two ways.
+
+The first is to build an initial ramdisk which boots to a minimal userspace
+which configures the device, then pivot_root(8) in to it.
+
+The second is when the device-mapper and targets are compiled into the kernel
+(not a module). One or more device-mappers may be created and used as the root
+device at boot time with the parameters given with the boot line dm=...
+
+The format is specified as a string of data separated by commas and optionally
+semi-colons, where:
+ - a comma is used to separate fields like name, uuid, flags and table
+   (specifies one device)
+ - a semi-colon is used to separate devices.
+
+So the format will look like this:
+
+ dm=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
+
+Where,
+	<name>		::= The device name.
+	<uuid>		::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
+	<minor>		::= The device minor number | ""
+	<flags>		::= "ro" | "rw"
+	<table>		::= <start_sector> <num_sectors> <target_type> <target_args>
+	<target_type>	::= "verity" | "linear" | ... (see list below)
+
+The dm line should be equivalent to the one used by the dmsetup tool with the
+--concise argument.
+
+Target types
+============
+
+Not all target types are available as there are serious risks in allowing
+activation of certain DM targets without first using userspace tools to check
+the validity of associated metadata.
+
+
+	"cache":		constrained, requires userspace validation
+	"crypt":		allowed
+	"delay":		allowed
+	"era":			allowed
+	"error":		allowed
+	"flakey":		allowed
+	"integrity":		allowed
+	"linear":		allowed
+	"log-writes":		allowed
+	"mirror":		allowed
+	"multipath":		allowed
+	"raid":			allowed
+	"snapshot":		allowed
+	"snapshot-origin":	allowed
+	"striped":		allowed
+	"switch":		allowed
+	"thin":			constrained,requires userspace validation
+	"thin-pool":		constrained, requires userspace validation
+	"unstriped":		allowed
+	"verity":		allowed
+	"writecache":		allowed
+	"zero":			constrained, requires userspace validation
+	"zoned":		allowed
+
+Examples
+========
+An example of booting to a linear array made up of user-mode linux block
+devices:
+
+  dm="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
+
+This will boot to a rw dm-linear target of 8192 sectors split across two block
+devices identified by their major:minor numbers.  After boot, udev will rename
+this target to /dev/mapper/lroot (depending on the rules). No uuid was assigned.
+
+An example of multiple device-mappers, with the dm="..." contents is shown here
+split on multiple lines for readability:
+
+  vroot,,,ro,
+    0 1740800 verity 254:0 254:0 1740800 sha1
+      76e9be054b15884a9fa85973e9cb274c93afadb6
+      5b3549d54d6c7a3837b9b81ed72e49463a64c03680c47835bef94d768e5646fe;
+  vram,,,rw,
+    0 32768 linear 1:0 0,
+    32768 32768 linear 1:1 0
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 822f4e8753bc..26ffe4536247 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -5,7 +5,7 @@
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o \
-		   dm-rq.o
+		   dm-rq.o dm-boot.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
diff --git a/drivers/md/dm-boot.c b/drivers/md/dm-boot.c
new file mode 100644
index 000000000000..f886174b08fc
--- /dev/null
+++ b/drivers/md/dm-boot.c
@@ -0,0 +1,433 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * dm-boot.c
+ * Copyright (C) 2017 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/ctype.h>
+#include <linux/device-mapper.h>
+#include <linux/list.h>
+
+#define DM_MSG_PREFIX "dm"
+#define DM_MAX_DEVICES 256
+
+/* See Documentation/device-mapper/dm-boot.txt for dm="..." format details. */
+
+struct target {
+	unsigned long long start;
+	unsigned long long length;
+	char *type;
+	char *params;
+	struct list_head list;
+};
+
+struct dm_device {
+	int minor;
+	int ro;
+	char *name;
+	char *uuid;
+	int table_count;
+	struct list_head table;
+	struct list_head list;
+};
+
+/**
+ * _align - align address with the next block
+ * @ptr: the pointer to be aligned.
+ * @a: the size of the block to align the pointer. Must be a power of two.
+ */
+static void __init *_align(void *ptr, unsigned int a)
+{
+	register unsigned long agn = --a;
+
+	return (void *) (((unsigned long) ptr + agn) & ~agn);
+}
+
+const char *dm_allowed_types[] __initconst = {
+	/* "cache", constrained, requires userspace validation */
+	"crypt",
+	"delay",
+	"era",
+	"error",
+	"flakey",
+	"integrity",
+	"linear",
+	"log-writes",
+	"mirror",
+	"multipath",
+	"raid",
+	"snapshot",
+	"snapshot-origin",
+	"striped",
+	"switch",
+	/* "thin", constrained, requires userspace validation */
+	/* "thin-pool", constrained, requires userspace validation */
+	"unstriped",
+	"verity",
+	"writecache",
+	/* "zero", constrained, requires userspace validation */
+	"zoned",
+};
+
+static int __init dm_verify_type(const char *type)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(dm_allowed_types); i++) {
+		if (!strcmp(dm_allowed_types[i], type))
+			return 0;
+	}
+	return -EINVAL;
+}
+
+static struct target __init *dm_parse_table_entry(char *str)
+{
+	char type[DM_MAX_TYPE_NAME], *ptr;
+	struct target *table;
+	int n;
+
+	/* trim trailing space */
+	for (ptr = str + strlen(str) - 1;
+	     ptr >= str && isspace(*ptr); ptr--)
+		;
+	*(++ptr) = '\0';
+
+	/* trim leading space */
+	for (ptr = str; *ptr && isspace(*ptr); ptr++)
+		;
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
+		goto err_free_table;
+	}
+
+	if (dm_verify_type(type)) {
+		DMERR("invalid type \"%s\"", type);
+		goto err_free_table;
+	}
+
+	table->type = kstrndup(type, strlen(type), GFP_KERNEL);
+	if (!table->type) {
+		DMERR("invalid type of table");
+		goto err_free_table;
+	}
+
+	ptr += n;
+	table->params = kstrndup(ptr, strlen(ptr), GFP_KERNEL);
+	if (!table->params) {
+		DMERR("invalid params for table");
+		goto err_free_type;
+	}
+
+	return table;
+
+err_free_type:
+	kfree(table->type);
+err_free_table:
+	kfree(table);
+	return NULL;
+}
+
+/* Parse multiple lines of table */
+static int __init dm_parse_table(struct dm_device *dev, char *str)
+{
+	char *pos = str, *next_pos;
+	struct target *table;
+
+	do {
+		/* Identify and terminate each line */
+		next_pos = strchr(pos, ',');
+		if (next_pos)
+			*next_pos++ = '\0';
+		table = dm_parse_table_entry(pos);
+		if (!table) {
+			DMERR("Couldn't parse table \"%s\"", pos);
+			return -EINVAL;
+		}
+		dev->table_count++;
+		list_add_tail(&table->list, &dev->table);
+	} while ((pos = next_pos));
+
+	return 0;
+}
+
+static void __init dm_setup_cleanup(struct list_head *devices)
+{
+	struct dm_device *dev, *d_tmp;
+	struct target *target, *t_tmp;
+
+	list_for_each_entry_safe(dev, d_tmp, devices, list) {
+		list_del(&dev->list);
+		list_for_each_entry_safe(target, t_tmp, &dev->table, list) {
+			list_del(&target->list);
+			kfree(target->type);
+			kfree(target->params);
+			kfree(target);
+		}
+		kfree(dev);
+	}
+}
+
+/* code based on _create_concise function from dmsetup.c (lvm2) */
+static int __init dm_parse_args(struct list_head *devices, char *str)
+{
+	/* name,uuid,minor,flags,table */
+	char *fields[5] = { NULL };
+	unsigned long ndev = 0;
+	struct dm_device *dev;
+	char *c, *n;
+	int f = 0;
+
+	/*
+	 * Work through input string c, parsing into sets of 5 fields.
+	 * Strip out any characters quoted by backslashes in-place.
+	 * Read characters from c and prepare them in situ for final processing
+	 * at n
+	 */
+	c = n = fields[f] = str;
+
+	while (*c) {
+		/* Quoted character?  Skip past quote. */
+		if (*c == '\\') {
+			if (!*(++c)) {
+				DMERR("Backslash must be followed by another character at end of string.");
+				*n = '\0';
+				DMERR("Parsed %d fields: name: %s uuid: %s minor: %s flags: %s table: %s",
+				      f + 1, fields[0], fields[1], fields[2],
+				      fields[3], fields[4]);
+				goto out;
+			}
+			/* Don't interpret next character */
+			*n++ = *c++;
+			continue;
+		}
+
+		/* Comma marking end of field? */
+		if (*c == ',' && f < 4) {
+			/* Terminate string */
+			*n++ = '\0', c++;
+			/* Store start of next field */
+			fields[++f] = n;
+			/* Skip any whitespace after field-separating commas */
+			while (isspace(*c))
+				c++;
+			continue;
+		}
+
+		/* Semi-colon marking end of device? */
+		if (*c == ';' || *(c + 1) == '\0') {
+			/* End of input? */
+			if (*c != ';')
+				/* Copy final character */
+				*n++ = *c;
+
+			/* Terminate string */
+			*n++ = '\0', c++;
+
+			if (f != 4) {
+				DMERR("Five comma-separated fields are required for each device");
+				DMERR("Parsed %d fields: name: %s uuid: %s minor: %s flags: %s table: %s",
+				      f + 1, fields[0], fields[1], fields[2],
+				      fields[3], fields[4]);
+				goto out;
+			}
+
+			dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+			if (!dev)
+				goto out;
+			INIT_LIST_HEAD(&dev->table);
+			list_add_tail(&dev->list, devices);
+			if (++ndev > DM_MAX_DEVICES) {
+				DMERR("too many devices %lu > %d",
+				      ndev, DM_MAX_DEVICES);
+				goto out;
+			}
+
+			/* Set up parameters */
+			dev->name = fields[0];
+			dev->uuid = fields[1];
+
+			if (!*fields[2])
+				dev->minor = DM_ANY_MINOR;
+			else if (kstrtoint(fields[2], 0, &dev->minor))
+				goto out;
+
+			if (!strcmp(fields[3], "ro"))
+				dev->ro = 1;
+			else if (*fields[3] && strcmp(fields[3], "rw")) {
+				DMERR("Invalid flags parameter '%s' must be 'ro' or 'rw' or empty.", fields[3]);
+				goto out;
+			}
+
+			if (*fields[4] && dm_parse_table(dev, fields[4]))
+				goto out;
+
+			/* Clear parameters ready for any further devices */
+			f = 0;
+			fields[0] = n;
+			fields[1] = fields[2] = fields[3] = fields[4] = NULL;
+
+			/* Skip any whitespace after semi-colons */
+			while (isspace(*c))
+				c++;
+
+			continue;
+		}
+
+		/* Normal character */
+		*n++ = *c++;
+	}
+
+	if (fields[0] != n) {
+		*n = '\0';
+		DMERR("Incomplete entry: five comma-separated fields are required for each device");
+		DMERR("Parsed %d fields: name: %s uuid: %s minor: %s flags: %s table: %s",
+		      f + 1, fields[0], fields[1], fields[2], fields[3],
+		      fields[4]);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	dm_setup_cleanup(devices);
+	return -EINVAL;
+}
+
+static char __init *dm_add_target(const struct target *const table,
+				  char *const buf, char *const end)
+{
+	struct dm_target_spec sp;
+	char *p = buf;
+	size_t len;
+
+	len = strlen(table->params);
+	if (sizeof(struct dm_target_spec) + len >= end - p) {
+		DMERR("ran out of memory building ioctl parameter");
+		return NULL;
+	}
+
+	p += sizeof(struct dm_target_spec);
+	strcpy(p, table->params);
+	p += len + 1;
+	/* align next block */
+	p = _align(p, 8);
+
+	sp.status = 0;
+	sp.sector_start = table->start;
+	sp.length = table->length;
+	strscpy(sp.target_type, table->type, sizeof(sp.target_type));
+	sp.next = p - buf;
+	memcpy(buf, &sp, sizeof(struct dm_target_spec));
+
+	return p;
+}
+
+static int dm_setup_ioctl(struct dm_ioctl *dmi, size_t len,
+			  struct dm_device *dev, int flags)
+{
+	struct target *table;
+	char *b, *e;
+
+	memset(dmi, 0, len);
+	dmi->version[0] = 4;
+	dmi->version[1] = 0;
+	dmi->version[2] = 0;
+	dmi->data_size = len;
+	dmi->data_start = sizeof(struct dm_ioctl);
+	dmi->flags = flags;
+	dmi->target_count = dev->table_count;
+	dmi->event_nr = 1;
+
+	/* Only one between uuid, name and dev should be filled */
+	if (*dev->uuid)
+		strscpy(dmi->uuid, dev->uuid, sizeof(dmi->uuid));
+	else if (*dev->name)
+		strscpy(dmi->name, dev->name, sizeof(dmi->name));
+	else if (dev->minor > 0)
+		dmi->dev = dev->minor;
+	else {
+		DMERR("device name or uuid or minor number should be provided");
+		return -EINVAL;
+	}
+
+	b = (char *) (dmi + 1);
+	e = (char *) dmi + len;
+
+	list_for_each_entry(table, &dev->table, list) {
+		DMDEBUG("device %s adding table '%llu %llu %s %s'",
+			dev->name,
+			(unsigned long long) table->start,
+			(unsigned long long) table->length,
+			table->type, table->params);
+		b = dm_add_target(table, b, e);
+		if (!b) {
+			kfree(dmi);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+void __init dm_boot_setup_drives(char *boot_param)
+{
+	const size_t min_size = 16 * 1024;
+	const size_t len = sizeof(struct dm_ioctl) > min_size ?
+			   sizeof(struct dm_ioctl) : min_size;
+	LIST_HEAD(devices);
+	struct dm_device *dev;
+	struct dm_ioctl *dmi;
+	int flags;
+
+	if (dm_parse_args(&devices, boot_param))
+		return;
+
+	dmi = kmalloc(len, GFP_KERNEL);
+	if (!dmi)
+		return;
+
+	list_for_each_entry(dev, &devices, list) {
+		flags = dev->minor < 0 ? 0 : DM_PERSISTENT_DEV_FLAG;
+		if (dm_setup_ioctl(dmi, len, dev, flags))
+			goto out_free;
+		dmi->dev = dev->minor;
+		/* create a new device */
+		if (dm_ioctl_cmd(DM_DEV_CREATE, dmi)) {
+			DMERR("failed to create device %s", dev->name);
+			goto out_free;
+		}
+
+		flags = dev->ro ? DM_READONLY_FLAG : 0;
+		if (dm_setup_ioctl(dmi, len, dev, flags))
+			goto out_free;
+		/* load a table into the 'inactive' slot for the device. */
+		if (dm_ioctl_cmd(DM_TABLE_LOAD, dmi)) {
+			DMERR("failed to load device %s tables", dev->name);
+			goto out_free;
+		}
+
+		if (dm_setup_ioctl(dmi, len, dev, 0))
+			goto out_free;
+		/* resume and the device should be ready. */
+		if (dm_ioctl_cmd(DM_DEV_SUSPEND, dmi)) {
+			DMERR("failed to resume device %s", dev->name);
+			goto out_free;
+		}
+
+		DMINFO("dm-%d (%s) is ready", dev->minor, dev->name);
+	}
+
+out_free:
+	kfree(dmi);
+}
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8b2e4ae6a498..a3ad379fd2b7 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -429,6 +429,12 @@ union map_info *dm_get_rq_mapinfo(struct request *rq);
  */
 int dm_ioctl_cmd(unsigned int command, struct dm_ioctl *param);
 
+/*
+ * Device mapper function to parse and create devices specified in the kernel
+ * command line boot parameter "dm="
+ */
+void __init dm_boot_setup_drives(char *boot_param);
+
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
 
 /*
diff --git a/init/Makefile b/init/Makefile
index a3e5ce2bcf08..f814f0ff5974 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -19,6 +19,7 @@ mounts-y			:= do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
 mounts-$(CONFIG_BLK_DEV_INITRD)	+= do_mounts_initrd.o
 mounts-$(CONFIG_BLK_DEV_MD)	+= do_mounts_md.o
+mounts-$(CONFIG_BLK_DEV_DM)	+= do_mounts_dm.o
 
 # dependencies on generated files need to be listed explicitly
 $(obj)/version.o: include/generated/compile.h
diff --git a/init/do_mounts.c b/init/do_mounts.c
index e1c9afa9d8c9..d707f12be6e7 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -555,6 +555,7 @@ void __init prepare_namespace(void)
 	wait_for_device_probe();
 
 	md_run_setup();
+	dm_run_setup();
 
 	if (saved_root_name[0]) {
 		root_device_name = saved_root_name;
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 0bb0806de4ce..0f57528ea324 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -61,3 +61,13 @@ void md_run_setup(void);
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
index 000000000000..6657e2993706
--- /dev/null
+++ b/init/do_mounts_dm.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * do_mounts_dm.c
+ * Copyright (C) 2017 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * This file is released under the GPLv2.
+ */
+#include <linux/device-mapper.h>
+
+#include "do_mounts.h"
+
+#define DM_MSG_PREFIX "init"
+
+static struct {
+	char *str;
+	int early_setup;
+} dm_setup_args __initdata;
+
+/*
+ * Parse the command-line parameters given to our kernel, but do not
+ * actually try to invoke the DM device now; that is handled by
+ * dm_boot_setup_drives after the low-level disk drivers have initialised.
+ */
+static int __init dm_setup(char *str)
+{
+	if (!str) {
+		DMERR("Invalid arguments supplied to dm=.");
+		return 0;
+	}
+	DMDEBUG("Want to parse \"%s\"", str);
+	dm_setup_args.str = str;
+	dm_setup_args.early_setup = 1;
+
+	return 1;
+}
+
+__setup("dm=", dm_setup);
+
+void __init dm_run_setup(void)
+{
+	if (!dm_setup_args.early_setup)
+		return;
+	DMINFO("attempting early device configuration.");
+	dm_boot_setup_drives(dm_setup_args.str);
+}
-- 
2.19.1
