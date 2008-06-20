From: heinzm@sourceware.org
Subject: dmraid ./configure ./configure.in include/dmra ...
Date: 20 Jun 2008 21:52:27 -0000
Message-ID: <20080620215227.13500.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2008-06-20 21:52:19

Modified files:
	.              : configure configure.in 
	include/dmraid : display.h dmraid.h format.h lib_context.h 
	                 list.h locking.h metadata.h misc.h reconfig.h 
	lib            : .export.sym version.h 
	lib/activate   : activate.c devmapper.c 
	lib/datastruct : byteorder.h 
	lib/device     : ata.c ata.h dev-io.h scan.c scsi.c scsi.h 
	lib/display    : display.c 
	lib/format     : format.c register.h 
	lib/format/ataraid: asr.c asr.h hpt37x.c hpt37x.h hpt45x.c 
	                    hpt45x.h isw.c isw.h jm.c jm.h lsi.c lsi.h 
	                    nv.c nv.h pdc.c pdc.h sil.c sil.h via.c 
	                    via.h 
	lib/format/ddf : ddf1.c ddf1.h ddf1_crc.c ddf1_cvt.c ddf1_cvt.h 
	                 ddf1_dump.c ddf1_lib.c ddf1_lib.h 
	lib/format/partition: dos.c dos.h 
	lib/format/template: template.c template.h 
	lib/locking    : locking.c 
	lib/log        : log.c 
	lib/metadata   : log_ops.c metadata.c reconfig.c 
	lib/misc       : file.c init.c lib_context.c misc.c workaround.c 
	lib/mm         : dbg_malloc.c 
	man            : dmraid.8 
	tools          : VERSION commands.c commands.h dmraid.c 
	                 toollib.c toollib.h 

Log message:
	Intel Software RAID create/delete/spare/rebuild support

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/display.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/dmraid.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/format.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/lib_context.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/list.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/locking.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/metadata.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/misc.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/reconfig.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/.export.sym.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/devmapper.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/datastruct/byteorder.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/ata.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/ata.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/dev-io.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scan.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scsi.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scsi.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/display/display.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/format.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/register.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt37x.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt37x.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt45x.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt45x.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/nv.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/nv.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/via.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/via.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_crc.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_cvt.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_cvt.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_dump.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_lib.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_lib.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/partition/dos.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/partition/dos.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/template/template.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/template/template.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/locking/locking.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/log/log.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/log_ops.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/reconfig.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/file.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/init.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/lib_context.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/misc.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/workaround.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/mm/dbg_malloc.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/dmraid.8.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/dmraid.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/toollib.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/toollib.h.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/configure	2008/02/22 16:50:38	1.1
+++ dmraid/configure	2008/06/20 21:52:15	1.2
@@ -854,8 +854,10 @@
   --enable-jobs=NUM       Number of jobs to run simultaneously
   --enable-libselinux     Use this to link the tools to libselinux
   --enable-libsepol       Use this to link the tools to libsepol
-  --enable-mini           Use this to create a minimal binrary suitable
+  --enable-mini           Use this to create a minimal binary suitable
                           for early boot environments
+  --enable-led            Use this to enable LED support
+  --enable-intel_led      Use this to enable Intel LED support
   --disable-native_log    Disable native metadata logging. Default is enabled
   --enable-static_link    Use this to link the tools to the dmraid and devmapper
                           libraries statically.  Default is dynamic linking
@@ -4513,6 +4515,22 @@
   DMRAID_MINI=no
 fi;
 
+# Check whether --enable-led or --disable-led was given.
+if test "${enable_led+set}" = set; then
+  enableval="$enable_led"
+  DMRAID_LED=$enableval
+else
+  DMRAID_LED=no
+fi;
+
+# Check whether --enable-intel_led or --disable-intel_led was given.
+if test "${enable_intel_led+set}" = set; then
+  enableval="$enable_intel_led"
+  DMRAID_INTEL_LED=$enableval
+else
+  DMRAID_INTEL_LED=no
+fi;
+
 echo $ac_n "checking whether to disable native metadata logging""... $ac_c" 1>&6
 # Check whether --enable-native_log or --disable-native_log was given.
 if test "${enable_native_log+set}" = set; then
@@ -4577,6 +4595,14 @@
 	fi
 fi
 
+if test x$DMRAID_LED = xyes; then
+        CFLAGS="$CFLAGS -DDMRAID_LED"
+fi
+
+if test x$DMRAID_INTEL_LED = xyes; then
+        CFLAGS="$CFLAGS -DDMRAID_LED -DDMRAID_INTEL_LED"
+fi
+
 if test x$DEBUG = xyes; then
 	FLAVOUR="${FLAVOUR}debug "
 fi
--- dmraid/configure.in	2008/02/22 16:50:38	1.1
+++ dmraid/configure.in	2008/06/20 21:52:15	1.2
@@ -107,9 +107,15 @@
 AC_ARG_ENABLE(libsepol, [  --enable-libsepol       Use this to link the tools to libsepol ], LIBSEPOL=$enableval, LIBSEPOL=no)
 
 dnl Enables mini binary
-AC_ARG_ENABLE(mini, [  --enable-mini           Use this to create a minimal binrary suitable
+AC_ARG_ENABLE(mini, [  --enable-mini           Use this to create a minimal binary suitable
                           for early boot environments],  DMRAID_MINI=$enableval, DMRAID_MINI=no)
 
+dnl Enables LED support
+AC_ARG_ENABLE(led, [  --enable-led            Use this to enable LED support],  DMRAID_LED=$enableval, DMRAID_LED=no)
+
+dnl Enables Intel LED support
+AC_ARG_ENABLE(intel_led, [  --enable-intel_led      Use this to enable Intel LED support],  DMRAID_INTEL_LED=$enableval, DMRAID_INTEL_LED=no)
+
 echo $ac_n "checking whether to disable native metadata logging""... $ac_c" 1>&6
 dnl Disable native metadata logging
 AC_ARG_ENABLE(native_log, [  --disable-native_log    Disable native metadata logging. Default is enabled],  \
@@ -155,6 +161,14 @@
 	fi
 fi
 
+if test x$DMRAID_LED = xyes; then
+        CFLAGS="$CFLAGS -DDMRAID_LED"
+fi
+
+if test x$DMRAID_INTEL_LED = xyes; then
+        CFLAGS="$CFLAGS -DDMRAID_LED -DDMRAID_INTEL_LED"
+fi
+
 if test x$DEBUG = xyes; then
 	FLAVOUR="${FLAVOUR}debug "
 fi
--- dmraid/include/dmraid/display.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/display.h	2008/06/20 21:52:16	1.2
@@ -9,15 +9,15 @@
 #define _DISPLAY_H_
 
 enum dev_type {
-	DEVICE = 0x01,	/* ALL devices */
-	RAID   = 0x02,	/* RAID devices */
-	NATIVE = 0x04,	/* Native metadata of RAID devices */
-	SET    = 0x08,	/* RAID sets */
+	DEVICE = 0x01,		/* ALL devices */
+	RAID = 0x02,		/* RAID devices */
+	NATIVE = 0x04,		/* Native metadata of RAID devices */
+	SET = 0x08,		/* RAID sets */
 };
 
 enum active_type {
-	D_ALL      = 0x01,	/* All devices */
-	D_ACTIVE   = 0x02,	/* Active devices only */
+	D_ALL = 0x01,		/* All devices */
+	D_ACTIVE = 0x02,	/* Active devices only */
 	D_INACTIVE = 0x04,	/* Inactive devices only */
 };
 
--- dmraid/include/dmraid/dmraid.h	2008/02/22 17:04:35	1.2
+++ dmraid/include/dmraid/dmraid.h	2008/06/20 21:52:16	1.3
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ *
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -56,7 +59,7 @@
  */
 extern const char *get_set_type(struct lib_context *lc, void *rs);
 extern const char *get_set_name(struct lib_context *lc, void *rs);
-extern int group_set(struct lib_context *lc, char *name);
+extern int group_set(struct lib_context *lc, char **name);
 extern char *libdmraid_make_table(struct lib_context *lc, struct raid_set *rs);
 
 enum activate_type {
@@ -65,8 +68,8 @@
 };
 
 extern void process_sets(struct lib_context *lc,
-			 int (*func)(struct lib_context *lc, void *rs, int arg),
-			 int arg, enum set_type type);
+			 int (*func) (struct lib_context * lc, void *rs,
+				      int arg), int arg, enum set_type type);
 extern int change_set(struct lib_context *lc, enum activate_type what,
 		      void *rs);
 
--- dmraid/include/dmraid/format.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/format.h	2008/06/20 21:52:16	1.2
@@ -1,6 +1,9 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
+ * 
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
  *
  * See file LICENSE at the top of this source tree for license information.
  */
@@ -40,7 +43,7 @@
 struct event_rd {
 	struct raid_set *rs;
 	struct raid_dev *rd;
-	enum rd_action	action;
+	enum rd_action action;
 };
 
 /*
@@ -51,10 +54,46 @@
  */
 struct event_handlers {
 	/* Handle IO error */
-	int (*io)(struct lib_context *lc, struct event_io *e_io);
+	int (*io) (struct lib_context * lc, struct event_io * e_io);
 
 	/* Handle RAID device add/remove. */
-	int (*rd)(struct lib_context *lc, struct event_rd *e_rd);
+	int (*rd) (struct lib_context * lc, struct event_rd * e_rd);
+};
+
+/*
+ * Hot-spare search types list: it can be searched locally/globally 
+ */
+enum scope {
+	t_scope_local = 0x01,
+	t_scope_global = 0x02
+};
+
+/* Metadata Handler commands */
+enum handler_commands {
+	UPDATE_REBUILD_STATE,
+	GET_REBUILD_STATE,
+	GET_REBUILD_DRIVE,
+	GET_REBUILD_DRIVE_NO,
+	CHECK_HOT_SPARE,
+	/* ... */
+};
+
+/* Union to return metadata_handler information. */
+struct handler_info {
+	unsigned short size;
+
+	union {
+		char *str;
+		void *ptr;
+		int8_t i8;
+		int16_t i16;
+		int32_t i32;
+		int64_t i64;
+		uint8_t u8;
+		uint16_t u16;
+		uint32_t u32;
+		uint64_t u64;
+	} data;
 };
 
 /*
@@ -69,33 +108,54 @@
 	/*
 	 * Read RAID metadata off a device and unify it.
 	 */
-	struct raid_dev* (*read)(struct lib_context *lc, struct dev_info* di);
+	struct raid_dev *(*read) (struct lib_context * lc,
+				  struct dev_info * di);
 
 	/*
 	 * Write RAID metadata to a device deunifying it
 	 * or erase ondisk metadata if erase != 0.
 	 */
-	int (*write)(struct lib_context *lc, struct raid_dev* rd, int erase);
+	int (*write) (struct lib_context * lc, struct raid_dev * rd, int erase);
+
+	/*
+	 * delete RAID metadata to devices.
+	 */
+	int (*delete) (struct lib_context * lc, struct raid_set * rs);
+
+	/*
+	 * create RAID metadata to devices.
+	 */
+	int (*create) (struct lib_context * lc, struct raid_set * rs);
 
 	/*
 	 * Group a RAID device into a set.
 	 */
-	struct raid_set* (*group)(struct lib_context *lc, struct raid_dev *rd);
+	struct raid_set *(*group) (struct lib_context * lc,
+				   struct raid_dev * rd);
 
 	/*
 	 * Check consistency of the RAID set metadata.
 	 */
-	int (*check)(struct lib_context *lc, struct raid_set *rs);
+	int (*check) (struct lib_context * lc, struct raid_set * rs);
+
+	/* Metadata handler. */
+	int (*metadata_handler) (struct lib_context * lc,
+				 enum handler_commands command,
+				 struct handler_info * info, void *ptr);
 
 	/*
 	 * Event handlers (eg, I/O error).
 	 */
 	struct event_handlers *events;
 
+	/* 
+	 * Hot-spare disk search scope 
+	 */
+	enum scope scope;
 	/*
 	 * Display RAID disk metadata native.
 	 */
-	void (*log)(struct lib_context *lc, struct raid_dev *rd);
+	void (*log) (struct lib_context * lc, struct raid_dev * rd);
 };
 
 /* Chain of registered format handlers (needed for library context). */
@@ -113,14 +173,13 @@
  */
 #define	NO_CHECK_RD	NULL
 extern int check_raid_set(struct lib_context *lc, struct raid_set *rs,
-			  unsigned int (*f_devices)(struct raid_dev *rd,
-						    void *context),
+			  unsigned int (*f_devices) (struct raid_dev * rd,
+						     void *context),
 			  void *f_devices_context,
-			  int (*f_check)(struct lib_context *lc,
-					 struct raid_set *rs,
-					 struct raid_dev *rd, void *context),
-			  void *f_check_context,
-			  const char *handler);
+			  int (*f_check) (struct lib_context * lc,
+					  struct raid_set * rs,
+					  struct raid_dev * rd, void *context),
+			  void *f_check_context, const char *handler);
 extern int check_valid_format(struct lib_context *lc, char *fmt);
 extern int init_raid_set(struct lib_context *lc, struct raid_set *rs,
 			 struct raid_dev *rd, unsigned int stride,
@@ -135,22 +194,29 @@
 	uint64_t u64;
 };
 
-struct raid_dev *read_raid_dev(
-	struct lib_context *lc,
-	struct dev_info *di,
-	void* (*f_read_metadata)(struct lib_context *lc, struct dev_info *di,
-				 size_t *size, uint64_t *offset,
-				 union read_info *info),
-	size_t size, uint64_t offset,
-	void (*f_to_cpu)(void *meta),
-	int (*f_is_meta)(struct lib_context *lc, struct dev_info *di,
-			 void *meta),
-	void (*f_file_metadata)(struct lib_context *lc, struct dev_info *di,
-				void *meta),
-	int (*f_setup_rd)(struct lib_context *lc, struct raid_dev *rd,
-			  struct dev_info *di, void *meta,
-			  union read_info *info),
-	const char *handler);
+struct raid_dev *read_raid_dev(struct lib_context *lc,
+			       struct dev_info *di,
+			       void *(*f_read_metadata) (struct lib_context *
+							 lc,
+							 struct dev_info * di,
+							 size_t * size,
+							 uint64_t * offset,
+							 union read_info *
+							 info), size_t size,
+			       uint64_t offset, void (*f_to_cpu) (void *meta),
+			       int (*f_is_meta) (struct lib_context * lc,
+						 struct dev_info * di,
+						 void *meta),
+			       void (*f_file_metadata) (struct lib_context *
+							lc,
+							struct dev_info * di,
+							void *meta),
+			       int (*f_setup_rd) (struct lib_context * lc,
+						  struct raid_dev * rd,
+						  struct dev_info * di,
+						  void *meta,
+						  union read_info * info),
+			       const char *handler);
 
 extern void *alloc_meta_areas(struct lib_context *lc, struct raid_dev *rd,
 			      const char *who, unsigned int n);
@@ -158,14 +224,17 @@
 			   size_t size);
 extern void *alloc_private_and_read(struct lib_context *lc, const char *who,
 				    size_t size, char *path, loff_t offset);
-extern struct raid_set *join_superset(
-	struct lib_context *lc,
-	char *(*f_name)(struct lib_context *lc, struct raid_dev *rd,
-			unsigned int subset),
-	void (*f_create)(struct raid_set *super, void *private),
-	int (*f_set_sort)(struct list_head *pos, struct list_head *new),
-	struct raid_set *rs, struct raid_dev *rd
-);
+extern struct raid_set *join_superset(struct lib_context *lc,
+				      char *(*f_name) (struct lib_context * lc,
+						       struct raid_dev * rd,
+						       unsigned int subset),
+				      void (*f_create) (struct raid_set *
+							super, void *private),
+				      int (*f_set_sort) (struct list_head *
+							 pos,
+							 struct list_head *
+							 new),
+				      struct raid_set *rs, struct raid_dev *rd);
 extern int register_format_handler(struct lib_context *lc,
 				   struct dmraid_format *fmt);
 extern int write_metadata(struct lib_context *lc, const char *handler,
@@ -175,7 +244,7 @@
 
 #define	to_disk	to_cpu
 
-#define struct_offset(s, member) ((unsigned short) &((struct s *) 0)->member)
+#define struct_offset(s, member) ((size_t) &((struct s *) 0)->member)
 
 /* Print macros used in log methods. */
 
--- dmraid/include/dmraid/lib_context.h	2008/04/02 13:35:31	1.2
+++ dmraid/include/dmraid/lib_context.h	2008/06/20 21:52:16	1.3
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -13,12 +16,12 @@
 #include <dmraid/misc.h>
 
 enum lc_lists {
-	LC_FORMATS = 0,	/* Metadata format handlers. */
-	LC_DISK_INFOS,	/* Disks discovered. */
-	LC_RAID_DEVS,	/* Raid devices discovered. */
-	LC_RAID_SETS,	/* Raid sets grouped. */
+	LC_FORMATS = 0,		/* Metadata format handlers. */
+	LC_DISK_INFOS,		/* Disks discovered. */
+	LC_RAID_DEVS,		/* Raid devices discovered. */
+	LC_RAID_SETS,		/* Raid sets grouped. */
 	/* Add new lists below here ! */
-	LC_LISTS_SIZE,	/* Must be the last enumerator. */
+	LC_LISTS_SIZE,		/* Must be the last enumerator. */
 };
 
 /* List access macros. */
@@ -39,8 +42,12 @@
 	LC_IGNORELOCKING,
 	LC_SEPARATOR,
 	LC_DEVICES,
-	LC_PARTCHAR,	  /* Add new options below this one ! */
-	LC_OPTIONS_SIZE,  /* Must be the last enumerator. */
+	LC_PARTCHAR,
+	LC_CREATE,
+	LC_REBUILD_SET,
+	LC_REBUILD_DISK,
+	LC_HOT_SPARE_SET,	/* Add new options below this one ! */
+	LC_OPTIONS_SIZE,	/* Must be the last enumerator. */
 };
 
 /* Options access macros. */
@@ -57,6 +64,9 @@
 #define	OPT_TEST(lc)		(lc_opt(lc, LC_TEST))
 #define	OPT_VERBOSE(lc)		(lc_opt(lc, LC_VERBOSE))
 #define	OPT_PARTCHAR(lc)	(lc_opt(lc, LC_PARTCHAR))
+#define	OPT_CREATE(lc)		(lc_opt(lc, LC_CREATE))
+#define OPT_HOT_SPARE_SET(lc)	(lc_opt(lc, LC_HOT_SPARE_SET))
+#define OPT_REBUILD_DISK(lc)	(lc_opt(lc, LC_REBUILD_DISK))
 
 /* Return option value. */
 #define	OPT_STR(lc, o)		(lc->options[o].arg.str)
@@ -64,6 +74,8 @@
 #define	OPT_STR_FORMAT(lc)	OPT_STR(lc, LC_FORMAT)
 #define	OPT_STR_SEPARATOR(lc)	OPT_STR(lc, LC_SEPARATOR)
 #define	OPT_STR_PARTCHAR(lc)	OPT_STR(lc, LC_PARTCHAR)
+#define OPT_STR_HOT_SPARE_SET(lc)	OPT_STR(lc, LC_HOT_SPARE_SET)
+#define OPT_STR_REBUILD_DISK(lc)	OPT_STR(lc, LC_REBUILD_DISK)
 
 struct lib_version {
 	const char *text;
@@ -95,29 +107,116 @@
 	/*
 	 * Lists for:
 	 *
-	 *	o metadata format handlers the library supports
-	 * 	o block devices discovered
-	 * 	o RAID devices discovered
-	 * 	o RAID sets grouped
+	 *      o metadata format handlers the library supports
+	 *      o block devices discovered
+	 *      o RAID devices discovered
+	 *      o RAID sets grouped
 	 */
 	struct list_head lists[LC_LISTS_SIZE];
 
-	char *locking_name;		/* Locking mechanism selector. */
-	struct	locking *lock;		/* Resource locking. */
+	char *locking_name;	/* Locking mechanism selector. */
+	struct locking *lock;	/* Resource locking. */
 
-	mode_t	mode;			/* File/directrory create modes. */
+	mode_t mode;		/* File/directrory create modes. */
 
 	struct {
 		const char *error;	/* For error mappings. */
 	} path;
 };
 
+
+/* Options actions dmraid performs. */
+enum action {
+	UNDEF = 0x0,
+	ACTIVATE = 0x1,
+	DEACTIVATE = 0x2,
+	FORMAT = 0x4,
+#ifndef	DMRAID_MINI
+	BLOCK_DEVICES = 0x8,
+	COLUMN = 0x10,
+	DBG = 0x20,
+	DUMP = 0x40,
+	DMERASE = 0x80,
+	GROUP = 0x100,
+#endif
+	HELP = 0x200,
+#ifndef	DMRAID_MINI
+	LIST_FORMATS = 0x400,
+#  ifdef	DMRAID_NATIVE_LOG
+	NATIVE_LOG = 0x800,
+#  endif
+#endif
+	NOPARTITIONS = 0x1000,
+#ifndef	DMRAID_MINI
+	RAID_DEVICES = 0x2000,
+	RAID_SETS = 0x4000,
+	TEST = 0x8000,
+	VERBOSE = 0x10000,
+	ACTIVE = 0x20000,
+	INACTIVE = 0x40000,
+	SEPARATOR = 0x80000,
+#endif
+	VERSION = 0x100000,
+	IGNORELOCKING = 0x200000,
+#ifndef DMRAID_MINI
+	DEL_SETS = 0x400000,
+	CREATE = 0x800000,
+	REBUILD = 0x1000000,
+	SPARE = 0x2000000,
+	MEDIA = 0x4000000,
+	END_REBUILD = 0x8000000,
+	GET_MEMBERS = 0x10000000,
+	PARTCHAR = 0x20000000,
+
+#endif
+};
+
+/* Arguments allowed ? */
+enum args {
+	NO_ARGS,
+	ARGS,
+};
+
+/* Define which metadata is needed before we can call post functions. */
+enum metadata_need {
+	M_NONE = 0x00,
+	M_DEVICE = 0x01,
+	M_RAID = 0x02,
+	M_SET = 0x04,
+};
+
+enum id {
+	ROOT,
+	ANY_ID,
+};
+
+enum lock {
+	LOCK,
+	NO_LOCK,
+};
+
+/* 
+ * Pre and Post functions to perform for an option.
+ */
+struct prepost {
+	enum action action;
+	enum metadata_need metadata;
+	enum id id;
+	enum lock lock;
+	int (*pre) (int arg);
+	int arg;
+	int (*post) (struct lib_context * lc, int arg);
+};
+
+
+
+
 extern struct lib_context *alloc_lib_context(char **argv);
 extern void free_lib_context(struct lib_context *lc);
 extern int lc_opt(struct lib_context *lc, enum lc_options o);
 const char *lc_opt_arg(struct lib_context *lc, enum lc_options o);
 const char *lc_stralloc_opt(struct lib_context *lc, enum lc_options o,
-			   char *arg);
+			    char *arg);
 const char *lc_strcat_opt(struct lib_context *lc, enum lc_options o,
 			  char *arg, const char delim);
 extern int lc_inc_opt(struct lib_context *lc, int o);
--- dmraid/include/dmraid/list.h	2008/02/22 17:04:35	1.2
+++ dmraid/include/dmraid/list.h	2008/06/20 21:52:16	1.3
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -23,9 +26,9 @@
 
 #define list_empty(pos)	((pos)->next == pos)
 
-static inline void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next)
+static inline void
+__list_add(struct list_head *new,
+	   struct list_head *prev, struct list_head *next)
 {
 	next->prev = new;
 	new->next = next;
@@ -74,4 +77,10 @@
              pos != (head); \
              pos = n, n = pos->next)
 
+#define list_for_each_entry_safe(pos, n, head, member) \
+	for (pos = list_entry((head)->next, typeof(*pos), member),\
+             n = list_entry(pos->member.next, typeof(*pos), member); \
+             &pos->member != (head);   \
+pos = n, n = list_entry(pos->member.next, typeof(*pos), member))
+
 #endif
--- dmraid/include/dmraid/locking.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/locking.h	2008/06/20 21:52:16	1.2
@@ -17,9 +17,9 @@
 struct lib_context;
 struct locking {
 	const char *name;
-	int (*lock)(struct lib_context *lc, struct resource *res);
-	void (*unlock)(struct lib_context *lc, struct resource *res);
-	void *private; /* Private context. */
+	int (*lock) (struct lib_context * lc, struct resource * res);
+	void (*unlock) (struct lib_context * lc, struct resource * res);
+	void *private;		/* Private context. */
 };
 
 extern int init_locking(struct lib_context *lc);
--- dmraid/include/dmraid/metadata.h	2008/02/22 17:04:35	1.2
+++ dmraid/include/dmraid/metadata.h	2008/06/20 21:52:16	1.3
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -15,23 +18,23 @@
  * Unified RAID set types.
  */
 enum type {
-	t_undef     = 0x01,
-	t_group     = 0x02, /* To group subsets (eg, Intel Software RAID). */
-	t_partition = 0x04, /* FIXME: remove in favour of kpartx ? */
-	t_spare     = 0x08,
-	t_linear    = 0x10,
-	t_raid0     = 0x20,
-	t_raid1     = 0x40,
+	t_undef = 0x01,
+	t_group = 0x02,		/* To group subsets (eg, Intel Software RAID). */
+	t_partition = 0x04,	/* FIXME: remove in favour of kpartx ? */
+	t_spare = 0x08,
+	t_linear = 0x10,
+	t_raid0 = 0x20,
+	t_raid1 = 0x40,
 	/*
 	 * Higher RAID types below not supported (yet)
 	 * because of device-mapper constraints.
 	 */
-	t_raid4     = 0x80,
-	t_raid5_ls  = 0x100,
-	t_raid5_rs  = 0x200,
-	t_raid5_la  = 0x400,
-	t_raid5_ra  = 0x800,
-	t_raid6     = 0x1000,
+	t_raid4 = 0x80,
+	t_raid5_ls = 0x100,
+	t_raid5_rs = 0x200,
+	t_raid5_la = 0x400,
+	t_raid5_ra = 0x800,
+	t_raid6 = 0x1000,
 };
 
 /* Check macros for types. */
@@ -64,21 +67,23 @@
  * from format specific types to the unified ones above.
  */
 struct types {
-	unsigned int type; /* Must be long enough for vendor definition. */
-	enum type    unified_type;
+	unsigned int type;	/* Must be long enough for vendor definition. */
+	enum type unified_type;
 };
 
 /* RAID disk/set status. */
 enum status {
-	s_undef		= 0x01,
-	s_broken	= 0x02,	/* Completely broken (not accessible). */
-	s_inconsistent	= 0x04,	/* RAID disk/set inconsistent (needs
+	s_undef = 0x01,
+	s_broken = 0x02,	/* Completely broken (not accessible). */
+	s_inconsistent = 0x04,	/* RAID disk/set inconsistent (needs
 				   synchronization or reconfiguration). */
 	/* FIXME: is s_nosync sufficient or do I need s_upgrade (eg, NVidia) */
-	s_nosync	= 0x08,	/* RAID disk/set *not* in sync
+	s_nosync = 0x08,	/* RAID disk/set *not* in sync
 				   (needs synchronization). */
-	s_ok		= 0x10,	/* Fully operational. */
-	s_setup		= 0x20,	/* Only during RAID setup transition. */
+	s_ok = 0x10,		/* Fully operational. */
+	s_setup = 0x20,		/* Only during RAID setup transition. */
+	s_init = 0x40,		/* RAID set to be created */
+	s_config = 0x80,	/* RAID set hasn't been configured */
 };
 
 /*
@@ -104,24 +109,24 @@
 
 /* find_*() function enums */
 enum find {
-	FIND_TOP,	/* Search top level RAID sets only. */
-	FIND_ALL,	/* Decend all RAID set trees. */
+	FIND_TOP,		/* Search top level RAID sets only. */
+	FIND_ALL,		/* Decend all RAID set trees. */
 };
 
 /* Device information. */
 struct dev_info {
 	struct list_head list;	/* Global chain of discovered devices. */
 
-	char *path;	  /* Actual device node path. */
-	char *serial;	  /* ATA/SCSI serial number. */
-	uint64_t sectors; /* Device size. */
+	char *path;		/* Actual device node path. */
+	char *serial;		/* ATA/SCSI serial number. */
+	uint64_t sectors;	/* Device size. */
 };
 
 /* Metadata areas and size stored on a RAID device. */
 struct meta_areas {
-	uint64_t	offset;	/* on disk metadata offset in sectors. */
-	size_t		size;	/* on disk metadata size in bytes. */
-	void		*area;	/* pointer to format specific metadata. */
+	uint64_t offset;	/* on disk metadata offset in sectors. */
+	size_t size;		/* on disk metadata size in bytes. */
+	void *area;		/* pointer to format specific metadata. */
 };
 
 /*
@@ -131,29 +136,29 @@
  * exist at the lowest level of a RAID set stack (eg, for RAID10).
  */
 struct raid_dev {
-	struct list_head list;		/* Global chain of RAID devices. */
-	struct list_head devs;		/* Chain of devices belonging to set. */
+	struct list_head list;	/* Global chain of RAID devices. */
+	struct list_head devs;	/* Chain of devices belonging to set. */
 
-	char		*name;		/* Metadata format handler generated
-					   name of set this device belongs to.*/
+	char *name;		/* Metadata format handler generated
+				   name of set this device belongs to. */
 
-	struct dev_info  *di;		/* Pointer to dev_info. */
+	struct dev_info *di;	/* Pointer to dev_info. */
 	struct dmraid_format *fmt;	/* Format handler for this device. */
 
-	enum status status;		/* Status of device. */
-	enum type type;			/* Type of device. */
+	enum status status;	/* Status of device. */
+	enum type type;		/* Type of device. */
 
-	uint64_t	offset;		/* Data offset on device. */
-	uint64_t	sectors;	/* Length of the segment to map. */
+	uint64_t offset;	/* Data offset on device. */
+	uint64_t sectors;	/* Length of the segment to map. */
 
-	unsigned int	areas;		/* # of metadata areas on the device. */
+	unsigned int areas;	/* # of metadata areas on the device. */
 	struct meta_areas *meta_areas;	/* Dynamic array of metadata areas. */
 
 	/*
 	 * For format handler use (eg, to keep references between calls).
 	 * 
 	 * WARNING: non pointer members need to get zeroed before exit,
-	 *	    because the metadata layer frees private->ptr on cleanup.
+	 *          because the metadata layer frees private->ptr on cleanup.
 	 */
 	union {
 		void *ptr;
@@ -169,16 +174,16 @@
  * Defines RAID attributes for the set as a whole (eg: RAID0, Status).
  */
 enum flags {
-	f_maximize	= 0x01,	/* If set, maximize set capacity,
+	f_maximize = 0x01,	/* If set, maximize set capacity,
 				   if not set, limit to smallest device. */
-	f_partitions	= 0x02,	/* Set has partitions. */
+	f_partitions = 0x02,	/* Set has partitions. */
 };
 
 #define	F_MAXIMIZE(rs)		((rs)->flags & f_maximize)
 #define	F_PARTITIONS(rs)	((rs)->flags & f_partitions)
 
 struct raid_set {
-	struct list_head list;		/* Chain of independent sets. */
+	struct list_head list;	/* Chain of independent sets. */
 
 	/*
 	 * List of subsets (eg, RAID10) which make up RAID set stacks.
@@ -199,12 +204,13 @@
 	unsigned int total_devs;	/* The number of devices expected */
 	unsigned int found_devs;	/* The number of devices found */
 
-	char *name;			/* Name of the set. */
+	char *name;		/* Name of the set. */
 
-	unsigned int stride;		/* Stride size. */
-	enum type type;			/* Unified raid type. */
-	enum flags flags;		/* Set flags. */
-	enum status status;		/* Status of set. */
+	uint64_t size;		/* size of a raid set */
+	unsigned int stride;	/* Stride size. */
+	enum type type;		/* Unified raid type. */
+	enum flags flags;	/* Set flags. */
+	enum status status;	/* Status of set. */
 };
 
 extern struct raid_set *get_raid_set(struct lib_context *lc,
@@ -220,29 +226,31 @@
 extern struct raid_dev *alloc_raid_dev(struct lib_context *lc, const char *who);
 extern void free_raid_dev(struct lib_context *lc, struct raid_dev **rd);
 extern void list_add_sorted(struct lib_context *lc,
-		     struct list_head *to, struct list_head *new,
-		     int (*sort)(struct list_head *pos,
-				 struct list_head *new));
+			    struct list_head *to, struct list_head *new,
+			    int (*sort) (struct list_head * pos,
+					 struct list_head * new));
 extern struct raid_set *alloc_raid_set(struct lib_context *lc, const char *who);
 extern unsigned int count_sets(struct lib_context *lc, struct list_head *list);
 extern unsigned int count_devs(struct lib_context *lc, struct raid_set *rs,
-			enum count_type type);
+			       enum count_type type);
 extern void free_raid_set(struct lib_context *lc, struct raid_set *rs);
-extern struct raid_set *find_set(struct lib_context *lc, struct list_head *list,
-			  const char *name, enum find where);
+extern struct raid_set *find_set(struct lib_context *lc,
+				 struct list_head *list, const char *name,
+				 enum find where);
 extern struct raid_set *find_or_alloc_raid_set(struct lib_context *lc,
-					char *name, enum find where,
-					struct raid_dev *rd,
-					struct list_head *list,
-					void (*create) (struct raid_set *super,
-							void *private),
-					void *private);
+					       char *name, enum find where,
+					       struct raid_dev *rd,
+					       struct list_head *list,
+					       void (*create) (struct raid_set
+							       * super,
+							       void *private),
+					       void *private);
 #define	NO_RD		NULL
 #define	NO_LIST		NULL
 #define	NO_CREATE	NULL
 #define	NO_CREATE_ARG	NULL
 extern const char *get_set_name(struct lib_context *lc, void *rs);
-extern int group_set(struct lib_context *lc, char *name);
+extern int group_set(struct lib_context *lc, char **name);
 
 enum set_type {
 	SETS,
@@ -250,8 +258,8 @@
 };
 
 extern void process_sets(struct lib_context *lc,
-		  int (*func)(struct lib_context *lc, void *rs, int arg),
-		  int arg, enum set_type type);
+			 int (*func) (struct lib_context * lc, void *rs,
+				      int arg), int arg, enum set_type type);
 extern int write_set(struct lib_context *lc, void *rs);
 extern int partitioned_set(struct lib_context *lc, void *rs);
 extern int base_partitioned_set(struct lib_context *lc, void *rs);
@@ -262,10 +270,12 @@
 			     enum compare cmp);
 extern enum type rd_type(struct types *types, unsigned int type);
 extern void file_metadata(struct lib_context *lc, const char *handler,
-		   char *path, void *data, size_t size, uint64_t offset);
+			  char *path, void *data, size_t size, uint64_t offset);
 extern void file_dev_size(struct lib_context *lc, const char *handler,
-		   struct dev_info *di);
+			  struct dev_info *di);
 extern int write_dev(struct lib_context *lc, struct raid_dev *rd, int erase);
 extern int erase_metadata(struct lib_context *lc);
-
+extern int delete_raidsets(struct lib_context *lc);
+extern int lib_perform(struct lib_context *lc, enum action action,
+		       struct prepost *p, char **argv);
 #endif
--- dmraid/include/dmraid/misc.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/misc.h	2008/06/20 21:52:16	1.2
@@ -1,13 +1,18 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ *
  * See file LICENSE at the top of this source tree for license information.
  */
 
 #ifndef _MISC_H_
 #define _MISC_H_
 
+#define DM_ASSERT(__cond) do { if (!(__cond)) { printf("ASSERT file:%s line:%d fuction:%s cond: %s\n", __FILE__, __LINE__, __FUNCTION__, #__cond); } } while(0);
+
 extern struct lib_context *libdmraid_init(int argc, char **argv);
 extern void libdmraid_exit(struct lib_context *lc);
 
@@ -16,8 +21,10 @@
 extern char *get_basename(struct lib_context *lc, char *str);
 extern char *get_dirname(struct lib_context *lc, char *str);
 extern char *remove_white_space(struct lib_context *lc, char *str, size_t len);
+extern void remove_tail_space(char *str);
 extern char *remove_delimiter(char *ptr, char c);
 extern void add_delimiter(char **ptr, char c);
+extern char *replace_delimiter(char *str, char delim, char c);
 
 extern int mk_dir(struct lib_context *lc, const char *dir);
 
@@ -31,21 +38,33 @@
 extern void free_string(struct lib_context *lc, char **string);
 extern int p_fmt(struct lib_context *lc, char **string, const char *fmt, ...);
 
-static inline uint64_t round_down(uint64_t what, unsigned int by)
+static inline uint64_t
+round_down(uint64_t what, unsigned int by)
 {
 	return what & ~((uint64_t) by - 1);
 }
 
-static inline uint64_t round_up(uint64_t what, unsigned int by)
+static inline uint64_t
+round_up(uint64_t what, unsigned int by)
 {
 	uint64_t t = round_down(what, by);
 
 	return t == what ? t : t + by;
 }
 
-static inline uint64_t div_up(uint64_t what, unsigned int by)
+static inline uint64_t
+div_up(uint64_t what, unsigned int by)
 {
 	return round_up(what, by) / by;
 }
 
+
+#ifdef DMRAID_LED
+/* Definitions for LED support */
+#define LED_OFF		0
+#define LED_REBUILD 1
+
+int led(char *rd, int status);
+#endif
+
 #endif
--- dmraid/include/dmraid/reconfig.h	2008/02/22 17:04:35	1.1
+++ dmraid/include/dmraid/reconfig.h	2008/06/20 21:52:16	1.2
@@ -2,8 +2,8 @@
  * Copyright (C) 2006 Darrick Wong, IBM.
  *                    All rights reserved.
  *
- * Copyright (C) 2006 Heinz Mauelshagen Red Hat GmbH.
- * 		      All rights reserved.
+ * Copyright (C) 2006-2008 Heinz Mauelshagen Red Hat GmbH.
+ * 		           All rights reserved.
  *
  * See the file LICENSE at the top of this source tree for license information.
  */
@@ -50,5 +50,9 @@
 			  struct raid_dev *rd);
 extern void end_log(struct lib_context *lc, struct list_head *log);
 extern int revert_log(struct lib_context *lc, struct list_head *log);
+extern int hot_spare_add(struct lib_context *lc, struct raid_set *rs);
+extern struct raid_set *find_group(struct lib_context *lc,
+				   struct raid_set *sub_rs);
+extern int rebuild_raidset(struct lib_context *lc, char *set_name);
 
 #endif
--- dmraid/lib/.export.sym	2008/02/22 16:57:35	1.1
+++ dmraid/lib/.export.sym	2008/06/20 21:52:16	1.2
@@ -1,51 +1,58 @@
-Base {
-	global:
-		add_delimiter;
-		change_set;
-		check_valid_format;
-		collapse_delimiter;
-		count_devices;
-		count_devs;
-		count_sets;
-		_dbg_free;
-		_dbg_malloc;
-		_dbg_realloc;
-		_dbg_strdup;
-		discover_devices;
-		discover_partitions;
-		discover_raid_devices;
-		display_devices;
-		display_set;
-		dm_version;
-		erase_metadata;
-		find_set;
-		get_dm_type;
-		get_set_type;
-		get_set_name;
-		get_status;
-		get_type;
-		group_set;
-		init_locking;
-		lc_inc_opt;
-		lc_list;
-		lc_opt;
-		lc_stralloc_opt;
-		lc_strcat_opt;
-		libdmraid_exit;
-		libdmraid_init;
-		libdmraid_date;
-		libdmraid_version;
-		libdmraid_make_table;
-		list_formats;
-		lock_resource;
-		log_alloc_err;
-		plog;
-		process_sets;
-		remove_delimiter;
-		remove_white_space;
-		total_sectors;
-		unlock_resource;
-
-	local:
-		*;
-};
+Base {
+	global:
+		add_delimiter;
+		change_set;
+		check_valid_format;
+		collapse_delimiter;
+		count_devices;
+		count_devs;
+		count_sets;
+		_dbg_free;
+		_dbg_malloc;
+		_dbg_realloc;
+		_dbg_strdup;
+		discover_devices;
+		discover_partitions;
+		discover_raid_devices;
+		display_devices;
+		display_set;
+		dm_version;
+		erase_metadata;
+		find_set;
+		get_dm_type;
+		get_set_type;
+		get_set_name;
+		get_status;
+		get_type;
+		group_set;
+		init_locking;
+		lc_inc_opt;
+		lc_list;
+		lc_opt;
+		lc_stralloc_opt;
+		lc_strcat_opt;
+		libdmraid_exit;
+		libdmraid_init;
+		libdmraid_date;
+		libdmraid_version;
+		libdmraid_make_table;
+		list_formats;
+		lock_resource;
+		log_alloc_err;
+		plog;
+		process_sets;
+		remove_delimiter;
+		remove_white_space;
+		total_sectors;
+		unlock_resource;
+		add_dev_to_array;
+		delete_raidsets;
+                lib_perform;
+                rebuild_raidset;
+		dso_end_rebuild;
+		hot_spare_add;
+		dso_get_members;
+	local:
+		*;
+};
+
--- dmraid/lib/version.h	2008/04/02 13:35:31	1.5
+++ dmraid/lib/version.h	2008/06/20 21:52:16	1.6
@@ -7,6 +7,6 @@
 #define	DMRAID_LIB_SUBMINOR_VERSION	0
 #define	DMRAID_LIB_VERSION_SUFFIX	"rc15"
 
-#define	DMRAID_LIB_DATE			"(2008.04.02)"
+#define	DMRAID_LIB_DATE			"(2008.06.20)"
 
 #endif
--- dmraid/lib/activate/activate.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/activate/activate.c	2008/06/20 21:52:16	1.4
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10.
+ *
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -12,26 +15,28 @@
 #include "internal.h"
 #include "devmapper.h"
 
-static int valid_rd(struct raid_dev *rd)
+static int
+valid_rd(struct raid_dev *rd)
 {
 	return S_OK(rd->status) && !T_SPARE(rd);
 }
 
-static int valid_rs(struct raid_set *rs)
+static int
+valid_rs(struct raid_set *rs)
 {
 	return S_OK(rs->status) && !T_SPARE(rs);
 }
 
 /* Return rounded size in case of unbalanced mappings */
-static uint64_t maximize(struct raid_set *rs, uint64_t sectors,
-			 uint64_t last, uint64_t min)
+static uint64_t
+maximize(struct raid_set *rs, uint64_t sectors, uint64_t last, uint64_t min)
 {
 	return sectors > min ? min(last, sectors) : last;
 }
 
 /* Find smallest set/disk larger than given minimum. */
-static uint64_t _smallest(struct lib_context *lc,
-			  struct raid_set *rs, uint64_t min)
+static uint64_t
+_smallest(struct lib_context *lc, struct raid_set *rs, uint64_t min)
 {
 	uint64_t ret = ~0;
 	struct raid_set *r;
@@ -45,7 +50,7 @@
 			ret = maximize(rs, rd->sectors, ret, min);
 	}
 
-	return ret == (uint64_t) ~0 ? 0 : ret;
+	return ret == (uint64_t) ~ 0 ? 0 : ret;
 }
 
 /*
@@ -53,33 +58,38 @@
  */
 
 /* Undefined/-supported mapping. */
-static int _dm_un(struct lib_context *lc, char **table,
-		  struct raid_set *rs, const char *what)
+static int
+_dm_un(struct lib_context *lc, char **table,
+       struct raid_set *rs, const char *what)
 {
 	LOG_ERR(lc, 0, "Un%sed RAID type %s[%u] on %s", what,
 		get_set_type(lc, rs), rs->type, rs->name);
 }
 
-static int dm_undef(struct lib_context *lc, char **table, struct raid_set *rs)
+static int
+dm_undef(struct lib_context *lc, char **table, struct raid_set *rs)
 {
 	return _dm_un(lc, table, rs, "defin");
 }
 
-static int dm_unsup(struct lib_context *lc, char **table, struct raid_set *rs)
+static int
+dm_unsup(struct lib_context *lc, char **table, struct raid_set *rs)
 {
 	return _dm_un(lc, table, rs, "support");
 }
 
 
 /* "Spare mapping". */
-static int dm_spare(struct lib_context *lc, char **table, struct raid_set *rs)
+static int
+dm_spare(struct lib_context *lc, char **table, struct raid_set *rs)
 {
-	LOG_ERR(lc, 0, "spare set");
+	LOG_ERR(lc, 0, "spare set \"%s\" cannot be activated", rs->name);
 }
 
 /* Push path and offset onto a table. */
-static int _dm_path_offset(struct lib_context *lc, char **table,
-			   int valid, const char *path, uint64_t offset)
+static int
+_dm_path_offset(struct lib_context *lc, char **table,
+		int valid, const char *path, uint64_t offset)
 {
 	return p_fmt(lc, table, " %s %U",
 		     valid ? path : lc->path.error, offset);
@@ -88,17 +98,17 @@
 /*
  * Create dm table for linear mapping.
  */
-static int _dm_linear(struct lib_context *lc, char **table, int valid,
-		      const char *path, uint64_t start, uint64_t sectors,
-		      uint64_t offset)
+static int
+_dm_linear(struct lib_context *lc, char **table, int valid,
+	   const char *path, uint64_t start, uint64_t sectors, uint64_t offset)
 {
 	return p_fmt(lc, table, "%U %U %s", start, sectors,
 		     get_dm_type(lc, t_linear)) ?
-		     _dm_path_offset(lc, table, valid, path, offset) : 0;
+		_dm_path_offset(lc, table, valid, path, offset) : 0;
 }
 
-static int dm_linear(struct lib_context *lc, char **table,
-		     struct raid_set *rs)
+static int
+dm_linear(struct lib_context *lc, char **table, struct raid_set *rs)
 {
 	unsigned int segments = 0;
 	uint64_t start = 0, sectors = 0;
@@ -113,14 +123,14 @@
 
 			if (!(path = mkdm_path(lc, r->name)))
 				goto err;
-	
+
 			sectors = total_sectors(lc, r);
 			ret = _dm_linear(lc, table, valid_rs(r), path,
 					 start, sectors, 0);
 			dbg_free(path);
 			segments++;
 			start += sectors;
-	
+
 			if (!ret ||
 			    (r->sets.next != &rs->sets &&
 			     !p_fmt(lc, table, "\n")))
@@ -131,10 +141,11 @@
 	/* Devices of a linear set. */
 	list_for_each_entry(rd, &rs->devs, devs) {
 		if (!T_SPARE(rd)) {
-			if (!_dm_linear(lc, table, valid_rd(rd), rd->di->path,
-					start, rd->sectors, rd->offset))
+			if (!_dm_linear
+			    (lc, table, valid_rd(rd), rd->di->path, start,
+			     rd->sectors, rd->offset))
 				goto err;
-	
+
 			segments++;
 			start += rd->sectors;
 
@@ -146,7 +157,7 @@
 
 	return segments ? 1 : 0;
 
-   err:
+      err:
 	return log_alloc_err(lc, __func__);
 }
 
@@ -156,8 +167,8 @@
  * Partitioned RAID set with 1 RAID device
  * defining a linear partition mapping.
  */
-static int dm_partition(struct lib_context *lc, char **table,
-			struct raid_set *rs)
+static int
+dm_partition(struct lib_context *lc, char **table, struct raid_set *rs)
 {
 	return dm_linear(lc, table, rs);
 }
@@ -178,21 +189,22 @@
  *
  */
 /* Push begin of line onto a RAID0 table. */
-static int _dm_raid0_bol(struct lib_context *lc, char **table,
-			 uint64_t min, uint64_t last_min,
-			 unsigned int n, unsigned int stride)
+static int
+_dm_raid0_bol(struct lib_context *lc, char **table,
+	      uint64_t min, uint64_t last_min,
+	      unsigned int n, unsigned int stride)
 {
 	return p_fmt(lc, table,
 		     n > 1 ? "%U %U %s %u %u" : "%U %U %s",
 		     last_min * n, (min - last_min) * n,
-		     get_dm_type(lc, n > 1 ? t_raid0 : t_linear),
-		     n, stride);
+		     get_dm_type(lc, n > 1 ? t_raid0 : t_linear), n, stride);
 }
 
 /* Push end of line onto a RAID0 table. */
-static int _dm_raid0_eol(struct lib_context *lc,
-			 char **table, struct raid_set *rs,
-			 unsigned int *stripes, uint64_t last_min)
+static int
+_dm_raid0_eol(struct lib_context *lc,
+	      char **table, struct raid_set *rs,
+	      unsigned int *stripes, uint64_t last_min)
 {
 	struct raid_set *r;
 	struct raid_dev *rd;
@@ -216,7 +228,7 @@
 			(*stripes)++;
 		}
 	}
-	
+
 	list_for_each_entry(rd, &rs->devs, devs) {
 		if (!T_SPARE(rd) &&
 		    rd->sectors > last_min &&
@@ -229,13 +241,13 @@
 
 	return 1;
 
-   err:
+      err:
 	return 0;
 }
 
 /* Count RAID sets/devices larger than given minimum size. */
-static unsigned int _dm_raid_devs(struct lib_context *lc,
-				  struct raid_set *rs, uint64_t min)
+static unsigned int
+_dm_raid_devs(struct lib_context *lc, struct raid_set *rs, uint64_t min)
 {
 	unsigned int ret = 0;
 	struct raid_set *r;
@@ -246,7 +258,7 @@
 		if (!T_SPARE(r) && total_sectors(lc, r) > min)
 			ret++;
 	}
-	
+
 	list_for_each_entry(rd, &rs->devs, devs) {
 		if (!T_SPARE(rd) && rd->sectors > min)
 			ret++;
@@ -254,9 +266,9 @@
 
 	return ret;
 }
-	
-static int dm_raid0(struct lib_context *lc, char **table,
-		    struct raid_set *rs)
+
+static int
+dm_raid0(struct lib_context *lc, char **table, struct raid_set *rs)
 {
 	unsigned int stripes = 0;
 	uint64_t min, last_min = 0;
@@ -266,9 +278,10 @@
 			goto err;
 
 		if (!_dm_raid0_bol(lc, table, round_down(min, rs->stride),
-				   last_min, _dm_raid_devs(lc, rs, last_min),
-				   rs->stride) ||
-		    !_dm_raid0_eol(lc, table, rs, &stripes, last_min))
+				   last_min, _dm_raid_devs(lc, rs,
+							   last_min),
+				   rs->stride)
+		    || !_dm_raid0_eol(lc, table, rs, &stripes, last_min))
 			goto err;
 
 		if (!F_MAXIMIZE(rs))
@@ -277,7 +290,7 @@
 
 	return stripes ? 1 : 0;
 
-   err:
+      err:
 	return log_alloc_err(lc, __func__);
 }
 
@@ -286,20 +299,21 @@
  */
 
 /* Calculate dirty log region size. */
-static unsigned int calc_region_size(struct lib_context *lc, uint64_t sectors)
+static unsigned int
+calc_region_size(struct lib_context *lc, uint64_t sectors)
 {
-	const unsigned int mb_128 = 128*2*1024;
+	const unsigned int mb_128 = 128 * 2 * 1024;
 	unsigned int max, region_size;
 
 	if ((max = sectors / 1024) > mb_128)
 		max = mb_128;
 
 	for (region_size = 128; region_size < max; region_size <<= 1);
-
 	return region_size >> 1;
 }
 
-static unsigned int get_rds(struct raid_set *rs, int valid)
+static unsigned int
+get_rds(struct raid_set *rs, int valid)
 {
 	unsigned int ret = 0;
 	struct raid_dev *rd;
@@ -315,7 +329,8 @@
 	return ret;
 }
 
-static unsigned int get_dm_devs(struct raid_set *rs, int valid)
+static unsigned int
+get_dm_devs(struct raid_set *rs, int valid)
 {
 	unsigned int ret = 0;
 	struct raid_set *r;
@@ -329,30 +344,68 @@
 			ret++;
 	}
 
-	ret+= get_rds(rs, valid);
+	return ret + get_rds(rs, valid);
+}
 
-	return ret;
+/* Retrieve number of drive to rebuild from metadata format handler. */
+static int
+get_rebuild_drive(struct lib_context *lc, struct raid_set *rs,
+		  struct handler_info *info)
+{
+	/* Initialize drive to rebuild invalid. */
+	info->data.i32 = -1;
+
+	if (lc->options[LC_REBUILD_SET].opt) {
+		struct raid_dev *rd;
+
+		if (list_empty(&rs->devs))
+			LOG_ERR(lc, 0, "RAID set has no devices!");
+
+		rd = list_entry(rs->devs.next, typeof(*rd), devs);
+		if (rd->fmt->metadata_handler) {
+			if (!rd->
+			    fmt->metadata_handler(lc, GET_REBUILD_DRIVE_NO,
+						  info, rs))
+				LOG_ERR(lc, 0, "Can't get rebuild drive #!");
+		} else
+			LOG_ERR(lc, 0,
+				"Can't rebuild w/o metadata_handler for %s",
+				rd->fmt->name);
+	}
+
+	return 1;
 }
 
+/* Return true if RAID set needs rebuilding. */
+static inline int
+rs_need_sync(struct raid_set *rs)
+{
+	return S_INCONSISTENT(rs->status) || S_NOSYNC(rs->status);
+}
+
+
 /* Push begin of line onto a RAID1 table. */
 /* FIXME: persistent dirty log. */
-static int _dm_raid1_bol(struct lib_context *lc, char **table,
-			 struct raid_set *rs,
-			 uint64_t sectors, unsigned int mirrors)
+static int
+_dm_raid1_bol(struct lib_context *lc, char **table,
+	      struct raid_set *rs,
+	      uint64_t sectors, unsigned int mirrors, int need_sync)
 {
 	return (p_fmt(lc, table, "0 %U %s core 2 %u %s %u",
 		      sectors, get_dm_type(lc, t_raid1),
 		      calc_region_size(lc, sectors),
-		      (S_INCONSISTENT(rs->status) || S_NOSYNC(rs->status)) ?
-		      "sync" : "nosync", mirrors));
+		      (need_sync) ? "sync" : "nosync", mirrors));
 }
 
-static int dm_raid1(struct lib_context *lc, char **table, struct raid_set *rs)
+static int
+dm_raid1(struct lib_context *lc, char **table, struct raid_set *rs)
 {
+	int need_sync;
+	struct handler_info rebuild_drive;
 	uint64_t sectors = 0;
 	unsigned int mirrors = get_dm_devs(rs, 1);
-	struct raid_set *r;
-	struct raid_dev *rd;
+	struct raid_set *r, *swap_rs;
+	struct raid_dev *rd, *swap_rd;
 
 	switch (mirrors) {
 	case 0:
@@ -367,23 +420,36 @@
 			rs->name);
 		return dm_linear(lc, table, rs);
 	}
-		
+
 	if (!(sectors = _smallest(lc, rs, 0)))
 		LOG_ERR(lc, 0, "can't find smallest mirror!");
 
-	if (!_dm_raid1_bol(lc, table, rs, sectors, mirrors))
+	/*
+	 * Get drive for reordering - copy is made from first
+	 * drive (i.e. the master) to the other mirrors.
+	 */
+	need_sync = rs_need_sync(rs);
+	if (need_sync && !get_rebuild_drive(lc, rs, &rebuild_drive))
+		return 0;
+
+	if (!_dm_raid1_bol(lc, table, rs, sectors, mirrors, need_sync))
 		goto err;
 
 	/* Stacked mirror sets. */
+	swap_rs = NULL;
 	list_for_each_entry(r, &rs->sets, list) {
 		if (valid_rs(r)) {
-			int ret;
+			int ret = 1;
 			char *path;
 
 			if (!(path = mkdm_path(lc, r->name)))
 				goto err;
 
-			ret = _dm_path_offset(lc, table, 1, path, 0);
+			if (!rebuild_drive.data.i32 && !swap_rs)
+				swap_rs = r;
+			else
+				ret = _dm_path_offset(lc, table, 1, path, 0);
+
 			dbg_free(path);
 
 			if (!ret)
@@ -391,20 +457,47 @@
 		}
 	}
 
-	/* Lowest level mirror devices */
-	list_for_each_entry(rd, &rs->devs, devs) {
-		if (valid_rd(rd) &&
-		    !_dm_path_offset(lc, table, 1, rd->di->path, rd->offset))
+	/* Add rebuild target to the end of the list. */
+	if (swap_rs && valid_rs(swap_rs)) {
+		int ret = 1;
+		char *path;
+
+		if (!(path = mkdm_path(lc, swap_rs->name)))
 			goto err;
+
+		ret = _dm_path_offset(lc, table, 1, path, 0);
+		dbg_free(path);
+
+		if (!ret)
+			goto err;
+	}
+
+	/* Lowest level mirror devices. */
+	swap_rd = NULL;
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (valid_rd(rd)) {
+			if (!rebuild_drive.data.i32 && !swap_rd)
+				swap_rd = rd;
+			else if (!_dm_path_offset(lc, table, 1,
+						  rd->di->path, rd->offset))
+				goto err;
+		}
 	}
 
-	/* Append the flag/feature required for dmraid1 
-	 * event handling in the kernel driver 
+	/* Add rebuild target to the end of the list. */
+	if (swap_rd && valid_rd(swap_rd))
+		if (!_dm_path_offset(lc, table, valid_rd(swap_rd),
+				     swap_rd->di->path, swap_rd->offset))
+			goto err;
+
+	/*
+	 * Append the flag/feature required for dmraid1
+	 * event handling in the kernel driver.
 	 */
-	if(p_fmt(lc, table, " 1 handle_errors"))
+	if (p_fmt(lc, table, " 1 handle_errors"))
 		return 1;
 
-   err:
+      err:
 	return log_alloc_err(lc, __func__);
 }
 
@@ -414,19 +507,28 @@
 
 /* Push begin of line onto a RAID5 table. */
 /* FIXME: persistent dirty log. */
-static int _dm_raid45_bol(struct lib_context *lc, char **table,
-			 struct raid_set *rs,
-			 uint64_t sectors, unsigned int members)
+static int
+_dm_raid45_bol(struct lib_context *lc, char **table, struct raid_set *rs,
+	       uint64_t sectors, unsigned int members)
 {
-	return p_fmt(lc, table, "0 %U %s core 2 %u %s %s 1 %u %u -1",
+	int need_sync = rs_need_sync(rs);
+	struct handler_info rebuild_drive;
+
+	/* Get drive as rebuild target. */
+	if (need_sync && !get_rebuild_drive(lc, rs, &rebuild_drive))
+		return 0;
+
+	return p_fmt(lc, table, "0 %U %s core 2 %u %s %s 1 %u %u %d",
 		     sectors, get_dm_type(lc, rs->type),
-		     calc_region_size(lc, total_sectors(lc, rs) / _dm_raid_devs(lc, rs, 0)),
-		     (S_INCONSISTENT(rs->status) || S_NOSYNC(rs->status)) ?
-		     "sync" : "nosync",
-		     get_type(lc, rs->type), rs->stride, members);
+		     calc_region_size(lc,
+				      total_sectors(lc, rs) /
+				      _dm_raid_devs(lc, rs, 0)),
+		     (need_sync) ? "sync" : "nosync", get_type(lc, rs->type),
+		     rs->stride, members, rebuild_drive.data.i32);
 }
 
-static int dm_raid45(struct lib_context *lc, char **table, struct raid_set *rs)
+static int
+dm_raid45(struct lib_context *lc, char **table, struct raid_set *rs)
 {
 	uint64_t sectors = 0;
 	unsigned int members = get_dm_devs(rs, 0);
@@ -465,14 +567,14 @@
 
 	/* Lowest level RAID devices */
 	list_for_each_entry(rd, &rs->devs, devs) {
-		    if (!_dm_path_offset(lc, table, valid_rd(rd), rd->di->path,
-					 rd->offset))
+		if (!_dm_path_offset(lc, table, valid_rd(rd), rd->di->path,
+				     rd->offset))
 			goto err;
 	}
 
 	return 1;
 
-   err:
+      err:
 	return log_alloc_err(lc, __func__);
 }
 
@@ -485,25 +587,28 @@
  */
 static struct type_handler {
 	const enum type type;
-	int(*f)(struct lib_context *lc, char **table, struct raid_set *rs);
+	int (*f) (struct lib_context * lc, char **table, struct raid_set * rs);
 } type_handler[] = {
-	{ t_undef, dm_undef }, /* Needs to stay here! */
-	{ t_partition, dm_partition },
-	{ t_spare, dm_spare },
-	{ t_linear, dm_linear },
-	{ t_raid0, dm_raid0 },
-	{ t_raid1, dm_raid1 },
-	{ t_raid4, dm_raid45 },
-	{ t_raid5_ls, dm_raid45 },
-	{ t_raid5_rs, dm_raid45 },
-	{ t_raid5_la, dm_raid45 },
-	{ t_raid5_ra, dm_raid45 },
-	/* RAID types below not supported (yet) */
-	{ t_raid6, dm_unsup },
-};
+	{
+	t_undef, dm_undef},	/* Needs to stay here! */
+	{
+	t_partition, dm_partition}, {
+	t_spare, dm_spare}, {
+	t_linear, dm_linear}, {
+	t_raid0, dm_raid0}, {
+	t_raid1, dm_raid1}, {
+	t_raid4, dm_raid45}, {
+	t_raid5_ls, dm_raid45}, {
+	t_raid5_rs, dm_raid45}, {
+	t_raid5_la, dm_raid45}, {
+	t_raid5_ra, dm_raid45},
+		/* RAID types below not supported (yet) */
+	{
+t_raid6, dm_unsup},};
 
 /* Retrieve type handler from array. */
-static struct type_handler *handler(struct raid_set *rs)
+static struct type_handler *
+handler(struct raid_set *rs)
 {
 	struct type_handler *th = type_handler;
 
@@ -516,7 +621,8 @@
 }
 
 /* Return mapping table */
-char *libdmraid_make_table(struct lib_context *lc, struct raid_set *rs)
+char *
+libdmraid_make_table(struct lib_context *lc, struct raid_set *rs)
 {
 	char *ret = NULL;
 
@@ -531,23 +637,25 @@
 }
 
 
-enum dm_what { DM_ACTIVATE, DM_REGISTER};
+enum dm_what { DM_ACTIVATE, DM_REGISTER };
 
 /* Register devices of the RAID set with the dmeventd. */
 /* REMOVEME: dummy functions once linking to the real ones. */
 #define	ALL_EVENTS 0xffffffff
-static int dm_register_for_event(char *a, char *b, int c)
+static int
+dm_register_for_event(char *a, char *b, int c)
 {
 	return 1;
 }
 
-static int dm_unregister_for_event(char *a, char *b, int c)
+static int
+dm_unregister_for_event(char *a, char *b, int c)
 {
 	return 1;
 }
 
-static int do_device(struct lib_context *lc, struct raid_set *rs,
-		     int (*f)()) // char *, char *, enum event_type))
+static int
+do_device(struct lib_context *lc, struct raid_set *rs, int (*f) ())
 {
 	int ret = 0;
 	struct raid_dev *rd;
@@ -555,7 +663,7 @@
 	if (OPT_TEST(lc))
 		return 1;
 
-	return 1; /* REMOVEME: */
+	return 1;		/* REMOVEME: */
 
 	list_for_each_entry(rd, &rs->devs, devs) {
 		if (!(ret = f("dmraid", rd->di->path, ALL_EVENTS)))
@@ -565,24 +673,27 @@
 	return ret ? 1 : 0;
 }
 
-static int register_devices(struct lib_context *lc, struct raid_set *rs)
+static int
+register_devices(struct lib_context *lc, struct raid_set *rs)
 {
 	return do_device(lc, rs, dm_register_for_event);
 }
 
 /* Unregister devices of the RAID set with the dmeventd. */
-static int unregister_devices(struct lib_context *lc, struct raid_set *rs)
+static int
+unregister_devices(struct lib_context *lc, struct raid_set *rs)
 {
 	return do_device(lc, rs, dm_unregister_for_event);
 }
 
 /* Reload a single set. */
-static int reload_subset(struct lib_context *lc, struct raid_set *rs)
+static int
+reload_subset(struct lib_context *lc, struct raid_set *rs)
 {
 	int ret = 0;
 	char *table = NULL;
 
-	if (T_GROUP(rs))
+	if (T_GROUP(rs) || T_RAID0(rs))
 		return 1;
 
 	/* Suspend device */
@@ -603,23 +714,21 @@
 	/* Try to resume */
 	if (ret)
 		dm_resume(lc, rs);
-	else
-		if (!(ret = dm_resume(lc, rs)))
-			LOG_ERR(lc, ret, "Device resume failed.");
+	else if (!(ret = dm_resume(lc, rs)))
+		LOG_ERR(lc, ret, "Device resume failed.");
 
 	return ret;
 }
 
 /* Reload a RAID set recursively (eg, RAID1 on top of RAID0). */
-static int reload_set(struct lib_context *lc, struct raid_set *rs)
+static int
+reload_set(struct lib_context *lc, struct raid_set *rs)
 {
 	struct raid_set *r;
 
 	/* FIXME: Does it matter if the set is (in)active? */
 #if 0
-	if (!OPT_TEST(lc) &&
-	    what == DM_ACTIVATE &&
-	    dm_status(lc, rs)) {
+	if (!OPT_TEST(lc) && what == DM_ACTIVATE && dm_status(lc, rs)) {
 		log_print(lc, "RAID set \"%s\" already active", rs->name);
 		return 1;
 	}
@@ -629,15 +738,15 @@
 	list_for_each_entry(r, &rs->sets, list) {
 		/* Activate set below this one */
 		if (!reload_set(lc, r) && !T_GROUP(rs))
-			return 0;
+			continue;
 	}
 
 	return reload_subset(lc, rs);
 }
 
 /* Activate a single set. */
-static int activate_subset(struct lib_context *lc, struct raid_set *rs,
-			   enum dm_what what)
+static int
+activate_subset(struct lib_context *lc, struct raid_set *rs, enum dm_what what)
 {
 	int ret = 0;
 	char *table = NULL;
@@ -652,8 +761,12 @@
 	if ((ret = (handler(rs))->f(lc, &table, rs))) {
 		if (OPT_TEST(lc))
 			display_table(lc, rs->name, table);
+		else if ((ret = dm_create(lc, rs, table)))
+			log_print(lc, "RAID set \"%s\" was activated",
+				  rs->name);
 		else
-			ret = dm_create(lc, rs, table);
+			log_print(lc, "RAID set \"%s\" was not activated",
+				  rs->name);
 	} else
 		log_err(lc, "no mapping possible for RAID set %s", rs->name);
 
@@ -663,14 +776,12 @@
 }
 
 /* Activate a RAID set recursively (eg, RAID1 on top of RAID0). */
-static int activate_set(struct lib_context *lc, struct raid_set *rs,
-			enum dm_what what)
+static int
+activate_set(struct lib_context *lc, struct raid_set *rs, enum dm_what what)
 {
 	struct raid_set *r;
 
-	if (!OPT_TEST(lc) &&
-	    what == DM_ACTIVATE &&
-	    dm_status(lc, rs)) {
+	if (!OPT_TEST(lc) && what == DM_ACTIVATE && dm_status(lc, rs)) {
 		log_print(lc, "RAID set \"%s\" already active", rs->name);
 		return 1;
 	}
@@ -686,30 +797,29 @@
 }
 
 /* Deactivate a single set (one level of a device stack). */
-static int deactivate_superset(struct lib_context *lc, struct raid_set *rs,
-			       enum dm_what what)
+static int
+deactivate_superset(struct lib_context *lc, struct raid_set *rs,
+		    enum dm_what what)
 {
 	int ret = 1, status;
 
 	if (what == DM_REGISTER)
 		return unregister_devices(lc, rs);
-		
+
 	status = dm_status(lc, rs);
 	if (OPT_TEST(lc))
 		log_print(lc, "%s [%sactive]", rs->name, status ? "" : "in");
 	else if (status)
 		ret = dm_remove(lc, rs);
-	else {
+	else
 		log_print(lc, "RAID set \"%s\" is not active", rs->name);
-		ret = 1;
-	}
 
 	return ret;
 }
 
 /* Deactivate a RAID set. */
-static int deactivate_set(struct lib_context *lc, struct raid_set *rs,
-			  enum dm_what what)
+static int
+deactivate_set(struct lib_context *lc, struct raid_set *rs, enum dm_what what)
 {
 	struct raid_set *r;
 
@@ -717,8 +827,7 @@
 	 * Deactivate myself if not a group set,
 	 * which gets never activated itself.
 	 */
-	if (!T_GROUP(rs) &&
-	    !deactivate_superset(lc, rs, what))
+	if (!T_GROUP(rs) && !deactivate_superset(lc, rs, what))
 		return 0;
 
 	/* Deactivate any subsets recursively. */
@@ -732,25 +841,30 @@
 
 
 /* External (de)activate interface. */
-int change_set(struct lib_context *lc, enum activate_type what, void *v)
+int
+change_set(struct lib_context *lc, enum activate_type what, void *v)
 {
-	int ret = 0;
+	int ret;
 	struct raid_set *rs = v;
 
 	switch (what) {
 	case A_ACTIVATE:
 		ret = activate_set(lc, rs, DM_ACTIVATE) &&
-		      activate_set(lc, rs, DM_REGISTER);
+			activate_set(lc, rs, DM_REGISTER);
 		break;
 
 	case A_DEACTIVATE:
 		ret = deactivate_set(lc, rs, DM_REGISTER) &&
-		      deactivate_set(lc, rs, DM_ACTIVATE);
+			deactivate_set(lc, rs, DM_ACTIVATE);
 		break;
 
 	case A_RELOAD:
 		ret = reload_set(lc, rs);
 		break;
+
+	default:
+		log_err(lc, "%s: invalid activate type!", __func__);
+		ret = 0;
 	}
 
 	return ret;
--- dmraid/lib/activate/devmapper.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/activate/devmapper.c	2008/06/20 21:52:16	1.4
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ *
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -24,7 +27,8 @@
 #include <linux/dm-ioctl.h>
 
 /* Make up a dm path. */
-char *mkdm_path(struct lib_context *lc, const char *name)
+char *
+mkdm_path(struct lib_context *lc, const char *name)
 {
 	char *ret;
 	const char *dir = dm_dir();
@@ -38,20 +42,22 @@
 }
 
 /* Device-mapper NULL log function. */
-static void dmraid_log(int level, const char *file, int line,
-		       const char *f, ...)
+static void
+dmraid_log(int level, const char *file, int line, const char *f, ...)
 {
 	return;
 }
 
 /* Init device-mapper library. */
-static void _init_dm(void)
+static void
+_init_dm(void)
 {
 	dm_log_init(dmraid_log);
 }
 
 /* Cleanup at exit. */
-static void _exit_dm(struct dm_task *dmt)
+static void
+_exit_dm(struct dm_task *dmt)
 {
 	if (dmt)
 		dm_task_destroy(dmt);
@@ -65,17 +71,18 @@
  *
  * dm-library must get inititalized by caller.
  */
-static struct dm_versions *get_target_list(void)
+static struct dm_versions *
+get_target_list(void)
 {
 	struct dm_task *dmt;
 
 	return (dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)) &&
-	       dm_task_run(dmt) ? dm_task_get_versions(dmt) : NULL;
+		dm_task_run(dmt) ? dm_task_get_versions(dmt) : NULL;
 }
 
 /* Check a target's name against registered ones. */
-static int valid_ttype(struct lib_context *lc, char *ttype,
-		       struct dm_versions *targets)
+static int
+valid_ttype(struct lib_context *lc, char *ttype, struct dm_versions *targets)
 {
 	struct dm_versions *t, *last;
 
@@ -94,18 +101,20 @@
 			return 1;
 
 		last = t;
-		t = (void*) t + t->next;
+		t = (void *) t + t->next;
 	} while (last != t);
 
-	LOG_ERR(lc, 0, "device-mapper target type \"%s\" not in kernel", ttype);
+	LOG_ERR(lc, 0,
+		"device-mapper target type \"%s\" is not in the kernel", ttype);
 }
 
 /*
  * Parse a mapping table and create the appropriate targets or
  * check that a target type is registered with the device-mapper core.
  */
-static int handle_table(struct lib_context *lc, struct dm_task *dmt,
-			char *table, struct dm_versions *targets)
+static int
+handle_table(struct lib_context *lc, struct dm_task *dmt,
+	     char *table, struct dm_versions *targets)
 {
 	int line = 0, n, ret = 0;
 	uint64_t start, size;
@@ -138,21 +147,25 @@
 }
 
 /* Parse a mapping table and create the appropriate targets. */
-static int parse_table(struct lib_context *lc, struct dm_task *dmt, char *table)
+static int
+parse_table(struct lib_context *lc, struct dm_task *dmt, char *table)
 {
 	return handle_table(lc, dmt, table, NULL);
 }
 
 /* Check if a target type is not registered with the kernel after a failure. */
-static int check_table(struct lib_context *lc, char *table)
+static int
+check_table(struct lib_context *lc, char *table)
 {
 	return handle_table(lc, NULL, table, get_target_list());
 }
 
 /* Build a UUID for a dmraid device 
  * Return 1 for sucess; 0 for failure*/
-static int dmraid_uuid(struct lib_context *lc, struct raid_set *rs,
-		       char *uuid, uint uuid_len) {
+static int
+dmraid_uuid(struct lib_context *lc, struct raid_set *rs,
+	    char *uuid, uint uuid_len)
+{
 	int r;
 
 	/* Clear garbage data from uuid string */
@@ -164,35 +177,39 @@
 }
 
 /* Create a task, set its name and run it. */
-static int run_task(struct lib_context *lc, struct raid_set *rs,
-		    char *table, int type)
+static int
+run_task(struct lib_context *lc, struct raid_set *rs, char *table, int type)
 {
-	/* DM_UUID_LEN is defined in dm-ioctl.h as 129 characters;
+	/*
+	 * DM_UUID_LEN is defined in dm-ioctl.h as 129 characters;
 	 * though not all 129 must be used (md uses just 16 from 
 	 * a quick review of md.c. 
-	 * We will be using: (len vol grp name)*/ 
+	 * We will be using: (len vol grp name)
+	 */
 	char uuid[DM_UUID_LEN];
 	int ret;
 	struct dm_task *dmt;
 
 	_init_dm();
-	ret = (dmt = dm_task_create(type)) &&
-	      dm_task_set_name(dmt, rs->name);
+	ret = (dmt = dm_task_create(type)) && dm_task_set_name(dmt, rs->name);
 	if (ret && table)
 		ret = parse_table(lc, dmt, table);
 
-	if (ret && 
-	    DM_DEVICE_CREATE == type)
-		ret = dmraid_uuid(lc, rs, uuid, DM_UUID_LEN) &&
-		      dm_task_set_uuid(dmt, uuid) &&
-		      dm_task_run(dmt);
+	if (ret) {
+		if (DM_DEVICE_CREATE == type) {
+			ret = dmraid_uuid(lc, rs, uuid, DM_UUID_LEN) &&
+				dm_task_set_uuid(dmt, uuid) && dm_task_run(dmt);
+		} else
+			ret = dm_task_run(dmt);
+	}
 
 	_exit_dm(dmt);
 	return ret;
 }
-	
+
 /* Create a mapped device. */
-int dm_create(struct lib_context *lc, struct raid_set *rs, char *table)
+int
+dm_create(struct lib_context *lc, struct raid_set *rs, char *table)
 {
 	int ret;
 
@@ -210,21 +227,24 @@
 }
 
 /* Suspend a mapped device. */
-int dm_suspend(struct lib_context *lc, struct raid_set *rs)
+int
+dm_suspend(struct lib_context *lc, struct raid_set *rs)
 {
 	/* Suspend <dev_name> */
 	return run_task(lc, rs, NULL, DM_DEVICE_SUSPEND);
 }
 
 /* Resume a mapped device. */
-int dm_resume(struct lib_context *lc, struct raid_set *rs)
+int
+dm_resume(struct lib_context *lc, struct raid_set *rs)
 {
 	/* Resume <dev_name> */
 	return run_task(lc, rs, NULL, DM_DEVICE_RESUME);
 }
 
 /* Reload a mapped device. */
-int dm_reload(struct lib_context *lc, struct raid_set *rs, char *table)
+int
+dm_reload(struct lib_context *lc, struct raid_set *rs, char *table)
 {
 	int ret;
 
@@ -242,7 +262,8 @@
 }
 
 /* Remove a mapped device. */
-int dm_remove(struct lib_context *lc, struct raid_set *rs)
+int
+dm_remove(struct lib_context *lc, struct raid_set *rs)
 {
 	/* Remove <dev_name> */
 	return run_task(lc, rs, NULL, DM_DEVICE_REMOVE);
@@ -250,7 +271,8 @@
 
 /* Retrieve status of a mapped device. */
 /* FIXME: more status for device monitoring... */
-int dm_status(struct lib_context *lc, struct raid_set *rs)
+int
+dm_status(struct lib_context *lc, struct raid_set *rs)
 {
 	int ret;
 	struct dm_task *dmt;
@@ -260,18 +282,15 @@
 
 	/* Status <dev_name>. */
 	ret = (dmt = dm_task_create(DM_DEVICE_STATUS)) &&
-	       dm_task_set_name(dmt, rs->name) &&
-	       dm_task_run(dmt) &&
-	       dm_task_get_info(dmt, &info) &&
-	       info.exists;
-
+	      dm_task_set_name(dmt, rs->name) &&
+	      dm_task_run(dmt) && dm_task_get_info(dmt, &info) && info.exists;
 	_exit_dm(dmt);
-
 	return ret;
 }
 
 /* Retrieve device-mapper driver version. */
-int dm_version(struct lib_context *lc, char *version, size_t size)
+int
+dm_version(struct lib_context *lc, char *version, size_t size)
 {
 	int ret;
 	struct dm_task *dmt;
@@ -282,10 +301,8 @@
 	_init_dm();
 
 	ret = (dmt = dm_task_create(DM_DEVICE_VERSION)) &&
-	       dm_task_run(dmt) &&
-	       dm_task_get_driver_version(dmt, version, size);
-
+		dm_task_run(dmt) &&
+		dm_task_get_driver_version(dmt, version, size);
 	_exit_dm(dmt);
-
 	return ret;
 }
--- dmraid/lib/datastruct/byteorder.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/datastruct/byteorder.h	2008/06/20 21:52:16	1.2
@@ -16,30 +16,33 @@
 
 #ifdef	DM_BYTEORDER_SWAB
 
-static inline uint64_t le64_to_cpu(uint64_t x)
+static inline uint64_t
+le64_to_cpu(uint64_t x)
 {
-	return((((uint64_t)x & 0x00000000000000ffULL) << 56) | 
-	       (((uint64_t)x & 0x000000000000ff00ULL) << 40) | 
-	       (((uint64_t)x & 0x0000000000ff0000ULL) << 24) | 
-	       (((uint64_t)x & 0x00000000ff000000ULL) <<  8) |
-	       (((uint64_t)x & 0x000000ff00000000ULL) >>  8) | 
-	       (((uint64_t)x & 0x0000ff0000000000ULL) >> 24) | 
-	       (((uint64_t)x & 0x00ff000000000000ULL) >> 40) | 
-	       (((uint64_t)x & 0xff00000000000000ULL) >> 56));
+	return ((((uint64_t) x & 0x00000000000000ffULL) << 56) |
+		(((uint64_t) x & 0x000000000000ff00ULL) << 40) |
+		(((uint64_t) x & 0x0000000000ff0000ULL) << 24) |
+		(((uint64_t) x & 0x00000000ff000000ULL) << 8) |
+		(((uint64_t) x & 0x000000ff00000000ULL) >> 8) |
+		(((uint64_t) x & 0x0000ff0000000000ULL) >> 24) |
+		(((uint64_t) x & 0x00ff000000000000ULL) >> 40) |
+		(((uint64_t) x & 0xff00000000000000ULL) >> 56));
 }
 
-static inline int32_t le32_to_cpu(int32_t x)
+static inline int32_t
+le32_to_cpu(int32_t x)
 {
-	return((((u_int32_t)x & 0x000000ffU) << 24) | 
-	       (((u_int32_t)x & 0x0000ff00U) <<  8) | 
-	       (((u_int32_t)x & 0x00ff0000U) >>  8) | 
-	       (((u_int32_t)x & 0xff000000U) >> 24));
+	return ((((u_int32_t) x & 0x000000ffU) << 24) |
+		(((u_int32_t) x & 0x0000ff00U) << 8) |
+		(((u_int32_t) x & 0x00ff0000U) >> 8) |
+		(((u_int32_t) x & 0xff000000U) >> 24));
 }
 
-static inline int16_t le16_to_cpu(int16_t x)
+static inline int16_t
+le16_to_cpu(int16_t x)
 {
-	return((((u_int16_t)x & 0x00ff) << 8) | 
-	       (((u_int16_t)x & 0xff00) >> 8));
+	return ((((u_int16_t) x & 0x00ff) << 8) |
+		(((u_int16_t) x & 0xff00) >> 8));
 }
 
 #define	CVT64(x)	do { x = le64_to_cpu(x); } while(0)
--- dmraid/lib/device/ata.c	2008/02/22 16:57:35	1.1
+++ dmraid/lib/device/ata.c	2008/06/20 21:52:17	1.2
@@ -15,7 +15,8 @@
 #include "dev-io.h"
 #include "ata.h"
 
-int get_ata_serial(struct lib_context *lc, int fd, struct dev_info *di)
+int
+get_ata_serial(struct lib_context *lc, int fd, struct dev_info *di)
 {
 	int ret = 0;
 	const int cmd_offset = 4;
@@ -26,11 +27,14 @@
 		buf[0] = ATA_IDENTIFY_DEVICE;
 		buf[3] = 1;
 		if (!ioctl(fd, HDIO_DRIVE_CMD, buf)) {
-			ata_ident = (struct ata_identify*) &buf[cmd_offset];
-			if ((di->serial = dbg_strdup(remove_white_space(lc, (char*) ata_ident->serial, ATA_SERIAL_LEN))))
+			ata_ident = (struct ata_identify *) &buf[cmd_offset];
+			if ((di->serial =
+			     dbg_strdup(remove_white_space
+					(lc, (char *) ata_ident->serial,
+					 ATA_SERIAL_LEN))))
 				ret = 1;
 		}
-	
+
 		dbg_free(buf);
 	}
 
--- dmraid/lib/device/ata.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/device/ata.h	2008/06/20 21:52:17	1.2
@@ -13,10 +13,10 @@
 struct ata_identify {
 	unsigned short dummy[10];
 #define	ATA_SERIAL_LEN	20
-	unsigned char  serial[ATA_SERIAL_LEN];
+	unsigned char serial[ATA_SERIAL_LEN];
 	unsigned short dummy1[3];
-	unsigned char  fw_rev[8];
-	unsigned char  model[40];
+	unsigned char fw_rev[8];
+	unsigned char model[40];
 	unsigned short dummy2[33];
 	unsigned short major_rev_num;
 	unsigned short minor_rev_num;
--- dmraid/lib/device/dev-io.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/device/dev-io.h	2008/06/20 21:52:17	1.2
@@ -12,8 +12,8 @@
 #include <sys/stat.h>
 #include "internal.h"
 
-#define BLKGETSIZE	_IO(0x12, 0x60) /* get block device size */
-#define BLKSSZGET	_IO(0x12, 0x68) /* get block device sector size */
+#define BLKGETSIZE	_IO(0x12, 0x60)	/* get block device size */
+#define BLKSSZGET	_IO(0x12, 0x68)	/* get block device sector size */
 
 #define	DMRAID_SECTOR_SIZE	512
 
--- dmraid/lib/device/scan.c	2008/02/22 16:57:35	1.1
+++ dmraid/lib/device/scan.c	2008/06/20 21:52:17	1.2
@@ -32,7 +32,8 @@
 #define	_PATH_MOUNTS	"/proc/mounts"
 #endif
 
-static char *find_sysfs_mp(struct lib_context *lc)
+static char *
+find_sysfs_mp(struct lib_context *lc)
 {
 #ifndef __KLIBC__
 	char *ret = NULL;
@@ -57,12 +58,14 @@
 
 	return ret;
 #else
-	return (char*) "/sys";
+	return (char *) "/sys";
 #endif
 }
 
 /* Make up an absolute sysfs path given a relative one. */
-static char *mk_sysfs_path(struct lib_context *lc, char const *path) {
+static char *
+mk_sysfs_path(struct lib_context *lc, char const *path)
+{
 	static char *ret = NULL, *sysfs_mp;
 
 	if (!(sysfs_mp = find_sysfs_mp(lc)))
@@ -78,18 +81,19 @@
 
 /* Test with sparse mapped devices. */
 #ifdef	DMRAID_TEST
-static int dm_test_device(struct lib_context *lc, char *path)
+static int
+dm_test_device(struct lib_context *lc, char *path)
 {
 	struct stat s;
 
 	return !lstat(path, &s) &&
-	       S_ISLNK(s.st_mode) &&
-	       !strncmp(get_basename(lc, path), "dm-", 3);
+		S_ISLNK(s.st_mode) &&
+		!strncmp(get_basename(lc, path), "dm-", 3);
 }
 
 /* Fake a SCSI serial number by reading it from a file. */
-static int get_dm_test_serial(struct lib_context *lc,
-			      struct dev_info *di, char *path)
+static int
+get_dm_test_serial(struct lib_context *lc, struct dev_info *di, char *path)
 {
 	int ret = 1;
 	char *serial, buffer[32];
@@ -121,19 +125,20 @@
  * Ioctl for sector, optionally for device size
  * and get device serial number.
  */
-static int get_device_serial(struct lib_context *lc, int fd,
-			     struct dev_info *di)
+static int
+get_device_serial(struct lib_context *lc, int fd, struct dev_info *di)
 {
 	/*
 	 * In case new generic SCSI ioctl fails,
 	 * try ATA and fall back to old SCSI ioctl.
 	 */
-	return get_scsi_serial(lc, fd, di, SG) || /* SG: generic scsi ioctl. */
-	       get_ata_serial(lc, fd, di) ||	  /* Get ATA serial number. */
-	       get_scsi_serial(lc, fd, di, OLD);  /* OLD: Old scsi ioctl. */
+	return get_scsi_serial(lc, fd, di, SG) ||	/* SG: generic scsi ioctl. */
+		get_ata_serial(lc, fd, di) ||	/* Get ATA serial number. */
+		get_scsi_serial(lc, fd, di, OLD);	/* OLD: Old scsi ioctl. */
 }
 
-static int di_ioctl(struct lib_context *lc, int fd, struct dev_info *di)
+static int
+di_ioctl(struct lib_context *lc, int fd, struct dev_info *di)
 {
 	unsigned int sector_size = 0;
 	unsigned long size;
@@ -156,11 +161,12 @@
 		return get_dm_test_serial(lc, di, di->path);
 	else
 #endif
-	return get_device_serial(lc, fd, di);
+		return get_device_serial(lc, fd, di);
 }
 
 /* Are we interested in this device ? */
-static int interested(struct lib_context *lc, char *path)
+static int
+interested(struct lib_context *lc, char *path)
 {
 	char *name = get_basename(lc, path);
 
@@ -168,19 +174,19 @@
 	 * Whole IDE and SCSI disks only.
 	 */
 	return (!isdigit(name[strlen(name) - 1]) &&
-	       (*(name + 1) == 'd' && (*name == 'h' || *name == 's')))
-
+		(*(name + 1) == 'd' && (*name == 'h' || *name == 's')))
 #ifdef	DMRAID_TEST
-	/*
-	 * Include dm devices for testing.
-	 */
+		/*
+		 * Include dm devices for testing.
+		 */
 		|| dm_test_device(lc, path)
 #endif
-	;
+		;
 }
 
 /* Ask sysfs, if a device is removable. */
-int removable_device(struct lib_context *lc, char *dev_path)
+int
+removable_device(struct lib_context *lc, char *dev_path)
 {
 	int ret = 0;
 	char buf[2], *name, *sysfs_path, *sysfs_file;
@@ -200,8 +206,7 @@
 	sprintf(sysfs_file, "%s/%s/%s", sysfs_path, name, sysfs_removable);
 	if ((f = fopen(sysfs_file, "r"))) {
 		/* Using fread for klibc compatibility. */
-		if (fread(buf, sizeof(char), sizeof(buf) - 1, f) &&
-		    *buf == '1') {
+		if (fread(buf, sizeof(char), sizeof(buf) - 1, f) && *buf == '1') {
 			log_notice(lc, "skipping removable device %s",
 				   dev_path);
 			ret = 1;
@@ -212,7 +217,7 @@
 
 	dbg_free(sysfs_file);
 
-   out:
+      out:
 	dbg_free(sysfs_path);
 
 	return ret;
@@ -222,8 +227,9 @@
  * Read the size in sectors from the sysfs "size" file.
  * Avoid access to removable devices.
  */
-static int sysfs_get_size(struct lib_context *lc, struct dev_info *di,
-			  const char *path, char *name)
+static int
+sysfs_get_size(struct lib_context *lc, struct dev_info *di,
+	       const char *path, char *name)
 {
 	int ret = 0;
 	char buf[22], *sysfs_file;
@@ -253,8 +259,8 @@
 	return ret;
 }
 
-static int get_size(struct lib_context *lc, char *path,
-		    char *name, int sysfs)
+static int
+get_size(struct lib_context *lc, char *path, char *name, int sysfs)
 {
 	int fd, ret = 0;
 	char *dev_path;
@@ -282,7 +288,7 @@
 
 	close(fd);
 
-   out:
+      out:
 	dbg_free(dev_path);
 
 	if (!ret && di)
@@ -295,7 +301,8 @@
  * Find disk devices in sysfs or directly
  * in /dev (for Linux 2.4) and keep information.
  */
-int discover_devices(struct lib_context *lc, char **devnodes)
+int
+discover_devices(struct lib_context *lc, char **devnodes)
 {
 	int sysfs, ret = 0;
 	char *path, *p;
@@ -307,7 +314,7 @@
 		path = p;
 	} else {
 		sysfs = 0;
-		path = (char*) _PATH_DEV;
+		path = (char *) _PATH_DEV;
 		log_print(lc, "carrying on with %s", path);
 	}
 
@@ -328,7 +335,7 @@
 	closedir(d);
 	ret = 1;
 
-  out:
+      out:
 	if (p)
 		dbg_free(p);
 
--- dmraid/lib/device/scsi.c	2008/02/22 16:57:35	1.1
+++ dmraid/lib/device/scsi.c	2008/06/20 21:52:17	1.2
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -21,11 +24,12 @@
 /* Thx scsiinfo. */
 
 /* Initialize SCSI inquiry command block (used both with SG and old ioctls). */
-static void set_cmd(unsigned char *cmd, size_t len)
+static void
+set_cmd(unsigned char *cmd, size_t len)
 {
-	cmd[0] = 0x12;	/* INQUIRY */
+	cmd[0] = 0x12;		/* INQUIRY */
 	cmd[1] = 1;
-	cmd[2] = 0x80;	/* page code: SCSI serial */
+	cmd[2] = 0x80;		/* page code: SCSI serial */
 	cmd[3] = 0;
 	cmd[4] = (unsigned char) (len & 0xff);
 	cmd[5] = 0;
@@ -34,7 +38,8 @@
 /*
  * SCSI SG_IO ioctl to get serial number of a unit.
  */
-static int sg_inquiry(int fd, unsigned char *response, size_t response_len)
+static int
+sg_inquiry(int fd, unsigned char *response, size_t response_len)
 {
 	unsigned char cmd[6];
 	struct sg_io_hdr io_hdr;
@@ -43,30 +48,29 @@
 
 	/* Initialize generic (SG) SCSI ioctl header. */
 	memset(&io_hdr, 0, sizeof(io_hdr));
-	io_hdr.interface_id	= 'S';
-	io_hdr.cmdp		= cmd;
-	io_hdr.cmd_len		= sizeof(cmd);
-	io_hdr.sbp		= NULL;
-	io_hdr.mx_sb_len	= 0;
-	io_hdr.dxfer_direction	= SG_DXFER_FROM_DEV;
-	io_hdr.dxferp		= response;
-	io_hdr.dxfer_len	= response_len;
-	io_hdr.timeout		= 6000; /* [ms] */
-
+	io_hdr.interface_id = 'S';
+	io_hdr.cmdp = cmd;
+	io_hdr.cmd_len = sizeof(cmd);
+	io_hdr.sbp = NULL;
+	io_hdr.mx_sb_len = 0;
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxferp = response;
+	io_hdr.dxfer_len = response_len;
+	io_hdr.timeout = 6000;	/* [ms] */
 	return ioctl(fd, SG_IO, &io_hdr) ? 0 : 1;
 }
 
 /*
  * Old SCSI ioctl as fallback to get serial number of a unit.
  */
-static int old_inquiry(int fd, unsigned char *response, size_t response_len)
+static int
+old_inquiry(int fd, unsigned char *response, size_t response_len)
 {
-	unsigned int *i = (unsigned int*) response;
-
-	i[0] = 0; /* input data length */
-	i[1] = response_len; /* output buffer length */
-	set_cmd((unsigned char*) &i[2], response_len); 
+	unsigned int *i = (unsigned int *) response;
 
+	i[0] = 0;		/* input data length */
+	i[1] = response_len;	/* output buffer length */
+	set_cmd((unsigned char *) &i[2], response_len);
 	return ioctl(fd, SCSI_IOCTL_SEND_COMMAND, response) ? 0 : 1;
 }
 
@@ -74,8 +78,9 @@
  * Retrieve SCSI serial number.
  */
 #define	MAX_RESPONSE_LEN	255
-int get_scsi_serial(struct lib_context *lc, int fd, struct dev_info *di,
-		    enum ioctl_type type)
+int
+get_scsi_serial(struct lib_context *lc, int fd, struct dev_info *di,
+		enum ioctl_type type)
 {
 	int ret = 0;
 	size_t actual_len;
@@ -85,11 +90,11 @@
 	 * string length field (serial string follows length field immediately)
 	 */
 	struct {
-		int (*ioctl_func)(int, unsigned char*, size_t);
+		int (*ioctl_func) (int, unsigned char *, size_t);
 		unsigned int start;
 	} param[] = {
-		{ sg_inquiry ,  3 },
-		{ old_inquiry, 11 },
+		{ sg_inquiry, 3},
+		{ old_inquiry, 11},
 	}, *p = (SG == type) ? param : param + 1;
 
 	if (!(response = dbg_malloc(MAX_RESPONSE_LEN)))
@@ -104,10 +109,32 @@
 			ret = p->ioctl_func(fd, response, actual_len);
 		}
 
-		ret = ret && (di->serial = dbg_strdup(remove_white_space(lc, (char*) &response[p->start + 1], serial_len)));
+		ret = ret &&
+		     (di->serial = dbg_strdup(remove_white_space (lc, (char *) &response[p->start + 1], serial_len)));
 	}
 
 	dbg_free(response);
+	return ret;
+}
+
+int
+get_scsi_id(struct lib_context *lc, int fd, struct sg_scsi_id *sg_id)
+{
+	int ret = 1;
+
+	struct scsi_idlun {
+		int four_in_one;
+		int host_uniqe_id;
+	} lun;
+
+	if (!ioctl(fd, SCSI_IOCTL_GET_IDLUN, &lun)) {
+		sg_id->host_no = (lun.four_in_one >> 24) & 0xff;
+		sg_id->channel = (lun.four_in_one >> 16) & 0xff;
+		sg_id->scsi_id = lun.four_in_one & 0xff;
+		sg_id->lun = (lun.four_in_one >> 8) & 0xff;
+	} else
+		ret = 0;
 
 	return ret;
+
 }
--- dmraid/lib/device/scsi.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/device/scsi.h	2008/06/20 21:52:17	1.2
@@ -1,13 +1,18 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
 #ifndef	_SCSI_H_
 #define	_SCSI_H_
 
+#include <scsi/sg.h>
+
 /* Ioctl types possible (SG = SCSI generic, OLD = old SCSI command ioctl. */
 enum ioctl_type {
 	SG,
@@ -16,5 +21,6 @@
 
 int get_scsi_serial(struct lib_context *lc, int fd,
 		    struct dev_info *di, enum ioctl_type type);
+int get_scsi_id(struct lib_context *lc, int fd, struct sg_scsi_id *sg_id);
 
 #endif
--- dmraid/lib/display/display.c	2008/02/22 16:57:35	1.1
+++ dmraid/lib/display/display.c	2008/06/20 21:52:17	1.2
@@ -14,28 +14,32 @@
 struct log_handler {
 	const char *field;
 	const unsigned char minlen;
-	void (*log_func)(struct lib_context*, void *arg);
+	void (*log_func) (struct lib_context *, void *arg);
 	void *arg;
 };
 
-static void log_string(struct lib_context *lc, void *arg)
+static void
+log_string(struct lib_context *lc, void *arg)
 {
-	log_print_nnl(lc, "%s", (char*) arg);
+	log_print_nnl(lc, "%s", (char *) arg);
 }
 
-static void log_uint64(struct lib_context *lc, void *arg)
+static void
+log_uint64(struct lib_context *lc, void *arg)
 {
-	log_print_nnl(lc, "%" PRIu64, *((uint64_t*) arg));
+	log_print_nnl(lc, "%" PRIu64, *((uint64_t *) arg));
 }
 
-static void log_uint(struct lib_context *lc, void *arg)
+static void
+log_uint(struct lib_context *lc, void *arg)
 {
-	log_print_nnl(lc, "%u", *((unsigned int*) arg));
+	log_print_nnl(lc, "%u", *((unsigned int *) arg));
 }
 
 /* Log a structure member by field name. */
-static int log_field(struct lib_context *lc, const struct log_handler *lh,
-		     size_t lh_size, char *field)
+static int
+log_field(struct lib_context *lc, const struct log_handler *lh,
+	  size_t lh_size, char *field)
 {
 	const struct log_handler *h;
 
@@ -55,13 +59,14 @@
 }
 
 /* Log a list of structure members by field name. */
-static void log_fields(struct lib_context *lc, const struct log_handler *lh,
-		       size_t lh_size) {
+static void
+log_fields(struct lib_context *lc, const struct log_handler *lh, size_t lh_size)
+{
 	int logged = 0, last_logged = 0;
 	const char delim = *OPT_STR_SEPARATOR(lc);
 	char *p, *sep, *sep_sav;
 
-	if (!(sep_sav = dbg_strdup((char*) OPT_STR_COLUMN(lc)))) {
+	if (!(sep_sav = dbg_strdup((char *) OPT_STR_COLUMN(lc)))) {
 		log_alloc_err(lc, __func__);
 		return;
 	}
@@ -83,28 +88,30 @@
 }
 
 /* Display information about a block device */
-static void log_disk(struct lib_context *lc, struct list_head *pos)
+static void
+log_disk(struct lib_context *lc, struct list_head *pos)
 {
 	struct dev_info *di = list_entry(pos, typeof(*di), list);
 
 	if (OPT_STR_COLUMN(lc)) {
 		const struct log_handler log_handlers[] = {
-			{ "devpath", 1, log_string, di->path},
-			{ "path", 1, log_string, di->path},
-			{ "sectors", 3, log_uint64, &di->sectors},
-			{ "serialnumber", 3, log_string,
-			  di->serial ? (void*) di->serial : (void*) "N/A"},
-			{ "size", 2, log_uint64, &di->sectors},
+			{"devpath", 1, log_string, di->path},
+			{"path", 1, log_string, di->path},
+			{"sectors", 3, log_uint64, &di->sectors},
+			{"serialnumber", 3, log_string,
+			 di->serial ? (void *) di->serial : (void *) "N/A"},
+			{"size", 2, log_uint64, &di->sectors},
 		};
 
 		log_fields(lc, log_handlers, ARRAY_SIZE(log_handlers));
-	} else {
+	}
+	else {
 		const char *fmt[] = {
 			"%s: %12" PRIu64 " total, \"%s\"",
 			"%s",
 			"%s:%" PRIu64 ":\"%s\"",
 		};
-	
+
 		log_print(lc, fmt[ARRAY_LIMIT(fmt, OPT_COLUMN(lc))],
 			  di->path, di->sectors,
 			  di->serial ? di->serial : "N/A");
@@ -112,54 +119,59 @@
 }
 
 /* Turn NULL (= "unknown") into a displayable string. */
-static const char *check_null(const char *str)
+static const char *
+check_null(const char *str)
 {
 	return str ? str : "unknown";
 }
 
 /* Log native RAID device information. */
-static void log_rd_native(struct lib_context *lc, struct list_head *pos)
+static void
+log_rd_native(struct lib_context *lc, struct list_head *pos)
 {
 	struct raid_dev *rd = list_entry(pos, typeof(*rd), list);
 
 	if (rd->fmt->log) {
 		rd->fmt->log(lc, rd);
 		log_print(lc, "");
-	} else
+	}
+	else
 		log_print(lc, "\"%s\" doesn't support native logging of RAID "
 			  "device information", rd->fmt->name);
 }
 
 /* Display information about a RAID device */
-static void log_rd(struct lib_context *lc, struct list_head *pos)
+static void
+log_rd(struct lib_context *lc, struct list_head *pos)
 {
 	struct raid_dev *rd = list_entry(pos, typeof(*rd), list);
 
 	if (OPT_STR_COLUMN(lc)) {
 		const struct log_handler log_handlers[] = {
-			{ "dataoffset", 2, log_uint64, &rd->offset},
-			{ "devpath", 2, log_string, rd->di->path },
-			{ "format", 1, log_string, (void*) rd->fmt->name },
-			{ "offset", 1, log_uint64, &rd->offset},
-			{ "path", 1, log_string, rd->di->path },
-			{ "raidname", 1, log_string, rd->name },
-			{ "type", 1, log_string,
-			  (void*) check_null(get_type(lc, rd->type)) },
-			{ "sectors", 2, log_uint64, &rd->sectors},
-			{ "size", 2, log_uint64, &rd->sectors},
-			{ "status", 2, log_string,
-			  (void*) check_null(get_status(lc, rd->status)) },
+			{"dataoffset", 2, log_uint64, &rd->offset},
+			{"devpath", 2, log_string, rd->di->path},
+			{"format", 1, log_string, (void *) rd->fmt->name},
+			{"offset", 1, log_uint64, &rd->offset},
+			{"path", 1, log_string, rd->di->path},
+			{"raidname", 1, log_string, rd->name},
+			{"type", 1, log_string,
+			 (void *) check_null(get_type(lc, rd->type))},
+			{"sectors", 2, log_uint64, &rd->sectors},
+			{"size", 2, log_uint64, &rd->sectors},
+			{"status", 2, log_string,
+			 (void *) check_null(get_status(lc, rd->status))},
 		};
 
 		log_fields(lc, log_handlers, ARRAY_SIZE(log_handlers));
-	} else {
+	}
+	else {
 		const char *fmt[] = {
 			"%s: %s, \"%s\", %s, %s, %" PRIu64 " sectors, "
-			"data@ %" PRIu64,
+				"data@ %" PRIu64,
 			"%s",
 			"%s:%s:%s:%s:%s:%" PRIu64 ":%" PRIu64,
 		};
-	
+
 		log_print(lc, fmt[ARRAY_LIMIT(fmt, OPT_COLUMN(lc))],
 			  rd->di->path, rd->fmt->name, rd->name,
 			  check_null(get_type(lc, rd->type)),
@@ -169,17 +181,18 @@
 }
 
 /* Dispatch log functions. */
-static void log_devices(struct lib_context *lc, enum dev_type type)
+static void
+log_devices(struct lib_context *lc, enum dev_type type)
 {
 	struct list_head *pos;
 	struct {
 		enum dev_type type;
 		struct list_head *list;
-		void (*log)(struct lib_context *, struct list_head *);
+		void (*log) (struct lib_context *, struct list_head *);
 	} types[] = {
 		{ DEVICE, LC_DI(lc), log_disk },
 		{ NATIVE, LC_RD(lc), log_rd_native },
-		{ RAID,   LC_RD(lc), log_rd },
+		{ RAID, LC_RD(lc), log_rd },
 	}, *t = types;
 
 	do {
@@ -189,13 +202,14 @@
 
 			return;
 		}
-	} while (t++ < ARRAY_END(types));
+	} while (++t < ARRAY_END(types));
 
-	LOG_ERR(lc, , "%s: unknown device type", __func__);
+	LOG_ERR(lc,, "%s: unknown device type", __func__);
 }
 
 /* Display information about a dmraid format handler */
-static void log_format(struct lib_context *lc, struct dmraid_format *fmt)
+static void
+log_format(struct lib_context *lc, struct dmraid_format *fmt)
 {
 	log_print_nnl(lc, "%-7s : %s", fmt->name, fmt->descr);
 	if (fmt->caps)
@@ -205,7 +219,8 @@
 }
 
 /* Pretty print a mapping table. */
-void display_table(struct lib_context *lc, char *rs_name, char *table)
+void
+display_table(struct lib_context *lc, char *rs_name, char *table)
 {
 	char *nl = table, *p;
 
@@ -217,89 +232,92 @@
 }
 
 /* Display information about devices depending on device type. */
-void display_devices(struct lib_context *lc, enum dev_type type)
+void
+display_devices(struct lib_context *lc, enum dev_type type)
 {
 	int devs;
 
 	if ((devs = count_devices(lc, type))) {
 		log_info(lc, "%s device%s discovered:\n",
-			 (type & (RAID|NATIVE)) ? "RAID" : "Block",
-			  devs == 1 ? "" : "s");
+			 (type & (RAID | NATIVE)) ? "RAID" : "Block",
+			 devs == 1 ? "" : "s");
 
 		log_devices(lc, type);
 	}
 }
 
 /* Retrieve format name from (hierarchical) raid set. */
-static void *get_format_name(struct raid_set *rs)
+static void *
+get_format_name(struct raid_set *rs)
 {
 	struct dmraid_format *fmt = get_format(rs);
 
-	return (void*) check_null(fmt ? fmt->name : NULL);
+	return (void *) check_null(fmt ? fmt->name : NULL);
 }
 
-static void log_rs(struct lib_context *lc, struct raid_set *rs)
+static void
+log_rs(struct lib_context *lc, struct raid_set *rs)
 {
 	unsigned int devs = 0, spares = 0, subsets = 0;
 	uint64_t sectors = 0;
 
 	if (T_GROUP(rs) && !OPT_GROUP(lc))
 		return;
-	
+
 	sectors = total_sectors(lc, rs);
 	subsets = count_sets(lc, &rs->sets);
-	devs    = count_devs(lc, rs, ct_dev);
-	spares  = count_devs(lc, rs, ct_spare);
-	
+	devs = count_devs(lc, rs, ct_dev);
+	spares = count_devs(lc, rs, ct_spare);
+
 	if (OPT_STR_COLUMN(lc)) {
 		const struct log_handler log_handlers[] = {
-			{ "devices", 1, log_uint, &devs },
-			{ "format", 1, log_string, get_format_name(rs) },
-			{ "raidname", 1, log_string, rs->name },
-			{ "sectors", 2, log_uint64, &sectors },
-			{ "size", 2, log_uint64, &sectors },
-			{ "spares", 2, log_uint, &spares },
-			{ "status", 3, log_string,
-			   (void*) check_null(get_status(lc, rs->status)) },
-			{ "stride", 3, log_uint, &rs->stride },
-			{ "subsets", 2, log_uint, &subsets },
-			{ "type", 1, log_string,
-			   (void*) check_null(get_set_type(lc, rs)) },
+			{"devices", 1, log_uint, &devs},
+			{"format", 1, log_string, get_format_name(rs)},
+			{"raidname", 1, log_string, rs->name},
+			{"sectors", 2, log_uint64, &sectors},
+			{"size", 2, log_uint64, &sectors},
+			{"spares", 2, log_uint, &spares},
+			{"status", 3, log_string,
+			 (void *) check_null(get_status(lc, rs->status))},
+			{"stride", 3, log_uint, &rs->stride},
+			{"subsets", 2, log_uint, &subsets},
+			{"type", 1, log_string,
+			 (void *) check_null(get_set_type(lc, rs))},
 		};
 
 		log_fields(lc, log_handlers, ARRAY_SIZE(log_handlers));
-	} else {
+	}
+	else {
 		const char *fmt[] = {
 			"name   : %s\n"
-			"size   : %" PRIu64 "\n"
-			"stride : %u\n"
-			"type   : %s\n"
-			"status : %s\n"
-			"subsets: %u\n"
-			"devs   : %u\n"
-			"spares : %u",
+				"size   : %" PRIu64 "\n"
+				"stride : %u\n"
+				"type   : %s\n"
+				"status : %s\n"
+				"subsets: %u\n" "devs   : %u\n" "spares : %u",
 			"%s",
 			"%s:%" PRIu64 ":%u:%s:%s:%u:%u:%u",
 		};
 		unsigned int o = ARRAY_LIMIT(fmt, lc_opt(lc, LC_COLUMN));
-	
+
 		log_print(lc, fmt[o],
 			  rs->name, sectors, rs->stride,
 			  check_null(get_set_type(lc, rs)),
 			  check_null(get_status(lc, rs->status)),
 			  subsets, devs, spares);
-	
+
 	}
 
 	if (OPT_COLUMN(lc) > 2) {
 		struct raid_dev *rd;
-	
+
 		list_for_each_entry(rd, &rs->devs, devs)
 			log_rd(lc, &rd->list);
 	}
 }
 
-static int group_active(struct lib_context *lc, struct raid_set *rs)
+static int
+group_active(struct lib_context *lc, struct raid_set *rs)
 {
 	struct raid_set *r;
 
@@ -312,8 +330,8 @@
 }
 
 /* FIXME: Spock, do something better (neater). */
-void display_set(struct lib_context *lc, void *v,
-		 enum active_type active, int top)
+void
+display_set(struct lib_context *lc, void *v, enum active_type active, int top)
 {
 	struct raid_set *rs = v;
 	struct raid_set *r;
@@ -328,20 +346,19 @@
 			log_print(lc, "*** Group superset %s", rs->name);
 		else {
 			log_print(lc, "%s %s%s%set",
-		  		top ? "-->" : "***",
-		  		S_INCONSISTENT(rs->status) ?
-				"*Inconsistent* " : "",
-		  		dm_status(lc, rs) ? "Active " : "",
-		  		SETS(rs) ? "Supers" : (top ? "Subs" : "S"));
+				  top ? "-->" : "***",
+				  S_INCONSISTENT(rs->status) ?
+				  "*Inconsistent* " : "",
+				  dm_status(lc, rs) ? "Active " : "",
+				  SETS(rs) ? "Supers" : (top ? "Subs" : "S"));
 		}
 	}
 
 	log_rs(lc, rs);
 
 	/* Optionally display subsets. */
-	if (T_GROUP(rs) || /* Always display for GROUP sets. */
-	    OPT_SETS(lc) > 1 ||
-	    OPT_COLUMN(lc) > 2) {
+	if (T_GROUP(rs) ||	/* Always display for GROUP sets. */
+	    OPT_SETS(lc) > 1 || OPT_COLUMN(lc) > 2) {
 		list_for_each_entry(r, &rs->sets, list)
 			display_set(lc, r, active, ++top);
 	}
@@ -351,7 +368,8 @@
  * Display information about supported RAID metadata formats
  * (ie. registered format handlers)
  */
-static void _list_formats(struct lib_context *lc, enum fmt_type type)
+static void
+_list_formats(struct lib_context *lc, enum fmt_type type)
 {
 	struct format_list *fmt_list;
 
@@ -361,7 +379,8 @@
 	}
 }
 
-int list_formats(struct lib_context *lc, int arg)
+int
+list_formats(struct lib_context *lc, int arg)
 {
 	log_info(lc, "supported metadata formats:");
 	_list_formats(lc, FMT_RAID);
--- dmraid/lib/format/format.c	2008/04/02 13:35:31	1.4
+++ dmraid/lib/format/format.c	2008/06/20 21:52:17	1.5
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -46,30 +49,39 @@
 	{ "name", offset(name), FMT_ALL },
 	{ "description", offset(descr), FMT_ALL },
 	{ "capabilities", offset(caps), 0 },
-	{ "read", offset(read), FMT_ALL|FMT_METHOD },
+	{ "read", offset(read), FMT_ALL | FMT_METHOD },
 	{ "write", offset(write), FMT_METHOD },
-	{ "group", offset(group), FMT_ALL|FMT_METHOD },
-	{ "check", offset(check), FMT_ALL|FMT_METHOD },
+	{ "create", offset(create), FMT_METHOD },
+	{ "delete", offset(delete), FMT_METHOD },
+	{ "group", offset(group), FMT_ALL | FMT_METHOD },
+	{ "check", offset(check), FMT_ALL | FMT_METHOD },
 	{ "events array", offset(events), 0 },
 #ifdef	NATIVE_LOG
 	{ "log", offset(log), FMT_METHOD },
 #endif
 };
+
 #undef	offset
 
-static int check_member(struct lib_context *lc, struct dmraid_format *fmt,
-			struct format_member *member)
+static int
+check_member(struct lib_context *lc, struct dmraid_format *fmt,
+	     struct format_member *member)
 {
 	if ((!IS_FMT_ALL(member) && fmt->format != FMT_RAID) ||
-	    *((unsigned long*) (((unsigned char*) fmt) + member->offset)))
+	    *((unsigned long *) (((unsigned char *) fmt) + member->offset)))
 		return 0;
 
-	LOG_ERR(lc, 1, "%s: missing metadata format handler %s%s",
-		fmt->name, member->msg, IS_FMT_METHOD(member) ? " method" : "");
+	/* show error in case method is required for all handlers */
+	if (IS_FMT_ALL(member))
+		LOG_ERR(lc, 1, "%s: missing metadata format handler %s%s",
+			fmt->name, member->msg,
+			IS_FMT_METHOD(member) ? " method" : "");
+
+	return 0;
 }
 
-static int check_format_handler(struct lib_context *lc,
-				struct dmraid_format *fmt)
+static int
+check_format_handler(struct lib_context *lc, struct dmraid_format *fmt)
 {
 	unsigned int error = 0;
 	struct format_member *fm = format_member;
@@ -87,7 +99,8 @@
 /*
  * Register a RAID metadata format handler.
  */
-int register_format_handler(struct lib_context *lc, struct dmraid_format *fmt)
+int
+register_format_handler(struct lib_context *lc, struct dmraid_format *fmt)
 {
 	struct format_list *fl;
 
@@ -99,7 +112,8 @@
 	if ((fl = dbg_malloc(sizeof(*fl)))) {
 		fl->fmt = fmt;
 		list_add_tail(&fl->list, LC_FMT(lc));
-	}
+	} else
+		log_alloc_err(lc, __func__);
 
 	return fl ? 1 : 0;
 }
@@ -110,13 +124,14 @@
  * I use an array because of the growing number...
  */
 static struct register_fh {
-	int (*func)(struct lib_context *lc);
+	int (*func) (struct lib_context * lc);
 } register_fh[] = {
 #include "register.h"
 	{ NULL },
 };
 
-void unregister_format_handlers(struct lib_context *lc)
+void
+unregister_format_handlers(struct lib_context *lc)
 {
 	struct list_head *elem, *tmp;
 
@@ -126,7 +141,8 @@
 	}
 }
 
-int register_format_handlers(struct lib_context *lc)
+int
+register_format_handlers(struct lib_context *lc)
 {
 	int ret = 1;
 	struct register_fh *fh;
@@ -143,6 +159,7 @@
 
 	return ret;
 }
+
 /* END metadata format handler registry. */
 
 
@@ -151,7 +168,8 @@
  */
 
 /* Allocate private space in format handlers (eg, for on-disk metadata). */
-void *alloc_private(struct lib_context *lc, const char *who, size_t size)
+void *
+alloc_private(struct lib_context *lc, const char *who, size_t size)
 {
 	void *ret;
 
@@ -162,8 +180,9 @@
 }
 
 /* Allocate private space in format handlers and read data off device. */
-void *alloc_private_and_read(struct lib_context *lc, const char *who,
-			     size_t size, char *path, loff_t offset)
+void *
+alloc_private_and_read(struct lib_context *lc, const char *who,
+		       size_t size, char *path, loff_t offset)
 {
 	void *ret;
 
@@ -179,8 +198,9 @@
 
 
 /* Allocate metadata sector array in format handlers. */
-void *alloc_meta_areas(struct lib_context *lc, struct raid_dev *rd,
-		       const char *who, unsigned int n)
+void *
+alloc_meta_areas(struct lib_context *lc, struct raid_dev *rd,
+		 const char *who, unsigned int n)
 {
 	void *ret;
 
@@ -191,8 +211,9 @@
 }
 
 /* Simple metadata write function for format handlers. */
-static int _write_metadata(struct lib_context *lc, const char *handler,
-			   struct raid_dev *rd, int idx, int erase)
+static int
+_write_metadata(struct lib_context *lc, const char *handler,
+		struct raid_dev *rd, int idx, int erase)
 {
 	int ret = 0;
 	void *p, *tmp;
@@ -205,25 +226,26 @@
 	    !(p = alloc_private(lc, handler, rd->meta_areas[idx].size)))
 		goto out;
 
-	ret = write_file(lc, handler, rd->di->path, (void*) p,
+	ret = write_file(lc, handler, rd->di->path, (void *) p,
 			 rd->meta_areas[idx].size,
 			 rd->meta_areas[idx].offset << 9);
 
-	log_level(lc, ret ? _PLOG_DEBUG : _PLOG_ERR, 
+	log_level(lc, ret ? _PLOG_DEBUG : _PLOG_ERR,
 		  "writing metadata to %s, offset %" PRIu64 " sectors, "
 		  "size %zu bytes returned %d",
 		  rd->di->path, rd->meta_areas[idx].offset,
-		  rd->meta_areas[idx].size, ret); 
+		  rd->meta_areas[idx].size, ret);
 
 	if (p != tmp)
 		dbg_free(p);
 
-  out:
+      out:
 	return ret;
 }
 
-int write_metadata(struct lib_context *lc, const char *handler,
-		   struct raid_dev *rd, int idx, int erase)
+int
+write_metadata(struct lib_context *lc, const char *handler,
+	       struct raid_dev *rd, int idx, int erase)
 {
 	unsigned int i;
 
@@ -244,16 +266,16 @@
  * a. spares in a mirror set need to be large enough.
  * b. # of devices correct.
  */
-static void _check_raid_set(struct lib_context *lc, struct raid_set *rs,
-		       unsigned int (*f_devices)(struct raid_dev *rd,
-						 void *context),
-		       void *f_devices_context,
-		       int (*f_check)(struct lib_context *lc,
-				      struct raid_set *rs,
-				      struct raid_dev *rd,
-				      void *context),
-		       void *f_check_context,
-		       const char *handler)
+static void
+_check_raid_set(struct lib_context *lc, struct raid_set *rs,
+		unsigned int (*f_devices) (struct raid_dev * rd,
+					   void *context),
+		void *f_devices_context,
+		int (*f_check) (struct lib_context * lc,
+				struct raid_set * rs,
+				struct raid_dev * rd,
+				void *context),
+		void *f_check_context, const char *handler)
 {
 	unsigned int devs;
 	uint64_t sectors;
@@ -270,8 +292,7 @@
 		rs->found_devs = devices;
 
 		log_dbg(lc, "checking %s device \"%s\"", handler, rd->di->path);
-		if (T_SPARE(rd) &&
-		    rs->type == t_raid1 &&	/* FIXME: rs->type check ? */
+		if (T_SPARE(rd) && rs->type == t_raid1 &&	/* FIXME: rs->type check ? */
 		    rd->sectors != sectors) {
 			rd->status = s_inconsistent;
 			log_err(lc, "%s: size mismatch in set \"%s\", spare "
@@ -280,12 +301,11 @@
 		}
 
 		if (devs != devices &&
-		    f_check &&
-		    !f_check(lc, rs, rd, f_check_context)) {
+		    f_check && !f_check(lc, rs, rd, f_check_context)) {
 			rd->status = s_broken;
 			log_err(lc, "%s: wrong # of devices in RAID "
 				"set \"%s\" [%u/%u] on %s",
-	   			handler, rs->name, devs, devices, rd->di->path);
+				handler, rs->name, devs, devices, rd->di->path);
 		} else
 			rd->status = s_ok;
 	}
@@ -301,8 +321,9 @@
  * In case of lowest level RAID sets, check consistence of devices
  * and make the above decision at the device level.
  */
-static void _set_rs_status(struct lib_context *lc, struct raid_set *rs,
-			   unsigned int i, unsigned int operational)
+static void
+_set_rs_status(struct lib_context *lc, struct raid_set *rs,
+	       unsigned int i, unsigned int operational)
 {
 	if (operational == i)
 		rs->status = s_ok;
@@ -314,7 +335,8 @@
 	log_dbg(lc, "set status of set \"%s\" to %u", rs->name, rs->status);
 }
 
-static int set_rs_status(struct lib_context *lc, struct raid_set *rs)
+static int
+set_rs_status(struct lib_context *lc, struct raid_set *rs)
 {
 	unsigned int i = 0, operational = 0;
 	struct raid_set *r;
@@ -327,16 +349,15 @@
 		if (S_OK(r->status) || S_INCONSISTENT(r->status))
 			operational++;
 	}
-	
+
 	/* Check status of devices... */
 	list_for_each_entry(rd, &rs->devs, devs) {
 		i++;
 		if (S_OK(rd->status))
 			operational++;
 	}
-	
-	_set_rs_status(lc, rs, i, operational);
 
+	_set_rs_status(lc, rs, i, operational);
 	return S_BROKEN(rs->status) ? 0 : 1;
 }
 
@@ -346,14 +367,14 @@
  * This tiny helper function avoids coding recursive
  * RAID set stack unrolling in every metadata format handler.
  */
-int check_raid_set(struct lib_context *lc, struct raid_set *rs,
-		   unsigned int (*f_devices)(struct raid_dev *rd,
-					     void *context),
-		   void *f_devices_context,
-		   int (*f_check)(struct lib_context *lc, struct raid_set *r,
-				  struct raid_dev *rd, void *context),
-		   void *f_check_context,
-		   const char *handler)
+int
+check_raid_set(struct lib_context *lc, struct raid_set *rs,
+	       unsigned int (*f_devices) (struct raid_dev * rd,
+					  void *context),
+	       void *f_devices_context,
+	       int (*f_check) (struct lib_context * lc, struct raid_set * r,
+			       struct raid_dev * rd, void *context),
+	       void *f_check_context, const char *handler)
 {
 	struct raid_set *r;
 
@@ -370,9 +391,10 @@
 }
 
 /* Initialize a RAID sets type and stride. */
-int init_raid_set(struct lib_context *lc, struct raid_set *rs,
-		  struct raid_dev *rd, unsigned int stride,
-		  unsigned int type, const char *handler)
+int
+init_raid_set(struct lib_context *lc, struct raid_set *rs,
+	      struct raid_dev *rd, unsigned int stride,
+	      unsigned int type, const char *handler)
 {
 	if (T_UNDEF(rd))
 		LOG_ERR(lc, 0, "%s: RAID type %u not supported", handler, type);
@@ -395,22 +417,21 @@
 }
 
 /* Discover RAID metadata and setup RAID device. */
-struct raid_dev *read_raid_dev(
-	struct lib_context *lc,
-	struct dev_info *di,
-	void* (*f_read_metadata)(struct lib_context *lc, struct dev_info *di,
-				 size_t *size, uint64_t *offset,
-				 union read_info *info),
-	size_t size, uint64_t offset,
-	void (*f_to_cpu)(void *meta),
-	int (*f_is_meta)(struct lib_context *lc, struct dev_info *di,
-			 void *meta),
-	void (*f_file_metadata)(struct lib_context *lc, struct dev_info *di,
+struct raid_dev *
+read_raid_dev(struct lib_context *lc,
+	      struct dev_info *di,
+	      void *(*f_read_metadata) (struct lib_context * lc,
+					struct dev_info * di, size_t * size,
+					uint64_t * offset,
+					union read_info * info), size_t size,
+	      uint64_t offset, void (*f_to_cpu) (void *meta),
+	      int (*f_is_meta) (struct lib_context * lc, struct dev_info * di,
 				void *meta),
-	int (*f_setup_rd)(struct lib_context *lc, struct raid_dev *rd,
-			  struct dev_info *di, void *meta,
-			  union read_info *info),
-	const char *handler)
+	      void (*f_file_metadata) (struct lib_context * lc,
+				       struct dev_info * di, void *meta),
+	      int (*f_setup_rd) (struct lib_context * lc, struct raid_dev * rd,
+				 struct dev_info * di, void *meta,
+				 union read_info * info), const char *handler)
 {
 	struct raid_dev *rd = NULL;
 	void *meta;
@@ -421,10 +442,9 @@
 	 * metadata read function, use that. If not, allocate and
 	 * read size from offset.
 	 */
-	meta = f_read_metadata ? f_read_metadata(lc, di, &size, &offset,
-						 &info) :
-				 alloc_private_and_read(lc, handler, size,
-							di->path, offset);
+	meta = f_read_metadata ?
+	       f_read_metadata(lc, di, &size, &offset, &info) :
+		alloc_private_and_read(lc, handler, size, di->path, offset);
 	if (!meta)
 		goto out;
 
@@ -456,14 +476,15 @@
 	free_raid_dev(lc, &rd);
 	goto out;
 
-   bad:
+      bad:
 	dbg_free(meta);
-   out:
+      out:
 	return rd;
 }
 
 /* Check if format identifier is valid. */
-int check_valid_format(struct lib_context *lc, char *name)
+int
+check_valid_format(struct lib_context *lc, char *name)
 {
 	struct format_list *fl;
 
@@ -479,13 +500,14 @@
 /*
  * Set up a format capabilities (ie, RAID levels) string array.
  */
-const char **get_format_caps(struct lib_context *lc, struct dmraid_format *fmt)
+const char **
+get_format_caps(struct lib_context *lc, struct dmraid_format *fmt)
 {
 	int i;
 	char *caps, *p;
 	const char **ret = NULL, delim = ',';
 
-	if (fmt->caps && (caps = dbg_strdup((char*) fmt->caps))) {
+	if (fmt->caps && (caps = dbg_strdup((char *) fmt->caps))) {
 		/* Count capabilities delimiters. */
 		for (i = 0, p = caps; (p = remove_delimiter(p, delim)); i++)
 			add_delimiter(&p, delim);
@@ -494,17 +516,20 @@
 			for (i = 0, p = caps - 1; p;
 			     (p = remove_delimiter(p, delim)))
 				ret[i++] = ++p;
-		} else
+		} else {
+			log_alloc_err(lc, __func__);
 			dbg_free(caps);
+		}
 	}
 
 	return ret;
 }
 
-void free_format_caps(struct lib_context *lc, const char **caps)
+void
+free_format_caps(struct lib_context *lc, const char **caps)
 {
 	if (caps) {
-		dbg_free((char*) *caps);
+		dbg_free((char *) *caps);
 		dbg_free(caps);
 	}
 }
@@ -512,16 +537,16 @@
 /*
  * Allocate a RAID superset and link the subset to it.
  */
-struct raid_set *join_superset(struct lib_context *lc,
-			       char *(*f_name)(struct lib_context *lc,
-					       struct raid_dev *rd,
-					       unsigned int subset),
-			       void (*f_create)(struct raid_set *super,
-					        void *private),
-			       int (*f_set_sort)(struct list_head *pos,
-						 struct list_head *new),
-			       struct raid_set *rs,
-			       struct raid_dev *rd)
+struct raid_set *
+join_superset(struct lib_context *lc,
+	      char *(*f_name) (struct lib_context * lc,
+			       struct raid_dev * rd,
+			       unsigned int subset),
+	      void (*f_create) (struct raid_set * super,
+				void *private),
+	      int (*f_set_sort) (struct list_head * pos,
+				 struct list_head * new),
+	      struct raid_set *rs, struct raid_dev *rd)
 {
 	char *n;
 	struct raid_set *ret = NULL;
@@ -539,7 +564,8 @@
 }
 
 /* Display 'zero sectors on RAID' device error. */
-int log_zero_sectors(struct lib_context *lc, char *path, const char *handler)
+int
+log_zero_sectors(struct lib_context *lc, char *path, const char *handler)
 {
 	LOG_ERR(lc, 0, "%s: zero sectors on %s", handler, path);
 }
--- dmraid/lib/format/register.h	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/register.h	2008/06/20 21:52:17	1.3
@@ -15,7 +15,7 @@
 #define	xx(type)	{ register_ ## type },
 
 	/* Metadata format handlers. */
-	xx(asr)
+xx(asr)
 	xx(ddf1)
 	xx(hpt37x)
 	xx(hpt45x)
@@ -29,6 +29,5 @@
 
 	/* DOS partition type handler. */
 	xx(dos)
-
 #undef	xx
 #endif
--- dmraid/lib/format/ataraid/asr.c	2008/04/02 13:35:31	1.4
+++ dmraid/lib/format/ataraid/asr.c	2008/06/20 21:52:17	1.5
@@ -30,7 +30,9 @@
 static const char *spare_array = ".asr_spares";
 
 /* Map ASR disk status to dmraid status */
-static enum status disk_status(struct asr_raid_configline *disk) {
+static enum status
+disk_status(struct asr_raid_configline *disk)
+{
 	static struct states states[] = {
 		{ LSU_COMPONENT_STATE_OPTIMAL, s_ok },
 		{ LSU_COMPONENT_STATE_DEGRADED, s_broken },
@@ -45,13 +47,14 @@
 
 	return rd_status(states, disk->raidstate, EQUAL);
 }
-		
+
 /* Extract config line from metadata */
-static struct asr_raid_configline *get_config(struct asr *asr, uint32_t magic)
+static struct asr_raid_configline *
+get_config(struct asr *asr, uint32_t magic)
 {
 	struct asr_raidtable *rt = asr->rt;
 	struct asr_raid_configline *cl = rt->ent + rt->elmcnt;
-	
+
 	while (cl-- > rt->ent) {
 		if (cl->raidmagic == magic)
 			return cl;
@@ -61,14 +64,15 @@
 }
 
 /* Get this disk's configuration */
-static struct asr_raid_configline *this_disk(struct asr *asr)
+static struct asr_raid_configline *
+this_disk(struct asr *asr)
 {
 	return get_config(asr, asr->rb.drivemagic);
 }
 
 /* Make up RAID device name. */
-static size_t _name(struct lib_context *lc, struct asr *asr, char *str,
-		    size_t len)
+static size_t
+_name(struct lib_context *lc, struct asr *asr, char *str, size_t len)
 {
 	struct asr_raid_configline *cl = this_disk(asr);
 
@@ -79,7 +83,8 @@
 }
 
 /* Figure out a name for the RAID device. */
-static char *name(struct lib_context *lc, struct asr *asr)
+static char *
+name(struct lib_context *lc, struct asr *asr)
 {
 	size_t len;
 	char *ret;
@@ -93,9 +98,10 @@
 }
 
 /* Stride size */
-static inline unsigned stride(struct asr_raid_configline *cl)
+static inline unsigned
+stride(struct asr_raid_configline *cl)
 {
-	return cl ? cl->strpsize: 0;
+	return cl ? cl->strpsize : 0;
 }
 
 /*
@@ -105,14 +111,15 @@
  * do any of those right now (RAID4 and RAID5 are in the works).
  */
 /* Map the ASR raid type codes into dmraid type codes. */
-static enum type type(struct asr_raid_configline *cl)
+static enum type
+type(struct asr_raid_configline *cl)
 {
 	/* Mapping of template types to generic types */
 	static struct types types[] = {
-		{ ASR_RAID0,   t_raid0 },
-		{ ASR_RAID1,   t_raid1 },
+		{ ASR_RAID0, t_raid0 },
+		{ ASR_RAID1, t_raid1 },
 		{ ASR_RAIDSPR, t_spare },
-		{ 0, t_undef},
+		{ 0, t_undef },
 	};
 
 	return cl ? rd_type(types, (unsigned) cl->raidtype) : t_undef;
@@ -122,10 +129,11 @@
  * Read an ASR RAID device.  Fields are big endian, so
  * need to convert them if we're on a LE machine (i386, etc).
  */
-enum { ASR_BLOCK = 0x01, ASR_TABLE = 0x02, ASR_EXTTABLE  = 0x04 };
+enum { ASR_BLOCK = 0x01, ASR_TABLE = 0x02, ASR_EXTTABLE = 0x04 };
 
 #if	BYTE_ORDER == LITTLE_ENDIAN
-static void cvt_configline(struct asr_raid_configline *cl)
+static void
+cvt_configline(struct asr_raid_configline *cl)
 {
 	CVT16(cl->raidcnt);
 	CVT16(cl->raidseq);
@@ -141,12 +149,13 @@
 	CVT32(cl->appBurstCount);
 }
 
-static void to_cpu(void *meta, unsigned cvt)
+static void
+to_cpu(void *meta, unsigned cvt)
 {
 	struct asr *asr = meta;
 	struct asr_raidtable *rt = asr->rt;
 	unsigned i, elmcnt = rt->elmcnt,
-		     use_old_elmcnt = (rt->ridcode == RVALID2);
+		use_old_elmcnt = (rt->ridcode == RVALID2);
 
 	if (cvt & ASR_BLOCK) {
 		CVT32(asr->rb.b0idcode);
@@ -179,7 +188,7 @@
 		CVT32(rt->recreateDate);
 
 		/* Convert the first seven config lines */
-		for (i = 0; i < (min(elmcnt, ASR_TBLELMCNT)); i++) 
+		for (i = 0; i < (min(elmcnt, ASR_TBLELMCNT)); i++)
 			cvt_configline(rt->ent + i);
 	}
 
@@ -194,10 +203,11 @@
 #endif
 
 /* Compute the checksum of RAID metadata */
-static unsigned compute_checksum(struct asr *asr)
+static unsigned
+compute_checksum(struct asr *asr)
 {
 	struct asr_raidtable *rt = asr->rt;
-	uint8_t *ptr = (uint8_t*) rt->ent;
+	uint8_t *ptr = (uint8_t *) rt->ent;
 	unsigned checksum = 0, end = sizeof(*rt->ent) * rt->elmcnt;
 
 	/* Compute checksum. */
@@ -209,7 +219,8 @@
 
 /* (Un)truncate white space at the end of a name */
 enum truncate { TRUNCATE, UNTRUNCATE };
-static void handle_white_space(uint8_t *p, enum truncate truncate)
+static void
+handle_white_space(uint8_t * p, enum truncate truncate)
 {
 	unsigned j = ASR_NAMELEN;
 	uint8_t c = truncate == TRUNCATE ? 0 : ' ';
@@ -219,14 +230,14 @@
 }
 
 /* Read extended metadata areas */
-static int read_extended(struct lib_context *lc, struct dev_info *di,
-			 struct asr *asr)
+static int
+read_extended(struct lib_context *lc, struct dev_info *di, struct asr *asr)
 {
 	unsigned remaining, i, chk;
 	struct asr_raidtable *rt = asr->rt;
 
 	log_notice(lc, "%s: reading extended data on %s", handler, di->path);
-	
+
 	/* Read the RAID table. */
 	if (!read_file(lc, handler, di->path, rt, ASR_DISK_BLOCK_SIZE,
 		       (uint64_t) asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE))
@@ -235,7 +246,7 @@
 
 	/* Convert it */
 	to_cpu(asr, ASR_TABLE);
-	
+
 	/* Is this ok? */
 	if (rt->ridcode != RVALID2)
 		LOG_ERR(lc, 0, "%s: Invalid magic number in RAID table; "
@@ -256,7 +267,7 @@
 	if (rt->elmcnt > ASR_TBLELMCNT) {
 		remaining = rt->elmsize * (rt->elmcnt - 7);
 		if (!read_file(lc, handler, di->path, rt->ent + 7,
-			       remaining, (uint64_t)(asr->rb.raidtbl + 1) *
+			       remaining, (uint64_t) (asr->rb.raidtbl + 1) *
 			       ASR_DISK_BLOCK_SIZE))
 			return 0;
 
@@ -267,10 +278,10 @@
 	if (rt->rversion < 2) {
 		if ((chk = compute_checksum(asr)) != rt->rchksum)
 			log_err(lc, "%s: Invalid RAID config table checksum "
-				       "(0x%X vs. 0x%X) on %s",
+				"(0x%X vs. 0x%X) on %s",
 				handler, chk, rt->rchksum, di->path);
 	}
-	
+
 	/* Process the name of each line of the config line. */
 	for (i = 0; i < rt->elmcnt; i++) {
 		/* 
@@ -296,9 +307,8 @@
 		 * This is nuts.
 		 */
 		if (!*rt->ent[i].name)
-			strncpy((char*) rt->ent[i].name,
-				(char*) rt->ent->name,
-				ASR_NAMELEN);
+			strncpy((char *) rt->ent[i].name,
+				(char *) rt->ent->name, ASR_NAMELEN);
 
 		/* Now truncate trailing whitespace in the name. */
 		handle_white_space(rt->ent[i].name, TRUNCATE);
@@ -307,7 +317,8 @@
 	return 1;
 }
 
-static int is_asr(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_asr(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct asr *asr = meta;
 
@@ -315,11 +326,10 @@
 	 * Check our magic numbers and that the version == v8.
 	 * We don't support anything other than that right now.
 	 */
-	if (asr->rb.b0idcode == B0RESRVD &&
-	    asr->rb.smagic == SVALID) {
+	if (asr->rb.b0idcode == B0RESRVD && asr->rb.smagic == SVALID) {
 		if (asr->rb.resver == RBLOCK_VER)
 			return 1;
-		
+
 		log_err(lc, "%s: ASR v%d detected, but we only support v8",
 			handler, asr->rb.resver);
 	}
@@ -340,9 +350,9 @@
  * lacks this sort of visibility as to where its block devices come from.
  * This is EXTREMELY DANGEROUS if you aren't careful!
  */
-static void *read_metadata_areas(struct lib_context *lc, struct dev_info *di,
-				 size_t *sz, uint64_t *offset,
-				 union read_info *info)
+static void *
+read_metadata_areas(struct lib_context *lc, struct dev_info *di,
+		    size_t * sz, uint64_t * offset, union read_info *info)
 {
 	size_t size = ASR_DISK_BLOCK_SIZE;
 	uint64_t asr_sboffset = ASR_CONFIGOFFSET;
@@ -357,7 +367,7 @@
 	 */
 	if (!(asr = alloc_private(lc, handler, sizeof(*asr))))
 		goto bad0;
-	
+
 	if (!(asr->rt = alloc_private(lc, handler, sizeof(*asr->rt))))
 		goto bad1;
 
@@ -370,8 +380,7 @@
 	to_cpu(asr, ASR_BLOCK);
 
 	/* Check Signature and read optional extended metadata. */
-	if (!is_asr(lc, di, asr) ||
-	    !read_extended(lc, di, asr))
+	if (!is_asr(lc, di, asr) || !read_extended(lc, di, asr))
 		goto bad2;
 
 	/*
@@ -383,21 +392,21 @@
 
 	goto out;
 
-   bad2:
+      bad2:
 	dbg_free(asr->rt);
-   bad1:
+      bad1:
 	asr->rt = NULL;
 	dbg_free(asr);
-   bad0:
+      bad0:
 	asr = NULL;
 
-   out:
+      out:
 	return asr;
 }
 
 /* Read the whole metadata chunk at once */
-static uint8_t *read_metadata_chunk(struct lib_context *lc, struct dev_info *di,
-				    uint64_t start)
+static uint8_t *
+read_metadata_chunk(struct lib_context *lc, struct dev_info *di, uint64_t start)
 {
 	uint8_t *ret;
 	size_t size = (di->sectors - start) * ASR_DISK_BLOCK_SIZE;
@@ -420,8 +429,8 @@
  * "File the metadata areas" -- I think this function is supposed to declare
  * which parts of the drive are metadata and thus off-limits to dmraid.
  */
-static void file_metadata_areas(struct lib_context *lc, struct dev_info *di,
-				void *meta)
+static void
+file_metadata_areas(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	uint8_t *buf;
 	struct asr *asr = meta;
@@ -432,19 +441,18 @@
 
 	/* Register the raid tables. */
 	file_metadata(lc, handler, di->path, buf,
-		      ASR_DISK_BLOCK_SIZE * 17,
-		      start * ASR_DISK_BLOCK_SIZE);
-	
+		      ASR_DISK_BLOCK_SIZE * 17, start * ASR_DISK_BLOCK_SIZE);
+
 	dbg_free(buf);
-	
+
 	/* Record the device size if -D was specified. */
 	file_dev_size(lc, handler, di);
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *asr_read(struct lib_context *lc,
-					struct dev_info *di)
+static struct raid_dev *
+asr_read(struct lib_context *lc, struct dev_info *di)
 {
 	/*
 	 * NOTE: Everything called after read_metadata_areas assumes that
@@ -455,7 +463,8 @@
 			     file_metadata_areas, setup_rd, handler);
 }
 
-static int set_sort(struct list_head *dont, struct list_head *care)
+static int
+set_sort(struct list_head *dont, struct list_head *care)
 {
 	return 0;
 }
@@ -465,16 +474,18 @@
  * Is hba:ch:lun:id ok?
  * It seems to be the way the binary driver does it...
  */
-static inline uint64_t compose_id(struct asr_raid_configline *cl)
+static inline uint64_t
+compose_id(struct asr_raid_configline *cl)
 {
-	return    ((uint64_t) cl->raidhba  << 48)
+	return ((uint64_t) cl->raidhba << 48)
 		| ((uint64_t) cl->raidchnl << 40)
-		| ((uint64_t) cl->raidlun  << 32)
+		| ((uint64_t) cl->raidlun << 32)
 		| (uint64_t) cl->raidid;
 }
 
 /* Sort ASR devices by for a RAID set. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	return compose_id(this_disk(META(RD(new), asr))) <
 	       compose_id(this_disk(META(RD(pos), asr)));
@@ -483,7 +494,8 @@
 /*
  * Find the top-level RAID set for an ASR context.
  */
-static int find_toplevel(struct lib_context *lc, struct asr *asr)
+static int
+find_toplevel(struct lib_context *lc, struct asr *asr)
 {
 	int i, toplevel = -1;
 	struct asr_raidtable *rt = asr->rt;
@@ -496,7 +508,7 @@
 			break;
 		}
 	}
-	
+
 	return toplevel;
 }
 
@@ -504,7 +516,8 @@
  * Find the logical drive configuration that goes with this
  * physical disk configuration.
  */
-static struct asr_raid_configline *find_logical(struct asr *asr)
+static struct asr_raid_configline *
+find_logical(struct asr *asr)
 {
 	int i, j;
 	struct asr_raidtable *rt = asr->rt;
@@ -522,11 +535,13 @@
 	return NULL;
 }
 
-static struct raid_dev *find_spare(struct lib_context *lc) {
+static struct raid_dev *
+find_spare(struct lib_context *lc)
+{
 	struct raid_dev *spare;
-	
+
 	list_for_each_entry(spare, LC_RD(lc), list) {
-		if (spare->type == t_spare)  
+		if (spare->type == t_spare)
 			return spare;
 	}
 
@@ -534,8 +549,8 @@
 }
 
 /* Wrapper for name() */
-static char *js_name(struct lib_context *lc, struct raid_dev *rd,
-		     unsigned subset)
+static char *
+js_name(struct lib_context *lc, struct raid_dev *rd, unsigned subset)
 {
 	return name(lc, META(rd, asr));
 }
@@ -543,7 +558,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct asr *asr = META(rd, asr);
@@ -553,7 +569,7 @@
 	/* Ignore if we've already marked this disk broken(?) */
 	if (rd->status & s_broken)
 		return 0;
-	
+
 	log_err(lc, "%s: I/O error on device %s at sector %lu",
 		handler, e_io->rd->di->path, e_io->sector);
 
@@ -563,13 +579,14 @@
 	fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
 	/* FIXME: Do we have to mark a parent too? */
 
-	return 1; /* Indicate that this is indeed a failure. */
+	return 1;		/* Indicate that this is indeed a failure. */
 }
 
 /*
  * Helper routines for asr_group()
  */
-static struct raid_set *do_spare(struct lib_context *lc, struct raid_dev *rd)
+static struct raid_set *
+do_spare(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs;
 
@@ -585,11 +602,11 @@
 	 * it.
 	 *
 	 * rs = find_set(lc, name(lc, asr), FIND_TOP, rd, LC_RS(lc),
-	 *		 NO_CREATE, NO_CREATE_ARG);
+	 *               NO_CREATE, NO_CREATE_ARG);
 	 */
 
 	/* Otherwise, make a global spare pool. */
-	rs = find_or_alloc_raid_set(lc, (char*)spare_array, FIND_TOP, rd,
+	rs = find_or_alloc_raid_set(lc, (char *) spare_array, FIND_TOP, rd,
 				    LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
 
 	/*
@@ -604,8 +621,9 @@
 }
 
 #define BUFSIZE 128
-static struct raid_set *do_stacked(struct lib_context *lc, struct raid_dev *rd,
-				   struct asr_raid_configline *cl)
+static struct raid_set *
+do_stacked(struct lib_context *lc, struct raid_dev *rd,
+	   struct asr_raid_configline *cl)
 {
 	char buf[BUFSIZE], *path = rd->di->path;
 	struct raid_set *rs, *ss;
@@ -616,12 +634,11 @@
 	fwl = find_logical(asr);
 	if (!fwl)
 		LOG_ERR(lc, NULL, "%s: Failed to find RAID configuration "
-				  "line on %s",
-			handler, path);
+			"line on %s", handler, path);
 
 	snprintf(buf, BUFSIZE, ".asr_%s_%x_donotuse",
 		 fwl->name, fwl->raidmagic);
-	
+
 	/* Now find said parent. */
 	rs = find_or_alloc_raid_set(lc, buf, FIND_ALL, rd, NO_LIST,
 				    NO_CREATE, NO_CREATE_ARG);
@@ -635,7 +652,7 @@
 
 	/* Add the disk to the set. */
 	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
-	
+
 	/* Find the top level set. */
 	ss = join_superset(lc, js_name, NO_CREATE, set_sort, rs, rd);
 	if (!ss)
@@ -645,7 +662,7 @@
 	ss->stride = stride(cl);
 	ss->status = s_ok;
 	/* FIXME: correct type (this crashed in stacked set code) */
-	ss->type = t_raid1; // type(&asr->rt->ent[top_idx]);
+	ss->type = t_raid1;	// type(&asr->rt->ent[top_idx]);
 	return ss;
 }
 
@@ -654,7 +671,8 @@
  * which this disk belongs, and then attaching it.  Note that there are other
  * complications, such as two-layer arrays (RAID10).
  */
-static struct raid_set *asr_group(struct lib_context *lc, struct raid_dev *rd)
+static struct raid_set *
+asr_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	int top_idx;
 	struct asr *asr = META(rd, asr);
@@ -668,8 +686,7 @@
 	top_idx = find_toplevel(lc, asr);
 	if (top_idx < 0)
 		LOG_ERR(lc, NULL, "%s: Can't find a logical array config "
-			"for disk %x",
-			handler, asr->rb.drivemagic);
+			"for disk %x", handler, asr->rb.drivemagic);
 
 	/* This is a simple RAID0/1 array.  Find the set. */
 	if (asr->rt->ent[top_idx].raidlevel == FWL) {
@@ -700,7 +717,8 @@
 }
 
 /* deletes configline from metadata of given asr, by index. */
-static void delete_configline(struct asr *asr, int index)
+static void
+delete_configline(struct asr *asr, int index)
 {
 	struct asr_raid_configline *cl, *end;
 	struct asr_raidtable *rt = asr->rt;
@@ -715,13 +733,14 @@
 }
 
 /* Find the newest configline entry in raid set and return a pointer to it. */
-static struct raid_dev *find_newest_drive(struct raid_set *rs)
+static struct raid_dev *
+find_newest_drive(struct raid_set *rs)
 {
 	struct asr_raidtable *rt;
 	struct raid_dev *device, *newest = NULL;
 	uint16_t newest_raidseq = 0;
-        int i;
-	
+	int i;
+
 	list_for_each_entry(device, &rs->devs, devs) {
 		rt = META(device, asr)->rt;
 		// FIXME: We should be able to assume each configline
@@ -734,19 +753,21 @@
 			}
 		}
 	}
-	
+
 	return newest;
 }
 
 /* Creates a random integer for a drive magic section */
-static uint32_t create_drivemagic() {
+static uint32_t
+create_drivemagic()
+{
 
 	srand(time(NULL));
 	return rand() + rand();
 }
 
-static int spare(struct lib_context *lc, struct raid_dev *rd,
-		 struct asr *asr)
+static int
+spare(struct lib_context *lc, struct raid_dev *rd, struct asr *asr)
 {
 	struct asr_raid_configline *cl;
 
@@ -781,13 +802,13 @@
 	cl->raidtype = ASR_RAIDSPR;
 	cl->lcapcty = rd->di->sectors;
 	cl->raidlevel = FWP;
-
 	return 1;
 }
 
 /* Returns (boolean) whether or not the drive described by the given configline
  * is in the given raid_set. */
-static int in_raid_set(struct asr_raid_configline *cl, struct raid_set *rs)
+static int
+in_raid_set(struct asr_raid_configline *cl, struct raid_set *rs)
 {
 	struct asr *asr;
 	struct raid_dev *d;
@@ -797,11 +818,13 @@
 		if (cl->raidmagic == asr->rb.drivemagic)
 			return 1;
 	}
+
 	return 0;
 }
 
 /* Delete extra configlines which would otherwise trip us up. */
-static int cleanup_configlines(struct raid_dev *rd, struct raid_set *rs)
+static int
+cleanup_configlines(struct raid_dev *rd, struct raid_set *rs)
 {
 	struct asr *a;
 	struct raid_dev *d;
@@ -810,7 +833,7 @@
 
 	list_for_each_entry(d, &rs->devs, devs) {
 		a = META(d, asr);
-	
+
 		cl = a->rt->ent;
 		for (clcnt = 0; clcnt < a->rt->elmcnt; /* done in loop */ ) {
 			/* If it's in the seen list, or is a logical drive, 
@@ -833,19 +856,21 @@
 			}
 		}
 	}
+
 	return 1;
 }
 
 /* Add a CL entry */
-static int create_configline(struct raid_set *rs, struct asr *asr,
-		             struct asr *a, struct raid_dev* newest)
+static int
+create_configline(struct raid_set *rs, struct asr *asr,
+		  struct asr *a, struct raid_dev *newest)
 {
 	struct asr *newest_asr = META(newest, asr);
 	struct asr_raid_configline *cl;
-	
+
 	if (asr->rt->elmcnt >= RCTBL_MAX_ENTRIES)
 		return 0;
-	
+
 	cl = asr->rt->ent + asr->rt->elmcnt;
 	asr->rt->elmcnt++;
 
@@ -858,7 +883,7 @@
 	cl->strpsize = newest_asr->rt->ent[0].strpsize;
 
 	/* Starts after "asr_" */
-	strcpy((char*) cl->name, &rs->name[sizeof(HANDLER)]);
+	strcpy((char *) cl->name, &rs->name[sizeof(HANDLER)]);
 	cl->raidcnt = 0;
 
 	/* Convert rs->type to an ASR_RAID type for the CL */
@@ -872,6 +897,7 @@
 	default:
 		return 0;
 	}
+
 	cl->lcapcty = newest_asr->rt->ent[0].lcapcty;
 	cl->raidlevel = FWP;
 	return 1;
@@ -879,8 +905,8 @@
 
 /* Update metadata to reflect the current raid set configuration.
  * Returns boolean success. */
-static int update_metadata(struct lib_context *lc,  struct raid_dev *rd,
-			   struct asr *asr)
+static int
+update_metadata(struct lib_context *lc, struct raid_dev *rd, struct asr *asr)
 {
 	struct raid_set *rs;
 	struct asr_raid_configline *cl;
@@ -895,7 +921,7 @@
 		rt->elmcnt = 0;
 		return 1;
 	}
-	
+
 	/* If this is the spare array... */
 	if (!strcmp(spare_array, rs->name))
 		return spare(lc, rd, asr);
@@ -911,11 +937,11 @@
 	/* Make sure the raid type agrees with the metadata */
 	if (type(this_disk(asr)) == t_spare) {
 		struct asr *newest_asr = META(newest, asr);
-	
-		/* copy entire table from newest drive */	
+
+		/* copy entire table from newest drive */
 		rt->elmcnt = newest_asr->rt->elmcnt;
 		memcpy(rt->ent, newest_asr->rt->ent,
-			rt->elmcnt * sizeof(*rt->ent));
+		       rt->elmcnt * sizeof(*rt->ent));
 	}
 
 	/* Increment the top level CL's raid count */
@@ -935,26 +961,25 @@
 		}
 
 		/* If the magic is 0xFFFFFFFF, assign a random one */
-		if (a->rb.drivemagic == 0xFFFFFFFF) {
+		if (a->rb.drivemagic == 0xFFFFFFFF)
 			a->rb.drivemagic = create_drivemagic();
-		}
-		
+
 		if (!(newest = find_newest_drive(rs)))
 			return 0;
-				
+
 		create_configline(rs, asr, a, newest);
 	}
 
 	cleanup_configlines(rd, rs);
-
 	return 1;
 }
 
 
 /* Write metadata. */
-static int asr_write(struct lib_context *lc,  struct raid_dev *rd, int erase)
+static int
+asr_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
-        struct asr *asr = META(rd, asr);
+	struct asr *asr = META(rd, asr);
 	int elmcnt = asr->rt->elmcnt, i, ret;
 
 	/* Update the metadata if we're not erasing it. */
@@ -969,19 +994,19 @@
 	asr->rt->rchksum = compute_checksum(asr);
 
 	/* Convert back to disk format */
-        to_disk(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
+	to_disk(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
 
 	/* Write data */
-        ret = write_metadata(lc, handler, rd, -1, erase);
-	
+	ret = write_metadata(lc, handler, rd, -1, erase);
+
 	/* Go back to CPU format */
-        to_cpu(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
- 
+	to_cpu(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
+
 	/* Truncate trailing whitespace in the name. */
 	for (i = 0; i < elmcnt; i++)
 		handle_white_space(asr->rt->ent[i].name, TRUNCATE);
 
-        return ret;
+	return ret;
 }
 
 /*
@@ -989,7 +1014,8 @@
  */
 
 /* Retrieve the number of devices that should be in this set. */
-static unsigned device_count(struct raid_dev *rd, void *context)
+static unsigned
+device_count(struct raid_dev *rd, void *context)
 {
 	/* Get the logical drive */
 	struct asr_raid_configline *cl = find_logical(META(rd, asr));
@@ -998,15 +1024,17 @@
 }
 
 /* Check a RAID device */
-static int check_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_dev *rd, void *context)
+static int
+check_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_dev *rd, void *context)
 {
 	/* FIXME: Assume non-broken means ok. */
 	return rd->type != s_broken;
 }
 
 /* Start the recursive RAID set check. */
-static int asr_check(struct lib_context *lc, struct raid_set *rs)
+static int
+asr_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, device_count, NULL, check_rd,
 			      NULL, handler);
@@ -1018,7 +1046,8 @@
 };
 
 /* Dump a reserved block */
-static void dump_rb(struct lib_context *lc, struct asr_reservedblock *rb)
+static void
+dump_rb(struct lib_context *lc, struct asr_reservedblock *rb)
 {
 	DP("block magic:\t\t0x%X", rb, rb->b0idcode);
 	DP("sb0flags:\t\t\t0x%X", rb, rb->sb0flags);
@@ -1033,7 +1062,8 @@
 }
 
 /* Dump a raid config line */
-static void dump_cl(struct lib_context *lc, struct asr_raid_configline *cl)
+static void
+dump_cl(struct lib_context *lc, struct asr_raid_configline *cl)
 {
 	DP("config ID:\t\t0x%X", cl, cl->raidmagic);
 	DP("  name:\t\t\t\"%s\"", cl, cl->name);
@@ -1062,7 +1092,8 @@
 }
 
 /* Dump a raid config table */
-static void dump_rt(struct lib_context *lc, struct asr_raidtable *rt)
+static void
+dump_rt(struct lib_context *lc, struct asr_raidtable *rt)
 {
 	unsigned i;
 
@@ -1093,7 +1124,8 @@
 /*
  * Log native information about the RAID device.
  */
-static void asr_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+asr_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct asr *asr = META(rd, asr);
 
@@ -1104,22 +1136,23 @@
 #endif
 
 static struct dmraid_format asr_format = {
-	.name	= HANDLER,
-	.descr	= "Adaptec HostRAID ASR",
-	.caps	= "0,1,10",
+	.name = HANDLER,
+	.descr = "Adaptec HostRAID ASR",
+	.caps = "0,1,10",
 	.format = FMT_RAID,
-	.read	= asr_read,
-	.write	= asr_write,
-	.group	= asr_group,
-	.check	= asr_check,
-	.events	= &asr_event_handlers,
+	.read = asr_read,
+	.write = asr_write,
+	.group = asr_group,
+	.check = asr_check,
+	.events = &asr_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= asr_log,
+	.log = asr_log,
 #endif
 };
 
 /* Register this format handler with the format core */
-int register_asr(struct lib_context *lc)
+int
+register_asr(struct lib_context *lc)
 {
 	return register_format_handler(lc, &asr_format);
 }
@@ -1127,15 +1160,17 @@
 /*
  * Set up a RAID device from what we've assembled out of the metadata.
  */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct asr *asr = meta;
 	struct meta_areas *ma;
 	struct asr_raid_configline *cl = this_disk(asr);
 
 	if (!cl)
-		LOG_ERR(lc, 0, "%s: Could not find current disk!", handler);		
+		LOG_ERR(lc, 0, "%s: Could not find current disk!", handler);
+
 	/* We need two metadata areas */
 	if (!(ma = rd->meta_areas = alloc_meta_areas(lc, rd, handler, 2)))
 		return 0;
@@ -1151,11 +1186,12 @@
 	ma->area = asr->rt;
 
 	/* Now set up the rest of the metadata info */
-        rd->di = di;
+	rd->di = di;
 	rd->fmt = &asr_format;
 	rd->status = disk_status(cl);
-	rd->type   = type(cl);
+	rd->type = type(cl);
 	rd->offset = ASR_DATAOFFSET;
+
 	if (!(rd->sectors = cl->lcapcty))
 		return log_zero_sectors(lc, di->path, handler);
 
--- dmraid/lib/format/ataraid/asr.h	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/asr.h	2008/06/20 21:52:17	1.3
@@ -89,12 +89,12 @@
 
 /*** RAID CONFIGURATION TABLE STRUCTURE ***/
 
-#define RVALID2			0x900765C4   /* Version 2+ RAID table ID code
-						signature */
+#define RVALID2			0x900765C4	/* Version 2+ RAID table ID code
+						   signature */
 #define RCTBL_MAX_ENTRIES	127
 #define HBA_RCTBL_MAX_ENTRIES	255
-#define RTBLBLOCKS		16	     /* Size of drive's raid table
-						in blocks */
+#define RTBLBLOCKS		16	/* Size of drive's raid table
+					   in blocks */
 
 /* flag bits */
 #define RCTBLCHNG					0x80	/* Set on comp OR log (NOT AND) if tbl updates needed */
@@ -106,185 +106,182 @@
 #define PREDICTIVE_ENABLE				0x02
 #define RAID_ENTRY_FLAGS_ALARM_OFF_M			0x01
 
-struct asr_raid_configline
-{
-	uint16_t	raidcnt;    /* Component count of an OSL/FWL array */
-	uint16_t	raidseq;    /* Sequence # of component to look for */
-	uint32_t	raidmagic;  /* Magic # of component to look for */
-	uint8_t		raidlevel;  /* Array level = OSL/FWL/OSI/FWP */
-	uint8_t		raidtype;   /* Array type = RAID0/1/3/5, RAIDRED,
-				       RAIDSPR */
-	uint8_t		raidstate;  /* State of logical or physical drive */
-
-	uint8_t		flags;      /* misc flags set bit positions above */
-
-	uint8_t		refcnt;     /* Number of references to this log entry */
-	uint8_t		raidhba;    /* -- not used -- Host bus adapter number
-				       or RAIDID */
-	uint8_t		raidchnl;   /* Channel number */
-	uint8_t		raidlun;    /* SCSI LUN of log/phys drv */
-	uint32_t	raidid;     /* SCSI ID of log/phys drv */
-	uint32_t	loffset;    /* Offset of data for this comp in the
-				       array */
-	uint32_t	lcapcty;    /* Capacity of log drv or space used on
-				       phys */
-	uint16_t	strpsize;   /* Stripe size in blocks of this drive */
-	uint16_t	biosInfo;   /* bios info - set by
-				       I2O_EXEC_BIOS_INFO_SET */
-	uint32_t	lsu;        /* Pointer to phys/log lun of this entry */
-	uint8_t		addedDrives;
-	uint8_t		appSleepRate;
-	uint16_t	blockStorageTid;
-	uint32_t	curAppBlock;
-	uint32_t	appBurstCount;
+struct asr_raid_configline {
+	uint16_t raidcnt;	/* Component count of an OSL/FWL array */
+	uint16_t raidseq;	/* Sequence # of component to look for */
+	uint32_t raidmagic;	/* Magic # of component to look for */
+	uint8_t raidlevel;	/* Array level = OSL/FWL/OSI/FWP */
+	uint8_t raidtype;	/* Array type = RAID0/1/3/5, RAIDRED,
+				   RAIDSPR */
+	uint8_t raidstate;	/* State of logical or physical drive */
+
+	uint8_t flags;		/* misc flags set bit positions above */
+
+	uint8_t refcnt;		/* Number of references to this log entry */
+	uint8_t raidhba;	/* -- not used -- Host bus adapter number
+				   or RAIDID */
+	uint8_t raidchnl;	/* Channel number */
+	uint8_t raidlun;	/* SCSI LUN of log/phys drv */
+	uint32_t raidid;	/* SCSI ID of log/phys drv */
+	uint32_t loffset;	/* Offset of data for this comp in the
+				   array */
+	uint32_t lcapcty;	/* Capacity of log drv or space used on
+				   phys */
+	uint16_t strpsize;	/* Stripe size in blocks of this drive */
+	uint16_t biosInfo;	/* bios info - set by
+				   I2O_EXEC_BIOS_INFO_SET */
+	uint32_t lsu;		/* Pointer to phys/log lun of this entry */
+	uint8_t addedDrives;
+	uint8_t appSleepRate;
+	uint16_t blockStorageTid;
+	uint32_t curAppBlock;
+	uint32_t appBurstCount;
 #define	ASR_NAMELEN	16
-	uint8_t		name[ASR_NAMELEN];   /* Full name of the array. */
+	uint8_t name[ASR_NAMELEN];	/* Full name of the array. */
 } __attribute__ ((packed));
 
-struct asr_raidtable
-{
+struct asr_raidtable {
 /* raid Flag defines 32 bits 0 - FFFFFFFF */
 #define RAID_FLAGS_ALARM_OFF_M 0x00000001
-	uint32_t	ridcode;	/* RAID table signature - 0x900765C4 */
-	uint32_t	rversion;	/* Version of the RAID config table */
-	uint16_t	maxelm;		/* Maximum number of elements */
-	uint16_t	elmcnt;		/* Element Count (number used) */
+	uint32_t ridcode;	/* RAID table signature - 0x900765C4 */
+	uint32_t rversion;	/* Version of the RAID config table */
+	uint16_t maxelm;	/* Maximum number of elements */
+	uint16_t elmcnt;	/* Element Count (number used) */
 #define	ASR_TBLELMCNT	7
-	uint16_t	elmsize;	/* Size of an individual raidCLine */
-	uint16_t	rchksum;	/* RAID table check sum
-					   (no rconfTblV2)*/
-	uint32_t	res1;		/* Reserved */
-	uint16_t	res2;		/* was bldRate - Time in 1/10s
-					   between idle build bursts */
-	uint16_t	res3;		/* was bldAmount - Block to build
-					   during a build burst */
-	uint32_t	raidFlags;
-	uint32_t	timestamp;	/* used for iROC. A stamp to find
-					   which is latest */
-	uint8_t		irocFlags;
+	uint16_t elmsize;	/* Size of an individual raidCLine */
+	uint16_t rchksum;	/* RAID table check sum
+				   (no rconfTblV2) */
+	uint32_t res1;		/* Reserved */
+	uint16_t res2;		/* was bldRate - Time in 1/10s
+				   between idle build bursts */
+	uint16_t res3;		/* was bldAmount - Block to build
+				   during a build burst */
+	uint32_t raidFlags;
+	uint32_t timestamp;	/* used for iROC. A stamp to find
+				   which is latest */
+	uint8_t irocFlags;
 #define	ASR_IF_VERIFY_WITH_AUTOFIX	0x01
 #define ASR_IF_BOOTABLE			0x80
-	uint8_t		dirty;		/* Records "open state" for array */
+	uint8_t dirty;		/* Records "open state" for array */
 #define ARRAY_STATE_OK		0x00
 #define ARRAY_STATE_DIRTY	0x03
-	uint8_t		actionPriority;
-	uint8_t		spareid;	/* Stored in member disk meta data
-					   to declare the ID of dedicated
-					   spare to show up. */
-	uint32_t	sparedrivemagic;/* drivemagic (in RB) of the spare
+	uint8_t actionPriority;
+	uint8_t spareid;	/* Stored in member disk meta data
+				   to declare the ID of dedicated
+				   spare to show up. */
+	uint32_t sparedrivemagic;	/* drivemagic (in RB) of the spare
 					   at above ID. */
-	uint32_t	raidmagic;	/* used to identify spare drive with
-					   its mirror set. */
-	uint32_t 	verifyDate;	/* used by iomgr */
-	uint32_t	recreateDate;	/* used by iomgr */
-	uint8_t		res4[12];	/* Reserved */
+	uint32_t raidmagic;	/* used to identify spare drive with
+				   its mirror set. */
+	uint32_t verifyDate;	/* used by iomgr */
+	uint32_t recreateDate;	/* used by iomgr */
+	uint8_t res4[12];	/* Reserved */
 	struct asr_raid_configline ent[RCTBL_MAX_ENTRIES];
 } __attribute__ ((packed));
 
 
-#define RBLOCK_VER  8           /* Version of the reserved block */
-#define B0RESRVD    0x37FC4D1E  /* Signature of the reserved block */
-#define SVALID      0x4450544D  /* ASCII code for "DPTM" DPT Mirror */
-
-struct asr_reservedblock
-{
-	uint32_t	b0idcode;	/* 0x00 - ID code signifying block 0
-					   reserved */
-	uint8_t		lunsave[8];	/* 0x04 - NOT USED - LUN mappings for
-					   all drives */
-	uint16_t	sdtype;		/* 0x0C - NOT USED - drive type in
-					   boot prom */
-	uint16_t	ssavecyl;	/* 0x0E - NOT USED - Set Parameters
-					   cylinders */
-	uint8_t		ssavehed;	/* 0x10 - NOT USED - Set Parameters
-					   heads */
-	uint8_t		ssavesec;	/* 0x11 - NOT USED - Set Parameters
-					   sectors */
-	uint8_t		sb0flags;	/* 0x12 - flags saved in reserved
-					   block */
-	uint8_t		jbodEnable;	/* 0x13 - jbod enable -- DEC drive
-					   hiding */
-	uint8_t		lundsave;	/* 0x14 - NOT USED - LUNMAP disable
-					   flags */
-	uint8_t		svpdirty;	/* 0x15 - NOT USED - saved percentage
-					   dirty */
-	uint16_t	biosInfo;	/* 0x16 - bios info - set by
-					   I2O_EXEC_BIOS_INFO_SET */
-	uint16_t	svwbskip;	/* 0x18 - NOT USED - saved write-back
-					   skip value */
-	uint16_t	svwbcln;	/* 0x1A - NOT USED - saved maximum
-					   clean blocks in write-back */
-	uint16_t	svwbmax;	/* 0x1C - NOT USED - saved maximum
-					   write-back length */
-	uint16_t	res3;		/* 0x1E - unused (was write-back burst
-					   block count) */
-	uint16_t	svwbmin;	/* 0x20 - NOT USED - saved minimum
-					   block count to write */
-	uint16_t	res4;		/* 0x22 - unused (was minimum
-					   look-ahead length) */
-	uint16_t	svrcacth;	/* 0x24 - NOT USED - saved read cache
-					   threshold */
-	uint16_t	svwcacth;	/* 0x26 - NOT USED - saved write
-					    cache threshold */
-	uint16_t	svwbdly;	/* 0x28 - NOT USED - saved write-back
-					   delay */
-	uint8_t		svsdtime;	/* 0x2A - NOT USED - saved spin down
-					   time */
-	uint8_t		res5;		/* 0x2B - unused */
-	uint16_t	firmval;	/* 0x2C - NOT USED - firmware on
-					   drive  (dw) */
-	uint16_t	firmbln;	/* 0x2E - NOT USED - length in blocks
-					   for firmware */
-	uint32_t	firmblk;	/* 0x30 - NOT USED - starting block
-					   for firmware */
-	uint32_t	fstrsvrb;	/* 0x34 - 1st block reserved by
-					   Storage Manager */
-	uint16_t	svBlockStorageTid;	/* 0x38 - */
-	uint16_t	svtid;		/* 0x3A - */
-	uint8_t		svseccfl;	/* 0x3C - NOT USED - reserved block
-					   scsi bus ecc flags */
-	uint8_t		res6;		/* 0x3D - unused */
-	uint8_t		svhbanum;	/* 0x3E - NOT USED - HBA's unique
-					   RAID number */
-	uint8_t		resver;		/* 0x3F - reserved block version
-					   number */
-	uint32_t	drivemagic;	/* 0x40 - Magic number of this drive -
-					   used w/ RCTBLs */
-	uint8_t		reserved[20];	/* 0x44 - unused */
-	uint8_t		testnum;	/* 0x58 - NOT USED - diagnostic test
-					   number */
-	uint8_t		testflags;	/* 0x59 - NOT USED - diagnostic test
-					   flags */
-	uint16_t	maxErrorCount;	/* 0x5A - NOT USED - diagnostic test
-					   maximum error count */
-	uint32_t	count;		/* 0x5C - NOT USED - diagnostic test
-					   cycles - # of iterations */
-	uint32_t	startTime;	/* 0x60 - NOT USED - diagnostic test
-					   absolute test start time in
-					   seconds */
-	uint32_t	interval;	/* 0x64 - NOT USED - diagnostic test
-					   interval in seconds */
-	uint8_t		tstxt0;		/* 0x68 - not used - originally
-					   diagnostic test exclusion period
-					   start hour */
-	uint8_t		tstxt1;		/* 0x69 - not used - originally
-					   diagnostic test exclusion period
-					   end hour */
-	uint8_t		serNum[32];	/* 0x6A - reserved */
-	uint8_t		res8[102];	/* 0x8A - reserved */
-	uint32_t	fwTestMagic;	/* 0xF0 - test magic number - used by
-					   FW Test for automated tests */
-	uint32_t	fwTestSeqNum;	/* 0xF4 - test sequence number - used
-					   by FW Test for automated tests */
-	uint8_t		fwTestRes[8];	/* 0xF6 - reserved by FW Test for
-					   automated tests */
-	uint32_t	smagic;		/* 0x100 - magic value saying software
-					   half is valid */
-	uint32_t	raidtbl;	/* 0x104 - pointer to first block of
-					   raid table */
-	uint16_t	raidline;	/* 0x108 - line number of this raid
-					   table entry - only if version <7 */
-	uint8_t		res9[0xF6];	/* 0x10A - reserved for software stuff*/
+#define RBLOCK_VER  8		/* Version of the reserved block */
+#define B0RESRVD    0x37FC4D1E	/* Signature of the reserved block */
+#define SVALID      0x4450544D	/* ASCII code for "DPTM" DPT Mirror */
+
+struct asr_reservedblock {
+	uint32_t b0idcode;	/* 0x00 - ID code signifying block 0
+				   reserved */
+	uint8_t lunsave[8];	/* 0x04 - NOT USED - LUN mappings for
+				   all drives */
+	uint16_t sdtype;	/* 0x0C - NOT USED - drive type in
+				   boot prom */
+	uint16_t ssavecyl;	/* 0x0E - NOT USED - Set Parameters
+				   cylinders */
+	uint8_t ssavehed;	/* 0x10 - NOT USED - Set Parameters
+				   heads */
+	uint8_t ssavesec;	/* 0x11 - NOT USED - Set Parameters
+				   sectors */
+	uint8_t sb0flags;	/* 0x12 - flags saved in reserved
+				   block */
+	uint8_t jbodEnable;	/* 0x13 - jbod enable -- DEC drive
+				   hiding */
+	uint8_t lundsave;	/* 0x14 - NOT USED - LUNMAP disable
+				   flags */
+	uint8_t svpdirty;	/* 0x15 - NOT USED - saved percentage
+				   dirty */
+	uint16_t biosInfo;	/* 0x16 - bios info - set by
+				   I2O_EXEC_BIOS_INFO_SET */
+	uint16_t svwbskip;	/* 0x18 - NOT USED - saved write-back
+				   skip value */
+	uint16_t svwbcln;	/* 0x1A - NOT USED - saved maximum
+				   clean blocks in write-back */
+	uint16_t svwbmax;	/* 0x1C - NOT USED - saved maximum
+				   write-back length */
+	uint16_t res3;		/* 0x1E - unused (was write-back burst
+				   block count) */
+	uint16_t svwbmin;	/* 0x20 - NOT USED - saved minimum
+				   block count to write */
+	uint16_t res4;		/* 0x22 - unused (was minimum
+				   look-ahead length) */
+	uint16_t svrcacth;	/* 0x24 - NOT USED - saved read cache
+				   threshold */
+	uint16_t svwcacth;	/* 0x26 - NOT USED - saved write
+				   cache threshold */
+	uint16_t svwbdly;	/* 0x28 - NOT USED - saved write-back
+				   delay */
+	uint8_t svsdtime;	/* 0x2A - NOT USED - saved spin down
+				   time */
+	uint8_t res5;		/* 0x2B - unused */
+	uint16_t firmval;	/* 0x2C - NOT USED - firmware on
+				   drive  (dw) */
+	uint16_t firmbln;	/* 0x2E - NOT USED - length in blocks
+				   for firmware */
+	uint32_t firmblk;	/* 0x30 - NOT USED - starting block
+				   for firmware */
+	uint32_t fstrsvrb;	/* 0x34 - 1st block reserved by
+				   Storage Manager */
+	uint16_t svBlockStorageTid;	/* 0x38 - */
+	uint16_t svtid;		/* 0x3A - */
+	uint8_t svseccfl;	/* 0x3C - NOT USED - reserved block
+				   scsi bus ecc flags */
+	uint8_t res6;		/* 0x3D - unused */
+	uint8_t svhbanum;	/* 0x3E - NOT USED - HBA's unique
+				   RAID number */
+	uint8_t resver;		/* 0x3F - reserved block version
+				   number */
+	uint32_t drivemagic;	/* 0x40 - Magic number of this drive -
+				   used w/ RCTBLs */
+	uint8_t reserved[20];	/* 0x44 - unused */
+	uint8_t testnum;	/* 0x58 - NOT USED - diagnostic test
+				   number */
+	uint8_t testflags;	/* 0x59 - NOT USED - diagnostic test
+				   flags */
+	uint16_t maxErrorCount;	/* 0x5A - NOT USED - diagnostic test
+				   maximum error count */
+	uint32_t count;		/* 0x5C - NOT USED - diagnostic test
+				   cycles - # of iterations */
+	uint32_t startTime;	/* 0x60 - NOT USED - diagnostic test
+				   absolute test start time in
+				   seconds */
+	uint32_t interval;	/* 0x64 - NOT USED - diagnostic test
+				   interval in seconds */
+	uint8_t tstxt0;		/* 0x68 - not used - originally
+				   diagnostic test exclusion period
+				   start hour */
+	uint8_t tstxt1;		/* 0x69 - not used - originally
+				   diagnostic test exclusion period
+				   end hour */
+	uint8_t serNum[32];	/* 0x6A - reserved */
+	uint8_t res8[102];	/* 0x8A - reserved */
+	uint32_t fwTestMagic;	/* 0xF0 - test magic number - used by
+				   FW Test for automated tests */
+	uint32_t fwTestSeqNum;	/* 0xF4 - test sequence number - used
+				   by FW Test for automated tests */
+	uint8_t fwTestRes[8];	/* 0xF6 - reserved by FW Test for
+				   automated tests */
+	uint32_t smagic;	/* 0x100 - magic value saying software
+				   half is valid */
+	uint32_t raidtbl;	/* 0x104 - pointer to first block of
+				   raid table */
+	uint16_t raidline;	/* 0x108 - line number of this raid
+				   table entry - only if version <7 */
+	uint8_t res9[0xF6];	/* 0x10A - reserved for software stuff */
 } __attribute__ ((packed));
 
 
@@ -310,7 +307,7 @@
 
 #define ID_MAP_PHYSICAL_M	1	/* Logical Map Physical */
 #define ID_MAP_LOGICAL_M	2	/* Either Dual Level or Single Level
-					   Logical*/
+					   Logical */
 
 #define MAX_LSU_COUNT			256
 
@@ -369,10 +366,10 @@
 #define LSU_COMPONENT_STATE_REPLACED		0x04
 #define LSU_COMPONENT_STATE_UNINITIALIZED	0x0A
 
-#define LSU_COMPONENT_SUBSTATE_BUILDING		0x10  /* drive is being built
-							 for first time */
-#define LSU_COMPONENT_SUBSTATE_REBUILDING	0x20  /* drive is being
-							 rebuilt */
+#define LSU_COMPONENT_SUBSTATE_BUILDING		0x10	/* drive is being built
+							   for first time */
+#define LSU_COMPONENT_SUBSTATE_REBUILDING	0x20	/* drive is being
+							   rebuilt */
 #define LSU_ARRAY_SUBSTATE_AWAIT_FORMAT		0x50
 /* etc. */
 
--- dmraid/lib/format/ataraid/hpt37x.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/hpt37x.c	2008/06/20 21:52:17	1.3
@@ -1,7 +1,7 @@
 /*
  * Highpoint 37X ATARAID series metadata format handler.
  *
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -26,16 +26,16 @@
 
 /* Make up RAID set name from magic_[01] numbers */
 /* FIXME: better name ? */
-static size_t _name(struct hpt37x *hpt, char *str, size_t len,
-		    unsigned int subset)
+static size_t
+_name(struct hpt37x *hpt, char *str, size_t len, unsigned int subset)
 {
 	const char *fmt;
 
 	if (hpt->magic_0)
 		fmt = (subset &&
 		       (hpt->type == HPT37X_T_RAID01_RAID0 ||
-		        hpt->type == HPT37X_T_RAID01_RAID1)) ?
-		       "hpt37x_%u-%u" : "hpt37x_%u";
+			hpt->type == HPT37X_T_RAID01_RAID1)) ?
+			"hpt37x_%u-%u" : "hpt37x_%u";
 	else
 		fmt = "hpt37x_SPARE";
 
@@ -44,8 +44,8 @@
 			hpt->magic_1 ? hpt->magic_1 : hpt->magic_0, hpt->order);
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	size_t len;
 	char *ret;
@@ -65,52 +65,57 @@
  * Retrieve status of device.
  * FIXME: is this sufficient to cover all state ?
  */
-static enum status status(struct hpt37x *hpt)
+static enum status
+status(struct hpt37x *hpt)
 {
 	return hpt->magic == HPT37X_MAGIC_BAD ? s_broken : s_ok;
 }
 
 /* Neutralize disk type. */
-static enum type type(struct hpt37x *hpt)
+static enum type
+type(struct hpt37x *hpt)
 {
 	/* Mapping of HPT 37X types to generic types. */
 	static struct types types[] = {
-		{ HPT37X_T_SINGLEDISK, t_linear},
-		{ HPT37X_T_SPAN, t_linear},
-		{ HPT37X_T_RAID0, t_raid0},
-		{ HPT37X_T_RAID1, t_raid1},
-		{ HPT37X_T_RAID01_RAID0, t_raid0},
-		{ HPT37X_T_RAID01_RAID1, t_raid1},
+		{ HPT37X_T_SINGLEDISK, t_linear },
+		{ HPT37X_T_SPAN, t_linear },
+		{ HPT37X_T_RAID0, t_raid0 },
+		{ HPT37X_T_RAID1, t_raid1 },
+		{ HPT37X_T_RAID01_RAID0, t_raid0 },
+		{ HPT37X_T_RAID01_RAID1, t_raid1 },
 		/* FIXME: support RAID 3+5 */
-		{ 0, t_undef},
+		{ 0, t_undef },
 	};
 
 	return hpt->magic_0 ?
-	       rd_type(types, (unsigned int) hpt->type) : t_spare;
+		rd_type(types, (unsigned int) hpt->type) : t_spare;
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
-	return (META(RD(new), hpt37x))->disk_number <
-	       (META(RD(pos), hpt37x))->disk_number;
+	return META(RD(new), hpt37x)->disk_number <
+	       META(RD(pos), hpt37x)->disk_number;
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
-	return (META(RD_RS(RS(new)), hpt37x))->order <
-	       (META(RD_RS(RS(pos)), hpt37x))->order;
+	return META(RD_RS(RS(new)), hpt37x)->order <
+	       META(RD_RS(RS(pos)), hpt37x)->order;
 }
 
 /* Magic check. */
-static int check_magic(void *meta)
+static int
+check_magic(void *meta)
 {
 	struct hpt37x *hpt = meta;
 
 	return (hpt->magic == HPT37X_MAGIC_OK ||
 		hpt->magic == HPT37X_MAGIC_BAD) &&
-		hpt->disk_number < 8;
+	       hpt->disk_number < 8;
 }
 
 /*
@@ -120,7 +125,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct hpt37x *hpt = meta;
 
@@ -138,8 +144,7 @@
 
 		for (l = hpt->errorlog;
 		     l < hpt->errorlog +
-			 min(hpt->error_log_entries, HPT37X_MAX_ERRORLOG);
-		     l++) {
+		     min(hpt->error_log_entries, HPT37X_MAX_ERRORLOG); l++) {
 			CVT32(l->timestamp);
 			CVT32(l->lba);
 		}
@@ -148,14 +153,16 @@
 #endif
 
 /* Use magic check to tell, if this is Highpoint 37x */
-static int is_hpt37x(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_hpt37x(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	return check_magic(meta);
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *hpt37x_read(struct lib_context *lc, struct dev_info *di)
+static struct raid_dev *
+hpt37x_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
 			     sizeof(struct hpt37x), HPT37X_CONFIGOFFSET,
@@ -165,8 +172,8 @@
 /*
  * Write a Highpoint 37X RAID device.
  */
-static int hpt37x_write(struct lib_context *lc,
-			struct raid_dev *rd, int erase)
+static int
+hpt37x_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -188,28 +195,32 @@
  * Check device hierarchy and create sub sets appropriately.
  *
  */
-static unsigned int stride(struct hpt37x *hpt)
+static unsigned int
+stride(struct hpt37x *hpt)
 {
 	return hpt->raid0_shift ? 1 << hpt->raid0_shift : 0;
 }
 
-static int mismatch(struct lib_context *lc, struct raid_dev *rd, char magic)
+static int
+mismatch(struct lib_context *lc, struct raid_dev *rd, char magic)
 {
 	LOG_ERR(lc, 0, "%s: magic_%c mismatch on %s",
 		handler, magic, rd->di->path);
 }
 
-static void super_created(struct raid_set *ss, void *private)
+static void
+super_created(struct raid_set *ss, void *private)
 {
 	struct hpt37x *hpt = META(private, hpt37x);
 
-	ss->type   = hpt->type == HPT37X_T_RAID01_RAID0 ? t_raid1 : t_raid0;
+	ss->type = hpt->type == HPT37X_T_RAID01_RAID0 ? t_raid1 : t_raid0;
 	ss->stride = stride(hpt);
 }
 
 /* FIXME: handle spares in mirrors and check that types are correct. */
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	struct hpt37x *h, *hpt = META(rd, hpt37x);
 
@@ -248,8 +259,8 @@
 /*
  * Add a Highpoint RAID device to a set.
  */
-static struct raid_set *hpt37x_group(struct lib_context *lc,
-				       struct raid_dev *rd)
+static struct raid_set *
+hpt37x_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -268,22 +279,25 @@
  *
  * FIXME: more sanity checks.
  */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
-	return (META(rd, hpt37x))->raid_disks;
+	return META(rd, hpt37x)->raid_disks;
 }
 
-static int check_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_dev *rd, void *context)
+static int
+check_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_dev *rd, void *context)
 {
 	/*
 	 * FIXME: raid_disks member wrong ?
-	 *	  (eg, Peter Jonas RAID1 metadata, 2 disks and raid_disks = 1)
+	 *        (eg, Peter Jonas RAID1 metadata, 2 disks and raid_disks = 1)
 	 */
 	return T_RAID1(rd);
 }
 
-static int hpt37x_check(struct lib_context *lc, struct raid_set *rs)
+static int
+hpt37x_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, devices, NULL, check_rd, NULL, handler);
 }
@@ -291,7 +305,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct hpt37x *hpt = META(rd, hpt37x);
@@ -301,20 +316,20 @@
 		return 0;
 
 	hpt->magic = HPT37X_MAGIC_BAD;
-
 	return 1;
 }
 
 static struct event_handlers hpt37x_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about an HPT37X RAID device.
  */
-static void hpt37x_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+hpt37x_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct hpt37x *hpt = META(rd, hpt37x);
 	struct hpt37x_errorlog *el;
@@ -348,33 +363,35 @@
 		DP("status: %u", hpt, el->status);
 		DP("sectors: %u", hpt, el->sectors);
 		DP("lba: %u", hpt, el->lba);
-       };
+	};
 }
 #endif
 
 static struct dmraid_format hpt37x_format = {
-	.name	= HANDLER,
-	.descr	= "Highpoint HPT37X",
-	.caps	= "S,0,1,10,01",
+	.name = HANDLER,
+	.descr = "Highpoint HPT37X",
+	.caps = "S,0,1,10,01",
 	.format = FMT_RAID,
-	.read	= hpt37x_read,
-	.write	= hpt37x_write,
-	.group	= hpt37x_group,
-	.check	= hpt37x_check,
-	.events	= &hpt37x_event_handlers,
+	.read = hpt37x_read,
+	.write = hpt37x_write,
+	.group = hpt37x_group,
+	.check = hpt37x_check,
+	.events = &hpt37x_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= hpt37x_log,
+	.log = hpt37x_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_hpt37x(struct lib_context *lc)
+int
+register_hpt37x(struct lib_context *lc)
 {
 	return register_format_handler(lc, &hpt37x_format);
 }
 
 /* Calculate RAID device size in sectors depending on RAID type. */
-static uint64_t sectors(struct raid_dev *rd, struct hpt37x *hpt)
+static uint64_t
+sectors(struct raid_dev *rd, struct hpt37x *hpt)
 {
 	uint64_t ret = 0;
 	struct dev_info *di = rd->di;
@@ -397,8 +414,9 @@
 }
 
 /* Derive the RAID device contents from the Highpoint ones. */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct hpt37x *hpt = meta;
 
@@ -407,18 +425,18 @@
 
 	rd->meta_areas->offset = HPT37X_CONFIGOFFSET >> 9;
 	rd->meta_areas->size = sizeof(*hpt);
-	rd->meta_areas->area = (void*) hpt;
+	rd->meta_areas->area = (void *) hpt;
 
-	rd->di  = di;
+	rd->di = di;
 	rd->fmt = &hpt37x_format;
 
 	rd->status = status(hpt);
-	rd->type   = type(hpt);
+	rd->type = type(hpt);
 
 	/* Data offset from start of device; first device is special */
-	rd->offset  = hpt->disk_number ? HPT37X_DATAOFFSET : 0;
-        if (!(rd->sectors = sectors(rd, hpt)))
+	rd->offset = hpt->disk_number ? HPT37X_DATAOFFSET : 0;
+	if (!(rd->sectors = sectors(rd, hpt)))
 		return log_zero_sectors(lc, di->path, handler);
 
-        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+	return (rd->name = name(lc, rd, 1)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/hpt37x.h	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/hpt37x.h	2008/06/20 21:52:17	1.3
@@ -39,60 +39,59 @@
 #include <stdint.h>
 
 /* HPT 37x config data byte offset on disk */
-#define HPT37X_CONFIGOFFSET	(9 << 9) /* 9 sectors */
+#define HPT37X_CONFIGOFFSET	(9 << 9)	/* 9 sectors */
 #define HPT37X_DATAOFFSET	10	/* Data offset in sectors */
 
 /* Ondisk metadata for Highpoint ATARAID */
 struct hpt37x {
-       uint8_t  filler1[32];
+	uint8_t filler1[32];
 
-       uint32_t       magic;
+	uint32_t magic;
 #define HPT37X_MAGIC_OK   0x5a7816f0
-#define HPT37X_MAGIC_BAD  0x5a7816fd  
+#define HPT37X_MAGIC_BAD  0x5a7816fd
 
-       uint32_t       magic_0;	/* Set identifier */
-       uint32_t       magic_1;	/* Array identifier */
+	uint32_t magic_0;	/* Set identifier */
+	uint32_t magic_1;	/* Array identifier */
 
-       uint32_t       order;  
-#define HPT_O_MIRROR   0x01  
+	uint32_t order;
+#define HPT_O_MIRROR   0x01
 #define HPT_O_STRIPE   0x02
 #define HPT_O_OK       0x04
 
-       uint8_t        raid_disks;
-       uint8_t        raid0_shift; 
+	uint8_t raid_disks;
+	uint8_t raid0_shift;
 
-       uint8_t        type;
-#define HPT37X_T_RAID0		0x00 
+	uint8_t type;
+#define HPT37X_T_RAID0		0x00
 #define HPT37X_T_RAID1		0x01
 #define HPT37X_T_RAID01_RAID0	0x02
 #define HPT37X_T_SPAN		0x03
-#define HPT37X_T_RAID_3		0x04   
+#define HPT37X_T_RAID_3		0x04
 #define HPT37X_T_RAID_5		0x05
 #define HPT37X_T_SINGLEDISK	0x06
 #define HPT37X_T_RAID01_RAID1	0x07
 
-       uint8_t        disk_number;
-       uint32_t       total_secs; 
-       uint32_t       disk_mode;  
-       uint32_t       boot_mode;
-       uint8_t        boot_disk; 
-       uint8_t        boot_protect;
-       uint8_t        error_log_entries;
-       uint8_t        error_log_index;  
+	uint8_t disk_number;
+	uint32_t total_secs;
+	uint32_t disk_mode;
+	uint32_t boot_mode;
+	uint8_t boot_disk;
+	uint8_t boot_protect;
+	uint8_t error_log_entries;
+	uint8_t error_log_index;
 #define	HPT37X_MAX_ERRORLOG	32
-       struct hpt37x_errorlog
-       {
-	       uint32_t       timestamp;
-	       uint8_t        reason;   
-#define HPT_R_REMOVED          0xfe      
-#define HPT_R_BROKEN           0xff      
-
-	       uint8_t        disk;
-	       uint8_t        status;
-	       uint8_t        sectors;
-	       uint32_t       lba;
-       } errorlog[HPT37X_MAX_ERRORLOG];
-       uint8_t        filler[60];
+	struct hpt37x_errorlog {
+		uint32_t timestamp;
+		uint8_t reason;
+#define HPT_R_REMOVED          0xfe
+#define HPT_R_BROKEN           0xff
+
+		uint8_t disk;
+		uint8_t status;
+		uint8_t sectors;
+		uint32_t lba;
+	} errorlog[HPT37X_MAX_ERRORLOG];
+	uint8_t filler[60];
 } __attribute__ ((packed));
 #endif
 
--- dmraid/lib/format/ataraid/hpt45x.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/hpt45x.c	2008/06/20 21:52:17	1.3
@@ -1,7 +1,7 @@
 /*
  * Highpoint 45X ATARAID series metadata format handler.
  *
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -26,8 +26,8 @@
 
 /* Make up RAID set name from magic_0 number */
 /* FIXME: better name ? */
-static size_t _name(struct hpt45x *hpt, char *str, size_t len,
-		    unsigned int subset)
+static size_t
+_name(struct hpt45x *hpt, char *str, size_t len, unsigned int subset)
 {
 	const char *fmt;
 
@@ -39,8 +39,8 @@
 	return snprintf(str, len, fmt, hpt->magic_0, hpt->raid1_disk_number);
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	size_t len;
 	char *ret;
@@ -60,39 +60,43 @@
  * Retrieve status of device.
  * FIXME: is this sufficient to cover all state ?
  */
-static enum status status(struct hpt45x *hpt)
+static enum status
+status(struct hpt45x *hpt)
 {
 	return hpt->magic == HPT45X_MAGIC_BAD ? s_broken : s_ok;
 }
 
 /* Neutralize disk type */
-static enum type type(struct hpt45x *hpt)
+static enum type
+type(struct hpt45x *hpt)
 {
 	/* Mapping of HPT 45X types to generic types */
 	static struct types types[] = {
-		{ HPT45X_T_SPAN, t_linear},
-		{ HPT45X_T_RAID0, t_raid0},
-		{ HPT45X_T_RAID1, t_raid1},
+		{ HPT45X_T_SPAN, t_linear },
+		{ HPT45X_T_RAID0, t_raid0 },
+		{ HPT45X_T_RAID1, t_raid1 },
 		/* FIXME: handle RAID 4+5 */
-		{ 0, t_undef},
+		{ 0, t_undef },
 	};
 
 	return hpt->magic_0 ? rd_type(types, (unsigned int) hpt->type) :
-	       t_spare;
+		t_spare;
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
-	return (META(RD(new), hpt45x))->disk_number <
-	       (META(RD(pos), hpt45x))->disk_number;
+	return META(RD(new), hpt45x)->disk_number <
+	       META(RD(pos), hpt45x)->disk_number;
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
-	return (META(RD_RS(RS(new)), hpt45x))->raid1_disk_number <
-	       (META(RD_RS(RS(pos)), hpt45x))->raid1_disk_number;
+	return META(RD_RS(RS(new)), hpt45x)->raid1_disk_number <
+	       META(RD_RS(RS(pos)), hpt45x)->raid1_disk_number;
 }
 
 /*
@@ -100,19 +104,22 @@
  *
  * Check device hierarchy and create super set appropriately.
  */
-static unsigned int stride(unsigned int shift)
+static unsigned int
+stride(unsigned int shift)
 {
-	return shift ? 1 << shift : 0;
+	return shift ? (1 << shift) : 0;
 }
 
-static void super_created(struct raid_set *super, void *private)
+static void
+super_created(struct raid_set *super, void *private)
 {
-	super->type   = t_raid1;
+	super->type = t_raid1;
 	super->stride = stride(META((private), hpt45x)->raid1_shift);
 }
 
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	struct hpt45x *hpt = META(rd, hpt45x);
 
@@ -125,7 +132,7 @@
 	switch (hpt->type) {
 	case HPT45X_T_SPAN:
 	case HPT45X_T_RAID1:
-  no_raid10:
+	      no_raid10:
 		if (!find_set(lc, NULL, rs->name, FIND_TOP))
 			list_add_tail(&rs->list, LC_RS(lc));
 
@@ -152,8 +159,8 @@
 /*
  * Add a Highpoint RAID device to a set.
  */
-static struct raid_set *hpt45x_group(struct lib_context *lc,
-				       struct raid_dev *rd)
+static struct raid_set *
+hpt45x_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -174,7 +181,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct hpt45x *hpt = meta;
 
@@ -186,19 +194,20 @@
 #endif
 
 /* Magic check. */
-static int is_hpt45x(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_hpt45x(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct hpt45x *hpt = meta;
 
 	return (hpt->magic == HPT45X_MAGIC_OK ||
 		hpt->magic == HPT45X_MAGIC_BAD) &&
-		hpt->disk_number < 8;
+	       hpt->disk_number < 8;
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *hpt45x_read(struct lib_context *lc,
-				      struct dev_info *di)
+static struct raid_dev *
+hpt45x_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
 			     sizeof(struct hpt45x), HPT45X_CONFIGOFFSET,
@@ -208,8 +217,8 @@
 /*
  * Write a Highpoint 45X RAID device.
  */
-static int hpt45x_write(struct lib_context *lc,
-			struct raid_dev *rd, int erase)
+static int
+hpt45x_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -229,12 +238,14 @@
  *
  * FIXME: more sanity checks.
  */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
-	return (META(rd, hpt45x))->raid_disks;
+	return META(rd, hpt45x)->raid_disks;
 }
 
-static int hpt45x_check(struct lib_context *lc, struct raid_set *rs)
+static int
+hpt45x_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, devices, NULL,
 			      NO_CHECK_RD, NULL, handler);
@@ -243,7 +254,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct hpt45x *hpt = META(rd, hpt45x);
@@ -253,20 +265,20 @@
 		return 0;
 
 	hpt->magic = HPT45X_MAGIC_BAD;
-
 	return 1;
 }
 
 static struct event_handlers hpt45x_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about an HPT45X RAID device.
  */
-static void hpt45x_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+hpt45x_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	unsigned int i;
 	struct hpt45x *hpt = META(rd, hpt45x);
@@ -293,35 +305,37 @@
 #endif
 
 static struct dmraid_format hpt45x_format = {
-	.name	= HANDLER,
-	.descr	= "Highpoint HPT45X",
-	.caps	= "S,0,1,10",
+	.name = HANDLER,
+	.descr = "Highpoint HPT45X",
+	.caps = "S,0,1,10",
 	.format = FMT_RAID,
-	.read	= hpt45x_read,
-	.write	= hpt45x_write,
-	.group	= hpt45x_group,
-	.check	= hpt45x_check,
-	.events	= &hpt45x_event_handlers,
+	.read = hpt45x_read,
+	.write = hpt45x_write,
+	.group = hpt45x_group,
+	.check = hpt45x_check,
+	.events = &hpt45x_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= hpt45x_log,
+	.log = hpt45x_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_hpt45x(struct lib_context *lc)
+int
+register_hpt45x(struct lib_context *lc)
 {
 	return register_format_handler(lc, &hpt45x_format);
 }
 
 /* Calculate RAID device size in sectors depending on RAID type. */
-static uint64_t sectors(struct raid_dev *rd, void *meta)
+static uint64_t
+sectors(struct raid_dev *rd, void *meta)
 {
 	struct hpt45x *hpt = meta;
 
 	switch (rd->type) {
 	case t_raid0:
 		return hpt->total_secs /
-		       (hpt->raid_disks ? hpt->raid_disks : 1);
+			(hpt->raid_disks ? hpt->raid_disks : 1);
 
 	case t_raid1:
 		return hpt->total_secs;
@@ -332,8 +346,9 @@
 }
 
 /* Set the RAID device contents up derived from the Highpoint ones */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct hpt45x *hpt = meta;
 
@@ -342,18 +357,18 @@
 
 	rd->meta_areas->offset = HPT45X_CONFIGOFFSET >> 9;
 	rd->meta_areas->size = sizeof(*hpt);
-	rd->meta_areas->area = (void*) hpt;
+	rd->meta_areas->area = (void *) hpt;
 
 	rd->di = di;
 	rd->fmt = &hpt45x_format;
 
 	rd->status = status(hpt);
-	rd->type   = type(hpt);
+	rd->type = type(hpt);
 
 	rd->offset = HPT45X_DATAOFFSET;
 	if (!(rd->sectors = sectors(rd, hpt)))
 		return log_zero_sectors(lc, di->path, handler);
 
 	return (rd->name = name(lc, rd, hpt->raid1_type == HPT45X_T_RAID1)) ?
-	       1 : 0;
+		1 : 0;
 }
--- dmraid/lib/format/ataraid/hpt45x.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/hpt45x.h	2008/06/20 21:52:17	1.2
@@ -15,36 +15,36 @@
 
 /* Highpoint 45x config data sector offset off end of disk */
 #define HPT45X_CONFIGOFFSET	((di->sectors - 11) << 9)
-#define HPT45X_DATAOFFSET	0 /* Data offset in sectors */
+#define HPT45X_DATAOFFSET	0	/* Data offset in sectors */
 
 /* Ondisk metadata for Highpoint 45X ATARAID */
 struct hpt45x {
-	uint32_t	magic;		/* 0x0 - 0x03 */
+	uint32_t magic;		/* 0x0 - 0x03 */
 #define HPT45X_MAGIC_OK   0x5a7816f3
 #define HPT45X_MAGIC_BAD  0x5a7816fd
 
-	uint32_t	magic_0;	/* 0x04 - 0x07 Set identifier */
-	uint32_t	magic_1;	/* 0x08 - 0x0A (Sub-)Array identifier */
+	uint32_t magic_0;	/* 0x04 - 0x07 Set identifier */
+	uint32_t magic_1;	/* 0x08 - 0x0A (Sub-)Array identifier */
 
-	uint32_t	total_secs; 	/* 0x0B - 0x0F */
+	uint32_t total_secs;	/* 0x0B - 0x0F */
 
-	uint8_t	type;		/* 0x10 */
+	uint8_t type;		/* 0x10 */
 #define HPT45X_T_SPAN	0x04
 #define HPT45X_T_RAID0	0x05
 #define HPT45X_T_RAID1	0x06
 
-	uint8_t	raid_disks;	/* 0x11 */
-	uint8_t	disk_number;	/* 0x12 */
-	uint8_t	raid0_shift; 	/* 0x13 */
-
-	uint32_t	dummy[3];	/* 0x14 - 0x1F */
-
-	uint8_t	raid1_type;		/* 0x20 */
-	uint8_t	raid1_raid_disks;	/* 0x21 */
-	uint8_t	raid1_disk_number;	/* 0x22 */
-	uint8_t	raid1_shift;		/* 0x23 */
+	uint8_t raid_disks;	/* 0x11 */
+	uint8_t disk_number;	/* 0x12 */
+	uint8_t raid0_shift;	/* 0x13 */
+
+	uint32_t dummy[3];	/* 0x14 - 0x1F */
+
+	uint8_t raid1_type;	/* 0x20 */
+	uint8_t raid1_raid_disks;	/* 0x21 */
+	uint8_t raid1_disk_number;	/* 0x22 */
+	uint8_t raid1_shift;	/* 0x23 */
 
-	uint32_t	dummy1[3];	/* 0x24 - 0x2F */
+	uint32_t dummy1[3];	/* 0x24 - 0x2F */
 } __attribute__ ((packed));
 #endif
 
--- dmraid/lib/format/ataraid/isw.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/format/ataraid/isw.c	2008/06/20 21:52:17	1.4
@@ -1,9 +1,12 @@
 /*
  * Intel Software RAID metadata format handler.
  *
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007,2008  Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10.
+ *
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -15,7 +18,9 @@
  */
 #define	HANDLER	"isw"
 
+#include <time.h>
 #include "internal.h"
+#include <device/scsi.h>
 #define	FORMAT_HANDLER
 #include "isw.h"
 
@@ -24,74 +29,168 @@
 #  include	<datastruct/byteorder.h>
 #endif
 
+#define	GB_DIV	1024/1024/2
+
 static const char *handler = HANDLER;
 
-/*
- * Make up RAID set name from family_num and volume name.
- */
-static size_t _name(struct isw *isw, struct isw_dev *dev,
-		     char *str, size_t len)
-{
-	return snprintf(str, len, dev ? "isw_%u_%s" : "isw_%u",
-			isw->family_num, (char*) dev->volume);
+/* Return minimum/maximum disks for a given RAID level. */
+static uint16_t
+_num_disks(uint8_t raid_level, int max)
+{
+	struct mm {
+		uint8_t level;
+		uint16_t min, max;
+	};
+	static struct mm mm[] = {
+		{ISW_T_RAID0, 2, 6},
+		{ISW_T_RAID1, 2, 2},
+		{ISW_T_RAID10, 4, 4},
+		{ISW_T_RAID5, 3, 6},
+	};
+	struct mm *m = ARRAY_END(mm);
+
+	while (m-- > mm) {
+		if (raid_level == m->level)
+			return max ? m->max : m->min;
+	}
+
+	return 1;
 }
 
-static char *name(struct lib_context *lc, struct isw *isw, struct isw_dev *dev)
+static inline uint16_t
+min_num_disks(uint8_t raid_level)
 {
-        size_t len;
-        char *ret;
+	return _num_disks(raid_level, 0);
+}
 
-        if ((ret = dbg_malloc((len = _name(isw, dev, NULL, 0) + 1)))) {
-                _name(isw, dev, ret, len);
-		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
-			 (dev ? strlen((char*) dev->volume) - 2 : 1));
-        } else
-		log_alloc_err(lc, handler);
+static inline uint16_t
+max_num_disks(uint8_t raid_level)
+{
+	return _num_disks(raid_level, 1);
+}
 
-        return ret;
+/* Check if given device belongs to a RAID10 mapping. */
+static int
+is_raid10(struct isw_dev *dev)
+{
+	return dev ? (dev->vol.map.raid_level == ISW_T_RAID10 ||
+		      (dev->vol.map.raid_level == ISW_T_RAID1 &&
+		       dev->vol.map.num_members >=
+		       min_num_disks(ISW_T_RAID10))) : 0;
 }
 
 /* Find a disk table slot by serial number. */
-static struct isw_disk *_get_disk(struct isw *isw, struct dev_info *di)
+static struct isw_disk *
+_get_disk(struct isw *isw, struct dev_info *di)
 {
 	if (di->serial) {
+		int i = isw->num_disks;
 		struct isw_disk *disk = isw->disk;
 
-		do {
-			if (!strncmp(di->serial, (const char*) disk->serial,
+		while (i--) {
+			if (!strncmp(di->serial, (const char *) disk[i].serial,
 				     MAX_RAID_SERIAL_LEN))
-				return disk;
-		} while (++disk < isw->disk + isw->num_disks);
+				return disk + i;
+		}
 	}
 
 	return NULL;
 }
 
-static struct isw_disk *get_disk(struct lib_context *lc,
-				 struct dev_info *di, struct isw *isw)
+static struct isw_disk *
+get_disk(struct lib_context *lc, struct dev_info *di, struct isw *isw)
 {
 	struct isw_disk *disk;
 
 	if ((disk = _get_disk(isw, di)))
 		return disk;
 
-	LOG_ERR(lc, NULL, "%s: Error finding disk table slot for %s",
+	LOG_ERR(lc, NULL, "%s: Could not find disk %s in the metadata",
 		handler, di->path);
 }
 
+
+enum name_type { N_PATH, N_NUMBER, N_VOLUME, N_VOLUME_FORCE };
+static size_t
+_name(struct lib_context *lc, struct isw *isw, char *str, size_t len,
+      enum name_type nt, int num, struct isw_dev *dev, struct raid_dev *rd)
+{
+	struct {
+		const char *fmt, *what;
+	} formats[] = {
+		{
+		"isw_%u_%s", rd->di->path}, {
+		"isw_%u", NULL}, {
+		"isw_%u_%s", (const char *) dev->volume}, {
+	"isw_%u_%s-%u", (const char *) dev->volume},}, *f = formats;
+
+	if (nt < 0 || nt > N_VOLUME_FORCE)
+		LOG_ERR(lc, 0, "unsupported name type");
+
+	if (nt == N_VOLUME_FORCE)
+		f += N_VOLUME;
+	else {
+		f += nt;
+		if (nt == N_VOLUME)
+			f += (is_raid10(dev) ? 1 : 0);
+	}
+
+	return snprintf(str, len, f->fmt, isw->family_num, f->what, num);
+}
+
+static char *
+name(struct lib_context *lc, struct raid_dev *rd,
+     struct isw_dev *dev, enum name_type nt)
+{
+	size_t len;
+	char *ret = NULL;
+	int id = 0;
+	struct isw *isw = META(rd, isw);
+	struct isw_disk *disk = isw->disk;
+
+	if (nt == N_VOLUME && is_raid10(dev)) {
+		if ((disk = _get_disk(isw, rd->di))) {
+			int i = max_num_disks(ISW_T_RAID10);
+
+			while (i--) {
+				if (disk == isw->disk + i) {
+					id = i % 2;
+					goto ok;
+				}
+			}
+
+			return NULL;
+		}
+	}
+
+      ok:
+	if ((ret = alloc_private(lc, handler,
+				 (len = _name(lc, isw, ret, 0, nt, id,
+					      dev, rd) + 1)))) {
+		_name(lc, isw, ret, len, nt, id, dev, rd);
+		len = snprintf(ret, 0, "%u", isw->family_num);
+		mk_alpha(lc, ret + HANDLER_LEN, len);
+	}
+	else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
 /*
  * Retrieve status of device.
  *
  * FIXME: is this sufficient to cover all state ?
  */
-static enum status __status(unsigned int status)
+static enum status
+__status(unsigned status)
 {
-	return ((status & (CONFIGURED_DISK|USABLE_DISK)) &&
-		!(FAILED_DISK & status)) ?
-	       s_ok : s_broken;
+	return ((status & (CONFIGURED_DISK | USABLE_DISK)) &&
+		!(FAILED_DISK & status)) ? s_ok : s_broken;
 }
 
-static enum status status(struct lib_context *lc, struct raid_dev *rd)
+static enum status
+status(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct isw_disk *disk;
 
@@ -101,30 +200,53 @@
 	return s_undef;
 }
 
+/* Mapping of Intel types to generic types. */
+static struct types types[] = {
+	{ISW_T_RAID0, t_raid0},
+	{ISW_T_RAID1, t_raid1},
+	{ISW_T_RAID5, t_raid5_la},
+	/* Only left asymmetric supported now.
+	   { ISW_T_RAID5, t_raid5_ls},
+	   { ISW_T_RAID5, t_raid5_ra},
+	   { ISW_T_RAID5, t_raid5_rs}, */
+	{ISW_T_RAID10, t_raid1},
+	{ISW_T_SPARE, t_spare},
+	{ISW_T_UNDEF, t_undef},
+};
+
+static uint8_t
+_get_raid_level(enum type raid_type)
+{
+	int i;
+
+	for (i = 0;
+	     types[i].unified_type != t_undef &&
+	     types[i].unified_type != raid_type; i++);
+
+	return types[i].type;
+}
+
 /* Neutralize disk type. */
-static enum type type(struct raid_dev *rd)
+static enum type
+type(struct isw_dev *dev)
 {
-	/* Mapping of Intel types to generic types. */
-	static struct types types[] = {
-	        { ISW_T_RAID0, t_raid0},
-	        { ISW_T_RAID1, t_raid1},
-	        { ISW_T_RAID5, t_raid5_la},
-	        { 0, t_undef},
-	};
-	struct isw_dev *dev = rd->private.ptr;
 
-	return dev ? rd_type(types, (unsigned int) dev->vol.map.raid_level) :
-		     t_group;
+	if (is_raid10(dev))
+		return t_raid1;
+
+	return dev ? rd_type(types, (unsigned) dev->vol.map.raid_level) :
+		t_group;
 }
 
 /*
  * Generate checksum of Raid metadata for mpb_size/sizeof(u32) words
  * (checksum field itself ignored for this calculation).
  */
-static uint32_t _checksum(struct isw *isw)
+static uint32_t
+_checksum(struct isw *isw)
 {
 	uint32_t end = isw->mpb_size / sizeof(end),
-		 *p = (uint32_t*) isw, ret = 0;
+		*p = (uint32_t *) isw, ret = 0;
 
 	while (end--)
 		ret += *p++;
@@ -133,16 +255,17 @@
 }
 
 /* Calculate next isw device offset. */
-static struct isw_dev *advance_dev(struct isw_dev *dev,
-				   struct isw_map *map, size_t add)
+static struct isw_dev *
+advance_dev(struct isw_dev *dev, struct isw_map *map, size_t add)
 {
-	return (struct isw_dev*) ((uint8_t*) dev +
-				  (map->num_members - 1) * 
-				  sizeof(map->disk_ord_tbl) + add);
+	return (struct isw_dev *) ((uint8_t *) dev +
+				   (map->num_members - 1) *
+				   sizeof(map->disk_ord_tbl) + add);
 }
 
 /* Advance to the next isw_dev from a given one. */
-static struct isw_dev *advance_raiddev(struct isw_dev *dev)
+static struct isw_dev *
+advance_raiddev(struct isw_dev *dev)
 {
 	struct isw_vol *vol = &dev->vol;
 	struct isw_map *map = &vol->map;
@@ -150,16 +273,18 @@
 	/* Correction: yes, it sits here! */
 	dev = advance_dev(dev, map, sizeof(*dev));
 
-	if (vol->migr_state) /* need to add space for another map */
+	if (vol->migr_state)
+		/* Need to add space for another map. */
 		dev = advance_dev(dev, map, sizeof(*map));
 
 	return dev;
 }
 
 /* Return isw_dev by table index. */
-static struct isw_dev *raiddev(struct isw *isw, unsigned int i)
+static struct isw_dev *
+raiddev(struct isw *isw, unsigned i)
 {
-	struct isw_dev *dev = (struct isw_dev*) (isw->disk + isw->num_disks);
+	struct isw_dev *dev = (struct isw_dev *) (isw->disk + isw->num_disks);
 
 	while (i--)
 		dev = advance_raiddev(dev);
@@ -179,9 +304,10 @@
  * We can differ from the read_raid_dev template here,
  * because we don't get called from there.
  */
-static void to_cpu(struct isw *isw, enum convert cvt)
+static void
+to_cpu(struct isw *isw, enum convert cvt)
 {
-	unsigned int i, j;
+	unsigned i, j;
 	struct isw_disk *dsk;
 	struct isw_dev *dev;
 
@@ -211,7 +337,7 @@
 		CVT32(dev->reserved_blocks);
 
 		/* RAID volume has 8 bit members only. */
-	
+
 		/* RAID map. */
 		CVT32(dev->vol.map.pba_of_lba0);
 		CVT32(dev->vol.map.blocks_per_member);
@@ -224,29 +350,45 @@
 }
 #endif
 
-static int is_isw(struct lib_context *lc, struct dev_info *di, struct isw *isw)
+/* Return sector rounded size of isw metadata. */
+static size_t
+isw_size(struct isw *isw)
+{
+	return round_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE);
+}
+
+/* Set metadata area size in bytes and config offset in sectors. */
+static void
+set_metadata_sizoff(struct raid_dev *rd, size_t size)
+{
+	rd->meta_areas->size = size;
+	rd->meta_areas->offset = ISW_CONFIGSECTOR(rd->di) -
+		size / ISW_DISK_BLOCK_SIZE + 1;
+}
+
+/* Check for isw signature (magic) and version. */
+static int
+is_isw(struct lib_context *lc, struct dev_info *di, struct isw *isw)
 {
-	if (strncmp((const char *) isw->sig, MPB_SIGNATURE,
-		    sizeof(MPB_SIGNATURE) - 1))
+	if (strncmp((const char *) isw->sig, MPB_SIGNATURE, MPB_SIGNATURE_SIZE))
 		return 0;
 
-	/* Check version info, older versions supported */
-	if (strncmp((const char*) isw->sig + sizeof(MPB_SIGNATURE) - 1,
-		    MPB_VERSION_RAID2, sizeof(MPB_VERSION_RAID2) - 1) > 0)
-		log_print(lc, "%s: untested metadata version %s found on %s",
-			  handler, isw->sig + sizeof(MPB_SIGNATURE) - 1,
-			  di->path);
+	/* Check version info; older versions supported. */
+	if (strncmp((const char *) isw->sig + MPB_SIGNATURE_SIZE,
+		    MPB_VERSION_RAID2, MPB_VERSION_RAID2_SIZE) > 0)
+		log_print(lc,
+			  "%s: untested metadata version %s found on %s",
+			  handler, isw->sig + MPB_SIGNATURE_SIZE, di->path);
 
 	return 1;
 }
 
-static void isw_file_metadata(struct lib_context *lc, struct dev_info *di,
-			      void *meta)
+static void
+isw_file_metadata(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct isw *isw = meta;
-
 	/* Get the rounded up value for the metadata size */
-	size_t size = round_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE);
+	size_t size = isw_size(isw);
 
 	file_metadata(lc, handler, di->path,
 		      meta + (size / ISW_DISK_BLOCK_SIZE > 1 ?
@@ -255,62 +397,54 @@
 	file_dev_size(lc, handler, di);
 }
 
-static int isw_read_extended(struct lib_context *lc, struct dev_info *di,
-			     struct isw **isw,
-			     uint64_t *isw_sboffset, size_t *size)
+static int
+isw_read_extended(struct lib_context *lc, struct dev_info *di,
+		  struct isw **isw, uint64_t * isw_sboffset, size_t * size)
 {
 	struct isw *isw_tmp;
-
 	/* Get the rounded up value for the metadata blocks */
 	size_t blocks = div_up((*isw)->mpb_size, ISW_DISK_BLOCK_SIZE);
 
-	/* No extended metadata to read ? */
-	if (blocks < 2)
-		return 1;
-
-	/*
-	 * Allocate memory for the extended Intel superblock
-	 * and read it in. Reserve one more disk block in order
-	 * to be able to file the metadata in the proper sequence.
-	 * (ie, sectors 1, 2-n, 1 in core so that the filing can start at 2).
-	 */
+	/* Allocate memory for the extended Intel superblock and read it in. */
 	*size = blocks * ISW_DISK_BLOCK_SIZE;
 	*isw_sboffset -= *size - ISW_DISK_BLOCK_SIZE;
 
-	if ((isw_tmp = alloc_private(lc, handler,
-				     *size + ISW_DISK_BLOCK_SIZE))) {
+	if ((isw_tmp = alloc_private(lc, handler, *size))) {
+		/* Copy in first metadata sector. */
+		memcpy(isw_tmp, *isw, ISW_DISK_BLOCK_SIZE);
+
 		/* Read extended metadata to offset ISW_DISK_BLOCK_SIZE */
-		if (read_file(lc, handler, di->path,
-			      (void*) isw_tmp + ISW_DISK_BLOCK_SIZE,
-			      *size - ISW_DISK_BLOCK_SIZE, *isw_sboffset))
-			/* Copy in first metadata sector. */
-			memcpy(isw_tmp, *isw, ISW_DISK_BLOCK_SIZE);
-		else {
+		if (blocks > 1 &&
+		    !read_file(lc, handler, di->path,
+			       (void *) isw_tmp + ISW_DISK_BLOCK_SIZE,
+			       *size - ISW_DISK_BLOCK_SIZE, *isw_sboffset)) {
 			dbg_free(isw_tmp);
 			isw_tmp = NULL;
 		}
 	}
+	else
+		return 0;
 
 	dbg_free(*isw);
 	*isw = isw_tmp;
-
-	return isw_tmp ? 1 : 0;
+	return *isw ? 1 : 0;
 }
 
 /* Check for RAID disk ok. */
-static int disk_ok(struct lib_context *lc, struct dev_info *di, struct isw *isw)
+static int
+disk_ok(struct lib_context *lc, struct dev_info *di, struct isw *isw)
 {
 	struct isw_disk *disk = get_disk(lc, di, isw);
 
 	return disk && __status(disk->status) == s_ok;
 }
 
-static void *isw_read_metadata(struct lib_context *lc, struct dev_info *di,
-			       size_t *sz, uint64_t *offset,
-			       union read_info *info)
+static void *
+isw_read_metadata(struct lib_context *lc, struct dev_info *di,
+		  size_t * sz, uint64_t * offset, union read_info *info)
 {
 	size_t size = ISW_DISK_BLOCK_SIZE;
-	uint64_t isw_sboffset = ISW_CONFIGOFFSET;
+	uint64_t isw_sboffset = ISW_CONFIGOFFSET(di);
 	struct isw *isw;
 
 	if (!(isw = alloc_private_and_read(lc, handler, size,
@@ -336,57 +470,60 @@
 
 	if (disk_ok(lc, di, isw)) {
 		*sz = size;
-		*offset = isw_sboffset;
-		info->u64 = isw_sboffset;
+		*offset = info->u64 = isw_sboffset;
 		goto out;
 	}
-	
-   bad:
+
+      bad:
 	dbg_free(isw);
 	isw = NULL;
 
-   out:
-	return (void*) isw;
+      out:
+	return (void *) isw;
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *isw_read(struct lib_context *lc, struct dev_info *di)
+static struct raid_dev *
+isw_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, isw_read_metadata, 0, 0, NULL, NULL,
 			     isw_file_metadata, setup_rd, handler);
 }
 
 /*
- * Write an Intel Software RAID device.
+ * Write metadata to an Intel Software RAID device.
  */
-static int isw_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+static int
+isw_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 	struct isw *isw = META(rd, isw);
-	int large = div_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE) > 1;
+	void *dst, *src = isw;
+	uint32_t size = isw->mpb_size;
 
 	to_disk(isw, FULL);
 
-	if (large) {
-		/*
-		 * Copy 1st metadata sector to after the extended ones
-		 * and increment metadata area pointer by one block, so
-		 * that the metadata is filed in the proper sequence.
-		 */
-		memcpy((void*) isw + rd->meta_areas->size, isw,
-		       ISW_DISK_BLOCK_SIZE);
-		rd->meta_areas->area += ISW_DISK_BLOCK_SIZE;
-	}
+	/* Flip sectors for write_metadata() to work if extended metadata. */
+	if (size > ISW_DISK_BLOCK_SIZE) {
+		/* sunil */
+		dst = alloc_private(lc, handler, 2 * ISW_DISK_BLOCK_SIZE);
+		if (!dst)
+			return 0;
 
+		memcpy(dst, src + ISW_DISK_BLOCK_SIZE, ISW_DISK_BLOCK_SIZE);
+		memcpy(dst + ISW_DISK_BLOCK_SIZE, src, ISW_DISK_BLOCK_SIZE);
+	}
+	else
+		dst = isw;
+	rd->meta_areas->area = dst;
 	ret = write_metadata(lc, handler, rd, -1, erase);
+	rd->meta_areas->area = isw;
 
-	/* Correct metadata area pointer. */
-	if (large)
-		rd->meta_areas->area -= ISW_DISK_BLOCK_SIZE;
+	if (dst != isw)
+		dbg_free(dst);
 
 	to_cpu(isw, FULL);
-
 	return ret;
 }
 
@@ -395,137 +532,222 @@
  * multiple RAID sets and RAID disks.
  */
 /* Check state if isw device map. */
-static int _check_map_state(struct lib_context *lc, struct raid_dev *rd,
-			    struct isw_dev *dev)
+static int
+_check_map_state(struct lib_context *lc, struct raid_dev *rd,
+		 struct isw_dev *dev)
 {
 	/* FIXME: FAILED_MAP etc. */
 	switch (dev->vol.map.map_state) {
 	case ISW_T_STATE_NORMAL:
 	case ISW_T_STATE_UNINITIALIZED:
+	case ISW_T_STATE_DEGRADED:
+	case ISW_T_STATE_FAILED:
 		break;
 
 	default:
-		LOG_ERR(lc, 0, "%s: unsupported map state 0x%x on %s for %s",
+		LOG_ERR(lc, 0,
+			"%s: unsupported map state 0x%x on %s for %s",
 			handler, dev->vol.map.map_state, rd->di->path,
-			(char*) dev->volume);
+			(char *) dev->volume);
 	}
 
 	return 1;
 }
 
 /* Create a RAID device to map a volumes segment. */
-static struct raid_dev *_create_rd(struct lib_context *lc, struct raid_dev *rd,
-				   struct isw *isw, struct isw_dev *dev)
+static struct raid_dev *
+_create_rd(struct lib_context *lc,
+	   struct raid_dev *rd, struct isw *isw, struct isw_dev *dev)
 {
 	struct raid_dev *r;
 
-	if (!_check_map_state(lc, rd, dev) ||
-	    !(r = alloc_raid_dev(lc, handler)))
+	if (!(r = alloc_raid_dev(lc, handler)))
 		return NULL;
 
+	if (!(r->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		goto free;
+
+	/* Configuration for spare disk. */
+	if (isw->disk[0].status & SPARE_DISK) {
+		r->meta_areas->offset = rd->meta_areas->offset;
+		r->meta_areas->size = rd->meta_areas->size;
+		r->meta_areas->area =
+			alloc_private(lc, handler, rd->meta_areas->size);
+		memcpy(r->meta_areas->area, rd->meta_areas->area,
+		       rd->meta_areas->size);
+
+		r->type = t_spare;
+		if (!(r->name = name(lc, rd, NULL, N_PATH)))
+			goto free;
+
+		r->di = rd->di;
+		r->fmt = rd->fmt;
+		r->sectors = ISW_CONFIGSECTOR(r->di);
+		goto out;
+	}
+
+	if (!_check_map_state(lc, rd, dev))
+		goto free;
+
 	if (!(r->private.ptr = alloc_private(lc, handler, sizeof(*dev))))
 		goto free;
 
 	memcpy(r->private.ptr, dev, sizeof(*dev));
-	if ((r->type = type(r)) == t_undef) {
+
+	r->meta_areas->offset = rd->meta_areas->offset;
+	r->meta_areas->size = rd->meta_areas->size;
+	r->meta_areas->area = alloc_private(lc, handler, rd->meta_areas->size);
+	memcpy(r->meta_areas->area, rd->meta_areas->area, rd->meta_areas->size);
+
+	if ((r->type = type(dev)) == t_undef) {
 		log_err(lc, "%s: RAID type %u not supported",
-			handler, (unsigned int) dev->vol.map.raid_level);
+			handler, (unsigned) dev->vol.map.raid_level);
 		goto free;
 	}
 
-        if (!(r->name = name(lc, isw, dev)))
+	if (!(r->name = name(lc, rd, dev, N_VOLUME)))
 		goto free;
 
 	r->di = rd->di;
 	r->fmt = rd->fmt;
-	
-	r->offset  = dev->vol.map.pba_of_lba0;
+	r->offset = dev->vol.map.pba_of_lba0;
 	if ((r->sectors = dev->vol.map.blocks_per_member))
 		goto out;
 
 	log_zero_sectors(lc, rd->di->path, handler);
 
-   free:
+      free:
 	free_raid_dev(lc, &r);
-   out:
+      out:
 	return r;
 }
 
 /* Find an Intel RAID set or create it. */
-static void create_rs(struct raid_set *rs, void* private)
+static void
+create_rs(struct raid_set *rs, void *private)
 {
-	rs->stride = ((struct isw_dev*) private)->vol.map.blocks_per_strip;
+	rs->stride = ((struct isw_dev *) private)->vol.map.blocks_per_strip;
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	struct isw *isw = RD(new)->private.ptr;
-	
+
 	return _get_disk(isw, RD(new)->di) < _get_disk(isw, RD(pos)->di);
 }
 
+static void
+super_created(struct raid_set *super, void *private)
+{
+	super->type = t_raid0;
+	super->stride = ((struct isw_dev *) private)->vol.map.blocks_per_strip;
+}
+
 /*
  * rs_group contains the top-level group RAID set (type: t_group) on entry
  * and shall be returned on success (or NULL on error).
  */
-static struct raid_set *group_rd(struct lib_context *lc,
-				   struct raid_set *rs_group,
-				   struct raid_dev *rd_meta)
+static struct raid_set *
+group_rd(struct lib_context *lc,
+	 struct raid_set *rs_group, struct raid_dev *rd_meta)
 {
-	unsigned int d;
+	unsigned d;
 	void *private;
 	struct isw *isw = META(rd_meta, isw);
 	struct isw_dev *dev;
 	struct raid_dev *rd;
-	struct raid_set *rs;
+	struct raid_set *rs, *ss;
+	char *ss_name = NULL;
 
-	/* Loop the device/volume table. */
-	for (d = 0; d < isw->num_raid_devs; d++) {
-		dev = raiddev(isw, d);
 
+	/* Configuration for spare disk. */
+	if (isw->disk[0].status & SPARE_DISK) {
+
+		/* Spare disk has no device description. */
+		dev = NULL;
 		if (!(rd = _create_rd(lc, rd_meta, isw, dev)))
 			return NULL;
 
-		if (!(rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL,
-				      		  rd, &rs_group->sets,
-						  create_rs, dev))) {
+		if (!(rs = find_or_alloc_raid_set(lc, rd->name,
+						  FIND_ALL, rd,
+						  &rs_group->sets, NULL,
+						  NULL))) {
 			free_raid_dev(lc, &rd);
 			return NULL;
 		}
 
-		/* Save and set to enable dev_sort(). */
-		private = rd->private.ptr;
-		rd->private.ptr = isw;
-
+		rs->status = s_ok;
 		list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+	}
+	else {
+		/* Loop the device/volume table. */
+		for (d = 0; d < isw->num_raid_devs; d++) {
+			dev = raiddev(isw, d);
+
+			if (!(rd = _create_rd(lc, rd_meta, isw, dev)))
+				return NULL;
+			if (is_raid10(dev)) {
+				ss_name = name(lc, rd, dev, N_VOLUME_FORCE);
+				ss = find_or_alloc_raid_set(lc, ss_name,
+							    FIND_ALL, rd,
+							    &rs_group->sets,
+							    super_created, dev);
+
+				if (!ss) {
+					dbg_free(ss_name);
+					free_raid_dev(lc, &rd);
+					return NULL;
+				}
+			}
+			else
+				ss = rs_group;
+
+			if (!(rs = find_or_alloc_raid_set(lc, rd->name,
+							  FIND_ALL, rd,
+							  &ss->sets, create_rs,
+							  dev))) {
+				free_raid_dev(lc, &rd);
+				return NULL;
+			}
+
+			rs->status = s_ok;
+
+			/* Save and set to enable dev_sort(). */
+			private = rd->private.ptr;
+			rd->private.ptr = isw;
+			list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+			/* Restore. */
+			rd->private.ptr = private;
 
-		/* Restore. */
-		rd->private.ptr = private;
+		}
 	}
 
 	return rs_group;
 }
 
 /* Add an Intel SW RAID device to a set */
-static struct raid_set *isw_group(struct lib_context *lc,
-				  struct raid_dev *rd_meta)
+static struct raid_set *
+isw_group(struct lib_context *lc, struct raid_dev *rd_meta)
 {
-	struct raid_set *rs_group;
+	struct raid_set *rs_group = NULL;
 
-	if (T_SPARE(rd_meta))
-		return NULL;
 
 	/*
 	 * Once we get here, an Intel SW RAID disk containing a metadata area
-	 * with a volume table has been discovered by isw_read.
+	 * with a volume table has been discovered by isw_read. There is one
+	 * goup RAID set for each metadata configuration. The volume defined in
+	 * the metadata is a subset of the group RAID set.
 	 */
+
 	/* Check if a top level group RAID set already exists. */
-	if (!(rs_group = find_or_alloc_raid_set(lc, rd_meta->name, FIND_TOP,
-				      		rd_meta, LC_RS(lc),
-						NO_CREATE, NO_CREATE_ARG)))
+	if (!(rs_group =
+	      find_or_alloc_raid_set(lc, rd_meta->name, FIND_TOP, rd_meta,
+				     LC_RS(lc), NO_CREATE, NO_CREATE_ARG)))
 		return NULL;
 
+
 	/*
 	 * Add the whole underlying (meta) RAID device to the group set.
 	 * Sorting is no problem here, because RAID sets and devices will
@@ -535,6 +757,13 @@
 	list_add_sorted(lc, &rs_group->devs, &rd_meta->devs, dev_sort);
 	rd_meta->private.ptr = NULL;
 
+
+	/* mark spare set as group set */
+	if (T_SPARE(rs_group))
+		rs_group->type = t_group;
+
+
+
 	/*
 	 * We need to run through the volume table and create a RAID set and
 	 * RAID devices hanging off it for every volume,
@@ -543,264 +772,1894 @@
 	 * A pointer to the top-level group RAID set
 	 * gets returned or NULL on error.
 	 */
-	return group_rd(lc, rs_group, rd_meta);
+	struct raid_set *ret = group_rd(lc, rs_group, rd_meta);
+
+	return ret;
 }
 
-/*
- * Check an Intel SW RAID set.
- *
- * FIXME: more sanity checks.
- */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned
+adjust_length(struct isw_dev *dev, struct isw_dev *dev_rebuilt,
+	      unsigned map_size)
 {
-	return ((struct isw_dev*) rd->private.ptr)->vol.map.num_members;
+	return (dev == dev_rebuilt || !dev->vol.migr_state) ?
+		map_size : 2 * map_size;
 }
 
-static int check_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_dev *rd, void *context)
+/*
+ * Find out index of a raid device in isw_dev array by name.
+ * The function returns -1 if no relevant device can be found.
+ */
+static int
+rd_idx_by_name(struct isw *isw, const char *name)
 {
-	struct isw_dev *dev = rd->private.ptr;
+	int i = isw->num_raid_devs;
 
-	/* FIXME: more status checks ? */
-	if (dev->status)
-		LOG_ERR(lc, 0, "%s device for volume \"%s\" broken on %s "
-			"in RAID set \"%s\"",
-			handler, dev->volume, rd->di->path, rs->name);
+	while (i--) {
+		if (strstr(name, (const char *) raiddev(isw, i)->volume))
+			return i;
+	}
 
-	return 1;
+	return -ENOENT;
 }
 
-static int _isw_check(struct lib_context *lc, struct raid_set *rs)
+/* Return RAID device for serial string. */
+static struct raid_dev *
+rd_by_serial(struct raid_set *rs, const char *serial)
 {
-	return check_raid_set(lc, rs, devices, NULL, check_rd, NULL, handler);
-}
+	struct raid_dev *rd;
 
-static int isw_check(struct lib_context *lc, struct raid_set *rs)
-{
-	return T_GROUP(rs) ? _isw_check(lc, rs) : 0;
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (rd->di &&
+		    !strncmp(rd->di->serial, serial, MAX_RAID_SERIAL_LEN))
+			return rd;
+	}
+
+	return NULL;
 }
 
-/*
- * IO error event handler.
- */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static struct isw *
+update_metadata_after_rebuild(struct lib_context *lc, struct raid_set *rs)
 {
-	struct raid_dev *rd = e_io->rd;
-	struct isw *isw = META(rd, isw);
-	struct isw_disk *disk;
-
-	if (!(disk = get_disk(lc, rd->di, isw)))
-		LOG_ERR(lc, 0, "%s: disk", handler);
+	struct raid_dev *rd = list_entry(rs->devs.next, struct raid_dev, devs);
+	struct isw *old_isw = META(rd, isw), *new_isw;
+	struct isw_dev *old_vol0 = NULL, *old_vol1 = NULL, *vol_rebuilt = NULL;
+	int vol_rebuilt_idx;
+	int remove_disk;
+	unsigned map_size, new_isw_size;
+	unsigned old_isw_offs, new_isw_offs;
+	unsigned i;
+
+
+	old_vol0 = raiddev(old_isw, 0);
+	if (old_isw->num_raid_devs > 1)
+		old_vol1 = raiddev(old_isw, 1);
+
+	/* Determine the volume being rebuilt. */
+	vol_rebuilt_idx =
+		rd_idx_by_name(old_isw,
+			       lc->options[LC_REBUILD_SET].arg.str +
+			       strlen(rs->name) + 1);
+	if (vol_rebuilt_idx < 0)
+		return NULL;
 
-	/* Avoid write trashing. */
-	if (S_BROKEN(status(lc, rd)))
-		return 0;
+	/* Modify metadata related to the volume being rebuilt. */
+	vol_rebuilt = vol_rebuilt_idx ? old_vol1 : old_vol0;
+	vol_rebuilt->vol.migr_type = 0;	/* FIXME: replace magic numbers */
+	vol_rebuilt->vol.migr_state = 0;	/* FIXME: replace magic number */
+	vol_rebuilt->vol.map.failed_disk_num = 255;	/* FIXME: replace magic number */
+
+	/* Are we going to remove the failed disk from the metadata ? */
+	remove_disk = (!old_vol0->vol.migr_type && old_vol1) ?
+		!old_vol1->vol.migr_type : 1;
+
+	/* Calculate new metadata's size and allocate memory for it. */
+	map_size = sizeof(struct isw_map) +
+		(vol_rebuilt->vol.map.num_members - 1) *
+		sizeof(((struct isw_map *) NULL)->disk_ord_tbl);
+
+	/* If we remove a disk. */
+	new_isw_size = old_isw->mpb_size -	/* old size */
+		remove_disk * sizeof(struct isw_disk) - map_size;
+	new_isw = alloc_private(lc, handler, new_isw_size);
+
+	/* Copy metadata structures: struct isw without disks' array. */
+	new_isw_offs = old_isw_offs = i =
+		sizeof(struct isw) - sizeof(struct isw_disk);
+	memcpy(new_isw, old_isw, i);
+
+	/* Copy metadata structures: disks' array. */
+	i = (old_isw->num_disks - remove_disk) * sizeof(struct isw_disk);
+	memcpy((void *) new_isw + new_isw_offs,
+	       (void *) old_isw + old_isw_offs, i);
+	new_isw_offs += i;
+	old_isw_offs += i + remove_disk * sizeof(struct isw_disk);
+
+	/* Copy metadata structures: isw_dev record #0. */
+	i = sizeof(struct isw_dev) - sizeof(struct isw_map) +
+		adjust_length(old_vol0, vol_rebuilt, map_size);
+
+	memcpy((void *) new_isw + new_isw_offs,
+	       (void *) old_isw + old_isw_offs, i);
+	new_isw_offs += i;
+	old_isw_offs += i;
+	if (old_vol0 == vol_rebuilt)
+		old_isw_offs += map_size;
+
+	/* Copy metadata structures: isw_dev record #1 (if present). */
+	if (old_vol1) {
+		i = sizeof(struct isw_dev) - sizeof(struct isw_map) +
+			adjust_length(old_vol1, vol_rebuilt, map_size);
+		memcpy((void *) new_isw + new_isw_offs,
+		       (void *) old_isw + old_isw_offs, i);
+		new_isw_offs += i;
+		old_isw_offs += i;
 
-	disk->status &= ~USABLE_DISK;
-	disk->status |= FAILED_DISK;
+		if (old_vol1 == vol_rebuilt)
+			old_isw_offs += map_size;
+	}
 
-	return 1;
+	/* finally update new metadata's fields */
+	new_isw->mpb_size = new_isw_size;
+	new_isw->num_disks -= remove_disk;
+	new_isw->generation_num++;
+	new_isw->check_sum = _checksum(new_isw);
+	return new_isw;
 }
 
-static struct event_handlers isw_event_handlers = {
-	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
-};
 
-#ifdef DMRAID_NATIVE_LOG
-/*
- * Log native information about an ISW RAID device.
- */
-static void isw_log(struct lib_context *lc, struct raid_dev *rd)
+/* Handle rebuild state. */
+static int
+get_rebuild_state(struct lib_context *lc,
+		  struct raid_set *rs, struct raid_dev *rd)
 {
-	unsigned int d, i;
-	struct isw *isw = META(rd, isw);
-	struct isw_disk *disk;
+	int idx;
+	struct raid_dev *check_rd;
+	struct isw *isw;
 	struct isw_dev *dev;
+	struct isw_disk *disk;
 
-	log_print(lc, "%s (%s):", rd->di->path, handler);
-	P("sig: \"%*s\"", isw, isw->sig, MAX_SIGNATURE_LENGTH, isw->sig);
-	DP("check_sum: %u", isw, isw->check_sum);
-	DP("mpb_size: %u", isw, isw->mpb_size);
-	DP("family_num: %u", isw, isw->family_num);
-	DP("generation_num: %u", isw, isw->generation_num);
-	DP("reserved[0]: %u", isw, isw->reserved[0]);
-	DP("reserved[1]: %u", isw, isw->reserved[1]);
-	DP("num_disks: %u", isw, isw->num_disks);
-	DP("num_raid_devs: %u", isw, isw->num_raid_devs);
-	DP("fill[0]: %u", isw, isw->fill[0]);
-	DP("fill[1]: %u", isw, isw->fill[1]);
+	list_for_each_entry(check_rd, &rs->devs, devs) {
+		if (check_rd->meta_areas) {
+			isw = META(check_rd, isw);
+
+			idx = rd_idx_by_name(isw,
+					     lc->options[LC_REBUILD_SET].
+					     arg.str);
+			if (idx < 0)
+				return 0;
+
+			dev = raiddev(isw, idx);
+			disk = isw->disk;
+
+			if (dev->vol.migr_state &&
+			    dev->vol.migr_type &&
+			    dev->vol.map.failed_disk_num < isw->num_disks) {
+				/*
+				 * If rd that belongs to RAID set is
+				 * pointed at by failed disk number 
+				 * the RAID set state is migration.
+				 */
+				rd = rd_by_serial(rs,
+						  (const char *) disk[dev->
+								      vol.map.failed_disk_num].serial);
+				if (rd)
+					/*
+					 * Found RAID device that belongs to
+					 * RAID set is marked as failed in
+					 * metadata.
+					 */
+					return s_nosync;
+			}
+			else if (dev->vol.map.map_state == ISW_T_STATE_DEGRADED)
+				return s_inconsistent;
+		}
+
+		/*
+		 * Check only first metadata on the
+		 * first rd that has a metadata.
+		 */
+		return s_inconsistent;
 
-	for (i = 0; i < ISW_FILLERS; i++) {
-		if (isw->filler[i])
-        		P("filler[%i]: %u", isw,
-			  isw->filler[i], i, isw->filler[i]);
 	}
 
-	/* Disk table. */
-	for (d = 0, disk = isw->disk; d < isw->num_disks; d++, disk++) {
-		if (!disk->totalBlocks)
-			continue;
+	return s_inconsistent;
+}
 
-		P("disk[%u].serial: \"%*s\"", isw,
-		  disk->serial, d, MAX_RAID_SERIAL_LEN, disk->serial);
-		P("disk[%u].totalBlocks: %u", isw,
-		  disk->totalBlocks, d, disk->totalBlocks);
-		P("disk[%u].scsiId: 0x%x", isw, disk->scsiId, d, disk->scsiId);
-		P("disk[%u].status: 0x%x", isw, disk->status, d, disk->status);
-		for (i = 0; i < ISW_DISK_FILLERS; i++) {
-			if (disk->filler[i])
-                		P("disk[%u].filler[%u]: %u", isw,
-				  disk->filler[i], d, i, disk->filler[i]);
+/* isw metadata handler routine. */
+static int
+isw_metadata_handler(struct lib_context *lc, enum handler_commands command,
+		     struct handler_info *info, void *context)
+{
+	int idx, ret = 0;
+	struct raid_set *rs = context;
+	struct raid_dev *rd = list_entry(rs->devs.next, struct raid_dev, devs);
+	struct isw *isw, *new_isw;
+	struct isw_dev *dev;
+	struct isw_disk *disk;
+
+	switch (command) {
+	case UPDATE_REBUILD_STATE:
+		new_isw = update_metadata_after_rebuild(lc, rs);
+		if (!new_isw)
+			return 0;
+
+		/* Embed the new metadata on disks. */
+		list_for_each_entry(rd, &rs->devs, devs) {
+			set_metadata_sizoff(rd, isw_size(new_isw));
+			memcpy(rd->meta_areas->area, new_isw,
+			       new_isw->mpb_size);
+
+			/* FIXME: use fmt->write from metadata.c instead ? */
+			/* FIXME: log update. */
+			ret = isw_write(lc, rd, 0);
+			if (!ret)
+				break;
 		}
-	}
 
-	/* RAID device/volume table. */
-	for (d = 0; d < isw->num_raid_devs; d++) {
-		dev = raiddev(isw, d);
+		break;
 
-		/* RAID device */
-		P("isw_dev[%u].volume: \"%*s\"", isw,
-		  dev->volume, d, MAX_RAID_SERIAL_LEN, dev->volume);
-		P("isw_dev[%u].SizeHigh: %u", isw,
-		  dev->SizeHigh, d, dev->SizeHigh);
-		P("isw_dev[%u].SizeLow: %u", isw,
-		  dev->SizeLow, d, dev->SizeLow);
-		P("isw_dev[%u].status: 0x%x", isw, dev->status, d, dev->status);
-		P("isw_dev[%u].reserved_blocks: %u", isw,
-		  dev->reserved_blocks, d, dev->reserved_blocks);
+	case GET_REBUILD_STATE:
+		return get_rebuild_state(lc, rs, rd);
 
-		for (i = 0; i < ISW_DEV_FILLERS; i++) {
-			if (dev->filler[i])
-                		P("isw_dev[%u].filler[%u]: %u", isw,
-				  dev->filler[i], d, i, dev->filler[i]);
+	case GET_REBUILD_DRIVE:
+		isw = META(rd, isw);
+		dev = raiddev(isw, 0);
+		disk = isw->disk + dev->vol.map.failed_disk_num;
+
+		rd = rd_by_serial(rs, (const char *) disk->serial);
+		if (rd) {
+			if (info && info->data.str && info->size) {
+				strncpy(info->data.str, rd->di->path,
+					info->size);
+				log_print(lc,
+					  "Rebuild Drive: %s Serial No: %s\n",
+					  rd->di->path, rd->di->serial);
+				ret = 1;
+			}
+			else
+				log_err(lc,
+					"Can't provide rebuild drive path!");
 		}
 
-		/* RAID volume */
-		for (i = 0; i < 2; i++) {
-			if (dev->vol.reserved[i])
-                		P("isw_dev[%u].vol.reserved[%u]: %u", isw,
-				  dev->vol.reserved[i], d, i,
-				  dev->vol.reserved[i]);
+		break;
+
+	case GET_REBUILD_DRIVE_NO:
+		rd = list_entry(rs->devs.next, typeof(*rd), devs);
+		isw = META(rd, isw);
+		idx = rd_idx_by_name(isw, lc->options[LC_REBUILD_SET].arg.str);
+		if (idx < 0)
+			return 0;
+
+		dev = raiddev(isw, idx);
+		disk = isw->disk;
+
+		if (info) {
+			if (dev->vol.map.failed_disk_num <
+			    dev->vol.map.num_members) {
+				info->data.i32 = is_raid10(dev) ?
+					dev->vol.map.failed_disk_num /
+					dev->vol.map.num_domains :
+					dev->vol.map.failed_disk_num;
+
+				ret = 1;
+			}
+			else
+				info->data.i32 = -1;
 		}
 
-		P("isw_dev[%u].vol.migr_state: %u", isw,
-		  dev->vol.migr_state, d, dev->vol.migr_state);
-		P("isw_dev[%u].vol.migr_type: %u", isw,
-		  dev->vol.migr_type, d, dev->vol.migr_type);
-		P("isw_dev[%u].vol.dirty: %u", isw,
-		  dev->vol.dirty, d, dev->vol.dirty);
-		P("isw_dev[%u].vol.fill[0]: %u", isw,
-		  dev->vol.fill[0], d, dev->vol.fill[0]);
+		break;		/* case GET_REBUILD_DRIVE_NO */
 
-		for (i = 0; i < 5; i++) {
-			if (dev->vol.filler[i])
-                		P("isw_dev[%u].vol.filler[%u]: %u", isw,
-				  dev->vol.filler[i], d, i,
-				  dev->vol.filler[i]);
-		}
-
-		/* RAID map */
-		P("isw_dev[%u].vol.map.pba_of_lba0: %u", isw,
-		  dev->vol.map.pba_of_lba0, d,
-		  dev->vol.map.pba_of_lba0);
-		P("isw_dev[%u].vol.map.blocks_per_member: %u", isw,
-		  dev->vol.map.blocks_per_member, d,
-		  dev->vol.map.blocks_per_member);
-		P("isw_dev[%u].vol.map.num_data_stripes: %u", isw,
-		  dev->vol.map.num_data_stripes, d,
-		  dev->vol.map.num_data_stripes);
-		P("isw_dev[%u].vol.map.blocks_per_strip: %u", isw,
-		  dev->vol.map.blocks_per_strip, d,
-		  dev->vol.map.blocks_per_strip);
-		P("isw_dev[%u].vol.map.map_state: %u", isw,
-		  dev->vol.map.map_state, d,
-		  dev->vol.map.map_state);
-		P("isw_dev[%u].vol.map.raid_level: %u", isw,
-		  dev->vol.map.raid_level, d,
-		  dev->vol.map.raid_level);
-		P("isw_dev[%u].vol.map.num_members: %u", isw,
-		  dev->vol.map.num_members, d,
-		  dev->vol.map.num_members);
-
-		for (i = 0; i < 3; i++) {
-			if (dev->vol.map.reserved[i])
-                		P("isw_dev[%u].vol.map.reserved[%u]: %u", isw,
-				  dev->vol.map.reserved[i], d, i,
-				  dev->vol.map.reserved[i]);
-		}
-
-		for (i = 0; i < 7; i++) {
-			if (dev->vol.map.filler[i])
-                		P("isw_dev[%u].vol.map.filler[%u]: %u", isw,
-				  dev->vol.map.filler[i], d, i,
-				  dev->vol.map.filler[i]);
-		}
-
-		for (i = 0; i < isw->num_disks; i++) {
-			P("isw_dev[%u].vol.map.disk_ord_tbl[%u]: 0x%x", isw,
-			  dev->vol.map.disk_ord_tbl[i], d, i,
-			  dev->vol.map.disk_ord_tbl[i]);
-		}
-	}
-}
-#endif
+	default:
+		LOG_ERR(lc, 0, "%u not yet supported", command);
 
-static struct dmraid_format isw_format = {
-	.name	= HANDLER,
-	.descr	= "Intel Software RAID",
-	.caps	= "0,1,5",
-	.format = FMT_RAID,
-	.read	= isw_read,
-	.write	= isw_write,
-	.group	= isw_group,
-	.check	= isw_check,
-	.events	= &isw_event_handlers,
-#ifdef DMRAID_NATIVE_LOG
-	.log	= isw_log,
-#endif
-};
+	}
 
-/* Register this format handler with the format core. */
-int register_isw(struct lib_context *lc)
-{
-	return register_format_handler(lc, &isw_format);
+	return ret;
 }
 
 /*
- * Set the RAID device contents up derived from the Intel ones.
+ * Check an Intel SW RAID set.
  *
- * This is the first one we get with here and we potentially need to
- * create many in isw_group() in case of multiple Intel SW RAID devices
- * on this RAID disk.
+ * FIXME: more sanity checks.
  */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static unsigned
+devices(struct raid_dev *rd, void *context)
 {
-	struct isw *isw = meta;
+	return rd->type != t_spare ?
+		((struct isw_dev *) rd->private.ptr)->vol.map.num_members : 0;
+}
 
-	/* Superblock checksum */
-	if (isw->check_sum != _checksum(isw))
-		LOG_ERR(lc, 0, "%s: extended superblock for %s "
-			       "has wrong checksum",
-			handler, di->path);
+static unsigned
+devices_per_domain(struct raid_dev *rd, void *context)
+{
+	return ((struct isw_dev *) rd->private.ptr)->vol.map.num_members /
+		((struct isw_dev *) rd->private.ptr)->vol.map.num_domains;
+}
 
-	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
-		return 0;
+static int
+check_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_dev *rd, void *context)
+{
+	struct isw_dev *dev = rd->private.ptr;
 
-	rd->meta_areas->offset = info->u64 >> 9;
-	rd->meta_areas->size = round_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE);
-	rd->meta_areas->area = (void*) isw;
+	/* FIXME: more status checks ? */
+	if (dev->status) {
+		LOG_ERR(lc, 0, "%s device for volume \"%s\" broken on %s "
+			"in RAID set \"%s\"",
+			handler, dev->volume, rd->di->path, rs->name);
 
-	rd->di = di;
-	rd->fmt = &isw_format;
+	}
 
-	rd->offset = ISW_DATAOFFSET;
-	if (!(rd->sectors = info->u64 >> 9))
-		return log_zero_sectors(lc, di->path, handler);
+	return 1;
+}
 
-	rd->status = status(lc, rd);
-	rd->type   = t_group;
+static int
+_isw_check(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_set *r;
+
+	list_for_each_entry(r, &rs->sets, list) {
+		if (SETS(r))
+			check_raid_set(lc, r, devices_per_domain, NULL,
+				       check_rd, NULL, handler);
+		else
+			check_raid_set(lc, r, devices, NULL, check_rd,
+				       NULL, handler);
+	}
+
+	return 1;
+}
+
+static char *
+get_rs_basename(char *str)
+{
+	char *ret, *end;
+
+	if (!(end = strchr(str, '_')))
+		return str;
+
+	if (!(end = strchr((++end), '_')))
+		return str;
+
+	if ((ret = strstr(str, "isw_")) == str && strlen(end) > 1)
+		return ++end;
+
+	return str;
+}
+
+/* Check that volume name is unique. */
+static int
+is_name_unique(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_set *rs1, *rs2;
+	char *bn;
+
+	list_for_each_entry(rs1, LC_RS(lc), list) {
+		if (rs1->type == t_group) {
+			list_for_each_entry(rs2, &rs1->sets, list) {
+				bn = get_rs_basename(rs2->name);
+				if (!strcmp(bn, rs->name))
+					goto out_used;
+			}
+		}
+		else {
+			bn = get_rs_basename(rs1->name);
+			if (!strcmp(bn, rs->name))
+				goto out_used;
+		}
+	}
+
+	return 1;
+
+      out_used:
+	log_dbg(lc, "%s is being used", bn);
+	return 0;
+}
+
+static int
+check_capability(struct raid_set *rs)
+{
+	uint8_t raid_level = _get_raid_level(rs->type);
+
+	if (SETS(rs)) {
+		struct raid_set *rs1 =
+			list_entry(rs->sets.next, struct raid_set, list);
+
+		if (raid_level == ISW_T_RAID0 && rs1->type == t_raid1)
+			raid_level = ISW_T_RAID10;
+		else
+			raid_level = ISW_T_UNDEF;
+	}
+
+	return raid_level;
+}
+
+static int
+match_hd_array(struct raid_set *rs, struct isw *isw)
+{
+	int broken = 0, found = 0; // , i = isw->num_disks;
+//	struct isw_disk *disk = isw->disk;
+	struct raid_dev *rd;
+
+/* FIXME: all disks broken in case of no SCSI IDs
+	while (i--) {
+		if (disk[i].scsiId == UNKNOWN_SCSI_ID)
+			broken++;
+	}
+*/
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (_get_disk(isw, rd->di))
+			found++;
+	}
+
+	return isw->num_disks == broken + found && found == rs->total_devs;
+}
+
+static int
+is_hd_array_available(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_dev *rd1, *rd2;
+
+	list_for_each_entry(rd1, &rs->devs, devs) {
+		list_for_each_entry(rd2, LC_RD(lc), list) {
+			if (!strcmp(rd1->di->path, rd2->di->path) &&
+			    rd1->fmt == rd2->fmt)
+				return match_hd_array(rs, META(rd2, isw));
+		}
+	}
+
+	return 0;
+}
+
+#define MIN_VOLUME_SIZE 204800
+static void
+enforce_size_limit(struct raid_set *rs)
+{
+	/* the min size is 100M bytes */
+	if (rs->size && rs->size < MIN_VOLUME_SIZE)
+		rs->size = MIN_VOLUME_SIZE;
+}
+
+static int
+is_first_volume(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_dev *rd1, *rd2;
+
+	list_for_each_entry(rd1, &rs->devs, devs) {
+		list_for_each_entry(rd2, LC_RD(lc), list) {
+			if (!strcmp(rd1->di->path, rd2->di->path) &&
+			    rd1->fmt == rd2->fmt) {
+				/* No choice for the 2nd volume. */
+				rs->size = 0;
+				return 0;
+			}
+		}
+	}
+
+	enforce_size_limit(rs);
+	return 1;
+}
+
+/* Retrieve and make up SCSI ID. */
+static unsigned
+get_scsiId(struct lib_context *lc, char *path)
+{
+	int fd;
+	Sg_scsi_id sg_id;
+
+	memset(&sg_id, 0, sizeof(sg_id));
+
+	if ((fd = open(path, O_RDONLY)) == -1)
+		return UNKNOWN_SCSI_ID;
+
+	if (!get_scsi_id(lc, fd, &sg_id)) {
+		close(fd);
+		return UNKNOWN_SCSI_ID;
+	}
+
+	close(fd);
+	return (sg_id.host_no << 16) | (sg_id.scsi_id << 8) | sg_id.lun;
+}
+
+static int
+isw_config_disks(struct lib_context *lc, struct isw_disk *disk,
+		 struct raid_set *rs)
+{
+	int i = 0;
+	struct raid_dev *rd;
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		strncpy((char *) disk[i].serial, rd->di->serial,
+			MAX_RAID_SERIAL_LEN);
+		disk[i].totalBlocks = rd->di->sectors;
+
+		/* FIXME: when scsiID == UNKNOWN_SCSI_ID */
+		disk[i].scsiId = get_scsiId(lc, rd->di->path);
+		disk[i++].status = CLAIMED_DISK |
+			CONFIG_ON_DISK |
+			DETECTED_DISK | USABLE_DISK |
+			((rs->type == ISW_T_SPARE) ?
+			 SPARE_DISK : CONFIGURED_DISK);
+	}
+
+	return i;
+}
+
+static void
+isw_config_vol(struct raid_set *rs, struct isw_vol *vol)
+{
+	if (rs->status == s_init) {
+		vol->migr_state = 0;
+		vol->migr_type = 0;
+	}
+}
+
+static uint32_t
+_get_stride_size(struct raid_set *rs)
+{
+	/* In blocks (512-bytes). */
+	/* First member is default stride size. */
+	static const uint32_t s_raid0[] = { 256, 8, 16, 32, 64, 128, 256, 0 };
+	static const uint32_t s_raid1[] = { 128, 128, 0 };
+	static const uint32_t s_raid10[] = { 128, 8, 16, 32, 64, 128, 256, 0 };
+	static const uint32_t s_raid5[] = { 128, 32, 64, 128, 256, 0 };
+	struct strip_options {
+		const uint8_t level;
+		const uint32_t *options;
+	};
+	static struct strip_options strip_options[] = {
+		{ISW_T_RAID0, s_raid0},
+		{ISW_T_RAID1, s_raid1},
+		{ISW_T_RAID10, s_raid10},
+		{ISW_T_RAID5, s_raid5},
+	};
+	struct strip_options *so = ARRAY_END(strip_options);
+
+	while (so-- > strip_options) {
+		if (rs->type == so->level) {
+			int i;
+
+			if (rs->stride) {
+				i = 1;
+				while (so->options[i + 1] &&
+				       rs->stride > so->options[i])
+					i++;
+			}
+			else
+				i = 0;
+
+			return so->options[i];
+		}
+	}
+
+	return 0;
+}
+
+static void
+_find_factors(struct raid_set *rs, uint8_t * div, uint8_t * sub)
+{
+	struct factors {
+		const uint8_t level;
+		const uint8_t div, sub;
+	};
+	static struct factors factors[] = {
+		{ISW_T_RAID0, 1, 0},
+		{ISW_T_RAID1, 2, 0},
+		{ISW_T_RAID10, 2, 0},
+		{ISW_T_RAID5, 1, 1},
+	};
+	struct factors *f = ARRAY_END(factors);
+
+	while (f-- > factors) {
+		if (rs->type == f->level) {
+			*div = f->div;
+			*sub = f->sub;
+			return;
+		}
+	}
+
+	*div = 1;
+	*sub = 0;
+}
+
+/* Configure an isw map. */
+static void
+isw_config_map(struct raid_set *rs, struct isw_map *map,
+	       uint64_t size, uint32_t first)
+{
+	int i;
+	uint8_t div, sub;
+
+	_find_factors(rs, &div, &sub);
+	map->pba_of_lba0 = first;
+	map->blocks_per_strip = _get_stride_size(rs);
+	map->num_data_stripes = size / (map->blocks_per_strip) /
+		((rs->total_devs - sub) / div);
+	map->blocks_per_member = map->blocks_per_strip * map->num_data_stripes +
+		RAID_DS_JOURNAL;
+
+	map->map_state = ISW_T_STATE_NORMAL;
+	map->raid_level = rs->type == ISW_T_RAID10 ? ISW_T_RAID1 : rs->type;
+	map->num_members = rs->found_devs;
+	map->num_domains = (rs->type == ISW_T_RAID1 ||
+			    rs->type == ISW_T_RAID10) ? 2 : 1;
+
+/* FIXME */
+	for (i = 0; i < map->num_members; i++)
+		map->disk_ord_tbl[i] = i;
+}
+
+/* Calculate the (new) array size. */
+static uint64_t
+_cal_array_size(struct isw_disk *disk, struct raid_set *rs, struct isw_dev *dev)
+{
+	int n = 0;
+	uint8_t div, sub;
+	uint64_t min_ds = ~0, max_ds;
+	struct raid_dev *rd;
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (min_ds > rd->di->sectors)
+			min_ds = rd->di->sectors;
+		n++;
+	}
+
+	if (min_ds < DISK_RESERVED_BLOCKS)
+		return 0;
+
+	min_ds -= DISK_RESERVED_BLOCKS;
+
+	/* blank disks */
+	if (dev) {
+		/* One volume existed and started from the beginning */
+		if (!dev->vol.map.pba_of_lba0) {
+			max_ds = dev->vol.map.blocks_per_member +
+				DISK_RESERVED_BLOCKS;
+
+			if (min_ds > max_ds)
+				min_ds -= max_ds;
+			else
+				return 1;
+			/* An existing volume at the bottom */
+		}
+		else if (dev->vol.map.pba_of_lba0 >=
+			 RAID_VOLUME_RESERVED_BLOCKS)
+			min_ds = dev->vol.map.pba_of_lba0 -
+				RAID_VOLUME_RESERVED_BLOCKS;
+		else
+			return 1;
+	}
+	else {
+		if (min_ds > DISK_RESERVED_BLOCKS)
+			min_ds -= DISK_RESERVED_BLOCKS;
+		else
+			return 1;
+	}
+
+	_find_factors(rs, &div, &sub);
+	max_ds = min_ds * (n - sub) / div;
+	return max_ds;
+}
+
+#define METADATA_BLOCKS 2
+static int
+isw_config_dev(struct lib_context *lc, struct raid_set *rs,
+	       struct isw_dev *dev1, struct isw_dev *dev2, uint64_t max_size)
+{
+	uint64_t tmp = rs->size ? rs->size : max_size;
+
+	strncpy((char *) dev2->volume, rs->name, MAX_RAID_SERIAL_LEN);
+	dev2->SizeLow = (uint32_t) tmp;
+	dev2->SizeHigh = (uint32_t) (tmp >> 32);
+	/* FIXME: isi this status ok, Radoslaw ? */
+	dev2->status = ISW_DEV_READ_COALESCING | ISW_DEV_WRITE_COALESCING;
+	isw_config_vol(rs, &dev2->vol);
+
+	if (!dev1) {
+		isw_config_map(rs, &dev2->vol.map, tmp, 0);
+		return 1;
+	}
+
+	if (!dev1->vol.map.pba_of_lba0)	/* Start at the begginning. */
+		isw_config_map(rs, &dev2->vol.map, tmp,
+			       dev1->vol.map.blocks_per_member +
+			       MIGR_OPT_SPACE);
+	else {
+		isw_config_map(rs, &dev2->vol.map, tmp, 0);
+
+		if (dev2->vol.map.blocks_per_member + MIGR_OPT_SPACE >
+		    dev1->vol.map.pba_of_lba0)
+			LOG_ERR(lc, 0, "%s: not enough space to create "
+				"requested volume", handler);
+
+	}
+
+	return 1;
+}
+
+static void
+display_new_volume(struct raid_set *rs, struct isw *isw, struct isw_dev *dev)
+{
+	enum type rt;
+	const char *type_name = NULL;
+	struct raid_dev *r;
+
+	if (rs->type == ISW_T_SPARE) {	/* Case if spare disk. */
+		printf("\n\n     Create a SPARE DISK with ISW metadata "
+		       "format     \n\nDISK:     ");
+	}
+	else {
+		rt = type(dev);
+		switch (rt) {
+		case t_raid0:
+			type_name = "RAID0";
+			break;
+
+		case t_raid1:
+			type_name = dev->vol.map.num_members ==
+				min_num_disks(ISW_T_RAID10) ?
+				"RAID01 (isw RAID10)" : "RAID1";
+			break;
+
+		case t_raid5_la:
+			type_name = "RAID5";
+			break;
+
+		default:
+			return;
+		}
+
+		printf("\n\n     Create a RAID set with ISW "
+		       "metadata format     \n\n");
+		printf("RAID name:      %s\n", dev->volume);
+		printf("RAID type:      %s\n", type_name);
+		printf("RAID size:      %lluG",
+		       ((unsigned long long) dev->SizeLow +
+			((unsigned long long) dev->SizeHigh << 32)) / GB_DIV);
+		printf("(%llublocks)\n",
+		       ((unsigned long long) dev->SizeLow +
+			((unsigned long long) dev->SizeHigh << 32)));
+
+		if (rt != t_raid1)
+			printf("RAID strip:     %uk(%ublocks)\n",
+			       dev->vol.map.blocks_per_strip / 2,
+			       dev->vol.map.blocks_per_strip);
+
+		printf("DISKS:     ");
+	}
+
+	list_for_each_entry(r, &rs->devs, devs) {
+		if (_get_disk(isw, r->di))
+			printf("%s%s ", r->di->path,
+			       rs->type == ISW_T_SPARE ? "" : ",");
+	}
+
+	printf("\n\n\n");
+}
+
+static struct isw *
+_isw_create_first_volume(struct lib_context *lc, struct raid_set *rs)
+{
+
+	uint16_t isw_size;
+	uint64_t total_size;
+	struct isw *isw;
+	struct isw_dev *dev = NULL;
+	struct isw_disk *disk = NULL;
+
+	total_size = _cal_array_size(disk, rs, NULL);
+	if (rs->size > total_size)
+		LOG_ERR(lc, 0,
+			"%s: the size exceeds the max %lluG(%llublocks)",
+			handler, total_size / GB_DIV, total_size);
+
+	/* allocate min 2 sectors space for isw metadata. */
+	isw_size = METADATA_BLOCKS * ISW_DISK_BLOCK_SIZE;
+	if (!(isw = alloc_private(lc, handler, isw_size)))
+		LOG_ERR(lc, 0, "%s: failed to allocate memory", handler);
+
+	disk = isw->disk;
+	isw->num_disks = isw_config_disks(lc, disk, rs);
+	isw_size = sizeof(*isw) + sizeof(*disk) * (isw->num_disks - 1);
+
+	if (rs->type != ISW_T_SPARE) {
+		dev = (struct isw_dev *) (disk + isw->num_disks);
+		if (!isw_config_dev(lc, rs, NULL, dev, total_size)) {
+			dbg_free(isw);
+			return NULL;
+		}
+
+		isw_size += sizeof(*dev) + sizeof(dev->vol.map.disk_ord_tbl) *
+			(isw->num_disks - 1);
+	}
+
+	display_new_volume(rs, isw, dev);
+
+	strncpy((char *) isw->sig, MPB_SIGNATURE, MPB_SIGNATURE_SIZE);
+	strncpy((char *) isw->sig + MPB_SIGNATURE_SIZE,
+		MPB_VERSION_RAID2, MPB_VERSION_RAID2_SIZE);
+	isw->mpb_size = isw_size;
+	isw->generation_num = 0;
+	isw->num_raid_devs = (rs->type == ISW_T_SPARE) ? 0 : 1;
+	isw->family_num = isw->orig_family_num = _checksum(isw) + time(NULL);
+	isw->check_sum = 0;
+	isw->check_sum = _checksum(isw);
+	return isw;
+}
+
+static struct raid_set *
+_find_group(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_set *r;
+	struct raid_dev *rd1, *rd2;
+	int match = 0;
+
+	list_for_each_entry(r, LC_RS(lc), list) {
+		if (r->type != t_group)
+			continue;
+
+		list_for_each_entry(rd2, &rs->devs, devs) {
+			list_for_each_entry(rd1, &r->devs, devs) {
+				if (!strcmp(rd1->di->path, rd2->di->path)) {
+					match++;
+					break;
+				}
+			}
+		}
+
+		if (match) {
+			if (match == rs->found_devs)
+				return r;
+
+			LOG_ERR(lc, NULL,
+				"%s: mismatch in the number of drives "
+				"found", handler);
+		}
+	}
+
+	return NULL;
+}
+
+static struct isw *
+_isw_create_second_volume(struct lib_context *lc, struct raid_set *rs)
+{
+	uint16_t isw_size;
+	uint64_t total_size;
+	struct raid_set *rs_group;
+	struct raid_dev *rd;
+	struct isw *isw, *isw_v1;
+	struct isw_dev *dev1, *dev2;
+
+	if (!(rs_group = _find_group(lc, rs)))
+		return NULL;
+
+	rd = list_entry(rs_group->devs.next, struct raid_dev, devs);
+	/* Note: size of a volume data structure is smaller than a sector. */
+
+	/* FIXME: >=2 ? */
+	isw_v1 = rd->meta_areas->area;
+	if (isw_v1->num_raid_devs >= 2)
+		LOG_ERR(lc, NULL, "%s: only two volumes allowed per array",
+			handler);
+
+	if (!(dev1 = raiddev(isw_v1, 0)))
+		LOG_ERR(lc, NULL, "%s: failed to get the first volume info",
+			handler);
+
+	total_size = _cal_array_size(isw_v1->disk, rs, dev1);
+	if (total_size < MIN_VOLUME_SIZE)
+		LOG_ERR(lc, NULL, "%s: either not enough disk space or the "
+			"requested volume size is too small", handler);
+
+	isw_size = rd->meta_areas->size + ISW_DISK_BLOCK_SIZE;
+	if (!(isw = alloc_private(lc, handler, isw_size)))
+		LOG_ERR(lc, NULL, "%s: failed to allocate memory", handler);
+
+	memcpy(isw, isw_v1, isw_size - ISW_DISK_BLOCK_SIZE);
+	isw_size = isw_v1->mpb_size;
+	dev2 = raiddev(isw, 1);
+	if (!isw_config_dev(lc, rs, dev1, dev2, total_size)) {
+		dbg_free(isw);
+		return NULL;
+	}
+
+	isw_size += sizeof(*dev2) + sizeof(dev2->vol.map.disk_ord_tbl) *
+		(isw->num_disks - 1);
+
+	display_new_volume(rs, isw, dev2);
+	isw->mpb_size = isw_size;
+	isw->generation_num++;
+	isw->num_raid_devs++;
+	isw->check_sum = 0;
+	isw->check_sum = _checksum(isw);
+	return isw;
+}
+
+static struct isw_dev *
+get_raiddev(struct isw *isw, char *name)
+{
+	struct isw_dev *dev;
+	int i;
+
+	for (i = 0; i < isw->num_raid_devs; i++) {
+		dev = raiddev(isw, i);
+		if (!strcmp((const char *) dev->volume, (const char *) name))
+			return dev;
+	}
+
+	return NULL;
+}
+
+/*
+ * Update the metadata attached to each raid
+ * device and the name of the RAID set.
+ */
+static int
+update_raidset(struct lib_context *lc, struct raid_set *rs, struct isw *isw)
+{
+	int blocks = div_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE);
+	size_t size = blocks * ISW_DISK_BLOCK_SIZE;
+	struct raid_dev *rd;
+	struct isw_dev *dev;
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (rd->meta_areas) {
+			if (rd->meta_areas->area)
+				dbg_free(rd->meta_areas->area);
+
+			dbg_free(rd->meta_areas);
+		}
+
+		if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+			return 0;
+
+		if (!(rd->meta_areas->area = alloc_private(lc, handler, size)))
+			return 0;
+
+		set_metadata_sizoff(rd, size);
+		memcpy(rd->meta_areas->area, isw, size);
+		rd->type = t_group;
+
+		dev = NULL;
+		if (rs->type != ISW_T_SPARE &&
+		    !(dev = get_raiddev(isw, rs->name)))
+			return 0;
+
+		if (!(rd->name = name(lc, rd, dev, N_NUMBER)))
+			return 0;
+	}
+
+	if (rs->type != ISW_T_SPARE) {
+		if (!(dev = get_raiddev(isw, rs->name)))
+			return 0;
+
+		dbg_free(rs->name);
+		rd = list_entry(rs->devs.next, struct raid_dev, devs);
+		if (!(rs->name = name(lc, rd, dev, N_VOLUME)))
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Create a RAID set (i.e. an isw volume). */
+static int
+_isw_create_raidset(struct lib_context *lc, struct raid_set *rs)
+{
+	uint16_t min, max = 0;
+	struct isw *isw;
+
+	/* The type is changed into the ISW defination */
+	if ((rs->type = check_capability(rs)) == ISW_T_UNDEF)
+		LOG_ERR(lc, 0, "%s: unsupported raid level", handler);
+
+	if (rs->type != ISW_T_SPARE && rs->name) {
+		if (!is_name_unique(lc, rs))
+			LOG_ERR(lc, 0, "%s: the name %s is already in use, "
+				"please try another name", handler, rs->name);
+	}
+
+	if ((min = min_num_disks(rs->type)) > rs->found_devs ||
+	    (max = max_num_disks(rs->type)) < rs->found_devs)
+		LOG_ERR(lc, 0, "%s: the RAID set cannot have %s "
+			"than %d hard drives",
+			handler, max ? "more" : "less", max ? max : min);
+
+	/*
+	 * The size of the RAID set is set to 0 if there is one volume
+	 * detected. Also, the mininum size is enforced to 0.1G.
+	 */
+	if (is_first_volume(lc, rs))
+		isw = _isw_create_first_volume(lc, rs);
+	else if (rs->type == ISW_T_SPARE)
+		LOG_ERR(lc, 0, "%s: SPARE disk must use all space "
+			"on the disk", handler);
+	else if (is_hd_array_available(lc, rs))
+		isw = _isw_create_second_volume(lc, rs);
+	else
+		LOG_ERR(lc, 0,
+			"%s: second volume must use all drives on the "
+			"existing array", handler);
+
+	/* isw spare disk is created without own name. */
+	if (isw) {
+		static const char *fmts[] = {
+			"About to create a RAID set with the above settings. "
+				"Name <%s> will lost. Continue",
+			"About to create a RAID set with the above settings. "
+				"Continue",
+		};
+		const char *fmt = fmts[!(rs->type == ISW_T_SPARE && rs->name)];
+
+		if (yes_no_prompt(lc, fmt, rs->name)) {
+			if (!update_raidset(lc, rs, isw)) {
+				dbg_free(isw);
+				LOG_ERR(lc, 0, "%s: failed to update metadata "
+					"on the raid_dev data structure ",
+					handler);
+			}
+		}
+		else {
+			dbg_free(isw);
+			return 0;
+		}
+
+		dbg_free(isw);
+		rs->status = s_config;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int update_metadata(struct lib_context *lc, struct raid_set *rs);
+static int
+isw_create(struct lib_context *lc, struct raid_set *rs)
+{
+
+	int ret = 0;
+
+	if (rs->status == s_init) {
+		enum type raid_type;
+
+		/*
+		 * The field size and type get changed
+		 * later to faciliate processing.
+		 */
+		raid_type = rs->type;
+		ret = _isw_create_raidset(lc, rs);
+		rs->type = raid_type;
+	}
+	else if (rs->status == s_nosync)
+		ret = update_metadata(lc, rs);
+
+	return ret;
+}
+
+static int
+isw_check(struct lib_context *lc, struct raid_set *rs)
+{
+	if (rs->status == s_init)
+		return 1;
+	else
+		return T_GROUP(rs) ? _isw_check(lc, rs) : 0;
+}
+
+/*
+ * IO error event handler.
+ */
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct isw *isw = META(rd, isw);
+	struct isw_disk *disk;
+
+	if (!(disk = get_disk(lc, rd->di, isw)))
+		LOG_ERR(lc, 0, "%s: disk", handler);
+
+	/* Avoid write trashing. */
+	if (S_BROKEN(status(lc, rd)))
+		return 0;
+
+	disk->status &= ~USABLE_DISK;
+	disk->status |= FAILED_DISK;
+
+	return 1;
+}
+
+static struct event_handlers isw_event_handlers = {
+	.io = event_io,
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
+};
+
+static void
+_isw_log(struct lib_context *lc, struct isw *isw)
+{
+	unsigned d, i, m;
+	struct isw_disk *disk;
+	struct isw_dev *dev;
+
+	P("sig: \"%*s\"", isw, isw->sig, MAX_SIGNATURE_LENGTH, isw->sig);
+	DP("check_sum: %u", isw, isw->check_sum);
+	DP("mpb_size: %u", isw, isw->mpb_size);
+	DP("family_num: %u", isw, isw->family_num);
+	DP("generation_num: %u", isw, isw->generation_num);
+	DP("error_log_size: %u", isw, isw->error_log_size);
+	DP("attributes: %u", isw, isw->attributes);
+	DP("num_disks: %u", isw, isw->num_disks);
+	DP("num_raid_devs: %u", isw, isw->num_raid_devs);
+	DP("error_log_pos: %u", isw, isw->error_log_pos);
+	DP("cache_size: %u", isw, isw->cache_size);
+	DP("orig_family_num: %u", isw, isw->orig_family_num);
+
+	for (i = 0; i < ISW_FILLERS; i++) {
+		if (isw->filler[i])
+			P("filler[%i]: %u", isw, isw->filler[i], i,
+			  isw->filler[i]);
+	}
+
+	/* Disk table. */
+	for (d = 0, disk = isw->disk; d < isw->num_disks; d++, disk++) {
+		if (!disk->totalBlocks)
+			continue;
+
+		P("disk[%u].serial: \"%*s\"", isw,
+		  disk->serial, d, MAX_RAID_SERIAL_LEN, disk->serial);
+		P("disk[%u].totalBlocks: %u", isw,
+		  disk->totalBlocks, d, disk->totalBlocks);
+		P("disk[%u].scsiId: 0x%x", isw, disk->scsiId, d, disk->scsiId);
+		P("disk[%u].status: 0x%x", isw, disk->status, d, disk->status);
+		P("disk[%u].owner_cfg_num: 0x%x", isw, disk->owner_cfg_num,
+		  d, disk->owner_cfg_num);
+		for (i = 0; i < ISW_DISK_FILLERS; i++) {
+			if (disk->filler[i])
+				P("disk[%u].filler[%u]: %u", isw,
+				  disk->filler[i], d, i, disk->filler[i]);
+		}
+	}
+
+	/* RAID device/volume table. */
+	for (d = 0; d < isw->num_raid_devs; d++) {
+		dev = raiddev(isw, d);
+
+		/* RAID device */
+		P("isw_dev[%u].volume: \"%*s\"", isw,
+		  dev->volume, d, MAX_RAID_SERIAL_LEN, dev->volume);
+		P("isw_dev[%u].SizeHigh: %u", isw, dev->SizeHigh, d,
+		  dev->SizeHigh);
+		P("isw_dev[%u].SizeLow: %u", isw, dev->SizeLow, d,
+		  dev->SizeLow);
+		P("isw_dev[%u].status: 0x%x", isw, dev->status, d, dev->status);
+		P("isw_dev[%u].reserved_blocks: %u", isw,
+		  dev->reserved_blocks, d, dev->reserved_blocks);
+		P("isw_dev[%u].migr_priority: %u", isw, dev->migr_priority,
+		  d, dev->migr_priority);
+		P("isw_dev[%u].num_sub_vol: %u", isw, dev->num_sub_vol, d,
+		  dev->num_sub_vol);
+		P("isw_dev[%u].tid: %u", isw, dev->tid, d, dev->tid);
+		P("isw_dev[%u].cng_master_disk: %u", isw,
+		  dev->cng_master_disk, d, dev->cng_master_disk);
+		P("isw_dev[%u].cache_policy: %u", isw,
+		  dev->cache_policy, d, dev->cache_policy);
+		P("isw_dev[%u].cng_state: %u", isw, dev->cng_state, d,
+		  dev->cng_state);
+		P("isw_dev[%u].cng_sub_state: %u", isw, dev->cng_sub_state,
+		  d, dev->cng_sub_state);
+
+		for (i = 0; i < ISW_DEV_FILLERS; i++) {
+			if (dev->filler[i])
+				P("isw_dev[%u].filler[%u]: %u", isw,
+				  dev->filler[i], d, i, dev->filler[i]);
+		}
+
+		/* RAID volume */
+		P("isw_dev[%u].vol.curr_migr_unit: %u", isw,
+		  dev->vol.curr_migr_unit, d, dev->vol.curr_migr_unit);
+		P("isw_dev[%u].vol.check_point_id: %u", isw,
+		  dev->vol.check_point_id, d, dev->vol.check_point_id);
+
+		P("isw_dev[%u].vol.migr_state: %u", isw,
+		  dev->vol.migr_state, d, dev->vol.migr_state);
+		P("isw_dev[%u].vol.migr_type: %u", isw,
+		  dev->vol.migr_type, d, dev->vol.migr_type);
+		P("isw_dev[%u].vol.dirty: %u", isw, dev->vol.dirty, d,
+		  dev->vol.dirty);
+		P("isw_dev[%u].vol.fs_state: %u", isw, dev->vol.fs_state,
+		  d, dev->vol.fs_state);
+		P("isw_dev[%u].vol.verify_errors: %u", isw,
+		  dev->vol.verify_errors, d, dev->vol.verify_errors);
+		P("isw_dev[%u].vol.verify_bad_blocks: %u", isw,
+		  dev->vol.verify_bad_blocks, d, dev->vol.verify_bad_blocks);
+
+		for (i = 0; i < ISW_RAID_VOL_FILLERS; i++) {
+			if (dev->vol.filler[i])
+				P("isw_dev[%u].vol.filler[%u]: %u", isw,
+				  dev->vol.filler[i], d, i, dev->vol.filler[i]);
+		}
+
+
+		struct isw_map *map = &dev->vol.map;
+		for (m = 0; m < 2; m++) {
+			/* RAID map */
+
+			P("isw_dev[%u].vol.map[%d].pba_of_lba0: %u", isw,
+			  map->pba_of_lba0, d, m, map->pba_of_lba0);
+			P("isw_dev[%u].vol.map[%d].blocks_per_member: %u",
+			  isw, map->blocks_per_member, d, m,
+			  map->blocks_per_member);
+			P("isw_dev[%u].vol.map[%d].num_data_stripes: %u",
+			  isw, map->num_data_stripes, d, m,
+			  map->num_data_stripes);
+			P("isw_dev[%u].vol.map[%d].blocks_per_strip: %u",
+			  isw, map->blocks_per_strip, d, m,
+			  map->blocks_per_strip);
+			P("isw_dev[%u].vol.map[%d].map_state: %u", isw,
+			  map->map_state, d, m, map->map_state);
+			P("isw_dev[%u].vol.map[%d].raid_level: %u", isw,
+			  map->raid_level, d, m, map->raid_level);
+			P("isw_dev[%u].vol.map[%d].num_members: %u", isw,
+			  map->num_members, d, m, map->num_members);
+			P("isw_dev[%u].vol.map[%d].num_domains: %u", isw,
+			  map->num_domains, d, m, map->num_domains);
+			P("isw_dev[%u].vol.map[%d].failed_disk_num: %u",
+			  isw, map->failed_disk_num, d, m,
+			  map->failed_disk_num);
+			P("isw_dev[%u].vol.map[%d].ddf: %u", isw, map->ddf,
+			  d, m, map->ddf);
+
+			for (i = 0; i < 7; i++) {
+				if (map->filler[i])
+					P("isw_dev[%u].vol.map[%d].filler[%u]: %u", isw, map->filler[i], d, m, i, map->filler[i]);
+			}
+
+			for (i = 0; i < map->num_members; i++) {
+				P("isw_dev[%u].vol.map[%d].disk_ord_tbl[%u]: 0x%x", isw, map->disk_ord_tbl[i], d, m, i, map->disk_ord_tbl[i]);
+			}
+
+			if (!dev->vol.migr_state)
+				break;
+
+			map = (struct isw_map *) ((char *) map +
+						  (map->num_members - 1) *
+						  sizeof(map->disk_ord_tbl) +
+						  sizeof(struct isw_map));
+		}
+	}
+}
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about an ISW RAID device.
+ */
+static void
+isw_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct isw *isw = META(rd, isw);
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	_isw_log(lc, isw);
+}
+#endif
+
+static void
+isw_erase_metadata(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_dev *rd;
+
+	list_for_each_entry(rd, &rs->devs, devs)
+		isw_write(lc, rd, 1);
+}
+
+/*
+ * Write an Intel Software RAID device.
+ */
+static int
+isw_write_all(struct lib_context *lc, struct raid_set *rs, struct isw *isw)
+{
+	struct raid_dev *rd, *r;
+	struct meta_areas ma = {
+		.size = isw_size(isw),
+		.area = isw,
+	};
+
+	if (!(rd = alloc_raid_dev(lc, handler)))
+		return 0;
+
+	rd->meta_areas = &ma;
+	rd->type = t_raid0;	//dummy code
+	rd->areas = 1;
+
+	list_for_each_entry(r, &rs->devs, devs) {
+		rd->di = r->di;
+		set_metadata_sizoff(rd, ma.size);
+		rd->fmt = r->fmt;
+		isw_write(lc, rd, 0);
+	}
+
+	dbg_free(rd);
+	return 1;
+}
+
+/* Remove an isw device. */
+static void
+isw_remove_dev(struct lib_context *lc, struct raid_set *rs,
+	       struct isw *isw, struct isw_dev *dev)
+{
+	struct isw *isw_tmp;
+	size_t size, dev_size;
+
+	size = div_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE);
+	if (!(isw_tmp = alloc_private(lc, handler,
+				      (size + 1) * ISW_DISK_BLOCK_SIZE)))
+		log_err(lc, "%s: failed to allocate memory", handler);
+
+	size = sizeof(*isw) + sizeof(struct isw_disk) * (isw->num_disks - 1);
+	memcpy(isw_tmp, isw, size);
+
+	dev_size = sizeof(*dev) +
+		sizeof(uint32_t) * (dev->vol.map.num_members - 1);
+	memcpy((char *) isw_tmp + size, dev, dev_size);
+
+	isw_tmp->mpb_size = size + dev_size;
+	isw_tmp->num_raid_devs--;
+	isw_tmp->check_sum = _checksum(isw_tmp);
+	isw_write_all(lc, rs, isw_tmp);
+	dbg_free(isw_tmp);
+}
+
+static int
+_isw_delete_all(struct lib_context *lc, struct raid_set *rs_group)
+{
+	struct raid_set *rs;
+	struct raid_dev *rd;
+	char *name;
+	struct isw *isw;
+	struct isw_dev *dev1, *dev2;
+	int num = 0;
+
+	if (!(rs = list_entry(rs_group->sets.next, struct raid_set, list)))
+		  LOG_ERR(lc, 0, "%s: failed to find a RAID set in a group",
+			  handler);
+
+	if (!(rd = list_entry(rs_group->devs.next, struct raid_dev, devs)))
+		  LOG_ERR(lc, 0,
+			  "%s: failed to find a raid device in RS %s",
+			  handler, rs_group->name);
+
+	if (!(isw = (struct isw *) rd->meta_areas->area))
+		LOG_ERR(lc, 0, "%s: failed to locate metadata on drive %s",
+			handler, rd->di->path);
+
+	if (isw->num_raid_devs != 2)
+		LOG_ERR(lc, 0, "%s: the number of raid volumes is not 2",
+			handler);
+
+	if ((!(dev1 = raiddev(isw, 0))) || (!(dev2 = raiddev(isw, 1))))
+		LOG_ERR(lc, 0, "%s: failed to get two volume info", handler);
+
+	list_for_each_entry(rs, &rs_group->sets, list) {
+		if (!(name = get_rs_basename(rs->name)))
+			LOG_ERR(lc, 0,
+				"%s: could not find the volume to be "
+				"deleted", handler);
+
+		if (!strcmp((const char *) dev1->volume, (const char *) name))
+			num++;
+
+		if (!strcmp((const char *) dev2->volume, (const char *) name))
+			num++;
+	}
+	if (num != 2)
+		LOG_ERR(lc, 0,
+			"%s: failed to find all of the RAID sets to be "
+			"deleted", handler);
+
+	isw_erase_metadata(lc, rs_group);
+	return 1;
+}
+
+/* Delete metadata according to the RAID set. */
+static int
+isw_delete(struct lib_context *lc, struct raid_set *rs_group)
+{
+	struct raid_set *rs;
+	struct raid_dev *rd;
+	char *name;
+	struct isw *isw;
+	struct isw_dev *dev1, *dev2;
+	int num = 0;
+
+	if (rs_group->type != t_group)
+		LOG_ERR(lc, 0, "%s: RAID set is not a t-group type", handler);
+
+	list_for_each_entry(rs, &rs_group->sets, list)
+		num++;
+
+	if (num > 1)
+		return _isw_delete_all(lc, rs_group);
+
+	if (!(rs = list_entry(rs_group->sets.next, struct raid_set, list)))
+		  LOG_ERR(lc, 0,
+			  "%s: failed to find a RAID set in the group",
+			  handler);
+
+	if (!(name = get_rs_basename(rs->name)))
+		LOG_ERR(lc, 0,
+			"%s: failed to find the volume to be deleted", handler);
+
+	if (!(rd = list_entry(rs_group->devs.next, struct raid_dev, devs)))
+		  LOG_ERR(lc, 0,
+			  "%s: failed to find a raid device in RS %s",
+			  handler, rs_group->name);
+
+	if (!(isw = (struct isw *) rd->meta_areas->area))
+		LOG_ERR(lc, 0,
+			"%s: failed to locate metadata on device %s",
+			handler, rd->di->path);
+
+	/* case if metadata on spare disk is delete */
+	if (!isw->num_raid_devs && isw->num_disks == 1 &&
+	    (isw->disk[0].status & SPARE_DISK)) {
+		isw_erase_metadata(lc, rs_group);
+		return 1;
+	}
+
+	if (!(dev1 = raiddev(isw, 0)))
+		LOG_ERR(lc, 0,
+			"%s: failed to find a RAID set in the group", handler);
+
+	if (isw->num_raid_devs == 1) {
+		if (!strcmp((const char *) dev1->volume, (const char *) name)) {
+			isw_erase_metadata(lc, rs_group);
+			return 1;
+		}
+		else
+			LOG_ERR(lc, 0, "%s: failed to find the volume %s",
+				handler, name);
+	}
+
+	if (!(dev2 = raiddev(isw, 1)))
+		LOG_ERR(lc, 0,
+			"%s: failed to find a RAID set in the group", handler);
+
+	if (!strcmp((const char *) dev1->volume, (const char *) name))
+		isw_remove_dev(lc, rs_group, isw, dev2);
+	else if (!strcmp((const char *) dev2->volume, (const char *) name))
+		isw_remove_dev(lc, rs_group, isw, dev1);
+	else
+		return 0;
+
+	return 1;
+}
+
+
+static struct dmraid_format isw_format = {
+	.name = HANDLER,
+	.descr = "Intel Software RAID",
+	.caps = "0,1,01",
+	.format = FMT_RAID,
+	.read = isw_read,
+	.write = isw_write,
+	.create = isw_create,
+	.delete = isw_delete,
+	.group = isw_group,
+	.check = isw_check,
+	.metadata_handler = isw_metadata_handler,
+	.events = &isw_event_handlers,
+	.scope = t_scope_global /* | t_scope_local */ ,
+#ifdef DMRAID_NATIVE_LOG
+	.log = isw_log,
+#endif
+};
+
+static struct raid_set *
+change_set_name(struct lib_context *lc, struct list_head *list,
+		char *o_name, char *n_name)
+{
+	struct raid_set *r, *ret = NULL;
+
+	list_for_each_entry(r, list, list) {
+		if (!strcmp(r->name, o_name)) {
+			ret = r;
+			r->name = n_name;
+			break;
+		}
+	}
+
+	list_for_each_entry(r, list, list) {
+		if ((ret = change_set_name(lc, &r->sets, o_name, n_name)))
+			r->name = n_name;
+	}
+
+	return ret;
+}
+
+
+/*
+ * Create part of metadata (struct isw_dev) in new_isw based on
+ * certain parameters.
+ *
+ * Note that new_isw must have its data preceedning isw_dev field already set.
+ * The function returns size of created isw_dev (including map(s)).
+ */
+static unsigned
+update_metadata_isw_dev(struct isw *new_isw,
+			int failed_disk_idx,
+			struct isw *old_isw,
+			int isw_dev_idx, unsigned isw_dev_offs)
+{
+	int i, map_size;
+	struct isw_dev *new_dev, *old_dev = raiddev(old_isw, isw_dev_idx);
+
+	/* Append old volume information record (the first one);
+	 * note that at the moment there is only one isw_map record
+	 * (as in the old isw_dev/isw_vol record/subrecord) and we
+	 * need two of them till data transfer is finished.
+	 */
+	memcpy((void *) (new_isw->disk + new_isw->num_disks) +
+	       isw_dev_offs, old_dev, sizeof(struct isw_dev));
+
+	/* Update new volume information. */
+	new_dev = raiddev(new_isw, isw_dev_idx);
+	new_dev->vol.migr_state = 1;	/* FIXME: replace magic numbers */
+	new_dev->vol.migr_type = 1;	/* FIXME: replace magic numbers */
+
+	/* Update information in the first map. */
+	new_dev->vol.map.map_state = ISW_T_STATE_NORMAL;
+	new_dev->vol.map.failed_disk_num = failed_disk_idx;
+
+	/*
+	 * FIXME: disk_ord_tbl should be updated too but at the moment
+	 * we may leave it as it is coded below without any harm.
+	 */
+	for (i = 0; i < new_isw->num_disks - 1; i++)
+		new_dev->vol.map.disk_ord_tbl[i] = i;
+
+	/*
+	 * FIXME: code commented out
+	 * new_isw->family_num = _checksum(new_isw) + time(NULL);
+	 */
+
+	/* now let's proceed with the second, temporary map
+	   FIXME: we just copy the first map and update it a bit */
+	map_size =
+		sizeof(struct isw_map) + (new_dev->vol.map.num_members -
+					  1) *
+		sizeof(((struct isw_map *) NULL)->disk_ord_tbl);
+	memcpy((void *) &new_dev->vol.map + map_size,
+	       (void *) &new_dev->vol.map, map_size);
+
+	/*
+	 * FIXME: the code below should be put into
+	 * a new function 'raid_is_rebuildable()'.
+	 */
+	((struct isw_map *)
+	 ((void *) &new_dev->vol.map + map_size))->map_state =
+		new_dev->vol.map.raid_level == ISW_T_RAID0 ?
+		ISW_T_STATE_FAILED : ISW_T_STATE_DEGRADED;
+
+	return (unsigned)
+		((unsigned long) &new_dev->vol.map + 2 * map_size) -
+		((unsigned long) new_isw->disk + new_isw->num_disks) -
+		isw_dev_offs;
+}
+
+/* Update metadata wit hdrive to rebuild. */
+static int
+update_metadata(struct lib_context *lc, struct raid_set *rs)
+{
+	int failed_disk_idx = -1;	/* zero-based index of failed disk */
+	int i, idx, found = 0, failed_disks_num = 0, new_isw_size, ret = 0;
+	unsigned isw_dev_offs;
+	const char *rebuild_set_name = lc->options[LC_REBUILD_SET].arg.str;
+	struct raid_dev *rd = list_entry(rs->devs.next, struct raid_dev, devs);
+	struct raid_set *sub_rs = NULL;
+	struct dev_info *di = NULL;
+	struct isw *isw = META(rd, isw), *new_isw = NULL;
+	struct isw_disk *disk = isw->disk, *new_disk = NULL;
+	struct isw_dev *new_dev = NULL;
+
+
+	/*
+	 * Find the index of the failed disk -
+	 * at most we can handle 1 failed disk.
+	 */
+	i = isw->num_disks;
+	while (i--) {
+		/* Check if the disk is listed. */
+		list_for_each_entry(di, LC_DI(lc), list) {
+			if (!strncmp(di->serial, (const char *) disk[i].serial,
+				     MAX_RAID_SERIAL_LEN))
+				goto goon;
+		}
+
+		/* Disk not found in system, i.e. it's the failed one. */
+		failed_disk_idx = i;
+		failed_disks_num++;
+
+		/* Mark disk as not usable. */
+		disk[i].scsiId = UNKNOWN_SCSI_ID;
+		disk[i].status &= ~USABLE_DISK;
+		disk[i].status |= FAILED_DISK;
+	      goon:
+		;
+	}
+
+	/* We must have one failed disk */
+	if (failed_disks_num != 1)
+		LOG_ERR(lc, 0, "%s: only one failed disk supported", handler);
+
+	/* Now let's find the disk for rebuild. */
+	if (failed_disk_idx == -1)
+		/*
+		 * Could not find failed disk... maybe this place can
+		 * be used to search for and add a spare disk.
+		 */
+		return 0;
+
+	/* Search for a raid_dev in s_init state. */
+	sub_rs = find_set(lc, NULL, rebuild_set_name, FIND_ALL);
+	found = 0;
+	list_for_each_entry(rd, &sub_rs->devs, devs) {
+		if (rd->status == s_init) {
+			di = rd->di;
+			DM_ASSERT(di);
+			log_print(lc, "%s: drive to rebuild: %s\n",
+				  handler, di->path);
+			found = 1;
+			break;
+		}
+	}
+
+	/* FIXME: "TBD - remove later"  */
+	if (!found && lc->options[LC_REBUILD_DISK].opt) {
+		list_for_each_entry(di, LC_DI(lc), list) {
+			if (!strncmp(di->path,
+				     lc->options[LC_REBUILD_DISK].arg.str,
+				     strlen(di->path))) {
+				found = 1;
+				break;
+			}
+		}
+	}
+
+	if (!found)		/* Error: no disk to rebuild found - exit. */
+		LOG_ERR(lc, 0, "%s: no drive to rebuild", handler);
+
+	/* Now let's start building the new metadata. */
+
+	/* MPB can have at most two block size. */
+	new_isw_size = 2 * ISW_DISK_BLOCK_SIZE;
+	new_isw = alloc_private(lc, handler, new_isw_size);
+	if (!new_isw)
+		return 0;
+
+	/* Copy a few first metadata bytes. */
+	memcpy(new_isw, isw, sizeof(struct isw) - sizeof(struct isw_disk));
+
+	/* some field will be updated later on; they are marked below:
+	 * check_sum
+	 * mpb_size
+	 family_num
+	 * generation_num
+	 error_log_size
+	 attributes
+	 * num_disks
+	 num_raid_devs
+	 error_log_pos
+	 cache_size
+	 orig_family_num
+	 FIXME: OROM changes some fields that are not marked above,
+	 so we should too
+	 */
+
+	/* Add the new disk. */
+	new_disk = alloc_private(lc, handler, sizeof(struct isw_disk));
+	if (!new_disk)
+		goto bad_free_new_isw;
+
+	new_disk->totalBlocks = di->sectors;
+	new_disk->scsiId = get_scsiId(lc, di->path);
+	/* FIXME: is this state ok, Radoslaw ? Was 0x53a */
+	new_disk->status = CONFIG_ON_DISK |
+		DISK_SMART_EVENT_SUPPORTED |
+		CLAIMED_DISK | DETECTED_DISK | USABLE_DISK | CONFIGURED_DISK;
+	strncpy((char *) new_disk->serial, di->serial, MAX_RAID_SERIAL_LEN);
+
+	/* build new isw_disk array */
+	for (i = 0; i < isw->num_disks; i++) {
+		/*
+		 * Replace failed disk with the new one or
+		 * Leave previous drives as they are.
+		 */
+		memcpy(new_isw->disk + i,
+		       i == failed_disk_idx ? new_disk : isw->disk + i,
+		       sizeof(struct isw_disk));
+	}
+
+	/*
+	 * Append the failed disk at the end of the disks array in
+	 * the metadata; as designed in the intermediate rebuilding
+	 * step we have 3 disks and two maps per isw_dev: the new one
+	 * (at index 0) and the old one (at index 1).
+	 */
+	memcpy(new_isw->disk + i, isw->disk + failed_disk_idx,
+	       sizeof(struct isw_disk));
+	new_isw->disk[i].status = CONFIGURED_DISK;
+	new_isw->num_disks++;
+
+	/* Create isw_dev record for volume(s). */
+	isw_dev_offs = update_metadata_isw_dev(new_isw, failed_disk_idx,
+					       isw, 0, 0);
+	if (isw->num_raid_devs > 1)
+		isw_dev_offs += update_metadata_isw_dev(new_isw,
+							failed_disk_idx, isw,
+							1, isw_dev_offs);
+
+	/* now we may update new metadata's fields */
+	new_isw->mpb_size =
+		(unsigned long) (new_isw->disk + new_isw->num_disks) -
+		(unsigned long) (new_isw) + isw_dev_offs;
+	new_isw->generation_num++;
+	new_isw->check_sum = _checksum(new_isw);
+
+	/* embed new metadata on physical devices */
+	idx = rd_idx_by_name(new_isw, rebuild_set_name + strlen(rs->name) + 1);
+	if (idx < 0)
+		return 0;
+
+	new_dev = raiddev(new_isw, idx);
+	sub_rs = find_set(lc, NULL, rebuild_set_name, FIND_ALL);
+	list_for_each_entry(rd, &sub_rs->devs, devs) {
+		if (rd->meta_areas && rd->meta_areas->area) {
+
+			dbg_free(rd->meta_areas->area);
+		}
+		if (!rd->meta_areas || rd->status == s_init) {
+			if (rd->meta_areas)
+				dbg_free(rd->meta_areas);
+
+			rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1);
+			if (!rd->meta_areas)
+				goto bad_free_new_disk;
+
+			rd->di = di;
+			rd->fmt = &isw_format;
+			rd->meta_areas->area =
+				alloc_private(lc, handler, new_isw_size);
+			memcpy(rd->meta_areas->area, new_isw, new_isw_size);
+			rd->offset = new_dev->vol.map.pba_of_lba0;
+			rd->sectors = new_dev->vol.map.blocks_per_member;
+		}
+		else {
+			rd->meta_areas->area =
+				alloc_private(lc, handler, new_isw_size);
+			if (!rd->meta_areas->area)
+				goto bad_free_new_disk;
+
+			memcpy(rd->meta_areas->area, new_isw, new_isw_size);
+		}
+
+		if (!rd->areas)
+			rd->areas++;
+		set_metadata_sizoff(rd, isw_size(new_isw));
+
+		if (rd->status == s_init) {
+			rd->status = s_ok;
+			if (rd->name)
+				dbg_free(rd->name);
+
+			if (!(rd->name = name(lc, rd, new_dev, N_VOLUME)))
+				goto bad_free_new_disk;
+		}
+
+		rd->status = s_ok;
+	}
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (rd->meta_areas && rd->meta_areas->area)
+			dbg_free(rd->meta_areas->area);
+
+		if (!rd->meta_areas || rd->status == s_init) {
+			if (rd->meta_areas && rd->meta_areas->area)
+				dbg_free(rd->meta_areas->area);
+
+			rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1);
+			if (!rd->meta_areas)
+				goto bad_free_new_disk;
+
+			rd->di = di;
+			rd->fmt = &isw_format;
+			rd->offset = new_dev->vol.map.pba_of_lba0;
+			rd->sectors = new_dev->vol.map.blocks_per_member;
+		}
+		rd->meta_areas->area = alloc_private(lc, handler, new_isw_size);
+		if (!rd->meta_areas->area)
+			goto bad_free_new_disk;
+		set_metadata_sizoff(rd, isw_size(new_isw));
+		memcpy(rd->meta_areas->area, new_isw, new_isw_size);
+
+
+		if (rd->status == s_init) {
+
+			if (rd->name)
+				dbg_free(rd->name);
+
+			if (!(rd->name = name(lc, rd, new_dev, N_VOLUME)))
+				goto bad_free_new_disk;
+
+			/* FIXME: code commented out
+			   new_name = name(lc, rd, new_dev, 0);
+			 */
+		}
+
+		rd->status = s_ok;
+	}
+
+	/* FIXME: code commented out
+	   change_set_name(lc, LC_RS(lc), rs->name, new_name);
+	 */
+
+	ret = 1;
+      bad_free_new_disk:
+	dbg_free(new_disk);
+      bad_free_new_isw:
+	dbg_free(new_isw);
+	return ret;
+}
+
+/* Register this format handler with the format core. */
+int
+register_isw(struct lib_context *lc)
+{
+	return register_format_handler(lc, &isw_format);
+}
+
+/*
+ * Set the RAID device contents up derived from the Intel ones.
+ *
+ * This is the first one we get with here and we potentially need to
+ * create many in isw_group() in case of multiple Intel SW RAID devices
+ * on this RAID disk.
+ */
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
+{
+	struct isw *isw = meta;
+	struct isw_disk *disk;
+
+
+	/* Superblock checksum */
+	if (isw->check_sum != _checksum(isw))
+		LOG_ERR(lc, 0, "%s: extended superblock for %s "
+			"has wrong checksum", handler, di->path);
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = info->u64 >> 9;
+	rd->meta_areas->size = isw_size(isw);
+	rd->meta_areas->area = isw;
+
+	rd->di = di;
+	rd->fmt = &isw_format;
+
+	rd->offset = ISW_DATAOFFSET;
+	if (!(rd->sectors = info->u64 >> 9))
+		return log_zero_sectors(lc, di->path, handler);
+
+	rd->status = status(lc, rd);
+
+	/* Mark disk as spare disk. */
+	disk = get_disk(lc, di, isw);
+	if (disk->status & SPARE_DISK)
+		rd->type = t_spare;
+	else
+		rd->type = t_group;
 
-        return (rd->name = name(lc, isw, NULL)) ? 1 : 0;
+	disk->scsiId = get_scsiId(lc, di->path);
+	return (rd->name = name(lc, rd, NULL, N_NUMBER)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/isw.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/isw.h	2008/06/20 21:52:17	1.2
@@ -5,6 +5,9 @@
  * Copyright (C) 2004,2005 Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2.1, or (at your option)
@@ -31,85 +34,156 @@
 #undef	FORMAT_HANDLER
 
 /* Intel metadata offset in bytes */
-#define	ISW_CONFIGOFFSET	((di->sectors - 2) << 9)
+#define	ISW_CONFIGSECTOR(di)	((di)->sectors - 2)
+#define	ISW_CONFIGOFFSET(di)	(ISW_CONFIGSECTOR(di) << 9)
 #define	ISW_DATAOFFSET		0	/* Data offset in sectors */
 
 #define MPB_SIGNATURE	     "Intel Raid ISM Cfg Sig. "
-#define MPB_VERSION_RAID2                             "1.2.02"
+#define MPB_SIGNATURE_SIZE	(sizeof(MPB_SIGNATURE) - 1)
+#define MPB_VERSION_RAID2	"1.2.02"
+#define MPB_VERSION_RAID2_SIZE	(sizeof(MPB_VERSION_RAID2) - 1)
 #define MAX_SIGNATURE_LENGTH  32
 #define MAX_RAID_SERIAL_LEN   16
 #define ISW_DISK_BLOCK_SIZE  512
 #define TYPICAL_MPBSIZE 1024
 
+#define RAID_DS_JOURNAL 259
+#define MIGR_OPT_SPACE  4096
+#define RAID_VOLUME_RESERVED_BLOCKS (RAID_DS_JOURNAL+MIGR_OPT_SPACE)
+#define RAID_DISK_RESERVED_BLOCKS 417
+#define DISK_RESERVED_BLOCKS (RAID_DISK_RESERVED_BLOCKS+RAID_VOLUME_RESERVED_BLOCKS)
+#define UNKNOWN_SCSI_ID ((uint32_t)~0)
+
 /* Disk configuration info. */
 struct isw_disk {
-	int8_t serial[MAX_RAID_SERIAL_LEN];/* 0xD8 - 0xE7 ascii serial number */
+	int8_t serial[MAX_RAID_SERIAL_LEN];	/* 0xD8 - 0xE7 ascii serial number */
 	uint32_t totalBlocks;	/* 0xE8 - 0xEB total blocks */
 	uint32_t scsiId;	/* 0xEC - 0xEF scsi ID */
 	uint32_t status;	/* 0xF0 - 0xF3 */
-#define SPARE_DISK      0x01  /* Spare */
-#define CONFIGURED_DISK 0x02  /* Member of some RaidDev */
-#define FAILED_DISK     0x04  /* Permanent failure */
-#define USABLE_DISK     0x08  /* Fully usable unless FAILED_DISK is set */
-
-#define	ISW_DISK_FILLERS	5
-	uint32_t filler[ISW_DISK_FILLERS]; /* 0xF4 - 0x107 MPB_DISK_FILLERS for future expansion */
+#define SPARE_DISK      0x01	/* Spare */
+#define CONFIGURED_DISK 0x02	/* Member of some RaidDev */
+#define FAILED_DISK     0x04	/* Permanent failure */
+#define USABLE_DISK     0x08	/* Fully usable unless FAILED_DISK is set */
+#define DETECTED_DISK   0x10	/* Device attach received */
+#define CLAIMED_DISK    0X20	/* Device has been claimed ? */
+#define PASSTHRU_DISK   0X40	/* Device should be ignored */
+#define OFFLINE_DISK    0X80	/* Device has been marked offline by user */
+#define CONFIG_ON_DISK  0x100	/* Device currently has MPB stored on it */
+#define DISK_SMART_EVENT_TRIGGERED 0x200
+#define DISK_SMART_EVENT_SUPPORTED 0x400
+#define FORMATTING_DISK 0x800	/* Device is formatting */
+#define FORMAT_SUCCEEDED 0x1000	/* This bit is used with FORMATTING_DISK */
+#define FORMAT_FAILED    0x2000	/* This bit is used with FORMATTING_DISK */
+#define ELIGIBLE_FOR_SPARE 0x4000	/* Device may be used as a spare if needed. */
+#define READ_CONFIG_NEEDED 0x8000	/* Device needs to have its config read */
+#define CONFIG_IS_UPREV    0x10000	/* Config on device but cannot be handled */
+#define UNKNOW_DISK_FAILURE 0x40000	/* Any reading errors */
+#define DO_READ_CONFIG      0x80000	/* Device's config will be read and merged on nexted call */
+#define POWERED_OFF_DISK    0x100000	/* Device is spun down */
+#define PASSTHRU_CLAIMABLE  0x200000	/* Passthru device is claimable */
+#define CLONE_DISK_MODIFIED 0x400000
+#define PASSTHRU_DISK_WMPB  0X800000
+
+	uint32_t owner_cfg_num;	/* 0xF4 - 0xF7 */
+#define	ISW_DISK_FILLERS	4
+	uint32_t filler[ISW_DISK_FILLERS];	/* 0xF7 - 0x107 MPB_DISK_FILLERS for future expansion */
 };
 
 /* RAID map configuration infos. */
 struct isw_map {
-	uint32_t pba_of_lba0;		// start address of partition
+	uint32_t pba_of_lba0;	// start address of partition
 	uint32_t blocks_per_member;	// blocks per member
 	uint32_t num_data_stripes;	// number of data stripes
 	uint16_t blocks_per_strip;
-	uint8_t  map_state;		// Normal, Uninitialized, Degraded, Failed
-#define	ISW_T_STATE_NORMAL		0
-#define	ISW_T_STATE_UNINITIALIZED	1
-	uint8_t  raid_level;
+	uint8_t map_state;	// Normal, Uninitialized, Degraded, Failed
+#define	ISW_T_STATE_NORMAL	       0x00
+#define	ISW_T_STATE_UNINITIALIZED      0X01
+#define ISW_T_STATE_DEGRADED           0x02
+#define ISW_T_STATE_FAILED             0x03
+
+	uint8_t raid_level;
 #define	ISW_T_RAID0	0
 #define	ISW_T_RAID1	1
-#define	ISW_T_RAID5	5		// since metadata version 1.2.02 ?
-	uint8_t  num_members;		// number of member disks
-	uint8_t  reserved[3];
-	uint32_t filler[7];		// expansion area
+#define	ISW_T_RAID10	2
+#define	ISW_T_RAID5	5	// since metadata version 1.2.02 ?
+#define ISW_T_SPARE	8
+#define ISW_T_UNDEF     0xff
+	uint8_t num_members;	// number of member disks
+	uint8_t num_domains;
+	uint8_t failed_disk_num;
+#define	ISW_DEV_NONE_FAILED	255
+	uint8_t ddf;
+
+	uint32_t filler[7];	// expansion area
 	uint32_t disk_ord_tbl[1];	/* disk_ord_tbl[num_members],
 					   top byte special */
 } __attribute__ ((packed));
 
 struct isw_vol {
-	uint32_t reserved[2];
-	uint8_t  migr_state;		// Normal or Migrating
-	uint8_t  migr_type;		// Initializing, Rebuilding, ...
-	uint8_t  dirty;
-	uint8_t  fill[1];
-	uint32_t filler[5];
+	uint32_t curr_migr_unit;
+	uint32_t check_point_id;
+	uint8_t migr_state;	// Normal or Migrating
+	uint8_t migr_type;	// Initializing, Rebuilding, ...
+	uint8_t dirty;
+	uint8_t fs_state;
+	uint16_t verify_errors;
+	uint16_t verify_bad_blocks;
+#define ISW_RAID_VOL_FILLERS 4
+	uint32_t filler[ISW_RAID_VOL_FILLERS];
 	struct isw_map map;
 	// here comes another one if migr_state
 } __attribute__ ((packed));
 
 struct isw_dev {
-	uint8_t	volume[MAX_RAID_SERIAL_LEN];
+	uint8_t volume[MAX_RAID_SERIAL_LEN];
 	uint32_t SizeLow;
 	uint32_t SizeHigh;
 	uint32_t status;	/* Persistent RaidDev status */
-	uint32_t reserved_blocks; /* Reserved blocks at beginning of volume */
-#define	ISW_DEV_FILLERS	12
+#define ISW_DEV_BOOTABLE               0x01
+#define ISW_DEV_BOOT_DEVICE            0x02
+#define ISW_DEV_READ_COALESCING        0x04
+#define ISW_DEV_WRITE_COALESCING       0x08
+#define ISW_DEV_LAST_SHUTDOWN_DIRTY    0x10
+#define ISW_DEV_HIDDEN_AT_BOOT         0x20
+#define ISW_DEV_CURRENTLY_HIDDEN       0x40
+#define ISW_DEV_VERIFY_AND_FIX         0x80
+#define ISW_DEV_MAP_STATE_UNINIT       0x100
+#define ISW_DEV_NO_AUTO_RECOVERY       0x200
+#define ISW_DEV_CLONE_N_GO             0x400
+#define ISW_DEV_CLONE_MAN_SYNC         0x800
+#define ISW_DEV_CNG_MASTER_DISK_NUM    0x1000
+
+	uint32_t reserved_blocks;	/* Reserved blocks at beginning of volume */
+	uint8_t migr_priority;	/* Medium, Low, High */
+	uint8_t num_sub_vol;	/* number of subvolumes */
+	uint8_t tid;		/* target Id */
+	uint8_t cng_master_disk;	/*  */
+	uint16_t cache_policy;	/* Persistent cache info */
+	uint8_t cng_state;
+	uint8_t cng_sub_state;
+
+#define	ISW_DEV_FILLERS	10
 	uint32_t filler[ISW_DEV_FILLERS];
 	struct isw_vol vol;
 } __attribute__ ((packed));
 
 struct isw {
-	int8_t sig[MAX_SIGNATURE_LENGTH];/* 0x0 - 0x1F */
-	uint32_t check_sum;		/* 0x20 - 0x23  MPB Checksum */
-	uint32_t mpb_size;		/* 0x24 - 0x27 Size of MPB */
-	uint32_t family_num;		/* 0x28 - 0x2B Checksum from first time this config was written */
+	int8_t sig[MAX_SIGNATURE_LENGTH];	/* 0x0 - 0x1F */
+	uint32_t check_sum;	/* 0x20 - 0x23  MPB Checksum */
+	uint32_t mpb_size;	/* 0x24 - 0x27 Size of MPB */
+	uint32_t family_num;	/* 0x28 - 0x2B Checksum from first time this config was written */
 	/* 0x2C - 0x2F  Incremented each time this array's MPB is written */
 	uint32_t generation_num;
-	uint32_t reserved[2];		/* 0x30 - 0x37 */
-	uint8_t num_disks;		/* 0x38 Number of configured disks */
-	uint8_t num_raid_devs;		/* 0x39 Number of configured volumes */
-	uint8_t fill[2];		/* 0x3A - 0x3B */
-#define	ISW_FILLERS	39
+	uint32_t error_log_size;	/* 0x30 - 0x33 in bytes */
+	uint32_t attributes;	/* 0x34 - 0x37 */
+
+	uint8_t num_disks;	/* 0x38 Number of configured disks */
+	uint8_t num_raid_devs;	/* 0x39 Number of configured volumes */
+	uint8_t error_log_pos;	/* 0x3A  */
+	uint8_t fill[1];	/* 0x3B */
+	uint32_t cache_size;	/* 0x3c - 0x40 in mb */
+	uint32_t orig_family_num;	/* 0x40 - 0x43 original family num */
+#define	ISW_FILLERS	37
 	uint32_t filler[ISW_FILLERS];	/* 0x3C - 0xD7 RAID_MPB_FILLERS */
 	struct isw_disk disk[1];	/* 0xD8 diskTbl[numDisks] */
 	// here comes isw_dev[num_raid_devs]
--- dmraid/lib/format/ataraid/jm.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/format/ataraid/jm.c	2008/06/20 21:52:17	1.4
@@ -1,7 +1,7 @@
 /*
  * JMicron metadata format handler.
  *
- * Copyright (C) 2006,2007  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2006-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -22,8 +22,8 @@
 
 /* RAID set name */
 static int member(struct jm *jm);
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	int i;
 	size_t len;
@@ -55,50 +55,57 @@
  * Retrieve status of device.
  * FIXME: is this sufficient to cover all state ?
  */
-static enum status status(struct jm *jm)
+static enum status
+status(struct jm *jm)
 {
-	return jm->attribute & ~(JM_MOUNT|JM_BOOTABLE|JM_BADSEC|JM_ACTIVE|JM_UNSYNC|JM_NEWEST) ? s_broken : s_ok;
+	return jm->attribute & ~(JM_MOUNT | JM_BOOTABLE | JM_BADSEC | JM_ACTIVE
+				 | JM_UNSYNC | JM_NEWEST) ? s_broken : s_ok;
 }
 
 /* Neutralize disk type */
-static enum type type(struct jm *jm)
+static enum type
+type(struct jm *jm)
 {
 	/* Mapping of JM types to generic types */
 	static struct types types[] = {
-		{ JM_T_JBOD, t_linear},
-		{ JM_T_RAID0, t_raid0},
-		{ JM_T_RAID01, t_raid1},
-		{ JM_T_RAID1, t_raid1},
-		{ 0, t_undef},
+		{ JM_T_JBOD, t_linear },
+		{ JM_T_RAID0, t_raid0 },
+		{ JM_T_RAID01, t_raid1 },
+		{ JM_T_RAID1, t_raid1 },
+		{ 0, t_undef },
 	};
 
 	return rd_type(types, (unsigned int) jm->mode);
 }
 
 /* Calculate checksum on metadata */
-static int checksum(struct jm *jm)
+static int
+checksum(struct jm *jm)
 {
 	int count = 64;
-	uint16_t *p = (uint16_t*) jm, sum = 0;
+	uint16_t *p = (uint16_t *) jm, sum = 0;
 
-        while (count--)
+	while (count--)
 		sum += *p++;
 
 	/* FIXME: shouldn't this be one value only ? */
-	return sum == 0 || sum == 1;
+	return !sum || sum == 1;
 }
 
-static inline unsigned int segment(uint32_t m)
+static inline unsigned int
+segment(uint32_t m)
 {
 	return (unsigned int) (m & JM_SEG_MASK);
 }
 
-static inline unsigned int disk(unsigned int m)
+static inline unsigned int
+disk(unsigned int m)
 {
 	return (unsigned int) (m & JM_HDD_MASK);
 }
 
-static int member(struct jm *jm)
+static int
+member(struct jm *jm)
 {
 	unsigned int i = JM_MEMBERS;
 
@@ -111,25 +118,29 @@
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	return member(META(RD(new), jm)) < member(META(RD(pos), jm));
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
 	return member(META(RD_RS(RS(pos)), jm)) > 1;
 }
 
-static unsigned int stride(unsigned int shift)
+static unsigned int
+stride(unsigned int shift)
 {
 	return 1 << (shift + 1);
 }
 
-static void super_created(struct raid_set *super, void *private)
+static void
+super_created(struct raid_set *super, void *private)
 {
-	super->type   = t_raid0;
+	super->type = t_raid0;
 	super->stride = stride(META((private), jm)->block);
 }
 
@@ -138,8 +149,9 @@
  *
  * Check device hierarchy and create super set appropriately.
  */
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	struct jm *jm = META(rd, jm);
 
@@ -154,7 +166,6 @@
 	case JM_T_RAID1:
 		if (!find_set(lc, NULL, rs->name, FIND_TOP))
 			list_add_tail(&rs->list, LC_RS(lc));
-
 		break;
 
 	case JM_T_RAID01:
@@ -169,8 +180,8 @@
 /*
  * Add a JMicron RAID device to a set.
  */
-static struct raid_set *jm_group(struct lib_context *lc,
-				       struct raid_dev *rd)
+static struct raid_set *
+jm_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -191,7 +202,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	unsigned int i;
 	struct jm *jm = meta;
@@ -215,19 +227,20 @@
 #endif
 
 /* Magic check. */
-static int is_jm(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_jm(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct jm *jm = meta;
 
-	return !strncmp((const char*) jm->signature,
-			JM_SIGNATURE, JM_SIGNATURE_LEN)
-	       && checksum(jm);
+	return !strncmp((const char *) jm->signature,
+			JM_SIGNATURE, JM_SIGNATURE_LEN) &&
+	       checksum(jm);
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *jm_read(struct lib_context *lc,
-				      struct dev_info *di)
+static struct raid_dev *
+jm_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
 			     sizeof(struct jm), JM_CONFIGOFFSET,
@@ -237,8 +250,8 @@
 /*
  * Write a JMicron RAID device.
  */
-static int jm_write(struct lib_context *lc,
-			struct raid_dev *rd, int erase)
+static int
+jm_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -258,17 +271,18 @@
  *
  * FIXME: more sanity checks.
  */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
 	unsigned int r = JM_MEMBERS;
 	struct jm *jm = META(rd, jm);
 
 	while (r-- && !jm->member[r]);
-
 	return ++r;
 }
 
-static int jm_check(struct lib_context *lc, struct raid_set *rs)
+static int
+jm_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, devices, NULL,
 			      NO_CHECK_RD, NULL, handler);
@@ -277,7 +291,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct jm *jm = META(rd, jm);
@@ -286,21 +301,21 @@
 	if (S_BROKEN(status(jm)))
 		return 0;
 
-	jm->checksum = 1; /* FIXME: how to flag a JMicron disk bad? */
-
+	jm->checksum = 1;	/* FIXME: how to flag a JMicron disk bad? */
 	return 1;
 }
 
 static struct event_handlers jm_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about an JM RAID device.
  */
-static void jm_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+jm_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	unsigned int i;
 	struct jm *jm = META(rd, jm);
@@ -319,44 +334,49 @@
 	DP("name: %u", jm, jm->mode);
 	DP("block: %u", jm, jm->block);
 	DP("attribute: %u", jm, jm->attribute);
+
 	for (i = 0; i < JM_SPARES; i++)
 		P2("spare[%d]: 0x%x", jm, i, jm->spare[i]);
+
 	for (i = 0; i < JM_MEMBERS; i++)
 		P2("member[%d]: 0x%x", jm, i, jm->member[i]);
 }
 #endif
 
 static struct dmraid_format jm_format = {
-	.name	= HANDLER,
-	.descr	= "JMicron ATARAID",
-	.caps	= "S,0,1",
+	.name = HANDLER,
+	.descr = "JMicron ATARAID",
+	.caps = "S,0,1",
 	.format = FMT_RAID,
-	.read	= jm_read,
-	.write	= jm_write,
-	.group	= jm_group,
-	.check	= jm_check,
-	.events	= &jm_event_handlers,
+	.read = jm_read,
+	.write = jm_write,
+	.group = jm_group,
+	.check = jm_check,
+	.events = &jm_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= jm_log,
+	.log = jm_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_jm(struct lib_context *lc)
+int
+register_jm(struct lib_context *lc)
 {
 	return register_format_handler(lc, &jm_format);
 }
 
 /* Calculate RAID device size in sectors depending on RAID type. */
-static inline uint64_t sectors(struct jm *jm)
+static inline uint64_t
+sectors(struct jm *jm)
 {
 	/* range * 32MB[sectors] + range2 */
-	return jm->segment.range * 32*2048 + jm->segment.range2;
+	return jm->segment.range * 32 * 2048 + jm->segment.range2;
 }
 
 /* Set the RAID device contents up derived from the JMicron ones */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct jm *jm = meta;
 
@@ -365,13 +385,13 @@
 
 	rd->meta_areas->offset = JM_CONFIGOFFSET >> 9;
 	rd->meta_areas->size = sizeof(*jm);
-	rd->meta_areas->area = (void*) jm;
+	rd->meta_areas->area = (void *) jm;
 
 	rd->di = di;
 	rd->fmt = &jm_format;
 
 	rd->status = status(jm);
-	rd->type   = type(jm);
+	rd->type = type(jm);
 
 	rd->offset = jm->segment.base;
 	if (!(rd->sectors = sectors(jm)))
--- dmraid/lib/format/ataraid/jm.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/jm.h	2008/06/20 21:52:17	1.2
@@ -22,35 +22,35 @@
 struct jm {
 #define JM_SIGNATURE "JM"
 #define JM_SIGNATURE_LEN	2
-	int8_t		signature[JM_SIGNATURE_LEN];	/* 0x0 - 0x01 */
+	int8_t signature[JM_SIGNATURE_LEN];	/* 0x0 - 0x01 */
 
-	uint16_t	version;	/* 0x03 - 0x04 JMicron version */
+	uint16_t version;	/* 0x03 - 0x04 JMicron version */
 #define	JM_MINOR_VERSION(jm)	(jm->version & 0xFF)
 #define	JM_MAJOR_VERSION(jm)	(jm->version >> 8)
 
-	uint16_t	checksum;	/* 0x04 - 0x05 */
-	uint8_t		filler[10];
+	uint16_t checksum;	/* 0x04 - 0x05 */
+	uint8_t filler[10];
 
-	uint32_t	identity;	/* 0x10 - 0x13 */
+	uint32_t identity;	/* 0x10 - 0x13 */
 
 	struct {
-		uint32_t	base;	/* 0x14 - 0x17 */
-		uint32_t	range;	/* 0x18 - 0x1B range */
-		uint16_t	range2;	/* 0x1C - 0x1D range2 */
+		uint32_t base;	/* 0x14 - 0x17 */
+		uint32_t range;	/* 0x18 - 0x1B range */
+		uint16_t range2;	/* 0x1C - 0x1D range2 */
 	} segment;
 
 #define	JM_NAME_LEN	16
-	int8_t		name[JM_NAME_LEN];	/* 0x20 - 0x2F */
+	int8_t name[JM_NAME_LEN];	/* 0x20 - 0x2F */
 
-	uint8_t		mode;		/* 0x30 RAID level */
+	uint8_t mode;		/* 0x30 RAID level */
 #define	JM_T_RAID0	0
 #define	JM_T_RAID1	1
 #define	JM_T_RAID01	2	/* RAID 0+1 (striped with mirrors underneath) */
 #define	JM_T_JBOD	3
 #define	JM_T_RAID5	5
 
-	uint8_t		block;		/* 0x31 stride size (2=4K, 3=8K, ...) */
-	uint16_t	attribute;	/* 0x32 - 0x33 */ 
+	uint8_t block;		/* 0x31 stride size (2=4K, 3=8K, ...) */
+	uint16_t attribute;	/* 0x32 - 0x33 */
 #define	JM_MOUNT	0x01
 #define	JM_BOOTABLE	0x02
 #define	JM_BADSEC	0x03
@@ -58,16 +58,16 @@
 #define	JM_UNSYNC	0x06
 #define	JM_NEWEST	0x07
 
-	uint8_t		filler1[4];
+	uint8_t filler1[4];
 
 #define	JM_SPARES	2
 #define	JM_MEMBERS	8
-	uint32_t	spare[JM_SPARES];	/* 0x38 - 0x3F */
-	uint32_t	member[JM_MEMBERS];	/* 0x40 - 0x5F */
+	uint32_t spare[JM_SPARES];	/* 0x38 - 0x3F */
+	uint32_t member[JM_MEMBERS];	/* 0x40 - 0x5F */
 #define	JM_HDD_MASK	0xFFFFFFF0
 #define	JM_SEG_MASK	0x0F
 
-	uint8_t		filler2[0x20];
+	uint8_t filler2[0x20];
 } __attribute__ ((packed));
 
 #endif
--- dmraid/lib/format/ataraid/lsi.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/format/ataraid/lsi.c	2008/06/20 21:52:17	1.4
@@ -1,7 +1,7 @@
 /*
  * LSI Logic MegaRAID (and MegaIDE ?) ATARAID metadata format handler.
  *
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *			    All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -26,26 +26,29 @@
 
 /* Make up RAID device name. */
 /* FIXME: senseful name ;) */
-static unsigned int get_disk_slot(struct lsi *lsi)
+static unsigned int
+get_disk_slot(struct lsi *lsi)
 {
 	return lsi->set_number * 2 + lsi->disk_number;
 }
 
-static struct lsi_disk *get_disk(struct lsi *lsi)
+static struct lsi_disk *
+get_disk(struct lsi *lsi)
 {
 	return lsi->disks + get_disk_slot(lsi);
 }
 
-static size_t _name(struct lsi *lsi, char *str, size_t len, unsigned int subset)
+static size_t
+_name(struct lsi *lsi, char *str, size_t len, unsigned int subset)
 {
 	return snprintf(str, len,
 			subset ? "lsi_%u%u-%u" : "lsi_%u%u",
- 			lsi->set_id, lsi->set_number,
-			(get_disk(lsi))->raid10_mirror);
+			lsi->set_id, lsi->set_number,
+			get_disk(lsi)->raid10_mirror);
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	size_t len;
 	char *ret;
@@ -63,14 +66,15 @@
 }
 
 /* Neutralize disk type */
-static enum type type(struct lsi *lsi)
+static enum type
+type(struct lsi *lsi)
 {
 	/* Mapping of LSI Logic types to generic types */
 	static struct types types[] = {
 		{ LSI_T_RAID0, t_raid0 },
 		{ LSI_T_RAID1, t_raid1 },
 		{ LSI_T_RAID10, t_raid0 },
-	        { 0, t_undef}
+		{ 0, t_undef }
 	};
 
 	return rd_type(types, (unsigned int) lsi->type);
@@ -78,28 +82,31 @@
 
 /* LSI device status. */
 /* FIXME: add flesh. */
-static int status(struct lsi *lsi)
+static int
+status(struct lsi *lsi)
 {
 	return s_ok;
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	struct lsi *p = META(RD(pos), lsi), *n = META(RD(new), lsi);
 
 	switch (n->type) {
 	case LSI_T_RAID10:
-		return (get_disk(n))->raid10_stripe < 
-		       (get_disk(p))->raid10_stripe;
+		return (get_disk(n))->raid10_stripe <
+			(get_disk(p))->raid10_stripe;
 
-	default: /* RAID0 + RAID01 */
+	default:		/* RAID0 + RAID01 */
 		return get_disk_slot(n) < get_disk_slot(p);
 	}
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
 	struct lsi *p = META(RD_RS(pos), lsi), *n = META(RD_RS(new), lsi);
 
@@ -114,7 +121,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct lsi *lsi = meta;
 	struct lsi_disk *disk;
@@ -130,25 +138,28 @@
 }
 #endif
 
-static int is_lsi(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_lsi(struct lib_context *lc, struct dev_info *di, void *meta)
 {
-	return !strncmp((const char*) ((struct lsi *) meta)->magic_name,
-	       LSI_MAGIC_NAME, LSI_MAGIC_NAME_LEN);
+	return !strncmp((const char *) ((struct lsi *) meta)->magic_name,
+			LSI_MAGIC_NAME, LSI_MAGIC_NAME_LEN);
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *lsi_read(struct lib_context *lc, struct dev_info *di)
+static struct raid_dev *
+lsi_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
-			     sizeof(struct lsi), LSI_CONFIGOFFSET, 
+			     sizeof(struct lsi), LSI_CONFIGOFFSET,
 			     to_cpu, is_lsi, NULL, setup_rd, handler);
 }
 
 /*
  * Write a LSI Logic RAID device.
  */
-static int lsi_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+static int
+lsi_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -168,14 +179,16 @@
  *
  * FIXME: this needs more work together with the metadata reengineering.
  */
-static void super_created(struct raid_set *ss, void *private)
+static void
+super_created(struct raid_set *ss, void *private)
 {
-	ss->type   = t_raid1;
+	ss->type = t_raid1;
 	ss->stride = META(private, lsi)->stride;
 }
 
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	struct lsi *lsi = META(rd, lsi);
 
@@ -204,8 +217,8 @@
 	return 1;
 }
 
-static struct raid_set *lsi_group(struct lib_context *lc,
-				    struct raid_dev *rd)
+static struct raid_set *
+lsi_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -220,9 +233,10 @@
 }
 
 /* Figure total number of disks depending on RAID type. */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
-	switch ((META(rd, lsi))->type) {
+	switch (META(rd, lsi)->type) {
 	case LSI_T_RAID10:
 		return 4;
 
@@ -239,7 +253,8 @@
  *
  * FIXME: more sanity checks!!!
  */
-static int lsi_check(struct lib_context *lc, struct raid_set *rs)
+static int
+lsi_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, devices, NULL,
 			      NO_CHECK_RD, NULL, handler);
@@ -248,7 +263,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct lsi *lsi = META(rd, lsi);
@@ -258,18 +274,18 @@
 		return 0;
 
 	// FIXME: lsi->? = BAD;
-
 	return 1;
 }
 
 static struct event_handlers lsi_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /* Log native information about an LSI Logic RAID device. */
-static void lsi_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+lsi_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	unsigned int i;
 	struct lsi *lsi = META(rd, lsi);
@@ -294,12 +310,12 @@
 		  disk->unknown, disk->unknown);
 		P("disks[%u].magic_0: 0x%x, %x, %x", lsi,
 		  disk->magic_0, i, disk->magic_0,
-		  (unsigned char) (((char*) &disk->magic_0)[0]),
-		  (unsigned char) (((char*) &disk->magic_0)[1]));
+		  (unsigned char) (((char *) &disk->magic_0)[0]),
+		  (unsigned char) (((char *) &disk->magic_0)[1]));
 		P("disks[%u].magic_1: 0x%x, %x, %x", lsi,
 		  disk->magic_1, i, disk->magic_1,
-		  (unsigned char) (((char*) &disk->magic_1)[0]),
-		  (unsigned char) (((char*) &disk->magic_1)[1]));
+		  (unsigned char) (((char *) &disk->magic_1)[0]),
+		  (unsigned char) (((char *) &disk->magic_1)[1]));
 		P("disks[%u].disk_number: %u", lsi, disk->disk_number,
 		  i, disk->disk_number);
 		P("disks[%u].set_number: %u", lsi, disk->set_number,
@@ -315,29 +331,31 @@
 #endif
 
 static struct dmraid_format lsi_format = {
-	.name	= HANDLER,
-	.descr	= "LSI Logic MegaRAID",
-	.caps	= "0,1,10",
+	.name = HANDLER,
+	.descr = "LSI Logic MegaRAID",
+	.caps = "0,1,10",
 	.format = FMT_RAID,
-	.read	= lsi_read,
-	.write	= lsi_write,
-	.group	= lsi_group,
-	.check	= lsi_check,
-	.events	= &lsi_event_handlers,
+	.read = lsi_read,
+	.write = lsi_write,
+	.group = lsi_group,
+	.check = lsi_check,
+	.events = &lsi_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= lsi_log,
+	.log = lsi_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_lsi(struct lib_context *lc)
+int
+register_lsi(struct lib_context *lc)
 {
 	return register_format_handler(lc, &lsi_format);
 }
 
 /* Set the RAID device contents up derived from the LSI ones */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct lsi *lsi = meta;
 
@@ -345,19 +363,19 @@
 		return 0;
 
 	rd->meta_areas->offset = LSI_CONFIGOFFSET >> 9;
-	rd->meta_areas->size   = sizeof(*lsi);
-	rd->meta_areas->area   = (void*) lsi;
+	rd->meta_areas->size = sizeof(*lsi);
+	rd->meta_areas->area = (void *) lsi;
 
-        rd->di = di;
+	rd->di = di;
 	rd->fmt = &lsi_format;
 
 	rd->status = status(lsi);
-	rd->type   = type(lsi);
+	rd->type = type(lsi);
 
 	rd->offset = LSI_DATAOFFSET;
 	/* FIXME: propper size ? */
 	if (!(rd->sectors = rd->meta_areas->offset))
 		return log_zero_sectors(lc, di->path, handler);
 
-        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+	return (rd->name = name(lc, rd, 1)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/lsi.h	2008/04/02 13:35:31	1.2
+++ dmraid/lib/format/ataraid/lsi.h	2008/06/20 21:52:17	1.3
@@ -36,21 +36,21 @@
 #define	LSI_MAGIC_NAME	"$XIDE$"
 #define	LSI_MAGIC_NAME_LEN	(sizeof(LSI_MAGIC_NAME) - 1)
 	uint8_t magic_name[LSI_MAGIC_NAME_LEN];	/* 0x0 - 0x05 */
-	uint8_t  dummy;		/* 0x06 */
-	uint8_t  seqno;		/* 0x07 */
-	uint32_t dummy2;		/* 0x08 - 0x0B */
-	uint32_t dummy3;		/* 0x0C - 0x0F */
-	uint8_t  type;			/* 0x10 */
+	uint8_t dummy;		/* 0x06 */
+	uint8_t seqno;		/* 0x07 */
+	uint32_t dummy2;	/* 0x08 - 0x0B */
+	uint32_t dummy3;	/* 0x0C - 0x0F */
+	uint8_t type;		/* 0x10 */
 #define LSI_T_RAID0	1
 #define LSI_T_RAID1	2
 #define LSI_T_RAID10	3
 
 	uint8_t dummy4;		/* 0x11 */
-	uint16_t stride;		/* 0x12 - 0x13 */
-	uint8_t filler[0x20-0x14];	/* 0x14 - 0x1F */
+	uint16_t stride;	/* 0x12 - 0x13 */
+	uint8_t filler[0x20 - 0x14];	/* 0x14 - 0x1F */
 
 #define	LSI_MAX_DISKS	4
-	struct lsi_disk disks[LSI_MAX_DISKS];/* 0x20 - 0x5F */
+	struct lsi_disk disks[LSI_MAX_DISKS];	/* 0x20 - 0x5F */
 
 #define	LSI_DISK(lsi)		(lsi->set_number * 2 + lsi->disk_number)
 #define LSI_MAGIC_0(lsi)	(lsi->disks[LSI_DISK(lsi)].magic_0)
@@ -59,13 +59,13 @@
 #define LSI_SET_NUMBER(lsi)	(lsi->disks[LSI_DISK(lsi)].set_number)
 #undef	LSI_DISK
 
-	uint8_t filler1[0x1F0-0x60];	/* 0x70 - 0x1EF */
+	uint8_t filler1[0x1F0 - 0x60];	/* 0x70 - 0x1EF */
 
-	uint8_t disk_number;		/* 0x1F0 */
-	uint8_t set_number;		/* 0x1F1 */
-	uint32_t set_id;		/* 0x1F2 - 0x1F5 */
+	uint8_t disk_number;	/* 0x1F0 */
+	uint8_t set_number;	/* 0x1F1 */
+	uint32_t set_id;	/* 0x1F2 - 0x1F5 */
 
-	uint8_t filler2[0x200-0x1F6];	/* 0x1F6 - 0x200 */
+	uint8_t filler2[0x200 - 0x1F6];	/* 0x1F6 - 0x200 */
 } __attribute__ ((packed));
 #endif
 
--- dmraid/lib/format/ataraid/nv.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/format/ataraid/nv.c	2008/06/20 21:52:17	1.4
@@ -2,7 +2,8 @@
  * NVidia NVRAID metadata format handler.
  *
  * Copyright (C) 2004      NVidia Corporation. All rights reserved.
- * Copyright (C) 2004,2005 Heinz Mauelshagen, Red Hat GmbH.
+ *
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -27,12 +28,14 @@
  * The subset parameter indicates the requirement to create
  * name suffixes in case the RAID set is hierarchical.
  */
-static unsigned int _subset(struct nv *nv)
+static unsigned int
+_subset(struct nv *nv)
 {
 	return nv->unitNumber >= nv->array.stripeWidth;
 }
 
-static size_t _name(struct nv *nv, char *str, size_t len, unsigned int subset)
+static size_t
+_name(struct nv *nv, char *str, size_t len, unsigned int subset)
 {
 	unsigned int i = NV_SIGNATURES;
 	uint32_t sum = 0;
@@ -44,8 +47,8 @@
 			handler, sum, _subset(nv));
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	size_t len;
 	char *ret;
@@ -61,7 +64,8 @@
 	return ret;
 }
 
-static enum status status(struct nv *nv)
+static enum status
+status(struct nv *nv)
 {
 	static struct states states[] = {
 		{ NV_IDLE, s_ok },
@@ -77,7 +81,8 @@
 }
 
 /* Neutralize disk type using generic metadata type mapping function. */
-static enum type type(struct nv *nv)
+static enum type
+type(struct nv *nv)
 {
 	uint8_t stripeWidth = nv->array.stripeWidth;
 	/* Mapping of nv types to generic types */
@@ -89,17 +94,17 @@
 		{ NV_LEVEL_1_0, t_raid0 },
 		{ NV_LEVEL_3, t_raid4 },
 		{ NV_LEVEL_5_SYM, t_raid5_ls },
-	        { NV_LEVEL_UNKNOWN, t_spare},	/* FIXME: UNKNOWN = spare ? */
+		{ NV_LEVEL_UNKNOWN, t_spare },	/* FIXME: UNKNOWN = spare ? */
 		/* FIXME: The ones below don't really map to anything ?? */
 		{ NV_LEVEL_10, t_undef },
-		{ NV_LEVEL_5, t_undef },    /* Asymmetric RAID 5 is not used */
+		{ NV_LEVEL_5, t_undef },	/* Asymmetric RAID 5 is not used */
 	};
 
 	/*
 	 * FIXME: is there a direct way to decide what
-	 * 	  a spare is (eg, NV_LEVEL_UNKNOWN) ?
+	 *        a spare is (eg, NV_LEVEL_UNKNOWN) ?
 	 */
-	switch(NV_RAIDLEVEL(nv)) {
+	switch (NV_RAIDLEVEL(nv)) {
 	case NV_LEVEL_1_0:
 	case NV_LEVEL_10:
 	case NV_LEVEL_1:
@@ -109,27 +114,29 @@
 	case NV_LEVEL_5_SYM:
 		stripeWidth += 1;
 		break;
-		
-			default:
+
+	default:
 		break;
 	}
 
 	if (nv->array.totalVolumes >= stripeWidth &&
-	    nv->unitNumber         >= stripeWidth)
+	    nv->unitNumber >= stripeWidth)
 		return t_spare;
 
 	return rd_type(types, (unsigned int) NV_RAIDLEVEL(nv));
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
-	return (META(RD(new), nv))->unitNumber <
-	       (META(RD(pos), nv))->unitNumber;
+	return META(RD(new), nv)->unitNumber <
+	       META(RD(pos), nv)->unitNumber;
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
 	return _subset((META(RD_RS(RS(new)), nv))) <
 	       _subset((META(RD_RS(RS(pos)), nv)));
@@ -141,7 +148,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct nv *nv = meta;
 	unsigned int i = NV_SIGNATURES;
@@ -173,7 +181,8 @@
 #endif
 
 /* Check the metadata checksum. */
-static int checksum(struct nv *nv)
+static int
+checksum(struct nv *nv)
 {
 	uint32_t sum = 0;
 	unsigned int s = nv->size;
@@ -181,18 +190,19 @@
 	if (s != sizeof(*nv) / sizeof(sum))
 		return 0;
 
-	while (s--) 
-		sum += ((uint32_t*) nv)[s];
+	while (s--)
+		sum += ((uint32_t *) nv)[s];
 
 	/* Ignore chksum member itself. */
 	return nv->chksum - sum == nv->chksum;
 }
 
-static int is_nv(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_nv(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct nv *nv = meta;
 
-	if (strncmp((char*) nv->vendor, NV_ID_STRING, sizeof(NV_ID_STRING) - 1))
+	if (strncmp((char *) nv->vendor, NV_ID_STRING, sizeof(NV_ID_STRING) -1))
 		return 0;
 
 	if (checksum(nv))
@@ -200,10 +210,11 @@
 
 	LOG_ERR(lc, 0, "%s: bad checksum on %s", handler, di->path);
 }
-	
+
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *nv_read(struct lib_context *lc, struct dev_info *di)
+static struct raid_dev *
+nv_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
 			     sizeof(struct nv), NV_CONFIGOFFSET,
@@ -211,7 +222,8 @@
 }
 
 /* Write private RAID metadata to device */
-static int nv_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+static int
+nv_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -226,15 +238,17 @@
 	return ret;
 }
 
-static void super_created(struct raid_set *ss, void *private)
+static void
+super_created(struct raid_set *ss, void *private)
 {
-	ss->type   = t_raid1;
+	ss->type = t_raid1;
 	ss->stride = META(private, nv)->array.stripeBlockSize;
 }
 
 /* FIXME: handle spares in mirrors and check that types are correct. */
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	struct nv *nv = META(rd, nv);
 
@@ -251,7 +265,6 @@
 	case NV_LEVEL_5_SYM:
 		if (!find_set(lc, NULL, rs->name, FIND_TOP))
 			list_add_tail(&rs->list, LC_RS(lc));
-
 		break;
 
 	case NV_LEVEL_1_0:
@@ -264,8 +277,8 @@
 }
 
 /* Add an NVidia RAID device to a set. */
-static struct raid_set *nv_group(struct lib_context *lc,
-				       struct raid_dev *rd)
+static struct raid_set *
+nv_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -282,14 +295,16 @@
  *
  * FIXME: more sanity checks.
  */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
 	struct nv *nv = META(rd, nv);
 
 	return nv->array.totalVolumes / (NVRAID_1_0(nv) ? 2 : 1);
 }
 
-static int nv_check(struct lib_context *lc, struct raid_set *rs)
+static int
+nv_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, devices, NULL,
 			      NO_CHECK_RD, NULL, handler);
@@ -298,7 +313,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct nv *nv = META(rd, nv);
@@ -315,14 +331,15 @@
 
 static struct event_handlers nv_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about the RAID device.
  */
-static void nv_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+nv_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	unsigned int i, j;
 #define	LEN	NV_PRODUCTIDS + 1
@@ -379,29 +396,31 @@
 #endif
 
 static struct dmraid_format nv_format = {
-	.name	= HANDLER,
-	.descr	= "NVidia RAID",
-	.caps	= "S,0,1,10,5",
+	.name = HANDLER,
+	.descr = "NVidia RAID",
+	.caps = "S,0,1,10,5",
 	.format = FMT_RAID,
-	.read	= nv_read,
-	.write	= nv_write,
-	.group	= nv_group,
-	.check	= nv_check,
-	.events	= &nv_event_handlers,
+	.read = nv_read,
+	.write = nv_write,
+	.group = nv_group,
+	.check = nv_check,
+	.events = &nv_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= nv_log,
+	.log = nv_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_nv(struct lib_context *lc)
+int
+register_nv(struct lib_context *lc)
 {
 	return register_format_handler(lc, &nv_format);
 }
 
 /* Set the RAID device contents up derived from the NV ones */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct nv *nv = meta;
 
@@ -410,17 +429,17 @@
 
 	rd->meta_areas->offset = NV_CONFIGOFFSET >> 9;
 	rd->meta_areas->size = sizeof(*nv);
-	rd->meta_areas->area = (void*) nv;
+	rd->meta_areas->area = (void *) nv;
 
-        rd->di = di;
+	rd->di = di;
 	rd->fmt = &nv_format;
 
 	rd->status = status(nv);
-	rd->type   = type(nv);
+	rd->type = type(nv);
 
 	rd->offset = NV_DATAOFFSET;
 	if (!(rd->sectors = rd->meta_areas->offset))
 		return log_zero_sectors(lc, di->path, handler);
 
-        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+	return (rd->name = name(lc, rd, 1)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/nv.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/nv.h	2008/06/20 21:52:17	1.2
@@ -28,29 +28,29 @@
 
 #define NV_ID_LENGTH		8
 #define NV_ID_STRING		"NVIDIA"
-#define NV_VERSION		100 
+#define NV_VERSION		100
 #define NV_SECTOR_SIZE		512
-#define NV_PRODUCT_ID_LEN	16 /* Product ID size in bytes */
+#define NV_PRODUCT_ID_LEN	16	/* Product ID size in bytes */
 
 typedef uint32_t lba_t;
 
 /* Array info */
 struct nv_array_base {
 	uint32_t version;	/* Version of this struct               */
-				/* 0x640000 + sizeof(nv_array_base) */
+	/* 0x640000 + sizeof(nv_array_base) */
 #define NV_SIGNATURES	4
-	uint32_t signature[NV_SIGNATURES]; /* Unique signature for array */
+	uint32_t signature[NV_SIGNATURES];	/* Unique signature for array */
 
-	uint8_t  raidJobCode;	/* State of array */ 
+	uint8_t raidJobCode;	/* State of array */
 #define NV_IDLE			0
 #define NV_SCDB_INIT_RAID	2
 #define NV_SCDB_REBUILD_RAID	3
 #define NV_SCDB_UPGRADE_RAID	4
 #define NV_SCDB_SYNC_RAID	5
 
-	uint8_t  stripeWidth;	/* Array stripe width */
-	uint8_t  totalVolumes;	/* Total # of disks in array, including spare */
-	uint8_t  originalWidth;	/* Stripe width before morph */
+	uint8_t stripeWidth;	/* Array stripe width */
+	uint8_t totalVolumes;	/* Total # of disks in array, including spare */
+	uint8_t originalWidth;	/* Stripe width before morph */
 
 	uint32_t raidLevel;	/* Array RAID level */
 #define	NV_RAIDLEVEL(nv)	((nv)->array.raidLevel)
@@ -66,45 +66,45 @@
 #define NV_LEVEL_5_SYM_FLAG		0x10
 #define NV_LEVEL_5_SYM		(NV_LEVEL_5|NV_LEVEL_5_SYM_FLAG)
 
-	lba_t    stripeBlockSize;	/* Array stripe block size in sectors */
+	lba_t stripeBlockSize;	/* Array stripe block size in sectors */
 	uint32_t stripeBlockByteSize;	/* stripeBlockSize in bytes */
 	uint32_t stripeBlockPower;	/* Array stripe block size in log2 */
-	lba_t    stripeMask;	/* stripeBlockSize - 1 */
-	lba_t    stripeSize;	/* stripeBlockSize * stripeWidth */
+	lba_t stripeMask;	/* stripeBlockSize - 1 */
+	lba_t stripeSize;	/* stripeBlockSize * stripeWidth */
 	uint32_t stripeByteSize;	/* stripeSize in bytes */
-	lba_t    raidJobMark;	/* Ignored if array is idle, otherwise the */
-                           	/* LBA where job is finished               */
+	lba_t raidJobMark;	/* Ignored if array is idle, otherwise the */
+	/* LBA where job is finished               */
 	uint32_t originalLevel;	/* RAID level before morph */
-	lba_t    originalCapacity;	/* Array capacity before morph */
+	lba_t originalCapacity;	/* Array capacity before morph */
 
 	uint32_t flags;		/* Flags for array */
-#define NV_ARRAY_FLAG_BOOT		(0x00000001) /* BIOS use only */
-#define NV_ARRAY_FLAG_ERROR		(0x00000002) /* Degraded or offling */
-#define NV_ARRAY_FLAG_PARITY_VALID	(0x00000004) /* RAID-3/5 parity valid */
+#define NV_ARRAY_FLAG_BOOT		(0x00000001)	/* BIOS use only */
+#define NV_ARRAY_FLAG_ERROR		(0x00000002)	/* Degraded or offling */
+#define NV_ARRAY_FLAG_PARITY_VALID	(0x00000004)	/* RAID-3/5 parity valid */
 #define	NV_BROKEN(n)		(n->array.flags & NV_ARRAY_FLAG_ERROR)
 #define	NV_SET_BROKEN(n)	(n->array.flags |= NV_ARRAY_FLAG_ERROR)
 } __attribute__ ((packed));
 
 /* Ondisk metadata */
 struct nv {
-	uint8_t  vendor[NV_ID_LENGTH]; /* 0x00 - 0x07 ID string */
+	uint8_t vendor[NV_ID_LENGTH];	/* 0x00 - 0x07 ID string */
 	uint32_t size;		/* 0x08 - 0x0B Size of metadata in dwords */
 	uint32_t chksum;	/* 0x0C - 0x0F Checksum of this struct */
 	uint16_t version;	/* 0x10 - 0x11 NV version */
-	uint8_t  unitNumber;	/* 0x12 Disk index in array */
-	uint8_t  reserved;	/* 0x13 */
-	lba_t    capacity;	/* 0x14 - 0x17 Array capacity in sectors */ 
+	uint8_t unitNumber;	/* 0x12 Disk index in array */
+	uint8_t reserved;	/* 0x13 */
+	lba_t capacity;		/* 0x14 - 0x17 Array capacity in sectors */
 	uint32_t sectorSize;	/* 0x18 - 0x1B Sector size */
 #define	NV_PRODUCTIDS	16
-				/* 0x1C - 0x2B Array product ID */
-	uint8_t  productID[NV_PRODUCTIDS];
-				/*             Match INQUIRY data */
+	/* 0x1C - 0x2B Array product ID */
+	uint8_t productID[NV_PRODUCTIDS];
+	/*             Match INQUIRY data */
 #define	NV_PRODUCTREVISIONS	4
-				/* 0x2C - 0x2F Array product revision */
-	uint8_t  productRevision[NV_PRODUCTREVISIONS];
-				/*             Match INQUIRY data */
+	/* 0x2C - 0x2F Array product revision */
+	uint8_t productRevision[NV_PRODUCTREVISIONS];
+	/*             Match INQUIRY data */
 	uint32_t unitFlags;	/* 0x30 - 0x33 Flags for this disk */
-	struct nv_array_base array;      /* Array information */
+	struct nv_array_base array;	/* Array information */
 } __attribute__ ((packed));
 #endif
 
--- dmraid/lib/format/ataraid/pdc.c	2008/04/02 13:35:31	1.4
+++ dmraid/lib/format/ataraid/pdc.c	2008/06/20 21:52:17	1.5
@@ -27,19 +27,21 @@
 /*
  * Make up Promise RAID device name.
  */
-static unsigned set_number(struct pdc *pdc)
+static unsigned
+set_number(struct pdc *pdc)
 {
 	return pdc->raid.disk_number >= (pdc->raid.total_disks / 2);
 }
 
-static size_t __name(struct pdc *pdc, char *str, size_t len, int subset)
+static size_t
+__name(struct pdc *pdc, char *str, size_t len, int subset)
 {
 	return snprintf(str, len, subset ? "pdc_%u-%u" : "pdc_%u",
 			pdc->raid.magic_1, set_number(pdc));
 }
 
-static char *_name(struct lib_context *lc, struct pdc *pdc,
-		  unsigned subset)
+static char *
+_name(struct lib_context *lc, struct pdc *pdc, unsigned subset)
 {
 	size_t len;
 	char *ret = NULL;
@@ -54,8 +56,8 @@
 	return ret;
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned subset)
 {
 	return _name(lc, META(rd, pdc), subset);
 }
@@ -65,28 +67,31 @@
  *
  * FIXME: need to identify state definitions.
  */
-static enum status status(struct pdc *pdc)
+static enum status
+status(struct pdc *pdc)
 {
 	return PDC_BROKEN(pdc) ? s_broken : s_ok;
 }
 
 #define	PDC_T_RAID10	0x2	/* Not defind by Promise (yet). */
-static int is_raid10(struct pdc *pdc)
+static int
+is_raid10(struct pdc *pdc)
 {
 	return pdc->raid.type == PDC_T_RAID10 ||
 	       (pdc->raid.type == PDC_T_RAID1 && pdc->raid.total_disks > 3);
 }
 
 /* Neutralize disk type */
-static enum type type(struct pdc *pdc)
+static enum type
+type(struct pdc *pdc)
 {
 	/* Mapping of Promise types to generic types. */
 	static struct types types[] = {
-	        { PDC_T_SPAN,   t_linear},
-	        { PDC_T_RAID0,  t_raid0},
-	        { PDC_T_RAID1,  t_raid1},
-	        { PDC_T_RAID10, t_raid0},
-	        { 0, t_undef}
+		{ PDC_T_SPAN, t_linear },
+		{ PDC_T_RAID0, t_raid0 },
+		{ PDC_T_RAID1, t_raid1 },
+		{ PDC_T_RAID10, t_raid0 },
+		{ 0, t_undef }
 	};
 
 	if (is_raid10(pdc))
@@ -96,10 +101,11 @@
 }
 
 /* Calculate checksum on Promise metadata. */
-static uint32_t checksum(struct pdc *pdc)
+static uint32_t
+checksum(struct pdc *pdc)
 {
 	unsigned i = 511, sum = 0;
-	uint32_t *p = (uint32_t*) pdc;
+	uint32_t *p = (uint32_t *) pdc;
 
 	while (i--)
 		sum += *p++;
@@ -115,7 +121,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct pdc *pdc = meta;
 	struct pdc_disk *disk;
@@ -130,8 +137,7 @@
 	CVT32(pdc->raid.magic_1);
 
 	for (disk = pdc->raid.disk;
-	     disk < pdc->raid.disk + pdc->raid.total_disks;
-	     disk++) {
+	     disk < pdc->raid.disk + pdc->raid.total_disks; disk++) {
 		CVT32(disk->magic_0);
 		CVT32(disk->disk_number);
 	}
@@ -139,16 +145,17 @@
 #endif
 
 /* Check for Promis signature. */
-static int is_signature(struct pdc *pdc)
+static int
+is_signature(struct pdc *pdc)
 {
-	return !strncmp((const char*) pdc->promise_id,
+	return !strncmp((const char *) pdc->promise_id,
 			PDC_MAGIC, PDC_ID_LENGTH);
 }
 
 /* Read and try to discover Promise signature. */
-static void *pdc_read_metadata(struct lib_context *lc, struct dev_info *di,
-			       size_t *size, uint64_t *offset,
-			       union read_info *info)
+static void *
+pdc_read_metadata(struct lib_context *lc, struct dev_info *di,
+		  size_t * size, uint64_t * offset, union read_info *info)
 {
 	struct pdc *ret;
 	unsigned ma, sub;
@@ -175,7 +182,7 @@
 		/* Check all sector offsets for metadata signature. */
 		for (; *s && !info->u32; s++) {
 			sector = sub ? di->sectors - *s : *s;
-	
+
 			/* ...and all possible optional metadata signatures. */
 			for (ma = 0;
 			     ma < PDC_MAX_META_AREAS &&
@@ -203,7 +210,7 @@
 			s = begin_sectors;
 	} while (!info->u32 && sub--);
 
-   out:
+      out:
 	/* No metadata signature(s) found. */
 	if (!info->u32) {
 		dbg_free(ret);
@@ -214,7 +221,8 @@
 }
 
 /* Magic check. */
-static int is_pdc(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_pdc(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct pdc *pdc = meta;
 
@@ -226,7 +234,6 @@
 	    pdc->raid.total_disks < PDC_MAXDISKS)
 		return 1;
 
-
 	LOG_ERR(lc, 0, "%s: identifying %s, magic_0: 0x%x/0x%x, "
 		"magic_1: 0x%x/0x%x, total_disks: %u",
 		handler, di->path,
@@ -236,8 +243,9 @@
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *pdc_read(struct lib_context *lc, struct dev_info *di)
-{ 
+static struct raid_dev *
+pdc_read(struct lib_context *lc, struct dev_info *di)
+{
 	return read_raid_dev(lc, di, pdc_read_metadata, 0, 0, to_cpu, is_pdc,
 			     NULL, setup_rd, handler);
 }
@@ -245,7 +253,8 @@
 /*
  * Write a Promise FastTrak RAID device.
  */
-static int pdc_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+static int
+pdc_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -261,14 +270,16 @@
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
-	return (META(RD(new), pdc))->raid.disk_number <
-	       (META(RD(pos), pdc))->raid.disk_number;
+	return META(RD(new), pdc)->raid.disk_number <
+	       META(RD(pos), pdc)->raid.disk_number;
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
 	return !set_number(META(RD_RS(RS(new)), pdc));
 }
@@ -276,46 +287,49 @@
 /*
  * Group the RAID disk into a Promise set.
  */
-static unsigned stride(struct pdc *pdc)
+static unsigned
+stride(struct pdc *pdc)
 {
-	return pdc->raid.raid0_shift ? 1 << pdc->raid.raid0_shift : 0;
+	return pdc->raid.raid0_shift ? (1 << pdc->raid.raid0_shift) : 0;
 }
 
-static void super_created(struct raid_set *super, void *private)
+static void
+super_created(struct raid_set *super, void *private)
 {
-	super->type   = t_raid1;
+	super->type = t_raid1;
 	super->stride = stride(META((private), pdc));
 }
 
 /* Calculate RAID device size in sectors depending on RAID type. */
-static uint64_t sectors(struct raid_dev *rd, unsigned meta_sector)
+static uint64_t
+sectors(struct raid_dev *rd, unsigned meta_sector)
 {
 	struct pdc *pdc = META(rd, pdc);
 
 	switch (pdc->raid.type) {
 	case PDC_T_RAID10:
-               return pdc->raid.total_secs / (pdc->raid.total_disks / 2);
+		return pdc->raid.total_secs / (pdc->raid.total_disks / 2);
 
 	case PDC_T_RAID1:
-               return pdc->raid.total_secs;
+		return pdc->raid.total_secs;
 
 	case PDC_T_RAID0:
-               return pdc->raid.total_secs / pdc->raid.total_disks;
+		return pdc->raid.total_secs / pdc->raid.total_disks;
 
 	case PDC_T_SPAN:
-	       return rd->di->sectors - meta_sector;
+		return rd->di->sectors - meta_sector;
 	}
 
 	return 0;
 }
 
-static struct raid_dev *_create_rd(struct lib_context *lc, struct raid_dev *rd,
-				   struct pdc *pdc, unsigned idx)
+static struct raid_dev *
+_create_rd(struct lib_context *lc, struct raid_dev *rd,
+	   struct pdc *pdc, unsigned idx)
 {
 	struct raid_dev *r;
 
-	if (!is_pdc(lc, rd->di, pdc) ||
-	    !(r = alloc_raid_dev(lc, handler)))
+	if (!is_pdc(lc, rd->di, pdc) || !(r = alloc_raid_dev(lc, handler)))
 		return NULL;
 
 	if ((r->type = type(pdc)) == t_undef) {
@@ -324,7 +338,7 @@
 		goto bad_free;
 	}
 
-        if (!(r->name = _name(lc, pdc, is_raid10(pdc))))
+	if (!(r->name = _name(lc, pdc, is_raid10(pdc))))
 		goto bad_free;
 
 	/* Allocate meta_areas for devices() to work. */
@@ -356,15 +370,16 @@
 
 	log_zero_sectors(lc, r->di->path, handler);
 
-   bad_free:
+      bad_free:
 	free_raid_dev(lc, &r);
-   out:
+      out:
 	return r;
 }
 
 /* Add a PDC RAID device to a set. */
-static int _group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd, struct pdc *pdc)
+static int
+_group_rd(struct lib_context *lc, struct raid_set *rs,
+	  struct raid_set **ss, struct raid_dev *rd, struct pdc *pdc)
 {
 	if (!init_raid_set(lc, rs, rd, stride(pdc), pdc->raid.type, handler))
 		return 0;
@@ -396,7 +411,8 @@
 	return 1;
 }
 
-static inline unsigned count_meta_areas(struct pdc *pdc)
+static inline unsigned
+count_meta_areas(struct pdc *pdc)
 {
 	unsigned r;
 
@@ -410,8 +426,9 @@
 }
 
 /* FIXME: different super sets possible with multiple metadata areas ? */
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	int r;
 	struct pdc *pdc = META(rd, pdc);
@@ -442,7 +459,8 @@
 	return r;
 }
 
-static struct raid_set *pdc_group(struct lib_context *lc, struct raid_dev *rd)
+static struct raid_set *
+pdc_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -461,23 +479,26 @@
  *
  * FIXME: more sanity checks.
  */
-static unsigned devices(struct raid_dev *rd, void *context)
+static unsigned
+devices(struct raid_dev *rd, void *context)
 {
 	struct pdc *pdc = META(rd, pdc);
 
 	if (context && pdc->raid.type != PDC_T_SPAN)
-		*((uint64_t*) context) += rd->sectors;
+		*((uint64_t *) context) += rd->sectors;
 
 	return pdc->raid.total_disks;
 }
 
-static int check_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_dev *rd, void *context)
+static int
+check_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_dev *rd, void *context)
 {
-      return *((uint64_t*) context) >= (META(rd, pdc))->raid.total_secs;
+	return *((uint64_t *) context) >= (META(rd, pdc))->raid.total_secs;
 }
 
-static int pdc_check(struct lib_context *lc, struct raid_set *rs)
+static int
+pdc_check(struct lib_context *lc, struct raid_set *rs)
 {
 	uint64_t total_secs = 0;
 
@@ -494,7 +515,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct pdc *pdc = META(rd, pdc);
@@ -504,19 +526,18 @@
 		return 0;
 
 	PDC_SET_BROKEN(pdc);
-
 	return 1;
 }
 
 static struct event_handlers pdc_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /* Log native information about a Promise RAID device. */
-static void _pdc_log(struct lib_context *lc, struct dev_info *di,
-		     struct pdc *pdc)
+static void
+_pdc_log(struct lib_context *lc, struct dev_info *di, struct pdc *pdc)
 {
 	unsigned i;
 	struct pdc_disk *disk;
@@ -539,7 +560,7 @@
 	DP("raid.device: %u", pdc, pdc->raid.device);
 	DP("raid.magic_0: 0x%x", pdc, pdc->raid.magic_0);
 	P("raid.unknown_1: 0x%x %u",
-	   pdc, pdc->raid.unknown_1, pdc->raid.unknown_1, pdc->raid.unknown_1);
+	  pdc, pdc->raid.unknown_1, pdc->raid.unknown_1, pdc->raid.unknown_1);
 	P("raid.start: 0x%x %u",
 	  pdc, pdc->raid.start, pdc->raid.start, pdc->raid.start);
 	DP("raid.disk_secs: %u", pdc, pdc->raid.disk_secs);
@@ -562,8 +583,7 @@
 	  pdc, pdc->raid.unknown_5, pdc->raid.unknown_5, pdc->raid.unknown_5);
 
 	for (disk = pdc->raid.disk, i = 0;
-	     i < pdc->raid.total_disks;
-	     disk++, i++) {
+	     i < pdc->raid.total_disks; disk++, i++) {
 		P2("raid.disk[%d].unknown_0: 0x%x", pdc, i, disk->unknown_0);
 		P2("raid.disk[%d].channel: %u", pdc, i, disk->channel);
 		P2("raid.disk[%d].device: %u", pdc, i, disk->device);
@@ -572,39 +592,42 @@
 	}
 
 	P("checksum: 0x%x %s", pdc, pdc->checksum, pdc->checksum,
-	   checksum(pdc) ? "Ok" : "BAD");
+	  checksum(pdc) ? "Ok" : "BAD");
 }
 
-static void pdc_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+pdc_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	_pdc_log(lc, rd->di, META(rd, pdc));
 }
 #endif
 
 static struct dmraid_format pdc_format = {
-	.name	= HANDLER,
-	.descr	= "Promise FastTrack",
-	.caps	= "S,0,1,10",
+	.name = HANDLER,
+	.descr = "Promise FastTrack",
+	.caps = "S,0,1,10",
 	.format = FMT_RAID,
-	.read	= pdc_read,
-	.write	= pdc_write,
-	.group	= pdc_group,
-	.check	= pdc_check,
-	.events	= &pdc_event_handlers,
+	.read = pdc_read,
+	.write = pdc_write,
+	.group = pdc_group,
+	.check = pdc_check,
+	.events = &pdc_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= pdc_log,
+	.log = pdc_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_pdc(struct lib_context *lc)
+int
+register_pdc(struct lib_context *lc)
 {
 	return register_format_handler(lc, &pdc_format);
 }
 
 /* Set the RAID device contents up derived from the PDC ones */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	unsigned meta_sector;
 	struct pdc *pdc = meta;
@@ -620,7 +643,7 @@
 	rd->meta_areas->size = sizeof(*pdc);
 	rd->meta_areas->area = pdc;
 
-        rd->di = di;
+	rd->di = di;
 	rd->fmt = &pdc_format;
 	rd->status = status(pdc);
 
@@ -634,5 +657,5 @@
 	if (!(rd->sectors = sectors(rd, meta_sector)))
 		return log_zero_sectors(lc, di->path, handler);
 
-        return (rd->name = _name(lc, pdc, is_raid10(pdc))) ? 1 : 0;
+	return (rd->name = _name(lc, pdc, is_raid10(pdc))) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/pdc.h	2008/04/02 13:35:31	1.2
+++ dmraid/lib/format/ataraid/pdc.h	2008/06/20 21:52:17	1.3
@@ -29,54 +29,54 @@
 	uint8_t promise_id[PDC_ID_LENGTH];	/* 0x00 - 0x17 */
 #define PDC_MAGIC        "Promise Technology, Inc."
 
-	uint32_t unknown_0;			/* 0x18 - 0x1B */
-	uint32_t magic_0;			/* 0x1C - 0x1F */
-	uint32_t unknown_1;			/* 0x20 - 0x23 */
-	uint32_t magic_1;			/* 0x24 - 0x27 */
-	uint16_t unknown_2;			/* 0x28 - 0x2B */
-	uint8_t filler1[470];			/* 0x2C - 0x1FF */
+	uint32_t unknown_0;	/* 0x18 - 0x1B */
+	uint32_t magic_0;	/* 0x1C - 0x1F */
+	uint32_t unknown_1;	/* 0x20 - 0x23 */
+	uint32_t magic_1;	/* 0x24 - 0x27 */
+	uint16_t unknown_2;	/* 0x28 - 0x2B */
+	uint8_t filler1[470];	/* 0x2C - 0x1FF */
 	struct {
-		uint32_t flags;			/* 0x200 - 0x203 */
-		uint8_t unknown_0;		/* 0x204 */
-		uint8_t disk_number;		/* 0x205 */
-		uint8_t channel;		/* 0x206 */
-		uint8_t device;			/* 0x207 */
-		uint32_t magic_0;		/* 0x208 - 0x20B */
-		uint32_t unknown_1;		/* 0x20C - 0x20F */
-		// uint32_t unknown_2;		/* 0x210 - 0x213 */
-		uint32_t start;			/* 0x210 - 0x213 */
-		uint32_t disk_secs;		/* 0x214 - 0x217 */
-		uint32_t unknown_3;		/* 0x218 - 0x21B */
-		uint16_t unknown_4;		/* 0x21C - 0x21D */
-		uint8_t status;			/* 0x21E */
+		uint32_t flags;	/* 0x200 - 0x203 */
+		uint8_t unknown_0;	/* 0x204 */
+		uint8_t disk_number;	/* 0x205 */
+		uint8_t channel;	/* 0x206 */
+		uint8_t device;	/* 0x207 */
+		uint32_t magic_0;	/* 0x208 - 0x20B */
+		uint32_t unknown_1;	/* 0x20C - 0x20F */
+		// uint32_t unknown_2;          /* 0x210 - 0x213 */
+		uint32_t start;	/* 0x210 - 0x213 */
+		uint32_t disk_secs;	/* 0x214 - 0x217 */
+		uint32_t unknown_3;	/* 0x218 - 0x21B */
+		uint16_t unknown_4;	/* 0x21C - 0x21D */
+		uint8_t status;	/* 0x21E */
 /* FIXME: bit 0x80 doesn't seem to indicate error as previously assumed. */
-// #define	PDC_BROKEN(pdc)		((pdc)->raid.status &  0x80)
+// #define      PDC_BROKEN(pdc)         ((pdc)->raid.status &  0x80)
 #define	PDC_BROKEN(pdc)		((pdc)->raid.status &  0x00)
 #define	PDC_SET_BROKEN(pdc)	((pdc)->raid.status |= 0x80)
-		uint8_t type;			/* 0x21F */
+		uint8_t type;	/* 0x21F */
 #define	PDC_T_RAID0	0x0
 #define	PDC_T_RAID1	0x1
 #define	PDC_T_SPAN	0x8
-		uint8_t total_disks;		/* 0x220 */
-		uint8_t raid0_shift;		/* 0x221 */
-		uint8_t raid0_disks;		/* 0x222 */
-		uint8_t array_number;		/* 0x223 */
-		uint32_t total_secs;		/* 0x224 - 0x227 */
-		uint16_t cylinders;		/* 0x228 - 0x229 */
-		uint8_t heads;			/* 0x22A */
-		uint8_t sectors;		/* 0x22B */
-		uint32_t magic_1;		/* 0x22C - 0x2EF */
-		uint32_t unknown_5;		/* 0x230 - 0x233 */
+		uint8_t total_disks;	/* 0x220 */
+		uint8_t raid0_shift;	/* 0x221 */
+		uint8_t raid0_disks;	/* 0x222 */
+		uint8_t array_number;	/* 0x223 */
+		uint32_t total_secs;	/* 0x224 - 0x227 */
+		uint16_t cylinders;	/* 0x228 - 0x229 */
+		uint8_t heads;	/* 0x22A */
+		uint8_t sectors;	/* 0x22B */
+		uint32_t magic_1;	/* 0x22C - 0x2EF */
+		uint32_t unknown_5;	/* 0x230 - 0x233 */
 		struct pdc_disk {
 			uint16_t unknown_0;	/* 0x234 - 0x235 */
 			uint8_t channel;	/* 0x236 */
-			uint8_t device;		/* 0x237 */
+			uint8_t device;	/* 0x237 */
 			uint32_t magic_0;	/* 0x238 - 0x23B */
 			uint32_t disk_number;	/* 0x23C - 0x23F */
 		} disk[8];
 	} raid;
 
-	uint32_t filler2[346];			/* 0x294 - */
+	uint32_t filler2[346];	/* 0x294 - */
 	uint32_t checksum;
 } __attribute__ ((packed));
 
--- dmraid/lib/format/ataraid/sil.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/sil.c	2008/06/20 21:52:17	1.3
@@ -22,19 +22,20 @@
 
 /* Make up RAID device name from some 'magic' numbers */
 /* FIXME: better name ? */
-static size_t _name(struct sil *sil, char *str, size_t len, unsigned int subset)
+static size_t
+_name(struct sil *sil, char *str, size_t len, unsigned int subset)
 {
 	return snprintf(str, len,
 			subset ? "sil_%02u%02u%02u%02u%02u%02u-%u" :
-				 "sil_%02u%02u%02u%02u%02u%02u",
+			"sil_%02u%02u%02u%02u%02u%02u",
 			sil->year, sil->month, sil->day,
 			sil->hour, sil->minutes % 60, sil->seconds % 60,
 			sil->type == SIL_T_RAID1 ? sil->mirrored_set_number :
-						   sil->striped_set_number);
+			sil->striped_set_number);
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	size_t len;
 	char *ret;
@@ -45,7 +46,8 @@
 		_name(sil, ret, len, subset);
 		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
 			 (strrchr(ret, '-') ? 3 : 1));
-	} else
+	}
+	else
 		log_alloc_err(lc, handler);
 
 	return ret;
@@ -55,43 +57,46 @@
  * Retrieve status of device.
  * FIXME: is this sufficient to cover all state ?
  */
-static enum status status(struct sil *sil)
+static enum status
+status(struct sil *sil)
 {
 	struct states states[] = {
-		{ SIL_OK, s_ok },
-		{ SIL_MIRROR_SYNC, s_ok },
-		{ SIL_MIRROR_NOSYNC, s_nosync },
-		{ 0, s_broken },
+		{SIL_OK, s_ok},
+		{SIL_MIRROR_SYNC, s_ok},
+		{SIL_MIRROR_NOSYNC, s_nosync},
+		{0, s_broken},
 	};
 
 	return rd_status(states, sil->mirrored_set_state, EQUAL);
 }
 
 /* Neutralize disk type */
-static enum type type(struct sil *sil)
+static enum type
+type(struct sil *sil)
 {
 	/* Mapping of SIL 680 types to generic types */
 	static struct types types[] = {
-	        { SIL_T_SPARE,  t_spare},
-	        { SIL_T_JBOD,   t_linear},
-	        { SIL_T_RAID0,  t_raid0},
-	        { SIL_T_RAID5, 	t_raid5_ls},
-	        { SIL_T_RAID1,  t_raid1},
-	        { SIL_T_RAID10, t_raid0},
-	        { 0,            t_undef}
+		{SIL_T_SPARE, t_spare},
+		{SIL_T_JBOD, t_linear},
+		{SIL_T_RAID0, t_raid0},
+		{SIL_T_RAID5, t_raid5_ls},
+		{SIL_T_RAID1, t_raid1},
+		{SIL_T_RAID10, t_raid0},
+		{0, t_undef}
 	};
 
 	return rd_type(types, (unsigned int) sil->type);
 }
 
 /* Calculate checksum on metadata */
-static int checksum(struct sil *sil)
+static int
+checksum(struct sil *sil)
 {
 	int sum = 0;
-	unsigned int count = struct_offset(sil, checksum1) / 2;
-	uint16_t *p = (uint16_t*) sil;
+	unsigned short count = struct_offset(sil, checksum1) / 2;
+	uint16_t *p = (uint16_t *) sil;
 
-        while (count--)
+	while (count--)
 		sum += *p++;
 
 	return (-sum & 0xFFFF) == sil->checksum1;
@@ -104,7 +109,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct sil *sil = meta;
 
@@ -128,13 +134,15 @@
 #define	AREAS	4
 #define SIL_META_AREA(i)	(SIL_CONFIGOFFSET - (i * 512 << 9))
 
-static inline int is_sil(struct sil *sil)
+static inline int
+is_sil(struct sil *sil)
 {
 	return SIL_MAGIC_OK(sil) && sil->disk_number < 8;
 }
 
-static int sil_valid(struct lib_context *lc, struct dev_info *di,
-		     void *meta, unsigned int area)
+static int
+sil_valid(struct lib_context *lc, struct dev_info *di,
+	  void *meta, unsigned int area)
 {
 	struct sil *sil = meta;
 
@@ -158,7 +166,8 @@
 	return 1;
 }
 
-static void free_sils(struct sil **sils, unsigned int i)
+static void
+free_sils(struct sil **sils, unsigned int i)
 {
 	for (; i < AREAS; i++)
 		dbg_free(sils[i]);
@@ -166,9 +175,9 @@
 	dbg_free(sils);
 }
 
-static void *sil_read_metadata(struct lib_context *lc, struct dev_info *di,
-			       size_t *size, uint64_t *offset,
-			       union read_info *info)
+static void *
+sil_read_metadata(struct lib_context *lc, struct dev_info *di,
+		  size_t * size, uint64_t * offset, union read_info *info)
 {
 	unsigned int i, valid;
 	char str[9] = { 0, };
@@ -190,8 +199,9 @@
 		if (sil_valid(lc, di, sil, i + 1)) {
 			sils[valid] = sil;
 			sprintf(&str[strlen(str)], "%s%u",
-			        valid++ ? "," : "", i + 1);
-		} else
+				valid++ ? "," : "", i + 1);
+		}
+		else
 			dbg_free(sil);
 	}
 
@@ -201,21 +211,23 @@
 			   valid == 1 ? "is" : "are");
 		goto out;
 	}
-	
-   bad:
+
+      bad:
 	free_sils(sils, 0);
 	sils = NULL;
 
-   out:
-	return (void*) sils;
+      out:
+	return (void *) sils;
 }
 
-static int _file_name(char *str, size_t len, char *n, int i)
+static int
+_file_name(char *str, size_t len, char *n, int i)
 {
 	return snprintf(str, len, "%s_%d", n, i) + 1;
 }
 
-static char *file_name(struct lib_context *lc, char *n, int i)
+static char *
+file_name(struct lib_context *lc, char *n, int i)
 {
 	size_t len;
 	char *ret;
@@ -229,13 +241,13 @@
 }
 
 /* File all metadata areas. */
-static void sil_file_metadata(struct lib_context *lc, struct dev_info *di,
-			      void *meta)
+static void
+sil_file_metadata(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	unsigned int i;
 	char *n;
 	struct sil **sils = meta;
-	
+
 	for (i = 0; i < AREAS; i++) {
 		if (!(n = file_name(lc, di->path, i)))
 			break;
@@ -250,7 +262,8 @@
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *sil_read(struct lib_context *lc, struct dev_info *di)
+static struct raid_dev *
+sil_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, sil_read_metadata, 0, 0, NULL, NULL,
 			     sil_file_metadata, setup_rd, handler);
@@ -260,7 +273,8 @@
 /*
  * Write a Silicon Image RAID device.
  */
-static int sil_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+static int
+sil_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -276,17 +290,19 @@
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	return (META(RD(new), sil))->disk_number <
-	       (META(RD(pos), sil))->disk_number;
+		(META(RD(pos), sil))->disk_number;
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
 	return (META(RD_RS(RS(new)), sil))->mirrored_set_number <
-	       (META(RD_RS(RS(pos)), sil))->mirrored_set_number;
+		(META(RD_RS(RS(pos)), sil))->mirrored_set_number;
 }
 
 /*
@@ -294,15 +310,17 @@
  *
  * Check device hierarchy and create super set appropriately.
  */
-static void super_created(struct raid_set *ss, void *private)
+static void
+super_created(struct raid_set *ss, void *private)
 {
-	ss->type   = t_raid1;
+	ss->type = t_raid1;
 	ss->stride = META(private, sil)->raid0_stride;
 }
 
 /* FIXME: handle spares. */
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	struct sil *sil = META(rd, sil);
 
@@ -336,7 +354,8 @@
 }
 
 /* Add a SIL RAID device to a set */
-static struct raid_set *sil_group(struct lib_context *lc, struct raid_dev *rd)
+static struct raid_set *
+sil_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -355,7 +374,8 @@
  *
  * FIXME: more sanity checks.
  */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
 	int ret;
 	struct sil *sil = META(rd, sil);
@@ -377,7 +397,8 @@
 	return ret;
 }
 
-static int sil_check(struct lib_context *lc, struct raid_set *rs)
+static int
+sil_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, devices, NULL,
 			      NO_CHECK_RD, NULL, handler);
@@ -386,7 +407,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct sil *sil = META(rd, sil);
@@ -402,14 +424,15 @@
 
 static struct event_handlers sil_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about a Silicon Image  RAID device.
  */
-static void sil_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+sil_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	char *tt;
 	struct sil *sil = META(rd, sil);
@@ -464,46 +487,49 @@
 #endif
 
 static struct dmraid_format sil_format = {
-	.name	= HANDLER,
-	.descr	= "Silicon Image(tm) Medley(tm)",
-	.caps	= "0,1,10",
+	.name = HANDLER,
+	.descr = "Silicon Image(tm) Medley(tm)",
+	.caps = "0,1,10",
 	.format = FMT_RAID,
-	.read	= sil_read,
-	.write	= sil_write,
-	.group	= sil_group,
-	.check	= sil_check,
-	.events	= &sil_event_handlers,
+	.read = sil_read,
+	.write = sil_write,
+	.group = sil_group,
+	.check = sil_check,
+	.events = &sil_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= sil_log,
+	.log = sil_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_sil(struct lib_context *lc)
+int
+register_sil(struct lib_context *lc)
 {
 	return register_format_handler(lc, &sil_format);
 }
 
 /* Set the RAID device contents up derived from the SIL ones. */
-static int stripes(struct sil *sil)
+static int
+stripes(struct sil *sil)
 {
 	return sil->drives_per_striped_set > -1 &&
-	       sil->disk_number < sil->drives_per_striped_set;
+		sil->disk_number < sil->drives_per_striped_set;
 }
 
-static uint64_t sectors(struct raid_dev *rd)
+static uint64_t
+sectors(struct raid_dev *rd)
 {
 	uint64_t array_sectors, ret = 0;
 	struct sil *sil = META(rd, sil);
 
 	array_sectors = (((uint64_t) sil->array_sectors_high) << 32) +
-			 sil->array_sectors_low;
+		sil->array_sectors_low;
 
 	switch (sil->type) {
 	case SIL_T_SPARE:
 		/* Cook them up... */
 		ret = rd->di->sectors - (AREAS - 1) * 512 -
-		      ((rd->di->sectors & 1) ? 1 : 2);
+			((rd->di->sectors & 1) ? 1 : 2);
 		break;
 
 	case SIL_T_RAID0:
@@ -519,7 +545,7 @@
 	default:
 		/* Cook them up... */
 		ret = rd->di->sectors - (AREAS - 1) * 512 -
-		      ((rd->di->sectors & 1) ? 1 : 2);
+			((rd->di->sectors & 1) ? 1 : 2);
 		break;
 	}
 
@@ -527,19 +553,19 @@
 }
 
 /* Quorate SIL metadata copies. */
-static struct sil *quorate(struct lib_context *lc, struct dev_info *di,
-			   struct sil *sils[])
+static struct sil *
+quorate(struct lib_context *lc, struct dev_info *di, struct sil *sils[])
 {
 	unsigned int areas = 0, i, ident = 0, j;
 	struct sil *sil = NULL, *tmp;
-	
+
 	/* Count valid metadata areas. */
 	while (areas < AREAS && sils[areas])
 		areas++;
 
 	if (areas != AREAS)
 		log_err(lc, "%s: only %u/%u metadata areas found on "
-			    "%s, %sing...",
+			"%s, %sing...",
 			handler, areas, AREAS, di->path,
 			areas > 1 ? "elect" : "pick");
 
@@ -551,7 +577,7 @@
 		}
 
 		if (ident > areas / 2);
-			break;
+		break;
 	}
 
 	if (ident) {
@@ -563,8 +589,9 @@
 	return sil;
 }
 
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	unsigned int i;
 	struct meta_areas *ma;
@@ -573,13 +600,13 @@
 	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, AREAS)))
 		goto bad;
 
-	sil = quorate(lc, di, sils);	/* Quorate one copy+save a pointer.*/
-	free_sils(sils, 1);		/* Free the other copies. */
+	sil = quorate(lc, di, sils);	/* Quorate one copy+save a pointer. */
+	free_sils(sils, 1);	/* Free the other copies. */
 
 	for (i = 0, ma = rd->meta_areas; i < rd->areas; i++, ma++) {
 		ma->offset = SIL_META_AREA(i) >> 9;
 		ma->size = sizeof(*sil);
-		ma->area = (void*) sil;
+		ma->area = (void *) sil;
 	}
 
 	rd->di = di;
@@ -590,11 +617,11 @@
 		return log_zero_sectors(lc, di->path, handler);
 
 	rd->status = status(sil);
-	rd->type   = type(sil);
+	rd->type = type(sil);
 
-        return (rd->name = name(lc, rd, sil->type == SIL_T_RAID10)) ? 1 : 0;
+	return (rd->name = name(lc, rd, sil->type == SIL_T_RAID10)) ? 1 : 0;
 
-   bad:
+      bad:
 	free_sils(sils, 0);
 
 	return 0;
--- dmraid/lib/format/ataraid/sil.h	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/sil.h	2008/06/20 21:52:17	1.3
@@ -14,64 +14,64 @@
 #include <stdint.h>
 
 #define SIL_CONFIGOFFSET        ((di->sectors - 1) << 9)
-#define SIL_DATAOFFSET          0       /* Data offset in sectors */
+#define SIL_DATAOFFSET          0	/* Data offset in sectors */
 
 struct sil {
-        uint8_t	unknown0[0x2E];		/* 0x4 - 0x2D */
-        uint8_t	ascii_version[0x36 - 0x2E];/* 0x2E - 0x35 */
-	int8_t		diskname[0x56 - 0x36];	/* 0x36 - 0x55 */
-	int8_t		unknown1[0x60 - 0x56];	/* 0x56 - 0x59 */	
-	uint32_t	magic;			/* 0x60 - 0x63 */
+	uint8_t unknown0[0x2E];	/* 0x4 - 0x2D */
+	uint8_t ascii_version[0x36 - 0x2E];	/* 0x2E - 0x35 */
+	int8_t diskname[0x56 - 0x36];	/* 0x36 - 0x55 */
+	int8_t unknown1[0x60 - 0x56];	/* 0x56 - 0x59 */
+	uint32_t magic;		/* 0x60 - 0x63 */
 #define	SIL_MAGIC	0x3000000
 #define	SIL_MAGIC_OK(sil)	((sil->magic & 0x3ffffff) == SIL_MAGIC)
-	int8_t		unknown1a[0x6C - 0x64];	/* 0x64 - 0x6B */	
-	uint32_t	array_sectors_low;	/* 0x6C - 0x6F */
-	uint32_t	array_sectors_high;	/* 0x70 - 0x73 */
-	int8_t		unknown2[0x78 - 0x74];	/* 0x74 - 0x77 */
-	uint32_t	thisdisk_sectors;	/* 0x78 - 0x7B */
-	int8_t		unknown3[0x100 - 0x7C];	/* 0x7C - 0xFF */
-	int8_t		unknown4[0x104 - 0x100];/* 0x100 - 0x103 */
-	uint16_t	product_id;		/* 0x104 + 0x105 */
-	uint16_t	vendor_id;		/* 0x106 + 0x107 */
-        uint16_t	minor_ver;		/* 0x108 + 0x109 */
-        uint16_t	major_ver;		/* 0x10A + 0x10B */
-	uint8_t	seconds;		/* 0x10C */
-	uint8_t	minutes;		/* 0x10D */
-	uint8_t	hour;			/* 0x10E */
-	uint8_t	day;			/* 0x10F */
-	uint8_t	month;			/* 0x110 */
-	uint8_t	year;			/* 0x111 */
-	uint16_t	raid0_stride;		/* 0x112 + 0x113 */
-	int8_t		unknown6[0x116 - 0x114];/* 0x114 + 0x115 */
-	uint8_t	disk_number;		/* 0x116 */
-	uint8_t	type;			/* 0x117 */
+	int8_t unknown1a[0x6C - 0x64];	/* 0x64 - 0x6B */
+	uint32_t array_sectors_low;	/* 0x6C - 0x6F */
+	uint32_t array_sectors_high;	/* 0x70 - 0x73 */
+	int8_t unknown2[0x78 - 0x74];	/* 0x74 - 0x77 */
+	uint32_t thisdisk_sectors;	/* 0x78 - 0x7B */
+	int8_t unknown3[0x100 - 0x7C];	/* 0x7C - 0xFF */
+	int8_t unknown4[0x104 - 0x100];	/* 0x100 - 0x103 */
+	uint16_t product_id;	/* 0x104 + 0x105 */
+	uint16_t vendor_id;	/* 0x106 + 0x107 */
+	uint16_t minor_ver;	/* 0x108 + 0x109 */
+	uint16_t major_ver;	/* 0x10A + 0x10B */
+	uint8_t seconds;	/* 0x10C */
+	uint8_t minutes;	/* 0x10D */
+	uint8_t hour;		/* 0x10E */
+	uint8_t day;		/* 0x10F */
+	uint8_t month;		/* 0x110 */
+	uint8_t year;		/* 0x111 */
+	uint16_t raid0_stride;	/* 0x112 + 0x113 */
+	int8_t unknown6[0x116 - 0x114];	/* 0x114 + 0x115 */
+	uint8_t disk_number;	/* 0x116 */
+	uint8_t type;		/* 0x117 */
 #define	SIL_T_RAID0	0
 #define	SIL_T_RAID1	1
 #define	SIL_T_RAID10	2
 #define	SIL_T_RAID5	16
 #define	SIL_T_SPARE	3
 #define	SIL_T_JBOD	255
-	int8_t		drives_per_striped_set;	/* 0x118 */
-	int8_t		striped_set_number;	/* 0x119 */
-        int8_t		drives_per_mirrored_set;/* 0x11A */
-        int8_t		mirrored_set_number;	/* 0x11B */
-	uint32_t	rebuild_ptr_low;	/* 0x11C - 0x12F */
-	uint32_t	rebuild_ptr_high;	/* 0x120 - 0x123 */
-	uint32_t	incarnation_no;		/* 0x124 - 0x127 */
-        uint8_t	member_status;		/* 0x128 */
-        uint8_t	mirrored_set_state;	/* 0x129 */
+	int8_t drives_per_striped_set;	/* 0x118 */
+	int8_t striped_set_number;	/* 0x119 */
+	int8_t drives_per_mirrored_set;	/* 0x11A */
+	int8_t mirrored_set_number;	/* 0x11B */
+	uint32_t rebuild_ptr_low;	/* 0x11C - 0x12F */
+	uint32_t rebuild_ptr_high;	/* 0x120 - 0x123 */
+	uint32_t incarnation_no;	/* 0x124 - 0x127 */
+	uint8_t member_status;	/* 0x128 */
+	uint8_t mirrored_set_state;	/* 0x129 */
 #define	SIL_OK			0
 #define	SIL_MIRROR_NOSYNC	1
 #define	SIL_MIRROR_SYNC		2
-        uint8_t	reported_device_location;/* 0x12A */
-        uint8_t	idechannel;		/* 0x12B */
-        uint8_t	auto_rebuild;		/* 0x12C */
+	uint8_t reported_device_location;	/* 0x12A */
+	uint8_t idechannel;	/* 0x12B */
+	uint8_t auto_rebuild;	/* 0x12C */
 #define	SIL_MIRROR_NOAUTOREBUILD	0
-	uint8_t		unknown8;		/* 0x12D */
-	uint8_t		text_type[0x13E - 0x12E]; /* 0x12E - 0x13D */
-	uint16_t	checksum1;		/* 0x13E + 0x13F */	
-	int8_t		assumed_zeros[0x1FE - 0x140];/* 0x140 - 0x1FD */
-	uint16_t	checksum2;		/* 0x1FE + 0x1FF */
+	uint8_t unknown8;	/* 0x12D */
+	uint8_t text_type[0x13E - 0x12E];	/* 0x12E - 0x13D */
+	uint16_t checksum1;	/* 0x13E + 0x13F */
+	int8_t assumed_zeros[0x1FE - 0x140];	/* 0x140 - 0x1FD */
+	uint16_t checksum2;	/* 0x1FE + 0x1FF */
 } __attribute__ ((packed));
 #endif
 
--- dmraid/lib/format/ataraid/via.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/via.c	2008/06/20 21:52:17	1.3
@@ -21,16 +21,18 @@
 
 static const char *handler = HANDLER;
 
-static int _subset(struct via *via)
+static int
+_subset(struct via *via)
 {
 	return VIA_T_RAID01_MIRROR(via);
 }
 
 /* Make up VIA RAID device name suffix from the serial_checksum array. */
-static uint32_t sum_serial(struct via *via)
+static uint32_t
+sum_serial(struct via *via)
 {
 	unsigned int i = VIA_MAX_DISKS;
-	uint32_t ret = via->array.disk_array_ex; /* FIXME: correct ? */
+	uint32_t ret = via->array.disk_array_ex;	/* FIXME: correct ? */
 
 	while (i--)
 		ret += via->serial_checksum[i];
@@ -38,7 +40,8 @@
 	return ret;
 }
 
-static char *_name_suffix(struct via *via)
+static char *
+_name_suffix(struct via *via)
 {
 	size_t len;
 	uint32_t sum = sum_serial(via);
@@ -51,15 +54,16 @@
 }
 
 /* Make up RAID device name. */
-static size_t _name(struct lib_context *lc, struct via *via, char *str,
-		     size_t len, char *suffix, unsigned int subset)
+static size_t
+_name(struct lib_context *lc, struct via *via, char *str,
+      size_t len, char *suffix, unsigned int subset)
 {
 	return snprintf(str, len,
 			subset ? "via_%s-%u" : "via_%s", suffix, _subset(via));
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	size_t len;
 	char *ret, *suffix;
@@ -74,7 +78,8 @@
 		_name(lc, via, ret, len, suffix, subset);
 		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
 			 (subset ? 3 : 1));
-	} else
+	}
+	else
 		log_alloc_err(lc, handler);
 
 	dbg_free(suffix);
@@ -86,7 +91,8 @@
  * Retrieve status of device.
  * FIXME: is this sufficient to cover all state ?
  */
-static enum status status(struct via *via)
+static enum status
+status(struct via *via)
 {
 	if (via->array.disk.tolerance)
 		return s_broken;
@@ -95,15 +101,16 @@
 }
 
 /* Neutralize disk type using generic metadata type mapping function */
-static enum type type(struct via *via)
+static enum type
+type(struct via *via)
 {
 	/* Mapping of via types to generic types */
 	static struct types types[] = {
-		{ VIA_T_SPAN,  t_linear },
-		{ VIA_T_RAID0, t_raid0 },
-		{ VIA_T_RAID1, t_raid1 },
-		{ VIA_T_RAID01, t_raid0 },
-	        { 0, t_undef}
+		{VIA_T_SPAN, t_linear},
+		{VIA_T_RAID0, t_raid0},
+		{VIA_T_RAID1, t_raid1},
+		{VIA_T_RAID01, t_raid0},
+		{0, t_undef}
 	};
 
 	return rd_type(types, (unsigned int) VIA_RAID_TYPE(via));
@@ -116,7 +123,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct via *via = meta;
 	unsigned int i = VIA_MAX_DISKS;
@@ -134,17 +142,19 @@
 #endif
 
 /* 8 bit checksum on first 50 bytes of metadata. */
-static uint8_t checksum(struct via *via)
+static uint8_t
+checksum(struct via *via)
 {
 	uint8_t i = 50, sum = 0;
-	
+
 	while (i--)
-		sum += ((uint8_t*) via)[i];
+		sum += ((uint8_t *) via)[i];
 
 	return sum == via->checksum;
 }
 
-static int is_via(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_via(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct via *via = meta;
 
@@ -157,13 +167,14 @@
 	if (via->version_number > 1)
 		log_info(lc, "%s: version %u; format handler specified for "
 			 "version 0+1 only", handler, via->version_number);
-	
+
 	return 1;
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *via_read(struct lib_context *lc, struct dev_info *di)
+static struct raid_dev *
+via_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
 			     sizeof(struct via), VIA_CONFIGOFFSET,
@@ -171,7 +182,8 @@
 }
 
 /* Decide about ordering sequence of RAID device. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	struct via *p = META(RD(pos), via);
 	struct via *n = META(RD(new), via);
@@ -180,27 +192,30 @@
 	case VIA_T_RAID1:
 		return VIA_T_RAID1_SOURCE(n);
 
-	default: /* span, RAID0 + RAID01 */
+	default:		/* span, RAID0 + RAID01 */
 		return VIA_T_RAID_INDEX(n) < VIA_T_RAID_INDEX(p);
 	}
 }
 
 /* Decide about ordering sequence of RAID subset. */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
 	return _subset(META(RD_RS(RS(new)), via)) <
-	       _subset(META(RD_RS(RS(pos)), via));
+		_subset(META(RD_RS(RS(pos)), via));
 }
 
-static void super_created(struct raid_set *ss, void *private)
+static void
+super_created(struct raid_set *ss, void *private)
 {
 	ss->type = t_raid1;
 	ss->stride = VIA_STRIDE(META(private, via));
 }
 
 /* FIXME: handle spares in mirrors and check that types are correct. */
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+static int
+group_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_set **ss, struct raid_dev *rd)
 {
 	struct via *via = META(rd, via);
 
@@ -230,8 +245,8 @@
 }
 
 /* Add a VIA RAID device to a set */
-static struct raid_set *via_group(struct lib_context *lc,
-					 struct raid_dev *rd)
+static struct raid_set *
+via_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
 
@@ -245,7 +260,8 @@
 	return NULL;
 }
 
-static int via_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+static int
+via_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -267,15 +283,17 @@
  * FIXME: more sanity checks.
  */
 /* Figure total number of disks depending on RAID type. */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
 	struct via *via = META(rd, via);
 
 	return VIA_RAID_TYPE(via) == VIA_T_RAID1 ? 2 : VIA_RAID_DISKS(via);
 }
 
-static int check_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_dev *rd, void *context)
+static int
+check_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_dev *rd, void *context)
 {
 	struct via *via = META(rd, via);
 
@@ -291,7 +309,8 @@
 	return 1;
 }
 
-static int via_check(struct lib_context *lc, struct raid_set *rs)
+static int
+via_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, devices, NULL, check_rd, NULL, handler);
 }
@@ -299,7 +318,8 @@
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
 	struct via *via = META(rd, via);
@@ -315,7 +335,7 @@
 
 static struct event_handlers via_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 
@@ -323,7 +343,8 @@
 /*
  * Log native information about the RAID device.
  */
-static void via_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+via_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	unsigned int i;
 	struct via *via = META(rd, via);
@@ -337,8 +358,7 @@
 	  via->array.disk.enable_enhanced);
 	P("array.disk.in_disk_array: %u", via, via->array.disk,
 	  via->array.disk.in_disk_array);
-	P("array.disk.raid_type: %u", via, via->array.disk,
-	  VIA_RAID_TYPE(via));
+	P("array.disk.raid_type: %u", via, via->array.disk, VIA_RAID_TYPE(via));
 	P("array.disk.array_index: %u", via, via->array.disk,
 	  VIA_ARRAY_INDEX(via));
 
@@ -366,28 +386,30 @@
 #endif
 
 static struct dmraid_format via_format = {
-	.name	= HANDLER,
-	.descr	= "VIA Software RAID",
-	.caps	= "S,0,1,10",
+	.name = HANDLER,
+	.descr = "VIA Software RAID",
+	.caps = "S,0,1,10",
 	.format = FMT_RAID,
-	.read	= via_read,
-	.write	= via_write,
-	.group	= via_group,
-	.check	= via_check,
-	.events	= &via_event_handlers,
+	.read = via_read,
+	.write = via_write,
+	.group = via_group,
+	.check = via_check,
+	.events = &via_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= via_log,
+	.log = via_log,
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_via(struct lib_context *lc)
+int
+register_via(struct lib_context *lc)
 {
 	return register_format_handler(lc, &via_format);
 }
 
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct via *via = meta;
 
@@ -396,17 +418,17 @@
 
 	rd->meta_areas->offset = VIA_CONFIGOFFSET >> 9;
 	rd->meta_areas->size = sizeof(*via);
-	rd->meta_areas->area = (void*) via;
+	rd->meta_areas->area = (void *) via;
 
-        rd->di = di;
+	rd->di = di;
 	rd->fmt = &via_format;
 
 	rd->status = status(via);
-	rd->type   = type(via);
+	rd->type = type(via);
 
 	rd->offset = VIA_DATAOFFSET;
 	if (!(rd->sectors = rd->meta_areas->offset))
 		return log_zero_sectors(lc, di->path, handler);
 
-        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+	return (rd->name = name(lc, rd, 1)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/via.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/via.h	2008/06/20 21:52:17	1.2
@@ -19,18 +19,18 @@
 #define	VIA_MAX_DISKS		8
 
 struct disk {
-	uint16_t	bootable:1;		/* BIOS boot */
-	uint16_t	enable_enhanced:1;	/* Unused */
-	uint16_t	in_disk_array:1;	/* Used/Spare */
-	uint16_t	raid_type:4;
+	uint16_t bootable:1;	/* BIOS boot */
+	uint16_t enable_enhanced:1;	/* Unused */
+	uint16_t in_disk_array:1;	/* Used/Spare */
+	uint16_t raid_type:4;
 #define	VIA_T_RAID0	0
 #define	VIA_T_RAID1	1
 #define	VIA_T_SPAN	8
 #define	VIA_T_RAID01	9
 #define VIA_RAID_TYPE(x)	((x)->array.disk.raid_type)
-	uint16_t	array_index:3;
+	uint16_t array_index:3;
 #define VIA_ARRAY_INDEX(x)	((x)->array.disk.array_index)
-	uint16_t	raid_type_info:5;
+	uint16_t raid_type_info:5;
 /* SPAN + RAID 0 */
 #define	VIA_T_RAID_INDEX(x) ((x)->array.disk.raid_type_info & 0x7)
 
@@ -41,33 +41,33 @@
 #define	VIA_T_RAID1_DIRTY(x)  (((x)->array.disk.raid_type_info & 0x4) >> 2)
 
 /* RAID 0+1 */
-// #define	VIA_T_RAID01_INDEX(x)	VIA_T_RAID_INDEX(x)
+// #define      VIA_T_RAID01_INDEX(x)   VIA_T_RAID_INDEX(x)
 #define	VIA_T_RAID01_MIRROR(x)	(((x)->array.disk.raid_type_info & 0x8) >> 3)
 #define	VIA_T_RAID01_DIRTY(x)	(((x)->array.disk.raid_type_info & 0x10) >> 4)
 
 /* SPAN */
 #define	VIA_T_SPAN_INDEX(x)	((x)->array.disk.raid_type_info & 0x7)
-	uint16_t	tolerance:1;
+	uint16_t tolerance:1;
 } __attribute__ ((packed));
 
 struct array {
-	struct disk	disk;
-	uint8_t		disk_array_ex;
+	struct disk disk;
+	uint8_t disk_array_ex;
 #define	VIA_RAID_DISKS(x)	((x)->array.disk_array_ex & 0x7)
 #define	VIA_BROKEN(x)		(((x)->array.disk_array_ex & 0x8) >> 4)
 #define	VIA_STRIDE(x)		(8 << (((x)->array.disk_array_ex & 0xF0) >> 4))
-	uint32_t	capacity_low;
-	uint32_t	capacity_high;
-	uint32_t	serial_checksum;
+	uint32_t capacity_low;
+	uint32_t capacity_high;
+	uint32_t serial_checksum;
 } __attribute__ ((packed));
 
 struct via {
-	uint16_t	signature;
+	uint16_t signature;
 #define	VIA_SIGNATURE	0xAA55
-	uint8_t		version_number;
-	struct array	array;
-	uint32_t	serial_checksum[8];
-	uint8_t		checksum;
+	uint8_t version_number;
+	struct array array;
+	uint32_t serial_checksum[8];
+	uint8_t checksum;
 } __attribute__ ((packed));
 #endif
 
--- dmraid/lib/format/ddf/ddf1.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/format/ddf/ddf1.c	2008/06/20 21:52:17	1.4
@@ -4,8 +4,8 @@
  * Copyright (C) 2005-2006 IBM, All rights reserved.
  * Written by Darrick Wong <djwong@us.ibm.com>
  *
- * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
- *                    All rights reserved.
+ * Copyright (C) 2006-2008 Heinz Mauelshagen, Red Hat GmbH
+ *                         All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
@@ -37,17 +37,19 @@
 #define	DDF1_DISKS	(char*) ".ddf1_disks"
 
 /* PCI IDs for Adaptec */
-// #define PCI_VENDOR_ID_ADAPTEC		0x9004
+// #define PCI_VENDOR_ID_ADAPTEC                0x9004
 #define PCI_VENDOR_ID_ADAPTEC2		0x9005
 
 /* Map DDF1 disk status to dmraid status */
-static enum status disk_status(struct ddf1_phys_drive *disk) {
+static enum status
+disk_status(struct ddf1_phys_drive *disk)
+{
 	struct states states[] = {
-		{ 0x72, s_broken },
-		{ 0x04, s_nosync },
-		{ 0x08, s_setup },
-		{ 0x01, s_ok },
-		{ 0, s_undef },
+		{0x72, s_broken},
+		{0x04, s_nosync},
+		{0x08, s_setup},
+		{0x01, s_ok},
+		{0, s_undef},
 	};
 
 	return disk ? rd_status(states, disk->state, AND) : s_undef;
@@ -60,7 +62,8 @@
  * both GUIDs don't have 0xFFFFFFFF in bytes 20-23.  Gross.
  */
 /* Find this drive's physical data */
-static struct ddf1_phys_drive *get_phys_drive(struct ddf1 *ddf1)
+static struct ddf1_phys_drive *
+get_phys_drive(struct ddf1 *ddf1)
 {
 	unsigned int i = ddf1->pd_header->max_drives;
 
@@ -73,8 +76,8 @@
 }
 
 /* Find the virtual drive that goes with this config record */
-static struct ddf1_virt_drive *get_virt_drive(struct ddf1 *ddf1,
-					      struct ddf1_config_record *cr)
+static struct ddf1_virt_drive *
+get_virt_drive(struct ddf1 *ddf1, struct ddf1_config_record *cr)
 {
 	int i = ddf1->vd_header->num_drives;
 
@@ -89,8 +92,9 @@
 /*
  * Find the index of the VD config record given a physical drive and offset.
  */
-static int get_config_byoffset(struct ddf1 *ddf1, struct ddf1_phys_drive *pd,
-				 uint64_t offset)
+static int
+get_config_byoffset(struct ddf1 *ddf1, struct ddf1_phys_drive *pd,
+		    uint64_t offset)
 {
 	int cfgs = NUM_CONFIG_ENTRIES(ddf1), i;
 	uint32_t *cfg_drive_ids, j;
@@ -114,8 +118,8 @@
 }
 
 /* Find the index of the nth VD config record for this physical drive. */
-static int get_config_index(struct ddf1 *ddf1, struct ddf1_phys_drive *pd,
-			    unsigned int *n)
+static int
+get_config_index(struct ddf1 *ddf1, struct ddf1_phys_drive *pd, unsigned int *n)
 {
 	int cfgs = NUM_CONFIG_ENTRIES(ddf1), i, j, nn = *n;
 	uint32_t *ids;
@@ -127,7 +131,7 @@
 			ids = CR_IDS(ddf1, cr);
 			for (j = 0; j < cr->primary_element_count; j++) {
 				if (ids[j] == pd->reference && !nn--)
-						return i;
+					return i;
 			}
 		}
 	}
@@ -139,18 +143,17 @@
 /*
  * Find the nth VD config record for this physical drive.
  */
-static inline struct ddf1_config_record *get_config(struct ddf1 *ddf1,
-						    struct ddf1_phys_drive *pd,
-						    unsigned int n)
+static inline struct ddf1_config_record *
+get_config(struct ddf1 *ddf1, struct ddf1_phys_drive *pd, unsigned int n)
 {
 	int i = get_config_index(ddf1, pd, &n);
 
 	return i < 0 ? NULL : CR(ddf1, i);
 }
- 
+
 /* Find a config record for this drive, given the offset of the array. */
-static inline struct ddf1_config_record *get_this_config(struct ddf1 *ddf1,
-							 uint64_t offset)
+static inline struct ddf1_config_record *
+get_this_config(struct ddf1 *ddf1, uint64_t offset)
 {
 	struct ddf1_phys_drive *pd = get_phys_drive(ddf1);
 	int i = get_config_byoffset(ddf1, pd, offset);
@@ -159,8 +162,9 @@
 }
 
 /* Find the config record disk/offset entry for this config/drive. */
-static int get_offset_entry(struct ddf1 *ddf1, struct ddf1_config_record *cr,
-			    struct ddf1_phys_drive *pd)
+static int
+get_offset_entry(struct ddf1 *ddf1, struct ddf1_config_record *cr,
+		 struct ddf1_phys_drive *pd)
 {
 	int i;
 	uint32_t *ids;
@@ -177,8 +181,9 @@
 }
 
 /* Find the offset for this config/drive. */
-static uint64_t get_offset(struct ddf1 *ddf1, struct ddf1_config_record *cr,
-			   struct ddf1_phys_drive *pd)
+static uint64_t
+get_offset(struct ddf1 *ddf1, struct ddf1_config_record *cr,
+	   struct ddf1_phys_drive *pd)
 {
 	int i = get_offset_entry(ddf1, cr, pd);
 
@@ -186,33 +191,34 @@
 }
 
 /* Calculate the stripe size, in sectors */
-static inline unsigned int stride(struct ddf1_config_record *cr)
+static inline unsigned int
+stride(struct ddf1_config_record *cr)
 {
 	return to_bytes(1) >> 9 << cr->stripe_size;
 }
 
 /* Map the DDF1 raid type codes into dmraid type codes. */
-static enum type type(struct lib_context *lc, struct ddf1 *ddf1,
-		      struct ddf1_config_record *cr)
+static enum type
+type(struct lib_context *lc, struct ddf1 *ddf1, struct ddf1_config_record *cr)
 {
 	unsigned int l;
 	struct types *t;
 	/* Mapping of template types to generic types */
 	static struct types types[] = {
-		{ DDF1_RAID0,	t_raid0 },
-		{ DDF1_RAID1,	t_raid1 },
-		{ DDF1_RAID4,	t_raid4 },
-		{ DDF1_CONCAT,	t_linear },
-		{ DDF1_JBOD,	t_linear },
-		{ 0, t_undef}
+		{DDF1_RAID0, t_raid0},
+		{DDF1_RAID1, t_raid1},
+		{DDF1_RAID4, t_raid4},
+		{DDF1_CONCAT, t_linear},
+		{DDF1_JBOD, t_linear},
+		{0, t_undef}
 	};
 	/* Seperate array for RAID5 qualifiers */
 	static struct types qualifier_types[] = {
 		/* FIXME: Is RLQ=0 really right symmetric? */
-		{ DDF1_RAID5_RS, t_raid5_rs },
-		{ DDF1_RAID5_LA, t_raid5_la },
-		{ DDF1_RAID5_LS, t_raid5_ls },
-		{ 0, t_undef}
+		{DDF1_RAID5_RS, t_raid5_rs},
+		{DDF1_RAID5_LA, t_raid5_la},
+		{DDF1_RAID5_LS, t_raid5_ls},
+		{0, t_undef}
 	};
 
 	if (!cr)
@@ -236,8 +242,8 @@
 }
 
 /* Read the whole metadata chunk at once */
-static uint8_t *read_metadata_chunk(struct lib_context *lc, struct dev_info *di,
-				    uint64_t start)
+static uint8_t *
+read_metadata_chunk(struct lib_context *lc, struct dev_info *di, uint64_t start)
 {
 	uint8_t *ret;
 	size_t size = to_bytes(di->sectors - start);
@@ -254,26 +260,29 @@
 	return ret;
 }
 
-static inline void cond_free(void *p)
+static inline void
+cond_free(void *p)
 {
 	if (p)
 		dbg_free(p);
 }
 
 /* Reused error message */
-static inline void *err_drive(struct lib_context *lc, struct dev_info *di,
-			      const char *what)
+static inline void *
+err_drive(struct lib_context *lc, struct dev_info *di, const char *what)
 {
 	LOG_ERR(lc, NULL, "%s: cannot find %s drive record on %s",
 		handler, what, di->path);
 }
 
-static void *err_phys_drive(struct lib_context *lc, struct dev_info *di)
+static void *
+err_phys_drive(struct lib_context *lc, struct dev_info *di)
 {
 	return err_drive(lc, di, "physical");
 }
 
-static void *err_virt_drive(struct lib_context *lc, struct dev_info *di)
+static void *
+err_virt_drive(struct lib_context *lc, struct dev_info *di)
 {
 	return err_drive(lc, di, "virtual");
 }
@@ -282,8 +291,8 @@
  * Read a DDF1 RAID device.  Fields are little endian, so
  * need to convert them if we're on a BE machine (ppc, etc).
  */
-static int read_extended(struct lib_context *lc, struct dev_info *di,
-			 struct ddf1 *ddf1)
+static int
+read_extended(struct lib_context *lc, struct dev_info *di, struct ddf1 *ddf1)
 {
 	int i;
 	uint64_t where;
@@ -319,7 +328,7 @@
 		cond_free(ddf1->primary);
 		ddf1->primary = NULL;
 	};
-	
+
 	if (sec->signature == DDF1_HEADER) {
 		/* If we encounter an error, we use the secondary table */
 		if (!ddf1->primary) {
@@ -331,8 +340,7 @@
 	} else {
 		if (sec->signature)
 			log_warn(lc, "%s: bad secondary header signature %x "
-				     "on %s",
-				 handler, sec->signature, di->path);
+				 "on %s", handler, sec->signature, di->path);
 
 		dbg_free(sec);
 		ddf1->secondary = NULL;
@@ -357,7 +365,7 @@
 	if (ddf1->adapter->signature != DDF1_ADAPTER_DATA) {
 		if (ddf1->adapter->signature)
 			log_warn(lc, "%s: incorrect adapter data signature %x "
-				     "on %s",
+				 "on %s",
 				 handler, ddf1->adapter->signature, di->path);
 		dbg_free(ddf1->adapter);
 		ddf1->adapter = NULL;
@@ -402,8 +410,8 @@
 	}
 
 	/* Now read the physical drive data */
-	ddf1->pds = (struct ddf1_phys_drive *)(((uint8_t *)ddf1->pd_header) +
-		    sizeof (*pd));
+	ddf1->pds = (struct ddf1_phys_drive *) (((uint8_t *) ddf1->pd_header) +
+						sizeof(*pd));
 	for (i = 0; i < pd->num_drives; i++) {
 		ddf1_cvt_phys_drive(ddf1, &ddf1->pds[i]);
 		/*
@@ -428,7 +436,7 @@
 	}
 
 	/* Now read the virtual drive data */
-	ddf1->vds = (struct ddf1_virt_drive*)(((uint8_t*) vd) + sizeof (*pd));
+	ddf1->vds = (struct ddf1_virt_drive *) (((uint8_t *) vd) + sizeof(*pd));
 	for (i = 0; i < vd->num_drives; i++)
 		ddf1_cvt_virt_drive(ddf1, &ddf1->vds[i]);
 
@@ -454,13 +462,12 @@
 	ddf1->in_cpu_format = 1;
 
 	/* FIXME: We should verify the checksums for all modes */
-	if (ddf1->adaptec_mode &&
-	    !(ddf1_check_all_crcs(lc, di, ddf1)))
+	if (ddf1->adaptec_mode && !(ddf1_check_all_crcs(lc, di, ddf1)))
 		goto bad;
 
 	return 1;
 
-bad:
+      bad:
 	ddf1->vds = NULL;
 	ddf1->pds = NULL;
 	cond_free(ddf1->cfg);
@@ -473,18 +480,19 @@
 }
 
 /* Count the number of raid_devs we need to create for this drive */
-static unsigned int num_devs(struct lib_context *lc, void *meta)
+static unsigned int
+num_devs(struct lib_context *lc, void *meta)
 {
 	struct ddf1 *ddf1 = meta;
 	unsigned int num_drives = ~0;
-	
+
 	get_config_index(ddf1, get_phys_drive(ddf1), &num_drives);
 	return num_drives;
 }
 
 /* Is this DDF1 metadata? */
-static inline int is_ddf1(struct lib_context *lc, struct dev_info *di,
-			  struct ddf1 *ddf1)
+static inline int
+is_ddf1(struct lib_context *lc, struct dev_info *di, struct ddf1 *ddf1)
 {
 	/*
 	 * Check our magic numbers and that the version == v2.
@@ -493,15 +501,15 @@
 
 	/* FIXME: We should examine the version headers... */
 	return ddf1->anchor.signature == DDF1_HEADER ||
-	       ddf1->anchor.signature == DDF1_HEADER_BACKWARDS;
+		ddf1->anchor.signature == DDF1_HEADER_BACKWARDS;
 }
 
 /* Try to find DDF1 metadata at a given offset (ddf1_sboffset) */
-static struct ddf1 *try_to_find_ddf1(struct lib_context *lc,
-				     struct dev_info *di,
-				     size_t *sz, uint64_t *offset,
-				     union read_info *info,
-				     uint64_t ddf1_sboffset)
+static struct ddf1 *
+try_to_find_ddf1(struct lib_context *lc,
+		 struct dev_info *di,
+		 size_t * sz, uint64_t * offset,
+		 union read_info *info, uint64_t ddf1_sboffset)
 {
 	struct ddf1 *ddf1;
 
@@ -515,8 +523,7 @@
 		goto err;
 
 	if (!read_file(lc, handler, di->path, &ddf1->anchor, to_bytes(1),
-		       ddf1_sboffset) ||
-	    !is_ddf1(lc, di, ddf1))
+		       ddf1_sboffset) || !is_ddf1(lc, di, ddf1))
 		goto bad;
 
 	ddf1->anchor_offset = ddf1_sboffset;
@@ -531,9 +538,9 @@
 	if (read_extended(lc, di, ddf1))
 		return ddf1;
 
-   bad:
+      bad:
 	dbg_free(ddf1);
-   err:
+      err:
 	return NULL;
 }
 
@@ -543,9 +550,9 @@
  * Note that the struct should be fully converted to the correct endianness
  * by the time this function returns.
  */
-static void *read_metadata_areas(struct lib_context *lc, struct dev_info *di,
-				 size_t *sz, uint64_t *offset,
-				 union read_info *info)
+static void *
+read_metadata_areas(struct lib_context *lc, struct dev_info *di,
+		    size_t * sz, uint64_t * offset, union read_info *info)
 {
 	struct ddf1 *ddf1;
 
@@ -560,8 +567,8 @@
 }
 
 /* This is all hogwash since file_metadata can only be called once... */
-static void file_metadata_areas(struct lib_context *lc, struct dev_info *di,
-				void *meta)
+static void
+file_metadata_areas(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	uint8_t *buf;
 	uint64_t start = ddf1_beginning(meta);
@@ -571,14 +578,14 @@
 		file_metadata(lc, handler, di->path, buf,
 			      to_bytes(di->sectors - start), to_bytes(start));
 		dbg_free(buf);
-		file_dev_size(lc, handler, di); /* Record the device size. */
+		file_dev_size(lc, handler, di);	/* Record the device size. */
 	}
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *ddf1_read(struct lib_context *lc,
-					struct dev_info *di)
+static struct raid_dev *
+ddf1_read(struct lib_context *lc, struct dev_info *di)
 {
 	/*
 	 * NOTE: Everything called after read_metadata_areas assumes that
@@ -590,7 +597,8 @@
 }
 
 /* Compose an "identifier" for use as a sort key for raid sets. */
-static inline int compose_id(struct ddf1 *ddf1, struct raid_dev *rd)
+static inline int
+compose_id(struct ddf1 *ddf1, struct raid_dev *rd)
 {
 	struct ddf1_phys_drive *pd = get_phys_drive(ddf1);
 	int i = get_config_byoffset(ddf1, pd, rd->offset);
@@ -599,24 +607,27 @@
 }
 
 /* No sort. */
-static int no_sort(struct list_head *pos, struct list_head *new)
+static int
+no_sort(struct list_head *pos, struct list_head *new)
 {
 	return 0;
 }
 
 /* Sort DDF1 devices by offset entry within a RAID set. */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	struct raid_dev *rd_pos = RD(pos), *rd_new = RD(new);
 
 	return compose_id(META(GRP_RD(rd_new), ddf1), rd_new) <
-	       compose_id(META(GRP_RD(rd_pos), ddf1), rd_pos);
+		compose_id(META(GRP_RD(rd_pos), ddf1), rd_pos);
 }
 
 /*
  * IO error event handler.
  */
-static int event_io(struct lib_context *lc, struct event_io *e_io)
+static int
+event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	log_err(lc, "%s: I/O error on device %s at sector %lu.\n",
 		handler, e_io->rd->di->path, e_io->sector);
@@ -626,30 +637,30 @@
 
 #if 0
 	/* FIXME: This should not use META() directly? */
-	struct raid_dev *rd = e_io->rd;
-	struct ddf1 *ddf1 = META(rd, ddf1);
-	struct ddf1_raid_configline *cl = this_disk(ddf1);
-	struct ddf1_raid_configline *fwl = find_logical(ddf1);
+struct raid_dev *rd = e_io->rd;
+struct ddf1 *ddf1 = META(rd, ddf1);
+struct ddf1_raid_configline *cl = this_disk(ddf1);
+struct ddf1_raid_configline *fwl = find_logical(ddf1);
 
 	/* Ignore if we've already marked this disk broken(?) */
-	if (rd->status & s_broken)
-		return 0;
-	
+if (rd->status & s_broken)
+	return 0;
+
 	/* Mark the array as degraded and the disk as failed. */
-	rd->status = s_broken;
-	cl->raidstate = LSU_COMPONENT_STATE_FAILED;
-	fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
+rd->status = s_broken;
+cl->raidstate = LSU_COMPONENT_STATE_FAILED;
+fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
 	/* FIXME: Do we have to mark a parent too? */
 
 	/* Indicate that this is indeed a failure. */
-	return 1;
+return 1;
 }
 #endif
 
 #define NAME_SIZE 64
 /* Formulate a RAID set name for this disk. */
-static char *name(struct lib_context *lc, struct ddf1 *ddf1,
-		  struct raid_dev *rd)
+static char *
+name(struct lib_context *lc, struct ddf1 *ddf1, struct raid_dev *rd)
 {
 	int i, prefix;
 	char buf[NAME_SIZE];
@@ -661,8 +672,8 @@
 		return err_phys_drive(lc, rd->di);
 
 	i = get_config_byoffset(ddf1, pd, rd->offset);
- 	cr = get_config(ddf1, pd, i);
- 	if (i < 0 || !cr) {
+	cr = get_config(ddf1, pd, i);
+	if (i < 0 || !cr) {
 		sprintf(buf, DDF1_SPARES);
 		goto out;
 	}
@@ -677,29 +688,29 @@
 		memcpy(buf + prefix, vd->name, 16);
 		i = prefix + 16;
 		while (!isgraph(buf[--i]));
-		buf[i+1] = 0;
+		buf[i + 1] = 0;
 	} else {
 		char *b;
 
 		for (b = buf + prefix, i = 0; i < 24; b += 8, i += 4)
 			sprintf(b, "%02x%02x%02x%02x",
-				vd->guid[i], vd->guid[i+1],
-			        vd->guid[i+2], vd->guid[i+3]);
+				vd->guid[i], vd->guid[i + 1],
+				vd->guid[i + 2], vd->guid[i + 3]);
 	}
 
-   out:
-	return dbg_strdup(buf); /* Only return the needed allocation */
+      out:
+	return dbg_strdup(buf);	/* Only return the needed allocation */
 }
 
 /* Figure out the real size of a disk... */
-static uint64_t get_size(struct lib_context *lc, struct ddf1 *ddf1,
-			 struct ddf1_config_record *cr,
-			 struct ddf1_phys_drive *pd)
+static uint64_t
+get_size(struct lib_context *lc, struct ddf1 *ddf1,
+	 struct ddf1_config_record *cr, struct ddf1_phys_drive *pd)
 {
 	if (cr && cr->sectors)
 		/* Some Adaptec controllers need this clamping. */
 		return type(lc, ddf1, cr) == t_raid0 ?
-		       cr->sectors - cr->sectors % stride(cr) : cr->sectors;
+			cr->sectors - cr->sectors % stride(cr) : cr->sectors;
 
 	return pd->size;
 }
@@ -710,9 +721,9 @@
  * function is successful, NULL if not.  rd_group is the raid device that
  * represents the entire disk drive.
  */
-static struct raid_set *group_rd(struct lib_context *lc,
-				 struct raid_set *rs_group,
-				 struct raid_dev *rd_group)
+static struct raid_set *
+group_rd(struct lib_context *lc,
+	 struct raid_set *rs_group, struct raid_dev *rd_group)
 {
 	struct ddf1 *ddf1 = META(rd_group, ddf1);
 	struct raid_set *rs = NULL;
@@ -721,7 +732,7 @@
 	struct ddf1_phys_drive *pd;
 	struct ddf1_group_info *gi;
 	unsigned int devs, i;
-	
+
 	if (!(pd = get_phys_drive(ddf1)))
 		return err_phys_drive(lc, rd_group->di);
 
@@ -747,7 +758,7 @@
 		 * If we have a virtual drive config without an entry in the
 		 * list of virtual drives, we ignore it.  Weird bug seen on
 		 * Adaptec 2410SA controller.
-		*/
+		 */
 		if (!(rd->name = name(lc, ddf1, rd))) {
 			free_raid_dev(lc, &rd);
 			continue;
@@ -789,7 +800,8 @@
  *
  * FIXME: We haven't been able to set up a RAID10 for testing...
  */
-static struct raid_set *ddf1_group(struct lib_context *lc, struct raid_dev *rd)
+static struct raid_set *
+ddf1_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct ddf1 *ddf1 = META(rd, ddf1);
 	struct ddf1_phys_drive *pd;
@@ -810,8 +822,7 @@
 	 * (Is this really necessary?)
 	 */
 	if (!(rs = find_or_alloc_raid_set(lc, rd->name, FIND_TOP, rd,
-					  LC_RS(lc), NO_CREATE,
-					  NO_CREATE_ARG)))
+					  LC_RS(lc), NO_CREATE, NO_CREATE_ARG)))
 		return NULL;
 
 	rs->type = t_group;
@@ -822,19 +833,20 @@
 }
 
 /* Write metadata. */
-static int ddf1_write(struct lib_context *lc,  struct raid_dev *rd, int erase)
+static int
+ddf1_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
-        struct ddf1 *ddf1 = META(rd, ddf1);
+	struct ddf1 *ddf1 = META(rd, ddf1);
 
 	if (ddf1->adaptec_mode)
 		ddf1_update_all_crcs(lc, rd->di, ddf1);
 
-        ddf1_cvt_all(lc, ddf1, rd->di);
-        ret = write_metadata(lc, handler, rd, -1, erase);
-        ddf1_cvt_all(lc, ddf1, rd->di);
+	ddf1_cvt_all(lc, ddf1, rd->di);
+	ret = write_metadata(lc, handler, rd, -1, erase);
+	ddf1_cvt_all(lc, ddf1, rd->di);
 
-        return ret;
+	return ret;
 }
 
 /*
@@ -842,7 +854,8 @@
  */
 
 /* Retrieve the number of devices that should be in this set. */
-static unsigned int device_count(struct raid_dev *rd, void *context)
+static unsigned int
+device_count(struct raid_dev *rd, void *context)
 {
 	/* Get the logical drive */
 	struct ddf1_config_record *cr =
@@ -852,8 +865,9 @@
 }
 
 /* Check a RAID device */
-static int check_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_dev *rd, void *context)
+static int
+check_rd(struct lib_context *lc, struct raid_set *rs,
+	 struct raid_dev *rd, void *context)
 {
 	/*
 	 * FIXME: Should we do more checking for brokenness here?
@@ -863,7 +877,8 @@
 }
 
 /* Start the recursive RAID set check. */
-static int ddf1_check(struct lib_context *lc, struct raid_set *rs)
+static int
+ddf1_check(struct lib_context *lc, struct raid_set *rs)
 {
 	return check_raid_set(lc, rs, device_count, NULL, check_rd,
 			      NULL, handler);
@@ -871,36 +886,38 @@
 
 static struct event_handlers ddf1_event_handlers = {
 	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about the RAID device.
  */
-static void ddf1_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+ddf1_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	ddf1_dump_all(lc, rd->di, META(rd, ddf1), handler);
 }
 #endif /* #ifdef DMRAID_NATIVE_LOG  */
 
 static struct dmraid_format ddf1_format = {
-	.name	= HANDLER,
-	.descr	= "SNIA DDF1",
-	.caps	= "0,1,4,5,linear",
+	.name = HANDLER,
+	.descr = "SNIA DDF1",
+	.caps = "0,1,4,5,linear",
 	.format = FMT_RAID,
-	.read	= ddf1_read,
-	.write	= ddf1_write,
-	.group	= ddf1_group,
-	.check	= ddf1_check,
-	.events	= &ddf1_event_handlers,
+	.read = ddf1_read,
+	.write = ddf1_write,
+	.group = ddf1_group,
+	.check = ddf1_check,
+	.events = &ddf1_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= ddf1_log,
+	.log = ddf1_log,
 #endif
 };
 
 /* Register this format handler with the format core */
-int register_ddf1(struct lib_context *lc)
+int
+register_ddf1(struct lib_context *lc)
 {
 	return register_format_handler(lc, &ddf1_format);
 }
@@ -908,8 +925,9 @@
 /*
  * Set up a RAID device from what we've assembled out of the metadata.
  */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	unsigned int i, ma_count = 5;
 	struct ddf1 *ddf1 = meta;
@@ -918,7 +936,7 @@
 
 	if (!(pd = get_phys_drive(ddf1)))
 		LOG_ERR(lc, 0, "%s: Cannot find physical drive description "
-			       "on %s!", handler, di->path);
+			"on %s!", handler, di->path);
 
 	/* We need multiple metadata areas */
 	ma_count += ddf1->adapter ? 1 : 0;
@@ -969,7 +987,7 @@
 	ma->area = ddf1->cfg;
 
 	/* Now set up the rest of the metadata info */
-        rd->di = di;
+	rd->di = di;
 	rd->fmt = &ddf1_format;
 	rd->status = disk_status(pd);
 	rd->type = t_group;
--- dmraid/lib/format/ddf/ddf1.h	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1.h	2008/06/20 21:52:17	1.2
@@ -91,160 +91,160 @@
 
 /* The DDF1 header table */
 struct ddf1_header {
-	uint32_t	signature;
-	uint32_t	crc;
-	uint8_t		guid[DDF1_GUID_LENGTH];
-	uint8_t		ddf_rev[DDF1_REV_LENGTH];
-	uint32_t	seqnum;
-	uint32_t	timestamp;
-	uint8_t		open_flag;
-	uint8_t		foreign_flag;
-	uint8_t		grouping_enforced;
-	uint8_t		reserved2[45];
-	uint64_t	primary_table_lba;
-	uint64_t	secondary_table_lba;
-	uint8_t		header_type;
-	uint8_t		reserved3[3];
-	uint32_t	workspace_length;
-	uint64_t	workspace_lba;
-	uint16_t	max_phys_drives;
-	uint16_t	max_virt_drives;
-	uint16_t	max_partitions;
-	uint16_t	vd_config_record_len;
-	uint16_t	max_primary_elements;
-	uint8_t		reserved4[54];
-	uint32_t	adapter_data_offset;
-	uint32_t	adapter_data_len;
-	uint32_t	phys_drive_offset;
-	uint32_t	phys_drive_len;
-	uint32_t	virt_drive_offset;
-	uint32_t	virt_drive_len;
-	uint32_t	config_record_offset;
-	uint32_t	config_record_len;
-	uint32_t	disk_data_offset;
-	uint32_t	disk_data_len;
-	uint32_t	badblock_offset;
-	uint32_t	badblock_len;
-	uint32_t	diag_offset;
-	uint32_t	diag_len;
-	uint32_t	vendor_offset;
-	uint32_t	vendor_len;
-	uint8_t		reserved5[256];
+	uint32_t signature;
+	uint32_t crc;
+	uint8_t guid[DDF1_GUID_LENGTH];
+	uint8_t ddf_rev[DDF1_REV_LENGTH];
+	uint32_t seqnum;
+	uint32_t timestamp;
+	uint8_t open_flag;
+	uint8_t foreign_flag;
+	uint8_t grouping_enforced;
+	uint8_t reserved2[45];
+	uint64_t primary_table_lba;
+	uint64_t secondary_table_lba;
+	uint8_t header_type;
+	uint8_t reserved3[3];
+	uint32_t workspace_length;
+	uint64_t workspace_lba;
+	uint16_t max_phys_drives;
+	uint16_t max_virt_drives;
+	uint16_t max_partitions;
+	uint16_t vd_config_record_len;
+	uint16_t max_primary_elements;
+	uint8_t reserved4[54];
+	uint32_t adapter_data_offset;
+	uint32_t adapter_data_len;
+	uint32_t phys_drive_offset;
+	uint32_t phys_drive_len;
+	uint32_t virt_drive_offset;
+	uint32_t virt_drive_len;
+	uint32_t config_record_offset;
+	uint32_t config_record_len;
+	uint32_t disk_data_offset;
+	uint32_t disk_data_len;
+	uint32_t badblock_offset;
+	uint32_t badblock_len;
+	uint32_t diag_offset;
+	uint32_t diag_len;
+	uint32_t vendor_offset;
+	uint32_t vendor_len;
+	uint8_t reserved5[256];
 } __attribute__ ((packed));
 
 /* The adapter data header */
 struct ddf1_adapter {
-	uint32_t	signature;
-	uint32_t	crc;
-	uint8_t		guid[DDF1_GUID_LENGTH];
-	uint16_t	pci_vendor;
-	uint16_t	pci_device;
-	uint16_t	pci_subvendor;
-	uint16_t	pci_subdevice;
-	uint8_t		reserved2[24];
-	uint8_t		adapter_data[448];
+	uint32_t signature;
+	uint32_t crc;
+	uint8_t guid[DDF1_GUID_LENGTH];
+	uint16_t pci_vendor;
+	uint16_t pci_device;
+	uint16_t pci_subvendor;
+	uint16_t pci_subdevice;
+	uint8_t reserved2[24];
+	uint8_t adapter_data[448];
 } __attribute__ ((packed));
 
 /* Physical drive info */
 struct ddf1_disk_data {
-	uint32_t	signature;
-	uint32_t	crc;
-	uint8_t		guid[DDF1_GUID_LENGTH];
-	uint32_t	reference;
-	uint8_t		forced_ref_flag;
-	uint8_t		forced_guid_flag;
-	uint8_t		scratch[32];
-	uint8_t		reserved[442];
+	uint32_t signature;
+	uint32_t crc;
+	uint8_t guid[DDF1_GUID_LENGTH];
+	uint32_t reference;
+	uint8_t forced_ref_flag;
+	uint8_t forced_guid_flag;
+	uint8_t scratch[32];
+	uint8_t reserved[442];
 } __attribute__ ((packed));
 
 /* Physical drive record header */
 struct ddf1_phys_drives {
-	uint32_t	signature;
-	uint32_t	crc;
-	uint16_t	num_drives;
-	uint16_t	max_drives;
-	uint8_t		reserved2[52];
+	uint32_t signature;
+	uint32_t crc;
+	uint16_t num_drives;
+	uint16_t max_drives;
+	uint8_t reserved2[52];
 	/* 64 bytes */
 	/* Drive records follow */
 } __attribute__ ((packed));
 
 /* Physical drive record */
 struct ddf1_phys_drive {
-	uint8_t		guid[DDF1_GUID_LENGTH];
-	uint32_t	reference;
-	uint16_t	type;
-	uint16_t	state;
-	uint64_t	size;
-	uint8_t		path_info[18];
-	uint8_t		reserved3[6];
+	uint8_t guid[DDF1_GUID_LENGTH];
+	uint32_t reference;
+	uint16_t type;
+	uint16_t state;
+	uint64_t size;
+	uint8_t path_info[18];
+	uint8_t reserved3[6];
 } __attribute__ ((packed));
 
 /* Virtual drive record header */
 struct ddf1_virt_drives {
-	uint32_t	signature;
-	uint32_t	crc;
-	uint16_t	num_drives;
-	uint16_t	max_drives;
-	uint8_t		reserved2[52];
+	uint32_t signature;
+	uint32_t crc;
+	uint16_t num_drives;
+	uint16_t max_drives;
+	uint8_t reserved2[52];
 	/* Drive records follow */
 } __attribute__ ((packed));
 
 /* Virtual drive record */
 struct ddf1_virt_drive {
-	uint8_t		guid[DDF1_GUID_LENGTH];
-	uint16_t	vd_num;
-	uint16_t	reserved2;
-	uint32_t	type;
-	uint8_t		state;
-	uint8_t		init_state;
-	uint8_t		reserved3[14];
-	uint8_t		name[16];
+	uint8_t guid[DDF1_GUID_LENGTH];
+	uint16_t vd_num;
+	uint16_t reserved2;
+	uint32_t type;
+	uint8_t state;
+	uint8_t init_state;
+	uint8_t reserved3[14];
+	uint8_t name[16];
 } __attribute__ ((packed));
 
 /* Virtual disk configuration record. */
 struct ddf1_config_record {
-	uint32_t	signature;
-	uint32_t	crc;
-	uint8_t		guid[DDF1_GUID_LENGTH];
-	uint32_t	timestamp;
-	uint32_t	seqnum;
-	uint8_t		reserved[24];
-	uint16_t	primary_element_count;
-	uint8_t		stripe_size;
-	uint8_t		raid_level;
-	uint8_t		raid_qualifier;
-	uint8_t		secondary_element_count;
-	uint8_t		secondary_element_number;
-	uint8_t		secondary_element_raid_level;
-	uint64_t	sectors;
-	uint64_t	size;
-	uint64_t	reserved2;
-	uint32_t	spares[8];
-	uint64_t	cache_policy;
-	uint8_t		bg_task_rate;
+	uint32_t signature;
+	uint32_t crc;
+	uint8_t guid[DDF1_GUID_LENGTH];
+	uint32_t timestamp;
+	uint32_t seqnum;
+	uint8_t reserved[24];
+	uint16_t primary_element_count;
+	uint8_t stripe_size;
+	uint8_t raid_level;
+	uint8_t raid_qualifier;
+	uint8_t secondary_element_count;
+	uint8_t secondary_element_number;
+	uint8_t secondary_element_raid_level;
+	uint64_t sectors;
+	uint64_t size;
+	uint64_t reserved2;
+	uint32_t spares[8];
+	uint64_t cache_policy;
+	uint8_t bg_task_rate;
 	/* 137 bytes */
-	uint8_t		reserved3[3+52+192+32+32+16+16+32];
+	uint8_t reserved3[3 + 52 + 192 + 32 + 32 + 16 + 16 + 32];
 	/* 512 bytes */
 } __attribute__ ((packed));
 
 /* Spare disk record */
 struct ddf1_spare {
-	uint8_t		guid[DDF1_GUID_LENGTH];
-	uint16_t	secondary_element;
-	uint8_t		reserved[6];
+	uint8_t guid[DDF1_GUID_LENGTH];
+	uint16_t secondary_element;
+	uint8_t reserved[6];
 } __attribute__ ((packed));
 
 /* Spare disk assignment record */
 struct ddf1_spare_header {
-	uint32_t	signature;
-	uint32_t	crc;
-	uint32_t	timestamp;
-	uint8_t		reserved[7];
-	uint8_t		type;
-	uint16_t	num_spares;
-	uint16_t	max_spares;
-	uint8_t		reserved2[8];
-	struct ddf1_spare	spares[0];
+	uint32_t signature;
+	uint32_t crc;
+	uint32_t timestamp;
+	uint8_t reserved[7];
+	uint8_t type;
+	uint16_t num_spares;
+	uint16_t max_spares;
+	uint8_t reserved2[8];
+	struct ddf1_spare spares[0];
 } __attribute__ ((packed));
 
 /* Metadata owner */
--- dmraid/lib/format/ddf/ddf1_crc.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/format/ddf/ddf1_crc.c	2008/06/20 21:52:17	1.4
@@ -4,8 +4,8 @@
  * Copyright (C) 2005-2006 IBM, All rights reserved.
  * Written by James Simshaw <simshawj@us.ibm.com>
  *
- * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
- *                    All rights reserved.
+ * Copyright (C) 2006-2008 Heinz Mauelshagen, Red Hat GmbH
+ *                         All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
@@ -28,9 +28,10 @@
 
 /* Make the table for a fast CRC. */
 #define	CRC_TABLE_SIZE	256
-static inline void crc_table_init(uint32_t *crc_table)
+static inline void
+crc_table_init(uint32_t * crc_table)
 {
-	static int new = 1; /* Flag for table not yet computed. */
+	static int new = 1;	/* Flag for table not yet computed. */
 
 	if (new) {
 		uint32_t c, n, k;
@@ -49,15 +50,16 @@
  * crc() routine below).
  */
 /* Return the CRC of the bytes buf[0..len-1]. */
-static uint32_t crc(uint32_t crc, unsigned char *buf, int len)
+static uint32_t
+crc(uint32_t crc, unsigned char *buf, int len)
 {
 	int n;
-	static uint32_t crc_table[CRC_TABLE_SIZE]; /* CRCs of 8-bit messages. */
+	static uint32_t crc_table[CRC_TABLE_SIZE];	/* CRCs of 8-bit messages. */
 
 	crc_table_init(crc_table);
 	for (n = 0; n < len; n++)
 		crc = crc_table[(crc ^ buf[n]) & (CRC_TABLE_SIZE - 1)] ^
-		      (crc >> 8);
+			(crc >> 8);
 
 	return crc ^ 0xFFFFFFFFL;
 }
@@ -71,7 +73,8 @@
 };
 
 /* Compute the checksum of a table */
-static uint32_t do_crc32(struct lib_context *lc, struct crc_info *ci)
+static uint32_t
+do_crc32(struct lib_context *lc, struct crc_info *ci)
 {
 	uint32_t old_csum = *ci->crc, ret = 0xFFFFFFFF;
 
@@ -82,7 +85,8 @@
 }
 
 /* Return VD record size. */
-static inline size_t record_size(struct ddf1 *ddf1)
+static inline size_t
+record_size(struct ddf1 *ddf1)
 {
 	return ddf1->primary->vd_config_record_len * DDF1_BLKSIZE;
 }
@@ -108,8 +112,8 @@
 
 
 /* Process the configuration records to have their CRCs updated */
-static int update_cfg_crc(struct lib_context *lc, struct dev_info *di,
-			  struct ddf1 *ddf1)
+static int
+update_cfg_crc(struct lib_context *lc, struct dev_info *di, struct ddf1 *ddf1)
 {
 	static struct ddf1_record_handler handlers = {
 		.vd = crc32_vd,
@@ -121,17 +125,17 @@
 }
 
 /* Checks the CRC for a particular table */
-static int check_crc(struct lib_context *lc, struct dev_info *di,
-		     struct crc_info *ci)
+static int
+check_crc(struct lib_context *lc, struct dev_info *di, struct crc_info *ci)
 {
 	uint32_t crc32;
 
 	crc32 = do_crc32(lc, ci);
 	if (*ci->crc != crc32)
 		log_print(lc, "%s: %s with CRC %X, expected %X on %s",
-			 HANDLER, ci->text, crc32, *ci->crc, di->path);
-	
-	
+			  HANDLER, ci->text, crc32, *ci->crc, di->path);
+
+
 	return 1;
 
 }
@@ -155,8 +159,8 @@
 #undef CHECK_CRC
 
 /* Process the configuration records to have their CRCs checked */
-static int check_cfg_crc(struct lib_context *lc, struct dev_info *di,
-			 struct ddf1 *ddf1)
+static int
+check_cfg_crc(struct lib_context *lc, struct dev_info *di, struct ddf1 *ddf1)
 {
 	struct ddf1_record_handler handlers = {
 		.vd = vd_check_crc,
@@ -169,27 +173,35 @@
 
 /* Processes all of the DDF1 information for having their CRCs updated*/
 enum all_type { CHECK, UPDATE };
-static int all_crcs(struct lib_context *lc, struct dev_info *di,
-		    struct ddf1 *ddf1, enum all_type type)
+static int
+all_crcs(struct lib_context *lc, struct dev_info *di,
+	 struct ddf1 *ddf1, enum all_type type)
 {
 	int ret = 1;
 	uint32_t crc;
 	struct crc_info crcs[] = {
-		{ ddf1->primary, &ddf1->primary->crc, 
-		  sizeof(*ddf1->primary), "primary header" },
-		{ ddf1->secondary, &ddf1->secondary->crc,
-		  sizeof(*ddf1->secondary), "secondary header" },
-		{ ddf1->adapter, &ddf1->adapter->crc, 
-		  ddf1->primary->adapter_data_len * DDF1_BLKSIZE, "adapter" },
-		{ ddf1->disk_data, &ddf1->disk_data->crc, 
-		  ddf1->primary->disk_data_len * DDF1_BLKSIZE, "disk data" },
-		{ ddf1->pd_header, &ddf1->pd_header->crc, 
-		  ddf1->primary->phys_drive_len * DDF1_BLKSIZE,
-		  "physical drives" },
-		{ ddf1->vd_header, &ddf1->vd_header->crc, 
-		  ddf1->primary->virt_drive_len * DDF1_BLKSIZE,
-		  "virtual drives" },
-	}, *c = ARRAY_END(crcs);
+		{ddf1->primary, &ddf1->primary->crc,
+		 sizeof(*ddf1->primary), "primary header"}
+		,
+		{ddf1->secondary, &ddf1->secondary->crc,
+		 sizeof(*ddf1->secondary), "secondary header"}
+		,
+		{ddf1->adapter, &ddf1->adapter->crc,
+		 ddf1->primary->adapter_data_len * DDF1_BLKSIZE, "adapter"}
+		,
+		{ddf1->disk_data, &ddf1->disk_data->crc,
+		 ddf1->primary->disk_data_len * DDF1_BLKSIZE, "disk data"}
+		,
+		{ddf1->pd_header, &ddf1->pd_header->crc,
+		 ddf1->primary->phys_drive_len * DDF1_BLKSIZE,
+		 "physical drives"}
+		,
+		{ddf1->vd_header, &ddf1->vd_header->crc,
+		 ddf1->primary->virt_drive_len * DDF1_BLKSIZE,
+		 "virtual drives"}
+		,
+	}
+	, *c = ARRAY_END(crcs);
 
 	while (c-- > crcs) {
 		if (c->p) {
@@ -203,19 +215,21 @@
 	}
 
 	return type == CHECK ? (ret & check_cfg_crc(lc, di, ddf1)) :
-			       update_cfg_crc(lc, di, ddf1);
+		update_cfg_crc(lc, di, ddf1);
 }
 
 /* Processes the tables to check their CRCs */
-int ddf1_check_all_crcs(struct lib_context *lc, struct dev_info *di,
-			struct ddf1 *ddf1)
+int
+ddf1_check_all_crcs(struct lib_context *lc, struct dev_info *di,
+		    struct ddf1 *ddf1)
 {
 	return all_crcs(lc, di, ddf1, CHECK);
 }
 
 /* Processes all of the DDF1 information for having their CRCs updated */
-void ddf1_update_all_crcs(struct lib_context *lc, struct dev_info *di,
-			  struct ddf1 *ddf1)
+void
+ddf1_update_all_crcs(struct lib_context *lc, struct dev_info *di,
+		     struct ddf1 *ddf1)
 {
 	all_crcs(lc, di, ddf1, UPDATE);
 }
--- dmraid/lib/format/ddf/ddf1_cvt.c	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1_cvt.c	2008/06/20 21:52:17	1.2
@@ -20,7 +20,8 @@
 #include <datastruct/byteorder.h>
 
 /* Convert a DDF header */
-void ddf1_cvt_header(struct ddf1 *ddf1, struct ddf1_header *hdr)
+void
+ddf1_cvt_header(struct ddf1 *ddf1, struct ddf1_header *hdr)
 {
 	if (BYTE_ORDER == ddf1->disk_format)
 		return;
@@ -57,7 +58,8 @@
 }
 
 /* Convert DDF adapter data */
-void ddf1_cvt_adapter(struct ddf1 *ddf1, struct ddf1_adapter *hdr)
+void
+ddf1_cvt_adapter(struct ddf1 *ddf1, struct ddf1_adapter *hdr)
 {
 	if (BYTE_ORDER == ddf1->disk_format)
 		return;
@@ -71,7 +73,8 @@
 }
 
 /* Convert physical disk data */
-void ddf1_cvt_disk_data(struct ddf1 *ddf1, struct ddf1_disk_data *hdr)
+void
+ddf1_cvt_disk_data(struct ddf1 *ddf1, struct ddf1_disk_data *hdr)
 {
 	if (BYTE_ORDER == ddf1->disk_format)
 		return;
@@ -82,7 +85,8 @@
 }
 
 /* Convert physical drive header data */
-void ddf1_cvt_phys_drive_header(struct ddf1 *ddf1, struct ddf1_phys_drives *hdr)
+void
+ddf1_cvt_phys_drive_header(struct ddf1 *ddf1, struct ddf1_phys_drives *hdr)
 {
 	if (BYTE_ORDER == ddf1->disk_format)
 		return;
@@ -94,7 +98,8 @@
 }
 
 /* Convert physical drive data */
-void ddf1_cvt_phys_drive(struct ddf1 *ddf1, struct ddf1_phys_drive *hdr)
+void
+ddf1_cvt_phys_drive(struct ddf1 *ddf1, struct ddf1_phys_drive *hdr)
 {
 	if (BYTE_ORDER == ddf1->disk_format)
 		return;
@@ -106,7 +111,8 @@
 }
 
 /* Convert virtual drive header data */
-void ddf1_cvt_virt_drive_header(struct ddf1 *ddf1, struct ddf1_virt_drives *hdr)
+void
+ddf1_cvt_virt_drive_header(struct ddf1 *ddf1, struct ddf1_virt_drives *hdr)
 {
 	if (BYTE_ORDER == ddf1->disk_format)
 		return;
@@ -118,7 +124,8 @@
 }
 
 /* Convert virtual drive data */
-void ddf1_cvt_virt_drive(struct ddf1 *ddf1, struct ddf1_virt_drive *hdr)
+void
+ddf1_cvt_virt_drive(struct ddf1 *ddf1, struct ddf1_virt_drive *hdr)
 {
 	if (BYTE_ORDER == ddf1->disk_format)
 		return;
@@ -128,8 +135,9 @@
 }
 
 /* Convert config record data */
-int ddf1_cvt_config_record(struct lib_context *lc, struct dev_info *di,
-			   struct ddf1 *ddf1, int idx)
+int
+ddf1_cvt_config_record(struct lib_context *lc, struct dev_info *di,
+		       struct ddf1 *ddf1, int idx)
 {
 	unsigned int i;
 	uint16_t max_pds;
@@ -148,7 +156,8 @@
 	if (ddf1->primary->signature == DDF1_HEADER_BACKWARDS)
 		CVT32(x);
 
-	off = ((uint64_t*) (((uint8_t*) hdr) + sizeof(*hdr) + (x * sizeof(x))));
+	off = ((uint64_t *) (((uint8_t *) hdr) + sizeof(*hdr) +
+			     (x * sizeof(x))));
 
 	CVT32(hdr->signature);
 	CVT32(hdr->crc);
@@ -172,8 +181,9 @@
 }
 
 /* Convert spare records */
-int ddf1_cvt_spare_record(struct lib_context *lc, struct dev_info *di,
-			  struct ddf1 *ddf1, int idx)
+int
+ddf1_cvt_spare_record(struct lib_context *lc, struct dev_info *di,
+		      struct ddf1 *ddf1, int idx)
 {
 	uint16_t x, i;
 	struct ddf1_spare_header *sh = SR(ddf1, idx);
@@ -196,7 +206,8 @@
 	return 1;
 }
 
-void ddf1_cvt_records(struct lib_context *lc, struct dev_info *di,
+void
+ddf1_cvt_records(struct lib_context *lc, struct dev_info *di,
 		 struct ddf1 *ddf1, int in_cpu_format)
 {
 	static struct ddf1_record_handler handlers = {
@@ -208,8 +219,8 @@
 }
 
 /* Convert endianness of all metadata */
-void ddf1_cvt_all(struct lib_context *lc, struct ddf1 *ddf1,
-		  struct dev_info *di)
+void
+ddf1_cvt_all(struct lib_context *lc, struct ddf1 *ddf1, struct dev_info *di)
 {
 	int i;
 	uint16_t pds = 0, vds = 0;
--- dmraid/lib/format/ddf/ddf1_cvt.h	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1_cvt.h	2008/06/20 21:52:17	1.2
@@ -29,7 +29,7 @@
 int ddf1_cvt_spare_record(struct lib_context *lc, struct dev_info *di,
 			  struct ddf1 *ddf1, int idx);
 void ddf1_cvt_records(struct lib_context *lc, struct dev_info *di,
-		 struct ddf1 *ddf1, int in_cpu_format);
+		      struct ddf1 *ddf1, int in_cpu_format);
 void ddf1_cvt_all(struct lib_context *lc, struct ddf1 *ddf1,
 		  struct dev_info *di);
 
--- dmraid/lib/format/ddf/ddf1_dump.c	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1_dump.c	2008/06/20 21:52:17	1.2
@@ -28,8 +28,9 @@
 _dp_guid(lc, name, P_OFF(x, basevar, x), DDF1_GUID_LENGTH);\
 } while (0)
 
-static void _dp_guid(struct lib_context *lc, const char *name,
-		     unsigned int offset, void *data, unsigned int len)
+static void
+_dp_guid(struct lib_context *lc, const char *name,
+	 unsigned int offset, void *data, unsigned int len)
 {
 	char *p;
 	int i;
@@ -52,17 +53,19 @@
 #endif
 
 /* Dump top */
-static void dump_top(struct lib_context *lc, struct dev_info *di,
-		     struct ddf1 *ddf1, const char *handler)
+static void
+dump_top(struct lib_context *lc, struct dev_info *di,
+	 struct ddf1 *ddf1, const char *handler)
 {
 	log_print(lc, "%s (%s):", di->path, handler);
 	log_print(lc, "DDF1 anchor at %llu with tables in %s-endian format.",
 		  ddf1->anchor_offset / DDF1_BLKSIZE,
 		  (ddf1->disk_format == LITTLE_ENDIAN ? "little" : "big"));
 }
-	
+
 /* Dump DDF tables. */
-static void dump_header(struct lib_context *lc, struct ddf1_header *dh)
+static void
+dump_header(struct lib_context *lc, struct ddf1_header *dh)
 {
 	if (!dh)
 		return;
@@ -105,7 +108,8 @@
 	DP("vendor_len:\t%d", dh, dh->vendor_len);
 }
 
-static void dump_adapter(struct lib_context *lc, struct ddf1_adapter *da)
+static void
+dump_adapter(struct lib_context *lc, struct ddf1_adapter *da)
 {
 	if (!da)
 		return;
@@ -120,7 +124,8 @@
 	DP("pci subdevice:\t0x%X", da, da->pci_subdevice);
 }
 
-static void dump_disk_data(struct lib_context *lc, struct ddf1_disk_data *fg)
+static void
+dump_disk_data(struct lib_context *lc, struct ddf1_disk_data *fg)
 {
 	log_print(lc, "Disk Data at %p", fg);
 	DP("signature:\t0x%X", fg, fg->signature);
@@ -131,8 +136,8 @@
 	DP("forced_guid_flag:\t%d", fg, fg->forced_guid_flag);
 }
 
-static void dump_phys_drive_header(struct lib_context *lc,
-				   struct ddf1_phys_drives *pd)
+static void
+dump_phys_drive_header(struct lib_context *lc, struct ddf1_phys_drives *pd)
 {
 	log_print(lc, "Physical Drive Header at %p", pd);
 	DP("signature:\t0x%X", pd, pd->signature);
@@ -141,7 +146,8 @@
 	DP("max drives:\t%d", pd, pd->max_drives);
 }
 
-static void dump_phys_drive(struct lib_context *lc, struct ddf1_phys_drive *pd)
+static void
+dump_phys_drive(struct lib_context *lc, struct ddf1_phys_drive *pd)
 {
 	log_print(lc, "Physical Drive at %p", pd);
 	DP_GUID("guid:\t\t", pd, pd->guid);
@@ -152,8 +158,8 @@
 	DP_BUF("path info:\t", pd, pd->path_info, 18);
 }
 
-static void dump_virt_drive_header(struct lib_context *lc,
-				   struct ddf1_virt_drives *vd)
+static void
+dump_virt_drive_header(struct lib_context *lc, struct ddf1_virt_drives *vd)
 {
 	log_print(lc, "Virtual Drive Header at %p", vd);
 	DP("signature:\t0x%X", vd, vd->signature);
@@ -162,7 +168,8 @@
 	DP("max drives:\t%d", vd, vd->max_drives);
 }
 
-static void dump_virt_drive(struct lib_context *lc, struct ddf1_virt_drive *vd)
+static void
+dump_virt_drive(struct lib_context *lc, struct ddf1_virt_drive *vd)
 {
 	log_print(lc, "Virtual Drive at %p", vd);
 	DP_GUID("guid:\t\t", vd, vd->guid);
@@ -173,8 +180,9 @@
 	DP_BUF("name:\t\t", vd, vd->name, 16);
 }
 
-static int dump_config_record(struct lib_context *lc, struct dev_info *di,
-			      struct ddf1 *ddf, int idx)
+static int
+dump_config_record(struct lib_context *lc, struct dev_info *di,
+		   struct ddf1 *ddf, int idx)
 {
 	int i;
 	uint16_t x;
@@ -220,10 +228,11 @@
 			  cfg_drive_offsets[i]);
 	}
 	return 1;
-}	
+}
 
-static int dump_spares(struct lib_context *lc, struct dev_info *di,
-		       struct ddf1 *ddf1, int idx)
+static int
+dump_spares(struct lib_context *lc, struct dev_info *di,
+	    struct ddf1 *ddf1, int idx)
 {
 	int i;
 	struct ddf1_spare_header *sh = SR(ddf1, idx);
@@ -244,8 +253,9 @@
 	return 1;
 }
 
-static void dump_config_records(struct lib_context *lc, struct dev_info *di,
-				struct ddf1 *ddf1)
+static void
+dump_config_records(struct lib_context *lc, struct dev_info *di,
+		    struct ddf1 *ddf1)
 {
 	static struct ddf1_record_handler handlers = {
 		.vd = dump_config_record,
@@ -256,8 +266,9 @@
 }
 
 /* Dump the entire table */
-void ddf1_dump_all(struct lib_context *lc, struct dev_info *di,
-		   struct ddf1 *ddf1, const char *handler)
+void
+ddf1_dump_all(struct lib_context *lc, struct dev_info *di,
+	      struct ddf1 *ddf1, const char *handler)
 {
 	int i;
 
--- dmraid/lib/format/ddf/ddf1_lib.c	2008/02/22 17:06:54	1.2
+++ dmraid/lib/format/ddf/ddf1_lib.c	2008/06/20 21:52:17	1.3
@@ -20,9 +20,10 @@
 #include <datastruct/byteorder.h>
 
 /* Figure out what endian conversions we need */
-int ddf1_endianness(struct lib_context *lc, struct ddf1 *ddf1)
+int
+ddf1_endianness(struct lib_context *lc, struct ddf1 *ddf1)
 {
-	uint8_t *ptr = (uint8_t*) &ddf1->anchor.signature;
+	uint8_t *ptr = (uint8_t *) & ddf1->anchor.signature;
 
 	if (ptr[0] == 0xDE && ptr[1] == 0x11)
 		return BIG_ENDIAN;
@@ -33,7 +34,8 @@
 }
 
 /* Find the beginning of all DDF metadata */
-uint64_t ddf1_beginning(struct ddf1 *ddf1)
+uint64_t
+ddf1_beginning(struct ddf1 *ddf1)
 {
 	uint64_t start;
 	struct ddf1_header *h = &ddf1->anchor;
@@ -52,51 +54,52 @@
 }
 
 /* Helper for CR_OFF */
-uint16_t ddf1_cr_off_maxpds_helper(struct ddf1 *ddf1)
+uint16_t
+ddf1_cr_off_maxpds_helper(struct ddf1 * ddf1)
 {
 	struct ddf1_header *h = ddf1->primary;
 
 	/* The 0xFFFF nonsense is a weird Adaptec quirk */
-//	bz211016
-//	return (h->max_primary_elements == 0xFFFF && ddf1->adaptec_mode) ?
+//      bz211016
+//      return (h->max_primary_elements == 0xFFFF && ddf1->adaptec_mode) ?
 	return (h->max_primary_elements == 0xFFFF) ?
 		h->max_phys_drives : h->max_primary_elements;
 }
 
 /* Process DDF1 records depending on type */
-int ddf1_process_records(struct lib_context *lc, struct dev_info *di,
-			 struct ddf1_record_handler *handler,
-			 struct ddf1 *ddf1, int in_cpu_format)
+int
+ddf1_process_records(struct lib_context *lc, struct dev_info *di,
+		     struct ddf1_record_handler *handler,
+		     struct ddf1 *ddf1, int in_cpu_format)
 {
 	unsigned int i, cfgs = NUM_CONFIG_ENTRIES(ddf1);
 	uint32_t x;
 
 	for (i = 0; i < cfgs; i++) {
-		x = *((uint32_t*) CR(ddf1, i));
-		if (!in_cpu_format &&
-		    BYTE_ORDER != ddf1->disk_format)
+		x = *((uint32_t *) CR(ddf1, i));
+		if (!in_cpu_format && BYTE_ORDER != ddf1->disk_format)
 			CVT32(x);
 
 		switch (x) {
-			case DDF1_VD_CONFIG_REC:
-				if (!handler->vd(lc, di, ddf1, i))
-					return 0;
+		case DDF1_VD_CONFIG_REC:
+			if (!handler->vd(lc, di, ddf1, i))
+				return 0;
 
-				break;
+			break;
 
-			case DDF1_SPARE_REC:
-				if (!handler->spare(lc, di, ddf1, i))
-					return 0;
+		case DDF1_SPARE_REC:
+			if (!handler->spare(lc, di, ddf1, i))
+				return 0;
 
-				break;
+			break;
 
-			case 0: /* Adaptec puts zero in this field??? */
-			case DDF1_INVALID:
-				break;
+		case 0:	/* Adaptec puts zero in this field??? */
+		case DDF1_INVALID:
+			break;
 
-			default:
-				log_warn(lc, "%s: Unknown config record %d.",
-					 di->path, x);
+		default:
+			log_warn(lc, "%s: Unknown config record %d.",
+				 di->path, x);
 		}
 	}
 
--- dmraid/lib/format/ddf/ddf1_lib.h	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1_lib.h	2008/06/20 21:52:17	1.2
@@ -14,12 +14,14 @@
 #define _DDF1_LIB_H
 
 /* Cpmpare two GUIDs */
-static inline uint8_t _and(uint8_t *p)
+static inline uint8_t
+_and(uint8_t * p)
 {
 	return p[20] & p[21] & p[22] & p[23];
 }
 
-static inline int guidcmp(uint8_t *one, uint8_t *two)
+static inline int
+guidcmp(uint8_t * one, uint8_t * two)
 {
 	int x = memcmp(one, two, DDF1_GUID_LENGTH - 4);
 
@@ -30,20 +32,21 @@
 }
 
 /* Byte offset for sector */
-static inline uint64_t to_bytes(uint64_t sector)
+static inline uint64_t
+to_bytes(uint64_t sector)
 {
 	return sector * DDF1_BLKSIZE;
 }
 
-uint64_t ddf1_beginning(struct ddf1 *ddf1);
+uint64_t ddf1_beginning(struct ddf1 * ddf1);
 uint16_t ddf1_cr_off_maxpds_helper(struct ddf1 *ddf1);
 int ddf1_endianness(struct lib_context *lc, struct ddf1 *ddf1);
 
 struct ddf1_record_handler {
-	int (*vd)(struct lib_context *lc, struct dev_info *di,
-		  struct ddf1 *ddf1, int idx);
-	int (*spare)(struct lib_context *lc, struct dev_info *di,
-		     struct ddf1 *ddf1, int idx);
+	int (*vd) (struct lib_context * lc, struct dev_info * di,
+		   struct ddf1 * ddf1, int idx);
+	int (*spare) (struct lib_context * lc, struct dev_info * di,
+		      struct ddf1 * ddf1, int idx);
 };
 
 int ddf1_process_records(struct lib_context *lc, struct dev_info *di,
--- dmraid/lib/format/partition/dos.c	2008/04/02 13:35:31	1.3
+++ dmraid/lib/format/partition/dos.c	2008/06/20 21:52:18	1.4
@@ -25,19 +25,19 @@
 static const char *handler = HANDLER;
 
 /* Make up RAID device name. */
-static size_t _name(struct lib_context *lc, struct raid_dev *rd,
-		    unsigned short partition, char *str, size_t len,
-		    unsigned char type)
+static size_t
+_name(struct lib_context *lc, struct raid_dev *rd,
+      unsigned short partition, char *str, size_t len, unsigned char type)
 {
 	const char *base = get_basename(lc, rd->di->path);
 
 	return type ? snprintf(str, len, "%s%s%u", base, OPT_STR_PARTCHAR(lc),
-			       partition) :
-		      snprintf(str, len, "%s", base);
+			       partition) : snprintf(str, len, "%s", base);
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		   unsigned int part, unsigned char type)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd,
+     unsigned int part, unsigned char type)
 {
 	size_t len;
 	char *ret;
@@ -57,7 +57,8 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu	NULL
 #else
-static void to_cpu(void *meta)
+static void
+to_cpu(void *meta)
 {
 	struct dos *dos = meta;
 	struct dos_partition *part = dos->partitions;
@@ -71,7 +72,8 @@
 }
 #endif
 
-static int is_dos(struct lib_context *lc, struct dev_info *di, void *meta)
+static int
+is_dos(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct dos *dos = meta;
 	struct dos_partition *part;
@@ -87,8 +89,8 @@
 	return 1;
 }
 
-static void dos_file_metadata(struct lib_context *lc, struct dev_info *di,
-			      void *meta)
+static void
+dos_file_metadata(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	if (OPT_DUMP(lc))
 		log_print(lc, "%s: filing metadata not supported (use fdisk "
@@ -98,7 +100,8 @@
 /* Allocate a DOS partition sector struct and read the data. */
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *dos_read(struct lib_context *lc, struct dev_info *di)
+static struct raid_dev *
+dos_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
 			     sizeof(struct dos), DOS_CONFIGOFFSET,
@@ -107,23 +110,24 @@
 }
 
 /* Support functions for dos_group to read the partition table(s). */
-static int part_is_extended (struct dos_partition *part)
+static int
+part_is_extended(struct dos_partition *part)
 {
 	return part->type == PARTITION_EXT ||
-	       part->type == PARTITION_EXT_LBA ||
-	       part->type == PARTITION_LINUX_EXT;
+		part->type == PARTITION_EXT_LBA ||
+		part->type == PARTITION_LINUX_EXT;
 }
 
 /* Get a partition start offset relative to a base location. */
-static uint64_t get_part_start(const struct dos_partition *raw_part,
-			     uint64_t offset)
+static uint64_t
+get_part_start(const struct dos_partition *raw_part, uint64_t offset)
 {
 	return (uint64_t) raw_part->start + offset;
 }
 
 /* RAID set allocation support function. */
-static struct raid_set *_alloc_raid_set(struct lib_context *lc,
-					struct raid_dev *rd)
+static struct raid_set *
+_alloc_raid_set(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs;
 
@@ -135,9 +139,9 @@
 		return NULL;
 
 	rs->status = rd->status;
-	rs->type   = rd->type;
+	rs->type = rd->type;
 
-       	if (!(rs->name = dbg_strdup(rd->name))) {
+	if (!(rs->name = dbg_strdup(rd->name))) {
 		dbg_free(rs);
 		rs = NULL;
 		log_alloc_err(lc, handler);
@@ -147,12 +151,12 @@
 }
 
 /* Check sector vs. RAID device end */
-static int rd_check_end(struct lib_context *lc,
-			struct raid_dev *rd, uint64_t sector)
+static int
+rd_check_end(struct lib_context *lc, struct raid_dev *rd, uint64_t sector)
 {
 	if (sector > rd->di->sectors)
 		LOG_ERR(lc, 1, "%s: partition address past end of RAID device",
-		 	handler);
+			handler);
 
 	return 0;
 }
@@ -161,9 +165,10 @@
  * Allocate a DOS RAID device and a set.
  * Set the device up and add it to the set.
  */
-static int _create_rs_and_rd(struct lib_context *lc, struct raid_dev *rd,
-			     struct dos_partition *raw_part, uint64_t sector,
-			     unsigned int part)
+static int
+_create_rs_and_rd(struct lib_context *lc, struct raid_dev *rd,
+		  struct dos_partition *raw_part, uint64_t sector,
+		  unsigned int part)
 {
 	struct raid_dev *r;
 	struct raid_set *rs;
@@ -174,7 +179,7 @@
 	if (!(r->di = alloc_dev_info(lc, rd->di->path)))
 		goto free_raid_dev;
 
-        if (!(r->name = name(lc, rd, part, 1)))
+	if (!(r->name = name(lc, rd, part, 1)))
 		goto free_di;
 
 	r->fmt = rd->fmt;
@@ -197,9 +202,9 @@
 
 	return 1;
 
-  free_di:
+      free_di:
 	free_dev_info(lc, r->di);
-  free_raid_dev:
+      free_raid_dev:
 	free_raid_dev(lc, &r);
 
 	return 0;
@@ -215,14 +220,16 @@
  * Partition code inspired by libparted and squeezed for this purpose (lemon).
  */
 /* FIXME: Check for position of partition */
-static int is_partition(struct dos_partition *p, uint64_t start_sector)
+static int
+is_partition(struct dos_partition *p, uint64_t start_sector)
 {
 	return p->type != PARTITION_EMPTY && p->length && p->start;
 }
 
-static int group_rd_extended(struct lib_context *lc, struct raid_dev *rd,
-			     uint64_t start_sector, uint64_t *extended_root,
-			     unsigned int part)
+static int
+group_rd_extended(struct lib_context *lc, struct raid_dev *rd,
+		  uint64_t start_sector, uint64_t * extended_root,
+		  unsigned int part)
 {
 	int ret = 0;
 	uint64_t new_start_sector;
@@ -240,7 +247,7 @@
 #endif
 	if (dos->magic == PARTITION_MAGIC_MAGIC)
 		goto out;
-	
+
 	/* Check magic to see if this is a real partition table. */
 	if (dos->magic != DOS_MAGIC)
 		goto out;
@@ -249,13 +256,13 @@
 	 * Logical partition tables only have two entries,
 	 * one for the partition and one for the next partition table.
 	 */
-	 
+
 	/*
 	 * An entry pointing to the present logical partition.
 	 * It is an offset from the present partition table location.
 	 */
 	p1 = dos->partitions;
-	
+
 	/*
 	 * An entry pointing to the next logical partition table.
 	 * It is an offset from the main extended partition start.
@@ -276,25 +283,25 @@
 	if (!*extended_root)
 		*extended_root = start_sector;
 	new_start_sector = get_part_start(p2, *extended_root);
-	
+
 	if (is_partition(p2, start_sector) &&
 	    !group_rd_extended(lc, rd, new_start_sector, extended_root, part))
 		goto out;
 
 	ret = 1;
 
-  out:
+      out:
 	dbg_free(dos);
 	return ret;
 }
 
 /* Handle primary partitions. */
-static int group_rd(struct lib_context *lc, struct raid_dev *rd,
-		    uint64_t start_sector)
+static int
+group_rd(struct lib_context *lc, struct raid_dev *rd, uint64_t start_sector)
 {
 	unsigned int i;
 	uint64_t part_start, part_end,
-		 extended_part_start = 0, extended_root = 0;
+		extended_part_start = 0, extended_root = 0;
 	struct dos *dos = META(rd, dos);
 	struct dos_partition *raw_table_entry;
 
@@ -314,8 +321,8 @@
 		 * start of drive.
 		 */
 		part_start = get_part_start(raw_table_entry, start_sector);
-		part_end   = part_start + raw_table_entry->length;
-		
+		part_end = part_start + raw_table_entry->length;
+
 		/* Avoid infinite recursion (mostly). */
 		if (part_start == start_sector)
 			continue;
@@ -336,19 +343,19 @@
 					    start_sector, i + 1))
 			return 0;
 	}
-	
+
 	/* When we are finished with all the primary partitions,
 	 * go do the extended partition if we have one.
 	 * It always starts with partition 5.
 	 */
 	return extended_part_start ?
-	       group_rd_extended(lc, rd, extended_part_start,
-				 &extended_root, 5) : 1;
+		group_rd_extended(lc, rd, extended_part_start,
+				  &extended_root, 5) : 1;
 }
 
 /* Add a DOS RAID device to a set */
-static struct raid_set *dos_group(struct lib_context *lc,
-				    struct raid_dev *rd)
+static struct raid_set *
+dos_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	/*
 	 * Once we get here, a DOS partition table
@@ -363,34 +370,36 @@
 	 * to something else for some strange partitioning scheme because the
 	 * code will handle it.
 	 */
-	return group_rd(lc, rd, 0) ? (struct raid_set*) 1 : NULL;
+	return group_rd(lc, rd, 0) ? (struct raid_set *) 1 : NULL;
 }
 
 /*
  * Check integrity of a DOS RAID set.
  */
-static int dos_check(struct lib_context *lc, struct raid_set *rs)
+static int
+dos_check(struct lib_context *lc, struct raid_set *rs)
 {
-	return 1; /* Nice, eh ? */
+	return 1;		/* Nice, eh ? */
 }
 
 static struct dmraid_format dos_format = {
-	.name	= HANDLER,
-	.descr	= "DOS partitions on SW RAIDs",
-	.caps	= NULL, /* Not supported */
+	.name = HANDLER,
+	.descr = "DOS partitions on SW RAIDs",
+	.caps = NULL,		/* Not supported */
 	.format = FMT_PARTITION,
-	.read	= dos_read,
-	.write	= NULL, /* Not supported */
-	.group	= dos_group,
-	.check	= dos_check,
-	.events	= NULL, /* Not supported */
+	.read = dos_read,
+	.write = NULL,		/* Not supported */
+	.group = dos_group,
+	.check = dos_check,
+	.events = NULL,		/* Not supported */
 #ifdef DMRAID_NATIVE_LOG
-	.log	= NULL, /* Not supported; use fdisk and friends */
+	.log = NULL,		/* Not supported; use fdisk and friends */
 #endif
 };
 
 /* Register this format handler with the format core. */
-int register_dos(struct lib_context *lc)
+int
+register_dos(struct lib_context *lc)
 {
 	return register_format_handler(lc, &dos_format);
 }
@@ -401,8 +410,9 @@
  * For a DOS partition we essentially just save the
  * partition table sector and let dos_group do the rest...
  */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct dos *dos = meta;
 
@@ -411,16 +421,16 @@
 
 	rd->meta_areas->offset = DOS_CONFIGOFFSET >> 9;
 	rd->meta_areas->size = sizeof(*dos);
-	rd->meta_areas->area = (void*) dos;
+	rd->meta_areas->area = (void *) dos;
 
-        rd->di  = di;
+	rd->di = di;
 	rd->fmt = &dos_format;
 
-        rd->status = s_ok; /* Always :-) */
-	rd->type   = t_partition;
+	rd->status = s_ok;	/* Always :-) */
+	rd->type = t_partition;
 
-	rd->offset   = DOS_DATAOFFSET;
-	rd->sectors  = di->sectors;
+	rd->offset = DOS_DATAOFFSET;
+	rd->sectors = di->sectors;
 
-        return (rd->name = name(lc, rd, 0, 0)) ? 1 : 0;
+	return (rd->name = name(lc, rd, 0, 0)) ? 1 : 0;
 }
--- dmraid/lib/format/partition/dos.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/partition/dos.h	2008/06/20 21:52:18	1.2
@@ -23,29 +23,29 @@
 #define	DOS_DATAOFFSET		0
 
 struct chs {
-        uint8_t         head;
-        uint8_t         sector;
-        uint8_t         cylinder;
+	uint8_t head;
+	uint8_t sector;
+	uint8_t cylinder;
 } __attribute__ ((packed));
 
 struct dos_partition {
-        uint8_t		boot_ind;	/* 00:  0x80 - active */
-	struct chs	chs_start;	/* 01: */
-	uint8_t		type;		/* 04: partition type */
+	uint8_t boot_ind;	/* 00:  0x80 - active */
+	struct chs chs_start;	/* 01: */
+	uint8_t type;		/* 04: partition type */
 #define PARTITION_EMPTY		0x00
 #define PARTITION_EXT		0x05
 #define PARTITION_EXT_LBA	0x0f
 #define PARTITION_LINUX_EXT	0x85
 #define PARTITION_GPT		0xee
-	struct chs	chs_end;	/* 05: */
-	uint32_t	start;		/* 08: starting sector from 0 */
-	uint32_t	length;		/* 0c: nr of sectors in partition */
+	struct chs chs_end;	/* 05: */
+	uint32_t start;		/* 08: starting sector from 0 */
+	uint32_t length;	/* 0c: nr of sectors in partition */
 } __attribute__ ((packed));
 
 struct dos {
-	uint8_t			boot_code [446];
-	struct dos_partition	partitions [4];
-	uint16_t		magic;
+	uint8_t boot_code[446];
+	struct dos_partition partitions[4];
+	uint16_t magic;
 #define	DOS_MAGIC	0xAA55
 #define	PARTITION_MAGIC_MAGIC	0xF6F6
 } __attribute__ ((packed));
--- dmraid/lib/format/template/template.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/template/template.c	2008/06/20 21:52:18	1.2
@@ -24,14 +24,14 @@
 
 /* Make up RAID device name. */
 /* CODEME: implement creation of senseful name for the RAID device */
-static size_t _name(struct template *template, char *str, size_t len,
-		    unsigned int subset)
+static size_t
+_name(struct template *template, char *str, size_t len, unsigned int subset)
 {
 	return snprintf(str, len, "template");
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *
+name(struct lib_context *lc, struct raid_dev *rd, unsigned int subset)
 {
 	size_t len;
 	char *ret;
@@ -40,7 +40,8 @@
 	if ((ret = dbg_malloc((len = _name(template, NULL, 0, subset) + 1)))) {
 		_name(template, ret, len, subset);
 		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN);
-	} else
+	}
+	else
 		log_alloc_err(lc, handler);
 
 	return ret;
@@ -52,13 +53,14 @@
  * (see metadata.h for generic ones)
  */
 static struct types types[] = {
-	{ TEMPLATE_T_SPAN,  t_linear },
-	{ TEMPLATE_T_RAID0, t_raid0 },
-        { 0, t_undef}
+	{TEMPLATE_T_SPAN, t_linear},
+	{TEMPLATE_T_RAID0, t_raid0},
+	{0, t_undef}
 };
 
 /* Neutralize disk type using generic metadata type mapping function */
-static enum type template_type(struct lib_context *lc, struct raid_dev *rd)
+static enum type
+template_type(struct lib_context *lc, struct raid_dev *rd)
 {
 	return rd_type(types, (unsigned int) (META(rd, template))->type);
 }
@@ -70,17 +72,17 @@
 #if	BYTE_ORDER == LITTLE_ENDIAN
 #  define	to_cpu(x)
 #else
-static void to_cpu(struct template *template)
+static void
+to_cpu(struct template *template)
 {
 	CVT32(template->something);
-	...
-}
+...}
 #endif
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-static struct raid_dev *template_read(struct lib_context *lc,
-					struct dev_info *di)
+static struct raid_dev *
+template_read(struct lib_context *lc, struct dev_info *di)
 {
 	return read_raid_dev(lc, di, NULL,
 			     sizeof(struct template), TEMPLATE_CONFIGOFFSET,
@@ -91,25 +93,27 @@
  * Decide about ordering sequence of RAID device.
  * (Called by list_add_sorted().
  */
-static int dev_sort(struct list_head *pos, struct list_head *new)
+static int
+dev_sort(struct list_head *pos, struct list_head *new)
 {
 	return (META(RD(new), template))->disk_number <
-	       (META(RD(pos), template))->disk_number;
+		(META(RD(pos), template))->disk_number;
 }
 
 /*
  * Decide about ordering sequence of RAID device.
  * (Called by join_superset().
  */
-static int set_sort(struct list_head *pos, struct list_head *new)
+static int
+set_sort(struct list_head *pos, struct list_head *new)
 {
 	return _subset(META(RD_RS(RS(new)), via)) <
-	       _subset(META(RD_RS(RS(pos)), via));
+		_subset(META(RD_RS(RS(pos)), via));
 }
 
 /* Add a Template RAID device to a set */
-static struct raid_set *template_group(struct lib_context *lc,
-					 struct raid_dev *rd)
+static struct raid_set *
+template_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	if (T_SPARE(rd))
 		return NULL;
@@ -124,8 +128,8 @@
 }
 
 /* CODEME: Write private RAID metadata to device */
-static int template_write(struct lib_context *lc,
-			  struct raid_dev *rd, int erase)
+static int
+template_write(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret;
 #if	BYTE_ORDER != LITTLE_ENDIAN
@@ -142,7 +146,8 @@
 /*
  * Check integrity of a RAID set.
  */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned int
+devices(struct raid_dev *rd, void *context)
 {
 	LOG_ERR(lc, 0, "%s: implement RAID device # function", handler);
 }
@@ -153,7 +158,8 @@
 	LOG_ERR(lc, 0, "%s: implement RAID device integrity checks", handler);
 }
 
-static int template_check(struct lib_context *lc, struct raid_set *rs)
+static int
+template_check(struct lib_context *lc, struct raid_set *rs)
 {
 	/* CODEME: implement */
 	return check_raid_set(lc, rs, devices, devices_context,
@@ -161,15 +167,16 @@
 }
 
 static struct event_handlers template_event_handlers = {
-	.io = event_io,	/* CODEME: */
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+	.io = event_io,		/* CODEME: */
+	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
 };
 
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about the RAID device.
  */
-static void template_log(struct lib_context *lc, struct raid_dev *rd)
+static void
+template_log(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct template *template = META(rd, template);
 
@@ -179,29 +186,31 @@
 #endif
 
 static struct dmraid_format template_format = {
-	.name	= HANDLER,
-	.descr	= "Template RAID",
-	.caps	= "(Insert RAID levels here)",
+	.name = HANDLER,
+	.descr = "Template RAID",
+	.caps = "(Insert RAID levels here)",
 	.format = FMT_RAID,
-	.read	= template_read,
-	.write	= template_write,
-	.group	= template_group,
-	.check	= template_check,
-	.events	= &template_event_handlers,
+	.read = template_read,
+	.write = template_write,
+	.group = template_group,
+	.check = template_check,
+	.events = &template_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
-	.log	= template_log,
+	.log = template_log,
 #endif
 };
 
 /* Register this format handler with the format core */
-int register_template(struct lib_context *lc)
+int
+register_template(struct lib_context *lc)
 {
 	return register_format_handler(lc, &template_format);
 }
 
 /* CODEME: Set the RAID device contents up derived from the TEMPLATE ones */
-static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
-		    struct dev_info *di, void *meta, union read_info *info)
+static int
+setup_rd(struct lib_context *lc, struct raid_dev *rd,
+	 struct dev_info *di, void *meta, union read_info *info)
 {
 	struct template *template = meta;
 
@@ -210,20 +219,20 @@
 
 	rd->meta_areas->offset = TEMPLATE_CONFIGOFFSET >> 9;
 	rd->meta_areas->size = sizeof(*template);
-	rd->meta_areas->area = (void*) template;
+	rd->meta_areas->area = (void *) template;
 
-        rd->di = di;
+	rd->di = di;
 	rd->fmt = &template_format;
 
-	rd->status = s_ok; /* CODEME: derive from metadata. */
-	rd->type   = template_type(template);
+	rd->status = s_ok;	/* CODEME: derive from metadata. */
+	rd->type = template_type(template);
 
 	rd->offset = TEMPLATE_DATAOFFSET;
 	/* CODEME: correct sectors. */
 	rd->sectors = rd->meta_areas->offset;
 
 
-        if ((rd->name = name(lc, rd, 1)))
+	if ((rd->name = name(lc, rd, 1)))
 		return 1;
 
 	return 0;
--- dmraid/lib/format/template/template.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/template/template.h	2008/06/20 21:52:18	1.2
@@ -25,14 +25,14 @@
 	uint32_t magic;		/* and/or metadata has a 'magic' number ? */
 #define	TEMPLATE_MAGIC_OK	0xABCDEF
 
-	uint8_t	type;		/* RAID level */
+	uint8_t type;		/* RAID level */
 #define	TEMPLATE_T_SPAN	0
 #define	TEMPLATE_T_RAID0 1
 
 	uint8_t disk_number;	/* Absolute disk number in set. */
 	/* etc. */
 
-	.......			/* members for numbers of disks, whatever... */
+	... ....		/* members for numbers of disks, whatever... */
 } __attribute__ ((packed));
 #endif
 
--- dmraid/lib/locking/locking.c	2008/02/22 17:04:36	1.2
+++ dmraid/lib/locking/locking.c	2008/06/20 21:52:18	1.3
@@ -16,7 +16,8 @@
 static int lf = -1;
 
 /* flock file. */
-static int lock(struct lib_context *lc, struct resource *res)
+static int
+lock(struct lib_context *lc, struct resource *res)
 {
 	/* Already locked. */
 	if (lf > -1)
@@ -36,7 +37,8 @@
 }
 
 /* Unlock file. */
-static void unlock(struct lib_context *lc, struct resource *res)
+static void
+unlock(struct lib_context *lc, struct resource *res)
 {
 	/* Not locked! */
 	if (lf == -1)
@@ -55,17 +57,18 @@
 
 /* File base locking interface. */
 static struct locking file_locking = {
-	.name	 = "file",
-	.lock 	 = lock,
-	.unlock	 = unlock,
+	.name = "file",
+	.lock = lock,
+	.unlock = unlock,
 };
 
-static int init_file_locking(struct lib_context *lc)
+static int
+init_file_locking(struct lib_context *lc)
 {
 	int ret = 0;
 	char *dir;
 
-	if (!(dir = get_dirname(lc, (char*) lock_file)))
+	if (!(dir = get_dirname(lc, (char *) lock_file)))
 		return 0;
 
 	if (!mk_dir(lc, dir))
@@ -78,7 +81,7 @@
 	lc->lock = &file_locking;
 	ret = 1;
 
-   out:
+      out:
 	dbg_free(dir);
 
 	return ret;
@@ -89,7 +92,8 @@
  */
 
 /* Initialize locking. */
-int init_locking(struct lib_context *lc)
+int
+init_locking(struct lib_context *lc)
 {
 	if (OPT_IGNORELOCKING(lc))
 		return 1;
@@ -101,13 +105,15 @@
 }
 
 /* Hide locking. */
-int lock_resource(struct lib_context *lc, struct resource *res)
+int
+lock_resource(struct lib_context *lc, struct resource *res)
 {
 	return OPT_IGNORELOCKING(lc) ? 1 : lc->lock->lock(lc, res);
 }
 
 /* Hide unlocking. */
-void unlock_resource(struct lib_context *lc, struct resource *res)
+void
+unlock_resource(struct lib_context *lc, struct resource *res)
 {
 	return OPT_IGNORELOCKING(lc) ? 1 : lc->lock->unlock(lc, res);
 }
--- dmraid/lib/log/log.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/log/log.c	2008/06/20 21:52:18	1.2
@@ -18,19 +18,21 @@
 	"FATAL",
 };
 
-static const char *_prefix(int level)
+static const char *
+_prefix(int level)
 {
 	return level < ARRAY_SIZE(_prefixes) ? _prefixes[level] : "UNDEF";
 }
 
-void plog(struct lib_context *lc, int level, int lf, const char *file,
-	  int line, const char *format, ...)
+void
+plog(struct lib_context *lc, int level, int lf, const char *file,
+     int line, const char *format, ...)
 {
 	int o = LC_VERBOSE, l = level;
 	FILE *f = stdout;
 	va_list ap;
 
- 	if (level == _PLOG_DEBUG) {
+	if (level == _PLOG_DEBUG) {
 		o = LC_DEBUG;
 		l -= _PLOG_WARN;
 	}
@@ -53,7 +55,8 @@
 }
 
 /* This is used so often in the metadata format handlers and elsewhere. */
-int log_alloc_err(struct lib_context *lc, const char *who)
+int
+log_alloc_err(struct lib_context *lc, const char *who)
 {
 	LOG_ERR(lc, 0, "%s: allocating", who);
 }
--- dmraid/lib/metadata/log_ops.c	2008/02/22 17:04:36	1.1
+++ dmraid/lib/metadata/log_ops.c	2008/06/20 21:52:18	1.2
@@ -9,7 +9,8 @@
  */
 #include "internal.h"
 
-void end_log(struct lib_context *lc, struct list_head *log)
+void
+end_log(struct lib_context *lc, struct list_head *log)
 {
 	struct list_head *pos, *tmp;
 
@@ -19,7 +20,8 @@
 	}
 }
 
-int revert_log(struct lib_context *lc, struct list_head *log)
+int
+revert_log(struct lib_context *lc, struct list_head *log)
 {
 	int writes_started = 0, ret = 0;
 	struct change *entry;
@@ -37,13 +39,14 @@
 			rd = entry->rd;
 			rd->type = t_spare;
 			list_del_init(&entry->rd->devs);
-		} else if (entry->type == WRITE_METADATA) {
+		}
+		else if (entry->type == WRITE_METADATA) {
 			writes_started = 1;
 			rd = entry->rd;
 			ret = write_dev(lc, rd, 0);
 			if (ret) {
 				log_err(lc, "%s: Error while reverting "
-					    "metadata.", __func__);
+					"metadata.", __func__);
 				break;
 			}
 		}
--- dmraid/lib/metadata/metadata.c	2008/04/02 13:35:31	1.4
+++ dmraid/lib/metadata/metadata.c	2008/06/20 21:52:18	1.5
@@ -1,10 +1,14 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
+#include <getopt.h>
 #include "internal.h"
 #include "activate/devmapper.h"
 
@@ -20,24 +24,24 @@
 	const char *dm_ascii;
 } ascii_type[] = {
 	/* enum        text         dm-target id */
-	{ t_undef,     NULL,        NULL },
-	{ t_group,     "GROUP",	    NULL },
-	{ t_partition, "partition", NULL },
-	{ t_spare,     "spare",     NULL },
-	{ t_linear,    "linear",    "linear" },
-	{ t_raid0,     "stripe",    "striped" },
-	{ t_raid1,     "mirror",    "mirror" },
-	{ t_raid4,     "raid4",     "raid45" },
-	{ t_raid5_ls,  "raid5_ls",  "raid45" },
-	{ t_raid5_rs,  "raid5_rs",  "raid45" },
-	{ t_raid5_la,  "raid5_la",  "raid45" },
-	{ t_raid5_ra,  "raid5_ra",  "raid45" },
-	{ t_raid6,     "raid6",     NULL },
+	{ t_undef, NULL, NULL},
+	{ t_group, "GROUP", NULL},
+	{ t_partition, "partition", NULL},
+	{ t_spare, "spare", NULL},
+	{ t_linear, "linear", "linear"},
+	{ t_raid0, "stripe", "striped"},
+	{ t_raid1, "mirror", "mirror"},
+	{ t_raid4, "raid4", "raid45"},
+	{ t_raid5_ls, "raid5_ls", "raid45"},
+	{ t_raid5_rs, "raid5_rs", "raid45"},
+	{ t_raid5_la, "raid5_la", "raid45"},
+	{ t_raid5_ra, "raid5_ra", "raid45"},
+	{ t_raid6, "raid6", NULL},
 };
 
 static const char *stacked_ascii_type[][5] = {
-	{ "raid10", "raid30", "raid40", "raid50", "raid60" },
-	{ "raid01", "raid03", "raid04", "raid05", "raid06" },
+	{"raid10", "raid30", "raid40", "raid50", "raid60"},
+	{"raid01", "raid03", "raid04", "raid05", "raid06"},
 };
 
 /*
@@ -47,16 +51,47 @@
 	const enum status status;
 	const char *ascii;
 } ascii_status[] = {
-	{ s_undef,        NULL },
-	{ s_setup,        "setup" },
-	{ s_broken,       "broken" },
-	{ s_inconsistent, "inconsistent" },
-	{ s_nosync,       "nosync" },
-	{ s_ok,           "ok" },
+	{
+	s_undef, NULL}, {
+	s_setup, "setup"}, {
+	s_broken, "broken"}, {
+	s_inconsistent, "inconsistent"}, {
+	s_nosync, "nosync"}, {
+s_ok, "ok"},};
+
+/* type of spare set - string definition */
+#define SPARE_TYPE_STRING "8"
+
+/**************************/
+
+
+#define	ALL_FLAGS	((enum action) -1)
+
+/*
+ * Action flag definitions for set_action().
+ *
+ * 'Early' options can be handled directly in set_action() by calling
+ * the functions registered here (f_set member) handing in arg.
+ */
+struct actions {
+	int option;		/* Option character/value. */
+	enum action action;	/* Action flag for this option or UNDEF. */
+	enum action needed;	/* Mandatory options or UNDEF if alone */
+	enum action allowed;	/* Allowed flags (ie, other options allowed) */
+
+	enum args args;		/* Arguments allowed ? */
+
+	/* Function to call on hit or NULL */
+	int (*f_set) (struct lib_context * lc, int arg);
+	int arg;		/* Argument for above function call */
 };
 
+/*************************************/
+
+
 /* Fetch the respective ASCII string off the types array. */
-static unsigned int get_type_index(enum type type)
+static unsigned int
+get_type_index(enum type type)
 {
 	unsigned int ret = ARRAY_SIZE(ascii_type);
 
@@ -68,36 +103,39 @@
 	return 0;
 }
 
-const char *get_type(struct lib_context *lc, enum type type)
+const char *
+get_type(struct lib_context *lc, enum type type)
 {
 	return ascii_type[get_type_index(type)].dsp_ascii;
 }
 
-const char *get_dm_type(struct lib_context *lc, enum type type)
+const char *
+get_dm_type(struct lib_context *lc, enum type type)
 {
 	return ascii_type[get_type_index(type)].dm_ascii;
 }
 
 /* Return the RAID type of a stacked RAID set (eg, raid10). */
-static const char *get_stacked_type(void *v)
+static const char *
+get_stacked_type(void *v)
 {
 	struct raid_set *rs = v;
 	unsigned int t = (T_RAID0(rs) ? get_type_index((RS_RS(rs))->type) :
-					get_type_index(rs->type))
-			 - get_type_index(t_raid1);
+			  get_type_index(rs->type)) - get_type_index(t_raid1);
 
-	return stacked_ascii_type[T_RAID0(rs) ? 1 : 0]
-				 [t > t_raid0 ? t_undef : t];
+	return stacked_ascii_type[T_RAID0(rs) ? 1:0][t > t_raid0 ? t_undef:t];
 }
 
 /* Check, if a RAID set is stacked (ie, hierachical). */
-static inline int is_stacked(struct raid_set *rs)
+static inline int
+is_stacked(struct raid_set *rs)
 {
 	return !T_GROUP(rs) && SETS(rs);
 }
 
 /* Return the ASCII type for a RAID set. */
-const char *get_set_type(struct lib_context *lc, void *v)
+const char *
+get_set_type(struct lib_context *lc, void *v)
 {
 	struct raid_set *rs = v;
 
@@ -106,12 +144,12 @@
 }
 
 /* Fetch the respective ASCII string off the state array. */
-const char *get_status(struct lib_context *lc, enum status status)
+const char *
+get_status(struct lib_context *lc, enum status status)
 {
 	unsigned int i = ARRAY_SIZE(ascii_status);
 
 	while (i-- && !(status & ascii_status[i].status));
-
 	return ascii_status[i].ascii;
 }
 
@@ -121,8 +159,8 @@
  *
  * Pay attention to RAID > 0 types.
  */
-static uint64_t add_sectors(struct raid_set *rs, uint64_t sectors,
-			    uint64_t add)
+static uint64_t
+add_sectors(struct raid_set *rs, uint64_t sectors, uint64_t add)
 {
 	add = rs->stride ? round_down(add, rs->stride) : add;
 
@@ -136,7 +174,8 @@
 }
 
 /* FIXME: proper calculation of unsymetric sets ? */
-static uint64_t smallest_disk(struct raid_set *rs)
+static uint64_t
+smallest_disk(struct raid_set *rs)
 {
 	uint64_t ret = ~0;
 	struct raid_dev *rd;
@@ -148,26 +187,27 @@
 }
 
 /* Count subsets of a set. */
-static unsigned int count_subsets(struct lib_context *lc, struct raid_set *rs)
+static unsigned int
+count_subsets(struct lib_context *lc, struct raid_set *rs)
 {
 	unsigned ret = 0;
 	struct raid_set *r;
 
-	list_for_each_entry(r, &rs->sets, list)
-		ret++;
+	list_for_each_entry(r, &rs->sets, list) ret++;
 
 	return ret;
 }
 
 /* Calculate total sectors of a (hierarchical) RAID set. */
-uint64_t total_sectors(struct lib_context *lc, struct raid_set *rs)
+uint64_t
+total_sectors(struct lib_context * lc, struct raid_set * rs)
 {
-        uint64_t sectors = 0;
-        struct raid_dev *rd;
+	uint64_t sectors = 0;
+	struct raid_dev *rd;
 
 	/* Stacked RAID sets. */
 	if (!T_GROUP(rs)) {
-        	struct raid_set *r;
+		struct raid_set *r;
 
 		list_for_each_entry(r, &rs->sets, list)
 			sectors = add_sectors(rs, sectors,
@@ -186,6 +226,14 @@
 		}
 	}
 
+	/* Size for spare disk set */
+	if (T_SPARE(rs)) {
+		list_for_each_entry(rd, &rs->devs, devs) {
+			if (T_SPARE(rd))
+				sectors = add_sectors(rs, sectors, rd->sectors);
+		}
+	}
+
 	/* Size correction for higher RAID levels */
 	if (T_RAID4(rs) || T_RAID5(rs) || T_RAID6(rs)) {
 		unsigned int i = count_subsets(lc, rs);
@@ -196,20 +244,21 @@
 			sectors -= sub;
 	}
 
-        return sectors;
+	return sectors;
 }
 
 /* Check if a RAID device should be counted. */
-static unsigned int _count_dev(struct raid_dev *rd, enum count_type type)
+static unsigned int
+_count_dev(struct raid_dev *rd, enum count_type type)
 {
 	return ((type == ct_dev && !T_SPARE(rd)) ||
-		(type == ct_spare && T_SPARE(rd)) ||
-		type == ct_all) ? 1 : 0;
+		(type == ct_spare && T_SPARE(rd)) || type == ct_all) ? 1 : 0;
 }
 
 /* Count devices in a set recursively. */
-unsigned int count_devs(struct lib_context *lc, struct raid_set *rs,
-			enum count_type count_type)
+unsigned int
+count_devs(struct lib_context *lc, struct raid_set *rs,
+	   enum count_type count_type)
 {
 	unsigned int ret = 0;
 	struct raid_set *r;
@@ -233,7 +282,8 @@
  * format handlers so far. If life becomes more complex, I might need
  * one though...
  */
-static void _free_dev_pointers(struct lib_context *lc, struct raid_dev *rd)
+static void
+_free_dev_pointers(struct lib_context *lc, struct raid_dev *rd)
 {
 	int area, i, idx = 0;
 	void **p;
@@ -244,7 +294,7 @@
 
 	/* Allocate and initialize temporary pointer list. */
 	if (!(p = dbg_malloc(area * sizeof(*p))))
-		LOG_ERR(lc, , "allocating pointer array");
+		LOG_ERR(lc,, "failed to allocate pointer array");
 
 	/* Add private pointer to list. */
 	if (rd->private.ptr)
@@ -257,7 +307,7 @@
 			if (p[i] == rd->meta_areas[area].area)
 				break;
 		}
-	
+
 		if (i == idx)
 			p[idx++] = rd->meta_areas[area].area;
 	}
@@ -268,12 +318,13 @@
 	/* Free all RAID device pointers. */
 	while (idx--)
 		dbg_free(p[idx]);
-	
+
 	dbg_free(p);
 }
 
 /* Allocate dev_info struct and keep the device path */
-struct dev_info *alloc_dev_info(struct lib_context *lc, char *path)
+struct dev_info *
+alloc_dev_info(struct lib_context *lc, char *path)
 {
 	struct dev_info *di;
 
@@ -291,7 +342,8 @@
 }
 
 /* Free dev_info structure */
-static void _free_dev_info(struct lib_context *lc, struct dev_info *di)
+static void
+_free_dev_info(struct lib_context *lc, struct dev_info *di)
 {
 	if (di->serial)
 		dbg_free(di->serial);
@@ -300,11 +352,15 @@
 	dbg_free(di);
 }
 
-static inline void _free_dev_infos(struct lib_context *lc)
+static inline void
+_free_dev_infos(struct lib_context *lc)
 {
 	struct list_head *elem, *tmp;
 
 	list_for_each_safe(elem, tmp, LC_DI(lc)) {
+		if (!elem)
+			printf("NULL pointer\n");
+
 		list_del(elem);
 		_free_dev_info(lc, list_entry(elem, struct dev_info, list));
 	}
@@ -314,13 +370,15 @@
  * Free dev_info structure or all registered
  * dev_info structures in case di = NULL.
  */
-void free_dev_info(struct lib_context *lc, struct dev_info *di)
+void
+free_dev_info(struct lib_context *lc, struct dev_info *di)
 {
 	di ? _free_dev_info(lc, di) : _free_dev_infos(lc);
 }
 
 /* Allocate/Free RAID device (member of a RAID set). */
-struct raid_dev *alloc_raid_dev(struct lib_context *lc, const char *who)
+struct raid_dev *
+alloc_raid_dev(struct lib_context *lc, const char *who)
 {
 	struct raid_dev *ret;
 
@@ -334,7 +392,8 @@
 	return ret;
 }
 
-static void _free_raid_dev(struct lib_context *lc, struct raid_dev **rd)
+static void
+_free_raid_dev(struct lib_context *lc, struct raid_dev **rd)
 {
 	struct raid_dev *r = *rd;
 
@@ -348,12 +407,15 @@
 	 */
 	_free_dev_pointers(lc, r);
 
-	dbg_free(r->name);
+	if (r->name)
+		dbg_free(r->name);
+
 	dbg_free(r);
 	*rd = NULL;
 }
 
-static inline void _free_raid_devs(struct lib_context *lc)
+static inline void
+_free_raid_devs(struct lib_context *lc)
 {
 	struct list_head *elem, *tmp;
 	struct raid_dev *rd;
@@ -365,13 +427,15 @@
 }
 
 /* Free RAID device structure or all registered RAID devices if rd == NULL. */
-void free_raid_dev(struct lib_context *lc, struct raid_dev **rd)
+void
+free_raid_dev(struct lib_context *lc, struct raid_dev **rd)
 {
 	rd ? _free_raid_dev(lc, rd) : _free_raid_devs(lc);
 }
 
 /* Allocate/Free RAID set. */
-struct raid_set *alloc_raid_set(struct lib_context *lc, const char *who)
+struct raid_set *
+alloc_raid_set(struct lib_context *lc, const char *who)
 {
 	struct raid_set *ret;
 
@@ -380,7 +444,7 @@
 		INIT_LIST_HEAD(&ret->sets);
 		INIT_LIST_HEAD(&ret->devs);
 		ret->status = s_setup;
-		ret->type   = t_undef;
+		ret->type = t_undef;
 	} else
 		log_alloc_err(lc, who);
 
@@ -388,7 +452,8 @@
 }
 
 /* Free a single RAID set structure and its RAID devices. */
-static void _free_raid_set(struct lib_context *lc, struct raid_set *rs)
+static void
+_free_raid_set(struct lib_context *lc, struct raid_set *rs)
 {
 	struct raid_dev *rd;
 	struct list_head *elem, *tmp;
@@ -399,7 +464,7 @@
 		rd = RD(elem);
 
 		log_dbg(lc, "freeing device \"%s\", path \"%s\"",
-			rd->name, rd->di->path);
+			rd->name, (rd->di) ? rd->di->path : "?");
 
 		/* FIXME: remove partition code in favour of kpartx ? */
 		/*
@@ -425,7 +490,8 @@
 }
 
 /* Remove a set or all sets (in case rs = NULL) recursively. */
-void free_raid_set(struct lib_context *lc, struct raid_set *rs)
+void
+free_raid_set(struct lib_context *lc, struct raid_set *rs)
 {
 	struct list_head *elem, *tmp;
 
@@ -439,21 +505,24 @@
 }
 
 /* Return != 0 in case of a partitioned RAID set type. */
-int partitioned_set(struct lib_context *lc, void *rs)
+int
+partitioned_set(struct lib_context *lc, void *rs)
 {
-	return T_PARTITION((struct raid_set*) rs);
+	return T_PARTITION((struct raid_set *) rs);
 }
 
 /* Return != 0 in case of a partitioned base RAID set. */
-int base_partitioned_set(struct lib_context *lc, void *rs)
+int
+base_partitioned_set(struct lib_context *lc, void *rs)
 {
-	return ((struct raid_set*) rs)->flags & f_partitions;
+	return ((struct raid_set *) rs)->flags & f_partitions;
 }
 
 /* Return RAID set name. */
-const char *get_set_name(struct lib_context *lc, void *rs)
+const char *
+get_set_name(struct lib_context *lc, void *rs)
 {
-	return ((struct raid_set*) rs)->name;
+	return ((struct raid_set *) rs)->name;
 }
 
 /*
@@ -462,9 +531,9 @@
  * Search top level RAID set list only if where = FIND_TOP.
  * Recursive if where = FIND_ALL.
  */
-static struct raid_set *_find_set(struct lib_context *lc,
-				  struct list_head *list,
-				  const char *name, enum find where)
+static struct raid_set *
+_find_set(struct lib_context *lc,
+	  struct list_head *list, const char *name, enum find where)
 {
 	struct raid_set *r, *ret = NULL;
 
@@ -483,26 +552,41 @@
 		}
 	}
 
-  out:
+      out:
 	log_dbg(lc, "_find_set: %sfound %s", ret ? "" : "not ", name);
 
 	return ret;
 }
 
-struct raid_set *find_set(struct lib_context *lc,
-			  struct list_head *list,
-			  const char *name, enum find where)
+struct raid_set *
+find_set(struct lib_context *lc,
+	 struct list_head *list, const char *name, enum find where)
 {
 	return _find_set(lc, list ? list : LC_RS(lc), name, where);
 }
 
-struct raid_set *find_or_alloc_raid_set(struct lib_context *lc,
-				char *name, enum find where,
-				struct raid_dev *rd,
-				struct list_head *list,
-				void (*f_create) (struct raid_set *super,
-						  void *private),
-				void *private)
+static int set_sort(struct list_head *pos, struct list_head *new);
+
+
+static int
+set_sort(struct list_head *pos, struct list_head *new)
+{
+	struct raid_set *new_rs = list_entry(new, struct raid_set, list);
+	struct raid_set *pos_rs = list_entry(pos, struct raid_set, list);
+
+	if ((new_rs->name) && (pos_rs->name))
+		return (strcmp(new_rs->name, pos_rs->name) < 0);
+	else
+		return -1;
+}
+
+struct raid_set *
+find_or_alloc_raid_set(struct lib_context *lc,
+		       char *name, enum find where,
+		       struct raid_dev *rd,
+		       struct list_head *list,
+		       void (*f_create) (struct raid_set *
+					 super, void *private), void *private)
 {
 	struct raid_set *rs;
 
@@ -515,35 +599,34 @@
 	if (!(rs->name = dbg_strdup(name)))
 		goto err;
 
-	if (rd && ((rs->type = rd->type), T_SPARE(rd)))
-		rs->type = t_undef;
+	rs->type = rd ? rd->type : t_undef;
 
 	/* If caller hands a list in, add to it. */
 	if (list)
-		list_add_tail(&rs->list, list);
+		list_add_sorted(lc, list, &rs->list, set_sort);
 
 	/* Call any create callback. */
 	if (f_create)
 		f_create(rs, private);
 
-   out:
+      out:
 	return rs;
 
-   err:
+      err:
 	dbg_free(rs);
 	log_alloc_err(lc, __func__);
 
 	return NULL;
 }
 
-/* Return # of raid sets build */
-unsigned int count_sets(struct lib_context *lc, struct list_head *list)
+/* Return # of RAID sets build */
+unsigned int
+count_sets(struct lib_context *lc, struct list_head *list)
 {
 	int ret = 0;
 	struct list_head *elem;
 
-	list_for_each(elem, list)
-		ret++;
+	list_for_each(elem, list) ret++;
 
 	return ret;
 }
@@ -551,44 +634,45 @@
 /*
  * Count devices found
  */
-static unsigned int _count_devices(struct lib_context *lc, enum dev_type type)
+static unsigned int
+_count_devices(struct lib_context *lc, enum dev_type type)
 {
 	unsigned int ret = 0;
 	struct list_head *elem, *list;
 
 	if (DEVICE & type)
 		list = LC_DI(lc);
-	else if (((RAID|NATIVE) & type))
+	else if (((RAID | NATIVE) & type))
 		list = LC_RD(lc);
 	else
 		return 0;
-	
-	list_for_each(elem, list)
-			ret++;
+
+	list_for_each(elem, list) ret++;
 
 	return ret;
 }
 
-unsigned int count_devices(struct lib_context *lc, enum dev_type type)
+unsigned int
+count_devices(struct lib_context *lc, enum dev_type type)
 {
 	return type == SET ? count_sets(lc, LC_RS(lc)) :
-			     _count_devices(lc, type);
+		_count_devices(lc, type);
 }
 
 /*
  * Read RAID metadata off a device by trying
  * all/selected registered format handlers in turn.
  */
-static int _want_format(struct dmraid_format *fmt, const char *format,
-			enum fmt_type type)
+static int
+_want_format(struct dmraid_format *fmt, const char *format, enum fmt_type type)
 {
 	return fmt->format != type ||
-	       (format && strncmp(format, fmt->name, strlen(format))) ? 0 : 1;
+		(format && strncmp(format, fmt->name, strlen(format))) ? 0 : 1;
 }
 
-static struct raid_dev *_dmraid_read(struct lib_context *lc,
-				       struct dev_info *di,
-				       struct dmraid_format *fmt)
+static struct raid_dev *
+_dmraid_read(struct lib_context *lc,
+	     struct dev_info *di, struct dmraid_format *fmt)
 {
 	struct raid_dev *rd;
 
@@ -602,9 +686,9 @@
 	return rd;
 }
 
-static struct raid_dev *dmraid_read(struct lib_context *lc,
-				      struct dev_info *di, char const *format,
-				      enum fmt_type type)
+static struct raid_dev *
+dmraid_read(struct lib_context *lc,
+	    struct dev_info *di, char const *format, enum fmt_type type)
 {
 	struct format_list *fl;
 	struct raid_dev *rd = NULL, *rd_tmp;
@@ -614,7 +698,8 @@
 		if (_want_format(fl->fmt, format, type) &&
 		    (rd_tmp = _dmraid_read(lc, di, fl->fmt))) {
 			if (rd) {
-				log_print(lc, "%s: \"%s\" and \"%s\" formats "
+				log_print(lc,
+					  "%s: \"%s\" and \"%s\" formats "
 					  "discovered (using %s)!",
 					  di->path, rd_tmp->fmt->name,
 					  rd->fmt->name, rd->fmt->name);
@@ -630,7 +715,8 @@
 /*
  * Write RAID metadata to a device.
  */
-int write_dev(struct lib_context *lc, struct raid_dev *rd, int erase)
+int
+write_dev(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret = 0;
 	struct dmraid_format *fmt = rd->fmt;
@@ -638,10 +724,10 @@
 	if (fmt->write) {
 		log_notice(lc, "%sing metadata %s %s",
 			   erase ? "Eras" : "Writ",
-			   erase ? "on" : "to",
-			   rd->di->path);
+			   erase ? "on" : "to", rd->di->path);
 		ret = fmt->write(lc, rd, erase);
-	} else
+	}
+	else
 		log_err(lc, "format \"%s\" doesn't support writing metadata",
 			fmt->name);
 
@@ -651,14 +737,15 @@
 /*
  * Group RAID device into a RAID set.
  */
-static inline struct raid_set *dmraid_group(struct lib_context *lc,
-					    struct raid_dev *rd)
+static inline struct raid_set *
+dmraid_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	return rd->fmt->group(lc, rd);
 }
 
 /* Check that device names are members of the devices list. */
-static int _want_device(struct dev_info *di, char **devices)
+static int
+_want_device(struct dev_info *di, char **devices)
 {
 	char **dev;
 
@@ -673,8 +760,29 @@
 	return 0;
 }
 
+/* Discover RAID devices that are spares */
+void
+discover_raid_devices_spares(struct lib_context *lc, const char *format)
+{
+	struct dev_info *di;
+
+	/* Walk the list of discovered block devices. */
+	list_for_each_entry(di, LC_DI(lc), list) {
+		struct raid_dev *rd;
+
+		if ((rd = dmraid_read(lc, di, format, FMT_RAID))) {
+			/* FIXME: */
+			/*if (T_SPARE(rd)) */
+			list_add_tail(&rd->list, LC_RD(lc));
+
+		}
+
+	}
+}
+
 /* Discover RAID devices. */
-void discover_raid_devices(struct lib_context *lc, char **devices)
+void
+discover_raid_devices(struct lib_context *lc, char **devices)
 {
 	struct dev_info *di;
 	char *names = NULL;
@@ -682,7 +790,7 @@
 
 	/* In case we've got format identifiers -> duplicate string for loop. */
 	if (OPT_FORMAT(lc) &&
-	    (!(names = dbg_strdup((char*) OPT_STR_FORMAT(lc))))) {
+	    (!(names = dbg_strdup((char *) OPT_STR_FORMAT(lc))))) {
 		log_alloc_err(lc, __func__);
 		return;
 	}
@@ -714,8 +822,8 @@
  *
  * FIXME: remove partition code in favour of kpartx ?
  */
-static void _discover_partitions(struct lib_context *lc,
-				 struct list_head *rs_list)
+static void
+_discover_partitions(struct lib_context *lc, struct list_head *rs_list)
 {
 	char *path;
 	struct dev_info *di;
@@ -738,8 +846,7 @@
 		 * Skip all "container" sets, which are not active.
 		 */
 		if (base_partitioned_set(lc, rs) ||
-		    partitioned_set(lc, rs) ||
-		    !dm_status(lc, rs))
+		    partitioned_set(lc, rs) || !dm_status(lc, rs))
 			continue;
 
 		log_notice(lc, "discovering partitions on \"%s\"", rs->name);
@@ -766,7 +873,8 @@
 		 * We don't want to access that 'pointer'!
 		 */
 		if ((r = dmraid_group(lc, rd))) {
-			log_notice(lc, "created partitioned RAID set(s) for %s",
+			log_notice(lc,
+				   "created partitioned RAID set(s) for %s",
 				   di->path);
 			rs->flags |= f_partitions;
 		} else
@@ -781,7 +889,8 @@
 	}
 }
 
-void discover_partitions(struct lib_context *lc)
+void
+discover_partitions(struct lib_context *lc)
 {
 	_discover_partitions(lc, LC_RS(lc));
 }
@@ -792,18 +901,25 @@
  *	name = NULL  : build all sets
  *	name = String: build just the one set
  */
-static void want_set(struct lib_context *lc, struct raid_set *rs, char *name)
+static void
+want_set(struct lib_context *lc, struct raid_set *rs, char *name)
 {
-	if (name) {
+	struct raid_set *rs_sub, *rs_n;
+
+	if (rs->type == t_group) {
+		list_for_each_entry_safe(rs_sub, rs_n, &rs->sets, list)
+			want_set(lc, rs_sub, name);
+
+		if (list_empty(&rs->sets))
+			free_raid_set(lc, rs);
+	} else if (name) {
 		size_t len1 = strlen(rs->name), len2 = strlen(name);
 
-		if (len2 > len1 ||
-		    strncmp(rs->name, name, min(len1, len2))) {
+		if (len2 != len1 || strncmp(rs->name, name, min(len1, len2))) {
 			struct dmraid_format *fmt = get_format(rs);
-
-			log_notice(lc, "dropping unwanted RAID set \"%s\"",
+			log_notice(lc,
+				   "dropping unwanted RAID set \"%s\"",
 				   rs->name);
-
 			/*
 			 * ddf1 carries a private pointer to it's contianing
 			 * set which is cleared as part of the check. So we
@@ -820,7 +936,8 @@
 }
 
 /* Get format handler of RAID set. */
-struct dmraid_format *get_format(struct raid_set *rs)
+struct dmraid_format *
+get_format(struct raid_set *rs)
 {
 	/* Decend RAID set hierarchy. */
 	while (SETS(rs))
@@ -830,21 +947,30 @@
 }
 
 /* Find the set associated with a device */
-struct raid_set *get_raid_set(struct lib_context *lc, struct raid_dev *dev)
+struct raid_set *
+get_raid_set(struct lib_context *lc, struct raid_dev *dev)
 {
-	struct raid_set *rs;
-	struct raid_dev *rd;
+	struct raid_set *rs = NULL, *sub_rs = NULL;
+	struct raid_dev *rd = NULL;
 
-	list_for_each_entry(rs, LC_RS(lc), list)
-		list_for_each_entry(rd, &rs->devs, devs)
-			if (dev == rd)
-				return rs;
+	list_for_each_entry(rs, LC_RS(lc), list) {
+		list_for_each_entry(rd, &rs->devs, devs) if (dev == rd)
+			return rs;
+		if (T_GROUP(rs)) {
+			list_for_each_entry(sub_rs, &rs->sets, list) {
+				list_for_each_entry(rd, &rs->devs, devs)
+					if (dev == rd)
+					return rs;
+			}
+		}
+	}
 
 	return NULL;
 }
 
-/* Check metadata consistency of raid sets. */
-static void check_raid_sets(struct lib_context *lc)
+/* Check metadata consistency of RAID sets. */
+static void
+check_raid_sets(struct lib_context *lc)
 {
 	struct list_head *elem, *tmp;
 	struct raid_set *rs;
@@ -874,7 +1000,9 @@
 	return;
 }
 
-int group_set(struct lib_context *lc, char *name)
+/* Build RAID sets from devices on global RD list. */
+static int
+build_set(struct lib_context *lc, char *name)
 {
 	struct raid_dev *rd;
 	struct raid_set *rs;
@@ -906,14 +1034,571 @@
 
 	/* Check sanity of grouped RAID sets. */
 	check_raid_sets(lc);
+	return 1;
+}
+
+struct raid_set_descr {
+	char *name;
+	uint64_t size;
+	char *raid_level;
+	uint64_t stripe_size;
+	char *disks;
+	//uint8_t num_disks;
+	//struct list_head *disks;
+};
+
+/* RAID set creation options. */
+static struct option rs_lopts[] = {
+	{ "size",  required_argument, NULL, 's'},
+	{ "type",  required_argument, NULL, 'r'},
+	{ "str",   required_argument, NULL, 't'},
+	{ "stri",  required_argument, NULL, 't'},
+	{ "strip", required_argument, NULL, 't'},
+	{ "strid", required_argument, NULL, 't'},
+	{ "disk",  required_argument, NULL, 'd'},
+	{ "disks", required_argument, NULL, 'd'},
+	{ NULL,    no_argument,       NULL, 0},
+};
+
+#define RAIDLEVEL_INVALID 0xff
+#define MAX_STACK 16
+static enum type
+check_raid_level(char *raidlevel)
+{
+	int len, i;
+
+	if (raidlevel == NULL)
+		return t_undef;
+
+	for (i = 0, len = strlen(raidlevel); i < len; i++) {
+		if (!isdigit(raidlevel[i]))
+			return t_undef;
+	}
+
+	if (i > MAX_STACK)
+		return t_undef;
+
+	return t_raid0;
+}
+
+static int
+check_size(char *size)
+{
+	int c;
+	size_t len;
+	char *pEnd;
+
+	if (!size)
+		return 0;
+
+	len = strlen(size);
+	strtod(size, &pEnd);
+
+	/* No unit. */
+	if (size + len == pEnd)
+		return 1;
+
+	/* Check units. */
+	c = tolower(size[len - 1]);
+	if (c == 'b')
+		len--;
+
+	c = tolower(size[len - 1]);
+	if (c == 'k' || c == 'm' || c == 'g')
+		len--;
+
+	return size + len == pEnd ? 1 : 0;
+}
+
+/*
+ * The unit of a raid size can be byte(b) or block(B)(512 bytes)
+ * k=1024 and m=1024*1024 or g=1024*1024*1024.
+ *
+ * Return size in byte
+ */
+static uint64_t
+get_raid_size(char *rsp)
+{
+	char *pEnd, *pSizeUnit;
+	double dRsp;
+	uint64_t mul = 1;
+
+	if ((dRsp = strtod(rsp, &pEnd)) <= 0) 
+		dRsp = 0;
+
+	if ((pSizeUnit = strpbrk(pEnd, "kKmMgG"))) {
+		switch (tolower(*pSizeUnit)) {
+		case 'g':
+			mul *= 1024;
+		case 'm':
+			mul *= 1024;
+		case 'k':
+			mul *= 1024;
+		}
+	}
+
+	if ((pSizeUnit = strpbrk(pEnd, "bB"))) {
+		if (*pSizeUnit == 'B')
+			mul *= 512;
+	}
+
+	return (uint64_t) (dRsp * mul);
+}
+
+/* Parse RAID set creation arguments. */
+int
+parse_rs_args(struct lib_context *lc, char **argv, struct raid_set_descr *rsd)
+{
+	int o, n, opt_idx;
+
+	optind = 0;
+	rsd->raid_level = NULL;
+	rsd->size = 0;
+	rsd->stripe_size = 0;
+	rsd->disks = NULL;
+
+	/* set rsd structure for spare disk set */
+	if (OPT_HOT_SPARE_SET(lc)) {
+		rsd->name = (char *) OPT_STR_HOT_SPARE_SET(lc);
+		rsd->raid_level = (char *) SPARE_TYPE_STRING;
+		rsd->disks = (char *) OPT_STR_REBUILD_DISK(lc);
+	} else {
+		if (!argv[0] || !*argv[0])
+			LOG_ERR(lc, 0,
+				"failed to provide a valid RAID set name");
+
+		/* Handle the case -Cname. */
+		rsd->name = strstr(argv[0], "-C") ? argv[0] + 2 : argv[0];
+
+		for (n = 0; *(argv + n); n++);
+		if (n < 4)
+			LOG_ERR(lc, 0, "too few arguments");
+
+		while ((o = getopt_long(n, argv, ":", 
+					rs_lopts, &opt_idx)) != -1) {
+			switch (o) {
+			case 's':
+				if (!check_size(optarg))
+					LOG_ERR(lc, 0, "failed to config size");
+
+				if (!rsd->size)
+					rsd->size = get_raid_size(optarg);
+				break;
+
+			case 'r':
+				if (!rsd->raid_level)
+					rsd->raid_level = optarg;
+				break;
+
+			case 't':
+				if (!check_size(optarg))
+					LOG_ERR(lc, 0,
+						"failed to config stripe");
+
+				if (!rsd->stripe_size)
+					rsd->stripe_size =
+						get_raid_size(optarg);
+				break;
+
+			case 'd':
+				if (!rsd->disks)
+					rsd->disks = optarg;
+				break;
+
+			case '?':
+				LOG_ERR(lc, 0, "unknown option");
+			}
+		}
+	}
+
+	return 1;
+}
+
+struct dev_info *
+find_disk(struct lib_context *lc, char *dp)
+{
+	struct dev_info *di;
+
+	if ((dp == NULL) || (*dp == '\0'))
+		LOG_ERR(lc, 0, "failed to provide an array of disks");
+
+
+	list_for_each_entry(di, LC_DI(lc), list) {
+		if (!strcmp(di->path, dp))
+			return di;
+	}
+
+	return NULL;
+}
+
+static struct dmraid_format *
+find_format(struct lib_context *lc, const char *cp)
+{
+	struct format_list *fl;
+
+	if (cp == NULL)
+		LOG_ERR(lc, 0, "format handler string is NULL");
+
+
+	list_for_each_entry(fl, LC_FMT(lc), list) {
+		if (!(strcmp(fl->fmt->name, cp)))
+			return fl->fmt;
+	}
+	return NULL;
+}
+
+/*
+ * Remove the first digit and return a raid type according to the
+ * value of the first digit.
+ */
+static enum type
+get_raid_level(char **rl)
+{
+	char c;
+	struct raid_type {
+		char c;
+		enum type level;
+	};
+	static struct raid_type rts[] = {
+		{ '0', t_raid0 },
+		{ '1', t_raid1 },
+		{ '4', t_raid4 },
+		{ '5', t_raid5_la }, /* FIXME: other RAID5 algorithms? */
+		{ '6', t_raid6 },
+		{ '8', t_spare }, /* FIXME: Intel abuse of raid char. */
+	};
+	struct raid_type *rt = ARRAY_END(rts);
+
+	if (rl && *rl) {
+		c = **rl;
+		(*rl)++;
+	
+		while (rt-- > rts) {
+			if (rt->c == c)
+				return rt->level;
+		}
+	}
+
+	return t_undef;
+}
+
+#define MAX_NAME_LEN 15
+static int
+check_rsd(struct lib_context *lc, struct raid_set_descr *rsd)
+{
+	uint16_t i, len;
+
+	if (!find_format(lc, OPT_STR_FORMAT(lc)))
+		LOG_ERR(lc, 0, "unknown format type: %s",
+			lc->options[LC_FORMAT].arg.str);
+
+	if (check_raid_level(rsd->raid_level) == t_undef)
+		LOG_ERR(lc, 0, "failed to provide a valid RAID type");
+
+	/* do not check name set, if it is spare set without name  */
+	if (!((rsd->name == NULL) &&
+	    !(strcmp(rsd->raid_level, SPARE_TYPE_STRING)))) {
+
+		if ((len = strlen(rsd->name)) > MAX_NAME_LEN)
+			LOG_ERR(lc, 0, "name %s is longer than %d chars",
+				rsd->name, MAX_NAME_LEN);
+
+		if (len == 0)
+			LOG_ERR(lc, 0, "no RAID set name provided");
+		else if (!isalnum(rsd->name[0]))
+			LOG_ERR(lc, 0, "first character of a name must "
+				"be an alphanumeric charater");
+
+		for (i = 1; i < len; i++) {
+			if ((!isalnum(rsd->name[i]))
+			    && (rsd->name[i] != '_')
+			    && (rsd->name[i] != '-'))
+				LOG_ERR(lc, 0, "name %s has non-alphanumeric "
+					"characters", rsd->name);
+		}
+	}
+
+	if ((rsd->disks == NULL) || (*(rsd->disks) == 0))
+		LOG_ERR(lc, 0, "no hard drives specified");
+
+	return 1;
+}
+
+static void
+free_raidset(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_set *rs1;
+
+	if (SETS(rs)) {
+		rs1 = list_entry(rs->sets.next, struct raid_set, list);
+		free_raidset(lc, rs1);
+	}
+	if (rs)
+		_free_raid_set(lc, rs);
+}
+
+struct raid_dev *
+find_raiddev(struct lib_context *lc, struct raid_set *rs, struct dev_info *di)
+{
+	struct raid_dev *rd;
+
+	if (di == NULL)
+		LOG_ERR(lc, 0, "failed to provide dev info");
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (rd->di == di)
+			return rd;
+	}
+
+	return NULL;
+}
+
+struct raid_set *
+create_raidset(struct lib_context *lc, struct raid_set_descr *rsd)
+{
+	struct raid_set *rs, *rs_sub, *rs_tmp;
+	struct dev_info *di;
+	struct raid_dev *rd;
+	struct dmraid_format *fmt;
+	enum type rt;
+	int n = 0;
+	char *start, *end;
+
+	if (!check_rsd(lc, rsd))
+		return NULL;
+
+	if (!(rs = alloc_raid_set(lc, __func__)))
+		return NULL;
+
+	/* case if it is spare disk set without name */
+	if (!rsd->name
+	    && !(strcmp(rsd->raid_level, SPARE_TYPE_STRING))) {
+		rs->name = NULL;
+	} else {
+		if (!(rs->name = dbg_strdup(rsd->name)))
+			goto err;
+	}
+
+	/* the format type has been checked by check_rsd */
+	fmt = find_format(lc, OPT_STR_FORMAT(lc));
 
+	/*
+	 * The raid level has been checked at the function check_rsd. 
+	 * Use get_raid_level to remove the first digit from the string.
+	 */
+	rt = get_raid_level(&rsd->raid_level);
+
+	if (rsd->size)
+		rs->size = (rsd->size - 1) / 512 + 1;
+
+	if (rsd->stripe_size)
+		rs->stride = (rsd->stripe_size - 1) / 512 + 1;
+
+	rs->type = rt;
+	rs->flags = 0;
+	rs->status = s_init;
+	end = rsd->disks;
+	replace_delimiter(end, ',', ' ');
+	remove_tail_space(end);
+
+	do {
+		start = end;
+		/* skip space */
+		for (; *start == ' '; start++);
+		end = remove_delimiter(start, ' ');
+
+		if (!(di = find_disk(lc, start))) {
+			log_err(lc, "failed to find disk %s", start);
+			goto err;
+		}
+
+		/* check if device is not duplicated on the raid dev list */
+		if (find_raiddev(lc, rs, di)) {
+			log_err(lc, "disk %s is duplicated on the disk list",
+				di->path);
+			goto err;
+		}
+
+		if (!(rd = alloc_raid_dev(lc, __func__))) {
+			log_err(lc, "failed to allocate space for a raid_dev");
+			goto err;
+		}
+
+		rd->name = NULL;
+		rd->di = di;
+		rd->fmt = fmt;
+		rd->status = s_init;
+		rd->type = t_undef;
+		rd->offset = 0;
+		rd->sectors = 0;
+		list_add_tail(&rd->devs, &rs->devs);
+		n++;
+	} while (end++ != '\0');
+
+	rs->total_devs = rs->found_devs = n;
+	rs_tmp = rs;
+
+	/*
+	 * If there is a stacked RAID set, all sub sets are
+	 * created and only the type is required to set 
+	 */
+	while (*rsd->raid_level) {
+		if ((!(rt = get_raid_level(&rsd->raid_level))) ||
+		    !(rs_sub = alloc_raid_set(lc, __func__)))
+			goto err;
+
+		rs_sub->type = rt;
+		list_add_tail(&rs_sub->list, &rs_tmp->sets);
+		rs_tmp = rs_sub;
+	}
+
+	return rs;
+
+      err:
+	free_raidset(lc, rs);
+	return NULL;
+}
+
+
+int
+rebuild_config_raidset(struct lib_context *lc, struct raid_set *rs)
+{
+
+	struct raid_dev *rd;
+	struct raid_set *rs1 = NULL;
+	struct list_head *elem, *tmp;
+	struct dmraid_format *fmt;
+	int ret = 0;
+
+	if (!(fmt = (RD_RS(rs)->fmt)))
+		return 0;
+
+	if (!(fmt->create))
+		LOG_ERR(lc, 0,
+			"metadata creation isn't supported in \"%s\" format",
+			fmt->name);
+
+	if ((ret = fmt->create(lc, rs)) && (printf("no write_set\n"), 1)) {	/* (ret=write_set(lc, rs)) */
+		/* free rebuilded RAID set and then reconstr */
+		free_raid_set(lc, rs);
+		list_for_each_safe(elem, tmp, LC_RD(lc)) {
+			//list_del(elem);
+			rd = RD(elem);
+			rd->status = s_ok;
+			if (!(rs1 = dmraid_group(lc, rd)))
+				LOG_ERR(lc, 0,
+					"failed to build the created RAID set");
+			want_set(lc, rs1, rs->name);
+		}
+		if (rs1)
+			fmt->check(lc, rs1);
+	}
 	return 1;
 }
 
+static int
+config_raidset(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_dev *rd;
+	struct raid_set *rs1 = NULL;
+	struct list_head *elem, *tmp;
+	struct dmraid_format *fmt;
+	int ret = 0;
+
+	if (!(fmt = RD_RS(rs)->fmt))
+		return 0;
+
+	if (!fmt->create)
+		LOG_ERR(lc, 0,
+			"metadata creation isn't supported in \"%s\" format",
+			fmt->name);
+
+	if ((ret = fmt->create(lc, rs)) && (ret = write_set(lc, rs))) {
+		free_raid_set(lc, NULL);
+
+		list_for_each_safe(elem, tmp, &rs->devs) {
+			list_del(elem);
+			rd = RD(elem);
+			rd->status = s_ok;
+
+			if (!(rs1 = dmraid_group(lc, rd)))
+				LOG_ERR(lc, 0,
+					"failed to build the created RAID set");
+
+			want_set(lc, rs1, rs->name);
+		}
+
+		if (rs1)
+			fmt->check(lc, rs1);
+	}
+
+	free_raidset(lc, rs);
+	return ret;
+}
+
+
+int
+group_set(struct lib_context *lc, char **argv)
+{
+	char **sets = argv;
+	int i = 0;
+	struct raid_set_descr rsd;
+	struct raid_set *rs;
+
+	/* This is valid if name of RAID set is required. */
+	if (!OPT_HOT_SPARE_SET(lc) && !OPT_STR_HOT_SPARE_SET(lc)) {
+		if (!build_set(lc, sets[i]))
+			LOG_ERR(lc, 0, "failed to build a RAID set");
+
+		/* The required RAID set is found. */
+		if (!list_empty(LC_RS(lc)))
+			return 1;
+
+		/* There is no way for add spare disk to RAID set. */
+		if (!OPT_FORMAT(lc) &&
+		    OPT_REBUILD_DISK(lc) && OPT_HOT_SPARE_SET(lc))
+			return 0;
+
+		/*
+		 * Since there are several arguments required for
+		 * creating a RAID set, we know that the intented command is to list all RAID sets.
+		 */
+		if (!sets[0])
+			LOG_ERR(lc, 0, "no RAID set found");
+
+	}
+
+	/* This is not argument for creating spare RAID set. */
+	if (!OPT_HOT_SPARE_SET(lc)) {
+		/*
+		 * Make sure we have min arguments for creating a RAID set:
+		 * a name and an option.
+		 */
+		if (!sets[1])
+			LOG_ERR(lc, 0,
+				"either the required RAID set not found or more options required");
+
+		if (sets[1][0] != '-')
+			LOG_ERR(lc, 0,
+				"only one argument allowed for this option");
+	}
+
+	if (!parse_rs_args(lc, argv, &rsd))
+		return 0;
+
+	if (!build_set(lc, NULL))
+		LOG_ERR(lc, 0, "failed to get the existing RAID set info");
+
+	if (!(rs = create_raidset(lc, &rsd)))
+		return 0;
+
+	return config_raidset(lc, rs);
+}
+
 /* Process function on RAID set(s) */
-static void process_set(struct lib_context *lc, void *rs,
-			int (*func)(struct lib_context *lc, void *rs, int arg),
-			int arg)
+static void
+process_set(struct lib_context *lc, void *rs,
+	    int (*func) (struct lib_context * lc, void *rs, int arg), int arg)
 {
 	if (!partitioned_set(lc, rs))
 		func(lc, rs, arg);
@@ -922,28 +1607,30 @@
 /* FIXME: remove partition code in favour of kpartx ? */
 static void
 process_partitioned_set(struct lib_context *lc, void *rs,
-			int (*func)(struct lib_context *lc, void *rs, int arg),
-			int arg)
+			int (*func) (struct lib_context * lc, void *rs,
+				     int arg), int arg)
 {
 	if (partitioned_set(lc, rs) && !base_partitioned_set(lc, rs))
 		func(lc, rs, arg);
 }
 
-void process_sets(struct lib_context *lc,
-		  int (*func)(struct lib_context *lc, void *rs, int arg),
-		  int arg, enum set_type type)
+void
+process_sets(struct lib_context *lc,
+	     int (*func) (struct lib_context * lc, void *rs, int arg),
+	     int arg, enum set_type type)
 {
 	struct raid_set *rs;
-	void (*p)(struct lib_context *l, void *r,
-		  int (*f)(struct lib_context *lc, void *rs, int arg), int a) =
+	void (*p) (struct lib_context * l, void *r,
+		   int (*f) (struct lib_context * lc, void *rs, int arg),
+		   int a) =
 		(type == PARTITIONS) ? process_partitioned_set : process_set;
 
-	list_for_each_entry(rs, LC_RS(lc), list)
-		p(lc, rs, func, arg);
+	list_for_each_entry(rs, LC_RS(lc), list) p(lc, rs, func, arg);
 }
 
 /* Write RAID set metadata to devices. */
-int write_set(struct lib_context *lc, void *v)
+int
+write_set(struct lib_context *lc, void *v)
 {
 	int ret = 1;
 	struct raid_set *r, *rs = v;
@@ -953,10 +1640,11 @@
 	list_for_each_entry(r, &rs->sets, list) {
 		/*
 		 * FIXME: does it make sense to try the rest of the subset
-		 *	  in case we fail writing one ?
+		 *        in case we fail writing one ?
 		 */
-		if (!write_set(lc, (void*) r))
-			log_err(lc, "writing RAID subset \"%s\", continuing",
+		if (!write_set(lc, (void *) r))
+			log_err(lc,
+				"writing RAID subset \"%s\", continuing",
 				r->name);
 	}
 
@@ -964,10 +1652,11 @@
 	list_for_each_entry(rd, &rs->devs, devs) {
 		/*
 		 * FIXME: does it make sense to try the rest of the
-		 *	  devices in case we fail writing one ?
+		 *        devices in case we fail writing one ?
 		 */
 		if (!write_dev(lc, rd, 0)) {
-			log_err(lc, "writing RAID device \"%s\", continuing",
+			log_err(lc,
+				"writing RAID device \"%s\", continuing",
 				rd->di->path);
 			ret = 0;
 		}
@@ -977,7 +1666,8 @@
 }
 
 /* Erase ondisk metadata. */
-int erase_metadata(struct lib_context *lc)
+int
+erase_metadata(struct lib_context *lc)
 {
 	int ret = 1;
 	struct raid_dev *rd;
@@ -1001,7 +1691,8 @@
  *
  * Return neutralized RAID type for given mapping array (linear, raid0, ...)
  */
-enum type rd_type(struct types *t, unsigned int type)
+enum type
+rd_type(struct types *t, unsigned int type)
 {
 	for (; t->unified_type != t_undef && t->type != type; t++);
 	return t->unified_type;
@@ -1012,9 +1703,13 @@
  *
  * Return neutralized RAID status for given metadata status
  */
-enum status rd_status(struct states *s, unsigned int status, enum compare cmp)
+enum status
+rd_status(struct states *s, unsigned int status, enum compare cmp)
 {
-	for (; s->status && (cmp == AND ? !(s->status & status) : (s->status != status)); s++);
+	for (;
+	     s->status
+	     && (cmp ==
+		 AND ? !(s->status & status) : (s->status != status)); s++);
 	return s->unified_status;
 }
 
@@ -1024,10 +1719,10 @@
  * Sort an element into a list by optionally
  * using a metadata format handler helper function.
  */
-void list_add_sorted(struct lib_context *lc,
-		     struct list_head *to, struct list_head *new,
-		     int (*f_sort)(struct list_head *pos,
-				   struct list_head *new))
+void
+list_add_sorted(struct lib_context *lc,
+		struct list_head *to, struct list_head *new,
+		int (*f_sort) (struct list_head * pos, struct list_head * new))
 {
 	struct list_head *pos;
 
@@ -1055,14 +1750,16 @@
  * File RAID metadata and offset on device for analysis.
  */
 /* FIXME: all files into one directory ? */
-static size_t __name(struct lib_context *lc, char *str, size_t len,
-		     const char *path, const char *suffix)
+static size_t
+__name(struct lib_context *lc, char *str, size_t len,
+       const char *path, const char *suffix)
 {
 	return snprintf(str, len, "%s.%s",
-			get_basename(lc, (char*) path), suffix) + 1;
+			get_basename(lc, (char *) path), suffix) + 1;
 }
 
-static char *_name(struct lib_context *lc, const char *path, const char *suffix)
+static char *
+_name(struct lib_context *lc, const char *path, const char *suffix)
 {
 	size_t len;
 	char *ret;
@@ -1075,8 +1772,9 @@
 	return ret;
 }
 
-static int file_data(struct lib_context *lc, const char *handler,
-		     char *path, void *data, size_t size)
+static int
+file_data(struct lib_context *lc, const char *handler,
+	  char *path, void *data, size_t size)
 {
 	int ret = 0;
 	char *name;
@@ -1090,21 +1788,23 @@
 	return ret;
 }
 
-static void file_number(struct lib_context *lc, const char *handler,
-			char *path, uint64_t number, const char *suffix)
+static void
+file_number(struct lib_context *lc, const char *handler,
+	    char *path, uint64_t number, const char *suffix)
 {
 	char *name, s_number[32];
-	
+
 	if ((name = _name(lc, path, suffix))) {
 		log_notice(lc, "writing %s to file \"%s\"", suffix, name);
-		write_file(lc, handler, name, (void*) s_number,
-		           snprintf(s_number, sizeof(s_number),
-			   "%" PRIu64 "\n", number), 0);
+		write_file(lc, handler, name, (void *) s_number,
+			   snprintf(s_number, sizeof(s_number),
+				    "%" PRIu64 "\n", number), 0);
 		dbg_free(name);
 	}
 }
 
-static int _chdir(struct lib_context *lc, const char *dir)
+static int
+_chdir(struct lib_context *lc, const char *dir)
 {
 	if (chdir(dir)) {
 		log_err(lc, "changing directory to %s", dir);
@@ -1114,7 +1814,8 @@
 	return 0;
 }
 
-static char *_dir(struct lib_context *lc, const char *handler)
+static char *
+_dir(struct lib_context *lc, const char *handler)
 {
 	char *dir = _name(lc, lc->cmd, handler);
 
@@ -1129,7 +1830,7 @@
 	if (!_chdir(lc, dir))
 		return dir;
 
-   out:
+      out:
 	dbg_free(dir);
 	return NULL;
 }
@@ -1137,8 +1838,9 @@
 /*
  * File vendor RAID metadata.
  */
-void file_metadata(struct lib_context *lc, const char *handler,
-		   char *path, void *data, size_t size, uint64_t offset)
+void
+file_metadata(struct lib_context *lc, const char *handler,
+	      char *path, void *data, size_t size, uint64_t offset)
 {
 	if (OPT_DUMP(lc)) {
 		char *dir = _dir(lc, handler);
@@ -1158,8 +1860,8 @@
 /*
  * File RAID device size.
  */
-void file_dev_size(struct lib_context *lc, const char *handler,
-		   struct dev_info *di)
+void
+file_dev_size(struct lib_context *lc, const char *handler, struct dev_info *di)
 {
 	if (OPT_DUMP(lc)) {
 		char *dir = _dir(lc, handler);
@@ -1173,3 +1875,307 @@
 		_chdir(lc, "..");
 	}
 }
+
+/* Delete RAID set(s) */
+int
+delete_raidsets(struct lib_context *lc)
+{
+	struct raid_set *rs, *rs1;
+	struct raid_dev *rd;
+	int n = 0, status;
+
+	if (list_empty(&(lc->lists[LC_RAID_SETS])))
+		LOG_ERR(lc, 0, "Cannot find a RAID set to delete");
+
+	list_for_each_entry(rs, LC_RS(lc), list) {
+		if (!(rd = list_entry(rs->devs.next, struct raid_dev, devs)))
+			  LOG_ERR(lc, 0, "Failed to locate the raid device");
+
+		if (rs->type == t_group) {
+			list_for_each_entry(rs1, &rs->sets, list) {
+				status = dm_status(lc, rs1);
+				if (status == 1)
+					LOG_ERR(lc, 0,
+						"%s is active and cannot be deleted",
+						rs1->name);
+
+				n++;
+			}
+			if (n > 1) {
+				printf("\nAbout to delete the raid super-set \"%s\" with the following RAID sets\n", rs->name);
+				list_for_each_entry(rs1, &rs->sets, list)
+					printf("%s\n", rs1->name);
+			}
+			else if (n == 1) {
+				rs1 = list_entry(rs->sets.next,
+						 struct raid_set, list);
+				printf("\nAbout to delete RAID set %s\n",
+				       rs1->name);
+			}
+			else
+				LOG_ERR(lc, 0, "coding error");
+		}
+		else {
+			printf("\nAbout to delete RAID set %s\n", rs->name);
+		}
+		printf("\nWARNING: The metadata stored on the raidset(s) will not be accessible after deletion\n");
+		if (!yes_no_prompt(lc, "Do you want to continue"))
+			return 0;
+
+		if (!rd->fmt->delete)
+			LOG_ERR(lc, 0,
+				"Raid set deletion is not supported in \"%s\" format",
+				rd->fmt->name);
+
+		rd->fmt->delete(lc, rs);
+
+	}
+
+	return 1;
+}
+
+struct raid_set *find_set_inconsistent(struct lib_context *lc,
+				       struct raid_set *rs);
+
+struct raid_dev *find_spare(struct lib_context *lc,
+			    struct raid_set *rs2rebuild,
+			    struct raid_set **spareRs);
+
+struct raid_set *
+find_set_inconsistent(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_set *r, *rsb;
+
+	list_for_each_entry(r, &rs->sets, list) {
+		if (T_GROUP(r) && !(rsb = find_set_inconsistent(lc, r)))
+			return rsb;
+	}
+
+	return (DEVS(rs) &&
+		(S_BROKEN(rs->status) || S_INCONSISTENT(rs->status))) ?
+		rs : NULL;
+
+}
+
+
+/*
+ * Search for spare drive that can be used to fix given rs.
+ *
+ * Returns spare raid_dev and its spare RAID set.
+ * Based on format configuration searches:
+ * localy (in RAID set that shall be fixed)
+ * globaly (any spare drive that can be used to fix rs)
+ */
+struct raid_dev *
+find_spare(struct lib_context *lc, struct raid_set *rs,
+	   struct raid_set **spare_rs)
+{
+	struct raid_dev *closest = NULL, *spare_rd, *rd = NULL;
+	struct raid_set *rs_failed = NULL, *tmp_spare_rs = NULL;
+	struct dmraid_format *fmt = get_format(rs);
+
+	/* Find rd that will be evaluated for replacement. */
+
+	/* Search the spare sets for eligible disk. */
+	if (!(rs_failed = find_set_inconsistent(lc, rs)) ||
+	    !(rd = RD_RS(rs_failed)))
+		LOG_PRINT(lc, NULL,
+			  "no failed subsets or no device in subset  found");
+
+
+	/* Local search - based on fmt. */
+	if (fmt->scope & t_scope_local) {
+		struct raid_set *group_rs = find_group(lc, rs);
+
+		if (!group_rs)
+			return NULL;
+
+		list_for_each_entry(tmp_spare_rs, &group_rs->sets, list) {
+			if (DEVS(tmp_spare_rs) && T_SPARE(tmp_spare_rs)) {
+				list_for_each_entry(spare_rd,
+						    &tmp_spare_rs->devs, devs) {
+					/* Simple check of size */
+					if (spare_rd->di->sectors >=
+					    rd->di->sectors &&
+					    (!closest ||
+					     closest->di->sectors <
+					     rd->di->sectors)) {
+						if (spare_rd->di->sectors ==
+						    rd->di->sectors) {
+							/* Match */
+							closest = spare_rd;
+							break;
+						}
+
+						closest = spare_rd;
+					}
+				}
+			}
+		}
+	}
+
+	/* Global search - based on fmt */
+	if ((fmt->scope & t_scope_global) && !closest) {
+		struct raid_set *group_rs;
+
+		list_for_each_entry(group_rs, LC_RS(lc), list) {
+			if (T_GROUP(group_rs)
+			    && (get_format(group_rs) == fmt)) {
+				list_for_each_entry(tmp_spare_rs,
+						    &group_rs->sets, list) {
+					if ((DEVS(tmp_spare_rs)) &&
+					    T_SPARE(tmp_spare_rs)) {
+						list_for_each_entry(spare_rd, &tmp_spare_rs->devs, devs) {
+							/* Simple check of size. */
+							if ((spare_rd->di->sectors >= rd->di->sectors) &&
+							    (!closest == NULL ||
+							     closest->di->sectors < rd->di->sectors)) {
+								if (spare_rd->di->sectors == rd->di->sectors) {
+									/* match */
+									closest = spare_rd;
+									break;
+								}
+
+								closest = spare_rd;
+							}
+						}
+					}
+				}
+			}
+		}
+	}
+
+	/* Global search. */
+	if (closest) {
+		*spare_rs = get_raid_set(lc, closest);
+		return closest;
+	}
+
+	/* spare not found */
+	return NULL;
+}
+
+
+void
+format_error(struct lib_context *lc, const char *error, char **argv)
+{
+	log_print_nnl(lc, "no raid %s", error);
+
+	if (OPT_FORMAT(lc))
+		log_print_nnl(lc, " with format: \"%s\"", OPT_STR_FORMAT(lc));
+
+
+	if (argv && *argv) {
+		log_print_nnl(lc, " and with names: \"");
+
+		while (*argv) {
+			log_print_nnl(lc, "%s", *argv++);
+			if (*argv)
+				log_print_nnl(lc, "%s", OPT_STR_SEPARATOR(lc));
+			else
+				log_print_nnl(lc, "\"");
+		}
+	}
+
+	log_print(lc, "");
+}
+
+/* Retrieve and build metadata. */
+static int
+get_metadata(struct lib_context *lc, enum action action,
+	     struct prepost *p, char **argv)
+{
+	if (!(M_DEVICE & p->metadata))
+		return 1;
+
+	if (!discover_devices(lc, OPT_DEVICES(lc) ? argv : NULL))
+		LOG_ERR(lc, 0, "failed to discover devices");
+
+	if (!count_devices(lc, DEVICE)) {
+		log_print(lc, "no block devices found");
+		return 1;
+	}
+
+	if (!(M_RAID & p->metadata))
+		return 1;
+
+#ifndef	DMRAID_MINI
+	/* Discover RAID disks and keep RAID metadata (eg, hpt45x) */
+	discover_raid_devices(lc,
+# ifdef	DMRAID_NATIVE_LOG
+			      ((NATIVE_LOG | RAID_DEVICES) & action) ? argv
+			      : NULL);
+# else
+			      (RAID_DEVICES & action) ? argv : NULL);
+# endif
+#else
+	discover_raid_devices(lc, NULL);
+#endif
+
+	if (!OPT_HOT_SPARE_SET(lc) && !OPT_CREATE(lc)
+	    && !count_devices(lc, RAID)) {
+		format_error(lc, "disks", argv);
+		return 1;
+	}
+
+	if (M_SET & p->metadata) {
+		/* Group RAID sets. */
+		group_set(lc, argv);
+		if (!OPT_HOT_SPARE_SET(lc) && !OPT_CREATE(lc)
+		    && !count_devices(lc, SET)) {
+			format_error(lc, "sets", argv);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+
+int
+lib_perform(struct lib_context *lc, enum action action,
+	    struct prepost *p, char **argv)
+{
+	int ret = 0;
+
+	if (ROOT == p->id && geteuid())
+		LOG_ERR(lc, 0, "you must be root");
+
+	/* Lock against parallel runs. Resource NULL for now. */
+	if (LOCK == p->lock && !lock_resource(lc, NULL))
+		LOG_ERR(lc, 0, "lock failure");
+
+	if (get_metadata(lc, action, p, argv))
+		ret = p->post(lc, p->pre ? p->pre(p->arg) : p->arg);
+
+	if (LOCK == p->lock)
+		unlock_resource(lc, NULL);
+
+	return ret;
+}
+
+int
+dso_get_members(struct lib_context *lc, int arg)
+{
+	static char disks[100] = "\0";
+	const char *vol_name = lc->options[LC_REBUILD_SET].arg.str;
+	struct raid_set *sub_rs;
+	struct raid_dev *rd;
+
+	if ((sub_rs = find_set(lc, NULL, vol_name, FIND_ALL))) {
+		lc->options[LC_REBUILD_SET].opt = 0;
+
+		list_for_each_entry(rd, &sub_rs->devs, devs) {
+			strcat(disks, rd->di->path);
+			strcat(disks, " ");
+			lc->options[LC_REBUILD_SET].opt++;
+		}
+
+		dbg_free((char *) lc->options[LC_REBUILD_SET].arg.str);
+		lc->options[LC_REBUILD_SET].arg.str = dbg_strdup(disks);
+		return 0;
+	}
+	else
+		/* RAID set not found. */
+		return 1;
+}
--- dmraid/lib/metadata/reconfig.c	2008/02/22 17:04:36	1.1
+++ dmraid/lib/metadata/reconfig.c	2008/06/20 21:52:18	1.2
@@ -4,113 +4,354 @@
  * James Simshaw <simshawj@us.ibm.com>, and
  * Adam DiCarlo <bikko@us.ibm.com>
  *
- * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
- * 		      All rights reserved
+ * Copyright (C) 2006-2008 Heinz Mauelshagen, Red Hat GmbH
+ * 		           All rights reserved
+ *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
 #include "internal.h"
+int dso = 0;
 
 #define	add_to_log(entry, log)	\
 	list_add_tail(&(entry)->changes, &(log));
 
-static inline int alloc_entry(struct change **entry)
+static inline int
+alloc_entry(struct change **entry, struct lib_context *lc)
 {
-	return (*entry = dbg_malloc(sizeof (*entry))) ? 0 : -ENOMEM;
+	return (*entry = dbg_malloc(sizeof(*entry))) ? 0 : -ENOMEM;
 }
 
-static int nuke_spare(struct lib_context *lc, struct raid_dev *rd)
+static int
+nuke_spare(struct lib_context *lc, struct raid_dev *rd)
 {
 	printf("Nuking Spare\n");
 	list_del_init(&rd->devs);
 	return 0;
 }
 
-/* Add a device to a RAID1 set and start the resync */
-static int add_dev_to_raid1(struct lib_context *lc, struct raid_set *rs,
-			    struct raid_dev *rd)
+int
+dso_end_rebuild(struct lib_context *lc, int arg)
 {
-	int ret;
-	struct raid_dev *tmp;
-	struct change *entry;
-	LIST_HEAD(log); /* playback log */
+	struct raid_set *sub_rs;
+	const char *vol_name = lc->options[LC_REBUILD_SET].arg.str;
 
-	/* Add device to the raid set */
-	ret = alloc_entry(&entry);
-	if (ret)
-		goto err;
+	sub_rs = find_set(lc, NULL, vol_name, FIND_ALL);
+	if (sub_rs) {
+		struct raid_set *rs = NULL;
+
+		rs = find_group(lc, sub_rs);
+		if ((rs) && S_OK(sub_rs->status)) {
+			struct raid_dev *check_rd = RD_RS(sub_rs);
+			enum status state = s_ok;
+
+			if (check_rd->fmt->metadata_handler)
+				state = check_rd->fmt->metadata_handler(lc,
+									GET_REBUILD_STATE,
+									NULL,
+									(void *)
+									sub_rs);
+
+			if (state != s_nosync) {
+				/* cannot rebuild */
+				log_print(lc,
+					  "Volume \"%s\" is not in rebuild state (current: %u)\n",
+					  sub_rs->name, state);
+				return 1;
+			}
+
+			if (check_rd->fmt->metadata_handler)
+				check_rd->fmt->metadata_handler(lc,
+								UPDATE_REBUILD_STATE,
+								NULL,
+								(void *) rs);
+		} else {
+			log_print(lc,
+				  "Volume \"%s\" is not in rebuild state \n",
+				  vol_name);
+			return 1;
+		}
+	} else
+		log_print(lc, "raid volume \"%s\" not found\n", vol_name);
 
-	entry->type = ADD_TO_SET;
-	entry->rs = rs;
-	entry->rd = rd;
-	add_to_log(entry, log);
-	list_add_tail(&rd->devs, &rs->devs);
-	rd->type = t_raid1;
+	return 0;
+}
 
-	/* Check that this is a sane configuration */
-	list_for_each_entry(tmp, &rs->devs, devs) {
-		ret = tmp->fmt->check(lc, rs);
-		if (ret)
-			goto err;
+int rebuild_config_raidset(struct lib_context *lc, struct raid_set *rs);
+
+void
+show_raid_stack(struct lib_context *lc)
+{
+	struct raid_set *_rs;
+	log_dbg(lc, "RM: Discovered raid sets:");
+	list_for_each_entry(_rs, LC_RS(lc), list) {
+		struct raid_dev *_rd;
+		struct raid_set *_rss;
+		log_dbg(lc, "RM: GROUP name: \"%s\"", _rs->name);
+		list_for_each_entry(_rd, &_rs->devs, devs) {
+			log_dbg(lc, "RM: GROUP_DISK name: \"%s\"",
+				(_rd->di) ? _rd->di->path : "UNKNOWN");
+		}
+		list_for_each_entry(_rss, &_rs->sets, list) {
+			struct raid_dev *_rsd;
+			struct raid_set *_rsss;
+
+			log_dbg(lc, "RM:   SUPERSET name: \"%s\"", _rss->name);
+
+			list_for_each_entry(_rsd, &_rss->devs, devs) {
+				log_dbg(lc, "RM:   SUPERSET_DISK name: \"%s\"",
+					(_rsd->di) ? _rsd->
+					di->path : "UNKNOWN");
+			}
+
+			list_for_each_entry(_rsss, &_rss->sets, list) {
+				struct raid_dev *_rssd;
+				log_dbg(lc, "RM:     SUBSET name: \"%s\"",
+					_rsss->name);
+				list_for_each_entry(_rssd, &_rsss->devs, devs) {
+					log_dbg(lc,
+						"RM:     SUBSET_DISK name: \"%s\"",
+						(_rssd->di) ? _rssd->
+						di->path : "UNKNOWN");
+				}
+			}
+		}
 	}
+}
 
-	/* Write the metadata of the drive we're adding _first_ */
-	ret = alloc_entry(&entry);
-	if (ret)
-		goto err;
+/* Add a device to a RAID1 set and start the resync */
+static int
+add_dev_to_raid(struct lib_context *lc, struct raid_set *rs,
+		struct raid_dev *rd)
+{
+	int ret = 0;
+	const char *vol_name = lc->options[LC_REBUILD_SET].arg.str;
 
-	entry->type = WRITE_METADATA;
-	entry->rd = rd;
-	add_to_log(entry, log);
-	ret = write_dev(lc, rd, 0);
-	if (!ret)
-		goto err;
+	struct raid_set *sub_rs, *crs;
+	struct raid_dev *check_rd;
 
-	/* Write metadatas of every device in the set */
-	list_for_each_entry(tmp, &rs->devs, devs) {
-		if (tmp != rd) {
-			ret = alloc_entry(&entry);
-			if (ret)
-				goto err;
 
-			entry->type = WRITE_METADATA;
-			entry->rd = tmp;
-			add_to_log(entry, log);
-			ret = write_dev(lc, tmp, 0);
-			if (!ret)
+	LIST_HEAD(log);		/* playback log */
+	sub_rs = find_set(lc, NULL, vol_name, FIND_ALL);
+	check_rd = list_entry(rs->devs.next, typeof(*rd), devs);
+
+	if (rd) {
+		if (check_rd->fmt->create) {
+			struct raid_dev *tmp;
+			if ((ret = check_rd->fmt->create(lc, rs))) {
+
+				list_for_each_entry(tmp, &rs->devs, devs) {
+					write_dev(lc, tmp, 0);
+				}
+			} else {
+				log_print(lc, "metadata fmt update failed\n");
 				goto err;
+			}
+		} else {
+			log_print(lc, "create failed fmt handler missing\n");
+			goto err;
+		}
+
+		struct handler_info info;
+
+		if (lc->options[LC_REBUILD_SET].opt) {
+			if (check_rd->fmt->metadata_handler) {
+				if (!check_rd->
+				    fmt->metadata_handler(lc,
+							  GET_REBUILD_DRIVE_NO,
+							  &info,
+							  (void *) sub_rs)) {
+					LOG_ERR(lc, 0,
+						"can't get rebuild drive !");
+				}
+			}
 		}
+
+		if (info.data.i32 != -1) {
+			struct raid_dev *before_rd, *tmp_rd;
+			int idx = 0;
+			list_for_each_entry_safe(before_rd, tmp_rd,
+						 &sub_rs->devs, devs) {
+				if ((idx == info.data.i32)
+				    && (&rd->devs != &before_rd->devs)) {
+					list_del(&rd->devs)
+						list_add_tail(&rd->devs,
+							      &before_rd->devs);
+					break;
+				}
+				idx++;
+			}
+		}
+		show_raid_stack(lc);
+		log_dbg(lc, "RM: REBUILD drivie #: \"%d\"", info.data);
+		show_raid_stack(lc);
 	}
 
 	/* Reconfigure device mapper */
 	// FIXME: is nosync enough? rs->status |= s_inconsistent;
-	rs->status |= s_nosync;
+	rs->status = s_ok;
+	if ((sub_rs = find_set(lc, NULL, vol_name, FIND_ALL))) {
+		sub_rs->status = s_ok;
+
+		list_for_each_entry(crs, &sub_rs->sets, list)
+			crs->status = s_ok;
+	}
+
 	change_set(lc, A_ACTIVATE, rs);
+	rs->status |= s_nosync;
+
+	if ((sub_rs = find_set(lc, NULL, vol_name, FIND_ALL))) {
+		sub_rs->status |= s_nosync;
+		list_for_each_entry(crs, &sub_rs->sets, list) {
+			crs->status |= s_nosync;
+		}
+	}
+
 	ret = change_set(lc, A_RELOAD, rs);
 	// FIXME: might need this later: change_set(lc, A_DEACTIVATE,rs);
 	if (!ret)
 		goto err;
 
+	if (!dso) {
+#ifdef DMRAID_LED
+		struct raid_dev *_rd;
+		list_for_each_entry(_rd, &sub_rs->devs, devs)
+			led(strrchr(_rd->di->path, '/') + 1, LED_REBUILD);
+#endif
+
+		if (check_rd->fmt->metadata_handler)
+			check_rd->fmt->metadata_handler(lc,
+							UPDATE_REBUILD_STATE,
+							NULL, (void *) rs);
+	}
+
 	/* End transaction */
 	end_log(lc, &log);
 	return 0;
 
-err:
+      err:
 	revert_log(lc, &log);
 	return ret;
 }
 
+struct dev_info *find_disk(struct lib_context *lc, char *dp);
+
+/* check if disk is under a raid set */
+int
+check_busy_disk(struct lib_context *lc, struct raid_dev *check_rd)
+{
+	struct raid_dev *rd;
+
+	if (!check_rd)
+		return 0;
+
+	if (!check_rd->di)
+		return 0;
+
+	list_for_each_entry(rd, LC_RD(lc), list) {
+		if (rd->di == check_rd->di)
+			return 0;
+	}
+
+	return 1;
+}
+
+int
+add_dev_to_array(struct lib_context *lc, struct raid_set *rs,
+		 uint build_metadata, struct raid_dev *hot_spare_rd)
+{
+	const char *set_name = lc->options[LC_REBUILD_SET].arg.str;
+	struct raid_dev *rd = NULL;
+	struct raid_set *sub_rs;
+
+	if ((hot_spare_rd) || (build_metadata)) {
+		struct raid_dev tmp_rd;
+		struct raid_dev *new_rd = hot_spare_rd;
+		enum type type = t_raid1;
+
+		sub_rs = find_set(lc, NULL, set_name, FIND_ALL);
+		if (sub_rs == NULL) {
+			log_print(lc, "Volume \"%s\" not found\n", set_name);
+			return 1;
+		}
+
+
+		type = sub_rs->type;
+
+		if (new_rd == NULL) {
+			const char *disk_name =
+				lc->options[LC_REBUILD_DISK].arg.str;
+
+			new_rd = &tmp_rd;
+			/* for non-hot-spare */
+			if (!(new_rd->di = find_disk(lc, (char *) disk_name)))
+				LOG_ERR(lc, 0, "failed to find disk %s",
+					disk_name);
+
+			/* check if disk is a member of another raid set */
+			if (!(check_busy_disk(lc, new_rd)))
+				LOG_ERR(lc, 0,
+					"disk %s cannot be used to rebuilding",
+					disk_name);
+
+			new_rd->fmt = get_format(rs);
+		}
+
+		/* add a rd to group raid set */
+		if ((rd = alloc_raid_dev(lc, "rebuild")) == NULL)
+			LOG_ERR(lc, 1,
+				"failed to allocate space for a raid_dev");
+
+		memset(rd, 0, sizeof(*rd));
+		rd->name = NULL;
+
+		rd->di = new_rd->di;
+		rd->fmt = new_rd->fmt;
+
+		rd->status = s_init;
+		rd->type = type;
+		rd->offset = 0;
+		rd->sectors = 0;
+
+		list_add_tail(&rd->list, LC_RD(lc));
+		list_add_tail(&rd->devs, &rs->devs);
+
+		/* add a spare to raid set */
+		sub_rs = find_set(lc, NULL, set_name, FIND_ALL);
+
+		if (!(rd = alloc_raid_dev(lc, __func__)))
+			LOG_ERR(lc, 1,
+				"failed to allocate space for a raid_dev");
+
+		rd->name = NULL;
+		rd->di = new_rd->di;
+		rd->fmt = new_rd->fmt;
+		rd->status = s_init;
+		rd->type = type;
+		rd->offset = 0;
+		rd->sectors = 0;
+		list_add_tail(&rd->devs, &sub_rs->devs);
+		sub_rs->total_devs++;
+	}
+
+	add_dev_to_raid(lc, rs, rd);
+	return 0;
+}
+
 /* Remove a disk from a raid1 */
-static int del_dev_in_raid1(struct lib_context *lc, struct raid_set *rs,
-			    struct raid_dev *rd)
+static int
+del_dev_in_raid1(struct lib_context *lc, struct raid_set *rs,
+		 struct raid_dev *rd)
 {
 	int ret;
 	struct raid_dev *tmp;
 	struct change *entry;
-	LIST_HEAD(log); /* Playback log */
+	LIST_HEAD(log);		/* Playback log */
 
 	/* Remove device from the raid set */
-	ret = alloc_entry(&entry);
+	ret = alloc_entry(&entry, lc);
 	if (ret)
 		goto err;
 
@@ -129,7 +370,7 @@
 	}
 
 	/* Write the metadata of the drive we're removing _first_ */
-	ret = alloc_entry(&entry);
+	ret = alloc_entry(&entry, lc);
 	if (ret)
 		goto err;
 
@@ -145,7 +386,7 @@
 		if (tmp == rd)
 			continue;
 
-		ret = alloc_entry(&entry);
+		ret = alloc_entry(&entry, lc);
 		if (ret)
 			goto err;
 
@@ -168,7 +409,7 @@
 	end_log(lc, &log);
 	return 0;
 
-err:
+      err:
 	revert_log(lc, &log);
 	return ret;
 }
@@ -176,13 +417,14 @@
 /* Corelate type and function to handle addition/removel of RAID device */
 struct handler {
 	enum change_type type;
-	int (*func) (struct lib_context *lc, struct raid_set *rs,
-		     struct raid_dev *rd);
+	int (*func) (struct lib_context * lc, struct raid_set * rs,
+		     struct raid_dev * rd);
 };
 
 /* Call the function to handle addition/removal of a RAID device */
-static int handle_dev(struct lib_context *lc, struct handler *h,
-		      struct raid_set *rs, struct raid_dev *rd)
+static int
+handle_dev(struct lib_context *lc, struct handler *h,
+	   struct raid_set *rs, struct raid_dev *rd)
 {
 	do {
 		if (h->type == rs->type)
@@ -193,11 +435,11 @@
 }
 
 /* Add a disk to an array. */
-int add_dev_to_set(struct lib_context *lc, struct raid_set *rs,
-		   struct raid_dev *rd)
+int
+add_dev_to_set(struct lib_context *lc, struct raid_set *rs, struct raid_dev *rd)
 {
 	struct handler handlers[] = {
-		{t_raid1, add_dev_to_raid1},
+		{t_raid1, add_dev_to_raid},
 		{t_undef, NULL},
 	};
 
@@ -216,8 +458,8 @@
 }
 
 /* Remove a disk from an array */
-int del_dev_in_set(struct lib_context *lc, struct raid_set *rs,
-		   struct raid_dev *rd)
+int
+del_dev_in_set(struct lib_context *lc, struct raid_set *rs, struct raid_dev *rd)
 {
 	struct handler handlers[] = {
 		{t_raid1, del_dev_in_raid1},
@@ -235,3 +477,323 @@
 
 	return handle_dev(lc, handlers, rs, rd);
 }
+
+/*
+ * Find group of raid_set to which sub_rs belongs 
+ * Serves one level stacked raids.
+ */
+struct raid_set *
+find_group(struct lib_context *lc, struct raid_set *sub_rs)
+{
+	struct raid_set *tmp = NULL, *r = NULL, *r2 = NULL;
+
+	list_for_each_entry(tmp, LC_RS(lc), list) {
+		if (T_GROUP(tmp)) {
+			list_for_each_entry(r, &tmp->sets, list) {
+				if (r == sub_rs)
+					return tmp;
+				else if (SETS(r)) {
+					list_for_each_entry(r2, &r->sets, list) {
+						if (r2 == sub_rs)
+							return tmp;
+					}
+				}
+			}
+		}
+	}
+
+	/* Group not found. */
+	return NULL;
+}
+
+struct raid_dev *find_spare(struct lib_context *lc, struct raid_set *sub_rs,
+			    struct raid_set **spare_set);
+
+int
+_rebuild_raidset(struct lib_context *lc, struct raid_set *sub_rs,
+		 char *set_name)
+{
+	struct raid_set *spare_set = NULL, *rs = NULL;
+	struct raid_dev *rd = NULL;
+	int driveRebuild = 1;
+
+	rs = find_group(lc, sub_rs);
+
+	/* raid 0 cannot be rebuild - exit */
+	if (T_RAID0(sub_rs) && (!SETS(sub_rs))) {
+		log_print(lc, "Rebuild: raid0 cannot be rebuild\n");
+		return 1;
+	}
+	/* FIXME - work-aroud for status reporting */
+	if (S_BROKEN(sub_rs->status) ||
+	    S_INCONSISTENT(sub_rs->status)) {
+		if (lc->options[LC_REBUILD_DISK].opt == 0) {
+			/* find the spare drive */
+			if ((rd = find_spare(lc, sub_rs, &spare_set)) == NULL) {
+				log_print(lc,
+					  "Rebuild: a hot-spare drive not found for a volume: \"%s\"."
+					  " Need a drive to rebuild a volume.\n",
+					  sub_rs->name);
+				return 1;
+			}
+
+		}
+	} else if (S_OK(sub_rs->status)) {
+		struct raid_dev *check_rd = RD_RS(sub_rs);
+		enum status state = s_ok;
+
+		if (check_rd && (check_rd->fmt->metadata_handler))
+			state = check_rd->fmt->metadata_handler(lc,
+								GET_REBUILD_STATE,
+								NULL, (void *)
+								sub_rs);
+
+		if (state != s_nosync) {
+			/* cannot rebuild */
+			log_print(lc,
+				  "Volume \"%s\" is not in rebuild state (current: %u)",
+				  sub_rs->name, state);
+			log_print(lc,
+				  "Rebuild: cannot rebuild from current state!\n");
+			return 1;
+		}
+		driveRebuild = 0;
+	} else if (!(S_NOSYNC(sub_rs->status))) {
+		/* cannot rebuild */
+		log_print(lc, "Rebuild: cannot rebuild from current state!\n");
+		return 1;
+	}
+
+
+	sub_rs->status = s_nosync;
+	rs->status = s_nosync;
+
+	/* set the name for rebuild set (function down the path are using this variable to
+	 * retrive the raid set that is rebuild 
+	 */
+
+
+	dbg_free((char *) lc->options[LC_REBUILD_SET].arg.str);
+	lc->options[LC_REBUILD_SET].arg.str =
+		(const char *) dbg_malloc(strlen(sub_rs->name) + 1);
+	strcpy((char *) lc->options[LC_REBUILD_SET].arg.str, sub_rs->name);
+
+	if (!(add_dev_to_array(lc, rs,
+			       (driveRebuild
+				&& lc->options[LC_REBUILD_DISK].opt)
+			       || rd, rd))) {
+		log_dbg(lc, "rebuild: raid \"%s\" rebuild finished\n",
+			set_name);
+	} else {
+		/* error - raid failed to be rebuilded */
+		log_print(lc, "Rebuild: raid \"%s\" rebuild failed\n",
+			  set_name);
+		return 1;
+	}
+	return 0;
+}
+
+
+int
+rebuild_raidset(struct lib_context *lc, char *set_name)
+{
+	struct raid_set *sub_rs = NULL;
+	int ret = 0;
+
+	sub_rs = find_set(lc, NULL, set_name, FIND_ALL);
+	if (sub_rs) {
+		/* for stacked subsets go throu the stack to retrive the subsets that:
+		   - do not contain subsets
+		   - are eligible for rebuild 
+		 */
+		if (SETS(sub_rs)) {
+			enum status curr_state = s_ok;
+			struct raid_set *r = NULL;
+
+			/* check sub-set that are in Ok state */
+			curr_state = s_ok;
+
+			/* check for all subsets that have state equal curr_state */
+			list_for_each_entry(r, &sub_rs->sets, list) {
+				if (r->status & curr_state) {
+					ret |= _rebuild_raidset(lc, r,
+								set_name);
+				}
+			}
+
+			/* TBD change to s_inconsisten when the states are reported in right way */
+			curr_state = s_broken | s_inconsistent;
+			list_for_each_entry(r, &sub_rs->sets, list) {
+				if (r->status & curr_state) {
+					ret |= _rebuild_raidset(lc, r,
+								set_name);
+				}
+			}
+		} else
+			ret |= _rebuild_raidset(lc, sub_rs, set_name);
+
+	} else
+		log_print(lc, "raid volume \"%s\" not found\n", set_name);
+
+	return ret;
+}
+
+
+int
+write_set_spare(struct lib_context *lc, void *v)
+{
+	int ret = 1;
+	struct raid_set *r, *rs = v;
+	struct raid_dev *rd;
+
+	/* Decend hierarchy */
+	list_for_each_entry(r, &rs->sets, list) {
+		/*
+		 * FIXME: does it make sense to try the rest of the subset
+		 *        in case we fail writing one ?
+		 */
+		if (!write_set_spare(lc, (void *) r))
+			log_err(lc, "writing RAID subset \"%s\", continuing",
+				r->name);
+	}
+
+	/* Write metadata to the RAID devices of a set */
+	list_for_each_entry(rd, &rs->devs, devs) {
+		/*
+		 * FIXME: does it make sense to try the rest of the
+		 *        devices in case we fail writing one ?
+		 */
+		if (!(T_GROUP(rs))) {
+			if (!write_dev(lc, rd, 0)) {
+				log_err(lc,
+					"writing RAID device \"%s\", continuing",
+					rd->di->path);
+				ret = 0;
+			}
+		}
+	}
+
+	return ret;
+}
+
+
+
+static int
+add_spare_dev_to_raid(struct lib_context *lc, struct raid_set *rs)
+{
+	int ret = 0;
+	struct dmraid_format *fmt_hand;
+
+
+	/* find format handler */
+	fmt_hand = get_format(rs);
+
+	if (!(fmt_hand->create)) {
+		LOG_ERR(lc, 0,
+			"metadata creation is not supported in \"%s\" format",
+			fmt_hand->name);
+	} else {
+		if ((ret = fmt_hand->create(lc, rs)))
+			ret = write_set_spare(lc, rs);
+
+		if (!ret)
+			log_print(lc, "metadata fmt update failed\n");
+	}
+
+	return ret;
+}
+
+int
+add_spare_dev_to_array(struct lib_context *lc, struct raid_set *rs)
+{
+	struct dev_info *di;
+	struct dmraid_format *fmt_hand;
+	struct raid_dev *rd;
+	struct raid_set *rs_sub;
+
+	const char *disk_name = lc->options[LC_REBUILD_DISK].arg.str;
+
+
+	/* find format handler */
+	fmt_hand = get_format(rs);
+
+	/* add a spare rs to raid set */
+	if (!(rs_sub = alloc_raid_set(lc, "rebuild")))
+		return 0;
+
+	rs_sub->name = NULL;
+	rs_sub->size = 0;
+	rs_sub->stride = 0;
+	rs_sub->type = t_spare;
+	rs_sub->flags = 0;
+	rs_sub->status = s_init;
+	list_add_tail(&rs_sub->list, &rs->sets);
+
+	/* Find disk by name. */
+	if (!(di = find_disk(lc, (char *) disk_name)))
+		LOG_ERR(lc, 0, "failed to find disk %s", disk_name);
+
+	/* Add a rd to group raid set. */
+	if ((rd = alloc_raid_dev(lc, "rebuild")) == NULL)
+		LOG_ERR(lc, 0, "failed to allocate space for a raid_dev");
+
+	rd->name = NULL;
+	rd->di = di;
+	rd->fmt = fmt_hand;
+	rd->status = s_init;
+	rd->type = t_spare;
+	rd->offset = 0;
+	rd->sectors = 0;
+
+	/* add dev to lc list and to group rs */
+	list_add_tail(&rd->list, LC_RD(lc));
+	list_add_tail(&rd->devs, &rs->devs);
+
+	if (!(rd = alloc_raid_dev(lc, "rebuild")))
+		LOG_ERR(lc, 0, "failed to allocate space for a raid_dev");
+
+	rd->name = NULL;
+	rd->di = di;
+	rd->fmt = fmt_hand;
+	rd->status = s_init;
+	rd->type = t_spare;
+	rd->offset = 0;
+	rd->sectors = 0;
+	list_add_tail(&rd->devs, &rs_sub->devs);
+	return add_spare_dev_to_raid(lc, rs);
+}
+
+
+/* Add a disk to raid set as spare disk. */
+int
+hot_spare_add(struct lib_context *lc, struct raid_set *rs)
+{
+	const char *vol_name = lc->options[LC_HOT_SPARE_SET].arg.str;
+	int ret_func;
+	struct dmraid_format *fmt_hand;
+
+
+	if (!(!OPT_FORMAT(lc) &&
+	      OPT_REBUILD_DISK(lc) &&
+	      OPT_HOT_SPARE_SET(lc)))
+		return 0;
+
+	if (!(fmt_hand = get_format(rs)))
+		LOG_ERR(lc, 0, "unknown metadata format");
+
+	if (!(fmt_hand->metadata_handler))
+		LOG_ERR(lc, 0,
+			"metadata_handler() is not supported in \"%s\" format",
+			fmt_hand->name);
+
+	ret_func = fmt_hand->metadata_handler(lc, CHECK_HOT_SPARE, NULL,
+					      (void *) rs);
+
+	if (!ret_func)
+		LOG_ERR(lc, 0,
+			"hot-spare cannot be added to existing raid "
+			"set \"%s\" in \"%s\" format",
+			vol_name, fmt_hand->name);
+
+	return add_spare_dev_to_array(lc, rs);
+}
--- dmraid/lib/misc/file.c	2008/02/22 17:04:36	1.2
+++ dmraid/lib/misc/file.c	2008/06/20 21:52:18	1.3
@@ -8,17 +8,18 @@
 #include "internal.h"
 
 /* Create directory recusively. */
-static int mk_dir_recursive(struct lib_context *lc, const char *dir)
+static int
+mk_dir_recursive(struct lib_context *lc, const char *dir)
 {
 	int ret = 1;
-        char *orig, *s;
+	char *orig, *s;
 	const char delim = '/';
 
-        if (!(orig = s = dbg_strdup((char*) dir)))
+	if (!(orig = s = dbg_strdup((char *) dir)))
 		return log_alloc_err(lc, __func__);
 
-        /* Create parent directories */
-        log_notice(lc, "creating directory %s", dir);
+	/* Create parent directories */
+	log_notice(lc, "creating directory %s", dir);
 	do {
 		s = remove_delimiter(s + 1, delim);
 		if (mkdir(orig, 0777) && errno != EEXIST) {
@@ -32,11 +33,12 @@
 
 	dbg_free(orig);
 
-        return ret;
+	return ret;
 }
 
 /* Create directory. */
-int mk_dir(struct lib_context *lc, const char *dir)
+int
+mk_dir(struct lib_context *lc, const char *dir)
 {
 	struct stat info;
 
@@ -50,18 +52,19 @@
 	LOG_ERR(lc, 0, "directory %s not found", dir);
 }
 
-static int rw_file(struct lib_context *lc, const char *who, int flags,
-		   char *path, void *buffer, size_t size, loff_t offset)
+static int
+rw_file(struct lib_context *lc, const char *who, int flags,
+	char *path, void *buffer, size_t size, loff_t offset)
 {
 	int fd, ret = 0;
 	loff_t o;
 	struct {
-		ssize_t (*func)();
+		ssize_t(*func) ();
 		const char *what;
 	} rw_spec[] = {
-		{ read,  "read" },
-		{ write, "writ" },
-	}, *rw = rw_spec + ((flags & O_WRONLY) ? 1 : 0);
+		{
+		read, "read"}, {
+	write, "writ"},}, *rw = rw_spec + ((flags & O_WRONLY) ? 1 : 0);
 
 	if ((fd = open(path, flags, lc->mode)) == -1)
 		LOG_ERR(lc, 0, "opening \"%s\"", path);
@@ -71,7 +74,7 @@
 #else
 #define	DMRAID_LSEEK	lseek64
 #endif
-	if (offset && (o = DMRAID_LSEEK(fd, offset, SEEK_SET)) == (loff_t) -1)
+	if (offset && (o = DMRAID_LSEEK(fd, offset, SEEK_SET)) == (loff_t) - 1)
 		log_err(lc, "%s: seeking device \"%s\" to %" PRIu64,
 			who, path, offset);
 	else if (rw->func(fd, buffer, size) != size)
@@ -85,16 +88,18 @@
 	return ret;
 }
 
-int read_file(struct lib_context *lc, const char *who, char *path,
-	      void *buffer, size_t size, loff_t offset)
+int
+read_file(struct lib_context *lc, const char *who, char *path,
+	  void *buffer, size_t size, loff_t offset)
 {
 	return rw_file(lc, who, O_RDONLY, path, buffer, size, offset);
 }
 
-int write_file(struct lib_context *lc, const char *who, char *path,
-	       void *buffer, size_t size, loff_t offset)
+int
+write_file(struct lib_context *lc, const char *who, char *path,
+	   void *buffer, size_t size, loff_t offset)
 {
 	/* O_CREAT|O_TRUNC are noops on a devnode. */
-	return rw_file(lc, who, O_WRONLY|O_CREAT|O_TRUNC, path,
+	return rw_file(lc, who, O_WRONLY | O_CREAT | O_TRUNC, path,
 		       buffer, size, offset);
 }
--- dmraid/lib/misc/init.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/misc/init.c	2008/06/20 21:52:18	1.2
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -7,11 +7,16 @@
 
 #include "internal.h"
 
+extern int dso;
+
 /* Library initialization. */
-struct lib_context *libdmraid_init(int argc, char **argv)
+struct lib_context *
+libdmraid_init(int argc, char **argv)
 {
 	struct lib_context *lc;
 
+	dso = (argv[0] && strcmp(argv[0], "dso")) ? 1 : 0;
+
 	if ((lc = alloc_lib_context(argv))) {
 		if (!register_format_handlers(lc)) {
 			libdmraid_exit(lc);
@@ -25,11 +30,12 @@
 }
 
 /* Library exit processing. */
-void libdmraid_exit(struct lib_context *lc)
+void
+libdmraid_exit(struct lib_context *lc)
 {
 	free_raid_set(lc, NULL);	/* Free all RAID sets. */
 	free_raid_dev(lc, NULL);	/* Free all RAID devices. */
 	free_dev_info(lc, NULL);	/* Free all disk infos. */
 	unregister_format_handlers(lc);	/* Unregister all format handlers. */
-	free_lib_context(lc);		/* Release library context. */
+	free_lib_context(lc);	/* Release library context. */
 }
--- dmraid/lib/misc/lib_context.c	2008/04/02 13:35:32	1.2
+++ dmraid/lib/misc/lib_context.c	2008/06/20 21:52:18	1.3
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -10,34 +10,39 @@
 #include "version.h"
 
 /* Options access functions. */
-static inline int lc_opt_ok(enum lc_options o)
+static inline int
+lc_opt_ok(enum lc_options o)
 {
 	return o < LC_OPTIONS_SIZE;
 }
 
-int lc_opt(struct lib_context *lc, enum lc_options o)
+int
+lc_opt(struct lib_context *lc, enum lc_options o)
 {
 	return lc_opt_ok(o) ? lc->options[o].opt : 0;
 }
 
-static int _inc_opt(struct lib_context *lc, int o)
+static int
+_inc_opt(struct lib_context *lc, int o)
 {
-	return lc->options[o].opt < UCHAR_MAX ? ++lc->options[o].opt :
-					       lc->options[o].opt;
+	return lc->options[o].opt < UCHAR_MAX ?
+	       ++lc->options[o].opt : lc->options[o].opt;
 }
 
-int lc_inc_opt(struct lib_context *lc, int o)
+int
+lc_inc_opt(struct lib_context *lc, int o)
 {
 	return lc_opt_ok(o) ? _inc_opt(lc, o) : 0;
 }
 
-const char *lc_strcat_opt(struct lib_context *lc, enum lc_options o,
-			  char *arg, const char delim)
+const char *
+lc_strcat_opt(struct lib_context *lc, enum lc_options o,
+	      char *arg, const char delim)
 {
 	char *ret = NULL;
 
 	if (lc_opt_ok(o)) {
-		char *a = (char*) OPT_STR(lc, o);
+		char *a = (char *) OPT_STR(lc, o);
 		size_t end = (a ? strlen(a) : 0),
 		       len = end + strlen(arg) + ((delim && end) ? 1 : 0) + 1;
 
@@ -50,7 +55,7 @@
 			strcat(ret, arg);
 			OPT_STR(lc, o) = ret;
 		} else {
-			dbg_free((char*) OPT_STR(lc, o));
+			dbg_free((char *) OPT_STR(lc, o));
 			OPT_STR(lc, o) = ret;
 			log_alloc_err(lc, __func__);
 		}
@@ -59,13 +64,13 @@
 	return ret;
 }
 
-const char *lc_stralloc_opt(struct lib_context *lc, enum lc_options o,
-			    char *arg)
+const char *
+lc_stralloc_opt(struct lib_context *lc, enum lc_options o, char *arg)
 {
 	if (lc_opt_ok(o)) {
 		/* Free any already allocated one. */
 		if (OPT_STR(lc, o))
-			dbg_free((char*) OPT_STR(lc, o));
+			dbg_free((char *) OPT_STR(lc, o));
 
 		/* Dup new one. */
 		if ((OPT_STR(lc, o) = dbg_strdup(arg)))
@@ -77,12 +82,14 @@
 	return NULL;
 }
 
-const char *lc_opt_arg(struct lib_context *lc, enum lc_options o)
+const char *
+lc_opt_arg(struct lib_context *lc, enum lc_options o)
 {
 	return lc_opt_ok(o) ? lc->options[o].arg.str : NULL;
 }
 
-struct list_head *lc_list(struct lib_context *lc, int l)
+struct list_head *
+lc_list(struct lib_context *lc, int l)
 {
 	return l < ARRAY_SIZE(lc->lists) ? lc->lists + l : NULL;
 }
@@ -90,21 +97,24 @@
 /*
  * Library context initialization functions.
  */
-static void init_options(struct lib_context *lc, void *arg)
+static void
+init_options(struct lib_context *lc, void *arg)
 {
 	lc_inc_opt(lc, LC_SEPARATOR);
-	lc->options[LC_SEPARATOR].arg.str = dbg_strdup((char*) ",");
+	lc->options[LC_SEPARATOR].arg.str = dbg_strdup((char *) ",");
 
 	lc_inc_opt(lc, LC_PARTCHAR);
-	lc->options[LC_PARTCHAR].arg.str = dbg_strdup((char*) "p");
+	lc->options[LC_PARTCHAR].arg.str = dbg_strdup((char *) "p");
 }
 
-static void init_cmd(struct lib_context *lc, void *arg)
+static void
+init_cmd(struct lib_context *lc, void *arg)
 {
-	lc->cmd = get_basename(lc, ((char**) arg)[0]);
+	lc->cmd = get_basename(lc, ((char **) arg)[0]);
 }
 
-static void init_lists(struct lib_context *lc, void *arg)
+static void
+init_lists(struct lib_context *lc, void *arg)
 {
 	unsigned int i = LC_LISTS_SIZE;
 
@@ -112,40 +122,44 @@
 		INIT_LIST_HEAD(lc->lists + i);
 }
 
-static void init_mode(struct lib_context *lc, void *arg)
+static void
+init_mode(struct lib_context *lc, void *arg)
 {
 	lc->mode = 0600;
 }
 
-static void init_paths(struct lib_context *lc, void *arg)
+static void
+init_paths(struct lib_context *lc, void *arg)
 {
 	lc->path.error = "/dev/zero";
 }
 
 /* FIXME: add lib flavour info (e.g., DEBUG). */
-static void init_version(struct lib_context *lc, void *arg)
+static void
+init_version(struct lib_context *lc, void *arg)
 {
-	lc->version.text	= DMRAID_LIB_VERSION;
-	lc->version.date	= DMRAID_LIB_DATE;
-	lc->version.v.major	= DMRAID_LIB_MAJOR_VERSION;
-	lc->version.v.minor	= DMRAID_LIB_MINOR_VERSION;
-	lc->version.v.sub_minor	= DMRAID_LIB_SUBMINOR_VERSION;
-	lc->version.v.suffix	= DMRAID_LIB_VERSION_SUFFIX;
+	lc->version.text = DMRAID_LIB_VERSION;
+	lc->version.date = DMRAID_LIB_DATE;
+	lc->version.v.major = DMRAID_LIB_MAJOR_VERSION;
+	lc->version.v.minor = DMRAID_LIB_MINOR_VERSION;
+	lc->version.v.sub_minor = DMRAID_LIB_SUBMINOR_VERSION;
+	lc->version.v.suffix = DMRAID_LIB_VERSION_SUFFIX;
 }
 
 /* Put init functions into an array because of the potentially growing list. */
 struct init_fn {
-	void (*func)(struct lib_context *lc, void *arg);
+	void (*func) (struct lib_context * lc, void *arg);
 } init_fn[] = {
-	{ init_options },
-	{ init_cmd },
-	{ init_lists },
-	{ init_mode },
-	{ init_paths },
-	{ init_version },
-};
+	{
+	init_options}, {
+	init_cmd}, {
+	init_lists}, {
+	init_mode}, {
+	init_paths}, {
+init_version},};
 
-struct lib_context *alloc_lib_context(char **argv)
+struct lib_context *
+alloc_lib_context(char **argv)
 {
 	struct lib_context *lc;
 	struct init_fn *f;
@@ -167,26 +181,29 @@
 	return lc;
 }
 
-void free_lib_context(struct lib_context *lc)
+void
+free_lib_context(struct lib_context *lc)
 {
 	int o;
 
 	for (o = 0; o < LC_OPTIONS_SIZE; o++) {
 		if (lc->options[o].arg.str)
-			dbg_free ((char*) lc->options[o].arg.str);
+			dbg_free((char *) lc->options[o].arg.str);
 	}
 
 	dbg_free(lc);
 }
 
 /* Return library date (ASCII). */
-const char *libdmraid_date(struct lib_context *lc)
+const char *
+libdmraid_date(struct lib_context *lc)
 {
 	return lc->version.date;
 }
 
 /* Return library version (ASCII). */
-const char *libdmraid_version(struct lib_context *lc)
+const char *
+libdmraid_version(struct lib_context *lc)
 {
 	return lc->version.text;
 }
--- dmraid/lib/misc/misc.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/misc/misc.c	2008/06/20 21:52:18	1.2
@@ -2,6 +2,9 @@
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -9,7 +12,8 @@
 #include "internal.h"
 
 /* Prompt for a yes/no answer */
-int yes_no_prompt(struct lib_context *lc, const char *prompt, ...)
+int
+yes_no_prompt(struct lib_context *lc, const char *prompt, ...)
 {
 	int c = '\n';
 	va_list ap;
@@ -31,7 +35,8 @@
 }
 
 /* Return the basename of a path. */
-char *get_basename(struct lib_context *lc, char *str)
+char *
+get_basename(struct lib_context *lc, char *str)
 {
 	char *ret = strrchr(str, '/');
 
@@ -39,7 +44,8 @@
 }
 
 /* Return the dirname of a path. */
-char *get_dirname(struct lib_context *lc, char *str)
+char *
+get_dirname(struct lib_context *lc, char *str)
 {
 	char *ret = strrchr(str, '/');
 	size_t len = ret ? ret - str : strlen(str);
@@ -51,7 +57,8 @@
 }
 
 /* Convert a numeric string to alpha. */
-void mk_alpha(struct lib_context *lc, char *str, size_t len)
+void
+mk_alpha(struct lib_context *lc, char *str, size_t len)
 {
 	for (; len && *str; len--, str++) {
 		if (isdigit(*str))
@@ -60,7 +67,8 @@
 }
 
 /* Remove any whitespace from a string. */
-char *remove_white_space(struct lib_context *lc, char *str, size_t size)
+char *
+remove_white_space(struct lib_context *lc, char *str, size_t size)
 {
 	int c;
 	char *in = str, *out = str;
@@ -70,24 +78,36 @@
 		if (!isspace(c))
 			*out++ = c;
 	}
-	*out = 0;
 
+	*out = 0;
 	return str;
 
 }
 
+/* Remove any whitespace at the tail of a string */
+void
+remove_tail_space(char *str)
+{
+	char *s = str + strlen(str);
+
+	while (s-- > str && isspace(*s))
+		*s = 0;
+}
+
 /* Remove/add a delimiter character. */
-char *remove_delimiter(char *ptr, char c)
+char *
+remove_delimiter(char *ptr, char c)
 {
 	char *ret = NULL;
 
 	if (ptr && (ret = strchr(ptr, (int) c)))
 		*ret = 0;
 
-	return ret; 
+	return ret;
 }
 
-void add_delimiter(char **ptr, char c)
+void
+add_delimiter(char **ptr, char c)
 {
 	if (ptr && *ptr) {
 		**ptr = c;
@@ -95,24 +115,38 @@
 	}
 }
 
+char *
+replace_delimiter(char *str, char delim, char c)
+{
+	char *s = str;
+
+	while ((s = remove_delimiter(s, delim)))
+		add_delimiter(&s, c);
+
+	return str;
+}
+
 /* Grow a string. */
-static int grow_string(struct lib_context *lc, char **string, const char *s)
+static int
+grow_string(struct lib_context *lc, char **string, const char *s)
 {
 	size_t len;
 	char *tmp = *string;
 
- 	len = strlen(s) + (tmp ? strlen(tmp) + 1 : 1);
+	len = strlen(s) + (tmp ? strlen(tmp) + 1 : 1);
 	if ((*string = dbg_realloc(tmp, len))) {
 		if (!tmp)
 			**string = '\0';
-	} else if (tmp)
+	}
+	else if (tmp)
 		dbg_free(tmp);
-	
+
 	return *string ? 1 : 0;
 }
 
 /* Free a string. */
-void free_string(struct lib_context *lc, char **string)
+void
+free_string(struct lib_context *lc, char **string)
 {
 	if (*string) {
 		dbg_free(*string);
@@ -121,46 +155,48 @@
 }
 
 /* Push a string onto the end of another. */
-static int p_str(struct lib_context *lc, char **string, const char *s)
+static int
+p_str(struct lib_context *lc, char **string, const char *s)
 {
 	int ret;
 
 	if ((ret = grow_string(lc, string, s)))
-		strcat (*string, s);
+		strcat(*string, s);
 
 	return ret;
 }
 
 /* Push a string defined by a start and end pointer onto the end of another. */
-static int p_str_str(struct lib_context *lc, char **string,
-		     char *begin, char *end)
+static int
+p_str_str(struct lib_context *lc, char **string, char *begin, char *end)
 {
 	if (end == begin)
 		return 1;
 
 	*end = 0;
-
 	return p_str(lc, string, begin);
 }
 
 /* Push an uint64_t in ascii onto the end of a string. */
-static int p_u64(struct lib_context *lc, char **string, const uint64_t u)
+static int
+p_u64(struct lib_context *lc, char **string, const uint64_t u)
 {
 	char buffer[22];
 
 	sprintf(buffer, "%" PRIu64, u);
-
 	return p_str(lc, string, buffer);
 }
 
 /* Push an uint_t in ascii onto the end of a string. */
-static int p_u(struct lib_context *lc, char **string, const unsigned int u)
+static int
+p_u(struct lib_context *lc, char **string, const unsigned int u)
 {
 	return p_u64(lc, string, (uint64_t) u);
 }
 
 /* Push an uint_t in ascii onto the end of a string. */
-static int p_d(struct lib_context *lc, char **string, const int d)
+static int
+p_d(struct lib_context *lc, char **string, const int d)
 {
 	char buffer[12];
 
@@ -170,12 +206,13 @@
 }
 
 /* Push a format string defined list of arguments onto a string. */
-int p_fmt(struct lib_context *lc, char **string, const char *fmt, ...)
+int
+p_fmt(struct lib_context *lc, char **string, const char *fmt, ...)
 {
 	int ret = 1;
 	char *b, *f, *f_sav;
 	va_list ap;
-	
+
 	if (!(f = f_sav = dbg_strdup((char *) fmt)))
 		return 0;
 
@@ -198,7 +235,7 @@
 		case 's':
 			ret = p_str(lc, string, va_arg(ap, char *));
 			break;
-	
+
 		case 'u':
 			ret = p_u(lc, string, va_arg(ap, unsigned int));
 			break;
@@ -222,3 +259,49 @@
 
 	return ret;
 }
+
+#ifdef DMRAID_LED
+int
+led(const char *path, int status)
+{
+
+#ifdef DMRAID_INTEL_LED
+	FILE *fd;
+	int sgpio = 0;
+	static char com[100];
+
+	/* Check if sgpio app is installed. */
+	if ((fd = popen("which sgpio", "r"))) {
+		sgpio = fscanf(fd, "%s", com);
+		close(fd);
+	}
+
+	if (sgpio != 1) {
+		printf("sgpio app not found\n");
+		return 1;
+	}
+
+	switch (status) {
+	case LED_REBUILD:
+		sprintf(com, "sgpio -d %s -s rebuild", path);
+		break;
+
+	case LED_OFF:
+		sprintf(com, "sgpio -d %s -s off", path);
+		break;
+
+	default:
+		printf("Unknown LED status\n");
+		return 2;
+	}
+
+	if (system(com) == -1) {
+		printf("Call to sgpio app (%s) failed\n", com);
+		return 4;
+	}
+#endif
+
+	return 0;
+
+}
+#endif
--- dmraid/lib/misc/workaround.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/misc/workaround.c	2008/06/20 21:52:18	1.2
@@ -15,22 +15,23 @@
  * populate /sys/block in case of IDE module
  * load because of asynchronuous registration !?
  */
-void sysfs_workaround(struct lib_context *lc)
+void
+sysfs_workaround(struct lib_context *lc)
 {
 	int d, fd;
 	size_t len;
 	char *dev;
 
 	if (!(dev = dbg_malloc(sizeof(_PATH_DEV) + 4)))
-		LOG_ERR(lc, , "sysfs workaround");
+		LOG_ERR(lc,, "sysfs workaround");
 
 	sprintf(dev, "%shd?", _PATH_DEV);
 	for (len = strlen(dev) - 1, d = 'a'; d <= 'z'; d++) {
 		dev[len] = (char) d;
 
 		if (!removable_device(lc, dev) &&
-		    (fd = open (dev, O_RDONLY)) != -1)
-			close (fd);
+		    (fd = open(dev, O_RDONLY)) != -1)
+			close(fd);
 	}
 
 	dbg_free(dev);
--- dmraid/lib/mm/dbg_malloc.c	2008/02/22 16:57:37	1.1
+++ dmraid/lib/mm/dbg_malloc.c	2008/06/20 21:52:18	1.2
@@ -12,7 +12,8 @@
 #include "dbg_malloc.h"
 #include "log/log.h"
 
-static void *__dbg_malloc(size_t size, int init)
+static void *
+__dbg_malloc(size_t size, int init)
 {
 	void *ret = malloc(size);
 
@@ -24,31 +25,34 @@
 
 #ifdef	DEBUG_MALLOC
 
-void *_dbg_malloc(size_t size, struct lib_context *lc,
-		  const char *who, unsigned int line)
+void *
+_dbg_malloc(size_t size, struct lib_context *lc,
+	    const char *who, unsigned int line)
 {
 	void *ret = __dbg_malloc(size, 1);
 
 	log_dbg(lc, "%s: dbg_malloc(%zu) at line %u returned 0x%x",
-		(char*) who, size, line, (unsigned long) ret);
+		(char *) who, size, line, (unsigned long) ret);
 
 	return ret;
 }
 
-void *_dbg_realloc(void *ptr, size_t size, struct lib_context *lc,
-		   const char *who, unsigned int line)
+void *
+_dbg_realloc(void *ptr, size_t size, struct lib_context *lc,
+	     const char *who, unsigned int line)
 {
 	void *ret = realloc(ptr, size);
 
 	log_dbg(lc, "%s: dbg_realloc(0x%x, %zu) at line %u returned 0x%x",
-		(char*) who, (unsigned long) ptr, size, line,
+		(char *) who, (unsigned long) ptr, size, line,
 		(unsigned long) ret);
 
 	return ret;
 }
 
-void *_dbg_strndup(void *ptr, size_t len, struct lib_context *lc,
-		   const char *who, unsigned int line)
+void *
+_dbg_strndup(void *ptr, size_t len, struct lib_context *lc,
+	     const char *who, unsigned int line)
 {
 	char *ret;
 
@@ -58,40 +62,44 @@
 	}
 
 	log_dbg(lc, "%s: dbg_strndup(0x%x) at line %u returned 0x%x",
-		(char*) who, (unsigned long) ptr, line, (unsigned long) ret);
+		(char *) who, (unsigned long) ptr, line, (unsigned long) ret);
 
 	return ret;
 
 }
 
-void *_dbg_strdup(void *ptr, struct lib_context *lc,
-		  const char *who, unsigned int line)
+void *
+_dbg_strdup(void *ptr, struct lib_context *lc,
+	    const char *who, unsigned int line)
 {
 	return _dbg_strndup(ptr, strlen(ptr), lc, who, line);
 }
 
 
-void _dbg_free(void *ptr, struct lib_context *lc,
-	       const char *who, unsigned int line)
+void
+_dbg_free(void *ptr, struct lib_context *lc, const char *who, unsigned int line)
 {
 	log_dbg(lc, "%s: dbg_free(0x%x) at line %u",
-		(char*) who, (unsigned long) ptr, line);
+		(char *) who, (unsigned long) ptr, line);
 	free(ptr);
 }
 
 #else
 
-void *_dbg_malloc(size_t size)
+void *
+_dbg_malloc(size_t size)
 {
 	return __dbg_malloc(size, 1);
 }
 
-void *_dbg_realloc(void *ptr, size_t size)
+void *
+_dbg_realloc(void *ptr, size_t size)
 {
 	return realloc(ptr, size);
 }
 
-void *_dbg_strndup(void *ptr, size_t len)
+void *
+_dbg_strndup(void *ptr, size_t len)
 {
 	char *ret;
 
@@ -103,12 +111,14 @@
 	return ret;
 }
 
-void *_dbg_strdup(void *ptr)
+void *
+_dbg_strdup(void *ptr)
 {
 	return _dbg_strndup(ptr, strlen(ptr));
 }
 
-void _dbg_free(void *ptr)
+void
+_dbg_free(void *ptr)
 {
 	free(ptr);
 }
--- dmraid/man/dmraid.8	2008/04/02 13:35:32	1.2
+++ dmraid/man/dmraid.8	2008/06/20 21:52:18	1.3
@@ -1,420 +1,533 @@
-.TH DMRAID 8 "DMRAID TOOL" "Heinz Mauelshagen" \" -*- nroff -*-
-.SH NAME
-dmraid \- discover and activate software (ATA)RAID
-.SH SYNOPSIS
-.B dmraid
- {-a|--activate} {y|n|yes|no} 
- [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
- [-f|--format FORMAT[,FORMAT...]]
- [{-P|--partchar} CHAR]
- [-p|--no_partitions]
- [--separator SEPARATOR]
- [-t|--test]
- [RAID-set...]
-
-.B dmraid
- {-b|--block_devices}
- [-c|--display_columns][FIELD[,FIELD...]]...
- [-d|--debug]... [-v|--verbose]...
- [--separator SEPARATOR]
- [device-path...]
-
-.B dmraid
- {-h|--help}
-
-.B dmraid
- {-l|--list_formats}
- [-d|--debug]... [-v|--verbose]...
-
-.B dmraid
- {-n|--native_log}
- [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
- [-f|--format FORMAT[,FORMAT...]]
- [--separator SEPARATOR]
- [device-path...]
-
-.B dmraid
- {-r|--raid_devices}
- [-c|--display_columns][FIELD[,FIELD...]]...
- [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
- [-D|--dump_metadata]
- [-f|--format FORMAT[,FORMAT...]]
- [--separator SEPARATOR]
- [device-path...]
-
-.B dmraid
- {-r|--raid_devices}
- [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
- [-E|--erase_metadata]
- [-f|--format FORMAT[,FORMAT...]]
- [--separator SEPARATOR]
- [device-path...]
-
-.B dmraid
- {-s|--sets}...[a|i|active|inactive]
- [-c|--display_columns][FIELD[,FIELD...]]...
- [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
- [-f|--format FORMAT[,FORMAT...]]
- [-g|--display_group]
- [--separator SEPARATOR]
- [RAID-set...]
-
-.B dmraid
- {-V/--version}
-
-.SH DESCRIPTION
-dmraid discovers block and software RAID devices (eg, ATARAID)
-by using multiple different metadata format handlers which
-support various formats (eg, Highpoint 37x series).
-It offers activating RAID sets made up by 2 or more
-discovered RAID devices, display properties of devices and sets (see option
-.B -l
-for supported metadata formats).
-Block device access to activated RAID sets occurs via device-mapper nodes
-/dev/mapper/RaidSetName.
-RaidSetName starts with the format name (see
-.B -l
-option) which can be used to access all RAID sets of a specific format
-easily with certain options (eg,
-.B -a
-below).
-
-.SS OPTIONS
-.TP
-.I \-a, \-\-activate {y|n} [RAID set...]
-Activates or deactivates all or particular software RAID set.
-In case metadata format handlers are chosen with
-.B -f
-, only RAID sets with such format(s) can be activated or deactivated.
-Useful if devices have multiple metadata signatures.
-When activating RAID sets,
-.B -p
-disables the activation of partitions on them.
-RAID set names given on command line don't need to be fully specified
-(eg, "dmraid -ay sil" would activate all discovered Silicon Image Medley
-RAID sets).
-
-.TP
-.I {-b|--block_devices} [device-path...]
-List all or particular discovered block devices with their
-properties (size, serial number).
-Add
-.B -c
-to display block device names only and
-.B -cc
-for CSV column output of block device properties.
-See description of
-.B -c
-below for FIELD identifiers.
-
-.TP
-.I [-d|--debug]...
-Enable debugging output. Opion can be given multiple times
-increasing the debug output level.
-
-.TP
-.I [-c|--display_columns][FIELD[,FIELD...]]...
-Display properties of block devices, RAID sets and devices in column(s).
-Optional list specifying which FIELDs to display.
-.br
-For
-.B -b:
-.br
-d[evpath]|p[ath], sec[tors]|si[ze], ser[ialnumber].
-.br
-For
-.B -r:
-.br
-de[vpath]|p[ath], f[ormat], r[aidname], t[ype], st[atus], se[ctors]|si[ze], da[taoffset]|o[ffset].
-.br
-For
-.B -s:
-.br
-f[ormat], r[aidname], t[ype], sta[tus], str[ide], se[ctors]|si[ze], su[bsets], d[evices], sp[ares].
-.br
-.TP
-.I [-f|--format FORMAT[,FORMAT...]]
-Use metadata format handler(s) to discover RAID devices.
-See
-.B -l
-for a list of supported format handler names. This is useful to
-select particular formats in case multiple metadata signatures are found
-on a device. A comma seperated list of format names can be specified which 
-may not contain white space.
-
-.TP
-.I {-h|--help}
-Display help text.
-
-.TP
-.I {-i|--ignorelocking}
-Don't take out any locks. Useful in early boot where no read/write
-access to /var is available.
-
-.TP
-.I {-l|--list_formats}
-List all available metadata format handlers with their names and
-descriptions. Supported RAID levels are listed in parenthesis:
-.br
-
-S: Span (concatination)
-.br
-0: RAID0 (stripe)
-.br
-1: RAID1 (mirror)
-.br
-10: RAID10 (mirror on top of stripes)
-.br
-01: RAID10 (stripe on top of mirrors)
-
-.TP
-.I {-n|--native_log} [device-path...]
-Display metadata in native, vendor-specific format.
-In case a metadata format handler is chosen with
-.B -f
-only RAID devices with such format will be displayed in native format.
-If device-path(s) is/are given on the command line, native metadata output
-is restricted to those listed.
-
-.TP
-.I [{-P|--partchar} CHAR]
-Use CHAR as the separator between the device name and the partition number.
-
-.TP
-.I {-r|--raid_devices} [device-path...]
-List all discovered RAID devices with format, RAID level, sectors used
-and data offset into the device.
-In case a metadata format handler is chosen with
-.B -f
-, only RAID devices with such format can be discovered. Useful if devices
-have multiple metadata signatures.
-If 
-.B -D
-is added to
-.B -r
-the RAID metadata gets dumped into a subdirectory named dmraid.format_name
-(eg. format_name = isw) in files named devicename.dat.
-The byte offset where the metadata is located on the device is written
-into files named devicename.offset and the size of the device in sectors
-into files named devicename.size.
-
-If 
-.B -E
-is added to
-.B -r
-the RAID metadata on the devices gets conditionally erased.
-Useful to erase old metadata after new one of different type has been
-stored on a device in order to avoid discovering both. If you enter
-.B -E
-option
-.B -D
-will be enforced in order to have a fallback in case the wrong metadata
-got erased.
-Manual copying back onto the device is needed to recover from erasing
-the wrong metadata using the dumped files devicename_formatname.dat
-and devicename_formatname.offset.
-Eg, to restore all *.dat files in the working directory to the respective devices:
-
-.br
-for f in *.dat
-.br
-do
-.br
-	dd if=$f of=/dev/${f%%.dat} \\
-.br
-	seek=`cat ${f%%dat}offset` bs=1
-.br
-done
-.br
-
-If device-path(s) is/are given on the command line, the above actions
-are restricted to those listed.
-Add
-.B -c
-to display RAID device names only and
-.B -cc
-for CSV column output of RAID device properties.
-See description of
-.B -c
-above for FIELD identifiers.
-
-.TP
-.I --separator SEPARATOR
-Use SEPARATOR as a delimiter for all options taking or displaying lists.
-
-.TP
-.I -s... [a|i] [RAID-set...]
-Display properties of RAID sets. Multiple RAID set names can be given
-on the command line which don't need to be fully specified (eg, "dmraid -s hpt"
-would display all discovered Highpoint RAID sets). Enter
-.B -s
-twice to display RAID subsets too.
-Add
-.B -c
-to display names of RAID sets only,
-.B -cc
-for CSV column output of RAID set properties and
-.B -ccc
-for inclusion of block devices in the listing. Doesn't imply
-.B -s -s
-to show RAID subsets (implied for group sets, e.g. isw).
-Add
-.B -g
-to include information about group RAID sets (as with Intel Software
-RAID) in the listing.
-See description of
-.B -c
-above for FIELD identifiers.
-
-.TP
-.I [-v|--verbose]...
-Enable verbose runtime information output. Opion can be given multiple times
-increasing the verbosity level.
-
-.SH EXAMPLES
-"dmraid -l" lists all supported metadata formats with their names along with
-some descriptive information, eg:
-.br
-hpt37x : (+) Highpoint HPT37X
-.br
-hpt45x : (+) Highpoint HPT45X
-.br
-isw    : (+) Intel Software RAID
-.br
-lsi    : (0) LSI Logic MegaRAID
-.br
-nvidia : (+) NVidia RAID
-.br
-pdc    : (+) Promise FastTrack
-.br
-sil    : (+) Silicon Image(tm) Medley(tm)
-.br
-via    : (+) VIA Software RAID
-.br
-dos    : (+) DOS partitions on SW RAIDs
-.br
-(0): Discover, (+): Discover+Activate
-
-"dmraid -ay" activates all software RAID sets discovered.
-
-"dmraid -an" deactivates all active software RAID sets which are not open
-(eg, mounted filesystem on them).
-
-"dmraid -ay -f pdc" (pdc looked up from "dmraid -l") activates all
-software RAID sets with Promise format discovered and ignores all other
-supported formats.
-
-"dmraid -r" discovers all software RAID devices supported on your system, eg:
-.br
-/dev/dm-46: hpt45x, "hpt45x_chidjhaiaa-0", striped, ok, 320172928 sectors, data@ 0
-.br
-/dev/dm-50: hpt45x, "hpt45x_chidjhaiaa-0", striped, ok, 320172928 sectors, data@ 0
-.br
-/dev/dm-54: hpt45x, "hpt45x_chidjhaiaa-1", striped, ok, 320172928 sectors, data@ 0
-.br
-/dev/dm-58: hpt45x, "hpt45x_chidjhaiaa-1", striped, ok, 320172928 sectors, data@ 0
-
-
-"dmraid -s -s hpt45x_chidjhaiaa" displays properties of
-set "hpt45x_chidjhaiaa", eg:
-.br
-*** Superset
-.br
-name   : hpt45x_chidjhaiaa
-.br
-size   : 640345856
-.br
-stride : 128
-.br
-type   : raid10
-.br
-status : ok
-.br
-subsets: 2
-.br
-dev    : 4
-.br
-spare  : 0
-.br
----> Subset
-.br
-name   : hpt45x_chidjhaiaa-0
-.br
-size   : 640345856
-.br
-stride : 128
-.br
-type   : stripe
-.br
-status : ok
-.br
-subsets: 0
-.br
-dev    : 2
-.br
-spare  : 0
-.br
----> Subset
-.br
-name   : hpt45x_chidjhaiaa-1
-.br
-size   : 640345856
-.br
-stride : 128
-.br
-type   : stripe
-.br
-status : ok
-.br
-subsets: 0
-.br
-dev    : 2
-.br
-spare  : 0
-.br
-
-"dmraid -s -ccs hpt45" displays properties in column format of all sets
-and subsets with hpt45* format, eg:
-.br
-hpt45x_chidjhaiaa,640345856,128,raid10,ok,4,0
-.br
-hpt45x_chidjhaiaa-a,640345856,128,stripe,ok,2,0
-.br
-hpt45x_chidjhaiaa-b,640345856,128,stripe,ok,2,0
-
-"dmraid -r --sep : -cpath:size" display paths and sizes in sectors for
-RAID devices in column format using ':' as a delimiter, eg:
-.br
-/dev/dm-8:320173055
-.br
-/dev/dm-12:320173055
-.br
-/dev/dm-22:320173055
-.br
-/dev/dm-26:320173055
-.br
-/dev/dm-30:586114703
-.br
-/dev/dm-34:586114703
-.br
-/dev/dm-38:586114703
-.br
-/dev/dm-42:586114703
-.br
-/dev/dm-46:156301487
-.br
-/dev/dm-50:156301487
-.br
-/dev/dm-54:390624896
-.br
-/dev/dm-58:390624896
-.br
-/dev/dm-62:390624896
-.br
-/dev/dm-66:390624896
-
-.SH DIAGNOSTICS
-dmraid returns an exit code of 0 for success or 1 for error.
-
-.SH AUTHOR
-Heinz Mauelshagen <Mauelshagen@RedHat.com>
+.TH DMRAID 8 "DMRAID TOOL" "Heinz Mauelshagen" \" -*- nroff -*-
+.SH NAME
+dmraid \- discover, configure and activate software (ATA)RAID
+.SH SYNOPSIS
+.B dmraid
+ {-a|--activate} {y|n|yes|no} 
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-f|--format FORMAT[,FORMAT...]]
+ [{-P|--partchar} CHAR]
+ [-p|--no_partitions]
+ [--separator SEPARATOR]
+ [-t|--test]
+ [RAID-set...]
+
+.B dmraid
+ {-b|--block_devices}
+ [-c|--display_columns][FIELD[,FIELD...]]...
+ [-d|--debug]... [-v|--verbose]...
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-h|--help}
+
+.B dmraid
+ {-l|--list_formats}
+ [-d|--debug]... [-v|--verbose]...
+
+.B dmraid
+ {-n|--native_log}
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-f|--format FORMAT[,FORMAT...]]
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-R| --rebuild}
+ RAID-set
+ [device-path]
+
+.B dmraid
+ {-x| --remove}
+ [RAID-set]
+
+.B dmraid
+ -f FORMAT-handler
+{-C| --create} set 
+ --type raidlevel
+ [--size=setsize --strip stridesize] 
+ --disk "device-path, device-path [, device-path ...]"
+
+.B dmraid
+[ -f|--format FORMAT-handler]
+-S|--spare [RAID-set]
+-M|--media  "device-path"
+
+.B dmraid
+ {-r|--raid_devices}
+ [-c|--display_columns][FIELD[,FIELD...]]...
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-D|--dump_metadata]
+ [-f|--format FORMAT[,FORMAT...]]
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-r|--raid_devices}
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-E|--erase_metadata]
+ [-f|--format FORMAT[,FORMAT...]]
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-s|--sets}...[a|i|active|inactive]
+ [-c|--display_columns][FIELD[,FIELD...]]...
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-f|--format FORMAT[,FORMAT...]]
+ [-g|--display_group]
+ [--separator SEPARATOR]
+ [RAID-set...]
+
+.B dmraid
+ {-V/--version}
+
+.SH DESCRIPTION
+dmraid discovers block and software RAID devices (eg, ATARAID)
+by using multiple different metadata format handlers which
+support various formats (eg, Highpoint 37x series).
+It offers activating RAID sets made up by 2 or more
+discovered RAID devices, display properties of devices and sets (see option
+.B -l
+for supported metadata formats).
+Block device access to activated RAID sets occurs via device-mapper nodes
+/dev/mapper/RaidSetName.
+RaidSetName starts with the format name (see
+.B -l
+option) which can be used to access all RAID sets of a specific format
+easily with certain options (eg,
+.B -a
+below).
+
+.SS OPTIONS
+.TP
+.I \-a, \-\-activate {y|n} [RAID set...]
+Activates or deactivates all or particular software RAID set.
+In case metadata format handlers are chosen with
+.B -f
+, only RAID sets with such format(s) can be activated or deactivated.
+Useful if devices have multiple metadata signatures.
+When activating RAID sets,
+.B -p
+disables the activation of partitions on them.
+RAID set names given on command line don't need to be fully specified
+(eg, "dmraid -ay sil" would activate all discovered Silicon Image Medley
+RAID sets).
+
+.TP
+.I {-b|--block_devices} [device-path...]
+List all or particular discovered block devices with their
+properties (size, serial number).
+Add
+.B -c
+to display block device names only and
+.B -cc
+for CSV column output of block device properties.
+See description of
+.B -c
+below for FIELD identifiers.
+
+.TP
+.I [-d|--debug]...
+Enable debugging output. Opion can be given multiple times
+increasing the debug output level.
+
+.TP
+.I [-c|--display_columns][FIELD[,FIELD...]]...
+Display properties of block devices, RAID sets and devices in column(s).
+Optional list specifying which FIELDs to display.
+.br
+For
+.B -b:
+.br
+d[evpath]|p[ath], sec[tors]|si[ze], ser[ialnumber].
+.br
+For
+.B -r:
+.br
+de[vpath]|p[ath], f[ormat], r[aidname], t[ype], st[atus], se[ctors]|si[ze], da[taoffset]|o[ffset].
+.br
+For
+.B -s:
+.br
+f[ormat], r[aidname], t[ype], sta[tus], str[ide], se[ctors]|si[ze], su[bsets], d[evices], sp[ares].
+.br
+.TP
+.I [-f|--format FORMAT[,FORMAT...]]
+Use metadata format handler(s) to discover RAID devices.
+See
+.B -l
+for a list of supported format handler names. This is useful to
+select particular formats in case multiple metadata signatures are found
+on a device. A comma seperated list of format names can be specified which 
+may not contain white space.
+
+.TP
+.I {-h|--help}
+Display help text.
+
+.TP
+.I {-i|--ignorelocking}
+Don't take out any locks. Useful in early boot where no read/write
+access to /var is available.
+
+.TP
+.I {-l|--list_formats}
+List all available metadata format handlers with their names and
+descriptions. Supported RAID levels are listed in parenthesis:
+.br
+
+S: Span (concatination)
+.br
+0: RAID0 (stripe)
+.br
+1: RAID1 (mirror)
+.br
+10: RAID10 (mirror on top of stripes)
 
+.br
+01: RAID10 (stripe on top of mirrors) Note: Intel OROM displays this as RAID10
+
+.TP
+.I {-n|--native_log} [device-path...]
+Display metadata in native, vendor-specific format.
+In case a metadata format handler is chosen with
+.B -f
+only RAID devices with such format will be displayed in native format.
+If device-path(s) is/are given on the command line, native metadata output
+is restricted to those listed.
+.TP
+.I [{-P|--partchar} CHAR]
+Use CHAR as the separator between the device name and the partition number.
+.TP
+.I {-R| --rebuild} RAID-set [device-path]
+Rebuild raid array after a drive has failed and a new drive is added. 
+For Intel chipset based systems, there are two methods in which a new drive 
+is added to the system.
+
+1. Using OROM to identify a new drive
+    During system reboot, enter OROM and mark the new drive as the rebuild drive.  
+    After booting to the OS, use the dmraid command to rebuild.
+
+    Example: dmraid -R raid_set 
+
+2. Using dmraid to identify a new drive
+    Boot to the OS and use the dmraid command with the new drive as
+the second parameter.
+
+    Example: dmraid -R raid_set /dev/sdc
+
+3. Using hot spare drive
+    Mark a drive as hot spare using the "dmraid -f isw -S" command. Then use the dmraid command to start the rebuild.
+
+    Example: dmraid -R raid_set
+
+.TP
+.I {-x|--remove} [RAID-set]
+Delete one or all existing software RAID devices from the metadata.
+
+.TP
+.I -f FORMAT-handler {-C|--create} --type raidlevel [--size=setsize --strip stripsize] --disk "device-path, device-path [,device-path]"
+Delete one or all existing Configure a software RAID device  and store the configuration data in a group of hard drive devices consisting of this array. This command requires the following options:
+
+-f FORMAT-handler
+.br
+	metadata format (see "dmraid -l")
+.br		
+--type digit[digit...]
+.br
+	specify the raid level of the software RAID set. 
+.br
+		0:  raid0
+.br
+		1:  raid1
+.br
+		5:  raid5
+.br
+		01: raid01 (isw raid10)
+.br
+--size: [digits[k|K|m|M|g|G][b|B]]
+.br
+	specify the size of the RAID set.The number is an integer followed by [kKmMgG] and/or [bB].
+.br
+		b: byte (default)
+.br
+		B: block (512 bytes)
+.br
+		K or K: on the base of 1024
+.br
+		m or M: on the base of 1024*1024
+.br
+		g or G: on the base of 1024*1024*1024
+.br
+If this option is missing, it's set to the default value pre-configured by the vendor. Note that different vendors may apply different constraints on the granularity of the size or the minimal value.
+.br
+--strip: [digits[k|K|m|M|g|G][b|B]]
+.br
+	specify the strip size of a RAID1, RAID5, and RAID10 RAID set (as above)
+.br
+--disk: device-path[{,| }device-path...]
+.br
+	specify the array of the hard drives, e.g. /dev/sda.
+
+.TP
+.I -f FORMAT-handler -S -M device-path
+.I -S -M device-path
+
+This command adds hot spare support for one or more RAID sets.
+
+1. When used with a format handler, which supports hot spare sets (e.g. isw), a hot spare is marked to be used when rebuilding any RAID set of that format.
+2. When used when specifying a RAID set, the drive is added to that RAID set and will be used only to rebuild that set. Note: If the specified name does not match an existing RAID-set, a set with the new name will be created.
+
+.TP
+.I {-r|--raid_devices} [device-path...]
+List all discovered RAID devices with format, RAID level, sectors used
+and data offset into the device.
+In case a metadata format handler is chosen with
+.B -f
+, only RAID devices with such format can be discovered. Useful if devices
+have multiple metadata signatures.
+If 
+.B -D
+is added to
+.B -r
+the RAID metadata gets dumped into a subdirectory named dmraid.format_name
+(eg. format_name = isw) in files named devicename.dat.
+The byte offset where the metadata is located on the device is written
+into files named devicename.offset and the size of the device in sectors
+into files named devicename.size.
+
+If 
+.B -E
+is added to
+.B -r
+the RAID metadata on the devices gets conditionally erased.
+Useful to erase old metadata after new one of different type has been
+stored on a device in order to avoid discovering both. If you enter
+.B -E
+option
+.B -D
+will be enforced in order to have a fallback in case the wrong metadata
+got erased.
+Manual copying back onto the device is needed to recover from erasing
+the wrong metadata using the dumped files devicename_formatname.dat
+and devicename_formatname.offset.
+Eg, to restore all *.dat files in the working directory to the respective devices:
+
+.br
+for f in *.dat
+.br
+do
+.br
+	dd if=$f of=/dev/${f%%.dat} \\
+.br
+	seek=`cat ${f%%dat}offset` bs=1
+.br
+done
+.br
+
+If device-path(s) is/are given on the command line, the above actions
+are restricted to those listed.
+Add
+.B -c
+to display RAID device names only and
+.B -cc
+for CSV column output of RAID device properties.
+See description of
+.B -c
+above for FIELD identifiers.
+
+.TP
+.I --separator SEPARATOR
+Use SEPARATOR as a delimiter for all options taking or displaying lists.
+
+.TP
+.I -s... [a|i] [RAID-set...]
+Display properties of RAID sets. Multiple RAID set names can be given
+on the command line which don't need to be fully specified (eg, "dmraid -s hpt"
+would display all discovered Highpoint RAID sets). Enter
+.B -s
+twice to display RAID subsets too.
+Add
+.B -c
+to display names of RAID sets only,
+.B -cc
+for CSV column output of RAID set properties and
+.B -ccc
+for inclusion of block devices in the listing. Doesn't imply
+.B -s -s
+to show RAID subsets (implied for group sets, e.g. isw).
+Add
+.B -g
+to include information about group RAID sets (as with Intel Software
+RAID) in the listing.
+See description of
+.B -c
+above for FIELD identifiers.
+Note: Size is given in sectors (not bytes).
+
+.TP
+.I [-v|--verbose]...
+Enable verbose runtime information output. Opion can be given multiple times
+increasing the verbosity level.
+
+.SH EXAMPLES
+"dmraid -l" lists all supported metadata formats with their names along with
+some descriptive information, eg:
+.br
+hpt37x : (+) Highpoint HPT37X
+.br
+hpt45x : (+) Highpoint HPT45X
+.br
+isw    : (+) Intel Software RAID
+.br
+lsi    : (0) LSI Logic MegaRAID
+.br
+nvidia : (+) NVidia RAID
+.br
+pdc    : (+) Promise FastTrack
+.br
+sil    : (+) Silicon Image(tm) Medley(tm)
+.br
+via    : (+) VIA Software RAID
+.br
+dos    : (+) DOS partitions on SW RAIDs
+.br
+(0): Discover, (+): Discover+Activate
+
+"dmraid -ay" activates all software RAID sets discovered.
+
+"dmraid -an" deactivates all active software RAID sets which are not open
+(eg, mounted filesystem on them).
+
+"dmraid -ay -f pdc" (pdc looked up from "dmraid -l") activates all
+software RAID sets with Promise format discovered and ignores all other
+supported formats.
+
+"dmraid -r" discovers all software RAID devices supported on your system, eg:
+.br
+/dev/dm-46: hpt45x, "hpt45x_chidjhaiaa-0", striped, ok, 320172928 sectors, data@ 0
+.br
+/dev/dm-50: hpt45x, "hpt45x_chidjhaiaa-0", striped, ok, 320172928 sectors, data@ 0
+.br
+/dev/dm-54: hpt45x, "hpt45x_chidjhaiaa-1", striped, ok, 320172928 sectors, data@ 0
+.br
+/dev/dm-58: hpt45x, "hpt45x_chidjhaiaa-1", striped, ok, 320172928 sectors, data@ 0
+
+
+"dmraid -s -s hpt45x_chidjhaiaa" displays properties of
+set "hpt45x_chidjhaiaa", eg:
+.br
+*** Superset
+.br
+name   : hpt45x_chidjhaiaa
+.br
+size   : 640345856
+.br
+stride : 128
+.br
+type   : raid10
+.br
+status : ok
+.br
+subsets: 2
+.br
+dev    : 4
+.br
+spare  : 0
+.br
+---> Subset
+.br
+name   : hpt45x_chidjhaiaa-0
+.br
+size   : 640345856
+.br
+stride : 128
+.br
+type   : stripe
+.br
+status : ok
+.br
+subsets: 0
+.br
+dev    : 2
+.br
+spare  : 0
+.br
+---> Subset
+.br
+name   : hpt45x_chidjhaiaa-1
+.br
+size   : 640345856
+.br
+stride : 128
+.br
+type   : stripe
+.br
+status : ok
+.br
+subsets: 0
+.br
+dev    : 2
+.br
+spare  : 0
+.br
+
+"dmraid -s -ccs hpt45" displays properties in column format of all sets
+and subsets with hpt45* format, eg:
+.br
+hpt45x_chidjhaiaa,640345856,128,raid10,ok,4,0
+.br
+hpt45x_chidjhaiaa-a,640345856,128,stripe,ok,2,0
+.br
+hpt45x_chidjhaiaa-b,640345856,128,stripe,ok,2,0
+
+"dmraid -r --sep : -cpath:size" display paths and sizes in sectors for
+RAID devices in column format using ':' as a delimiter, eg:
+.br
+/dev/dm-8:320173055
+.br
+/dev/dm-12:320173055
+.br
+/dev/dm-22:320173055
+.br
+/dev/dm-26:320173055
+.br
+/dev/dm-30:586114703
+.br
+/dev/dm-34:586114703
+.br
+/dev/dm-38:586114703
+.br
+/dev/dm-42:586114703
+.br
+/dev/dm-46:156301487
+.br
+/dev/dm-50:156301487
+.br
+/dev/dm-54:390624896
+.br
+/dev/dm-58:390624896
+.br
+/dev/dm-62:390624896
+.br
+/dev/dm-66:390624896
+
+"dmraid -f isw -C Raid0 --type 0 --strip 8k --size 20g --disk "/dev/sdb /dev/sdc"" creates an ISW volume with
+a name of "Raid0", 20Gig bytes in total, and 8kilo bytes strip size on two disks.
+
+"dmraid -f isw -C Test0 --type 0 --disk "/dev/sdd /dev/sde"" creates an ISW volume with the default size and strip size.
+
+"dmraid -f isw -C Test10 --type 01 --strip 128B --disk "/dev/sda /dev/sdb /dev/sdc /dev/sdd" creates a stacked
+RAID device, RAID10 (isw format), with a name of "Test10", 128 blocks (512bytes) strip size , and the default volume size on
+4 disks.
+
+"dmraid -f isw -S -M /dev/sde" marks the device /dev/sde as a hot spare for rebuild
+
+"dmraid -R isw_djaggchdde_RAID1 /dev/sde" starts rebuild of the RAID volume on device /dev/sde
+
+.SH DIAGNOSTICS
+dmraid returns an exit code of 0 for success or 1 for error.
+
+.SH AUTHOR
+Heinz Mauelshagen <Mauelshagen@RedHat.com>
--- dmraid/tools/VERSION	2008/04/02 13:35:32	1.5
+++ dmraid/tools/VERSION	2008/06/20 21:52:19	1.6
@@ -1 +1 @@
-1.0.0.rc15 (2008.04.02)
+1.0.0.rc15 (2008-06-20)
--- dmraid/tools/commands.c	2008/04/02 13:35:32	1.2
+++ dmraid/tools/commands.c	2008/06/20 21:52:19	1.3
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ *
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -21,18 +24,21 @@
 /* Action flags */
 enum action action = UNDEF;
 
+int add_dev_to_array(struct lib_context *lc, struct raid_set *rs,
+		     uint build_metadata, struct raid_dev *hot_spare_rd);
+
 /*
  * Command line options.
  */
 static char const *short_opts = "a:hipP:"
 #ifndef	DMRAID_MINI
-				"bc::dDEf:gl"
+	"bc::dDEf:glxM:"
 #ifdef	DMRAID_NATIVE_LOG
-				"n"
+	"n"
 #endif
-				"rs::tv"
+	"rR:s::tv"
 #endif
-				"V";
+	"VC:S::";
 
 #ifdef HAVE_GETOPTLONG
 static struct option long_opts[] = {
@@ -52,16 +58,21 @@
 	{"ignorelocking", no_argument, NULL, 'i'},
 # ifndef DMRAID_MINI
 	{"list_formats", no_argument, NULL, 'l'},
+	{"media", required_argument, NULL, 'M'},
 #  ifdef DMRAID_NATIVE_LOG
 	{"native_log", no_argument, NULL, 'n'},
 #  endif
 	{"raid_devices", no_argument, NULL, 'r'},
+	{"rebuild", required_argument, NULL, 'R'},
 	{"sets", optional_argument, NULL, 's'},
-	{"separator", required_argument, NULL, SEPARATOR}, /* long only. */
+	{"remove", no_argument, NULL, 'x'},
+	{"separator", required_argument, NULL, SEPARATOR},	/* long only. */
 	{"test", no_argument, NULL, 't'},
 	{"verbose", no_argument, NULL, 'v'},
 # endif
 	{"version", no_argument, NULL, 'V'},
+	{"create", required_argument, NULL, 'C'},
+	{"spare", optional_argument, NULL, 'S'},
 	{NULL, no_argument, NULL, 0}
 };
 #endif /* #ifdef HAVE_GETOPTLONG */
@@ -73,8 +84,8 @@
 };
 
 /* Check option argument. */
-static int check_optarg(struct lib_context *lc, const char option,
-			struct optarg_def *def)
+static int
+check_optarg(struct lib_context *lc, const char option, struct optarg_def *def)
 {
 	size_t len;
 	struct optarg_def *d;
@@ -91,16 +102,17 @@
 		}
 	}
 
-	LOG_ERR(lc, 0, "Invalid option argument for -%c", option);
+	LOG_ERR(lc, 0, "invalid option argument for -%c", option);
 }
 
 /* Check activate/deactivate option arguments. */
-static int check_activate(struct lib_context *lc, int arg)
+static int
+check_activate(struct lib_context *lc, int arg)
 {
 	struct optarg_def def[] = {
-		{ "yes", ACTIVATE },
-		{ "no",  DEACTIVATE },
-		{ NULL,  UNDEF },
+		{ "yes", ACTIVATE},
+		{ "no",  DEACTIVATE},
+		{ NULL,  UNDEF},
 	};
 
 	return check_optarg(lc, 'a', def);
@@ -108,21 +120,22 @@
 
 #ifndef	DMRAID_MINI
 /* Check active/inactive option arguments. */
-static int check_active(struct lib_context *lc, int arg)
+static int
+check_active(struct lib_context *lc, int arg)
 {
 	struct optarg_def def[] = {
-		{ "active",   ACTIVE },
-		{ "inactive", INACTIVE },
-		{ NULL,  UNDEF },
+		{ "active",   ACTIVE},
+		{ "inactive", INACTIVE},
+		{ NULL,       UNDEF},
 	};
 
 	lc_inc_opt(lc, LC_SETS);
-
 	return check_optarg(lc, 's', def);
 }
 
 /* Check and store option arguments. */
-static int check_identifiers(struct lib_context *lc, int o)
+static int
+check_identifiers(struct lib_context *lc, int o)
 {
 	if (optarg) {
 		const char delim = *OPT_STR_SEPARATOR(lc);
@@ -135,22 +148,48 @@
 	}
 
 	lc_inc_opt(lc, o);
-
 	return 1;
 }
 
 /* Check and store option argument/output field separator. */
-static int check_separator(struct lib_context *lc, int arg)
+static int
+check_separator(struct lib_context *lc, int arg)
 {
 	if (strlen(optarg) != 1)
-		LOG_ERR(lc, 0, "Invalid separator \"%s\"", optarg);
+		LOG_ERR(lc, 0, "invalid separator \"%s\"", optarg);
 
 	return lc_stralloc_opt(lc, LC_SEPARATOR, optarg) ? 1 : 0;
 }
+
+/* Check create option arguments. */
+static int
+check_create_argument(struct lib_context *lc, int arg)
+{
+	size_t len;
+
+	len = strlen(optarg);
+	if (len < 1)
+		LOG_ERR(lc, 0, "arguments missing");
+
+	if (*optarg == '-')
+		LOG_ERR(lc, 0, "the raid set name is missing");
+
+	lc_inc_opt(lc, arg);
+	return 1;
+}
+
+/* 'Check' spare option argument. */
+static int
+check_spare_argument(struct lib_context *lc, int arg)
+{
+	lc_inc_opt(lc, arg);
+	return 1;
+}
 #endif
 
 /* Check and store option for partition separator. */
-static int check_part_separator(struct lib_context *lc, int arg)
+static int
+check_part_separator(struct lib_context *lc, int arg)
 {
 	/* We're not actually checking that it's only one character... if
 	   somebody wants to use more, it shouldn't hurt anything. */
@@ -158,7 +197,8 @@
 }
 
 /* Display help information */
-static int help(struct lib_context *lc, int arg)
+static int
+help(struct lib_context *lc, int arg)
 {
 	char *c = lc->cmd;
 
@@ -169,21 +209,21 @@
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
 		  "\t[-P|--partchar CHAR]\n"
 		  "\t[-p|--no_partitions]\n"
-		  "\t[--separator SEPARATOR]\n"
-		  "\t[RAID-set...]\n", c);
+		  "\t[--separator SEPARATOR]\n" "\t[RAID-set...]\n", c);
 	log_print(lc, "%s\t{-h|--help}\n", c);
 	log_print(lc, "%s\t{-V/--version}\n", c);
 #else
 	log_print(lc, "%s: Device-Mapper Software RAID tool\n", c);
-	log_print(lc, "* = [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]\n");
-	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} *\n"
+	log_print(lc,
+		  "* = [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]\n");
+	log_print(lc,
+		  "%s\t{-a|--activate} {y|n|yes|no} *\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
-		  "\t[-P|--partchar CHAR]\n"
-		  "\t[-p|--no_partitions]\n"
-		  "\t[--separator SEPARATOR]\n"
-		  "\t[-t|--test]\n"
+		  "\t[-P|--partchar CHAR]\n" "\t[-p|--no_partitions]\n"
+		  "\t[--separator SEPARATOR]\n" "\t[-t|--test]\n"
 		  "\t[RAID-set...]\n", c);
-	log_print(lc, "%s\t{-b|--block_devices} *\n"
+	log_print(lc,
+		  "%s\t{-b|--block_devices} *\n"
 		  "\t[-c|--display_columns][FIELD[,FIELD...]]...\n"
 		  "\t[device-path...]\n", c);
 	log_print(lc, "%s\t{-h|--help}\n", c);
@@ -191,29 +231,34 @@
 #  ifdef	DMRAID_NATIVE_LOG
 	log_print(lc, "%s\t{-n|--native_log} *\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
-		  "\t[--separator SEPARATOR]\n"
-		  "\t[device-path...]\n", c);
+		  "\t[--separator SEPARATOR]\n" "\t[device-path...]\n", c);
 #  endif
 	log_print(lc, "%s\t{-r|--raid_devices} *\n"
 		  "\t[-c|--display_columns][FIELD[,FIELD...]]...\n"
 		  "\t[-D|--dump_metadata]\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
-		  "\t[--separator SEPARATOR]\n"
-		  "\t[device-path...]\n", c);
+		  "\t[--separator SEPARATOR]\n" "\t[device-path...]\n", c);
 	log_print(lc, "%s\t{-r|--raid_devices} *\n"
 		  "\t{-E|--erase_metadata}\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
-		  "\t[--separator SEPARATOR]\n"
-		  "\t[device-path...]\n", c);
+		  "\t[--separator SEPARATOR]\n" "\t[device-path...]\n", c);
 	log_print(lc, "%s\t{-s|--sets}...[a|i|active|inactive] *\n"
 		  "\t[-c|--display_columns][FIELD[,FIELD...]]...\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
 		  "\t[-g|--display_group]\n"
-		  "\t[--separator SEPARATOR]\n"
-		  "\t[RAID-set...]\n", c);
+		  "\t[--separator SEPARATOR]\n" "\t[RAID-set...]\n", c);
+	log_print(lc, "%s\t{-f|--format FORMAT}\n \t{-C|--create RAID-set} \n"
+		  "\t{--type RAID-level}\n"
+		  "\t[--size [0-9]...[kKgG][bB]]\n"
+		  "\t[--str[i[de]] [0-9]...[kK][bB]]\n"
+		  "\t{--disk[s] \"device-path[, device-path...\"}\n", c);
+	log_print(lc, "%s\t{-x|--remove RAID-set} \n");
+	log_print(lc, "%s\t{-R|--rebuild} RAID-set [drive_name]\n", c);
+	log_print(lc, "%s\t[{-f|--format FORMAT}]\n"
+		  "\t{-S|--spare [RAID-set]} \n"
+		  "\t{-M|--media \"device-path\"}\n", c);
 	log_print(lc, "%s\t{-V/--version}\n", c);
 #endif
-
 	return 1;
 }
 
@@ -225,247 +270,316 @@
  */
 static struct actions actions[] = {
 	/* [De]activate option. */
-	{ 'a',
-	  UNDEF, /* Set in check_activate() by mandatory option argument. */
-	  UNDEF,
-	  ACTIVATE|DEACTIVATE|FORMAT|HELP|IGNORELOCKING|NOPARTITIONS|SEPARATOR
+	{'a',
+	 UNDEF,			/* Set in check_activate() by mandatory option argument. */
+	 UNDEF,
+	 ACTIVATE | DEACTIVATE | FORMAT | HELP | IGNORELOCKING | NOPARTITIONS |
+	 SEPARATOR
 #ifndef DMRAID_MINI
-	  |DBG|TEST|VERBOSE
+	 | DBG | TEST | VERBOSE
 #endif
- 	  , ARGS,
-	  check_activate,
-	  0,
-	},
+	 , ARGS,
+	 check_activate,
+	 0,
+	 },
 
 	/* Format option. */
-	{ 'f',
-	  FORMAT,
-	  ACTIVATE|DEACTIVATE
+	{'f',
+	 FORMAT,
+	 ACTIVATE | DEACTIVATE
 #ifndef DMRAID_MINI
 #  ifdef DMRAID_NATIVE_LOG
-	  |NATIVE_LOG
+	 | NATIVE_LOG
 #  endif
-	  |RAID_DEVICES|RAID_SETS,
-	  ACTIVE|INACTIVE|COLUMN|DBG|DUMP|ERASE|GROUP|HELP|
-	  IGNORELOCKING|NOPARTITIONS|SEPARATOR|TEST|VERBOSE
+	 | RAID_DEVICES | RAID_SETS,
+	 ACTIVE | INACTIVE | COLUMN | DBG | DUMP | DMERASE | GROUP | HELP |
+	 IGNORELOCKING | NOPARTITIONS | SEPARATOR | TEST | VERBOSE
 #else
-	  , UNDEF
+	 , UNDEF
 #endif
-	  , ARGS,
+	 , ARGS,
 #ifndef DMRAID_MINI
-	  check_identifiers,
+	 check_identifiers,
 #else
-	  NULL,
+	 NULL,
 #endif
-	  LC_FORMAT,
-	},
+	 LC_FORMAT,
+	 },
 
 	/* Partition separator. */
-	{ 'P',
-	  PARTCHAR,
-	  ACTIVATE|DEACTIVATE,
-	  FORMAT|HELP|IGNORELOCKING|SEPARATOR
+	{'P',
+	 PARTCHAR,
+	 ACTIVATE | DEACTIVATE,
+	 FORMAT | HELP | IGNORELOCKING | SEPARATOR
 #ifndef DMRAID_MINI
-	  |DBG|TEST|VERBOSE
+	 | DBG | TEST | VERBOSE
 #endif
-	  , ARGS,
-	  check_part_separator,
-	  0,
-	},
+	 , ARGS,
+	 check_part_separator,
+	 0,
+	 },
 
 	/* Partition option. */
-	{ 'p',
-	  NOPARTITIONS,
-	  ACTIVATE|DEACTIVATE,
-	  FORMAT|HELP|IGNORELOCKING|SEPARATOR
+	{'p',
+	 NOPARTITIONS,
+	 ACTIVATE | DEACTIVATE,
+	 FORMAT | HELP | IGNORELOCKING | SEPARATOR
 #ifndef DMRAID_MINI
-	  |DBG|TEST|VERBOSE
+	 | DBG | TEST | VERBOSE
 #endif
-	  , ARGS,
-	  NULL,
-	  0,
-	},
+	 , ARGS,
+	 NULL,
+	 0,
+	 },
 
 #ifndef	DMRAID_MINI
 	/* Block devices option. */
-	{ 'b',
-	  BLOCK_DEVICES,
-	  UNDEF,
-	  COLUMN|DBG|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
-	  ARGS,
-	  lc_inc_opt,
-	  LC_DEVICES,
-	},
+	{'b',
+	 BLOCK_DEVICES,
+	 UNDEF,
+	 COLUMN | DBG | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
+	 ARGS,
+	 lc_inc_opt,
+	 LC_DEVICES,
+	 },
 
 	/* Columns display option. */
-	{ 'c',
-	  COLUMN,
-	  BLOCK_DEVICES|RAID_DEVICES|RAID_SETS,
-	  ACTIVE|INACTIVE|DBG|DUMP|FORMAT|GROUP|HELP|IGNORELOCKING
-	  |SEPARATOR|VERBOSE,
-	  ARGS,
-	  check_identifiers,
-	  LC_COLUMN,
-	},
+	{'c',
+	 COLUMN,
+	 BLOCK_DEVICES | RAID_DEVICES | RAID_SETS,
+	 ACTIVE | INACTIVE | DBG | DUMP | FORMAT | GROUP | HELP | IGNORELOCKING
+	 | SEPARATOR | VERBOSE,
+	 ARGS,
+	 check_identifiers,
+	 LC_COLUMN,
+	 },
 
 	/* Debug option. */
-	{ 'd',
-	  DBG,
-	  ALL_FLAGS,
-	  ALL_FLAGS,
-	  ARGS,
-	  lc_inc_opt,
-	  LC_DEBUG,
-	},
+	{'d',
+	 DBG,
+	 ALL_FLAGS,
+	 ALL_FLAGS,
+	 ARGS,
+	 lc_inc_opt,
+	 LC_DEBUG,
+	 },
 
 	/* Dump metadata option. */
-	{ 'D',
-	  DUMP,
-	  RAID_DEVICES,
-	  COLUMN|DBG|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
-	  ARGS,
-	  lc_inc_opt,
-	  LC_DUMP,
-	},
+	{'D',
+	 DUMP,
+	 RAID_DEVICES,
+	 COLUMN | DBG | FORMAT | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
+	 ARGS,
+	 lc_inc_opt,
+	 LC_DUMP,
+	 },
 
 	/* Erase metadata option. */
-	{ 'E',
-	  ERASE,
-	  RAID_DEVICES,
-	  COLUMN|DBG|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
-	  ARGS,
-	  NULL,
-	  0,
-	},
+	{'E',
+	 DMERASE,
+	 RAID_DEVICES,
+	 COLUMN | DBG | FORMAT | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
+	 ARGS,
+	 NULL,
+	 0,
+	 },
 
 	/* RAID groups option. */
-	{ 'g',
-	  GROUP,
-	  RAID_SETS,
-	  ACTIVE|INACTIVE|DBG|COLUMN|FORMAT|HELP|IGNORELOCKING
-	  |SEPARATOR|VERBOSE,
-	  ARGS,
-	  lc_inc_opt,
-	  LC_GROUP,
-	},
+	{'g',
+	 GROUP,
+	 RAID_SETS,
+	 ACTIVE | INACTIVE | DBG | COLUMN | FORMAT | HELP | IGNORELOCKING
+	 | SEPARATOR | VERBOSE,
+	 ARGS,
+	 lc_inc_opt,
+	 LC_GROUP,
+	 },
 
 #endif
 	/* Help option. */
-	{ 'h',
-	  HELP,
-	  UNDEF,
-	  ALL_FLAGS,
-	  ARGS,
-	  help,
-	  0, 
-	},
+	{'h',
+	 HELP,
+	 UNDEF,
+	 ALL_FLAGS,
+	 ARGS,
+	 help,
+	 0,
+	 },
 
 	/* ignorelocking option. */
-	{ 'i',
-	  IGNORELOCKING,
-	  UNDEF,
-	  ALL_FLAGS,
-	  ARGS,
-	  lc_inc_opt,
-	  LC_IGNORELOCKING,
-	},
+	{'i',
+	 IGNORELOCKING,
+	 UNDEF,
+	 ALL_FLAGS,
+	 ARGS,
+	 lc_inc_opt,
+	 LC_IGNORELOCKING,
+	 },
 
 #ifndef	DMRAID_MINI
 	/* List metadata format handlers option. */
-	{ 'l',
-	  LIST_FORMATS,
-	  UNDEF,
-	  DBG|HELP|IGNORELOCKING|VERBOSE,
-	  NO_ARGS,
-	  NULL,
-	  0,
-	},
+	{'l',
+	 LIST_FORMATS,
+	 UNDEF,
+	 DBG | HELP | IGNORELOCKING | VERBOSE,
+	 NO_ARGS,
+	 NULL,
+	 0,
+	 },
+
+	/* Delete a RAID set option. */
+	{'x',
+	 DEL_SETS,
+	 UNDEF,			//RAID_SETS,
+	 RAID_SETS | INACTIVE | COLUMN | DBG | FORMAT | GROUP | HELP |
+	 IGNORELOCKING | SEPARATOR | VERBOSE,
+	 ARGS,
+	 NULL,
+	 0,
+	 },
 
 #  ifdef DMRAID_NATIVE_LOG
 	/* Native log option. */
-	{ 'n',
-	  NATIVE_LOG,
-	  UNDEF,
-	  DBG|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
-	  ARGS,
-	  NULL,
-	  0,
-	},
+	{'n',
+	 NATIVE_LOG,
+	 UNDEF,
+	 DBG | FORMAT | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
+	 ARGS,
+	 NULL,
+	 0,
+	 },
 
 #  endif
 	/* Display RAID devices option. */
-	{ 'r',
-	  RAID_DEVICES,
-	  UNDEF,
-	  COLUMN|DBG|DUMP|ERASE|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
-	  ARGS,
-	  NULL,
-	  0,
-	},
+	{'r',
+	 RAID_DEVICES,
+	 UNDEF,
+	 COLUMN | DBG | DUMP | DMERASE | FORMAT | HELP | IGNORELOCKING |
+	 SEPARATOR | VERBOSE,
+	 ARGS,
+	 NULL,
+	 0,
+	 },
+
+	/* rebuild option */
+	{'R',
+	 REBUILD,
+	 UNDEF,
+#ifdef DMRAID_MINI
+	 HELP, IGNORELOCKING,
+#else
+	 DBG | HELP | IGNORELOCKING | VERBOSE,
+#endif
+	 ARGS,
+#ifndef DMRAID_MINI
+	 check_identifiers,
+#else
+	 NULL,
+#endif
+	 LC_REBUILD_SET,
+	 },
+
+	/* Media/drive option */
+	{'M',
+	 MEDIA,
+	 UNDEF,
+#ifdef DMRAID_MINI
+	 HELP, IGNORELOCKING,
+#else
+	 DBG | HELP | IGNORELOCKING | VERBOSE | REBUILD,
+#endif
+	 ARGS,
+#ifndef DMRAID_MINI
+	 check_identifiers,
+#else
+	 NULL,
+#endif
+	 LC_REBUILD_DISK,
+	 },
 
 	/* Display RAID sets option. */
-	{ 's',
-	  RAID_SETS,
-	  UNDEF,
-	  ACTIVE|INACTIVE|COLUMN|DBG|FORMAT|GROUP|HELP|IGNORELOCKING
-	  |SEPARATOR|VERBOSE,
-	  ARGS,
-	  check_active,
-	  0,
-	},
+	{'s',
+	 RAID_SETS,
+	 UNDEF,
+	 ACTIVE | INACTIVE | COLUMN | DBG | FORMAT | GROUP | HELP |
+	 IGNORELOCKING | DEL_SETS | SEPARATOR | VERBOSE,
+	 ARGS,
+	 check_active,
+	 0,
+	 },
 
 	/* Display RAID sets option. */
-	{ SEPARATOR,
-	  SEPARATOR,
-	  COLUMN|FORMAT,
-	  ALL_FLAGS,
-	  ARGS,
-	  check_separator,
-	  0,
-	},
+	{SEPARATOR,
+	 SEPARATOR,
+	 COLUMN | FORMAT,
+	 ALL_FLAGS,
+	 ARGS,
+	 check_separator,
+	 0,
+	 },
 
 
 	/* Test run option. */
-	{ 't',
-	  TEST,
-	  ACTIVATE|DEACTIVATE,
-	  ACTIVATE|DEACTIVATE|DBG|FORMAT|HELP|IGNORELOCKING|
-	  NOPARTITIONS|VERBOSE,
-	  ARGS,
-	  lc_inc_opt,
-	  LC_TEST,
-	},
+	{'t',
+	 TEST,
+	 ACTIVATE | DEACTIVATE,
+	 ACTIVATE | DEACTIVATE | DBG | FORMAT | HELP | IGNORELOCKING |
+	 NOPARTITIONS | VERBOSE,
+	 ARGS,
+	 lc_inc_opt,
+	 LC_TEST,
+	 },
 
 	/* Verbose option. */
-	{ 'v',
-	  VERBOSE,
-	  ALL_FLAGS,
-	  ALL_FLAGS,
-	  ARGS,
-	  lc_inc_opt,
-	  LC_VERBOSE,
-	},
+	{'v',
+	 VERBOSE,
+	 ALL_FLAGS,
+	 ALL_FLAGS,
+	 ARGS,
+	 lc_inc_opt,
+	 LC_VERBOSE,
+	 },
 #endif /* #ifndef DMRAID_MINI */
 
 	/* Version option. */
-	{ 'V',
-	  VERSION,
-	  UNDEF,
+	{'V',
+	 VERSION,
+	 UNDEF,
 #ifdef DMRAID_MINI
-	  HELP,IGNORELOCKING,
+	 HELP, IGNORELOCKING,
 #else
-	  DBG|HELP|IGNORELOCKING|VERBOSE,
+	 DBG | HELP | IGNORELOCKING | VERBOSE,
 #endif
-	  NO_ARGS,
-	  NULL,
-	  0,
-	},
+	 NO_ARGS,
+	 NULL,
+	 0,
+	 },
+
+	/* RAID set creation. */
+	{'C',
+	 CREATE,
+	 UNDEF,
+	 DBG | HELP | IGNORELOCKING | VERBOSE,
+	 NO_ARGS,
+	 check_create_argument,
+	 LC_CREATE,
+	 },
+	/* Spare disk creation. */
+	{'S',
+	 SPARE,
+	 UNDEF,
+	 DBG | HELP | IGNORELOCKING | VERBOSE,
+	 NO_ARGS,
+	 check_spare_argument,
+	 LC_HOT_SPARE_SET,
+	 },
 };
 
 /*
  * Set action flag and call optional function.
  */
-static int set_action(struct lib_context *lc, int o)
+static int
+set_action(struct lib_context *lc, int o)
 {
 	struct actions *a;
 
@@ -474,6 +588,7 @@
 			action |= a->action;	/* Set action flag. */
 			a->allowed |= a->action;/* Merge to allowed flags. */
 			a->allowed |= a->needed;
+
 			if (a->f_set)	/* Optionally call function. */
 				return a->f_set(lc, a->arg);
 
@@ -485,38 +600,37 @@
 }
 
 /* Check for invalid option combinations */
-static int check_actions(struct lib_context *lc, char **argv)
+static int
+check_actions(struct lib_context *lc, char **argv)
 {
 	struct actions *a;
 
 	for (a = actions; a < ARRAY_END(actions); a++) {
 		if (a->action & action) {
-			if (a->needed != UNDEF &&
-			    !(a->needed & action))
+			if (a->needed != UNDEF && !(a->needed & action))
 				LOG_ERR(lc, 0,
 					"option missing/invalid option "
-					"combination with -%c",
-					a->option);
+					"combination with -%c", a->option);
 
 			if (~a->allowed & action)
-				LOG_ERR(lc, 0, "Invalid option combination"
-					   " (-h for help)");
+				LOG_ERR(lc, 0, "invalid option combination"
+					" (-h for help)");
 
 			if (a->args == NO_ARGS && argv[optind])
 				LOG_ERR(lc, 0,
-					"No arguments allowed with -%c\n",
+					"no arguments allowed with -%c\n",
 					a->option);
 		}
 	}
 
 	if (!action)
-		LOG_ERR(lc, 0, "Options missing\n");
+		LOG_ERR(lc, 0, "options missing\n");
 
 #ifndef DMRAID_MINI
-	if ((action & (DBG|VERBOSE)) == action)
-		LOG_ERR(lc, 0, "More options needed with -d/-v");
+	if ((action & (DBG | VERBOSE)) == action)
+		LOG_ERR(lc, 0, "more options needed with -d/-v");
 
-	if (action & ERASE) {
+	if (action & DMERASE) {
 		action |= DUMP;
 		lc_inc_opt(lc, LC_DUMP);
 	}
@@ -526,16 +640,42 @@
 }
 
 /* Check for invalid option argumengts. */
-static int check_actions_arguments(struct lib_context *lc)
+static int
+check_actions_arguments(struct lib_context *lc)
 {
 	if (valid_format(lc, OPT_STR_FORMAT(lc)))
 		return 1;
 
-	LOG_ERR(lc, 0, "Invalid format for -f at (see -l)");
+	LOG_ERR(lc, 0, "invalid format for -f at (see -l)");
 }
 
+int
+save_drive_name(struct lib_context *lc, char *drive)
+{
+	lc->options[LC_REBUILD_DISK].opt++;
+	return lc_strcat_opt(lc, LC_REBUILD_DISK, drive, ',') ? 1 : 0;
+}
+
+static int
+save_spare_name(struct lib_context *lc, char **argv)
+{
+	char *p = argv[optind];
+
+	lc->options[LC_HOT_SPARE_SET].arg.str = NULL;
+
+	if (p && strlen(p) && *p != '-') {
+		lc->options[LC_HOT_SPARE_SET].arg.str = dbg_strdup(p);
+		if (!lc->options[LC_HOT_SPARE_SET].arg.str)
+			return log_alloc_err(lc, __func__);
+	}
+
+	return 1;
+}
+
+
 /* Parse and handle the command line arguments */
-int handle_args(struct lib_context *lc, int argc, char ***argv)
+int
+handle_args(struct lib_context *lc, int argc, char ***argv)
 {
 	int o, ret = 0;
 #ifdef HAVE_GETOPTLONG
@@ -543,7 +683,7 @@
 #endif
 
 	if (argc < 2)
-		LOG_ERR(lc, 0, "No arguments/options given (-h for help)\n");
+		LOG_ERR(lc, 0, "no arguments/options given (-h for help)\n");
 
 #ifdef HAVE_GETOPTLONG
 	/* Walk the options (and option arguments) */
@@ -556,6 +696,29 @@
 		if ((ret = set_action(lc, o)) && (HELP & action))
 			return 1;
 
+		/* Handle arguments for option -S */
+		if (o == 'S') {
+			if (!save_spare_name(lc, *argv))
+				return 0;
+		}
+
+		/* to create spare disk/set */
+		if (o == 'M' &&
+		    OPT_HOT_SPARE_SET(lc) &&
+		    OPT_REBUILD_DISK(lc)) {
+			*argv += optind - 3;
+			return 1;
+		}
+
+		/* To create a new RAID set; arguments are handled later */
+		if (o == 'C') {
+			*argv += optind - 1;
+			return 1;
+		} else if (o == 'R' && argc == 4) {
+			if (*(*argv + optind))
+				save_drive_name(lc, *(*argv + optind));
+		}
+
 		if (!ret || o == ':' || o == '?')
 			return 0;
 	}
@@ -569,107 +732,103 @@
 		ret = check_actions_arguments(lc);
 
 	*argv += optind;
+	if (argc == 4 && lc->options[LC_REBUILD_SET].opt)
+		*argv += 1;
 
 	return ret;
 }
 
-static int version(struct lib_context *lc, int arg)
+static int
+version(struct lib_context *lc, int arg)
 {
 	char v[80];
 
 	dm_version(lc, v, sizeof(v));
 	log_print(lc, "%s version:\t\t%s\n"
-		      "%s library version:\t%s %s\n"
-		      "device-mapper version:\t%s",
-		      lc->cmd, DMRAID_VERSION,
-		      lc->cmd, libdmraid_version(lc), libdmraid_date(lc), v);
+		  "%s library version:\t%s %s\n"
+		  "device-mapper version:\t%s",
+		  lc->cmd, DMRAID_VERSION,
+		  lc->cmd, libdmraid_version(lc), libdmraid_date(lc), v);
 
 	return 1;
 }
 
+static int
+rebuild(struct lib_context *lc, int arg)
+{
+	return rebuild_raidset(lc,
+			       (char *) lc->options[LC_REBUILD_SET].arg.str);
+}
+
 /*********************************************************************
  * Perform pre/post functions for requested actions.
  */
 /* Post Activate/Deactivate RAID set. */
 #ifndef DMRAID_MINI
 /* Pre and post display_set() functions. */
-static int _display_sets_arg(int arg)
+static int
+_display_sets_arg(int arg)
 {
 	return (action & ACTIVE) ?
-	       D_ACTIVE : ((action & INACTIVE) ? D_INACTIVE : D_ALL);
+		D_ACTIVE : ((action & INACTIVE) ? D_INACTIVE : D_ALL);
 }
 
-static int _display_set(struct lib_context *lc, void *rs, int type)
+static int
+_display_set(struct lib_context *lc, void *rs, int type)
 {
 	display_set(lc, rs, type, 0);
-
 	return 1;
 }
 
-static int _display_sets(struct lib_context *lc, int type)
+static int
+_display_sets(struct lib_context *lc, int type)
 {
 	process_sets(lc, _display_set, type, SETS);
+	return 1;
+}
 
+static int
+_delete_sets(struct lib_context *lc, int arg)
+{
+	delete_raidsets(lc);
 	return 1;
 }
 
-static int _display_devices(struct lib_context *lc, int type)
+static int
+_create_sets(struct lib_context *lc, int arg)
 {
-	display_devices(lc, type);
+	return 1;
+}
 
+static int
+_display_devices(struct lib_context *lc, int type)
+{
+	display_devices(lc, type);
 	return 1;
 }
 
-static int _erase(struct lib_context *lc, int arg)
+static int
+_erase(struct lib_context *lc, int arg)
 {
 	return erase_metadata(lc);
 }
-#endif
 
-/* Retrieve and build metadata. */
-static int get_metadata(struct lib_context *lc, struct prepost *p, char **argv)
+/* Post hot_spare_add function */
+static int
+_hot_spare_add_set(struct lib_context *lc, void *r, int type)
 {
-	if (!(M_DEVICE & p->metadata))
-		return 1;
-
-	if (!discover_devices(lc, OPT_DEVICES(lc) ? argv : NULL))
-		LOG_ERR(lc, 0, "failed to discover devices");
-
-	if(!count_devices(lc, DEVICE)) {
-		log_print(lc, "no block devices found");
-		return 1;
-	}
+	return hot_spare_add(lc, (struct raid_set*) r);
+}
 
-	if (!(M_RAID & p->metadata))
-		return 1;
+static int
+_hot_spare_add(struct lib_context *lc, int type)
+{
+	process_sets(lc, _hot_spare_add_set, type, SETS);
+	return 1;
+}
 
-#ifndef	DMRAID_MINI
-	/* Discover RAID disks and keep RAID metadata (eg, hpt45x) */
-	discover_raid_devices(lc, 
-# ifdef	DMRAID_NATIVE_LOG
-		    ((NATIVE_LOG|RAID_DEVICES) & action) ? argv : NULL);
-# else
-		    (RAID_DEVICES & action) ? argv : NULL);
-# endif
-#else
-	discover_raid_devices(lc, NULL);
 #endif
-	if (!count_devices(lc, RAID)) {
-		format_error(lc, "disks", argv);
-		return 1;
-	}
 
-	if (M_SET & p->metadata) {
-		/* Group RAID sets. */
-		build_sets(lc, argv);
-		if (!count_devices(lc, SET)) {
-			format_error(lc, "sets", argv);
-			return 0;
-		}
-	}
-
-	return 1;
-}
 
 /*
  * Function abstraction which takes pre- and post-function calls
@@ -692,112 +851,136 @@
  */
 struct prepost prepost[] = {
 	/* (De)activate RAID set. */
-	{ ACTIVATE|DEACTIVATE,
-	  M_DEVICE|M_RAID|M_SET,
-	  ROOT,
-	  LOCK,
-	  NULL,
-	  0,
-	  activate_or_deactivate_sets,
-	},
+	{ACTIVATE | DEACTIVATE,
+	 M_DEVICE | M_RAID | M_SET,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 0,
+	 activate_or_deactivate_sets,
+	 },
 
 #ifndef DMRAID_MINI
 	/* Display block devices. */
-	{ BLOCK_DEVICES,
-	  M_DEVICE,
-	  ROOT,
-	  NO_LOCK,
-	  NULL,
-	  DEVICE,
-	  _display_devices,
-	},
+	{BLOCK_DEVICES,
+	 M_DEVICE,
+	 ROOT,
+	 NO_LOCK,
+	 NULL,
+	 DEVICE,
+	 _display_devices,
+	 },
 
 	/* Erase metadata. */
-	{ ERASE,
-	  M_DEVICE|M_RAID, 
-	  ROOT,
-	  LOCK,
-	  NULL,
-	  0,
-	  _erase,
-	},
+	{DMERASE,
+	 M_DEVICE | M_RAID,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 0,
+	 _erase,
+	 },
 
 	/* List metadata format handlers. */
-	{ LIST_FORMATS,
-	  M_NONE, 
-	  ANY_ID,
-	  NO_LOCK,
-	  NULL,
-	  0,
-	  list_formats,
-	},
+	{LIST_FORMATS,
+	 M_NONE,
+	 ANY_ID,
+	 NO_LOCK,
+	 NULL,
+	 0,
+	 list_formats,
+	 },
 
 #  ifdef DMRAID_NATIVE_LOG
 	/* Native metadata log. */
-	{ NATIVE_LOG,
-	  M_DEVICE|M_RAID, 
-	  ROOT,
-	  LOCK,
-	  NULL,
-	  NATIVE,
-	  _display_devices,
-	},
+	{NATIVE_LOG,
+	 M_DEVICE | M_RAID,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 NATIVE,
+	 _display_devices,
+	 },
 #  endif
 
 	/* Display RAID devices. */
-	{ RAID_DEVICES,
-	  M_DEVICE|M_RAID,
-	  ROOT,
-	  LOCK,
-	  NULL,
-	  RAID,
-	  _display_devices,
-	},
+	{RAID_DEVICES,
+	 M_DEVICE | M_RAID,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 RAID,
+	 _display_devices,
+	 },
+
+	/* Delete RAID sets. */
+	{DEL_SETS,
+	 M_DEVICE | M_RAID | M_SET,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 0,
+	 _delete_sets,
+	 },
 
 	/* Display RAID sets. */
-	{ RAID_SETS,
-	  M_DEVICE|M_RAID|M_SET,
-	  ROOT,
-	  LOCK,
-	  _display_sets_arg,
-	  0,
-	  _display_sets,
-	},
+	{RAID_SETS,
+	 M_DEVICE | M_RAID | M_SET,
+	 ROOT,
+	 LOCK,
+	 _display_sets_arg,
+	 0,
+	 _display_sets,
+	 },
+
 #endif
 
 	/* Display version. */
-	{ VERSION,
-	  M_NONE,
-	  ANY_ID,
-	  NO_LOCK,
-	  NULL,
-	  0,
-	  version,
-	},
-};
+	{VERSION,
+	 M_NONE,
+	 ANY_ID,
+	 NO_LOCK,
+	 NULL,
+	 0,
+	 version,
+	 },
+
+	/* Create a RAID set. */
+	{CREATE,
+	 M_DEVICE | M_RAID | M_SET,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 0,
+	 _create_sets,
+	 },
+
+	/* Add spare disk to a RAID set. */
+	{SPARE,
+	 M_DEVICE | M_RAID | M_SET,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 0,
+	 _hot_spare_add,
+	 },
+
+
+	/* Rebuild */
+	{REBUILD,
+	 M_DEVICE | M_RAID | M_SET,
+	 ROOT,
+	 LOCK,
+	 NULL,
+	 0,
+	 rebuild,
+	 },
 
-static int _perform(struct lib_context *lc, struct prepost *p,
-		    char **argv)
-{
-	int ret = 0;
-
-	if (ROOT == p->id && geteuid())
-		LOG_ERR(lc, 0, "you must be root");
-	
-	/* Lock against parallel runs. Resource NULL for now. */
-	if (LOCK == p->lock && !lock_resource(lc, NULL))
-		LOG_ERR(lc, 0, "lock failure");
-	
-	if (get_metadata(lc, p, argv))
-		ret = p->post(lc, p->pre ? p->pre(p->arg) : p->arg);
-	
-	if (LOCK == p->lock)
-		unlock_resource(lc, NULL);
-	
-	return ret;
-}
+};
 
-int perform(struct lib_context *lc, char **argv)
+/* Perform pre/post actions for options. */
+int
+perform(struct lib_context *lc, char **argv)
 {
 	struct prepost *p;
 
@@ -808,7 +991,8 @@
 	/* Find appropriate action. */
 	for (p = prepost; p < ARRAY_END(prepost); p++) {
 		if (p->action & action)
-			return _perform(lc, p, argv);
+			return lib_perform(lc, action, p, argv);
+
 	}
 
 	return 0;
--- dmraid/tools/commands.h	2008/04/02 13:35:32	1.2
+++ dmraid/tools/commands.h	2008/06/20 21:52:19	1.3
@@ -2,6 +2,9 @@
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ * 
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -13,50 +16,8 @@
 #define ARRAY_SIZE(a)	(sizeof(a) / sizeof(*a))
 #define ARRAY_END(a)	(a + ARRAY_SIZE(a))
 
-/* Options actions dmraid performs. */
-enum action {
-	UNDEF		= 0x0,
-	ACTIVATE	= 0x1,
-	DEACTIVATE	= 0x2,
-	FORMAT		= 0x4,
-#ifndef	DMRAID_MINI
-	BLOCK_DEVICES	= 0x8,
-	COLUMN		= 0x10,
-	DBG		= 0x20,
-	DUMP		= 0x40,
-	ERASE		= 0x80,
-	GROUP		= 0x100,
-#endif
-	HELP		= 0x200,
-#ifndef	DMRAID_MINI
-	LIST_FORMATS	= 0x400,
-#  ifdef	DMRAID_NATIVE_LOG
-	NATIVE_LOG	= 0x800,
-#  endif
-#endif
-	NOPARTITIONS	= 0x1000,
-#ifndef	DMRAID_MINI
-	RAID_DEVICES	= 0x2000,
-	RAID_SETS	= 0x4000,
-	TEST		= 0x8000,
-	VERBOSE		= 0x10000,
-	ACTIVE		= 0x20000,
-	INACTIVE	= 0x40000,
-	SEPARATOR	= 0x80000,
-#endif
-	VERSION		= 0x100000,
-	IGNORELOCKING	= 0x200000,
-	PARTCHAR	= 0x400000,
-};
-
 #define	ALL_FLAGS	((enum action) -1)
 
-/* Arguments allowed ? */
-enum args {
-	NO_ARGS,
-	ARGS,
-};
-
 /*
  * Action flag definitions for set_action().
  *
@@ -72,41 +33,10 @@
 	enum args args;		/* Arguments allowed ? */
 
 	/* Function to call on hit or NULL */
-	int (*f_set)(struct lib_context *lc, int arg);
+	int (*f_set) (struct lib_context * lc, int arg);
 	int arg;		/* Argument for above function call */
 };
 
-/* Define which metadata is needed before we can call post functions. */
-enum metadata_need {
-	M_NONE	 = 0x00,
-	M_DEVICE = 0x01,
-	M_RAID	 = 0x02,
-	M_SET	 = 0x04,
-};
-
-enum id {
-	ROOT,
-	ANY_ID,
-};
-
-enum lock {
-	LOCK,
-	NO_LOCK,
-};
-
-/* 
- * Pre and Post functions to perform for an option.
- */
-struct prepost {
-	enum action action;
-	enum metadata_need metadata;
-	enum id id;
-	enum lock lock;
-	int (*pre)(int arg);
-	int arg;
-	int (*post)(struct lib_context *lc, int arg);
-};
-
 int handle_args(struct lib_context *lc, int argc, char ***argv);
 int perform(struct lib_context *lc, char **argv);
 
--- dmraid/tools/dmraid.c	2008/02/22 16:57:37	1.1
+++ dmraid/tools/dmraid.c	2008/06/20 21:52:19	1.2
@@ -14,7 +14,8 @@
 #include "toollib.h"
 #include "version.h"
 
-int main(int argc, char **argv)
+int
+main(int argc, char **argv)
 {
 	int ret = 0;
 	struct lib_context *lc;
@@ -32,13 +33,12 @@
 		 * If both are ok -> perform the required action.
 		 */
 		ret = handle_args(lc, argc, &argv) &&
-		      init_locking(lc) &&
-		      perform(lc, argv);
+			init_locking(lc) && perform(lc, argv);
 
 		/* Cleanup the library context. */
 		libdmraid_exit(lc);
 	}
 
 	/* Set standard exit code. */
-	exit (ret ? EXIT_SUCCESS : EXIT_FAILURE);
+	exit(ret ? EXIT_SUCCESS : EXIT_FAILURE);
 }
--- dmraid/tools/toollib.c	2008/02/22 16:57:37	1.1
+++ dmraid/tools/toollib.c	2008/06/20 21:52:19	1.2
@@ -1,7 +1,10 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
+ * Copyright (C) 2007   Intel Corporation. All rights reserved.
+ * November, 2007 - additions for Create, Delete, Rebuild & Raid 10. 
+ *
  * See file LICENSE at the top of this source tree for license information.
  */
 
@@ -23,13 +26,13 @@
 #include "toollib.h"
 
 /* [De]activate a RAID set. */
-static int _change_set(struct lib_context *lc, void *rs, int arg)
+static int
+_change_set(struct lib_context *lc, void *rs, int arg)
 {
-	if (change_set(lc,
-		       (ACTIVATE & action) ? A_ACTIVATE : A_DEACTIVATE,
+	if (change_set(lc, (ACTIVATE & action) ? A_ACTIVATE : A_DEACTIVATE,
 		       rs)) {
-		log_info(lc, "%sctivating %s RAID set \"%s\"",
-			 action & ACTIVATE ? "A": "Dea",
+		log_info(lc, "%sctivating %s raid set \"%s\"",
+			 action & ACTIVATE ? "A" : "Dea",
 			 get_set_type(lc, rs), get_set_name(lc, rs));
 		return 1;
 	}
@@ -39,13 +42,15 @@
 
 /* [De]activate RAID sets. */
 /* FIXME: remove partition code in favour of kpartx ? */
-static void process_partitions(struct lib_context *lc)
+static void
+process_partitions(struct lib_context *lc)
 {
 	discover_partitions(lc);
 	process_sets(lc, _change_set, 0, PARTITIONS);
 }
 
-int activate_or_deactivate_sets(struct lib_context *lc, int arg)
+int
+activate_or_deactivate_sets(struct lib_context *lc, int arg)
 {
 	/* Discover partitions to deactivate RAID sets for and work on them. */
 	if (DEACTIVATE & action)
@@ -61,21 +66,15 @@
 }
 
 /* Build all sets or the ones given. */
-void build_sets(struct lib_context *lc, char **sets)
+void
+build_sets(struct lib_context *lc, char **sets)
 {
-	int o = 0;
-
-	do {
-		if (!group_set(lc, sets[o]))
-			log_err(lc, "building set");
-
-		if (!sets[o])
-			break;
-	} while (sets[++o]);
+	group_set(lc, sets);
 }
 
 /* Convert a character string to lower case. */
-void str_tolower(char *s)
+void
+str_tolower(char *s)
 {
 	for (; *s; s++)
 		*s = tolower(*s);
@@ -85,8 +84,9 @@
  * Check if selected or all formats shall be used to read the metadata.
 */
 /* Collapse a delimiter into one. */
-char *collapse_delimiter(struct lib_context *lc, char *str,
-			 size_t size, const char delim)
+char *
+collapse_delimiter(struct lib_context *lc, char *str,
+		   size_t size, const char delim)
 {
 	size_t len;
 	char *p = str;
@@ -101,13 +101,14 @@
 	return str;
 }
 
-int valid_format(struct lib_context *lc, const char *fmt)
+int
+valid_format(struct lib_context *lc, const char *fmt)
 {
 	int ret = 1;
 	char *p, *p_sav, *sep;
 	const char delim = *OPT_STR_SEPARATOR(lc);
 
- 	if (!(p_sav = dbg_strdup((char*) fmt)))
+	if (!(p_sav = dbg_strdup((char *) fmt)))
 		return log_alloc_err(lc, __func__);
 
 	sep = p_sav;
@@ -122,29 +123,5 @@
 	} while (sep);
 
 	dbg_free(p_sav);
-
 	return ret;
 }
-
-void format_error(struct lib_context *lc, const char *error, char **argv)
-{
-	log_print_nnl(lc, "No RAID %s", error);
-
-	if (OPT_FORMAT(lc))
-		log_print_nnl(lc, " with format: \"%s\"",
-			      OPT_STR_FORMAT(lc));
-
-
-	if (argv && *argv) {
-		log_print_nnl(lc, " and with names: \"");
-		while (*argv) {
-			log_print_nnl(lc, "%s", *argv++);
-			if (*argv)
-				log_print_nnl(lc, "%s", OPT_STR_SEPARATOR(lc));
-			else
-				log_print_nnl(lc, "\"");
-		}
-	}
-
-	log_print(lc, "");
-}
--- dmraid/tools/toollib.h	2008/02/22 16:57:37	1.1
+++ dmraid/tools/toollib.h	2008/06/20 21:52:19	1.2
@@ -10,12 +10,12 @@
 
 extern enum action action;
 
-int  activate_or_deactivate_sets(struct lib_context *lc, int arg);
+int activate_or_deactivate_sets(struct lib_context *lc, int arg);
 void build_sets(struct lib_context *lc, char **sets);
 void format_error(struct lib_context *lc, const char *error, char **argv);
 void str_tolower(char *s);
 char *collapse_delimiter(struct lib_context *lc, char *str,
 			 size_t size, const char delim);
-int  valid_format(struct lib_context *lc, const char *fmt);
+int valid_format(struct lib_context *lc, const char *fmt);
 
 #endif
