From: heinzm@sourceware.org
Subject: dmraid ./CHANGELOG ./CREDITS ./KNOWN_BUGS ./RE ...
Date: 22 Feb 2008 17:04:43 -0000
Message-ID: <20080222170443.29266.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2008-02-22 17:04:36

Modified files:
	.              : CHANGELOG CREDITS KNOWN_BUGS README TODO 
	include/dmraid : dmraid.h list.h metadata.h 
	lib            : Makefile.in internal.h version.h 
	lib/activate   : activate.c activate.h devmapper.c devmapper.h 
	lib/format     : format.c ondisk.h register.h 
	lib/format/ataraid: asr.c asr.h hpt37x.c hpt37x.h hpt45x.c isw.c 
	                    jm.c lsi.c nv.c pdc.c sil.c sil.h via.c 
	lib/format/partition: dos.c 
	lib/locking    : locking.c 
	lib/metadata   : metadata.c 
	lib/misc       : file.c 
	tools          : Makefile.in VERSION 
Added files:
	include/dmraid : reconfig.h 
	lib/format/ataraid: .isw.c.swp .jm.c.swp 
	lib/format/ddf : README ddf1.c ddf1.c.orig ddf1.h ddf1_crc.c 
	                 ddf1_crc.h ddf1_cvt.c ddf1_cvt.h ddf1_dump.c 
	                 ddf1_dump.h ddf1_lib.c ddf1_lib.h 
	lib/metadata   : log_ops.c reconfig.c 

Log message:
	1.0.0.rc12 checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CHANGELOG.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CREDITS.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/KNOWN_BUGS.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/README.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/TODO.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/reconfig.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/dmraid.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/list.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/metadata.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/internal.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/devmapper.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/devmapper.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/format.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ondisk.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/register.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/.isw.c.swp.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/.jm.c.swp.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt37x.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt37x.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt45x.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/nv.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/via.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/README.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.orig.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_crc.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_crc.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_cvt.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_cvt.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_dump.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_dump.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_lib.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_lib.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/partition/dos.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/locking/locking.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/log_ops.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/reconfig.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/file.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/CHANGELOG	2008/02/22 16:50:38	1.1
+++ dmraid/CHANGELOG	2008/02/22 17:04:35	1.2
@@ -1,4 +1,26 @@
 
+Changelog from dmraid 1.0.0.rc11 to 1.0.0.rc12		2006.09.22
+
+
+FIXES:
+------
+o sil.c: quorate() OBO fix
+o activate.c: handler() OBO fix
+o added log_zero_sectors() to various metadata format handlers
+
+FEATURES:
+---------
+o added SNIA DDF1 support (IBM)
+o added reload functionality to devmapper.c (IBM)
+o sil.[ch]: added JBOD support
+
+
+MISCELANIOUS:
+-------------
+o streamlined devmapper.c
+
+
+
 Changelog from dmraid 1.0.0.rc10 to 1.0.0.rc11		2006.05.16
 
 FIXES:
--- dmraid/CREDITS	2008/02/22 16:50:38	1.1
+++ dmraid/CREDITS	2008/02/22 17:04:35	1.2
@@ -5,6 +5,7 @@
 
 o Jane Liu for the NVidia RAID metadata format handler
 
-o Darrick J. Wong for the Adpatec HostRAID ASR metadata format handler
+o Darrick J. Wong for the SNIA DDF1 and
+  Adaptec HostRAID ASR metadata format handlers
 
 o various helpful people who provided metadata samples
--- dmraid/KNOWN_BUGS	2008/02/22 16:50:38	1.1
+++ dmraid/KNOWN_BUGS	2008/02/22 17:04:35	1.2
@@ -1,5 +1,5 @@
 
-KNOWN_BUGS in dmraid 1.0.0.rc11					2005.05.16
+KNOWN_BUGS in dmraid 1.0.0.rc12					2005.05.15
 
 o "dmraid --sets[a/i]" doesn't work properly. Use the short option -s.
 
--- dmraid/README	2008/02/22 16:48:26	1.2
+++ dmraid/README	2008/02/22 17:04:35	1.3
@@ -1,6 +1,6 @@
 ********************************************************************************
 *                                                                              *
-*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc11  2006.05.15   *
+*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc12  2006.05.15   *
 *                                                                              *
 *   (C)opyright 2004-2006  Heinz Mauelshagen, Red Hat GmbH.                    *
 *   All rights reserved.                                                       *
@@ -26,6 +26,7 @@
 NVidia NForce
 Promise FastTrack
 Silicon Image Medley
+SNIA DDF1
 VIA Software RAID
 
 Beside hints, enhancement proposals and patches, I want to know, if the mappings
--- dmraid/TODO	2008/02/22 16:50:38	1.1
+++ dmraid/TODO	2008/02/22 17:04:35	1.2
@@ -1,19 +1,15 @@
 
--- dmraid 1.0.0.rc11 TODO --					2006.05.15
+-- dmraid 1.0.0.rc12 TODO --					2006.09.19
+
+o use kpartx instead of my own metadata format handlers
 
 o more enhancements for RAID set consistency checks
 
 o neater -s output; something better than just paragraphs
   for super- and subsets ?
 
-o higher RAID levels above 1; main restriction to support these is
-  the need for device-mapper targets which map RAID4 and RAID5
-  (Alpha patch for device-mapper RAID4/RAID5 target on my people page now)
-
 o MD metadata format handler
 
-o SNIA DDF metadata format handler
-
 o enhance metadata write feature in order to be able to store state changes
   persistently; needs an event() method to inform the metadata handler about
   state changes recognized eg, at the device-mapper interface layer
@@ -24,9 +20,6 @@
 
 o more cleanup and enhance debug and verbose output
 
-o support other partitions than MSDOS on Software RAID devices or
-  use kpartx instead ?
-
 o regular expressions for metadata format, RAID device and RAID set selection
 
 o does dmraid need a config file ?
/cvs/dm/dmraid/include/dmraid/reconfig.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/reconfig.h
+++ -	2008-02-22 17:04:37.144287000 +0000
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2006 Darrick Wong, IBM.
+ *                    All rights reserved.
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen Red Hat GmbH.
+ * 		      All rights reserved.
+ *
+ * See the file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _RECONFIG_H_
+#define _RECONFIG_H_
+
+#include <dmraid/metadata.h>
+#include <dmraid/list.h>
+
+/* Type of change that a log entry describes */
+enum change_type {
+	ADD_TO_SET,
+	DELETE_FROM_SET,
+	WRITE_METADATA,
+	CREATE_CHILD_RD,
+	CREATE_RD,
+	DELETE_RD,
+	CREATE_RS,
+	DELETE_RS,
+	END_TRANSACTION
+};
+
+/* Change log entry */
+struct change {
+	struct list_head changes;	/* Chain of log entries */
+	enum change_type type;
+
+	/* All of these items may be listed as parameters */
+	struct raid_set *rs;
+	struct raid_dev *rd;
+
+	uint64_t offset;
+	uint64_t length;
+
+	struct dev_info *di;
+
+	char *name;
+};
+
+extern int add_dev_to_set(struct lib_context *lc, struct raid_set *rs,
+			  struct raid_dev *rd);
+extern int del_dev_in_set(struct lib_context *lc, struct raid_set *rs,
+			  struct raid_dev *rd);
+extern void end_log(struct lib_context *lc, struct list_head *log);
+extern int revert_log(struct lib_context *lc, struct list_head *log);
+
+#endif
--- dmraid/include/dmraid/dmraid.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/dmraid.h	2008/02/22 17:04:35	1.2
@@ -17,6 +17,7 @@
 #include <dmraid/display.h>
 #include <dmraid/format.h>
 #include <dmraid/metadata.h>
+#include <dmraid/reconfig.h>
 
 /*
  * Library init/exit
@@ -43,6 +44,7 @@
 extern int discover_devices(struct lib_context *lc, char **devnodes);
 extern void discover_raid_devices(struct lib_context *lc, char **devices);
 extern void discover_partitions(struct lib_context *lc);
+extern int write_dev(struct lib_context *lc, struct raid_dev *rd, int erase);
 
 /*
  * Erase ondisk metadata.
--- dmraid/include/dmraid/list.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/list.h	2008/02/22 17:04:35	1.2
@@ -19,6 +19,8 @@
 
 #define INIT_LIST_HEAD(a)	do { (a)->next = (a)->prev = a; } while(0)
 
+#define	LIST_HEAD(a)	struct list_head a = { .next = &a, .prev = &a }
+
 #define list_empty(pos)	((pos)->next == pos)
 
 static inline void __list_add(struct list_head *new,
@@ -44,6 +46,11 @@
 	(pos)->next = (pos)->prev = 0; \
 }
 
+#define	list_del_init(pos) { \
+	list_del(pos); \
+	INIT_LIST_HEAD(pos); \
+}
+
 /* Pointer to a struct 'type' derived from 'pos' and list_head* 'member'. */
 #define list_entry(pos, type, member) \
 	((type*) ((char*)pos - (unsigned long)(&((type*)0)->member)))
--- dmraid/include/dmraid/metadata.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/metadata.h	2008/02/22 17:04:35	1.2
@@ -81,6 +81,18 @@
 	s_setup		= 0x20,	/* Only during RAID setup transition. */
 };
 
+/*
+ * Mapping struct for RAID status unification.
+ *
+ * Format handler allocates an array and inserts mappings
+ * from format specific status to the unified ones above.
+ */
+enum compare { AND, EQUAL };
+struct states {
+	unsigned int status;
+	enum status unified_status;
+};
+
 /* Check macros for states. */
 #define	S_UNDEF(status)		((status) & s_undef)
 #define	S_BROKEN(status)	((status) & s_broken)
@@ -195,6 +207,8 @@
 	enum status status;		/* Status of set. */
 };
 
+extern struct raid_set *get_raid_set(struct lib_context *lc,
+				     struct raid_dev *rd);
 extern struct dmraid_format *get_format(struct raid_set *rs);
 extern const char *get_type(struct lib_context *lc, enum type type);
 extern const char *get_dm_type(struct lib_context *lc, enum type type);
@@ -244,11 +258,14 @@
 extern void discover_raid_devices(struct lib_context *lc, char **devices);
 extern void discover_partitions(struct lib_context *lc);
 extern unsigned int count_devices(struct lib_context *lc, enum dev_type type);
+extern enum status rd_status(struct states *states, unsigned int status,
+			     enum compare cmp);
 extern enum type rd_type(struct types *types, unsigned int type);
 extern void file_metadata(struct lib_context *lc, const char *handler,
 		   char *path, void *data, size_t size, uint64_t offset);
 extern void file_dev_size(struct lib_context *lc, const char *handler,
 		   struct dev_info *di);
+extern int write_dev(struct lib_context *lc, struct raid_dev *rd, int erase);
 extern int erase_metadata(struct lib_context *lc);
 
 #endif
--- dmraid/lib/Makefile.in	2008/02/22 16:57:35	1.1
+++ dmraid/lib/Makefile.in	2008/02/22 17:04:35	1.2
@@ -18,7 +18,9 @@
 	format/format.c \
 	locking/locking.c \
 	log/log.c \
+	metadata/log_ops.c \
 	metadata/metadata.c \
+	metadata/reconfig.c \
 	misc/file.c \
 	misc/init.c \
 	misc/lib_context.c \
@@ -35,7 +37,11 @@
 	format/ataraid/pdc.c \
 	format/ataraid/sil.c \
 	format/ataraid/via.c \
-	format/ataraid/asr.c \
+	format/ddf/ddf1.c \
+	format/ddf/ddf1_lib.c \
+	format/ddf/ddf1_crc.c \
+	format/ddf/ddf1_cvt.c \
+	format/ddf/ddf1_dump.c \
 	format/partition/dos.c
 
 OBJECTS=$(SOURCES:%.c=%.o)
--- dmraid/lib/internal.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/internal.h	2008/02/22 17:04:35	1.2
@@ -13,6 +13,7 @@
 #endif
 
 #include <ctype.h>
+#include <errno.h>
 #include <fcntl.h>
 #include <inttypes.h>
 #include <limits.h>
@@ -34,6 +35,7 @@
 #include <dmraid/format.h>
 #include <dmraid/metadata.h>
 #include "activate/activate.h"
+#include <dmraid/reconfig.h>
 
 #ifndef	u_int16_t
 #define	u_int16_t	uint16_t
--- dmraid/lib/version.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/version.h	2008/02/22 17:04:35	1.2
@@ -1,12 +1,12 @@
 #ifndef	DMRAID_LIB_VERSION
 
-#define	DMRAID_LIB_VERSION		"1.0.0.rc11"
+#define	DMRAID_LIB_VERSION		"1.0.0.rc12"
 
 #define	DMRAID_LIB_MAJOR_VERSION	1
 #define	DMRAID_LIB_MINOR_VERSION	0
 #define	DMRAID_LIB_SUBMINOR_VERSION	0
-#define	DMRAID_LIB_VERSION_SUFFIX	"rc11"
+#define	DMRAID_LIB_VERSION_SUFFIX	"rc12"
 
-#define	DMRAID_LIB_DATE			"(2006.05.15)"
+#define	DMRAID_LIB_DATE			"(2006.09.15)"
 
 #endif
--- dmraid/lib/activate/activate.c	2008/02/22 16:57:35	1.1
+++ dmraid/lib/activate/activate.c	2008/02/22 17:04:35	1.2
@@ -506,7 +506,7 @@
 	do {
 		if (rs->type == th->type)
 			return th;
-	} while (th++ < ARRAY_END(type_handler));
+	} while (++th < ARRAY_END(type_handler));
 
 	return type_handler;
 }
@@ -572,6 +572,65 @@
 	return do_device(lc, rs, dm_unregister_for_event);
 }
 
+/* Reload a single set. */
+static int reload_subset(struct lib_context *lc, struct raid_set *rs)
+{
+	int ret = 0;
+	char *table = NULL;
+
+	if (T_GROUP(rs))
+		return 1;
+
+	/* Suspend device */
+	if (!(ret = dm_suspend(lc, rs)))
+		LOG_ERR(lc, ret, "Device suspend failed.");
+
+	/* Call type handler */
+	if ((ret = (handler(rs))->f(lc, &table, rs))) {
+		if (OPT_TEST(lc))
+			display_table(lc, rs->name, table);
+		else
+			ret = dm_reload(lc, rs, table);
+	} else
+		log_err(lc, "no mapping possible for RAID set %s", rs->name);
+
+	free_string(lc, &table);
+
+	/* Try to resume */
+	if (ret)
+		dm_resume(lc, rs);
+	else
+		if (!(ret = dm_resume(lc, rs)))
+			LOG_ERR(lc, ret, "Device resume failed.");
+
+	return ret;
+}
+
+/* Reload a RAID set recursively (eg, RAID1 on top of RAID0). */
+static int reload_set(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_set *r;
+
+	/* FIXME: Does it matter if the set is (in)active? */
+#if 0
+	if (!OPT_TEST(lc) &&
+	    what == DM_ACTIVATE &&
+	    dm_status(lc, rs)) {
+		log_print(lc, "RAID set \"%s\" already active", rs->name);
+		return 1;
+	}
+#endif
+
+	/* Recursively walk down the chain of stacked RAID sets */
+	list_for_each_entry(r, &rs->sets, list) {
+		/* Activate set below this one */
+		if (!reload_set(lc, r) && !T_GROUP(rs))
+			return 0;
+	}
+
+	return reload_subset(lc, rs);
+}
+
 /* Activate a single set. */
 static int activate_subset(struct lib_context *lc, struct raid_set *rs,
 			   enum dm_what what)
@@ -683,6 +742,11 @@
 	case A_DEACTIVATE:
 		ret = deactivate_set(lc, rs, DM_REGISTER) &&
 		      deactivate_set(lc, rs, DM_ACTIVATE);
+		break;
+
+	case A_RELOAD:
+		ret = reload_set(lc, rs);
+		break;
 	}
 
 	return ret;
--- dmraid/lib/activate/activate.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/activate/activate.h	2008/02/22 17:04:35	1.2
@@ -11,6 +11,7 @@
 enum activate_type {
 	A_ACTIVATE,
 	A_DEACTIVATE,
+	A_RELOAD,
 };
 
 int change_set(struct lib_context *lc, enum activate_type what, void *rs);
--- dmraid/lib/activate/devmapper.c	2008/02/22 16:57:35	1.1
+++ dmraid/lib/activate/devmapper.c	2008/02/22 17:04:35	1.2
@@ -16,7 +16,6 @@
 #include <string.h>
 #include <ctype.h>
 #include <dirent.h>
-#include <errno.h>
 #include <unistd.h>
 
 #include "internal.h"
@@ -148,19 +147,31 @@
 	return handle_table(lc, NULL, table, get_target_list());
 }
 
