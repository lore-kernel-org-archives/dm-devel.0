From: heinzm@sourceware.org
Subject: dmraid include/dmraid/dmreg.h lib/device/parti ...
Date: 16 Dec 2009 11:39:19 -0000
Message-ID: <20091216113919.7736.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-12-16 11:39:18

Added files:
	include/dmraid : dmreg.h 
	lib/device     : partition.c 
	man            : dmevent_tool.8 
	tools          : dmevent_tool.c 

Log message:
	Add missing files to repository (Neail Brown)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/dmreg.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/partition.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/dmevent_tool.8.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/dmevent_tool.c.diff?cvsroot=dm&r1=NONE&r2=1.1

/cvs/dm/dmraid/include/dmraid/dmreg.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/dmreg.h
+++ -	2009-12-16 11:39:18.978388000 +0000
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2009   Intel Corporation. All rights reserved.
+ * Copyright (C) 2009   Heinz Mauelshagen, Red Hat GmbH.
+ *			All rights reserved.
+ * 
+ * See file LICENSE at the top of this source tree for license information.
+ * April 2009 - File creation
+ */
+
+#ifndef _DMREG_H_
+#define _DMREG_H_
+
+
+enum display_opt { UNREGISTERED, ALL, REGISTERED_WITH_UUID, REGISTERED_NO_UUID };
+
+
+extern int dm_register_device(char *dev_name, char *dso_name);
+extern int dm_unregister_device(char *dev_name, char *dso_name);
+extern int dm_all_monitored(enum display_opt);
+extern int dm_monitored_events(int *pending, char *dev_name, char *dso);
+
+#endif
/cvs/dm/dmraid/lib/device/partition.c,v  -->  standard output
revision 1.1
--- dmraid/lib/device/partition.c
+++ -	2009-12-16 11:39:19.124655000 +0000
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2009  Hans de Goede <hdegoede@redhat.com>, Red Hat Inc.
+ *                     All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+#include <linux/blkpg.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <fcntl.h>
+#include "internal.h"
+
+static int
+_remove_subset_partitions(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_dev *rd;
+	struct blkpg_partition part = { 0, };
+	struct blkpg_ioctl_arg io = {
+		.op = BLKPG_DEL_PARTITION,
+		.datalen = sizeof(part),
+		.data = &part,
+	};
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		int fd = open(rd->di->path, O_RDWR);
+		if (fd < 0)
+			LOG_ERR(lc, 0, "opening %s: %s\n", rd->di->path,
+				strerror(errno));
+
+		/* There is no way to enumerate partitions */
+		for (part.pno = 1; part.pno <= 256; part.pno++) {
+			if (ioctl(fd, BLKPG, &io) < 0 && errno != ENXIO &&
+					(part.pno < 16 || errno != EINVAL))
+				LOG_ERR(lc, 0,
+					"removing part %d from %s: %s\n",
+					part.pno, rd->di->path,
+					strerror(errno));
+		}
+	}
+	return 1;
+}
+
+/* Remove the partition block devices (ie sda1) from block devices (ie sda)
+   used in the set, so that things like hal / blkid won't try to access the
+   disks directly */
+int
+remove_device_partitions(struct lib_context *lc, void *v, int dummy)
+{
+	struct raid_set *subset, *rs = v;
+
+	/* Recursively walk down the chain of stacked RAID sets */
+	list_for_each_entry(subset, &rs->sets, list) {
+		/* Remove partitions from devices of set below this one */
+		if (!T_GROUP(rs) && !remove_device_partitions(lc, subset, 0))
+			return 0;
+	}
+
+	return _remove_subset_partitions(lc, rs);
+}
/cvs/dm/dmraid/man/dmevent_tool.8,v  -->  standard output
revision 1.1
--- dmraid/man/dmevent_tool.8
+++ -	2009-12-16 11:39:19.279852000 +0000
@@ -0,0 +1,69 @@
+.TH "DMEVENT_TOOL" "8" "1.0.0.rc3" "Brian Wood" "\""
+.SH "NAME"
+\fBdmevent_tool\fR \- A utility used to load a DSO into dmeventd and (un)register devices with it for monitoring
+.SH "SYNOPSIS"
+dmevent_tool \-[Vhmru] {RAID device name} {DSO Name}
+ 
+.SH "DESCRIPTION"
+dmevent_tool is a userspace utility used to register/unregister DSOs
+with the daemon dmeventd. 
+
+If used with the \fB\-m\fR command line parameter users can display all of the
+actively dmeventd monitored devices.
+
+
+.SH "OPTIONS"
+.TP 
+\-V      Show version of dmevent_tool
+
+.LP
+\-{h/?}  Show this help information
+
+.LP
+\-m[r|u] List all currently active device mapper devices
+        and their current status with dmeventd
+        for registered (-r)/unregistered (-m) devices
+            Syntax: dmevent_tool -m[u|r]
+
+.LP
+\-a[r|u] Same as -m, but for devices with UUID only!
+            Syntax: dmevent_tool -a[u|r]
+
+.LP
+\-r      Register a device with dmeventd
+            Syntax: dmevent_tool -r <device name> <path to DSO library>
+            Example: dmevent_tool -r isw_abcdeh_Volume0 libdmraid-events.so
+
+.LP 
+\-u      Unregister a device with dmeventd
+            Syntax: dmevent_tool -u <device name> [<path to DSO library>]
+            Example: dmevent_tool -u isw_abcdefgh_Volume0
+
+.SH "EXAMPLES"
+\fBdmevent_tool \-m\fR is used to display all of the actively monitored devices
+.br 
+    dmevent_tool \-m
+    Device Name: isw_defeaigdde_Volume0_dmraid00
+        Registered DSO:                   libdmraid\-events.so
+        UUID:                             isw_defeaigdde_Volume0_dmraid00
+        status:                           Active
+        major device #:                   253
+        minor device #:                   0
+        read only device:                 No
+        number of recorded kernel events: 0
+        SATA drives in this volume group: /dev/sdb /dev/sdc	
+
+\fBdmevent_tool \-r\fR is used to register a volume group device with dmeventd
+.br  
+    dmevent_tool \-r isw_defeaigdde_Volume0_dmraid00 libdmraid\-events.so
+
+
+\fBdmevent_tool \-u\fR is used to unregister a volume group from dmeventd
+.br 
+    dmevent_tool \-u isw_defeaigdde_Volume0_dmraid00
+
+.SH "DIAGNOSTICS"
+dmevent_tool returns an exit code of 0 for success or 1 for error.
+
+.SH "AUTHOR"
+Brian Wood <brian.j.wood@intel.com>
/cvs/dm/dmraid/tools/dmevent_tool.c,v  -->  standard output
revision 1.1
--- dmraid/tools/dmevent_tool.c
+++ -	2009-12-16 11:39:19.577847000 +0000
@@ -0,0 +1,243 @@
+/*
+ * Author: 	Brian Wood (brian.j.wood@intel.com), Intel Corporation
+ * Date: 		8/07-12/07
+ * Description: This is a utility that can be used to register/unregister/check status 
+ *			of device mapper RAID devices, see the manpage for further details.
+ *
+ * Copyright (C) 2003-2004 Sistina Software, Inc. All rights reserved.  
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2007,2009 Intel Corp. All rights reserved.
+ *
+ * Streamlining by Heinz Mauelshagen <heinzm@redhat.com>
+ *
+ * Portions of this code (and its underlying architectural idea's)
+ * are borrowed from LVM2 and Device Mapper.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * FIXME before releasing in RHEL5 (Heinz Mauelshagen):
+ *
+ *
+ * Likely after 5.3:
+ * o integrate code with dmraid package
+ * o support metadata updates
+ * o remove any limitations to SATA, because dmraid must be device agnostic;
+ *   ie. the devices being registered with dmeventd have to be derived from
+ *   libdmraid metadata discovery; this essentially means a rewrite!
+ *
+ * FIXED:
+ * o symbols naming consistency
+ * o white space / indenting
+ * o removed bogus sysfs access code in favour of "dmraid -s" for the time
+ *   being; maby share code with libdmraid-events later ?
+ * o memory leaks
+ * o remove code duplication
+ * o programm exit codes
+ * o cover error paths
+ * o stdout/stderr in _usage()
+ * o any (naming) limitations to Intel Matrix RAID
+ * o replace memcpy by s[n]printf/strcpy/cat and check for memory leaks
+ * o variable declaration consistency
+ * o streamlined in general for better readability
+ * o command line processing
+ * o avoid displaying slave devices in _dm_all_monitored()
+ * o most of the functions transferred to dmraid library
+ */
+
+#include <dirent.h>
+#include <dlfcn.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syslog.h>
+#include <unistd.h>
+#include <dmraid/dmreg.h>
+#include "libdevmapper.h"
+#include "libdevmapper-event.h"
+
+#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(*a))
+#define ARRAY_END(a)	(a + ARRAY_SIZE(a))
+       
+#define DEFAULT_DMRAID_MIRROR_LIB "libdmraid-events.so"
+#define DM_DSO_REG_TOOL_VERSION "1.0.0.rc3"
+#define SYS_DM_LEN 256
+#define MAJOR_MINOR 10
+#define SYS_DM_PATH "/sys/block/dm-"
+#define SYS_DM_DEV "/dev"
+#define SYS_DM_SLAVES_DIR "/slaves"
+
+/* Command line option counters for CLI processing. */
+enum option_type { OPT_a, OPT_h, OPT_m, OPT_r, OPT_u, OPT_V, OPT_SUM, OPT_MAX };
+static int optc[OPT_MAX];
+
+/* Usage for dm_dso_reg_tool. */
+static const char *options = "Vh?amru";
+static void _usage(const char *cmd, FILE *file)
+{
+	fprintf(file,
+		"Usage:\n"
+		"%s -[%s]\n"
+		"\n"
+		"   -V      Show version of %s\n"
+		"\n"
+		"   -{h/?}  Show this help information\n"
+		"\n"
+		"   -m[r|u] List all currently active device mapper devices\n"
+		"           and their current status with dmeventd\n"
+		"           for registered (-r)/unregistered (-m) devices\n"
+		"             Syntax: %s -m[u|r]\n"
+		"\n"
+		"   -a[r|u] Same as -m, but for devices with UUID only!\n"
+		"             Syntax: %s -a[u|r]\n"
+		"\n"
+		"   -r      Register a device with dmeventd\n"
+		"             Syntax: %s -r <device name> "
+		"<path to DSO library>\n"
+		"             Example: %s -r isw_abcdeh_Volume0"
+		" libdmraid-events.so\n"
+		"\n"
+		"   -u      Unregister a device with dmeventd\n"
+		"             Syntax: %s -u <device name> "
+		"[<path to DSO library>]\n"
+		"             Example: %s -u isw_abcdefgh_Volume0\n"
+		"\n" , cmd, options, cmd, cmd, cmd, cmd, cmd, cmd, cmd);
+}
+
+void _test_user_id(void)
+{
+	if (geteuid()) {
+		fprintf(stderr, "This utility needs to be run as root.\n");
+		exit(1);
+	}
+}
+
+/* Increment option counters. */
+static _process_opt(int opt, const char *cmd)
+{
+	struct opt_def_struct {
+		const char opt;		/* Option character. */
+		enum option_type type;	/* The option type. */
+		int root;		/* Flag to require root crdentials. */
+	};
+	static struct opt_def_struct optdefs[] = {
+		{ 'V', OPT_V, 0 }, /* Display tool version. */
+		{ 'm', OPT_m, 1 }, /* List (all) devices. */
+		{ 'a', OPT_a, 1 }, /* List (all) devices with UUID only. */
+		{ 'r', OPT_r, 1 }, /* Register a device. */
+		{ 'u', OPT_u, 1 }, /* Unregister a device. */
+		{ 'h', OPT_h, 0 }, /* Help. */
+		{ '?', OPT_h, 0 }, /* Help. */
+	};
+	struct opt_def_struct *o;
+
+	for (o = optdefs; o < ARRAY_END(optdefs); o++) {
+		if (opt == o->opt) {
+			if (o->root)
+				_test_user_id();
+
+			optc[o->type]++;
+			optc[OPT_SUM]++;
+			return;
+		}
+	}
+
+	_usage(cmd, stderr);
+	exit(1);
+}
+
+/*
+ * Process command line options and do an initial argument check.
+ * Covers help request and command line error.
+ *
+ * Return 1 for failure, 0 for success.
+ */
+static void _process_options(int argc, char **argv, const char *cmd)
+{
+	int err = 0, opt;
+
+	memset(optc, 0, sizeof(optc));
+
+	/* Walk command line options. */
+	while ((opt = getopt(argc, argv, options)) != EOF)
+		_process_opt(opt, cmd);
+
+	/* No options specified -> request help. */
+	if (!optc[OPT_SUM])
+		optc[OPT_h]++;
+
+	/* Help may be the only option. */
+	if (optc[OPT_h]) {
+		if (optc[OPT_SUM] > 1)
+			err++;
+
+	/* Only one of -r or -u. */
+	} else if (optc[OPT_r] + optc[OPT_u] > 1)
+		err++;
+
+	/* Only one of -r or -u. */
+	else if (optc[OPT_a] + optc[OPT_m] > 1)
+		err++;
+
+	/* With -{a|m}, no additional arguments, only {-r/-u}. */
+	else if (optc[OPT_a] || optc[OPT_m]) {
+		if (argc != 2)
+			err++;
+
+	/* With -r, we need a device name and a DSO path. */
+	} else if (optc[OPT_r]) {
+		if (argc != 4)
+			err++;
+
+	/* With -u, we need a device name and optionally a DSO path. */
+	} else if (optc[OPT_u]) {
+		if (argc < 3 || argc > 4)
+			err++;
+	}
+
+	if (err || optc[OPT_h]) {
+		_usage(cmd, err ? stderr : stdout);
+		exit(!!err);
+	}
+}
+
+/* main: Process command line options + arguments. */
+int main(int argc, char **argv)
+{
+	int opt, ret = 0;
+	char *cmd = basename(argv[0]);
+	enum display_opt display_option;
+
+	/* Process command line option (covers help and error). */
+	_process_options(argc, argv, cmd);
+
+	if (optc[OPT_a] || optc[OPT_m]) {
+		display_option = ALL;
+		if (!optc[OPT_r] && optc[OPT_u])
+			display_option = UNREGISTERED;
+		else if (optc[OPT_r] && !optc[OPT_u])
+			if (optc[OPT_a])
+				display_option = REGISTERED_WITH_UUID;
+			else if (optc[OPT_m])
+				display_option = REGISTERED_NO_UUID;
+		dm_all_monitored(display_option);
+	}
+	else if (optc[OPT_r])
+		ret = dm_register_device(argv[2], argv[3]);
+	else if (optc[OPT_u])
+		ret = dm_unregister_device(argv[2], argc > 3 ? argv[3] : NULL);
+	else if (optc[OPT_V])
+		printf("%s version: %s\n", cmd, DM_DSO_REG_TOOL_VERSION);
+
+	return ret;
+} /* End main. */