-/* Create a mapped device. */
-int dm_create(struct lib_context *lc, struct raid_set *rs, char *table)
+/* Create a task, set its name and run it. */
+static int run_task(struct lib_context *lc, struct raid_set *rs,
+		    char *table, int type)
 {
-	int ret = 0;
+	int ret;
 	struct dm_task *dmt;
 
 	_init_dm();
+	ret = (dmt = dm_task_create(type)) && dm_task_set_name(dmt, rs->name);
+	if (ret && table)
+		ret = parse_table(lc, dmt, table);
+
+	if (ret)
+		ret = dm_task_run(dmt);
+
+	_exit_dm(dmt);
+	return ret;
+}
+/* Create a mapped device. */
+int dm_create(struct lib_context *lc, struct raid_set *rs, char *table)
+{
+	int ret;
 
 	/* Create <dev_name> */
-	ret = (dmt = dm_task_create(DM_DEVICE_CREATE)) &&
-	       dm_task_set_name(dmt, rs->name) &&
-	       parse_table(lc, dmt, table) &&
-	       dm_task_run(dmt);
+	ret = run_task(lc, rs, table, DM_DEVICE_CREATE);
 
 	/*
 	 * In case device creation failed, check if target
@@ -169,29 +180,48 @@
 	if (!ret)
 		check_table(lc, table);
 
-	_exit_dm(dmt);
-
 	return ret;
 }
 
-/* Remove a mapped device. */
-int dm_remove(struct lib_context *lc, struct raid_set *rs)
+/* Suspend a mapped device. */
+int dm_suspend(struct lib_context *lc, struct raid_set *rs)
 {
-	int ret;
-	struct dm_task *dmt;
+	/* Suspend <dev_name> */
+	return run_task(lc, rs, NULL, DM_DEVICE_SUSPEND);
+}
 
-	_init_dm();
+/* Resume a mapped device. */
+int dm_resume(struct lib_context *lc, struct raid_set *rs)
+{
+	/* Resume <dev_name> */
+	return run_task(lc, rs, NULL, DM_DEVICE_RESUME);
+}
 
-	/* remove <dev_name> */
-	ret = (dmt = dm_task_create(DM_DEVICE_REMOVE)) &&
-	       dm_task_set_name(dmt, rs->name) &&
-	       dm_task_run(dmt);
+/* Reload a mapped device. */
+int dm_reload(struct lib_context *lc, struct raid_set *rs, char *table)
+{
+	int ret;
 
-	_exit_dm(dmt);
+	/* Create <dev_name> */
+	ret = run_task(lc, rs, table, DM_DEVICE_RELOAD);
+
+	/*
+	 * In case device creation failed, check if target
+	 * isn't registered with the device-mapper core
+	 */
+	if (!ret)
+		check_table(lc, table);
 
 	return ret;
 }
 
+/* Remove a mapped device. */
+int dm_remove(struct lib_context *lc, struct raid_set *rs)
+{
+	/* Remove <dev_name> */
+	return run_task(lc, rs, NULL, DM_DEVICE_REMOVE);
+}
+
 /* Retrieve status of a mapped device. */
 /* FIXME: more status for device monitoring... */
 int dm_status(struct lib_context *lc, struct raid_set *rs)
--- dmraid/lib/activate/devmapper.h	2008/02/22 16:57:35	1.1
+++ dmraid/lib/activate/devmapper.h	2008/02/22 17:04:35	1.2
@@ -13,5 +13,8 @@
 int dm_remove(struct lib_context *lc, struct raid_set *rs);
 int dm_status(struct lib_context *lc, struct raid_set *rs);
 int dm_version(struct lib_context *lc, char *version, size_t size);
+int dm_suspend(struct lib_context *lc, struct raid_set *rs);
+int dm_resume(struct lib_context *lc, struct raid_set *rs);
+int dm_reload(struct lib_context *lc, struct raid_set *rs, char *table);
 
 #endif
--- dmraid/lib/format/format.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/format.c	2008/02/22 17:04:35	1.2
@@ -35,22 +35,24 @@
 
 struct format_member {
 	const unsigned short offset;
-	const unsigned char all;
-	const unsigned char method;
+	const unsigned char flags;
 	const char *msg;
 } __attribute__ ((packed));
 
+enum { FMT_ALL = 0x01, FMT_METHOD = 0x02 } format_flags;
+#define	IS_FMT_ALL(member)	(member->flags & FMT_ALL)
+#define	IS_FMT_METHOD(member)	(member->flags & FMT_METHOD)
 static struct format_member format_member[] = {
-	{ offset(name),   1, 0, "name" },
-	{ offset(descr),  1, 0, "description" },
-	{ offset(caps),   0, 0, "capabilities" },
-	{ offset(read),   1, 1, "read" },
-	{ offset(write),  0, 1, "write" },
-	{ offset(group),  1, 1, "group" },
-	{ offset(check),  1, 1, "check" },
-	{ offset(events), 0, 0, "events array" },
+	{ offset(name), FMT_ALL, "name" },
+	{ offset(descr), FMT_ALL, "description" },
+	{ offset(caps), 0, "capabilities" },
+	{ offset(read), FMT_ALL|FMT_METHOD, "read" },
+	{ offset(write), FMT_METHOD, "write" },
+	{ offset(group), FMT_ALL|FMT_METHOD, "group" },
+	{ offset(check), FMT_ALL|FMT_METHOD, "check" },
+	{ offset(events), 0, "events array" },
 #ifdef	NATIVE_LOG
-	{ offset(log),    0, 1, "log" },
+	{ offset(log),    FMT_METHOD, "log" },
 #endif
 };
 #undef	offset
@@ -58,12 +60,12 @@
 static int check_member(struct lib_context *lc, struct dmraid_format *fmt,
 			struct format_member *member)
 {
-	if ((!member->all && fmt->format != FMT_RAID) ||
+	if ((!IS_FMT_ALL(member) && fmt->format != FMT_RAID) ||
 	    *((unsigned long*) (((unsigned char*) fmt) + member->offset)))
 		return 0;
 
 	LOG_ERR(lc, 1, "%s: missing metadata format handler %s%s",
-		fmt->name, member->msg, member->method ? " method" : "");
+		fmt->name, member->msg, IS_FMT_METHOD(member) ? " method" : "");
 }
 
 static int check_format_handler(struct lib_context *lc,
--- dmraid/lib/format/ondisk.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ondisk.h	2008/02/22 17:04:35	1.2
@@ -18,7 +18,8 @@
 #include "ataraid/pdc.h"
 #include "ataraid/via.h"
 #include "ataraid/sil.h"
-#include "ataraid/asr.h"
+
+#include "ddf/ddf1.h"
 
 #include "partition/dos.h"
 
--- dmraid/lib/format/register.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/register.h	2008/02/22 17:04:35	1.2
@@ -16,6 +16,7 @@
 
 	/* Metadata format handlers. */
 	xx(asr)
+	xx(ddf1)
 	xx(hpt37x)
 	xx(hpt45x)
 	xx(isw)
/cvs/dm/dmraid/lib/format/ataraid/.isw.c.swp,v  -->  standard output
revision 1.1
Binary files /cvs/dm/dmraid/lib/format/ataraid/.isw.c.swp and - differ
co: output error: Broken pipe
co aborted
/cvs/dm/dmraid/lib/format/ataraid/.jm.c.swp,v  -->  standard output
revision 1.1
Binary files /cvs/dm/dmraid/lib/format/ataraid/.jm.c.swp and - differ
co: output error: Broken pipe
co aborted
--- dmraid/lib/format/ataraid/asr.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/asr.c	2008/02/22 17:04:35	1.2
@@ -1,13 +1,19 @@
 /*
- * Adaptec HostRAID ASR format interpreter for dmraid.
+ * Adaptec HostRAID ASR metadata format handler.
+ *
  * Copyright (C) 2005-2006 IBM, All rights reserved.
- * Written by Darrick Wong <djwong@us.ibm.com>
+ * Written by Darrick Wong <djwong@us.ibm.com>,
+ * James Simshaw <simshawj@us.ibm.com>, and
+ * Adam DiCarlo <bikko@us.ibm.com>
+ *
+ * Copyright (C) 2006  Heinz Mauelshagen, Red Hat GmbH
+ *		       All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
 
-#include <errno.h>
 #include <netinet/in.h>
+#include <time.h>
 
 #define	HANDLER	"asr"
 
@@ -21,44 +27,31 @@
 #endif
 
 static const char *handler = HANDLER;
-
-#define SPARE_ARRAY	".asr_spares"
-
-static int asr_write(struct lib_context *lc,  struct raid_dev *rd, int erase);
+static const char *spare_array = ".asr_spares";
 
 /* Map ASR disk status to dmraid status */
 static enum status disk_status(struct asr_raid_configline *disk) {
-	if (disk == NULL)
-		return s_undef;
-
-	switch (disk->raidstate) {
-	case LSU_COMPONENT_STATE_OPTIMAL:
-		return s_ok;
-
-	case LSU_COMPONENT_STATE_DEGRADED:
-	case LSU_COMPONENT_STATE_FAILED:
-		return s_broken;
-
-	case LSU_COMPONENT_STATE_UNINITIALIZED:
-	case LSU_COMPONENT_STATE_UNCONFIGURED:
-		return s_inconsistent;
-
-	case LSU_COMPONENT_SUBSTATE_BUILDING:
-	case LSU_COMPONENT_SUBSTATE_REBUILDING:
-	case LSU_COMPONENT_STATE_REPLACED:
-		return s_nosync;
+	static struct states states[] = {
+		{ LSU_COMPONENT_STATE_OPTIMAL, s_ok },
+		{ LSU_COMPONENT_STATE_DEGRADED, s_broken },
+		{ LSU_COMPONENT_STATE_FAILED, s_broken },
+		{ LSU_COMPONENT_STATE_UNINITIALIZED, s_inconsistent },
+		{ LSU_COMPONENT_STATE_UNCONFIGURED, s_inconsistent },
+		{ LSU_COMPONENT_SUBSTATE_BUILDING, s_nosync },
+		{ LSU_COMPONENT_SUBSTATE_REBUILDING, s_nosync },
+		{ LSU_COMPONENT_STATE_REPLACED, s_nosync },
+		{ 0, s_undef },
+	};
 
-	default:
-		return s_undef;
-	}
+	return rd_status(states, disk->raidstate, EQUAL);
 }
 		
 /* Extract config line from metadata */
 static struct asr_raid_configline *get_config(struct asr *asr, uint32_t magic)
 {
-	unsigned int i;
+	unsigned int i = asr->rt->elmcnt;
 	
-	for (i = 0; i < asr->rt->elmcnt; i++) {
+	while (i--) {
 		if (asr->rt->ent[i].raidmagic == magic)
 			return asr->rt->ent + i;
 	}
@@ -90,12 +83,9 @@
 	size_t len;
 	char *ret;
 
-	if ((ret = dbg_malloc((len = _name(lc, asr, NULL, 0) + 1)))) {
+	if ((ret = dbg_malloc((len = _name(lc, asr, NULL, 0) + 1))))
 		_name(lc, asr, ret, len);
-		/* Why do we call mk_alpha?  This makes labels like
-		 * "OS-u320-15k" become "OS-udca-bek", which is confusing.
-		 * mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN); */
-	} else
+	else
 		log_alloc_err(lc, handler);
 
 	return ret;
@@ -107,23 +97,23 @@
 	return cl ? cl->strpsize: 0;
 }
 
-/* Mapping of template types to generic types */
 /*
  * FIXME: This needs more examination.  Does HostRAID do linear
  * combination?  The BIOS implies that it only does RAID 0, 1 and 10.
  * The emd driver implied support for RAID3/4/5, but dm doesn't
  * do any of those right now (RAID4 and RAID5 are in the works).
  */
-static struct types types[] = {
-	{ ASR_RAID0,   t_raid0 },
-	{ ASR_RAID1,   t_raid1 },
-	{ ASR_RAIDSPR, t_spare },
-        { 0, t_undef}
-};
-
 /* Map the ASR raid type codes into dmraid type codes. */
 static enum type type(struct asr_raid_configline *cl)
 {
+	/* Mapping of template types to generic types */
+	static struct types types[] = {
+		{ ASR_RAID0,   t_raid0 },
+		{ ASR_RAID1,   t_raid1 },
+		{ ASR_RAIDSPR, t_spare },
+		{ 0, t_undef},
+	};
+
 	return cl ? rd_type(types, (unsigned int) cl->raidtype) : t_undef;
 }
 
@@ -131,9 +121,7 @@
  * Read an ASR RAID device.  Fields are big endian, so
  * need to convert them if we're on a LE machine (i386, etc).
  */
-#define ASR_BLOCK	0x01
-#define ASR_TABLE	0x02
-#define ASR_EXTTABLE 	0x04
+enum { ASR_BLOCK = 0x01, ASR_TABLE = 0x02, ASR_EXTTABLE  = 0x04 };
 
 #if	BYTE_ORDER == LITTLE_ENDIAN
 static void cvt_configline(struct asr_raid_configline *cl)
@@ -154,11 +142,9 @@
 
 static void to_cpu(void *meta, unsigned int cvt)
 {
-	int i;
 	struct asr *asr = meta;
-	int elmcnt = asr->rt->elmcnt;
-
-	int use_old_elmcnt = (asr->rt->ridcode == RVALID2);
+	unsigned int i, elmcnt = asr->rt->elmcnt,
+		     use_old_elmcnt = (asr->rt->ridcode == RVALID2);
 
 	if (cvt & ASR_BLOCK) {
 		CVT32(asr->rb.b0idcode);
@@ -190,15 +176,13 @@
 		CVT32(asr->rt->recreateDate);
 
 		/* Convert the first seven config lines */
-		for (i = 0; i < (elmcnt < 7 ? elmcnt : 7); i++) 
+		for (i = 0; i < (min(elmcnt, ASR_TBLELMCNT)); i++) 
 			cvt_configline(asr->rt->ent + i);
-		
 	}
 
 	if (cvt & ASR_EXTTABLE) {
-		for (i = 7; i < elmcnt; i++) {
+		for (i = ASR_TBLELMCNT; i < elmcnt; i++)
 			cvt_configline(asr->rt->ent + i);
-		}
 	}
 }
 
@@ -209,31 +193,41 @@
 /* Compute the checksum of RAID metadata */
 static unsigned int compute_checksum(struct asr *asr)
 {
-	uint8_t *ptr;
-	unsigned int i, checksum;
+	uint8_t *ptr = (uint8_t*) asr->rt->ent;
+	unsigned int checksum = 0,
+		     end = sizeof(*asr->rt->ent) * asr->rt->elmcnt;
 
 	/* Compute checksum. */
-	ptr = (uint8_t*) asr->rt->ent;
-	checksum = 0;
-	for (i = 0; i < sizeof(*asr->rt->ent) * asr->rt->elmcnt; i++)
-		checksum += ptr[i];
+	while (end--)
+		checksum += *(ptr++);
 
 	return checksum & 0xFFFF;
 }
 
+/* (Un)truncate white space at the end of a name */
+enum truncate { TRUNCATE, UNTRUNCATE };
+static void handle_white_space(uint8_t *p, enum truncate truncate)
+{
+	unsigned int j = ASR_NAMELEN;
+	uint8_t c = truncate == TRUNCATE ? 0 : ' ';
+
+	while (j-- && (truncate == TRUNCATE ? isspace(p[j]) : !p[j]))
+		p[j] = c;
+}
+
 /* Read extended metadata areas */
 static int read_extended(struct lib_context *lc, struct dev_info *di,
 			 struct asr *asr)
 {
 	unsigned int remaining, i, chk;
-	int j;
 
-	log_info(lc, "%s: reading extended data", di->path);
+	log_notice(lc, "%s: reading extended data on %s", handler, di->path);
 	
 	/* Read the RAID table. */
 	if (!read_file(lc, handler, di->path, asr->rt, ASR_DISK_BLOCK_SIZE,
 		       (uint64_t) asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE))
-		LOG_ERR(lc, 0, "%s: Could not read metadata.", handler);
+		LOG_ERR(lc, 0, "%s: Could not read metadata off %s",
+			handler, di->path);
 
 	/* Convert it */
 	to_cpu(asr, ASR_TABLE);
@@ -241,21 +235,21 @@
 	/* Is this ok? */
 	if (asr->rt->ridcode != RVALID2)
 		LOG_ERR(lc, 0, "%s: Invalid magic number in RAID table; "
-			"saw 0x%X, expected 0x%X.", handler, asr->rt->ridcode,
-			RVALID2);
+			"saw 0x%X, expected 0x%X on %s",
+			handler, asr->rt->ridcode, RVALID2, di->path);
 
 	/* Have we a valid element count? */
-	if (asr->rt->elmcnt >= asr->rt->maxelm)
-		LOG_ERR(lc, 0, "%s: Invalid RAID config table count.\n",
-			handler);
+	if (asr->rt->elmcnt >= asr->rt->maxelm || asr->rt->elmcnt == 0)
+		LOG_ERR(lc, 0, "%s: Invalid RAID config table count on %s",
+			handler, di->path);
 
 	/* Is each element the right size? */
-	if (asr->rt->elmsize != sizeof(struct asr_raid_configline))
-		LOG_ERR(lc, 0, "%s: RAID config line is the wrong size.\n",
-			handler);
+	if (asr->rt->elmsize != sizeof(*asr->rt->ent))
+		LOG_ERR(lc, 0, "%s: Wrong RAID config line size on %s",
+			handler, di->path);
 
 	/* Figure out how much else we need to read. */
-	if (asr->rt->elmcnt > 7) {
+	if (asr->rt->elmcnt > ASR_TBLELMCNT) {
 		remaining = asr->rt->elmsize * (asr->rt->elmcnt - 7);
 		if (!read_file(lc, handler, di->path, asr->rt->ent + 7,
 			       remaining, (uint64_t)(asr->rb.raidtbl + 1) *
@@ -268,8 +262,8 @@
 	chk = compute_checksum(asr);
 	if (chk != asr->rt->rchksum)
 		LOG_ERR(lc, 0,"%s: Invalid RAID config table checksum "
-			       "(0x%X vs. 0x%X).",
-			handler, chk, asr->rt->rchksum);
+			       "(0x%X vs. 0x%X) on %s",
+			handler, chk, asr->rt->rchksum, di->path);
 	
 	/* Process the name of each line of the config line. */
 	for (i = 0; i < asr->rt->elmcnt; i++) {
@@ -299,11 +293,7 @@
 			memcpy(asr->rt->ent[i].name, asr->rt->ent[0].name, 16);
 
 		/* Now truncate trailing whitespace in the name. */
-		for (j = 15; j >= 0; j--) {
-			if (asr->rt->ent[i].name[j] != ' ')
-				break;
-		}
-		asr->rt->ent[i].name[j + 1] = 0;
+		handle_white_space(asr->rt->ent[i].name, TRUNCATE);
 	}
 
 	return 1;
@@ -322,8 +312,7 @@
 		if (asr->rb.resver == RBLOCK_VER)
 			return 1;
 		
-		LOG_ERR(lc, 0,
-			"%s: ASR v%d detected, but we only support v8.\n",
+		log_err(lc, "%s: ASR v%d detected, but we only support v8",
 			handler, asr->rb.resver);
 	}
 
@@ -358,10 +347,10 @@
 	 * the two magic numbers, the version, and the pointer to the
 	 * RAID table.  Everything else appears to be unused in v8.
 	 */
-	if (!(asr = alloc_private(lc, handler, sizeof(struct asr))))
+	if (!(asr = alloc_private(lc, handler, sizeof(*asr))))
 		goto bad0;
 	
-	if (!(asr->rt = alloc_private(lc, handler, sizeof(struct asr_raidtable))))
+	if (!(asr->rt = alloc_private(lc, handler, sizeof(*asr->rt))))
 		goto bad1;
 
 	if (!read_file(lc, handler, di->path, &asr->rb, size, asr_sboffset))
@@ -395,7 +384,28 @@
 	asr = NULL;
 
    out:
-	return (void*) asr;
+	return asr;
+}
+
+/* Read the whole metadata chunk at once */
+static uint8_t *read_metadata_chunk(struct lib_context *lc, struct dev_info *di,
+				    uint64_t start)
+{
+	uint8_t *ret;
+	size_t size = (di->sectors - start) * ASR_DISK_BLOCK_SIZE;
+
+	if (!(ret = dbg_malloc(size)))
+		LOG_ERR(lc, ret, "%s: unable to allocate memory for %s",
+			handler, di->path);
+
+	if (!read_file(lc, handler, di->path, ret, size,
+		       start * ASR_DISK_BLOCK_SIZE)) {
+		dbg_free(ret);
+		LOG_ERR(lc, NULL, "%s: unable to read metadata on %s",
+			handler, di->path);
+	}
+
+	return ret;
 }
 
 /*
@@ -405,20 +415,26 @@
 static void file_metadata_areas(struct lib_context *lc, struct dev_info *di,
 				void *meta)
 {
+	uint8_t *buf;
 	struct asr *asr = meta;
+	uint64_t start = asr->rb.raidtbl;
+
+	if (!(buf = read_metadata_chunk(lc, di, start)))
+		return;
 
 	/* Register the raid tables. */
-	file_metadata(lc, handler, di->path, asr->rt,
+	file_metadata(lc, handler, di->path, buf,
 		      ASR_DISK_BLOCK_SIZE * 17,
-		      (uint64_t)asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE);
-
+		      start * ASR_DISK_BLOCK_SIZE);
+	
+	dbg_free(buf);
+	
 	/* Record the device size if -D was specified. */
 	file_dev_size(lc, handler, di);
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info);
-
 static struct raid_dev *asr_read(struct lib_context *lc,
 					struct dev_info *di)
 {
@@ -438,8 +454,8 @@
 
 /*
  * Compose a 64-bit ID for device sorting.
- * Is hba:ch:lun:id ok?  It seems to be the way the binary driver
- * does it...
+ * Is hba:ch:lun:id ok?
+ * It seems to be the way the binary driver does it...
  */
 static inline uint64_t compose_id(struct asr_raid_configline *cl)
 {
@@ -465,11 +481,8 @@
 
 	for (i = 0; i < asr->rt->elmcnt; i++) {
 		if (asr->rt->ent[i].raidlevel == FWL)
-		{
 			toplevel = i;
-		}
-		else if (asr->rt->ent[i].raidlevel == FWL_2)
-		{
+		else if (asr->rt->ent[i].raidlevel == FWL_2) {
 			toplevel = i;
 			break;
 		}
@@ -488,13 +501,10 @@
 
 	/* This MUST be done backwards! */
 	for (i = asr->rt->elmcnt - 1; i > -1; i--) {
-		if (asr->rt->ent[i].raidmagic == asr->rb.drivemagic)
-		{
+		if (asr->rt->ent[i].raidmagic == asr->rb.drivemagic) {
 			for (j = i - 1; j > -1; j--) {
 				if (asr->rt->ent[j].raidlevel == FWL)
-				{
-					return &asr->rt->ent[j];
-				}
+					return asr->rt->ent + j;
 			}
 		}
 	}
@@ -502,9 +512,20 @@
 	return NULL;
 }
 
+static struct raid_dev *find_spare(struct lib_context *lc) {
+	struct raid_dev *spare;
+	
+	list_for_each_entry(spare, LC_RD(lc), list) {
+		if (spare->type == t_spare)  
+			return spare;
+	}
+
+	return NULL;
+}
+
 /* Wrapper for name() */
 static char *js_name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+		     unsigned int subset)
 {
 	return name(lc, META(rd, asr));
 }
@@ -523,8 +544,8 @@
 	if (rd->status & s_broken)
 		return 0;
 	
-	log_err(lc, "I/O error on device %s at sector %lu.",
-		e_io->rd->di->path, e_io->sector);
+	log_err(lc, "%s: I/O error on device %s at sector %lu",
+		handler, e_io->rd->di->path, e_io->sector);
 
 	/* Mark the array as degraded and the disk as failed. */
 	rd->status = s_broken;
@@ -532,8 +553,90 @@
 	fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
 	/* FIXME: Do we have to mark a parent too? */
 
-	/* Indicate that this is indeed a failure. */
-	return 1;
+	return 1; /* Indicate that this is indeed a failure. */
+}
+
+/*
+ * Helper routines for asr_group()
+ */
+static struct raid_set *do_spare(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct raid_set *rs;
+
+	/*
+	 * If this drive really _is_ attached to a specific
+	 * RAID set, then just attach it.  Really old HostRAID cards
+	 * do this... but I don't have any hardware to test this.
+	 */
+	/*
+	 * FIXME: dmraid ignores spares attached to RAID arrays.
+	 * For now, we'll let it get sucked into the ASR spare pool. 
+	 * If we need it, we'll reconfigure it; if not, nobody touches
+	 * it.
+	 *
+	 * rs = find_set(lc, name(lc, asr), FIND_TOP, rd, LC_RS(lc),
+	 *		 NO_CREATE, NO_CREATE_ARG);
+	 */
+
+	/* Otherwise, make a global spare pool. */
+	rs = find_or_alloc_raid_set(lc, (char*)spare_array, FIND_TOP, rd,
+				    LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
+
+	/*
+	 * Setting the type to t_spare guarantees that dmraid won't
+	 * try to set up a real device-mapper mapping.
+	 */
+	rs->type = t_spare;
+
+	/* Add the disk to the set. */
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+	return rs;
+}
+
+#define BUFSIZE 128
+static struct raid_set *do_stacked(struct lib_context *lc, struct raid_dev *rd,
+				   struct asr_raid_configline *cl)
+{
+	char buf[BUFSIZE], *path = rd->di->path;
+	struct raid_set *rs, *ss;
+	struct asr_raid_configline *fwl;
+	struct asr *asr = META(rd, asr);
+
+	/* First compute the name of the disk's direct parent. */
+	fwl = find_logical(asr);
+	if (!fwl)
+		LOG_ERR(lc, NULL, "%s: Failed to find RAID configuration "
+				  "line on %s",
+			handler, path);
+
+	snprintf(buf, BUFSIZE, ".asr_%s_%x_donotuse",
+		 fwl->name, fwl->raidmagic);
+	
+	/* Now find said parent. */
+	rs = find_or_alloc_raid_set(lc, buf, FIND_ALL, rd, NO_LIST,
+				    NO_CREATE, NO_CREATE_ARG);
+	if (!rs)
+		LOG_ERR(lc, NULL, "%s: Error creating RAID set for %s",
+			handler, path);
+
+	rs->stride = stride(cl);
+	rs->status = s_ok;
+	rs->type = type(fwl);
+
+	/* Add the disk to the set. */
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+	
+	/* Find the top level set. */
+	ss = join_superset(lc, js_name, NO_CREATE, set_sort, rs, rd);
+	if (!ss)
+		LOG_ERR(lc, NULL, "%s: Error creating top RAID set for %s",
+			handler, path);
+
+	ss->stride = stride(cl);
+	ss->status = s_ok;
+	/* FIXME: correct type (this crashed in stacked set code) */
+	ss->type = t_raid1; // type(&asr->rt->ent[top_idx]);
+	return ss;
 }
 
 /* 
@@ -541,69 +644,35 @@
  * which this disk belongs, and then attaching it.  Note that there are other
  * complications, such as two-layer arrays (RAID10).
  */
-#define BUFSIZE 128
 static struct raid_set *asr_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	int top_idx;
 	struct asr *asr = META(rd, asr);
 	struct asr_raid_configline *cl = this_disk(asr);
-	struct asr_raid_configline *fwl;
-	struct raid_set *set, *sset;
-	char buf[BUFSIZE];
+	struct raid_set *rs;
 
-	if (T_SPARE(rd)) {
-		/*
-		 * If this drive really _is_ attached to a specific
-		 * RAID set, then just attach it.  Really old HostRAID cards
-		 * do this... but I don't have any hardware to test this.
-		 */
-		/*
-		 * FIXME: dmraid ignores spares attached to RAID arrays.
-		 * For now, we'll let it get sucked into the ASR spare pool. 
-		 * If we need it, we'll reconfigure it; if not, nobody touches
-		 * it.
-		 *
-		set = find_set(lc, name(lc, asr), FIND_TOP, rd, LC_RS(lc),
-			       NO_CREATE, NO_CREATE_ARG);
-		 */
-
-		/* Otherwise, make a global spare pool. */
-		set = find_or_alloc_raid_set(lc, (char*)SPARE_ARRAY,
-			FIND_TOP, rd, LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
-
-		/*
-		 * Setting the type to t_spare guarantees that dmraid won't
-		 * try to set up a real device-mapper mapping.
-		 */
-		set->type = t_spare;
-
-		/* Add the disk to the set. */
-		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
-		return set;
-	}
+	if (T_SPARE(rd))
+		return do_spare(lc, rd);
 
 	/* Find the top level FWL/FWL2 for this device. */
 	top_idx = find_toplevel(lc, asr);
-	if (top_idx < 0) {
-		LOG_ERR(lc, NULL, "Can't find a logical array config "
-			"for disk %x\n",
-			asr->rb.drivemagic);
-	}
+	if (top_idx < 0)
+		LOG_ERR(lc, NULL, "%s: Can't find a logical array config "
+			"for disk %x",
+			handler, asr->rb.drivemagic);
 
 	/* This is a simple RAID0/1 array.  Find the set. */
-	if (asr->rt->ent[top_idx].raidlevel == FWL)
-	{
-		set = find_or_alloc_raid_set(lc, name(lc, asr),
-			FIND_TOP, rd, LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
-
-		set->stride = stride(cl);
-		set->status = s_ok;
-		set->type = type(find_logical(asr));
+	if (asr->rt->ent[top_idx].raidlevel == FWL) {
+		rs = find_or_alloc_raid_set(lc, name(lc, asr), FIND_TOP,
+					    rd, LC_RS(lc), NO_CREATE,
+					    NO_CREATE_ARG);
+		rs->stride = stride(cl);
+		rs->status = s_ok;
+		rs->type = type(find_logical(asr));
 
 		/* Add the disk to the set. */
-		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
-		
-		return set;
+		list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+		return rs;
 	}
 
 	/*
@@ -612,59 +681,276 @@
 	 * and use join_superset to attach the parent set to the top set.
 	 */
 	if (asr->rt->ent[top_idx].raidlevel == FWL_2)
-	{
-		/* First compute the name of the disk's direct parent. */
-		fwl = find_logical(asr);
-		snprintf(buf, BUFSIZE, ".asr_%s_%x_donotuse",
-			 fwl->name, fwl->raidmagic);
-		
-		/* Now find said parent. */
-		set = find_or_alloc_raid_set(lc, buf,
-			FIND_ALL, rd, NO_LIST, NO_CREATE, NO_CREATE_ARG);
-
-		if (!set)
-			LOG_ERR(lc, NULL, "Error creating RAID set.\n");
-
-		set->stride = stride(cl);
-		set->status = s_ok;
-		set->type = type(fwl);
+		return do_stacked(lc, rd, cl);
 
-		/* Add the disk to the set. */
-		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
-		
-		/* Find the top level set. */
-		sset = join_superset(lc, js_name, NO_CREATE,
-				     set_sort, set, rd);
-
-		if (!sset)
-			LOG_ERR(lc, NULL, "Error creating top RAID set.\n");
-
-		sset->stride = stride(cl);
-		sset->status = s_ok;
-		sset->type = type(&asr->rt->ent[top_idx]);
 
-		return sset;
+	/* If we land here, something's seriously wrong. */
+	LOG_ERR(lc, NULL, "%s: Top level array config is not FWL/FWL2?",
+		handler);
+}
+
+/* deletes configline from metadata of given asr, by index. */
+static void delete_configline(struct asr *asr, int index)
+{
+	struct asr_raid_configline *cl, *end;
+
+	asr->rt->elmcnt--;
+	cl = asr->rt->ent + index;
+	end = asr->rt->ent + asr->rt->elmcnt;
+	while (cl < end) {
+		memcpy(cl, cl + 1, sizeof(*cl));
+		++cl;
 	}
+}
 
-	/* If we land here, something's seriously wrong. */
-	LOG_ERR(lc, NULL, "Top level array config is not FWL/FWL2?\n");
+/* Find the newest configline entry in raid set and return a pointer to it. */
+static struct raid_dev *find_newest_drive(struct raid_set *rs)
+{
+	struct asr *asr;
+	struct raid_dev *device, *newest = NULL;
+	uint16_t newest_raidseq = 0;
+        int i;
+	
+	list_for_each_entry(device, &rs->devs, devs) {
+		asr = META(device, asr);
+		// FIXME: We should be able to assume each configline
+		// in a single drive has the same raidseq as the rest
+		// in that drive. We're doing too much work here.
+		for (i = 0; i < asr->rt->elmcnt; ++i) {
+			if (asr->rt->ent[i].raidseq >= newest_raidseq) {
+				newest_raidseq = asr->rt->ent[i].raidseq;
+				newest = device;
+			}
+		}
+	}
+	
+	return newest;
+}
+
+/* Creates a random integer for a drive magic section */
+static uint32_t create_drivemagic() {
+
+	srand(time(NULL));
+	return rand() + rand();
+}
+
+static int spare(struct lib_context *lc, struct raid_dev *rd,
+		 struct asr *asr)
+{
+	struct asr_raid_configline *cl;
+
+	/* If the magic is already 0xFFFFFFFF, exit */
+	if (asr->rt->raidmagic == 0xFFFFFFFF)
+		return 1;
+
+	/* Otherwise, set the magic */
+	asr->rt->raidmagic = 0xFFFFFFFF;
+
+	/* Erase all the CLs, create the two defaults and exit */
+	/* FIXME: How to set blockstoragetid? */
+	asr->rt->elmcnt = 2;
+
+	/* Note the presence of an array of spares in first config
+	 * line entry. */
+	cl = asr->rt->ent;
+	cl->raidmagic = 0xFFFFFFFF;
+	cl->raidseq = 0;
+	cl->name[0] = 0;
+	cl->raidcnt = 1;
+	cl->raidtype = ASR_RAIDSPR;
+	cl->lcapcty = rd->di->sectors;
+	cl->raidlevel = FWL;
+	cl++;
+
+	/* Actually describe the disk: it's a spare. */
+	cl->raidmagic = asr->rb.drivemagic;
+	cl->raidseq = 0;
+	cl->name[0] = 0;
+	cl->raidcnt = 0;
+	cl->raidtype = ASR_RAIDSPR;
+	cl->lcapcty = rd->di->sectors;
+	cl->raidlevel = FWP;
+
+	return 1;
+}
+
+/* Returns (boolean) whether or not the drive described by the given configline
+ * is in the given raid_set. */
+static int in_raid_set(struct asr_raid_configline *cl, struct raid_set *rs)
+{
+	struct asr *asr;
+	struct raid_dev *d;
+
+	list_for_each_entry(d, &rs->devs, devs) {
+		asr = META(d, asr);
+		if (cl->raidmagic == asr->rb.drivemagic)
+			return 1;
+	}
+	return 0;
+}
+
+/* Delete extra configlines which would otherwise trip us up. */
+static int cleanup_configlines(struct raid_dev *rd, struct raid_set *rs)
+{
+	struct asr *a;
+	struct raid_dev *d;
+	struct asr_raid_configline *cl;
+	int clcnt;
+
+	list_for_each_entry(d, &rs->devs, devs) {
+		a = META(d, asr);
+	
+		cl = a->rt->ent;
+		for (clcnt = 0; clcnt < a->rt->elmcnt; /* done in loop */ ) {
+			/* If it's in the seen list, or is a logical drive, 
+			 * end iteration. The idea: get rid of configlines
+			 * which describe devices which are no longer in the
+			 * array.
+			 * FIXME: If our topmost level is FWL2, we could have
+			 * FWL entries which need to be removed, right? We need
+			 * to check for this condition, too. */
+			if (cl->raidlevel != FWP || in_raid_set(cl, rs)) {
+				cl++;
+				clcnt++;
+			} else {
+				/* Delete entry. After deleting, a new entry is
+				 * found at *cl (a->rt->ent[clcnt]), so don't
+				 * increment counter/pointer; otherwise we'd
+				 * skip an entry.
+				 */
+				delete_configline(a, clcnt);
+			}
+		}
+	}
+	return 1;
+}
+
+/* Add a CL entry */
+static int create_configline(struct raid_set *rs, struct asr *asr,
+		             struct asr *a, struct raid_dev* newest)
+{
+	if (asr->rt->elmcnt >= RCTBL_MAX_ENTRIES) {
+		return 0;
+	}
+
+	struct asr *newest_asr;
+	struct asr_raid_configline *cl;
+	
+	newest_asr = META(newest, asr);
+	
+	cl = asr->rt->ent + asr->rt->elmcnt;
+	asr->rt->elmcnt++;
+
+	/* Use first raidseq, below: FIXME - don't assume all CLS are
+	 * consistent */
+	cl->raidmagic = a->rb.drivemagic;
+	cl->raidseq = newest_asr->rt->ent[0].raidseq;
+	cl->strpsize = newest_asr->rt->ent[0].strpsize;
+	strcpy((char*) cl->name, &rs->name[4]); /* starts after "asr_" */
+	cl->raidcnt = 0;
+
+	/* Convert rs->type to an ASR_RAID type for the CL */
+	switch (rs->type) {
+	case t_raid0:
+		cl->raidtype = ASR_RAID0;
+		break;
+	case t_raid1:
+		cl->raidtype = ASR_RAID1;
+		break;
+	default:
+		return 0;
+	}
+	cl->lcapcty = newest_asr->rt->ent[0].lcapcty;
+	cl->raidlevel = FWP;
+	return 1;
+}
+
+/* Update metadata to reflect the current raid set configuration.
+ * Returns boolean success. */
+static int update_metadata(struct lib_context *lc,  struct raid_dev *rd,
+			   struct asr *asr)
+{
+	struct raid_set *rs;
+	struct asr_raid_configline *cl;
+	struct raid_dev *d, *newest;
+	struct asr *a;
+
+	/* Find the raid set */
+	rs = get_raid_set(lc, rd);
+	if (!rs) {
+		/* Array-less disks ... have no CLs ? */
+		asr->rt->elmcnt = 0;
+		return 1;
+	}
+	
+	/* If this is the spare array... */
+	if (!strcmp(spare_array, rs->name))
+		return spare(lc, rd, asr);
+
+	/* Find newest drive for use below */
+	if (!(newest = find_newest_drive(rs)))
+		return 0;
+
+	/* If the drive magic is 0xFFFFFFFF, assign a random one. */
+	if (asr->rb.drivemagic == 0xFFFFFFFF)
+		asr->rb.drivemagic = create_drivemagic();
+
+	/* Make sure the raid type agrees with the metadata */
+	if (type(this_disk(asr)) == t_spare) {
+		struct asr *newest_asr = META(newest, asr);
+	
+		/* copy entire table from newest drive */	
+		asr->rt->elmcnt = newest_asr->rt->elmcnt;
+		memcpy(asr->rt->ent, newest_asr->rt->ent,
+			asr->rt->elmcnt * sizeof(*asr->rt->ent));
+	}
+
+	/* Increment the top level CL's raid count */
+	/* Fixme: What about the the FWLs in a FWL2 setting? */
+	cl = asr->rt->ent + find_toplevel(lc, asr);
+	cl->raidseq++;
+
+	/* For each disk in the rs */
+	list_for_each_entry(d, &rs->devs, devs) {
+		a = META(d, asr);
+
+		/* If it's in the CL already... */
+		if ((cl = get_config(asr, a->rb.drivemagic))) {
+			/* Increment seq number */
+			cl->raidseq++;
+			continue;
+		}
+
+		/* If the magic is 0xFFFFFFFF, assign a random one */
+		if (a->rb.drivemagic == 0xFFFFFFFF) {
+			a->rb.drivemagic = create_drivemagic();
+		}
+		
+		if (!(newest = find_newest_drive(rs)))
+			return 0;
+				
+		create_configline(rs, asr, a, newest);
+	}
+
+	cleanup_configlines(rd, rs);
+
+	return 1;
 }
 
+
 /* Write metadata. */
 static int asr_write(struct lib_context *lc,  struct raid_dev *rd, int erase)
 {
-	int ret, i, j;
         struct asr *asr = META(rd, asr);
-	int elmcnt = asr->rt->elmcnt;
+	int elmcnt = asr->rt->elmcnt, i, ret;
+
+	/* Update the metadata if we're not erasing it. */
+	if (!erase)
+		update_metadata(lc, rd, asr);
 
 	/* Untruncate trailing whitespace in the name. */
-	for (i = 0; i < elmcnt; i++) {
-		for (j = 15; j >= 0; j--) {
-			if (asr->rt->ent[i].name[j] == 0)
-				break;
-		}
-		asr->rt->ent[i].name[j] = ' ';
-	}
+	for (i = 0; i < elmcnt; i++)
+		handle_white_space(asr->rt->ent[i].name, UNTRUNCATE);
 
 	/* Compute checksum */
 	asr->rt->rchksum = compute_checksum(asr);
@@ -679,13 +965,8 @@
         to_cpu(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
  
 	/* Truncate trailing whitespace in the name. */
-	for (i = 0; i < elmcnt; i++) {
-		for (j = 15; j >= 0; j--) {
-			if (asr->rt->ent[i].name[j] != ' ')
-				break;
-		}
-		asr->rt->ent[i].name[j + 1] = 0;
-	}
+	for (i = 0; i < elmcnt; i++)
+		handle_white_space(asr->rt->ent[i].name, TRUNCATE);
 
         return ret;
 }
@@ -699,7 +980,8 @@
 {
 	/* Get the logical drive */
 	struct asr_raid_configline *cl = find_logical(META(rd, asr));
-	return (cl ? cl->raidcnt : 0);
+
+	return cl ? cl->raidcnt : 0;
 }
 
 /* Check a RAID device */
@@ -707,7 +989,7 @@
 		    struct raid_dev *rd, void *context)
 {
 	/* FIXME: Assume non-broken means ok. */
-	return (rd->type != s_broken);
+	return rd->type != s_broken;
 }
 
 /* Start the recursive RAID set check. */
@@ -840,34 +1122,30 @@
 	struct asr_raid_configline *cl = this_disk(asr);
 
 	if (!cl)
-		LOG_ERR(lc, 0, "%s: Could not find current disk!\n",
-			handler);		
+		LOG_ERR(lc, 0, "%s: Could not find current disk!", handler);		
 
 	/* We need two metadata areas */
-	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 2)))
+	if (!(ma = rd->meta_areas = alloc_meta_areas(lc, rd, handler, 2)))
 		return 0;
 
 	/* First area: raid reserved block. */
-	ma = rd->meta_areas;
 	ma->offset = ASR_CONFIGOFFSET >> 9;
 	ma->size = ASR_DISK_BLOCK_SIZE;
-	ma->area = (void*) asr;
+	(ma++)->area = asr;
 
 	/* Second area: raid table. */
-	ma++;
 	ma->offset = asr->rb.raidtbl;
 	ma->size = ASR_DISK_BLOCK_SIZE * 16;
-	ma->area = (void*) asr->rt;
+	ma->area = asr->rt;
 
 	/* Now set up the rest of the metadata info */
         rd->di = di;
 	rd->fmt = &asr_format;
-
 	rd->status = disk_status(cl);
 	rd->type   = type(cl);
-
 	rd->offset = ASR_DATAOFFSET;
-	rd->sectors = cl->lcapcty;
+	if (!(rd->sectors = cl->lcapcty))
+		return log_zero_sectors(lc, di->path, handler);
 
 	return (rd->name = name(lc, asr)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/asr.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/asr.h	2008/02/22 17:04:35	1.2
@@ -137,7 +137,8 @@
 	uint16_t	blockStorageTid;
 	uint32_t	curAppBlock;
 	uint32_t	appBurstCount;
-	uint8_t		name[16];   /* Full name of the array. */
+#define	ASR_NAMELEN	16
+	uint8_t		name[ASR_NAMELEN];   /* Full name of the array. */
 } __attribute__ ((packed));
 
 struct asr_raidtable
@@ -148,6 +149,7 @@
 	uint32_t	rversion;	/* Version of the RAID config table */
 	uint16_t	maxelm;		/* Maximum number of elements */
 	uint16_t	elmcnt;		/* Element Count (number used) */
+#define	ASR_TBLELMCNT	7
 	uint16_t	elmsize;	/* Size of an individual raidCLine */
 	uint16_t	rchksum;	/* RAID table check sum
 					   (no rconfTblV2)*/
--- dmraid/lib/format/ataraid/hpt37x.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/hpt37x.c	2008/02/22 17:04:35	1.2
@@ -1,4 +1,6 @@
 /*
+ * Highpoint 37X ATARAID series metadata format handler.
+ *
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
@@ -6,8 +8,6 @@
  */
 
 /*
- * Highpoint 37X ATARAID metadata format handler.
- *
  * hpt37x_read(), hpt37x_group() and group_rd() profited from
  * Carl-Daniel Hailfinger's raiddetect code.
  */
@@ -70,21 +70,21 @@
 	return hpt->magic == HPT37X_MAGIC_BAD ? s_broken : s_ok;
 }
 
-/* Mapping of HPT 37X types to generic types. */
-static struct types types[] = {
-	{ HPT37X_T_SINGLEDISK, t_linear},
-	{ HPT37X_T_SPAN, t_linear},
-	{ HPT37X_T_RAID0, t_raid0},
-	{ HPT37X_T_RAID1, t_raid1},
-	{ HPT37X_T_RAID01_RAID0, t_raid0},
-	{ HPT37X_T_RAID01_RAID1, t_raid1},
-	/* FIXME: support RAID 3+5 */
-	{ 0, t_undef}
-};
-
 /* Neutralize disk type. */
 static enum type type(struct hpt37x *hpt)
 {
+	/* Mapping of HPT 37X types to generic types. */
+	static struct types types[] = {
+		{ HPT37X_T_SINGLEDISK, t_linear},
+		{ HPT37X_T_SPAN, t_linear},
+		{ HPT37X_T_RAID0, t_raid0},
+		{ HPT37X_T_RAID1, t_raid1},
+		{ HPT37X_T_RAID01_RAID0, t_raid0},
+		{ HPT37X_T_RAID01_RAID1, t_raid1},
+		/* FIXME: support RAID 3+5 */
+		{ 0, t_undef},
+	};
+
 	return hpt->magic_0 ?
 	       rd_type(types, (unsigned int) hpt->type) : t_spare;
 }
@@ -103,6 +103,16 @@
 	       (META(RD_RS(RS(pos)), hpt37x))->order;
 }
 
+/* Magic check. */
+static int check_magic(void *meta)
+{
+	struct hpt37x *hpt = meta;
+
+	return (hpt->magic == HPT37X_MAGIC_OK ||
+		hpt->magic == HPT37X_MAGIC_BAD) &&
+		hpt->disk_number < 8;
+}
+
 /*
  * Read a Highpoint 37X RAID device.
  */
@@ -113,7 +123,6 @@
 static void to_cpu(void *meta)
 {
 	struct hpt37x *hpt = meta;
-	struct hpt37x_errorlog *l;
 
 	CVT32(hpt->magic);
 	CVT32(hpt->magic_0);
@@ -123,23 +132,25 @@
 	CVT32(hpt->disk_mode);
 	CVT32(hpt->boot_mode);
 
-	for (l = hpt->errorlog;
-	     l < hpt->errorlog + hpt->error_log_entries;
-	     l++) {
-		CVT32(l->timestamp);
-		CVT32(l->lba);
+	/* Only convert error log entries in case we discover proper magic */
+	if (check_magic(meta)) {
+		struct hpt37x_errorlog *l;
+
+		for (l = hpt->errorlog;
+		     l < hpt->errorlog +
+			 min(hpt->error_log_entries, HPT37X_MAX_ERRORLOG);
+		     l++) {
+			CVT32(l->timestamp);
+			CVT32(l->lba);
+		}
 	}
 }
 #endif
 
-/* Magic check. */
+/* Use magic check to tell, if this is Highpoint 37x */
 static int is_hpt37x(struct lib_context *lc, struct dev_info *di, void *meta)
 {
-	struct hpt37x *hpt = meta;
-
-	return (hpt->magic == HPT37X_MAGIC_OK ||
-		hpt->magic == HPT37X_MAGIC_BAD) &&
-		hpt->disk_number < 8;
+	return check_magic(meta);
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
--- dmraid/lib/format/ataraid/hpt37x.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/hpt37x.h	2008/02/22 17:04:35	1.2
@@ -79,6 +79,7 @@
        uint8_t        boot_protect;
        uint8_t        error_log_entries;
        uint8_t        error_log_index;  
+#define	HPT37X_MAX_ERRORLOG	32
        struct hpt37x_errorlog
        {
 	       uint32_t       timestamp;
@@ -90,7 +91,7 @@
 	       uint8_t        status;
 	       uint8_t        sectors;
 	       uint32_t       lba;
-       } errorlog[32];
+       } errorlog[HPT37X_MAX_ERRORLOG];
        uint8_t        filler[60];
 } __attribute__ ((packed));
 #endif
--- dmraid/lib/format/ataraid/hpt45x.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/hpt45x.c	2008/02/22 17:04:35	1.2
@@ -1,4 +1,6 @@
 /*
+ * Highpoint 45X ATARAID series metadata format handler.
+ *
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
@@ -6,8 +8,6 @@
  */
 
 /*
- * Highpoint 45X ATARAID metadata format handler.
- *
  * hpt45x_read(), hpt45x_group() and group_rd() profited from
  * Carl-Daniel Hailfinger's raiddetect code.
  */
@@ -65,18 +65,18 @@
 	return hpt->magic == HPT45X_MAGIC_BAD ? s_broken : s_ok;
 }
 
-/* Mapping of HPT 45X types to generic types */
-static struct types types[] = {
-	{ HPT45X_T_SPAN, t_linear},
-	{ HPT45X_T_RAID0, t_raid0},
-	{ HPT45X_T_RAID1, t_raid1},
-/* FIXME: handle RAID 3+5 */
-	{ 0, t_undef}
-};
-
 /* Neutralize disk type */
 static enum type type(struct hpt45x *hpt)
 {
+	/* Mapping of HPT 45X types to generic types */
+	static struct types types[] = {
+		{ HPT45X_T_SPAN, t_linear},
+		{ HPT45X_T_RAID0, t_raid0},
+		{ HPT45X_T_RAID1, t_raid1},
+		/* FIXME: handle RAID 4+5 */
+		{ 0, t_undef},
+	};
+
 	return hpt->magic_0 ? rd_type(types, (unsigned int) hpt->type) :
 	       t_spare;
 }
--- dmraid/lib/format/ataraid/isw.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/isw.c	2008/02/22 17:04:35	1.2
@@ -1,4 +1,6 @@
 /*
+ * Intel Software RAID metadata format handler.
+ *
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
@@ -6,8 +8,6 @@
  */
 
 /*
- * Intel Software RAID metadata format handler.
- *
  * isw_read() etc. profited from Carl-Daniel Hailfinger's raiddetect code.
  *
  * Profited from the Linux 2.4 iswraid driver by
@@ -101,19 +101,16 @@
 	return s_undef;
 }
 
-/*
- * Mapping of Intel types to generic types.
- */
-static struct types types[] = {
-        { ISW_T_RAID0, t_raid0},
-        { ISW_T_RAID1, t_raid1},
-        { ISW_T_RAID5, t_raid5_la},
-        { 0, t_undef},
-};
-
 /* Neutralize disk type. */
 static enum type type(struct raid_dev *rd)
 {
+	/* Mapping of Intel types to generic types. */
+	static struct types types[] = {
+	        { ISW_T_RAID0, t_raid0},
+	        { ISW_T_RAID1, t_raid1},
+	        { ISW_T_RAID5, t_raid5_la},
+	        { 0, t_undef},
+	};
 	struct isw_dev *dev = rd->private.ptr;
 
 	return dev ? rd_type(types, (unsigned int) dev->vol.map.raid_level) :
@@ -229,7 +226,8 @@
 
 static int is_isw(struct lib_context *lc, struct dev_info *di, struct isw *isw)
 {
-	if (strncmp((const char *) isw->sig, MPB_SIGNATURE, sizeof(MPB_SIGNATURE) - 1))
+	if (strncmp((const char *) isw->sig, MPB_SIGNATURE,
+		    sizeof(MPB_SIGNATURE) - 1))
 		return 0;
 
 	/* Check version info, older versions supported */
@@ -437,9 +435,10 @@
 	r->fmt = rd->fmt;
 	
 	r->offset  = dev->vol.map.pba_of_lba0;
-	r->sectors = dev->vol.map.blocks_per_member;
+	if ((r->sectors = dev->vol.map.blocks_per_member))
+		goto out;
 
-	goto out;
+	log_zero_sectors(lc, rd->di->path, handler);
 
    free:
 	free_raid_dev(lc, &r);
@@ -792,7 +791,8 @@
 	rd->fmt = &isw_format;
 
 	rd->offset = ISW_DATAOFFSET;
-	rd->sectors = info->u64 >> 9;
+	if (!(rd->sectors = info->u64 >> 9))
+		return log_zero_sectors(lc, di->path, handler);
 
 	rd->status = status(lc, rd);
 	rd->type   = t_group;
--- dmraid/lib/format/ataraid/jm.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/jm.c	2008/02/22 17:04:35	1.2
@@ -1,13 +1,12 @@
 /*
+ * JMicron metadata format handler.
+ *
  * Copyright (C) 2006  Heinz Mauelshagen, Red Hat GmbH.
  *                     All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
 
-/*
- * JMicron ATARAID metadata format handler.
- */
 #define	HANDLER "jmicron"
 
 #include "internal.h"
@@ -59,18 +58,18 @@
 	return jm->attribute & ~(JM_MOUNT|JM_BOOTABLE|JM_BADSEC|JM_ACTIVE|JM_UNSYNC|JM_NEWEST) ? s_broken : s_ok;
 }
 
-/* Mapping of JM types to generic types */
-static struct types types[] = {
-	{ JM_T_JBOD, t_linear},
-	{ JM_T_RAID0, t_raid0},
-	{ JM_T_RAID01, t_raid1},
-	{ JM_T_RAID1, t_raid1},
-	{ 0, t_undef}
-};
-
 /* Neutralize disk type */
 static enum type type(struct jm *jm)
 {
+	/* Mapping of JM types to generic types */
+	static struct types types[] = {
+		{ JM_T_JBOD, t_linear},
+		{ JM_T_RAID0, t_raid0},
+		{ JM_T_RAID01, t_raid1},
+		{ JM_T_RAID1, t_raid1},
+		{ 0, t_undef},
+	};
+
 	return rd_type(types, (unsigned int) jm->mode);
 }
 
@@ -83,7 +82,8 @@
         while (count--)
 		sum += *p++;
 
-	return sum;
+	/* FIXME: shouldn't this be one value only ? */
+	return sum == 0 || sum == 1;
 }
 
 static inline unsigned int segment(uint32_t m)
@@ -219,7 +219,7 @@
 
 	return !strncmp((const char*) jm->signature,
 			JM_SIGNATURE, JM_SIGNATURE_LEN)
-	       && !checksum(jm);
+	       && checksum(jm);
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
--- dmraid/lib/format/ataraid/lsi.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/lsi.c	2008/02/22 17:04:35	1.2
@@ -1,4 +1,6 @@
 /*
+ * LSI Logic MegaRAID (and MegaIDE ?) ATARAID metadata format handler.
+ *
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *			    All rights reserved.
  *
@@ -6,10 +8,7 @@
  */
 
 /*
- * LSI Logic MegaRAID (and MegaIDE ?) ATARAID metadata format handler.
- *
- * Needs more metadata reengineering and grouping logic coding.
- *
+ * FIXME: needs more metadata reengineering and grouping logic coding.
  */
 
 #define	HANDLER	"lsi"
@@ -63,17 +62,17 @@
 	return ret;
 }
 
-/* Mapping of LSI Logic types to generic types */
-static struct types types[] = {
-	{ LSI_T_RAID0, t_raid0 },
-	{ LSI_T_RAID1, t_raid1 },
-	{ LSI_T_RAID10, t_raid0 },
-        { 0, t_undef}
-};
-
 /* Neutralize disk type */
 static enum type type(struct lsi *lsi)
 {
+	/* Mapping of LSI Logic types to generic types */
+	static struct types types[] = {
+		{ LSI_T_RAID0, t_raid0 },
+		{ LSI_T_RAID1, t_raid1 },
+		{ LSI_T_RAID10, t_raid0 },
+	        { 0, t_undef}
+	};
+
 	return rd_type(types, (unsigned int) lsi->type);
 }
 
@@ -353,7 +352,8 @@
 
 	rd->offset = LSI_DATAOFFSET;
 	/* FIXME: propper size ? */
-	rd->sectors = rd->meta_areas->offset;
+	if (!(rd->sectors = rd->meta_areas->offset))
+		return log_zero_sectors(lc, di->path, handler);
 
         return (rd->name = name(lc, rd, 1)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/nv.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/nv.c	2008/02/22 17:04:35	1.2
@@ -1,4 +1,6 @@
 /*
+ * NVidia NVRAID metadata format handler.
+ *
  * Copyright (C) 2004      NVidia Corporation. All rights reserved.
  * Copyright (C) 2004,2005 Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
@@ -6,9 +8,6 @@
  * See file LICENSE at the top of this source tree for license information.
  */
 
-/*
- * NVidia NVRAID metadata format handler.
- */
 #define	HANDLER "nvidia"
 
 #include "internal.h"
@@ -62,45 +61,39 @@
 	return ret;
 }
 
-/* Mapping of nv types to generic types */
-static struct types types[] = {
-	{ NV_LEVEL_JBOD, t_linear },
-	{ NV_LEVEL_0, t_raid0 },
-	{ NV_LEVEL_1, t_raid1 },
-	{ NV_LEVEL_1_0, t_raid0 },	/* Treat as 0 here, add mirror later */
-	{ NV_LEVEL_3, t_raid4 },
-	{ NV_LEVEL_5_SYM, t_raid5_ls },
-        { NV_LEVEL_UNKNOWN, t_spare},	/* FIXME: UNKNOWN = spare ? */
-	/* FIXME: The ones below don't really map to anything ?? */
-	{ NV_LEVEL_10, t_undef },
-	{ NV_LEVEL_5, t_undef },    /* Asymmetric RAID 5 is not used */
-};
-
 static enum status status(struct nv *nv)
 {
-	if (NV_BROKEN(nv))
-		return s_broken;
-	
-	switch(nv->array.raidJobCode) {
-	case NV_IDLE:
-		return s_ok;
-
-	case NV_SCDB_INIT_RAID:
-	case NV_SCDB_SYNC_RAID:
-		return s_nosync;
-
-	case NV_SCDB_REBUILD_RAID:
-	case NV_SCDB_UPGRADE_RAID:
-		return s_inconsistent;
-	}
+	static struct states states[] = {
+		{ NV_IDLE, s_ok },
+		{ NV_SCDB_INIT_RAID, s_nosync },
+		{ NV_SCDB_SYNC_RAID, s_nosync },
+		{ NV_SCDB_REBUILD_RAID, s_inconsistent },
+		{ NV_SCDB_UPGRADE_RAID, s_inconsistent },
+		{ 0, s_undef },
+	};
 
-	return s_broken; 
+	return NV_BROKEN(nv) ?
+	       s_broken : rd_status(states, nv->array.raidJobCode, EQUAL);
 }
 
 /* Neutralize disk type using generic metadata type mapping function. */
 static enum type type(struct nv *nv)
 {
 	uint8_t stripeWidth = nv->array.stripeWidth;
+	/* Mapping of nv types to generic types */
+	static struct types types[] = {
+		{ NV_LEVEL_JBOD, t_linear },
+		{ NV_LEVEL_0, t_raid0 },
+		{ NV_LEVEL_1, t_raid1 },
+		/* Treat as 0 here, add mirror later */
+		{ NV_LEVEL_1_0, t_raid0 },
+		{ NV_LEVEL_3, t_raid4 },
+		{ NV_LEVEL_5_SYM, t_raid5_ls },
+	        { NV_LEVEL_UNKNOWN, t_spare},	/* FIXME: UNKNOWN = spare ? */
+		/* FIXME: The ones below don't really map to anything ?? */
+		{ NV_LEVEL_10, t_undef },
+		{ NV_LEVEL_5, t_undef },    /* Asymmetric RAID 5 is not used */
+	};
 
 	/*
 	 * FIXME: is there a direct way to decide what
@@ -426,7 +419,8 @@
 	rd->type   = type(nv);
 
 	rd->offset = NV_DATAOFFSET;
-	rd->sectors = rd->meta_areas->offset;
+	if (!(rd->sectors = rd->meta_areas->offset))
+		return log_zero_sectors(lc, di->path, handler);
 
         return (rd->name = name(lc, rd, 1)) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/pdc.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/pdc.c	2008/02/22 17:04:35	1.2
@@ -1,4 +1,6 @@
 /*
+ * Promise FastTrak ATARAID metadata format handler.
+ *
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
@@ -6,8 +8,6 @@
  */
 
 /*
- * Promise FastTrak ATARAID metadata format handler.
- *
  * pdc_read() and pdc_group() profited from
  * Carl-Daniel Hailfinger's raiddetect code.
  */
@@ -65,18 +65,7 @@
 	return PDC_BROKEN(pdc) ? s_broken : s_ok;
 }
 
-/*
- * Mapping of Promise types to generic types.
- */
 #define	PDC_T_RAID10	0x2	/* Not defind by Promise (yet). */
-static struct types types[] = {
-        { PDC_T_SPAN,   t_linear},
-        { PDC_T_RAID0,  t_raid0},
-        { PDC_T_RAID1,  t_raid1},
-        { PDC_T_RAID10, t_raid0},
-        { 0, t_undef}
-};
-
 static int is_raid10(struct pdc *pdc)
 {
 	return pdc->raid.type == PDC_T_RAID10 ||
@@ -86,6 +75,15 @@
 /* Neutralize disk type */
 static enum type type(struct pdc *pdc)
 {
+	/* Mapping of Promise types to generic types. */
+	static struct types types[] = {
+	        { PDC_T_SPAN,   t_linear},
+	        { PDC_T_RAID0,  t_raid0},
+	        { PDC_T_RAID1,  t_raid1},
+	        { PDC_T_RAID10, t_raid0},
+	        { 0, t_undef}
+	};
+
 	if (is_raid10(pdc))
 		pdc->raid.type = PDC_T_RAID10;
 
--- dmraid/lib/format/ataraid/sil.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/sil.c	2008/02/22 17:04:35	1.2
@@ -1,13 +1,12 @@
 /*
+ * Silicon Image Medley ATARAID metadata format handler.
+ *
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
 
-/*
- * Silicon Image Medley ATARAID metadata format handler.
- */
 #define	HANDLER	"sil"
 
 #include "internal.h"
@@ -58,31 +57,30 @@
  */
 static enum status status(struct sil *sil)
 {
-	switch (sil->mirrored_set_state) {
-	case SIL_OK:
-	case SIL_MIRROR_SYNC:
-		return s_ok;
-
-	case SIL_MIRROR_NOSYNC:
-		return s_nosync;
-	}
+	struct states states[] = {
+		{ SIL_OK, s_ok },
+		{ SIL_MIRROR_SYNC, s_ok },
+		{ SIL_MIRROR_NOSYNC, s_nosync },
+		{ 0, s_broken },
+	};
 
-	return s_broken;
+	return rd_status(states, sil->mirrored_set_state, EQUAL);
 }
 
-/* Mapping of SIL 680 types to generic types */
-static struct types types[] = {
-        { SIL_T_SPARE,  t_spare},
-        { SIL_T_RAID0,  t_raid0},
-        { SIL_T_RAID5, 	t_raid5_ls},
-        { SIL_T_RAID1,  t_raid1},
-        { SIL_T_RAID10, t_raid0},
-        { 0,            t_undef}
-};
-
 /* Neutralize disk type */
 static enum type type(struct sil *sil)
 {
+	/* Mapping of SIL 680 types to generic types */
+	static struct types types[] = {
+	        { SIL_T_SPARE,  t_spare},
+	        { SIL_T_JBOD,   t_linear},
+	        { SIL_T_RAID0,  t_raid0},
+	        { SIL_T_RAID5, 	t_raid5_ls},
+	        { SIL_T_RAID1,  t_raid1},
+	        { SIL_T_RAID10, t_raid0},
+	        { 0,            t_undef}
+	};
+
 	return rd_type(types, (unsigned int) sil->type);
 }
 
@@ -179,8 +177,6 @@
 	if (!(sils = dbg_malloc(AREAS * sizeof(*sils))))
 		goto out;
 
-	memset(sils, 0, AREAS * sizeof(*sils));
-
 	/* Read the 4 metadata areas. */
 	for (i = valid = 0; i < AREAS; i++) {
 		if (!(sil = alloc_private_and_read(lc, handler, sizeof(*sil),
@@ -316,6 +312,7 @@
 	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
 
 	switch (sil->type) {
+	case SIL_T_JBOD:
 	case SIL_T_RAID0:
 	case SIL_T_RAID1:
 	case SIL_T_RAID5:
@@ -533,35 +530,37 @@
 static struct sil *quorate(struct lib_context *lc, struct dev_info *di,
 			   struct sil *sils[])
 {
-	unsigned int areas = 0, i, j;
-	struct sil *sil;
+	unsigned int areas = 0, i, ident = 0, j;
+	struct sil *sil = NULL, *tmp;
 	
 	/* Count valid metadata areas. */
-	while (areas < AREAS && sils[areas++]);
-
-	if (areas == AREAS)
-		goto out;
+	while (areas < AREAS && sils[areas])
+		areas++;
 
-	log_err(lc, "%s: only %u/%u metadata areas found on %s, %sing...",
-		handler, areas, AREAS, di->path, areas > 1 ? "elect" : "pick");
+	if (areas != AREAS)
+		log_err(lc, "%s: only %u/%u metadata areas found on "
+			    "%s, %sing...",
+			handler, areas, AREAS, di->path,
+			areas > 1 ? "elect" : "pick");
 
 	/* Identify maximum identical copies. */
 	for (i = 0; i < areas; i++) {
-		for (j = i + 1, sil = sils[i]; j < areas; j++) {
+		for (ident = 0, j = i + 1, sil = sils[i]; j < areas; j++) {
 			if (!memcmp(sil, sils[j], sizeof(*sil)))
-				goto end;
+				ident++;
 		}
+
+		if (ident > areas / 2);
+			break;
 	}
 
-   end:
-	if (i) {
-		sil = sils[0];
-		sils[0] = sils[i];
-		sils[i] = sil;
+	if (ident) {
+		tmp = sils[0];
+		sils[0] = sil;
+		sils[i] = tmp;
 	}
 
-   out:
-	return sils[0];
+	return sil;
 }
 
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
--- dmraid/lib/format/ataraid/sil.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/sil.h	2008/02/22 17:04:35	1.2
@@ -50,6 +50,7 @@
 #define	SIL_T_RAID10	2
 #define	SIL_T_RAID5	16
 #define	SIL_T_SPARE	3
+#define	SIL_T_JBOD	255
 	int8_t		drives_per_striped_set;	/* 0x118 */
 	int8_t		striped_set_number;	/* 0x119 */
         int8_t		drives_per_mirrored_set;/* 0x11A */
--- dmraid/lib/format/ataraid/via.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/via.c	2008/02/22 17:04:35	1.2
@@ -1,13 +1,12 @@
 /*
+ * VIA metadata format handler.
+ *
  * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file DISCLAIMER at the top of this source tree for license information.
  */
 
-/*
- * VIA metadata format handler.
- */
 #define	HANDLER	"via"
 
 #include "internal.h"
@@ -95,18 +94,18 @@
 	return via->array.disk.in_disk_array ? s_ok : s_undef;
 }
 
-/* Mapping of via types to generic types */
-static struct types types[] = {
-	{ VIA_T_SPAN,  t_linear },
-	{ VIA_T_RAID0, t_raid0 },
-	{ VIA_T_RAID1, t_raid1 },
-	{ VIA_T_RAID01, t_raid0 },
-        { 0, t_undef}
-};
-
 /* Neutralize disk type using generic metadata type mapping function */
 static enum type type(struct via *via)
 {
+	/* Mapping of via types to generic types */
+	static struct types types[] = {
+		{ VIA_T_SPAN,  t_linear },
+		{ VIA_T_RAID0, t_raid0 },
+		{ VIA_T_RAID1, t_raid1 },
+		{ VIA_T_RAID01, t_raid0 },
+	        { 0, t_undef}
+	};
+
 	return rd_type(types, (unsigned int) VIA_RAID_TYPE(via));
 }
 
@@ -142,7 +141,6 @@
 	while (i--)
 		sum += ((uint8_t*) via)[i];
 
-printf("sum=%u via->checksum=%u\n", sum, via->checksum);
 	return sum == via->checksum;
 }
 
@@ -407,7 +405,8 @@
 	rd->type   = type(via);
 
 	rd->offset = VIA_DATAOFFSET;
-	rd->sectors = rd->meta_areas->offset;
+	if (!(rd->sectors = rd->meta_areas->offset))
+		return log_zero_sectors(lc, di->path, handler);
 
         return (rd->name = name(lc, rd, 1)) ? 1 : 0;
 }
/cvs/dm/dmraid/lib/format/ddf/README,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/README
+++ -	2008-02-22 17:04:40.236923000 +0000
@@ -0,0 +1,3 @@
+
+This directory contains the SNIA DDF1 metadata format handler
+
/cvs/dm/dmraid/lib/format/ddf/ddf1.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1.c
+++ -	2008-02-22 17:04:41.194337000 +0000
@@ -0,0 +1,966 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+
+#define	FORMAT_HANDLER
+#include "ddf1.h"
+#include "ddf1_lib.h"
+#include "ddf1_crc.h"
+#include "ddf1_cvt.h"
+#include "ddf1_dump.h"
+
+static const char *handler = HANDLER;
+
+#define	DDF1_SPARES	".ddf1_spares"
+#define	DDF1_DISKS	(char*) ".ddf1_disks"
+
+/* PCI IDs for Adaptec */
+// #define PCI_VENDOR_ID_ADAPTEC		0x9004
+#define PCI_VENDOR_ID_ADAPTEC2		0x9005
+
+/* Map DDF1 disk status to dmraid status */
+static enum status disk_status(struct ddf1_phys_drive *disk) {
+	struct states states[] = {
+		{ 0x72, s_broken },
+		{ 0x04, s_nosync },
+		{ 0x08, s_setup },
+		{ 0x01, s_ok },
+		{ 0, s_undef },
+	};
+
+	return disk ? rd_status(states, disk->state, AND) : s_undef;
+}
+
+/*
+ * Compare two GUIDs.  For some reason, Adaptec sometimes writes 0xFFFFFFFF
+ * as the last four bytes (ala DDF2) and sometimes writes real data.
+ * For now we'll compare the first twenty and only the last four if
+ * both GUIDs don't have 0xFFFFFFFF in bytes 20-23.  Gross.
+ */
+/* Find this drive's physical data */
+static struct ddf1_phys_drive *get_phys_drive(struct ddf1 *ddf1)
+{
+	unsigned int i = ddf1->pd_header->max_drives;
+
+	while (i--) {
+		if (ddf1->pds[i].reference == ddf1->disk_data->reference)
+			return ddf1->pds + i;
+	}
+
+	return NULL;
+}
+
+/* Find the virtual drive that goes with this config record */
+static struct ddf1_virt_drive *get_virt_drive(struct ddf1 *ddf1,
+					      struct ddf1_config_record *cr)
+{
+	int i = ddf1->vd_header->num_drives;
+
+	while (i--) {
+		if (!guidcmp(ddf1->vds[i].guid, cr->guid))
+			return ddf1->vds + i;
+	}
+
+	return NULL;
+}
+
+/*
+ * Find the index of the VD config record given a physical drive and offset.
+ */
+static int get_config_byoffset(struct ddf1 *ddf1, struct ddf1_phys_drive *pd,
+				 uint64_t offset)
+{
+	int cfgs = NUM_CONFIG_ENTRIES(ddf1), i;
+	uint32_t *cfg_drive_ids, j;
+	uint64_t *cfg_drive_offsets;
+	struct ddf1_config_record *cfg;
+
+	for (i = 0; i < cfgs; i++) {
+		cfg = CR(ddf1, i);
+		if (cfg->signature == DDF1_VD_CONFIG_REC) {
+			cfg_drive_ids = CR_IDS(ddf1, cfg);
+			cfg_drive_offsets = CR_OFF(ddf1, cfg);
+			for (j = 0; j < cfg->primary_element_count; j++) {
+				if (cfg_drive_ids[j] == pd->reference &&
+				    cfg_drive_offsets[j] == offset)
+					return i;
+			}
+		}
+	}
+
+	return -ENOENT;
+}
+
+/* Find the index of the nth VD config record for this physical drive. */
+static int get_config_index(struct ddf1 *ddf1, struct ddf1_phys_drive *pd,
+			    unsigned int *n)
+{
+	int cfgs = NUM_CONFIG_ENTRIES(ddf1), i, j, nn = *n;
+	uint32_t *ids;
+	struct ddf1_config_record *cr;
+
+	for (i = 0; i < cfgs; i++) {
+		cr = CR(ddf1, i);
+		if (cr->signature == DDF1_VD_CONFIG_REC) {
+			ids = CR_IDS(ddf1, cr);
+			for (j = 0; j < cr->primary_element_count; j++) {
+				if (ids[j] == pd->reference && !nn--)
+						return i;
+			}
+		}
+	}
+
+	*n -= nn;
+	return nn < 0 ? -ENOENT : 0;
+}
+
+/*
+ * Find the nth VD config record for this physical drive.
+ */
+static inline struct ddf1_config_record *get_config(struct ddf1 *ddf1,
+						    struct ddf1_phys_drive *pd,
+						    unsigned int n)
+{
+	int i = get_config_index(ddf1, pd, &n);
+
+	return i < 0 ? NULL : CR(ddf1, i);
+}
+ 
+/* Find a config record for this drive, given the offset of the array. */
+static inline struct ddf1_config_record *get_this_config(struct ddf1 *ddf1,
+							 uint64_t offset)
+{
+	struct ddf1_phys_drive *pd = get_phys_drive(ddf1);
+	int i = get_config_byoffset(ddf1, pd, offset);
+
+	return i < 0 ? NULL : get_config(ddf1, pd, i);
+}
+
+/* Find the config record disk/offset entry for this config/drive. */
+static int get_offset_entry(struct ddf1 *ddf1, struct ddf1_config_record *cr,
+			    struct ddf1_phys_drive *pd)
+{
+	int i;
+	uint32_t *ids;
+
+	if (cr) {
+		ids = CR_IDS(ddf1, cr);
+		for (i = 0; i < ddf1->primary->max_phys_drives; i++) {
+			if (ids[i] == pd->reference)
+				return i;
+		}
+	}
+
+	return -ENOENT;
+}
+
+/* Find the offset for this config/drive. */
+static uint64_t get_offset(struct ddf1 *ddf1, struct ddf1_config_record *cr,
+			   struct ddf1_phys_drive *pd)
+{
+	int i = get_offset_entry(ddf1, cr, pd);
+
+	return i < 0 ? pd->size : CR_OFF(ddf1, cr)[i];
+}
+
+/* Calculate the stripe size, in sectors */
+static inline unsigned int stride(struct ddf1_config_record *cr)
+{
+	return to_bytes(1) >> 9 << cr->stripe_size;
+}
+
+/* Map the DDF1 raid type codes into dmraid type codes. */
+static enum type type(struct lib_context *lc, struct ddf1 *ddf1,
+		      struct ddf1_config_record *cr)
+{
+	unsigned int l;
+	struct types *t;
+	/* Mapping of template types to generic types */
+	static struct types types[] = {
+		{ DDF1_RAID0,	t_raid0 },
+		{ DDF1_RAID1,	t_raid1 },
+		{ DDF1_RAID4,	t_raid4 },
+		{ DDF1_CONCAT,	t_linear },
+		{ DDF1_JBOD,	t_linear },
+		{ 0, t_undef}
+	};
+	/* Seperate array for RAID5 qualifiers */
+	static struct types qualifier_types[] = {
+		/* FIXME: Is RLQ=0 really right symmetric? */
+		{ DDF1_RAID5_RS, t_raid5_rs },
+		{ DDF1_RAID5_LA, t_raid5_la },
+		{ DDF1_RAID5_LS, t_raid5_ls },
+		{ 0, t_undef}
+	};
+
+	if (!cr)
+		return t_undef;
+
+	l = cr->raid_level;
+	if (l == DDF1_RAID5) {
+		/*
+		 * FIXME: Do _all_ Adaptec controllers use left
+		 * asymmetric parity and write zero to RLQ?
+		 */
+		if (ddf1->adaptec_mode)
+			return t_raid5_la;
+
+		l = cr->raid_qualifier;
+		t = qualifier_types;
+	} else
+		t = types;
+
+	return rd_type(t, l);
+}
+
+/* Read the whole metadata chunk at once */
+static uint8_t *read_metadata_chunk(struct lib_context *lc, struct dev_info *di,
+				    uint64_t start)
+{
+	uint8_t *ret;
+	size_t size = to_bytes(di->sectors - start);
+
+	if (!(ret = alloc_private(lc, handler, size)))
+		return NULL;
+
+	if (!read_file(lc, handler, di->path, ret, size, to_bytes(start))) {
+		dbg_free(ret);
+		LOG_ERR(lc, NULL, "%s: unable to read metadata off %s",
+			handler, di->path);
+	}
+
+	return ret;
+}
+
+static inline void cond_free(void *p)
+{
+	if (p)
+		dbg_free(p);
+}
+
+/* Reused error message */
+static inline void *err_drive(struct lib_context *lc, struct dev_info *di,
+			      const char *what)
+{
+	LOG_ERR(lc, NULL, "%s: cannot find %s drive record on %s",
+		handler, what, di->path);
+}
+
+static void *err_phys_drive(struct lib_context *lc, struct dev_info *di)
+{
+	return err_drive(lc, di, "physical");
+}
+
+static void *err_virt_drive(struct lib_context *lc, struct dev_info *di)
+{
+	return err_drive(lc, di, "virtual");
+}
+
+/*
+ * Read a DDF1 RAID device.  Fields are little endian, so
+ * need to convert them if we're on a BE machine (ppc, etc).
+ */
+static int read_extended(struct lib_context *lc, struct dev_info *di,
+			 struct ddf1 *ddf1)
+{
+	int i;
+	uint64_t where;
+	size_t size;
+	struct ddf1_header *pri, *sec;
+	struct ddf1_adapter *adap;
+	struct ddf1_disk_data *ddata;
+	struct ddf1_phys_drives *pd;
+	struct ddf1_virt_drives *vd;
+
+
+	/* Read the primary DDF header */
+	where = to_bytes(ddf1->anchor.primary_table_lba);
+	if (!(pri = ddf1->primary =
+	      alloc_private_and_read(lc, handler, sizeof(*pri),
+				     di->path, where)))
+		goto bad;
+
+	/* Read the secondary header. */
+	ddf1_cvt_header(ddf1, pri);
+	if (!(sec = ddf1->secondary = alloc_private(lc, handler, sizeof(*sec))))
+		goto bad;
+
+	where = to_bytes(ddf1->anchor.secondary_table_lba);
+	if (ddf1->anchor.secondary_table_lba != 0xFFFFFFFFFFFFFFFFULL &&
+	    !read_file(lc, handler, di->path, sec, sizeof(*sec), where))
+		goto bad;
+
+	ddf1_cvt_header(ddf1, sec);
+	if (pri->signature != DDF1_HEADER) {
+		log_warn(lc, "%s: incorrect primary header signature %x on",
+			 handler, pri->signature, di->path);
+		cond_free(ddf1->primary);
+		ddf1->primary = NULL;
+	};
+	
+	if (sec->signature == DDF1_HEADER) {
+		/* If we encounter an error, we use the secondary table */
+		if (!ddf1->primary) {
+			log_warn(lc, "%s: using secondary header on %s",
+				 handler, di->path);
+			ddf1->primary = ddf1->secondary;
+			ddf1->secondary = NULL;
+		}
+	} else {
+		if (sec->signature)
+			log_warn(lc, "%s: bad secondary header signature %x "
+				     "on %s",
+				 handler, sec->signature, di->path);
+
+		dbg_free(sec);
+		ddf1->secondary = NULL;
+	}
+
+	if (!ddf1->primary) {
+		log_error(lc, "%s: both header signatures bad on %s",
+			  handler, di->path);
+		goto bad;
+	}
+
+	/* Read the adapter data */
+	if (!(adap = ddf1->adapter = alloc_private(lc, handler, sizeof(*adap))))
+		goto bad;
+
+	where = to_bytes(pri->primary_table_lba + pri->adapter_data_offset);
+	if (pri->adapter_data_offset != 0xFFFFFFFF &&
+	    !read_file(lc, handler, di->path, adap, sizeof(*adap), where))
+		goto bad;
+
+	ddf1_cvt_adapter(ddf1, ddf1->adapter);
+	if (ddf1->adapter->signature != DDF1_ADAPTER_DATA) {
+		if (ddf1->adapter->signature)
+			log_warn(lc, "%s: incorrect adapter data signature %x "
+				     "on %s",
+				 handler, ddf1->adapter->signature, di->path);
+		dbg_free(ddf1->adapter);
+		ddf1->adapter = NULL;
+	}
+
+	if (ddf1->adapter &&
+	    ddf1->adapter->pci_vendor == PCI_VENDOR_ID_ADAPTEC2) {
+		log_notice(lc, "%s: Adaptec mode discvered on %s",
+			   handler, di->path);
+		ddf1->adaptec_mode = 1;
+	}
+
+	/* Read physical drive characteristic data */
+	where = to_bytes(pri->primary_table_lba + pri->disk_data_offset);
+	if (!(ddata = ddf1->disk_data =
+	      alloc_private_and_read(lc, handler, sizeof(*ddata),
+				     di->path, where)))
+		goto bad;
+
+	/*
+	 * This table isn't technically required, but for now we rely
+	 * on it to give us a key into the physical drive table.
+	 */
+	ddf1_cvt_disk_data(ddf1, ddata);
+	if (ddata->signature != DDF1_FORCED_PD_GUID) {
+		log_warn(lc, "%s: incorrect disk data signature %x on %s",
+			 handler, ddata->signature, di->path);
+		goto bad;
+	}
+
+	/* Read physical drive data header */
+	where = to_bytes(pri->primary_table_lba + pri->phys_drive_offset);
+	size = to_bytes(pri->phys_drive_len);
+	if (!(pd = ddf1->pd_header =
+	      alloc_private_and_read(lc, handler, size, di->path, where)))
+		goto bad;
+
+	ddf1_cvt_phys_drive_header(ddf1, pd);
+	if (pd->signature != DDF1_PHYS_DRIVE_REC) {
+		err_phys_drive(lc, di);
+		goto bad;
+	}
+
+	/* Now read the physical drive data */
+	ddf1->pds = (struct ddf1_phys_drive *)(((uint8_t *)ddf1->pd_header) +
+		    sizeof (*pd));
+	for (i = 0; i < pd->num_drives; i++) {
+		ddf1_cvt_phys_drive(ddf1, &ddf1->pds[i]);
+		/*
+		 * Adaptec controllers have a weird bug where this field is
+		 * only four bytes ... and the next four are 0xFF.
+		 */
+		if (ddf1->pds[i].size >> 32 == 0xFFFFFFFF)
+			ddf1->pds[i].size &= 0xFFFFFFFF;
+	}
+
+	/* Read virtual drive data header */
+	where = to_bytes(pri->primary_table_lba + pri->virt_drive_offset);
+	size = to_bytes(pri->phys_drive_len);
+	if (!(vd = ddf1->vd_header =
+	      alloc_private_and_read(lc, handler, size, di->path, where)))
+		goto bad;
+
+	ddf1_cvt_virt_drive_header(ddf1, vd);
+	if (vd->signature != DDF1_VIRT_DRIVE_REC) {
+		err_virt_drive(lc, di);
+		goto bad;
+	}
+
+	/* Now read the virtual drive data */
+	ddf1->vds = (struct ddf1_virt_drive*)(((uint8_t*) vd) + sizeof (*pd));
+	for (i = 0; i < vd->num_drives; i++)
+		ddf1_cvt_virt_drive(ddf1, &ddf1->vds[i]);
+
+	/* Read config data */
+	where = to_bytes(pri->primary_table_lba + pri->config_record_offset);
+	size = to_bytes(pri->config_record_len);
+	if (!(ddf1->cfg = alloc_private_and_read(lc, handler, size,
+						 di->path, where)))
+		goto bad;
+
+	/*
+	 * Ensure each record is: a config table for VDs; a config table for
+	 * spare disks; or vendor-specifc data of some sort.
+	 */
+	ddf1_cvt_records(lc, di, ddf1, 1);
+
+	/*
+	 * FIXME: We don't pick up diagnostic logs, vendor specific logs,
+	 * bad block data, etc.  That shouldn't cause a problem with reading
+	 * or writing metadata, but at some point we might want to do something
+	 * with them.
+	 */
+	ddf1->in_cpu_format = 1;
+
+	/* FIXME: We should verify the checksums for all modes */
+	if (ddf1->adaptec_mode &&
+	    !(ddf1_check_all_crcs(lc, di, ddf1)))
+		goto bad;
+
+	return 1;
+
+bad:
+	ddf1->vds = NULL;
+	ddf1->pds = NULL;
+	cond_free(ddf1->cfg);
+	cond_free(ddf1->pd_header);
+	cond_free(ddf1->disk_data);
+	cond_free(ddf1->adapter);
+	cond_free(ddf1->secondary);
+	cond_free(ddf1->primary);
+	return 0;
+}
+
+/* Count the number of raid_devs we need to create for this drive */
+static unsigned int num_devs(struct lib_context *lc, void *meta)
+{
+	struct ddf1 *ddf1 = meta;
+	unsigned int num_drives = ~0;
+	
+	get_config_index(ddf1, get_phys_drive(ddf1), &num_drives);
+	return num_drives;
+}
+
+/* Is this DDF1 metadata? */
+static inline int is_ddf1(struct lib_context *lc, struct dev_info *di,
+			  struct ddf1 *ddf1)
+{
+	/*
+	 * Check our magic numbers and that the version == v2.
+	 * We don't support anything other than that right now.
+	 */
+
+	/* FIXME: We should examine the version headers... */
+	return ddf1->anchor.signature == DDF1_HEADER ||
+	       ddf1->anchor.signature == DDF1_HEADER_BACKWARDS;
+}
+
+/* Try to find DDF1 metadata at a given offset (ddf1_sboffset) */
+static struct ddf1 *try_to_find_ddf1(struct lib_context *lc,
+				     struct dev_info *di,
+				     size_t *sz, uint64_t *offset,
+				     union read_info *info,
+				     uint64_t ddf1_sboffset)
+{
+	struct ddf1 *ddf1;
+
+	/*
+	 * Try to find a DDF1 anchor block at ddf1_sboffset.  In theory this
+	 * should be the very last block, but some Adaptec controllers have
+	 * issues with standards compliance.  So we have to try with various
+	 * offsets.
+	 */
+	if (!(ddf1 = alloc_private(lc, handler, sizeof(*ddf1))))
+		goto err;
+
+	if (!read_file(lc, handler, di->path, &ddf1->anchor, to_bytes(1),
+		       ddf1_sboffset) ||
+	    !is_ddf1(lc, di, ddf1))
+		goto bad;
+
+	ddf1->anchor_offset = ddf1_sboffset;
+
+	/* Convert endianness */
+	ddf1->in_cpu_format = 0;
+	if ((ddf1->disk_format = ddf1_endianness(lc, ddf1)) < 0)
+		goto bad;
+	ddf1_cvt_header(ddf1, &ddf1->anchor);
+
+	/* Read extended metadata. */
+	if (read_extended(lc, di, ddf1))
+		return ddf1;
+
+   bad:
+	dbg_free(ddf1);
+   err:
+	return NULL;
+}
+
+/*
+ * Attempt to interpret DDF1 metadata from a block device.  This function
+ * returns either NULL or a pointer to a descriptor struct.
+ * Note that the struct should be fully converted to the correct endianness
+ * by the time this function returns.
+ */
+static void *read_metadata_areas(struct lib_context *lc, struct dev_info *di,
+				 size_t *sz, uint64_t *offset,
+				 union read_info *info)
+{
+	struct ddf1 *ddf1;
+
+	if (!(ddf1 = try_to_find_ddf1(lc, di, sz, offset,
+				      info, DDF1_CONFIGOFFSET))) {
+		if ((ddf1 = try_to_find_ddf1(lc, di, sz, offset,
+					     info, DDF1_CONFIGOFFSET_ADAPTEC)))
+			ddf1->adaptec_mode = 1;
+	}
+
+	return ddf1;
+}
+
+/* This is all hogwash since file_metadata can only be called once... */
+static void file_metadata_areas(struct lib_context *lc, struct dev_info *di,
+				void *meta)
+{
+	uint8_t *buf;
+	uint64_t start = ddf1_beginning(meta);
+
+	if ((buf = read_metadata_chunk(lc, di, start))) {
+		/* Record metadata. */
+		file_metadata(lc, handler, di->path, buf,
+			      to_bytes(di->sectors - start), to_bytes(start));
+		dbg_free(buf);
+		file_dev_size(lc, handler, di); /* Record the device size. */
+	}
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *ddf1_read(struct lib_context *lc,
+					struct dev_info *di)
+{
+	/*
+	 * NOTE: Everything called after read_metadata_areas assumes that
+	 * the reserved block, raid table and config table have been
+	 * converted to the appropriate endianness.
+	 */
+	return read_raid_dev(lc, di, read_metadata_areas, 0, 0, NULL, NULL,
+			     file_metadata_areas, setup_rd, handler);
+}
+
+/* Compose an "identifier" for use as a sort key for raid sets. */
+static inline int compose_id(struct ddf1 *ddf1, struct raid_dev *rd)
+{
+	struct ddf1_phys_drive *pd = get_phys_drive(ddf1);
+	int i = get_config_byoffset(ddf1, pd, rd->offset);
+
+	return i < 0 ? -1 : get_offset_entry(ddf1, get_config(ddf1, pd, i), pd);
+}
+
+/* No sort. */
+static int no_sort(struct list_head *pos, struct list_head *new)
+{
+	return 0;
+}
+
+/* Sort DDF1 devices by offset entry within a RAID set. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return compose_id(META(RD(new)->private.ptr, ddf1), RD(new)) <
+	       compose_id(META(RD(pos)->private.ptr, ddf1), RD(pos));
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	log_err(lc, "%s: I/O error on device %s at sector %lu.\n",
+		handler, e_io->rd->di->path, e_io->sector);
+
+	LOG_ERR(lc, 0, "%s: PANIC - don't know about event_io!", handler);
+}
+
+#if 0
+	/* FIXME: This should not use META() directly? */
+	struct raid_dev *rd = e_io->rd;
+	struct ddf1 *ddf1 = META(rd, ddf1);
+	struct ddf1_raid_configline *cl = this_disk(ddf1);
+	struct ddf1_raid_configline *fwl = find_logical(ddf1);
+
+	/* Ignore if we've already marked this disk broken(?) */
+	if (rd->status & s_broken)
+		return 0;
+	
+	/* Mark the array as degraded and the disk as failed. */
+	rd->status = s_broken;
+	cl->raidstate = LSU_COMPONENT_STATE_FAILED;
+	fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
+	/* FIXME: Do we have to mark a parent too? */
+
+	/* Indicate that this is indeed a failure. */
+	return 1;
+}
+#endif
+
+#define NAME_SIZE 64
+/* Formulate a RAID set name for this disk. */
+static char *name(struct lib_context *lc, struct ddf1 *ddf1,
+		  struct raid_dev *rd)
+{
+	int i, prefix;
+	char buf[NAME_SIZE];
+	struct ddf1_phys_drive *pd;
+	struct ddf1_virt_drive *vd;
+	struct ddf1_config_record *cr;
+
+	if (!(pd = get_phys_drive(ddf1)))
+		return err_phys_drive(lc, rd->di);
+
+	i = get_config_byoffset(ddf1, pd, rd->offset);
+ 	cr = get_config(ddf1, pd, i);
+ 	if (i < 0 || !cr) {
+		sprintf(buf, DDF1_SPARES);
+		goto out;
+	}
+
+	if (!(vd = get_virt_drive(ddf1, cr)))
+		return err_virt_drive(lc, rd->di);
+
+	sprintf(buf, "%s_", handler);
+	prefix = strlen(buf);
+
+	if (vd->name[0]) {
+		memcpy(buf + prefix, vd->name, 16);
+		i = prefix + 16;
+		while (!isgraph(buf[--i]));
+		buf[i+1] = 0;
+	} else {
+		char *b;
+
+		for (b = buf + prefix, i = 0; i < 24; b += 8, i += 4)
+			sprintf(b, "%02x%02x%02x%02x",
+				vd->guid[i], vd->guid[i+1],
+			        vd->guid[i+2], vd->guid[i+3]);
+	}
+
+   out:
+	return dbg_strdup(buf); /* Only return the needed allocation */
+}
+
+/* Figure out the real size of a disk... */
+static uint64_t get_size(struct lib_context *lc, struct ddf1 *ddf1,
+			 struct ddf1_config_record *cr,
+			 struct ddf1_phys_drive *pd)
+{
+	if (cr)
+		/* Some Adaptec controllers need this clamping. */
+		return type(lc, ddf1, cr) == t_raid0 ?
+		       cr->sectors - cr->sectors % stride(cr) : cr->sectors;
+
+	return pd->size;
+}
+
+/*
+ * Create all the volumes of a DDF1 disk as subsets of the top level DDF1
+ * disk group.  rs_group points to that raid subset and is returned if the
+ * function is successful, NULL if not.  rd_group is the raid device that
+ * represents the entire disk drive.
+ */
+static struct raid_set *group_rd(struct lib_context *lc,
+				 struct raid_set *rs_group,
+				 struct raid_dev *rd_group)
+{
+	struct ddf1 *ddf1 = META(rd_group, ddf1);
+	struct raid_set *rs = NULL;
+	struct raid_dev *rd;
+	struct ddf1_config_record *cr;
+	struct ddf1_phys_drive *pd;
+	unsigned int devs, i;
+	
+	if (!(pd = get_phys_drive(ddf1)))
+		return err_phys_drive(lc, rd_group->di);
+
+	devs = num_devs(lc, ddf1);
+	for (i = 0; i < devs; i++) {
+		/* Allocate a raid_dev for this volume */
+		if (!(rd = alloc_raid_dev(lc, handler)))
+			return NULL;
+
+		cr = get_config(ddf1, pd, i);
+		rd->di = rd_group->di;
+		rd->fmt = rd_group->fmt;
+		rd->type = type(lc, ddf1, cr);
+		if (!(rd->sectors = get_size(lc, ddf1, cr, pd))) {
+			log_zero_sectors(lc, rd->di->path, handler);
+			free_raid_dev(lc, &rd);
+			continue;
+		}
+
+		rd->offset = get_offset(ddf1, cr, pd);
+
+		/*
+		 * If we have a virtual drive config without an entry in the
+		 * list of virtual drives, we ignore it.  Weird bug seen on
+		 * Adaptec 2410SA controller.
+		*/
+		if (!(rd->name = name(lc, ddf1, rd))) {
+			free_raid_dev(lc, &rd);
+			continue;
+		}
+
+		/* Stuff it into the appropriate raid set. */
+		if (!(rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL,
+						  rd, &rs_group->sets,
+						  NO_CREATE, NO_CREATE_ARG))) {
+			free_raid_dev(lc, &rd);
+			return NULL;
+		}
+
+		/* Keep reference to the entire device for ddf1_check() */
+		rd->private.ptr = rd_group;
+
+		/* Add rest of subset state */
+		rs->stride = stride(cr);
+		rs->type = type(lc, ddf1, cr);
+		rs->status = s_ok;
+
+		/* Sort device into subset */
+		list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+	}
+
+	return rs_group;
+}
+
+/* 
+ * Add a DDF1 device to a RAID set.  This involves finding the raid set to
+ * which this disk belongs, and then attaching it.  Note that there are other
+ * complications, such as two-layer arrays (RAID10).
+ *
+ * FIXME: We haven't been able to set up a RAID10 for testing...
+ */
+static struct raid_set *ddf1_group(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct ddf1 *ddf1 = META(rd, ddf1);
+	struct ddf1_phys_drive *pd;
+	struct raid_set *rs;
+
+	if (!(pd = get_phys_drive(ddf1)))
+		return err_phys_drive(lc, rd->di);
+
+	if (!rd->name)
+		LOG_ERR(lc, NULL, "%s: no RAID array name on %s",
+			handler, rd->di->path);
+
+	/*
+	 * Find/create a raid set for all DDF drives and put this disk
+	 * into that set.  The raid_sets for the real arrays will be created
+	 * as children of the disk's raid_set.
+	 *
+	 * (Is this really necessary?)
+	 */
+	if (!(rs = find_or_alloc_raid_set(lc, rd->name, FIND_TOP, rd,
+					  LC_RS(lc), NO_CREATE,
+					  NO_CREATE_ARG)))
+		return NULL;
+
+	rs->type = t_group;
+	list_add_sorted(lc, &rs->devs, &rd->devs, no_sort);
+
+	/* Go deal with the real arrays. */
+	return group_rd(lc, rs, rd);
+}
+
+/* Write metadata. */
+static int ddf1_write(struct lib_context *lc,  struct raid_dev *rd, int erase)
+{
+	int ret;
+        struct ddf1 *ddf1 = META(rd, ddf1);
+
+	if (ddf1->adaptec_mode)
+		ddf1_update_all_crcs(lc, rd->di, ddf1);
+
+        ddf1_cvt_all(lc, ddf1, rd->di);
+        ret = write_metadata(lc, handler, rd, -1, erase);
+        ddf1_cvt_all(lc, ddf1, rd->di);
+
+        return ret;
+}
+
+/*
+ * Check integrity of a RAID set.
+ */
+
+/* Retrieve the number of devices that should be in this set. */
+static unsigned int device_count(struct raid_dev *rd, void *context)
+{
+	/* Get the logical drive */
+	struct ddf1_config_record *cr =
+		get_this_config(META(rd->private.ptr, ddf1), rd->offset);
+
+	/*
+	 * Release reference after check, so that core
+	 * doesn't try to free it multiple times.
+	 */
+	rd->private.ptr = NULL;
+	return cr ? cr->primary_element_count : 0;
+}
+
+/* Check a RAID device */
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context)
+{
+	/*
+	 * FIXME: Should we do more checking for brokenness here?
+	 * We could check SMART data, etc.
+	 */
+	return rd->type != s_broken;
+}
+
+/* Start the recursive RAID set check. */
+static int ddf1_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, device_count, NULL, check_rd,
+			      NULL, handler);
+}
+
+static struct event_handlers ddf1_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about the RAID device.
+ */
+static void ddf1_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	ddf1_dump_all(lc, rd->di, META(rd, ddf1), handler);
+}
+#endif /* #ifdef DMRAID_NATIVE_LOG  */
+
+static struct dmraid_format ddf1_format = {
+	.name	= HANDLER,
+	.descr	= "SNIA DDF1",
+	.caps	= "0,1,4,5,linear",
+	.format = FMT_RAID,
+	.read	= ddf1_read,
+	.write	= ddf1_write,
+	.group	= ddf1_group,
+	.check	= ddf1_check,
+	.events	= &ddf1_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= ddf1_log,
+#endif
+};
+
+/* Register this format handler with the format core */
+int register_ddf1(struct lib_context *lc)
+{
+	return register_format_handler(lc, &ddf1_format);
+}
+
+/*
+ * Set up a RAID device from what we've assembled out of the metadata.
+ */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	unsigned int i, ma_count = 5;
+	struct ddf1 *ddf1 = meta;
+	struct meta_areas *ma;
+	struct ddf1_phys_drive *pd;
+
+	if (!(pd = get_phys_drive(ddf1)))
+		LOG_ERR(lc, 0, "%s: Cannot find physical drive description "
+			       "on %s!", handler, di->path);
+
+	/* We need multiple metadata areas */
+	ma_count += ddf1->adapter ? 1 : 0;
+	ma_count += ddf1->secondary ? 1 : 0;
+	ma_count += ddf1->disk_data ? 1 : 0;
+	/* FIXME: metadata area for workspace_lba */
+
+	if (!(ma = rd->meta_areas = alloc_meta_areas(lc, rd, handler,
+						     ma_count)))
+		return 0;
+
+	/* Preset metadata area offset and size and adjust below */
+	for (i = 0; i < ma_count; i++)
+		ma[i].offset = ddf1->primary->primary_table_lba;
+
+	ma->offset = ddf1->anchor_offset;
+	(ma++)->area = &ddf1->anchor;
+
+	(ma++)->area = ddf1->primary;
+
+	if (ddf1->secondary)
+		(ma++)->offset = ddf1->primary->secondary_table_lba;
+
+	if (ddf1->adapter) {
+		ma->offset += ddf1->primary->adapter_data_offset;
+		ma->size = to_bytes(ddf1->primary->adapter_data_len);
+		(ma++)->area = ddf1->adapter;
+	}
+
+	/* FIXME: set up workspace_lba */
+
+	if (ddf1->disk_data) {
+		ma->offset += ddf1->primary->disk_data_offset;
+		ma->size = to_bytes(ddf1->primary->disk_data_len);
+		(ma++)->area = ddf1->disk_data;
+	}
+
+	ma->offset += ddf1->primary->phys_drive_offset;
+	ma->size = to_bytes(ddf1->primary->phys_drive_len);
+	(ma++)->area = ddf1->pd_header;
+
+	ma->offset += ddf1->primary->virt_drive_offset;
+	ma->size = to_bytes(ddf1->primary->virt_drive_len);
+	(ma++)->area = ddf1->vd_header;
+
+	ma->offset += ddf1->primary->config_record_offset;
+	ma->size = to_bytes(ddf1->primary->config_record_len);
+	ma->area = ddf1->cfg;
+
+	/* Now set up the rest of the metadata info */
+        rd->di = di;
+	rd->fmt = &ddf1_format;
+	rd->status = disk_status(pd);
+	rd->type = t_group;
+	rd->offset = 0;
+	if (!(rd->sectors = get_size(lc, ddf1, NULL, pd)))
+		return log_zero_sectors(lc, di->path, handler);
+
+	/* FIXME: better name */
+	return (rd->name = dbg_strdup(DDF1_DISKS)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ddf/ddf1.c.orig,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1.c.orig
+++ -	2008-02-22 17:04:41.464564000 +0000
@@ -0,0 +1,1047 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshage, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <errno.h>
+
+#define	HANDLER	"ddf1"
+
+#include "internal.h"
+
+#define	FORMAT_HANDLER
+#include "ddf1.h"
+
+// #include "ddf1_crc.h"
+#include "ddf1_cvt.h"
+#include "ddf1_dump.h"
+
+static const char *handler = HANDLER;
+
+/* PCI IDs for Adaptec */
+#define PCI_VENDOR_ID_ADAPTEC		0x9004
+#define PCI_VENDOR_ID_ADAPTEC2		0x9005
+
+/* Find the beginning of all DDF metadata */
+static uint64_t find_ddf_beginning(struct ddf1 *ddf1)
+{
+	uint64_t start;
+	struct ddf1_header *h = &ddf1->anchor;
+
+	start = ddf1->anchor_offset;
+	if (h->primary_table_lba < start)
+		start = h->primary_table_lba;
+	if (h->secondary_table_lba < start)
+		start = h->secondary_table_lba;
+#ifdef WORKSPACE_IS_PART_OF_DDF
+	if (ddf1->primary->workspace_lba < start)
+		start = ddf1->primary->workspace_lba;
+#endif
+
+	return start;
+}
+
+/* Figure out what endian conversions we need */
+static void find_endian(struct lib_context *lc, struct ddf1 *ddf1)
+{
+	uint8_t *ptr = (uint8_t*) &ddf1->anchor.signature;
+
+	if (ptr[0] == 0xDE && ptr[1] == 0x11)
+		ddf1->disk_format = BIG_ENDIAN;
+	else if (ptr[0] == 0x11 && ptr[1] == 0xDE)
+		ddf1->disk_format = LITTLE_ENDIAN;
+	else {
+		log_error(lc, "Can't figure out endianness!");
+		ddf1->disk_format = 0;
+	}
+}
+
+/* Map DDF1 disk status to dmraid status */
+static enum status disk_status(struct ddf1_phys_drive *disk) {
+	struct {
+		uint8_t	flag;
+		enum status status;
+	} states[] = {
+		{ 0x72, s_broken },
+		{ 0x04, s_nosync },
+		{ 0x08, s_setup },
+		{ 0x01, s_ok },
+	}, *s = states;
+
+	if (disk) {
+		do {
+			if (disk->state & s->flag)
+				return s->status;
+		} while ((s++)->status != s_ok);
+	}
+
+	return s_undef;
+}
+
+/*
+ * Compare two GUIDs.  For some reason, Adaptec sometimes writes 0xFFFFFFFF
+ * as the last four bytes (ala DDF2) and sometimes writes real data.
+ * For now we'll compare the first twenty and only the last four if
+ * both GUIDs don't have 0xFFFFFFFF in bytes 20-23.  Gross.
+ */
+static inline uint8_t _and(uint8_t *p)
+{
+	return p[20] & p[21] & p[22] & p[23];
+}
+
+static int guidcmp(uint8_t *one, uint8_t *two)
+{
+	int x = memcmp(one, two, DDF1_GUID_LENGTH - 4);
+
+	if (x)
+		return x;
+
+	return (_and(one) || _and(two)) ? 0 : memcmp(one + 20, two + 20, 4);
+}
+
+/* Find the physical drive data for a drive */
+static struct ddf1_phys_drive *get_phys_drive(struct ddf1 *ddf1, uint32_t ref)
+{
+	unsigned int i = ddf1->pd_header->max_drives;
+	struct ddf1_phys_drive *pd;
+
+	while (i--) {
+		pd = ddf1->pds + i;
+		if (pd->reference == ref)
+			return pd;
+	}
+
+	return NULL;
+}
+
+/* Find this drive's physical data */
+static inline struct ddf1_phys_drive *get_this_phys_drive(struct ddf1 *ddf1)
+{
+	return get_phys_drive(ddf1, ddf1->disk_data->reference);
+}
+
+/* Find the virtual drive that goes with this config record */
+static struct ddf1_virt_drive *get_virt_drive(struct ddf1 *ddf1,
+					      struct ddf1_config_record *cr)
+{
+	int i = ddf1->vd_header->num_drives;
+	struct ddf1_virt_drive *vd;
+
+	while (i--) {
+		vd = ddf1->vds + i;
+		if (!guidcmp(vd->guid, cr->guid))
+			return vd;
+	}
+
+	return NULL;
+}
+
+/*
+ * Find the index of the VD config record given a physical drive and offset.
+ */
+static int get_config_byoffset(struct ddf1 *ddf1, struct ddf1_phys_drive *pd,
+			       uint64_t offset)
+{
+	int cfgs = NUM_CONFIG_ENTRIES(ddf1), i;
+	uint32_t *cfg_drive_ids, j;
+	uint64_t *cfg_drive_offsets;
+	struct ddf1_config_record *cfg;
+
+	for (i = 0; i < cfgs; i++) {
+		cfg = CR(ddf1, i);
+		if (cfg->signature == DDF1_VD_CONFIG_REC) {
+			cfg_drive_ids = CR_IDS(ddf1, cfg);
+			cfg_drive_offsets = CR_OFF(ddf1, cfg);
+			for (j = 0; j < cfg->primary_element_count; j++) {
+				if (cfg_drive_ids[j] == pd->reference &&
+				    cfg_drive_offsets[j] == offset)
+					return i;
+			}
+		}
+	}
+
+	return -ENOENT;
+}
+
+/* Find the index of the nth VD config record for this physical drive. */
+static int get_config_index(struct ddf1 *ddf1, struct ddf1_phys_drive *pd,
+			    unsigned int *n)
+{
+	int cfgs = NUM_CONFIG_ENTRIES(ddf1), i, j, nn = *n;
+	uint32_t *ids;
+	struct ddf1_config_record *cr;
+
+	for (i = 0; i < cfgs; i++) {
+		cr = CR(ddf1, i);
+		if (cr->signature == DDF1_VD_CONFIG_REC) {
+			ids = CR_IDS(ddf1, cr);
+			for (j = 0; j < cr->primary_element_count; j++) {
+				if (ids[j] == pd->reference && !nn--)
+						return i;
+			}
+		}
+	}
+
+	*n -= nn;
+	return nn < 0 ? -ENOENT : 0;
+}
+
+/*
+ * Find the nth VD config record for this physical drive.
+ */
+static inline struct ddf1_config_record *get_config(struct ddf1 *ddf1,
+						    struct ddf1_phys_drive *pd,
+						    unsigned int n)
+{
+	int i = get_config_index(ddf1, pd, &n);
+
+	return i < 0 ? NULL : CR(ddf1, i);
+}
+ 
+/* Find a config record for this drive, given the offset of the array. */
+static inline struct ddf1_config_record *get_this_config(struct ddf1 *ddf1,
+							 uint64_t offset)
+{
+	struct ddf1_phys_drive *pd = get_this_phys_drive(ddf1);
+	int i = get_config_byoffset(ddf1, pd, offset);
+
+	return i < 0 ? NULL : get_config(ddf1, pd, i);
+}
+
+/* Find the config record disk/offset entry for this config/drive. */
+static int get_offset_entry(struct ddf1 *ddf1, struct ddf1_config_record *cr,
+			    struct ddf1_phys_drive *pd)
+{
+	int i;
+	uint32_t *ids;
+
+	if (cr) {
+		ids = CR_IDS(ddf1, cr);
+		for (i = 0; i < ddf1->primary->max_phys_drives; i++) {
+			if (ids[i] == pd->reference)
+				return i;
+		}
+	}
+
+	return -ENOENT;
+}
+
+/* Find the offset for this config/drive. */
+static uint64_t get_offset(struct ddf1 *ddf1, struct ddf1_config_record *cr,
+			   struct ddf1_phys_drive *pd)
+{
+	int i = get_offset_entry(ddf1, cr, pd);
+
+	return i < 0 ? pd->size : CR_OFF(ddf1, cr)[i];
+}
+
+/* Calculate the stripe size, in sectors */
+static inline unsigned int stride(struct ddf1_config_record *cr)
+{
+	return 1 << cr->stripe_size; // * 512 * 2;
+}
+
+/* Mapping of template types to generic types */
+static struct types types[] = {
+	{ DDF1_RAID0,	t_raid0 },
+	{ DDF1_RAID1,	t_raid1 },
+	{ DDF1_RAID4,	t_raid4 },
+	{ DDF1_CONCAT,	t_linear },
+	{ DDF1_JBOD,	t_linear },
+	{ 0, t_undef}
+};
+
+/* Seperate array for RAID5 qualifiers */
+static struct types qualifier_types[] = {
+	/* FIXME: Is RLQ=0 really right symmetric? */
+	{ DDF1_RAID5_RS, t_raid5_rs },
+	{ DDF1_RAID5_LA, t_raid5_la },
+	{ DDF1_RAID5_LS, t_raid5_ls },
+	{ 0, t_undef}
+};
+
+/* Map the DDF1 raid type codes into dmraid type codes. */
+static enum type type(struct lib_context *lc, struct ddf1 *ddf1,
+		      struct ddf1_config_record *cr)
+{
+	unsigned int l;
+	struct types *t;
+
+	if (!cr)
+		return t_undef;
+
+	l = cr->raid_level;
+	if (l == DDF1_RAID5) {
+		/*
+		 * FIXME: Do _all_ Adaptec controllers use left
+		 * asymmetric parity and write zero to RLQ?
+		 */
+		if (ddf1->adaptec_mode)
+			return t_raid5_la;
+
+		l = cr->raid_qualifier;
+		t = qualifier_types;
+	} else
+		t = types;
+
+	return rd_type(t, l);
+}
+
+/* Read the whole metadata chunk at once */
+static uint8_t *read_metadata_chunk(struct lib_context *lc, struct dev_info *di,
+				    uint64_t start)
+{
+	uint8_t *ret;
+	size_t size = (di->sectors - start) * DDF1_BLKSIZE;
+
+	if (!(ret = dbg_malloc(size)))
+		LOG_ERR(lc, ret, "%s: unable to allocate memory.", di->path);
+
+	if (!read_file(lc, handler, di->path, ret, size,
+		       start * DDF1_BLKSIZE)) {
+		dbg_free(ret);
+		LOG_ERR(lc, NULL, "%s: unable to read metadata.", di->path);
+	}
+
+	return ret;
+}
+
+static inline void cond_free(void *p)
+{
+	if (p)
+		dbg_free(p);
+}
+
+/*
+ * Read an DDF1 RAID device.  Fields are little endian, so
+ * need to convert them if we're on a BE machine (ppc, etc).
+ */
+static int read_extended(struct lib_context *lc, struct dev_info *di,
+			 struct ddf1 *ddf1)
+{
+	int i;
+	uint64_t where;
+	size_t size;
+	struct ddf1_header *pri, *sec;
+	struct ddf1_adapter *adap;
+	struct ddf1_disk_data *ddata;
+	struct ddf1_phys_drives *pd;
+	struct ddf1_virt_drives *vd;
+
+	/* FIXME: We should verify the checksums... */
+
+	/* Read the primary DDF header */
+	where = ddf1->anchor.primary_table_lba * DDF1_BLKSIZE;
+	if (!(pri = ddf1->primary =
+	      alloc_private_and_read(lc, handler, sizeof(*pri),
+				     di->path, where)))
+		goto bad;
+
+	/* Read the secondary header. */
+	ddf1_cvt_header(ddf1, pri);
+	if (!(sec = ddf1->secondary = alloc_private(lc, handler, sizeof(*sec))))
+		goto bad;
+
+	where = ddf1->anchor.secondary_table_lba * DDF1_BLKSIZE;
+	if (ddf1->anchor.secondary_table_lba != 0xFFFFFFFFFFFFFFFFULL &&
+	    !read_file(lc, handler, di->path, sec, sizeof(*sec), where))
+		goto bad;
+
+	ddf1_cvt_header(ddf1, sec);
+	if (pri->signature != DDF1_HEADER) {
+		log_warn(lc, "%s: incorrect primary header signature %x",
+			 di->path, pri->signature);
+		cond_free(ddf1->primary);
+		ddf1->primary = NULL;
+	};
+	
+	if (sec->signature == DDF1_HEADER) {
+		/* If we encounter an error, we use the secondary table */
+		if (!ddf1->primary) {
+			log_warn(lc, "%s: using secondary header", di->path);
+			ddf1->primary = ddf1->secondary;
+			ddf1->secondary = NULL;
+		}
+	} else {
+		if (sec->signature)
+			log_warn(lc, "%s: bad secondary header signature %x",
+				 di->path, sec->signature);
+
+		dbg_free(sec);
+		ddf1->secondary = NULL;
+	}
+
+	if (!ddf1->primary) {
+		log_error(lc, "%s: both header signatures bad", di->path);
+		goto bad;
+	}
+
+	/* Read the adapter data */
+	if (!(adap = ddf1->adapter = alloc_private(lc, handler, sizeof(*adap))))
+		goto bad;
+
+	where = (pri->primary_table_lba + pri->adapter_data_offset)
+		* DDF1_BLKSIZE;
+	if (pri->adapter_data_offset != 0xFFFFFFFF &&
+	    !read_file(lc, handler, di->path, adap, sizeof(*adap), where))
+		goto bad;
+
+	ddf1_cvt_adapter(ddf1, ddf1->adapter);
+	if (ddf1->adapter->signature != DDF1_ADAPTER_DATA) {
+		if (ddf1->adapter->signature)
+			log_warn(lc, "%s: incorrect adapter data signature %x",
+				 di->path, ddf1->adapter->signature);
+		free (ddf1->adapter);
+		ddf1->adapter = NULL;
+	}
+
+	if (ddf1->adapter &&
+	    ddf1->adapter->pci_vendor == PCI_VENDOR_ID_ADAPTEC2)
+		ddf1->adaptec_mode = 1;
+
+	/* Read physical drive characteristic data */
+	where = (pri->primary_table_lba + pri->disk_data_offset) * DDF1_BLKSIZE;
+	if (!(ddata = ddf1->disk_data =
+	      alloc_private_and_read(lc, handler, sizeof(*ddata),
+				     di->path, where)))
+		goto bad;
+
+	/*
+	 * This table isn't technically required, but for now we rely
+	 * on it to give us a key into the physical drive table.
+	 */
+	ddf1_cvt_disk_data(ddf1, ddata);
+	if (ddata->signature != DDF1_FORCED_PD_GUID) {
+		log_warn(lc, "%s: incorrect disk data signature %x",
+			 di->path, ddata->signature);
+		goto bad;
+	}
+
+	/* Read physical drive data header */
+	where = (pri->primary_table_lba + pri->phys_drive_offset) *
+		DDF1_BLKSIZE;
+	size = pri->phys_drive_len * DDF1_BLKSIZE;
+	if (!(pd = ddf1->pd_header =
+	      alloc_private_and_read(lc, handler, size, di->path, where)))
+		goto bad;
+
+	ddf1_cvt_phys_drive_header(ddf1, pd);
+	if (pd->signature != DDF1_PHYS_DRIVE_REC) {
+		log_warn(lc, "%s: cannot find physical drive records",
+			 di->path);
+		goto bad;
+	}
+
+	/* Now read the physical drive data */
+	ddf1->pds = (struct ddf1_phys_drive *)(((uint8_t *)ddf1->pd_header) +
+		    sizeof (*pd));
+	for (i = 0; i < pd->num_drives; i++) {
+		ddf1_cvt_phys_drive(ddf1, &ddf1->pds[i]);
+		/*
+		 * Adaptec controllers have a weird bug where this field is
+		 * only four bytes ... and the next four are 0xFF.
+		 */
+		if (ddf1->pds[i].size >> 32 == 0xFFFFFFFF)
+			ddf1->pds[i].size &= 0xFFFFFFFF;
+	}
+
+	/* Read virtual drive data header */
+	where = (pri->primary_table_lba + pri->virt_drive_offset) *
+		DDF1_BLKSIZE;
+	size = pri->phys_drive_len * DDF1_BLKSIZE;
+	if (!(vd = ddf1->vd_header =
+	      alloc_private_and_read(lc, handler, size, di->path, where)))
+		goto bad;
+
+	ddf1_cvt_virt_drive_header(ddf1, vd);
+	if (vd->signature != DDF1_VIRT_DRIVE_REC) {
+		log_warn(lc, "%s: cannot find virtual drive records",
+			 di->path);
+		goto bad;
+	}
+
+	/* Now read the virtual drive data */
+	ddf1->vds = (struct ddf1_virt_drive*)(((uint8_t*) vd) + sizeof (*pd));
+	for (i = 0; i < vd->num_drives; i++)
+		ddf1_cvt_virt_drive(ddf1, &ddf1->vds[i]);
+
+	/* Read config data */
+	where = (pri->primary_table_lba + pri->config_record_offset) *
+		DDF1_BLKSIZE;
+	size = pri->config_record_len * DDF1_BLKSIZE;
+	if (!(ddf1->cfg = alloc_private_and_read(lc, handler, size,
+						 di->path, where)))
+		goto bad;
+
+	/*
+	 * Ensure each record is: a config table for VDs; a config table for
+	 * spare disks; or vendor-specifc data of some sort.
+	 */
+	ddf1_cvt_records(lc, di, ddf1, 1);
+
+	/*
+	 * FIXME: We don't pick up diagnostic logs, vendor specific logs,
+	 * bad block data, etc.  That shouldn't cause a problem with reading
+	 * or writing metadata, but at some point we might want to do something
+	 * with them.
+	 */
+	ddf1->in_cpu_format = 1;
+	return 1;
+
+bad:
+	ddf1->vds = NULL;
+	ddf1->pds = NULL;
+	cond_free(ddf1->cfg);
+	cond_free(ddf1->pd_header);
+	cond_free(ddf1->disk_data);
+	cond_free(ddf1->adapter);
+	cond_free(ddf1->secondary);
+	cond_free(ddf1->primary);
+	return 0;
+}
+
+
+/* Count the number of raid_devs we need to create for this drive */
+static unsigned int num_devs(struct lib_context *lc, void *meta)
+{
+	struct ddf1 *ddf1 = meta;
+	unsigned int num_drives = ~0;
+	
+	get_config_index(ddf1, get_this_phys_drive(ddf1), &num_drives);
+	return num_drives;
+}
+
+/* Check CRC on a given struct */
+/*
+enum struct_type { ANCHOR, HEADER_PRIM, HEADER_SEC,
+		   ADAPTER, DISK_DATA, PHYS_DRIVES,
+		   VIRT_DRIVES, CONFIG_RECORD };
+static uint32_t checksum(struct ddf1 *ddf1, enum struct_type type)
+{
+	struct {
+		enum struct_type type;
+		void *ptr;
+		size_t len;
+	} types[] = {
+		{ ANCHOR, &ddf1->anchor, sizeof(ddf1->anchor) },
+		{ HEADER_PRIM, ddf1->primary, sizeof(*ddf1->primary) },
+		{ HEADER_SEC, ddf1->secondary, sizeof(*ddf1->secondary) },
+		{ ADAPTER, ddf1->adapter, sizeof(*ddf1->adapter) },
+		{ DISK_DATA, ddf1->disk_data, sizeof(*ddf1->disk_data) },
+		{ PHYS_DRIVES, ddf1->pd_header, sizeof(*ddf1->pd_header) },
+		{ VIRT_DRIVES, ddf1->vd_header, sizeof(*ddf1->vd_header) },
+		{ CONFIG_RECORD, ddf1->cfg, sizeof(*ddf1->cfg) },
+	}, *t = ARRAY_END(types);
+
+	while (t-- > types) {
+		if (type == t->type)
+			return crc(t->ptr, t->len);
+	}
+
+	return 0;
+}
+*/
+
+/* Is this DDF1 metadata? */
+static inline int is_ddf1(struct lib_context *lc, struct dev_info *di,
+			  struct ddf1 *ddf1)
+{
+	/*
+	 * Check our magic numbers and that the version == v2.
+	 * We don't support anything other than that right now.
+	 */
+
+	/* FIXME: We should examine the version headers... */
+	return ddf1->anchor.signature == DDF1_HEADER ||
+	       ddf1->anchor.signature == DDF1_HEADER_BACKWARDS;
+}
+
+/* Try to find DDF1 metadata at a given offset (ddf1_sboffset) */
+static struct ddf1 *try_to_find_ddf1(struct lib_context *lc,
+				     struct dev_info *di,
+				     size_t *sz, uint64_t *offset,
+				     union read_info *info,
+				     uint64_t ddf1_sboffset)
+{
+	struct ddf1 *ddf1;
+	// uint32_t crc;
+
+	/*
+	 * Try to find a DDF1 anchor block at ddf1_sboffset.  In theory this
+	 * should be the very last block, but some Adaptec controllers have
+	 * issues with standards compliance.  So we have to try with various
+	 * offsets.
+	 */
+	if (!(ddf1 = alloc_private(lc, handler, sizeof(*ddf1))))
+		goto err;
+
+	if (!read_file(lc, handler, di->path, &ddf1->anchor, DDF1_BLKSIZE,
+		       ddf1_sboffset) ||
+	    !is_ddf1(lc, di, ddf1))
+		goto bad;
+
+	ddf1->anchor_offset = ddf1_sboffset;
+
+	/* Convert endianness */
+	ddf1->in_cpu_format = 0;
+	find_endian(lc, ddf1);
+	ddf1_cvt_header(ddf1, &ddf1->anchor);
+
+	/* FIXME: crc */
+/*
+	crc = checksum(ddf1, ANCHOR);
+	printf("crc=%08x ", crc);
+	printf("ddf1=%08x\n", ddf1->anchor.crc);
+*/
+
+	/* Read extended metadata. */
+	if (read_extended(lc, di, ddf1))
+		return ddf1;
+
+   bad:
+	dbg_free(ddf1);
+   err:
+	return NULL;
+}
+
+/*
+ * Attempt to interpret DDF1 metadata from a block device.  This function
+ * returns either NULL or a pointer to a descriptor struct.
+ * Note that the struct should be fully converted to the correct endianness
+ * by the time this function returns.
+ */
+static void *read_metadata_areas(struct lib_context *lc, struct dev_info *di,
+				 size_t *sz, uint64_t *offset,
+				 union read_info *info)
+{
+	struct ddf1 *ddf1;
+
+	if ((ddf1 = try_to_find_ddf1(lc, di, sz, offset,
+				     info, DDF1_CONFIGOFFSET)))
+		goto out;
+
+	if ((ddf1 = try_to_find_ddf1(lc, di, sz, offset,
+				     info, DDF1_CONFIGOFFSET_ADAPTEC)))
+		ddf1->adaptec_mode = 1;
+
+   out:
+	return ddf1;
+}
+
+/* This is all hogwash since file_metadata can only be called once... */
+static void file_metadata_areas(struct lib_context *lc, struct dev_info *di,
+				void *meta)
+{
+	uint8_t *buf;
+	uint64_t start = find_ddf_beginning(meta);
+
+	if (!(buf = read_metadata_chunk(lc, di, start)))
+		return;
+
+	/* Record metadata. */
+	file_metadata(lc, handler, di->path, buf,
+		      (di->sectors - start) * DDF1_BLKSIZE,
+		      start * DDF1_BLKSIZE);
+
+	dbg_free(buf);
+
+	/* Record the device size. */
+	file_dev_size(lc, handler, di);
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *ddf1_read(struct lib_context *lc,
+					struct dev_info *di)
+{
+	/*
+	 * NOTE: Everything called after read_metadata_areas assumes that
+	 * the reserved block, raid table and config table have been
+	 * converted to the appropriate endianness.
+	 */
+	return read_raid_dev(lc, di, read_metadata_areas, 0, 0, NULL, NULL,
+			     file_metadata_areas, setup_rd, handler);
+}
+
+/* Compose an "identifier" for use as a sort key for raid sets. */
+static inline int compose_id(struct ddf1 *ddf1, struct raid_dev *rd)
+{
+	struct ddf1_phys_drive *pd = get_this_phys_drive(ddf1);
+	int i = get_config_byoffset(ddf1, pd, rd->offset);
+
+	return i < 0 ? -1 : get_offset_entry(ddf1, get_config(ddf1, pd, i), pd);
+}
+
+/* No sort. */
+static int no_sort(struct list_head *pos, struct list_head *new)
+{
+	return 0;
+}
+
+/* Sort DDF1 devices by for a RAID set. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return compose_id(META(RD(new)->private.ptr, ddf1), RD(new)) <
+	       compose_id(META(RD(pos)->private.ptr, ddf1), RD(pos));
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	log_err(lc, "I/O error on device %s at sector %lu.\n",
+		e_io->rd->di->path, e_io->sector);
+
+	LOG_ERR(lc, 0, "PANIC: ddf1 doesn't know about event_io!\n");
+}
+
+#if 0
+	/* FIXME: This should not use META() directly? */
+	struct raid_dev *rd = e_io->rd;
+	struct ddf1 *ddf1 = META(rd, ddf1);
+	struct ddf1_raid_configline *cl = this_disk(ddf1);
+	struct ddf1_raid_configline *fwl = find_logical(ddf1);
+
+	/* Ignore if we've already marked this disk broken(?) */
+	if (rd->status & s_broken)
+		return 0;
+	
+	/* Mark the array as degraded and the disk as failed. */
+	rd->status = s_broken;
+	cl->raidstate = LSU_COMPONENT_STATE_FAILED;
+	fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
+	/* FIXME: Do we have to mark a parent too? */
+
+	/* Indicate that this is indeed a failure. */
+	return 1;
+}
+#endif
+
+#define NAME_SIZE 64
+/* Formulate a RAID set name for this disk. */
+static char *name(struct lib_context *lc, struct ddf1 *ddf1,
+		  struct raid_dev *rd)
+{
+	int i, prefix;
+	char *buf, *r;
+	struct ddf1_phys_drive *pd;
+	struct ddf1_virt_drive *vd;
+	struct ddf1_config_record *cr;
+
+	if (!(pd = get_this_phys_drive(ddf1)))
+		LOG_ERR(lc, NULL, "Cannot find physical drive description!");
+
+	if (!(buf = dbg_malloc(NAME_SIZE)))
+		LOG_ERR(lc, NULL, "Cannot allocate memory for name.");
+
+	i = get_config_byoffset(ddf1, pd, rd->offset);
+ 	cr = get_config(ddf1, pd, i);
+ 	if (i < 0 || !cr) {
+		sprintf(buf, ".ddf1_spares");
+		goto out;
+	}
+
+	if (!(vd = get_virt_drive(ddf1, cr))) {
+		dbg_free(buf);
+		LOG_ERR(lc, NULL, "Cannot find virtual drive description!");
+	}
+
+	sprintf(buf, "%s_", handler);
+	prefix = strlen(buf);
+
+	if (vd->name[0]) {
+		memcpy(buf + prefix, vd->name, 16);
+		i = prefix + 16;
+		while (!isgraph(buf[--i]));
+		buf[i+1] = 0;
+	} else {
+		char *b;
+
+		for (b = buf + prefix, i = 0; i < 24; b += 8, i += 4)
+			sprintf(b, "%02x%02x%02x%02x",
+				vd->guid[i], vd->guid[i+1],
+			        vd->guid[i+2], vd->guid[i+3]);
+	}
+
+   out:
+	/* Just return the needed allocation */
+	r = dbg_strdup(buf);
+	dbg_free(buf);
+
+	return r;
+}
+
+/* Figure out the real size of a disk... */
+static uint64_t get_size(struct lib_context *lc, struct ddf1 *ddf1,
+			 struct ddf1_config_record *cr,
+			 struct ddf1_phys_drive *pd)
+{
+	if (cr)
+		/* Some Adaptec controllers need this clamping. */
+		return type(lc, ddf1, cr) == t_raid0 ?
+		       cr->sectors - cr->sectors % stride(cr) : cr->sectors;
+
+	return pd->size;
+}
+
+/*
+ * Create all the volumes of a DDF disk as subsets of the top level DDF
+ * disk group.  rs_group points to that raid set and is returned if the
+ * function is successful, NULL if not.  rd_group is the raid_dev that
+ * represents the entire disk drive.
+ */
+static struct raid_set *group_rd(struct lib_context *lc,
+				 struct raid_set *rs_group,
+				 struct raid_dev *rd_group)
+{
+	struct ddf1 *ddf1 = META(rd_group, ddf1);
+	struct raid_set *rs = NULL;
+	struct raid_dev *rd;
+	struct ddf1_config_record *cr;
+	struct ddf1_phys_drive *pd;
+	unsigned int devs, i;
+	
+	if (!(pd = get_this_phys_drive(ddf1)))
+		return NULL;
+
+	devs = num_devs(lc, ddf1);
+	for (i = 0; i < devs; i++) {
+		/* Allocate a raid_dev for this volume */
+		if (!(rd = alloc_raid_dev(lc, handler)))
+			return NULL;
+
+		cr = get_config(ddf1, pd, i);
+		rd->di = rd_group->di;
+		rd->fmt = rd_group->fmt;
+		rd->type = type(lc, ddf1, cr);
+		rd->offset = get_offset(ddf1, cr, pd);
+		rd->sectors = get_size(lc, ddf1, cr, pd);
+		rd->name = name(lc, ddf1, rd);
+
+		/* Stuff it into the appropriate raid set. */
+		if (!(rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL,
+						  rd, &rs_group->sets,
+						  NO_CREATE, NO_CREATE_ARG))) {
+			free_raid_dev(lc, &rd);
+			return NULL;
+		}
+
+		rs->stride = stride(cr);
+		rs->type = type(lc, ddf1, cr);
+		rs->status = s_ok;
+
+		if (!(rd->private.ptr = alloc_private(lc, handler,
+						      sizeof(*rd_group))))
+			return NULL;
+
+		memcpy(rd->private.ptr, rd_group, sizeof (*rd_group));
+		list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+	}
+
+	return rs_group;
+}
+
+/* 
+ * Add an DDF1 device to a RAID set.  This involves finding the raid set to
+ * which this disk belongs, and then attaching it.  Note that there are other
+ * complications, such as two-layer arrays (RAID10).
+ *
+ * FIXME: We haven't been able to set up a RAID10 for testing...
+ */
+static struct raid_set *ddf1_group(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct ddf1 *ddf1 = META(rd, ddf1);
+	struct ddf1_phys_drive *pd;
+	struct raid_set *rs;
+	char *set_name;
+
+	if (!(pd = get_this_phys_drive(ddf1)))
+		LOG_ERR(lc, NULL, "Cannot find physical drive description!\n");
+
+	if (!(set_name = rd->name))
+		LOG_ERR(lc, NULL, "%s: Could not find RAID array name.\n",
+			rd->di->path);
+
+	/*
+	 * Find/create a raid set for all DDF drives and put this disk
+	 * into that set.  The raid_sets for the real arrays will be created
+	 * as children of the disk's raid_set.
+	 *
+	 * (Is this really necessary?)
+	 */
+	if (!(rs = find_or_alloc_raid_set(lc, set_name, FIND_TOP, rd,
+					  LC_RS(lc), NO_CREATE,
+					  NO_CREATE_ARG)))
+		return NULL;
+
+	rs->type = t_group;
+	list_add_sorted(lc, &rs->devs, &rd->devs, no_sort);
+
+	/* Go deal with the real arrays. */
+	return group_rd(lc, rs, rd);
+}
+
+/* Write metadata. */
+static int ddf1_write(struct lib_context *lc,  struct raid_dev *rd, int erase)
+{
+	int ret;
+        struct ddf1 *ddf1 = META(rd, ddf1);
+
+        ddf1_cvt_all(lc, ddf1, rd->di);
+        ret = write_metadata(lc, handler, rd, -1, erase);
+        ddf1_cvt_all(lc, ddf1, rd->di);
+
+        return ret;
+}
+
+/*
+ * Check integrity of a RAID set.
+ */
+
+/* Retrieve the number of devices that should be in this set. */
+static unsigned int device_count(struct raid_dev *rd, void *context)
+{
+	/* Get the logical drive */
+	struct ddf1_config_record *cr =
+		get_this_config(META(rd->private.ptr, ddf1), rd->offset);
+
+	return cr ? cr->primary_element_count : 0;
+}
+
+/* Check a RAID device */
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context)
+{
+	/*
+	 * FIXME: Should we do more checking for brokenness here?
+	 * We could check SMART data, verify that nobody else is
+	 * putting non-ddf disks in our raid set, etc.
+	 */
+	return rd->type != s_broken;
+}
+
+/* Start the recursive RAID set check. */
+static int ddf1_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, device_count, NULL, check_rd,
+			      NULL, handler);
+}
+
+static struct event_handlers ddf1_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about the RAID device.
+ */
+static void ddf1_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	ddf1_dump_all(lc, handler, META(rd, ddf1), rd->di);
+}
+#endif /* #ifdef DMRAID_NATIVE_LOG  */
+
+static struct dmraid_format ddf1_format = {
+	.name	= HANDLER,
+	.descr	= "SNIA DDF1",
+	.caps	= "0,1,4,5,linear",
+	.format = FMT_RAID,
+	.read	= ddf1_read,
+	.write	= ddf1_write,
+	.group	= ddf1_group,
+	.check	= ddf1_check,
+	.events	= &ddf1_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= ddf1_log,
+#endif
+};
+
+/* Register this format handler with the format core */
+int register_ddf1(struct lib_context *lc)
+{
+	return register_format_handler(lc, &ddf1_format);
+}
+
+/*
+ * Set up a RAID device from what we've assembled out of the metadata.
+ */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	unsigned int i, ma_count = 5;
+	struct ddf1 *ddf1 = meta;
+	struct meta_areas *ma;
+	struct ddf1_phys_drive *pd;
+
+	if (!(pd = get_this_phys_drive(ddf1)))
+		LOG_ERR(lc, 0, "Cannot find physical drive description!\n");
+
+	/* We need multiple metadata areas */
+	ma_count += ddf1->adapter ? 1 : 0;
+	ma_count += ddf1->secondary ? 1 : 0;
+	ma_count += ddf1->disk_data ? 1 : 0;
+	/* FIXME: metadata area for workspace_lba */
+
+	if (!(ma = rd->meta_areas = alloc_meta_areas(lc, rd, handler,
+						     ma_count)))
+		return 0;
+
+	/* Preset metadata area offset and size and adjust below */
+	for (i = 0; i < ma_count; i++) {
+		ma[i].offset = ddf1->primary->primary_table_lba;
+		ma[i].size = DDF1_BLKSIZE;
+	}
+
+	ma->offset = ddf1->anchor_offset;
+	(ma++)->area = &ddf1->anchor;
+
+	(ma++)->area = ddf1->primary;
+
+	if (ddf1->secondary)
+		(ma++)->offset = ddf1->primary->secondary_table_lba;
+
+	if (ddf1->adapter) {
+		ma->offset += ddf1->primary->adapter_data_offset;
+		ma->size *= ddf1->primary->adapter_data_len;
+		(ma++)->area = ddf1->adapter;
+	}
+
+	/* FIXME: set up workspace_lba */
+
+	if (ddf1->disk_data) {
+		ma->offset += ddf1->primary->disk_data_offset;
+		ma->size *= ddf1->primary->disk_data_len;
+		(ma++)->area = ddf1->disk_data;
+	}
+
+	ma->offset += ddf1->primary->phys_drive_offset;
+	ma->size *= ddf1->primary->phys_drive_len;
+	(ma++)->area = ddf1->pd_header;
+
+	ma->offset += ddf1->primary->virt_drive_offset;
+	ma->size *= ddf1->primary->virt_drive_len;
+	(ma++)->area = ddf1->vd_header;
+
+	ma->offset += ddf1->primary->config_record_offset;
+	ma->size *= ddf1->primary->config_record_len;
+	ma->area = ddf1->cfg;
+
+	/* Now set up the rest of the metadata info */
+        rd->di = di;
+	rd->fmt = &ddf1_format;
+	rd->status = disk_status(pd);
+	rd->type = t_group;
+	rd->offset = 0;
+	rd->sectors = get_size(lc, ddf1, NULL, pd);
+	rd->name = dbg_strdup((char*) ".ddf_disks"); /* FIXME: better name */
+	return rd->name ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ddf/ddf1.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1.h
+++ -	2008-02-22 17:04:41.633908000 +0000
@@ -0,0 +1,273 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _DDF1_H
+#define _DDF1_H
+
+/* Beginning of stuff that Darrick Wong added */
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+#define	HANDLER	"ddf1"
+
+/* Number of config records */
+#define NUM_CONFIG_ENTRIES(ddf1) ((ddf1)->primary->config_record_len / \
+	(ddf1)->primary->vd_config_record_len)
+
+/* Macros to access config records */
+#define SR(ddf, idx)	((struct ddf1_spare_header*)(((uint8_t*)(ddf)->cfg) + \
+	((idx) * (ddf)->primary->vd_config_record_len * 512)))
+
+#define CR(ddf, idx)	((struct ddf1_config_record*)(((uint8_t*)(ddf)->cfg) + \
+	((idx) * (ddf)->primary->vd_config_record_len * 512)))
+
+#define CR_IDS(ddf, cr)	((uint32_t*)(((uint8_t*)(cr)) + \
+	sizeof(struct ddf1_config_record)))
+
+#define CR_OFF(ddf, cr)	((uint64_t*)(((uint8_t*)(cr)) + \
+	sizeof(struct ddf1_config_record) + \
+	(ddf1_cr_off_maxpds_helper(ddf) * sizeof(uint32_t))))
+
+
+/* DDF1 metadata offset in bytes */
+#define	DDF1_CONFIGOFFSET		((di->sectors - 1) << 9)
+/* DDF1 metadata offset on weird adaptec controllers */
+#define	DDF1_CONFIGOFFSET_ADAPTEC	((di->sectors - 257) << 9)
+
+/* Data offset in sectors */
+#define	DDF1_DATAOFFSET		0
+
+/* Assume block size is 512... */
+#define DDF1_BLKSIZE		512
+
+/* Length of GUIDs in DDF */
+#define DDF1_GUID_LENGTH	24
+
+/* Length of DDF revision strings */
+#define DDF1_REV_LENGTH		8
+
+/* RAID types */
+#define DDF1_RAID0		0x00
+#define DDF1_RAID1		0x01
+#define DDF1_RAID3		0x03
+#define DDF1_RAID4		0x04
+#define DDF1_RAID5		0x05
+#define DDF1_RAID1E		0x11
+#define DDF1_JBOD		0x0F
+#define DDF1_CONCAT		0x1F
+#define DDF1_RAID5E		0x15
+#define DDF1_RAID5EE		0x25
+#define DDF1_RAID6		0x16
+
+#define DDF1_RAID5_RS		0
+#define DDF1_RAID5_LA		2
+#define DDF1_RAID5_LS		3
+
+/* Table signatures */
+#define DDF1_HEADER		0xDE11DE11
+#define DDF1_HEADER_BACKWARDS	0x11DE11DE
+#define DDF1_ADAPTER_DATA	0XAD111111
+#define DDF1_PHYS_DRIVE_REC	0X22222222
+#define DDF1_FORCED_PD_GUID	0x33333333
+#define DDF1_VIRT_DRIVE_REC	0xDDDDDDDD
+#define DDF1_VD_CONFIG_REC	0xEEEEEEEE
+#define DDF1_SPARE_REC		0x55555555
+#define DDF1_VU_CONFIG_REC	0x88888888
+#define DDF1_VENDOR_DATA	0x01DBEEF0
+#define DDF1_BAD_BLOCKS		0xABADB10C
+#define DDF1_INVALID		0xFFFFFFFF
+
+/* DDF1 version string */
+#define DDF1_VER_STRING		"01.00.00"
+
+/* The DDF1 header table */
+struct ddf1_header {
+	uint32_t	signature;
+	uint32_t	crc;
+	uint8_t		guid[DDF1_GUID_LENGTH];
+	uint8_t		ddf_rev[DDF1_REV_LENGTH];
+	uint32_t	seqnum;
+	uint32_t	timestamp;
+	uint8_t		open_flag;
+	uint8_t		foreign_flag;
+	uint8_t		grouping_enforced;
+	uint8_t		reserved2[45];
+	uint64_t	primary_table_lba;
+	uint64_t	secondary_table_lba;
+	uint8_t		header_type;
+	uint8_t		reserved3[3];
+	uint32_t	workspace_length;
+	uint64_t	workspace_lba;
+	uint16_t	max_phys_drives;
+	uint16_t	max_virt_drives;
+	uint16_t	max_partitions;
+	uint16_t	vd_config_record_len;
+	uint16_t	max_primary_elements;
+	uint8_t		reserved4[54];
+	uint32_t	adapter_data_offset;
+	uint32_t	adapter_data_len;
+	uint32_t	phys_drive_offset;
+	uint32_t	phys_drive_len;
+	uint32_t	virt_drive_offset;
+	uint32_t	virt_drive_len;
+	uint32_t	config_record_offset;
+	uint32_t	config_record_len;
+	uint32_t	disk_data_offset;
+	uint32_t	disk_data_len;
+	uint32_t	badblock_offset;
+	uint32_t	badblock_len;
+	uint32_t	diag_offset;
+	uint32_t	diag_len;
+	uint32_t	vendor_offset;
+	uint32_t	vendor_len;
+	uint8_t		reserved5[256];
+} __attribute__ ((packed));
+
+/* The adapter data header */
+struct ddf1_adapter {
+	uint32_t	signature;
+	uint32_t	crc;
+	uint8_t		guid[DDF1_GUID_LENGTH];
+	uint16_t	pci_vendor;
+	uint16_t	pci_device;
+	uint16_t	pci_subvendor;
+	uint16_t	pci_subdevice;
+	uint8_t		reserved2[24];
+	uint8_t		adapter_data[448];
+} __attribute__ ((packed));
+
+/* Physical drive info */
+struct ddf1_disk_data {
+	uint32_t	signature;
+	uint32_t	crc;
+	uint8_t		guid[DDF1_GUID_LENGTH];
+	uint32_t	reference;
+	uint8_t		forced_ref_flag;
+	uint8_t		forced_guid_flag;
+	uint8_t		scratch[32];
+	uint8_t		reserved[442];
+} __attribute__ ((packed));
+
+/* Physical drive record header */
+struct ddf1_phys_drives {
+	uint32_t	signature;
+	uint32_t	crc;
+	uint16_t	num_drives;
+	uint16_t	max_drives;
+	uint8_t		reserved2[52];
+	/* 64 bytes */
+	/* Drive records follow */
+} __attribute__ ((packed));
+
+/* Physical drive record */
+struct ddf1_phys_drive {
+	uint8_t		guid[DDF1_GUID_LENGTH];
+	uint32_t	reference;
+	uint16_t	type;
+	uint16_t	state;
+	uint64_t	size;
+	uint8_t		path_info[18];
+	uint8_t		reserved3[6];
+} __attribute__ ((packed));
+
+/* Virtual drive record header */
+struct ddf1_virt_drives {
+	uint32_t	signature;
+	uint32_t	crc;
+	uint16_t	num_drives;
+	uint16_t	max_drives;
+	uint8_t		reserved2[52];
+	/* Drive records follow */
+} __attribute__ ((packed));
+
+/* Virtual drive record */
+struct ddf1_virt_drive {
+	uint8_t		guid[DDF1_GUID_LENGTH];
+	uint16_t	vd_num;
+	uint16_t	reserved2;
+	uint32_t	type;
+	uint8_t		state;
+	uint8_t		init_state;
+	uint8_t		reserved3[14];
+	uint8_t		name[16];
+} __attribute__ ((packed));
+
+/* Virtual disk configuration record. */
+struct ddf1_config_record {
+	uint32_t	signature;
+	uint32_t	crc;
+	uint8_t		guid[DDF1_GUID_LENGTH];
+	uint32_t	timestamp;
+	uint32_t	seqnum;
+	uint8_t		reserved[24];
+	uint16_t	primary_element_count;
+	uint8_t		stripe_size;
+	uint8_t		raid_level;
+	uint8_t		raid_qualifier;
+	uint8_t		secondary_element_count;
+	uint8_t		secondary_element_number;
+	uint8_t		secondary_element_raid_level;
+	uint64_t	sectors;
+	uint64_t	size;
+	uint64_t	reserved2;
+	uint32_t	spares[8];
+	uint64_t	cache_policy;
+	uint8_t		bg_task_rate;
+	/* 137 bytes */
+	uint8_t		reserved3[3+52+192+32+32+16+16+32];
+	/* 512 bytes */
+} __attribute__ ((packed));
+
+/* Spare disk record */
+struct ddf1_spare {
+	uint8_t		guid[DDF1_GUID_LENGTH];
+	uint16_t	secondary_element;
+	uint8_t		reserved[6];
+} __attribute__ ((packed));
+
+/* Spare disk assignment record */
+struct ddf1_spare_header {
+	uint32_t	signature;
+	uint32_t	crc;
+	uint32_t	timestamp;
+	uint8_t		reserved[7];
+	uint8_t		type;
+	uint16_t	num_spares;
+	uint16_t	max_spares;
+	uint8_t		reserved2[8];
+	struct ddf1_spare	spares[0];
+} __attribute__ ((packed));
+
+/* Metadata owner */
+struct ddf1 {
+	struct ddf1_header anchor;
+	uint64_t anchor_offset;
+
+	struct ddf1_header *primary, *secondary;
+	struct ddf1_adapter *adapter;
+	struct ddf1_disk_data *disk_data;
+	struct ddf1_phys_drives *pd_header;
+	struct ddf1_phys_drive *pds;
+	struct ddf1_virt_drives *vd_header;
+	struct ddf1_virt_drive *vds;
+	struct ddf1_config_record *cfg;
+
+	int disk_format;
+	int in_cpu_format;
+	int adaptec_mode;
+};
+
+#endif /* FORMAT_HANDLER */
+
+int register_ddf1(struct lib_context *lc);
+
+#endif /* _DDF1_H */
/cvs/dm/dmraid/lib/format/ddf/ddf1_crc.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_crc.c
+++ -	2008-02-22 17:04:41.774069000 +0000
@@ -0,0 +1,178 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by James Simshaw <simshawj@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+
+#define FORMAT_HANDLER
+#include "ddf1.h"
+#include "ddf1_crc.h"
+#include "ddf1_lib.h"
+#include "zlib.h"
+
+#define DM_BYTEORDER_SWAB
+#include <datastruct/byteorder.h>
+
+/* CRC info for various functions below */
+struct crc_info {
+	void *p;
+	uint32_t *crc;
+	size_t size;
+	const char *text;
+};
+
+/* Compute the checksum of a table */
+static uint32_t do_crc32(struct lib_context *lc, struct crc_info *ci)
+{
+	uint32_t old_csum = *ci->crc, ret = crc32(0, NULL, 0); /* Init CRC */
+
+	*ci->crc = 0xFFFFFFFF;
+	ret = crc32(ret, ci->p, ci->size); /* zlib */
+	*ci->crc = old_csum;
+	return ret;
+}
+
+static inline size_t record_size(struct ddf1 *ddf1)
+{
+	return ddf1->primary->vd_config_record_len * DDF1_BLKSIZE;
+}
+
+#define CRC32(postfix, record_type, macro) \
+static int crc32_ ## postfix(struct lib_context *lc, struct dev_info *di, \
+			     struct ddf1 *ddf1, int idx) \
+{ \
+	struct record_type *r = macro(ddf1, idx); \
+	struct crc_info ci = { \
+		.p = r, \
+		.crc = &r->crc, \
+		.size = record_size(ddf1), \
+	}; \
+\
+	r->crc = do_crc32(lc, &ci); \
+	return 1; \
+}
+
+CRC32(vd, ddf1_config_record, CR);
+CRC32(spare, ddf1_spare_header, SR);
+#undef CRC32
+
+
+/* Process the configuration records to have their CRCs updated */
+static int update_cfg_crc(struct lib_context *lc, struct dev_info *di,
+			  struct ddf1 *ddf1)
+{
+	static struct ddf1_record_handler handlers = {
+		.vd = crc32_vd,
+		.spare = crc32_spare,
+	};
+
+	ddf1_process_records(lc, di, &handlers, ddf1, 0);
+	return 1;
+}
+
+/* Checks the CRC for a particular table */
+static int check_crc(struct lib_context *lc, struct dev_info *di,
+		     struct crc_info *ci)
+{
+	uint32_t crc32;
+
+	crc32 = do_crc32(lc, ci);
+	if (*ci->crc != crc32)
+		log_warn(lc, "%s: %s with CRC %X, expected %X on %s",
+			 HANDLER, ci->text, crc32, *ci->crc, di->path);
+	
+	return 1;
+
+}
+
+#define	CHECK_CRC(prefix, record_type, macro, txt) \
+static int prefix ## _check_crc(struct lib_context *lc, struct dev_info *di, \
+				struct ddf1 *ddf1, int idx) \
+{ \
+	struct record_type *r = macro(ddf1, idx); \
+	struct crc_info ci = { \
+		.p = r, \
+		.crc = &r->crc, \
+		.size = record_size(ddf1), \
+		.text = txt, \
+	}; \
+\
+	return check_crc(lc, di, &ci); \
+}
+CHECK_CRC(vd, ddf1_config_record, CR, "VD CFG");
+CHECK_CRC(spare, ddf1_spare_header, SR, "Spare CFG");
+#undef CHECK_CRC
+
+/* Process the configuration records to have their CRCs checked */
+static int check_cfg_crc(struct lib_context *lc, struct dev_info *di,
+			 struct ddf1 *ddf1)
+{
+	struct ddf1_record_handler handlers = {
+		.vd = vd_check_crc,
+		.spare = spare_check_crc,
+	};
+
+	return ddf1_process_records(lc, di, &handlers, ddf1, 0);
+}
+
+
+/* Processes all of the DDF1 information for having their CRCs updated*/
+enum all_type { CHECK, UPDATE };
+static int all_crcs(struct lib_context *lc, struct dev_info *di,
+		    struct ddf1 *ddf1, enum all_type type)
+{
+	int ret = 1;
+	uint32_t crc;
+	struct crc_info crcs[] = {
+		{ ddf1->primary, &ddf1->primary->crc, 
+		  sizeof(*ddf1->primary), "primary header" },
+		{ ddf1->secondary, &ddf1->secondary->crc,
+		  sizeof(*ddf1->secondary), "secondary header" },
+		{ ddf1->adapter, &ddf1->adapter->crc, 
+		  ddf1->primary->adapter_data_len * DDF1_BLKSIZE, "adapter" },
+		{ ddf1->disk_data, &ddf1->disk_data->crc, 
+		  ddf1->primary->disk_data_len * DDF1_BLKSIZE, "disk data" },
+		{ ddf1->pd_header, &ddf1->pd_header->crc, 
+		  ddf1->primary->phys_drive_len * DDF1_BLKSIZE,
+		  "physical drives" },
+		{ ddf1->vd_header, &ddf1->vd_header->crc, 
+		  ddf1->primary->virt_drive_len * DDF1_BLKSIZE,
+		  "virtual drives" },
+	}, *c = ARRAY_END(crcs);
+
+	while (c-- > crcs) {
+		if (c->p) {
+			if (type == CHECK)
+				ret &= check_crc(lc, di, c);
+			else {
+				crc = do_crc32(lc, c);
+				*c->crc = crc;
+			}
+		}
+	}
+
+	return type == CHECK ? ret & check_cfg_crc(lc, di, ddf1) :
+			       update_cfg_crc(lc, di, ddf1);
+}
+
+/* Processes the tables to check their CRCs */
+int ddf1_check_all_crcs(struct lib_context *lc, struct dev_info *di,
+			struct ddf1 *ddf1)
+{
+	return all_crcs(lc, di, ddf1, CHECK);
+}
+
+/* Processes all of the DDF1 information for having their CRCs updated */
+void ddf1_update_all_crcs(struct lib_context *lc, struct dev_info *di,
+			  struct ddf1 *ddf1)
+{
+	all_crcs(lc, di, ddf1, UPDATE);
+}
/cvs/dm/dmraid/lib/format/ddf/ddf1_crc.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_crc.h
+++ -	2008-02-22 17:04:41.890347000 +0000
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2006 Heinz Mauelshage, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Copyright (C) 2006  Heinz Mauelshagen, Red Hat GmbH.
+ *                     All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_DDF1_CRC_H_
+#define	_DDF1_CRC_H_
+
+int ddf1_check_all_crcs(struct lib_context *lc, struct dev_info *di,
+			struct ddf1 *ddf1);
+void ddf1_update_all_crcs(struct lib_context *lc, struct dev_info *di,
+			  struct ddf1 *ddf1);
+
+#endif
/cvs/dm/dmraid/lib/format/ddf/ddf1_cvt.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_cvt.c
+++ -	2008-02-22 17:04:41.991594000 +0000
@@ -0,0 +1,254 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+#define FORMAT_HANDLER
+#include "ddf1.h"
+#include "ddf1_lib.h"
+#include "ddf1_cvt.h"
+
+#define DM_BYTEORDER_SWAB
+#include <datastruct/byteorder.h>
+
+/* Convert a DDF header */
+void ddf1_cvt_header(struct ddf1 *ddf1, struct ddf1_header *hdr)
+{
+	if (BYTE_ORDER == ddf1->disk_format)
+		return;
+
+	CVT32(hdr->signature);
+	CVT32(hdr->crc);
+	CVT32(hdr->seqnum);
+	CVT32(hdr->timestamp);
+	CVT64(hdr->primary_table_lba);
+	CVT64(hdr->secondary_table_lba);
+	CVT32(hdr->workspace_length);
+	CVT64(hdr->workspace_lba);
+	CVT16(hdr->max_phys_drives);
+	CVT16(hdr->max_virt_drives);
+	CVT16(hdr->max_partitions);
+	CVT16(hdr->vd_config_record_len);
+	CVT16(hdr->max_primary_elements);
+	CVT32(hdr->adapter_data_offset);
+	CVT32(hdr->adapter_data_len);
+	CVT32(hdr->phys_drive_offset);
+	CVT32(hdr->phys_drive_len);
+	CVT32(hdr->virt_drive_offset);
+	CVT32(hdr->virt_drive_len);
+	CVT32(hdr->config_record_offset);
+	CVT32(hdr->config_record_len);
+	CVT32(hdr->disk_data_offset);
+	CVT32(hdr->disk_data_len);
+	CVT32(hdr->badblock_offset);
+	CVT32(hdr->badblock_len);
+	CVT32(hdr->diag_offset);
+	CVT32(hdr->diag_len);
+	CVT32(hdr->vendor_offset);
+	CVT32(hdr->vendor_len);
+}
+
+/* Convert DDF adapter data */
+void ddf1_cvt_adapter(struct ddf1 *ddf1, struct ddf1_adapter *hdr)
+{
+	if (BYTE_ORDER == ddf1->disk_format)
+		return;
+
+	CVT32(hdr->signature);
+	CVT32(hdr->crc);
+	CVT16(hdr->pci_vendor);
+	CVT16(hdr->pci_device);
+	CVT16(hdr->pci_subvendor);
+	CVT16(hdr->pci_subdevice);
+}
+
+/* Convert physical disk data */
+void ddf1_cvt_disk_data(struct ddf1 *ddf1, struct ddf1_disk_data *hdr)
+{
+	if (BYTE_ORDER == ddf1->disk_format)
+		return;
+
+	CVT32(hdr->signature);
+	CVT32(hdr->crc);
+	CVT32(hdr->reference);
+}
+
+/* Convert physical drive header data */
+void ddf1_cvt_phys_drive_header(struct ddf1 *ddf1, struct ddf1_phys_drives *hdr)
+{
+	if (BYTE_ORDER == ddf1->disk_format)
+		return;
+
+	CVT32(hdr->signature);
+	CVT32(hdr->crc);
+	CVT16(hdr->num_drives);
+	CVT16(hdr->max_drives);
+}
+
+/* Convert physical drive data */
+void ddf1_cvt_phys_drive(struct ddf1 *ddf1, struct ddf1_phys_drive *hdr)
+{
+	if (BYTE_ORDER == ddf1->disk_format)
+		return;
+
+	CVT32(hdr->reference);
+	CVT16(hdr->type);
+	CVT16(hdr->state);
+	CVT64(hdr->size);
+}
+
+/* Convert virtual drive header data */
+void ddf1_cvt_virt_drive_header(struct ddf1 *ddf1, struct ddf1_virt_drives *hdr)
+{
+	if (BYTE_ORDER == ddf1->disk_format)
+		return;
+
+	CVT32(hdr->signature);
+	CVT32(hdr->crc);
+	CVT16(hdr->num_drives);
+	CVT16(hdr->max_drives);
+}
+
+/* Convert virtual drive data */
+void ddf1_cvt_virt_drive(struct ddf1 *ddf1, struct ddf1_virt_drive *hdr)
+{
+	if (BYTE_ORDER == ddf1->disk_format)
+		return;
+
+	CVT32(hdr->vd_num);
+	CVT32(hdr->type);
+}
+
+/* Convert config record data */
+int ddf1_cvt_config_record(struct lib_context *lc, struct dev_info *di,
+			   struct ddf1 *ddf1, int idx)
+{
+	unsigned int i;
+	uint16_t max_pds;
+	uint32_t *ids, x;
+	uint64_t *off;
+	struct ddf1_config_record *hdr = CR(ddf1, idx);
+
+	if (BYTE_ORDER == ddf1->disk_format)
+		return 1;
+
+	max_pds = hdr->primary_element_count;
+	ids = CR_IDS(ddf1, hdr);
+
+	/* This chunk is derived from CR_OFF */
+	x = ddf1_cr_off_maxpds_helper(ddf1);
+	if (ddf1->primary->signature == DDF1_HEADER_BACKWARDS)
+		CVT32(x);
+
+	off = ((uint64_t*) (((uint8_t*) hdr) + sizeof(*hdr) + (x * sizeof(x))));
+
+	CVT32(hdr->signature);
+	CVT32(hdr->crc);
+	CVT32(hdr->timestamp);
+	CVT32(hdr->seqnum);
+	CVT16(hdr->primary_element_count);
+	if (!ddf1->in_cpu_format)
+		max_pds = hdr->primary_element_count;
+
+	CVT64(hdr->sectors);
+	CVT64(hdr->size);
+	for (i = 0; i < 8; i++)
+		CVT32(hdr->spares[i]);
+
+	CVT64(hdr->cache_policy);
+	for (i = 0; i < max_pds; i++) {
+		CVT32(ids[i]);
+		CVT64(off[i]);
+	}
+	return 1;
+}
+
+/* Convert spare records */
+int ddf1_cvt_spare_record(struct lib_context *lc, struct dev_info *di,
+			  struct ddf1 *ddf1, int idx)
+{
+	uint16_t x, i;
+	struct ddf1_spare_header *sh = SR(ddf1, idx);
+
+	if (BYTE_ORDER == ddf1->disk_format)
+		return 1;
+
+	CVT32(sh->signature);
+	CVT32(sh->crc);
+	CVT32(sh->timestamp);
+	CVT16(sh->max_spares);
+	x = sh->num_spares;
+	CVT16(sh->num_spares);
+	if (!ddf1->in_cpu_format)
+		x = sh->num_spares;
+
+	for (i = 0; i < x; i++)
+		CVT16(sh->spares[i].secondary_element);
+
+	return 1;
+}
+
+void ddf1_cvt_records(struct lib_context *lc, struct dev_info *di,
+		 struct ddf1 *ddf1, int in_cpu_format)
+{
+	static struct ddf1_record_handler handlers = {
+		.vd = ddf1_cvt_config_record,
+		.spare = ddf1_cvt_spare_record,
+	};
+
+	ddf1_process_records(lc, di, &handlers, ddf1, in_cpu_format);
+}
+
+/* Convert endianness of all metadata */
+void ddf1_cvt_all(struct lib_context *lc, struct ddf1 *ddf1,
+		  struct dev_info *di)
+{
+	int i;
+	uint16_t pds = 0, vds = 0;
+
+	ddf1_cvt_header(ddf1, &ddf1->anchor);
+	if (ddf1->in_cpu_format)
+		ddf1_cvt_records(lc, di, ddf1, ddf1->in_cpu_format);
+
+	ddf1_cvt_header(ddf1, ddf1->primary);
+	if (!ddf1->in_cpu_format)
+		ddf1_cvt_records(lc, di, ddf1, ddf1->in_cpu_format);
+
+	if (ddf1->secondary)
+		ddf1_cvt_header(ddf1, ddf1->secondary);
+
+	if (ddf1->adapter)
+		ddf1_cvt_adapter(ddf1, ddf1->adapter);
+
+	ddf1_cvt_disk_data(ddf1, ddf1->disk_data);
+
+	if (ddf1->in_cpu_format)
+		pds = ddf1->pd_header->num_drives;
+
+	ddf1_cvt_phys_drive_header(ddf1, ddf1->pd_header);
+	if (!ddf1->in_cpu_format)
+		pds = ddf1->pd_header->num_drives;
+
+	for (i = 0; i < pds; i++)
+		ddf1_cvt_phys_drive(ddf1, &ddf1->pds[i]);
+
+	if (ddf1->in_cpu_format)
+		vds = ddf1->vd_header->num_drives;
+
+	ddf1_cvt_virt_drive_header(ddf1, ddf1->vd_header);
+	if (!ddf1->in_cpu_format)
+		vds = ddf1->vd_header->num_drives;
+
+	for (i = 0; i < vds; i++)
+		ddf1_cvt_virt_drive(ddf1, &ddf1->vds[i]);
+
+	ddf1->in_cpu_format = !ddf1->in_cpu_format;
+}
/cvs/dm/dmraid/lib/format/ddf/ddf1_cvt.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_cvt.h
+++ -	2008-02-22 17:04:42.116921000 +0000
@@ -0,0 +1,36 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _DDF1_CVT_H_
+#define _DDF1_CVT_H_
+
+#include "internal.h"
+
+void ddf1_cvt_header(struct ddf1 *ddf1, struct ddf1_header *hdr);
+void ddf1_cvt_adapter(struct ddf1 *ddf1, struct ddf1_adapter *hdr);
+void ddf1_cvt_disk_data(struct ddf1 *ddf1, struct ddf1_disk_data *hdr);
+void ddf1_cvt_phys_drive_header(struct ddf1 *ddf1,
+				struct ddf1_phys_drives *hdr);
+void ddf1_cvt_phys_drive(struct ddf1 *ddf1, struct ddf1_phys_drive *hdr);
+void ddf1_cvt_virt_drive_header(struct ddf1 *ddf1,
+				struct ddf1_virt_drives *hdr);
+void ddf1_cvt_virt_drive(struct ddf1 *ddf1, struct ddf1_virt_drive *hdr);
+int ddf1_cvt_config_record(struct lib_context *lc, struct dev_info *di,
+			   struct ddf1 *ddf1, int idx);
+int ddf1_cvt_spare_record(struct lib_context *lc, struct dev_info *di,
+			  struct ddf1 *ddf1, int idx);
+void ddf1_cvt_records(struct lib_context *lc, struct dev_info *di,
+		 struct ddf1 *ddf1, int in_cpu_format);
+void ddf1_cvt_all(struct lib_context *lc, struct ddf1 *ddf1,
+		  struct dev_info *di);
+
+#endif
/cvs/dm/dmraid/lib/format/ddf/ddf1_dump.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_dump.c
+++ -	2008-02-22 17:04:42.195186000 +0000
@@ -0,0 +1,281 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifdef DMRAID_NATIVE_LOG
+
+#include "internal.h"
+#define FORMAT_HANDLER
+#include "ddf1.h"
+#include "ddf1_lib.h"
+
+/* Print DDF GUIDs. */
+#ifdef  NATIVE_LOG_OFFSET
+
+#define DP_BUF(name, basevar, x, len) do { \
+	_dp_guid(lc, name, P_OFF(x, basevar, x), len);\
+} while (0)
+
+#define DP_GUID(name, basevar, x) do {\
+_dp_guid(lc, name, P_OFF(x, basevar, x), DDF1_GUID_LENGTH);\
+} while (0)
+
+static void _dp_guid(struct lib_context *lc, const char *name,
+		     unsigned int offset, void *data, unsigned int len)
+{
+	char *p;
+	int i;
+
+	p = data;
+	log_print_nnl(lc, "0x%03x %s\"", offset, name);
+	for (i = 0; i < len; i++)
+		log_print_nnl(lc, "%c",
+			      (isgraph(p[i]) || p[i] == ' ' ? p[i] : '.'));
+
+	log_print_nnl(lc, "\" [");
+	for (i = 0; i < len; i++)
+		log_print_nnl(lc, "%s%02x", (i != 0 ? " " : ""), p[i] & 0xFF);
+
+	log_print_nnl(lc, "]\n");
+}
+#else
+#define DP_BUF(name, basevar, x, len)
+#define DP_GUID(name, basevar, x)
+#endif
+
+/* Dump top */
+static void dump_top(struct lib_context *lc, struct dev_info *di,
+		     struct ddf1 *ddf1, const char *handler)
+{
+	log_print(lc, "%s (%s):", di->path, handler);
+	log_print(lc, "DDF1 anchor at %llu with tables in %s-endian format.",
+		  ddf1->anchor_offset / DDF1_BLKSIZE,
+		  (ddf1->disk_format == LITTLE_ENDIAN ? "little" : "big"));
+}
+	
+/* Dump DDF tables. */
+static void dump_header(struct lib_context *lc, struct ddf1_header *dh)
+{
+	if (!dh)
+		return;
+
+	log_print(lc, "DDF1 Header at %p", dh);
+	DP("signature:\t0x%X", dh, dh->signature);
+	DP("crc:\t\t0x%X", dh, dh->crc);
+	DP_GUID("guid:\t\t", dh, dh->guid);
+	DP_BUF("rev:\t\t", dh, dh->ddf_rev, DDF1_REV_LENGTH);
+	DP("seqnum:\t\t%d", dh, dh->seqnum);
+	DP("timestamp:\t0x%X", dh, dh->timestamp);
+	DP("open:\t\t0x%X", dh, dh->open_flag);
+	DP("foreign:\t\t0x%X", dh, dh->foreign_flag);
+	DP("grouping:\t\t0x%X", dh, dh->grouping_enforced);
+	DP("primary header:\t%lu", dh, dh->primary_table_lba);
+	DP("secondary header:\t%lu", dh, dh->secondary_table_lba);
+	DP("header type:\t0x%X", dh, dh->header_type);
+	DP("workspace len:\t%d", dh, dh->workspace_length);
+	DP("workspace lba:\t%lu", dh, dh->workspace_lba);
+	DP("max pd:\t\t%d", dh, dh->max_phys_drives);
+	DP("max vd:\t\t%d", dh, dh->max_virt_drives);
+	DP("max part:\t\t%d", dh, dh->max_partitions);
+	DP("vd_config len:\t%d", dh, dh->vd_config_record_len);
+	DP("max_primary_elts:\t%d", dh, dh->max_primary_elements);
+	DP("adapter_offset:\t%d", dh, dh->adapter_data_offset);
+	DP("adapter_len:\t%d", dh, dh->adapter_data_len);
+	DP("pd_offset:\t%d", dh, dh->phys_drive_offset);
+	DP("pd_len:\t\t%d", dh, dh->phys_drive_len);
+	DP("vd_offset:\t%d", dh, dh->virt_drive_offset);
+	DP("vd_len:\t\t%d", dh, dh->virt_drive_len);
+	DP("config_offset:\t%d", dh, dh->config_record_offset);
+	DP("config_len:\t%d", dh, dh->config_record_len);
+	DP("disk_data_offset:\t%d", dh, dh->disk_data_offset);
+	DP("disk_data_len:\t%d", dh, dh->disk_data_len);
+	DP("badblock_offset:\t%d", dh, dh->badblock_offset);
+	DP("badblock_len:\t%d", dh, dh->badblock_len);
+	DP("diag_offset:\t%d", dh, dh->diag_offset);
+	DP("diag_len:\t\t%d", dh, dh->diag_len);
+	DP("vendor_offset:\t%d", dh, dh->vendor_offset);
+	DP("vendor_len:\t%d", dh, dh->vendor_len);
+}
+
+static void dump_adapter(struct lib_context *lc, struct ddf1_adapter *da)
+{
+	if (!da)
+		return;
+
+	log_print(lc, "Adapter Data at %p", da);
+	DP("signature:\t0x%X", da, da->signature);
+	DP("crc:\t\t0x%X", da, da->crc);
+	DP_GUID("guid:\t\t", da, da->guid);
+	DP("pci vendor:\t0x%X", da, da->pci_vendor);
+	DP("pci device:\t0x%X", da, da->pci_device);
+	DP("pci subvendor:\t0x%X", da, da->pci_subvendor);
+	DP("pci subdevice:\t0x%X", da, da->pci_subdevice);
+}
+
+static void dump_disk_data(struct lib_context *lc, struct ddf1_disk_data *fg)
+{
+	log_print(lc, "Disk Data at %p", fg);
+	DP("signature:\t0x%X", fg, fg->signature);
+	DP("crc:\t\t0x%X", fg, fg->crc);
+	DP_GUID("guid:\t\t", fg, fg->guid);
+	DP("reference:\t\t0x%X", fg, fg->reference);
+	DP("forced_ref_flag:\t%d", fg, fg->forced_ref_flag);
+	DP("forced_guid_flag:\t%d", fg, fg->forced_guid_flag);
+}
+
+static void dump_phys_drive_header(struct lib_context *lc,
+				   struct ddf1_phys_drives *pd)
+{
+	log_print(lc, "Physical Drive Header at %p", pd);
+	DP("signature:\t0x%X", pd, pd->signature);
+	DP("crc:\t\t0x%X", pd, pd->crc);
+	DP("num drives:\t%d", pd, pd->num_drives);
+	DP("max drives:\t%d", pd, pd->max_drives);
+}
+
+static void dump_phys_drive(struct lib_context *lc, struct ddf1_phys_drive *pd)
+{
+	log_print(lc, "Physical Drive at %p", pd);
+	DP_GUID("guid:\t\t", pd, pd->guid);
+	DP("reference #:\t0x%X", pd, pd->reference);
+	DP("type:\t\t0x%X", pd, pd->type);
+	DP("state:\t\t0x%X", pd, pd->state);
+	DP("size:\t\t%llu", pd, pd->size);
+	DP_BUF("path info:\t", pd, pd->path_info, 18);
+}
+
+static void dump_virt_drive_header(struct lib_context *lc,
+				   struct ddf1_virt_drives *vd)
+{
+	log_print(lc, "Virtual Drive Header at %p", vd);
+	DP("signature:\t0x%X", vd, vd->signature);
+	DP("crc:\t\t0x%X", vd, vd->crc);
+	DP("num drives:\t%d", vd, vd->num_drives);
+	DP("max drives:\t%d", vd, vd->max_drives);
+}
+
+static void dump_virt_drive(struct lib_context *lc, struct ddf1_virt_drive *vd)
+{
+	log_print(lc, "Virtual Drive at %p", vd);
+	DP_GUID("guid:\t\t", vd, vd->guid);
+	DP("vd #:\t\t0x%X", vd, vd->vd_num);
+	DP("type:\t\t0x%X", vd, vd->type);
+	DP("state:\t\t0x%X", vd, vd->state);
+	DP("init state:\t0x%X", vd, vd->init_state);
+	DP_BUF("name:\t\t", vd, vd->name, 16);
+}
+
+static int dump_config_record(struct lib_context *lc, struct dev_info *di,
+			      struct ddf1 *ddf, int idx)
+{
+	int i;
+	uint16_t x;
+	uint32_t *cfg_drive_ids;
+	uint64_t *cfg_drive_offsets;
+	struct ddf1_config_record *cfg = CR(ddf, idx);
+
+	if (cfg->signature != DDF1_VD_CONFIG_REC)
+		return 1;
+
+	log_print(lc, "Virtual Drive Config Record at %p", cfg);
+	DP("signature:\t0x%X", cfg, cfg->signature);
+	DP("crc:\t\t0x%X", cfg, cfg->crc);
+	DP_GUID("guid:\t\t", cfg, cfg->guid);
+	DP("timestamp:\t0x%X", cfg, cfg->timestamp);
+	DP("seqnum:\t\t%d", cfg, cfg->seqnum);
+	DP("primary count:\t%d", cfg, cfg->primary_element_count);
+	DP("stripe size:\t%dKiB", cfg, cfg->stripe_size);
+	DP("raid level:\t%d", cfg, cfg->raid_level);
+	DP("raid qualifier:\t%d", cfg, cfg->raid_qualifier);
+	DP("secondary count:\t%d", cfg, cfg->secondary_element_count);
+	DP("secondary number:\t%d", cfg, cfg->secondary_element_number);
+	DP("secondary level:\t%d", cfg, cfg->secondary_element_raid_level);
+	DP("spare 0:\t\t0x%X", cfg, cfg->spares[0]);
+	DP("spare 1:\t\t0x%X", cfg, cfg->spares[1]);
+	DP("spare 2:\t\t0x%X", cfg, cfg->spares[2]);
+	DP("spare 3:\t\t0x%X", cfg, cfg->spares[3]);
+	DP("spare 4:\t\t0x%X", cfg, cfg->spares[4]);
+	DP("spare 5:\t\t0x%X", cfg, cfg->spares[5]);
+	DP("spare 6:\t\t0x%X", cfg, cfg->spares[6]);
+	DP("spare 7:\t\t0x%X", cfg, cfg->spares[7]);
+	DP("cache policy:\t0x%X", cfg, cfg->cache_policy);
+	DP("bg task rate:\t%d", cfg, cfg->bg_task_rate);
+	DP("sector count:\t%llu", cfg, cfg->sectors);
+	DP("size:\t\t%llu", cfg, cfg->size);
+	cfg_drive_ids = CR_IDS(ddf, cfg);
+	cfg_drive_offsets = CR_OFF(ddf, cfg);
+
+	x = cfg->primary_element_count;
+	log_print(lc, "Drive map:");
+	for (i = 0; i < x; i++) {
+		log_print(lc, "%d: %X @ %lu", i, cfg_drive_ids[i],
+			  cfg_drive_offsets[i]);
+	}
+	return 1;
+}	
+
+static int dump_spares(struct lib_context *lc, struct dev_info *di,
+		       struct ddf1 *ddf1, int idx)
+{
+	int i;
+	struct ddf1_spare_header *sh = SR(ddf1, idx);
+
+	log_print(lc, "Spare Config Record at %p", sh);
+	DP("signature:\t0x%X", sh, sh->signature);
+	DP("crc:\t\t0x%X", sh, sh->crc);
+	DP("timestamp:\t0x%X", sh, sh->timestamp);
+	DP("type:\t\t0x%X", sh, sh->type);
+	DP("num drives:\t%d", sh, sh->num_spares);
+	DP("max drives:\t%d", sh, sh->max_spares);
+
+	for (i = 0; i < sh->num_spares; i++) {
+		log_print(lc, "Spare %d:", i);
+		DP_GUID("guid:\t\t", sh, sh->spares[i].guid);
+		DP("secondary:\t%d", sh, sh->spares[i].secondary_element);
+	}
+	return 1;
+}
+
+static void dump_config_records(struct lib_context *lc, struct dev_info *di,
+				struct ddf1 *ddf1)
+{
+	static struct ddf1_record_handler handlers = {
+		.vd = dump_config_record,
+		.spare = dump_spares,
+	};
+
+	ddf1_process_records(lc, di, &handlers, ddf1, 1);
+}
+
+/* Dump the entire table */
+void ddf1_dump_all(struct lib_context *lc, struct dev_info *di,
+		   struct ddf1 *ddf1, const char *handler)
+{
+	int i;
+
+	dump_top(lc, di, ddf1, handler);
+	dump_header(lc, &ddf1->anchor);
+	dump_header(lc, ddf1->primary);
+	dump_header(lc, ddf1->secondary);
+	dump_adapter(lc, ddf1->adapter);
+	dump_disk_data(lc, ddf1->disk_data);
+	dump_phys_drive_header(lc, ddf1->pd_header);
+	for (i = 0; i < ddf1->pd_header->num_drives; i++)
+		dump_phys_drive(lc, ddf1->pds + i);
+
+	dump_virt_drive_header(lc, ddf1->vd_header);
+	for (i = 0; i < ddf1->vd_header->num_drives; i++)
+		dump_virt_drive(lc, ddf1->vds + i);
+
+	dump_config_records(lc, di, ddf1);
+}
+
+#endif /* DMRAID_NATIVE_LOG */
/cvs/dm/dmraid/lib/format/ddf/ddf1_dump.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_dump.h
+++ -	2008-02-22 17:04:42.273199000 +0000
@@ -0,0 +1,24 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifdef DMRAID_NATIVE_LOG
+
+#include "internal.h"
+
+#ifndef _DDF1_DUMP_H_
+#define _DDF1_DUMP_H_
+
+void ddf1_dump_all(struct lib_context *lc, struct dev_info *di,
+		   struct ddf1 *ddf1, const char *handler);
+
+#endif /* _DDF1_DUMP_H */
+#endif /* DMRAID_NATIVE_LOG */
/cvs/dm/dmraid/lib/format/ddf/ddf1_lib.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_lib.c
+++ -	2008-02-22 17:04:42.350222000 +0000
@@ -0,0 +1,102 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+
+#define	FORMAT_HANDLER
+#include "ddf1.h"
+#include "ddf1_lib.h"
+
+#define DM_BYTEORDER_SWAB
+#include <datastruct/byteorder.h>
+
+/* Figure out what endian conversions we need */
+int ddf1_endianness(struct lib_context *lc, struct ddf1 *ddf1)
+{
+	uint8_t *ptr = (uint8_t*) &ddf1->anchor.signature;
+
+	if (ptr[0] == 0xDE && ptr[1] == 0x11)
+		return BIG_ENDIAN;
+	else if (ptr[0] == 0x11 && ptr[1] == 0xDE)
+		return LITTLE_ENDIAN;
+	else
+		LOG_ERR(lc, -EINVAL, "Can't figure out endianness!");
+}
+
+/* Find the beginning of all DDF metadata */
+uint64_t ddf1_beginning(struct ddf1 *ddf1)
+{
+	uint64_t start;
+	struct ddf1_header *h = &ddf1->anchor;
+
+	start = ddf1->anchor_offset;
+	if (h->primary_table_lba < start)
+		start = h->primary_table_lba;
+	if (h->secondary_table_lba < start)
+		start = h->secondary_table_lba;
+#ifdef WORKSPACE_IS_PART_OF_DDF
+	if (ddf1->primary->workspace_lba < start)
+		start = ddf1->primary->workspace_lba;
+#endif
+
+	return start;
+}
+
+/* Helper for CR_OFF */
+uint16_t ddf1_cr_off_maxpds_helper(struct ddf1 *ddf1)
+{
+	struct ddf1_header *h = ddf1->primary;
+
+	/* The 0xFFFF nonsense is a weird Adaptec quirk */
+	return (h->max_primary_elements == 0xFFFF && ddf1->adaptec_mode) ?
+		h->max_phys_drives : h->max_primary_elements;
+}
+
+/* Process DDF1 records depending on type */
+int ddf1_process_records(struct lib_context *lc, struct dev_info *di,
+			 struct ddf1_record_handler *handler,
+			 struct ddf1 *ddf1, int in_cpu_format)
+{
+	unsigned int i, cfgs = NUM_CONFIG_ENTRIES(ddf1);
+	uint32_t x;
+
+	for (i = 0; i < cfgs; i++) {
+		x = *((uint32_t*) CR(ddf1, i));
+		if (!in_cpu_format &&
+		    BYTE_ORDER != ddf1->disk_format)
+			CVT32(x);
+
+		switch (x) {
+			case DDF1_VD_CONFIG_REC:
+				if (!handler->vd(lc, di, ddf1, i))
+					return 0;
+
+				break;
+
+			case DDF1_SPARE_REC:
+				if (!handler->spare(lc, di, ddf1, i))
+					return 0;
+
+				break;
+
+			case 0: /* Adaptec puts zero in this field??? */
+			case DDF1_INVALID:
+				break;
+
+			default:
+				log_warn(lc, "%s: Unknown config record %d.",
+					 di->path, x);
+		}
+	}
+
+	return 1;
+}
/cvs/dm/dmraid/lib/format/ddf/ddf1_lib.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ddf/ddf1_lib.h
+++ -	2008-02-22 17:04:42.433453000 +0000
@@ -0,0 +1,53 @@
+/*
+ * SNIA DDF1 v1.0 metadata format handler.
+ *
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *                    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _DDF1_LIB_H
+#define _DDF1_LIB_H
+
+/* Cpmpare two GUIDs */
+static inline uint8_t _and(uint8_t *p)
+{
+	return p[20] & p[21] & p[22] & p[23];
+}
+
+static inline int guidcmp(uint8_t *one, uint8_t *two)
+{
+	int x = memcmp(one, two, DDF1_GUID_LENGTH - 4);
+
+	if (x)
+		return x;
+
+	return (_and(one) || _and(two)) ? 0 : memcmp(one + 20, two + 20, 4);
+}
+
+/* Byte offset for sector */
+static inline uint64_t to_bytes(uint64_t sector)
+{
+	return sector * DDF1_BLKSIZE;
+}
+
+uint64_t ddf1_beginning(struct ddf1 *ddf1);
+uint16_t ddf1_cr_off_maxpds_helper(struct ddf1 *ddf1);
+int ddf1_endianness(struct lib_context *lc, struct ddf1 *ddf1);
+
+struct ddf1_record_handler {
+	int (*vd)(struct lib_context *lc, struct dev_info *di,
+		  struct ddf1 *ddf1, int idx);
+	int (*spare)(struct lib_context *lc, struct dev_info *di,
+		     struct ddf1 *ddf1, int idx);
+};
+
+int ddf1_process_records(struct lib_context *lc, struct dev_info *di,
+			 struct ddf1_record_handler *handler,
+			 struct ddf1 *ddf1, int in_cpu_format);
+
+#endif
--- dmraid/lib/format/partition/dos.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/partition/dos.c	2008/02/22 17:04:36	1.2
@@ -143,6 +143,17 @@
 	return rs;
 }
 
+/* Check sector vs. RAID device end */
+static int rd_check_end(struct lib_context *lc,
+			struct raid_dev *rd, uint64_t sector)
+{
+	if (sector > rd->di->sectors)
+		LOG_ERR(lc, 1, "%s: partition address past end of RAID device",
+		 	handler);
+
+	return 0;
+}
+
 /*
  * Allocate a DOS RAID device and a set.
  * Set the device up and add it to the set.
@@ -173,7 +184,9 @@
 	r->offset = get_part_start(raw_part, sector);
 	r->sectors = (uint64_t) raw_part->length;
 
-	if (!(rs = _alloc_raid_set(lc, r)))
+	if (rd_check_end(lc, rd, r->offset) ||
+	    rd_check_end(lc, rd, r->offset + r->sectors) ||
+	    !(rs = _alloc_raid_set(lc, r)))
 		goto free_di;
 
 	list_add_tail(&r->devs, &rs->devs);
@@ -238,13 +251,13 @@
 	 * An entry pointing to the present logical partition.
 	 * It is an offset from the present partition table location.
 	 */
-	p1 = &dos->partitions[0];
+	p1 = dos->partitions;
 	
 	/*
 	 * An entry pointing to the next logical partition table.
 	 * It is an offset from the main extended partition start.
 	 */
-	p2 = &dos->partitions[1];
+	p2 = dos->partitions + 1;
 
 	/* If it is a partition, add it to the set */
 	if (is_partition(p1, start_sector) &&
@@ -301,8 +314,12 @@
 		part_end   = part_start + raw_table_entry->length;
 		
 		/* Avoid infinite recursion (mostly). */
-		if (part_start == start_sector ||
-		    part_end > rd->sectors)
+		if (part_start == start_sector)
+			continue;
+
+		/* Check bogus partition starts + ends */
+		if (rd_check_end(lc, rd, part_start) ||
+		    rd_check_end(lc, rd, part_end))
 			continue;
 
 		/*
@@ -365,7 +382,7 @@
 	.check	= dos_check,
 	.events	= NULL, /* Not supported */
 #ifdef DMRAID_NATIVE_LOG
-	.log	= NULL, /* Not supported */
+	.log	= NULL, /* Not supported; use fdisk and friends */
 #endif
 };
 
--- dmraid/lib/locking/locking.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/locking/locking.c	2008/02/22 17:04:36	1.2
@@ -5,8 +5,6 @@
  * See file LICENSE at the top of this source tree for license information.
  */
 
-#include <errno.h>
-
 #ifndef __KLIBC__
 # include <sys/file.h>
 #endif
/cvs/dm/dmraid/lib/metadata/log_ops.c,v  -->  standard output
revision 1.1
--- dmraid/lib/metadata/log_ops.c
+++ -	2008-02-22 17:04:42.683358000 +0000
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2006 Darrick Wong, IBM
+ *                    All rights reserved.
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ *		      All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+#include "internal.h"
+
+void end_log(struct lib_context *lc, struct list_head *log)
+{
+	struct list_head *pos, *tmp;
+
+	list_for_each_safe(pos, tmp, log) {
+		list_del(pos);
+		dbg_free(list_entry(pos, struct change, changes));
+	}
+}
+
+int revert_log(struct lib_context *lc, struct list_head *log)
+{
+	int writes_started = 0, ret = 0;
+	struct change *entry;
+	struct raid_dev *rd;
+
+	list_for_each_entry(entry, log, changes) {
+		if (writes_started && entry->type != WRITE_METADATA) {
+			log_err(lc, "%s: State change after metadata write?",
+				__func__);
+			ret = -EINVAL;
+			break;
+		}
+
+		if (entry->type == ADD_TO_SET) {
+			rd = entry->rd;
+			rd->type = t_spare;
+			list_del_init(&entry->rd->devs);
+		} else if (entry->type == WRITE_METADATA) {
+			writes_started = 1;
+			rd = entry->rd;
+			ret = write_dev(lc, rd, 0);
+			if (ret) {
+				log_err(lc, "%s: Error while reverting "
+					    "metadata.", __func__);
+				break;
+			}
+		}
+	}
+
+	end_log(lc, log);
+	return ret;
+}
/cvs/dm/dmraid/lib/metadata/reconfig.c,v  -->  standard output
revision 1.1
--- dmraid/lib/metadata/reconfig.c
+++ -	2008-02-22 17:04:42.761505000 +0000
@@ -0,0 +1,237 @@
+/*
+ * Copyright (C) 2006 IBM, all rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>,
+ * James Simshaw <simshawj@us.ibm.com>, and
+ * Adam DiCarlo <bikko@us.ibm.com>
+ *
+ * Copyright (C) 2006 Heinz Mauelshagen, Red Hat GmbH
+ * 		      All rights reserved
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+#include "internal.h"
+
+#define	add_to_log(entry, log)	\
+	list_add_tail(&(entry)->changes, &(log));
+
+static inline int alloc_entry(struct change **entry)
+{
+	return (*entry = dbg_malloc(sizeof (*entry))) ? 0 : -ENOMEM;
+}
+
+static int nuke_spare(struct lib_context *lc, struct raid_dev *rd)
+{
+	printf("Nuking Spare\n");
+	list_del_init(&rd->devs);
+	return 0;
+}
+
+/* Add a device to a RAID1 set and start the resync */
+static int add_dev_to_raid1(struct lib_context *lc, struct raid_set *rs,
+			    struct raid_dev *rd)
+{
+	int ret;
+	struct raid_dev *tmp;
+	struct change *entry;
+	LIST_HEAD(log); /* playback log */
+
+	/* Add device to the raid set */
+	ret = alloc_entry(&entry);
+	if (ret)
+		goto err;
+
+	entry->type = ADD_TO_SET;
+	entry->rs = rs;
+	entry->rd = rd;
+	add_to_log(entry, log);
+	list_add_tail(&rd->devs, &rs->devs);
+	rd->type = t_raid1;
+
+	/* Check that this is a sane configuration */
+	list_for_each_entry(tmp, &rs->devs, devs) {
+		ret = tmp->fmt->check(lc, rs);
+		if (ret)
+			goto err;
+	}
+
+	/* Write the metadata of the drive we're adding _first_ */
+	ret = alloc_entry(&entry);
+	if (ret)
+		goto err;
+
+	entry->type = WRITE_METADATA;
+	entry->rd = rd;
+	add_to_log(entry, log);
+	ret = write_dev(lc, rd, 0);
+	if (!ret)
+		goto err;
+
+	/* Write metadatas of every device in the set */
+	list_for_each_entry(tmp, &rs->devs, devs) {
+		if (tmp != rd) {
+			ret = alloc_entry(&entry);
+			if (ret)
+				goto err;
+
+			entry->type = WRITE_METADATA;
+			entry->rd = tmp;
+			add_to_log(entry, log);
+			ret = write_dev(lc, tmp, 0);
+			if (!ret)
+				goto err;
+		}
+	}
+
+	/* Reconfigure device mapper */
+	// FIXME: is nosync enough? rs->status |= s_inconsistent;
+	rs->status |= s_nosync;
+	change_set(lc, A_ACTIVATE, rs);
+	ret = change_set(lc, A_RELOAD, rs);
+	// FIXME: might need this later: change_set(lc, A_DEACTIVATE,rs);
+	if (!ret)
+		goto err;
+
+	/* End transaction */
+	end_log(lc, &log);
+	return 0;
+
+err:
+	revert_log(lc, &log);
+	return ret;
+}
+
+/* Remove a disk from a raid1 */
+static int del_dev_in_raid1(struct lib_context *lc, struct raid_set *rs,
+			    struct raid_dev *rd)
+{
+	int ret;
+	struct raid_dev *tmp;
+	struct change *entry;
+	LIST_HEAD(log); /* Playback log */
+
+	/* Remove device from the raid set */
+	ret = alloc_entry(&entry);
+	if (ret)
+		goto err;
+
+	entry->type = DELETE_FROM_SET;
+	entry->rs = rs;
+	entry->rd = rd;
+	add_to_log(entry, log);
+	list_del_init(&rd->devs);
+	rd->type = t_spare;
+
+	/* Check that this is a sane configuration */
+	list_for_each_entry(tmp, &rs->devs, devs) {
+		ret = tmp->fmt->check(lc, rs);
+		if (ret)
+			goto err;
+	}
+
+	/* Write the metadata of the drive we're removing _first_ */
+	ret = alloc_entry(&entry);
+	if (ret)
+		goto err;
+
+	entry->type = WRITE_METADATA;
+	entry->rd = rd;
+	add_to_log(entry, log);
+	ret = write_dev(lc, rd, 0);
+	if (!ret)
+		goto err;
+
+	/* Write metadatas of every device in the set */
+	list_for_each_entry(tmp, &rs->devs, devs) {
+		if (tmp == rd)
+			continue;
+
+		ret = alloc_entry(&entry);
+		if (ret)
+			goto err;
+
+		entry->type = WRITE_METADATA;
+		entry->rd = tmp;
+		add_to_log(entry, log);
+		ret = write_dev(lc, tmp, 0);
+		if (!ret)
+			goto err;
+	}
+
+	/* Reconfigure device mapper */
+	rs->status |= s_inconsistent;
+	rs->status |= s_nosync;
+	ret = change_set(lc, A_RELOAD, rs);
+	if (!ret)
+		goto err;
+
+	/* End transaction */
+	end_log(lc, &log);
+	return 0;
+
+err:
+	revert_log(lc, &log);
+	return ret;
+}
+
+/* Corelate type and function to handle addition/removel of RAID device */
+struct handler {
+	enum change_type type;
+	int (*func) (struct lib_context *lc, struct raid_set *rs,
+		     struct raid_dev *rd);
+};
+
+/* Call the function to handle addition/removal of a RAID device */
+static int handle_dev(struct lib_context *lc, struct handler *h,
+		      struct raid_set *rs, struct raid_dev *rd)
+{
+	do {
+		if (h->type == rs->type)
+			return h->func(lc, rs, rd);
+	} while ((++h)->type != t_undef);
+
+	LOG_ERR(lc, -ENOENT, "%s: no handler for %x", __func__, rs->type);
+}
+
+/* Add a disk to an array. */
+int add_dev_to_set(struct lib_context *lc, struct raid_set *rs,
+		   struct raid_dev *rd)
+{
+	struct handler handlers[] = {
+		{t_raid1, add_dev_to_raid1},
+		{t_undef, NULL},
+	};
+
+	if (T_SPARE(rd))
+		nuke_spare(lc, rd);
+	else if (!list_empty(&rd->devs))
+		LOG_ERR(lc, -EBUSY, "%s: disk already in another set!",
+			__func__);
+
+	if (T_GROUP(rd))
+		LOG_ERR(lc, -EISDIR,
+			"%s: can't add a group raid_dev to a raid_set.",
+			__func__);
+
+	return handle_dev(lc, handlers, rs, rd);
+}
+
+/* Remove a disk from an array */
+int del_dev_in_set(struct lib_context *lc, struct raid_set *rs,
+		   struct raid_dev *rd)
+{
+	struct handler handlers[] = {
+		{t_raid1, del_dev_in_raid1},
+		{t_undef, NULL},
+	};
+
+	if (list_empty(&rd->devs))
+		LOG_ERR(lc, -EBUSY, "%s: disk is not in a set!", __func__);
+
+	/* FIXME: Not sure if this is true. */
+	if (T_GROUP(rd))
+		LOG_ERR(lc, -EISDIR,
+			"%s: can't remove a group raid_dev from a raid_set.",
+			__func__);
+
+	return handle_dev(lc, handlers, rs, rd);
+}
--- dmraid/lib/metadata/metadata.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/metadata/metadata.c	2008/02/22 17:04:36	1.2
@@ -60,9 +60,12 @@
 {
 	unsigned int ret = ARRAY_SIZE(ascii_type);
 
-	while (ret-- && !(type & ascii_type[ret].type));
+	while (ret--) {
+		if (type & ascii_type[ret].type)
+			return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 const char *get_type(struct lib_context *lc, enum type type)
@@ -83,7 +86,8 @@
 					get_type_index(rs->type))
 			 - get_type_index(t_raid1);
 
-	return stacked_ascii_type[T_RAID0(rs) ? 1 : 0][t];
+	return stacked_ascii_type[T_RAID0(rs) ? 1 : 0]
+				 [t > t_raid0 ? t_undef : t];
 }
 
 /* Check, if a RAID set is stacked (ie, hierachical). */
@@ -120,7 +124,7 @@
 static uint64_t add_sectors(struct raid_set *rs, uint64_t sectors,
 			    uint64_t add)
 {
-	add = round_down(add, rs->stride);
+	add = rs->stride ? round_down(add, rs->stride) : add;
 
 	if (T_RAID1(rs)) {
 		if (!sectors || sectors > add)
@@ -626,8 +630,7 @@
 /*
  * Write RAID metadata to a device.
  */
-static int dmraid_write(struct lib_context *lc,
-			struct raid_dev *rd, int erase)
+int write_dev(struct lib_context *lc, struct raid_dev *rd, int erase)
 {
 	int ret = 0;
 	struct dmraid_format *fmt = rd->fmt;
@@ -813,6 +816,20 @@
 	return DEVS(rs) ? (RD_RS(rs))->fmt : NULL;
 }
 
+/* Find the set associated with a device */
+struct raid_set *get_raid_set(struct lib_context *lc, struct raid_dev *dev)
+{
+	struct raid_set *rs;
+	struct raid_dev *rd;
+
+	list_for_each_entry(rs, LC_RS(lc), list)
+		list_for_each_entry(rd, &rs->devs, devs)
+			if (dev == rd)
+				return rs;
+
+	return NULL;
+}
+
 /* Check metadata consistency of raid sets. */
 static void check_raid_sets(struct lib_context *lc)
 {
@@ -933,7 +950,7 @@
 		 * FIXME: does it make sense to try the rest of the
 		 *	  devices in case we fail writing one ?
 		 */
-		if (!dmraid_write(lc, rd, 0)) {
+		if (!write_dev(lc, rd, 0)) {
 			log_err(lc, "writing RAID device \"%s\", continuing",
 				rd->di->path);
 			ret = 0;
@@ -953,7 +970,7 @@
 		if (yes_no_prompt(lc, "Do you really want to erase \"%s\" "
 				  "ondisk metadata on %s",
 				  rd->fmt->name, rd->di->path) &&
-		    !dmraid_write(lc, rd, 1)) {
+		    !write_dev(lc, rd, 1)) {
 			log_err(lc, "erasing ondisk metadata on %s",
 				rd->di->path);
 			ret = 0;
@@ -970,15 +987,27 @@
  */
 enum type rd_type(struct types *t, unsigned int type)
 {
-	for (; t->type != type && t->unified_type != t_undef; t++);
+	for (; t->type && t->type != type; t++);
 
 	return t->unified_type;
 }
 
 /*
+ * Support function for metadata format handlers:
+ *
+ * Return neutralized RAID status for given metadata status
+ */
+enum status rd_status(struct states *s, unsigned int status, enum compare cmp)
+{
+	for (; s->status && (cmp == AND ? !(s->status & status) : (s->status != status)); s++);
+
+	return s->unified_status;
+}
+
+/*
  * Support function for metadata format handlers.
  *
- * Sort a an element into a list by optionally
+ * Sort an element into a list by optionally
  * using a metadata format handler helper function.
  */
 void list_add_sorted(struct lib_context *lc,
--- dmraid/lib/misc/file.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/misc/file.c	2008/02/22 17:04:36	1.2
@@ -5,7 +5,6 @@
  * See file LICENSE at the top of this source tree for license information.
  */
 
-#include <errno.h>
 #include "internal.h"
 
 /* Create directory recusively. */
--- dmraid/tools/Makefile.in	2008/02/22 16:57:37	1.1
+++ dmraid/tools/Makefile.in	2008/02/22 17:04:36	1.2
@@ -20,7 +20,7 @@
 TARGETS=\
 	dmraid
 
-DMRAIDLIBS=-ldmraid
+DMRAIDLIBS=-ldmraid -lz
 
 include $(top_srcdir)/make.tmpl
 
--- dmraid/tools/VERSION	2008/02/22 16:57:37	1.1
+++ dmraid/tools/VERSION	2008/02/22 17:04:36	1.2
@@ -1 +1 @@
-1.0.0.rc11 (2006.05.15)
+1.0.0.rc12 (2006.09.15)
