From: heinzm@sourceware.org
Subject: dmraid ./CHANGELOG ./KNOWN_BUGS ./README ./dmr ...
Date: 2 Apr 2008 13:35:36 -0000
Message-ID: <20080402133536.9586.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2008-04-02 13:35:32

Modified files:
	.              : CHANGELOG KNOWN_BUGS README dmraid.spec 
	include/dmraid : lib_context.h 
	lib            : internal.h version.h 
	lib/activate   : activate.c devmapper.c 
	lib/format     : format.c 
	lib/format/ataraid: asr.c isw.c jm.c lsi.c lsi.h nv.c pdc.c 
	                    pdc.h 
	lib/format/ddf : ddf1.c ddf1_crc.c 
	lib/format/partition: dos.c 
	lib/metadata   : metadata.c 
	lib/misc       : lib_context.c 
	man            : dmraid.8 
	tools          : VERSION commands.c commands.h 

Log message:
	1.0.0.rc15-pre checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CHANGELOG.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/KNOWN_BUGS.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/README.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/lib_context.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/internal.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/devmapper.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/format.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/nv.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_crc.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/partition/dos.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/lib_context.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/dmraid.8.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.h.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/CHANGELOG	2008/02/22 17:06:54	1.4
+++ dmraid/CHANGELOG	2008/04/02 13:35:30	1.5
@@ -1,4 +1,21 @@
 
+Changelog from dmraid 1.0.0.rc14 to 1.0.0.rc15		2007.08.22
+
+FIXES:
+------
+o jm.c: fixed name handling, when whitespace added to end of name
+o nv.c: fixed endian bug (Bryn Reeves)
+
+
+FEATURES:
+---------
+
+
+MISCELANIOUS:
+-------------
+
+
+
 Changelog from dmraid 1.0.0.rc13 to 1.0.0.rc14		2006.11.08
 
 FIXES:
--- dmraid/KNOWN_BUGS	2008/02/22 17:06:54	1.3
+++ dmraid/KNOWN_BUGS	2008/04/02 13:35:30	1.4
@@ -1,4 +1,4 @@
 
-KNOWN_BUGS in dmraid 1.0.0.rc14					2005.11.08
+KNOWN_BUGS in dmraid 1.0.0.rc15					2008.04.02
 
 o "dmraid --sets[a/i]" doesn't work properly. Use the short option -s.
--- dmraid/README	2008/02/22 17:06:54	1.5
+++ dmraid/README	2008/04/02 13:35:30	1.6
@@ -1,8 +1,8 @@
 ********************************************************************************
 *                                                                              *
-*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc14  2006.11.08   *
+*   dmraid (Device-Mapper Software RAID tool) 1.0.0.rc15-pre 2008.04.02        *
 *                                                                              *
-*   (C)opyright 2004-2006  Heinz Mauelshagen, Red Hat GmbH.                    *
+*   (C)opyright 2004-2008  Heinz Mauelshagen, Red Hat GmbH.                    *
 *   All rights reserved.                                                       *
 *                                                                              *
 ********************************************************************************
@@ -66,13 +66,13 @@
 --------------
 To install the rpm
 
-rpm -i [--nodeps] dmraid-1.0.0.rc10.i386.rpm
+rpm -i [--nodeps] dmraid-1.0.0.rc15.i386.rpm
 
 - or -
 
 to build in an empty directory and install from source
 
-tar jxvf dmraid-1.0.0.rc10.tar.bz2
+tar jxvf dmraid-1.0.0.rc15.tar.bz2
 ./configure	# see ./configure --help for options
 make
 make install
--- dmraid/dmraid.spec	2008/02/22 16:50:38	1.1
+++ dmraid/dmraid.spec	2008/04/02 13:35:30	1.2
@@ -6,7 +6,7 @@
 
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
-Version: 1.0.0.rc11
+Version: 1.0.0.rc15-pre
 Release: 1
 License: GPL
 Group: System Environment/Base
--- dmraid/include/dmraid/lib_context.h	2008/02/22 16:57:35	1.1
+++ dmraid/include/dmraid/lib_context.h	2008/04/02 13:35:31	1.2
@@ -38,7 +38,8 @@
 	LC_VERBOSE,
 	LC_IGNORELOCKING,
 	LC_SEPARATOR,
-	LC_DEVICES,	  /* Add new options below this one ! */
+	LC_DEVICES,
+	LC_PARTCHAR,	  /* Add new options below this one ! */
 	LC_OPTIONS_SIZE,  /* Must be the last enumerator. */
 };
 
@@ -55,12 +56,14 @@
 #define	OPT_SETS(lc)		(lc_opt(lc, LC_SETS))
 #define	OPT_TEST(lc)		(lc_opt(lc, LC_TEST))
 #define	OPT_VERBOSE(lc)		(lc_opt(lc, LC_VERBOSE))
+#define	OPT_PARTCHAR(lc)	(lc_opt(lc, LC_PARTCHAR))
 
 /* Return option value. */
 #define	OPT_STR(lc, o)		(lc->options[o].arg.str)
 #define	OPT_STR_COLUMN(lc)	OPT_STR(lc, LC_COLUMN)
 #define	OPT_STR_FORMAT(lc)	OPT_STR(lc, LC_FORMAT)
 #define	OPT_STR_SEPARATOR(lc)	OPT_STR(lc, LC_SEPARATOR)
+#define	OPT_STR_PARTCHAR(lc)	OPT_STR(lc, LC_PARTCHAR)
 
 struct lib_version {
 	const char *text;
--- dmraid/lib/internal.h	2008/02/22 17:04:35	1.2
+++ dmraid/lib/internal.h	2008/04/02 13:35:31	1.3
@@ -49,8 +49,8 @@
 #define	u_int64_t	uint64_t
 #endif
 
-#define min(a, b) a < b ? a : b
-#define max(a, b) a > b ? a : b
+#define min(a, b) (a) < (b) ? (a) : (b)
+#define max(a, b) (a) > (b) ? (a) : (b)
 #define ARRAY_SIZE(a)   (sizeof(a) / sizeof(*a))
 #define ARRAY_END(a)   (a + ARRAY_SIZE(a))
 
--- dmraid/lib/version.h	2008/02/22 17:06:54	1.4
+++ dmraid/lib/version.h	2008/04/02 13:35:31	1.5
@@ -1,12 +1,12 @@
 #ifndef	DMRAID_LIB_VERSION
 
-#define	DMRAID_LIB_VERSION		"1.0.0.rc14"
+#define	DMRAID_LIB_VERSION		"1.0.0.rc15"
 
 #define	DMRAID_LIB_MAJOR_VERSION	1
 #define	DMRAID_LIB_MINOR_VERSION	0
 #define	DMRAID_LIB_SUBMINOR_VERSION	0
-#define	DMRAID_LIB_VERSION_SUFFIX	"rc14"
+#define	DMRAID_LIB_VERSION_SUFFIX	"rc15"
 
-#define	DMRAID_LIB_DATE			"(2006.11.08)"
+#define	DMRAID_LIB_DATE			"(2008.04.02)"
 
 #endif
--- dmraid/lib/activate/activate.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/activate/activate.c	2008/04/02 13:35:31	1.3
@@ -398,7 +398,11 @@
 			goto err;
 	}
 
-	return 1;
+	/* Append the flag/feature required for dmraid1 
+	 * event handling in the kernel driver 
+	 */
+	if(p_fmt(lc, table, " 1 handle_errors"))
+		return 1;
 
    err:
 	return log_alloc_err(lc, __func__);
--- dmraid/lib/activate/devmapper.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/activate/devmapper.c	2008/04/02 13:35:31	1.3
@@ -21,6 +21,8 @@
 #include "internal.h"
 #include "devmapper.h"
 
+#include <linux/dm-ioctl.h>
+
 /* Make up a dm path. */
 char *mkdm_path(struct lib_context *lc, const char *name)
 {
@@ -147,24 +149,48 @@
 	return handle_table(lc, NULL, table, get_target_list());
 }
 
+/* Build a UUID for a dmraid device 
+ * Return 1 for sucess; 0 for failure*/
+static int dmraid_uuid(struct lib_context *lc, struct raid_set *rs,
+		       char *uuid, uint uuid_len) {
+	int r;
+
+	/* Clear garbage data from uuid string */
+	memset(uuid, 0, uuid_len);
+
+	/* Create UUID string from subsystem prefix and RAID set name. */
+	r = snprintf(uuid, uuid_len, "DMRAID-%s", rs->name) < uuid_len;
+	return r < 0 ? 0 : (r < uuid_len);
+}
+
 /* Create a task, set its name and run it. */
 static int run_task(struct lib_context *lc, struct raid_set *rs,
 		    char *table, int type)
 {
+	/* DM_UUID_LEN is defined in dm-ioctl.h as 129 characters;
+	 * though not all 129 must be used (md uses just 16 from 
+	 * a quick review of md.c. 
+	 * We will be using: (len vol grp name)*/ 
+	char uuid[DM_UUID_LEN];
 	int ret;
 	struct dm_task *dmt;
 
 	_init_dm();
-	ret = (dmt = dm_task_create(type)) && dm_task_set_name(dmt, rs->name);
+	ret = (dmt = dm_task_create(type)) &&
+	      dm_task_set_name(dmt, rs->name);
 	if (ret && table)
 		ret = parse_table(lc, dmt, table);
 
-	if (ret)
-		ret = dm_task_run(dmt);
+	if (ret && 
+	    DM_DEVICE_CREATE == type)
+		ret = dmraid_uuid(lc, rs, uuid, DM_UUID_LEN) &&
+		      dm_task_set_uuid(dmt, uuid) &&
+		      dm_task_run(dmt);
 
 	_exit_dm(dmt);
 	return ret;
 }
+	
 /* Create a mapped device. */
 int dm_create(struct lib_context *lc, struct raid_set *rs, char *table)
 {
--- dmraid/lib/format/format.c	2008/02/22 17:06:54	1.3
+++ dmraid/lib/format/format.c	2008/04/02 13:35:31	1.4
@@ -18,7 +18,7 @@
  * Comment next line out to avoid pre-registration
  * checks on metadata format handlers.
  */
-// #define	CHECK_FORMAT_HANDLER
+#define	CHECK_FORMAT_HANDLER
 #ifdef	CHECK_FORMAT_HANDLER
 /*
  * Check that mandatory members of a metadata form handler are present.
@@ -34,25 +34,25 @@
 #define offset(member)	struct_offset(dmraid_format, member)
 
 struct format_member {
-	const unsigned short offset;
-	const unsigned char flags;
 	const char *msg;
+	const unsigned short offset;
+	const unsigned short flags;
 } __attribute__ ((packed));
 
 enum { FMT_ALL = 0x01, FMT_METHOD = 0x02 } format_flags;
 #define	IS_FMT_ALL(member)	(member->flags & FMT_ALL)
 #define	IS_FMT_METHOD(member)	(member->flags & FMT_METHOD)
 static struct format_member format_member[] = {
-	{ offset(name), FMT_ALL, "name" },
-	{ offset(descr), FMT_ALL, "description" },
-	{ offset(caps), 0, "capabilities" },
-	{ offset(read), FMT_ALL|FMT_METHOD, "read" },
-	{ offset(write), FMT_METHOD, "write" },
-	{ offset(group), FMT_ALL|FMT_METHOD, "group" },
-	{ offset(check), FMT_ALL|FMT_METHOD, "check" },
-	{ offset(events), 0, "events array" },
+	{ "name", offset(name), FMT_ALL },
+	{ "description", offset(descr), FMT_ALL },
+	{ "capabilities", offset(caps), 0 },
+	{ "read", offset(read), FMT_ALL|FMT_METHOD },
+	{ "write", offset(write), FMT_METHOD },
+	{ "group", offset(group), FMT_ALL|FMT_METHOD },
+	{ "check", offset(check), FMT_ALL|FMT_METHOD },
+	{ "events array", offset(events), 0 },
 #ifdef	NATIVE_LOG
-	{ offset(log),    FMT_METHOD, "log" },
+	{ "log", offset(log), FMT_METHOD },
 #endif
 };
 #undef	offset
--- dmraid/lib/format/ataraid/asr.c	2008/02/22 17:06:00	1.3
+++ dmraid/lib/format/ataraid/asr.c	2008/04/02 13:35:31	1.4
@@ -49,11 +49,12 @@
 /* Extract config line from metadata */
 static struct asr_raid_configline *get_config(struct asr *asr, uint32_t magic)
 {
-	unsigned int i = asr->rt->elmcnt;
+	struct asr_raidtable *rt = asr->rt;
+	struct asr_raid_configline *cl = rt->ent + rt->elmcnt;
 	
-	while (i--) {
-		if (asr->rt->ent[i].raidmagic == magic)
-			return asr->rt->ent + i;
+	while (cl-- > rt->ent) {
+		if (cl->raidmagic == magic)
+			return cl;
 	}
 
 	return NULL;
@@ -92,7 +93,7 @@
 }
 
 /* Stride size */
-static inline unsigned int stride(struct asr_raid_configline *cl)
+static inline unsigned stride(struct asr_raid_configline *cl)
 {
 	return cl ? cl->strpsize: 0;
 }
@@ -114,8 +115,7 @@
 		{ 0, t_undef},
 	};
 
-printf("cl->raidtype=%d rd_type=%d\n", cl->raidtype, rd_type(types, (unsigned int) cl->raidtype));
-	return cl ? rd_type(types, (unsigned int) cl->raidtype) : t_undef;
+	return cl ? rd_type(types, (unsigned) cl->raidtype) : t_undef;
 }
 
 /*
@@ -141,11 +141,12 @@
 	CVT32(cl->appBurstCount);
 }
 
-static void to_cpu(void *meta, unsigned int cvt)
+static void to_cpu(void *meta, unsigned cvt)
 {
 	struct asr *asr = meta;
-	unsigned int i, elmcnt = asr->rt->elmcnt,
-		     use_old_elmcnt = (asr->rt->ridcode == RVALID2);
+	struct asr_raidtable *rt = asr->rt;
+	unsigned i, elmcnt = rt->elmcnt,
+		     use_old_elmcnt = (rt->ridcode == RVALID2);
 
 	if (cvt & ASR_BLOCK) {
 		CVT32(asr->rb.b0idcode);
@@ -161,29 +162,30 @@
 	}
 
 	if (cvt & ASR_TABLE) {
-		CVT32(asr->rt->ridcode);
-		CVT32(asr->rt->rversion);
-		CVT16(asr->rt->maxelm);
-		CVT16(asr->rt->elmcnt);
+		CVT32(rt->ridcode);
+		CVT32(rt->rversion);
+		CVT16(rt->maxelm);
+		CVT16(rt->elmcnt);
 		if (!use_old_elmcnt)
-			elmcnt = asr->rt->elmcnt;
-		CVT16(asr->rt->elmsize);
-		CVT32(asr->rt->raidFlags);
-		CVT32(asr->rt->timestamp);
-		CVT16(asr->rt->rchksum);
-		CVT32(asr->rt->sparedrivemagic);
-		CVT32(asr->rt->raidmagic);
-		CVT32(asr->rt->verifyDate);
-		CVT32(asr->rt->recreateDate);
+			elmcnt = rt->elmcnt;
+
+		CVT16(rt->elmsize);
+		CVT32(rt->raidFlags);
+		CVT32(rt->timestamp);
+		CVT16(rt->rchksum);
+		CVT32(rt->sparedrivemagic);
+		CVT32(rt->raidmagic);
+		CVT32(rt->verifyDate);
+		CVT32(rt->recreateDate);
 
 		/* Convert the first seven config lines */
 		for (i = 0; i < (min(elmcnt, ASR_TBLELMCNT)); i++) 
-			cvt_configline(asr->rt->ent + i);
+			cvt_configline(rt->ent + i);
 	}
 
 	if (cvt & ASR_EXTTABLE) {
 		for (i = ASR_TBLELMCNT; i < elmcnt; i++)
-			cvt_configline(asr->rt->ent + i);
+			cvt_configline(rt->ent + i);
 	}
 }
 
@@ -192,11 +194,11 @@
 #endif
 
 /* Compute the checksum of RAID metadata */
-static unsigned int compute_checksum(struct asr *asr)
+static unsigned compute_checksum(struct asr *asr)
 {
-	uint8_t *ptr = (uint8_t*) asr->rt->ent;
-	unsigned int checksum = 0,
-		     end = sizeof(*asr->rt->ent) * asr->rt->elmcnt;
+	struct asr_raidtable *rt = asr->rt;
+	uint8_t *ptr = (uint8_t*) rt->ent;
+	unsigned checksum = 0, end = sizeof(*rt->ent) * rt->elmcnt;
 
 	/* Compute checksum. */
 	while (end--)
@@ -209,7 +211,7 @@
 enum truncate { TRUNCATE, UNTRUNCATE };
 static void handle_white_space(uint8_t *p, enum truncate truncate)
 {
-	unsigned int j = ASR_NAMELEN;
+	unsigned j = ASR_NAMELEN;
 	uint8_t c = truncate == TRUNCATE ? 0 : ' ';
 
 	while (j-- && (truncate == TRUNCATE ? isspace(p[j]) : !p[j]))
@@ -220,12 +222,13 @@
 static int read_extended(struct lib_context *lc, struct dev_info *di,
 			 struct asr *asr)
 {
-	unsigned int remaining, i, chk;
+	unsigned remaining, i, chk;
+	struct asr_raidtable *rt = asr->rt;
 
 	log_notice(lc, "%s: reading extended data on %s", handler, di->path);
 	
 	/* Read the RAID table. */
-	if (!read_file(lc, handler, di->path, asr->rt, ASR_DISK_BLOCK_SIZE,
+	if (!read_file(lc, handler, di->path, rt, ASR_DISK_BLOCK_SIZE,
 		       (uint64_t) asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE))
 		LOG_ERR(lc, 0, "%s: Could not read metadata off %s",
 			handler, di->path);
@@ -234,25 +237,25 @@
 	to_cpu(asr, ASR_TABLE);
 	
 	/* Is this ok? */
-	if (asr->rt->ridcode != RVALID2)
+	if (rt->ridcode != RVALID2)
 		LOG_ERR(lc, 0, "%s: Invalid magic number in RAID table; "
 			"saw 0x%X, expected 0x%X on %s",
-			handler, asr->rt->ridcode, RVALID2, di->path);
+			handler, rt->ridcode, RVALID2, di->path);
 
 	/* Have we a valid element count? */
-	if (asr->rt->elmcnt >= asr->rt->maxelm || asr->rt->elmcnt == 0)
+	if (rt->elmcnt >= rt->maxelm || rt->elmcnt == 0)
 		LOG_ERR(lc, 0, "%s: Invalid RAID config table count on %s",
 			handler, di->path);
 
 	/* Is each element the right size? */
-	if (asr->rt->elmsize != sizeof(*asr->rt->ent))
+	if (rt->elmsize != sizeof(*rt->ent))
 		LOG_ERR(lc, 0, "%s: Wrong RAID config line size on %s",
 			handler, di->path);
 
 	/* Figure out how much else we need to read. */
-	if (asr->rt->elmcnt > ASR_TBLELMCNT) {
-		remaining = asr->rt->elmsize * (asr->rt->elmcnt - 7);
-		if (!read_file(lc, handler, di->path, asr->rt->ent + 7,
+	if (rt->elmcnt > ASR_TBLELMCNT) {
+		remaining = rt->elmsize * (rt->elmcnt - 7);
+		if (!read_file(lc, handler, di->path, rt->ent + 7,
 			       remaining, (uint64_t)(asr->rb.raidtbl + 1) *
 			       ASR_DISK_BLOCK_SIZE))
 			return 0;
@@ -260,14 +263,16 @@
 		to_cpu(asr, ASR_EXTTABLE);
 	}
 
-	chk = compute_checksum(asr);
-	if (chk != asr->rt->rchksum)
-		LOG_ERR(lc, 0,"%s: Invalid RAID config table checksum "
-			       "(0x%X vs. 0x%X) on %s",
-			handler, chk, asr->rt->rchksum, di->path);
+	/* Checksum only valid for raid table version 1. */
+	if (rt->rversion < 2) {
+		if ((chk = compute_checksum(asr)) != rt->rchksum)
+			log_err(lc, "%s: Invalid RAID config table checksum "
+				       "(0x%X vs. 0x%X) on %s",
+				handler, chk, rt->rchksum, di->path);
+	}
 	
 	/* Process the name of each line of the config line. */
-	for (i = 0; i < asr->rt->elmcnt; i++) {
+	for (i = 0; i < rt->elmcnt; i++) {
 		/* 
 		 * Weird quirks of the name field of the config line:
 		 *
@@ -290,11 +295,13 @@
 		 *
 		 * This is nuts.
 		 */
-		if (!asr->rt->ent[i].name)
-			memcpy(asr->rt->ent[i].name, asr->rt->ent[0].name, 16);
+		if (!*rt->ent[i].name)
+			strncpy((char*) rt->ent[i].name,
+				(char*) rt->ent->name,
+				ASR_NAMELEN);
 
 		/* Now truncate trailing whitespace in the name. */
-		handle_white_space(asr->rt->ent[i].name, TRUNCATE);
+		handle_white_space(rt->ent[i].name, TRUNCATE);
 	}
 
 	return 1;
@@ -479,11 +486,12 @@
 static int find_toplevel(struct lib_context *lc, struct asr *asr)
 {
 	int i, toplevel = -1;
+	struct asr_raidtable *rt = asr->rt;
 
-	for (i = 0; i < asr->rt->elmcnt; i++) {
-		if (asr->rt->ent[i].raidlevel == FWL)
+	for (i = 0; i < rt->elmcnt; i++) {
+		if (rt->ent[i].raidlevel == FWL)
 			toplevel = i;
-		else if (asr->rt->ent[i].raidlevel == FWL_2) {
+		else if (rt->ent[i].raidlevel == FWL_2) {
 			toplevel = i;
 			break;
 		}
@@ -499,13 +507,14 @@
 static struct asr_raid_configline *find_logical(struct asr *asr)
 {
 	int i, j;
+	struct asr_raidtable *rt = asr->rt;
 
 	/* This MUST be done backwards! */
-	for (i = asr->rt->elmcnt - 1; i > -1; i--) {
-		if (asr->rt->ent[i].raidmagic == asr->rb.drivemagic) {
+	for (i = rt->elmcnt - 1; i > -1; i--) {
+		if (rt->ent[i].raidmagic == asr->rb.drivemagic) {
 			for (j = i - 1; j > -1; j--) {
-				if (asr->rt->ent[j].raidlevel == FWL)
-					return asr->rt->ent + j;
+				if (rt->ent[j].raidlevel == FWL)
+					return rt->ent + j;
 			}
 		}
 	}
@@ -526,7 +535,7 @@
 
 /* Wrapper for name() */
 static char *js_name(struct lib_context *lc, struct raid_dev *rd,
-		     unsigned int subset)
+		     unsigned subset)
 {
 	return name(lc, META(rd, asr));
 }
@@ -694,10 +703,11 @@
 static void delete_configline(struct asr *asr, int index)
 {
 	struct asr_raid_configline *cl, *end;
+	struct asr_raidtable *rt = asr->rt;
 
-	asr->rt->elmcnt--;
-	cl = asr->rt->ent + index;
-	end = asr->rt->ent + asr->rt->elmcnt;
+	rt->elmcnt--;
+	cl = rt->ent + index;
+	end = rt->ent + rt->elmcnt;
 	while (cl < end) {
 		memcpy(cl, cl + 1, sizeof(*cl));
 		++cl;
@@ -707,19 +717,19 @@
 /* Find the newest configline entry in raid set and return a pointer to it. */
 static struct raid_dev *find_newest_drive(struct raid_set *rs)
 {
-	struct asr *asr;
+	struct asr_raidtable *rt;
 	struct raid_dev *device, *newest = NULL;
 	uint16_t newest_raidseq = 0;
         int i;
 	
 	list_for_each_entry(device, &rs->devs, devs) {
-		asr = META(device, asr);
+		rt = META(device, asr)->rt;
 		// FIXME: We should be able to assume each configline
 		// in a single drive has the same raidseq as the rest
 		// in that drive. We're doing too much work here.
-		for (i = 0; i < asr->rt->elmcnt; ++i) {
-			if (asr->rt->ent[i].raidseq >= newest_raidseq) {
-				newest_raidseq = asr->rt->ent[i].raidseq;
+		for (i = 0; i < rt->elmcnt; i++) {
+			if (rt->ent[i].raidseq >= newest_raidseq) {
+				newest_raidseq = rt->ent[i].raidseq;
 				newest = device;
 			}
 		}
@@ -830,24 +840,25 @@
 static int create_configline(struct raid_set *rs, struct asr *asr,
 		             struct asr *a, struct raid_dev* newest)
 {
-	if (asr->rt->elmcnt >= RCTBL_MAX_ENTRIES) {
-		return 0;
-	}
-
-	struct asr *newest_asr;
+	struct asr *newest_asr = META(newest, asr);
 	struct asr_raid_configline *cl;
 	
-	newest_asr = META(newest, asr);
+	if (asr->rt->elmcnt >= RCTBL_MAX_ENTRIES)
+		return 0;
 	
 	cl = asr->rt->ent + asr->rt->elmcnt;
 	asr->rt->elmcnt++;
 
-	/* Use first raidseq, below: FIXME - don't assume all CLS are
-	 * consistent */
+	/*
+	 * Use first raidseq, below: FIXME - don't
+	 * assume all CLS are consistent.
+	 */
 	cl->raidmagic = a->rb.drivemagic;
 	cl->raidseq = newest_asr->rt->ent[0].raidseq;
 	cl->strpsize = newest_asr->rt->ent[0].strpsize;
-	strcpy((char*) cl->name, &rs->name[4]); /* starts after "asr_" */
+
+	/* Starts after "asr_" */
+	strcpy((char*) cl->name, &rs->name[sizeof(HANDLER)]);
 	cl->raidcnt = 0;
 
 	/* Convert rs->type to an ASR_RAID type for the CL */
@@ -875,12 +886,13 @@
 	struct asr_raid_configline *cl;
 	struct raid_dev *d, *newest;
 	struct asr *a;
+	struct asr_raidtable *rt = asr->rt;
 
 	/* Find the raid set */
 	rs = get_raid_set(lc, rd);
 	if (!rs) {
 		/* Array-less disks ... have no CLs ? */
-		asr->rt->elmcnt = 0;
+		rt->elmcnt = 0;
 		return 1;
 	}
 	
@@ -901,14 +913,14 @@
 		struct asr *newest_asr = META(newest, asr);
 	
 		/* copy entire table from newest drive */	
-		asr->rt->elmcnt = newest_asr->rt->elmcnt;
-		memcpy(asr->rt->ent, newest_asr->rt->ent,
-			asr->rt->elmcnt * sizeof(*asr->rt->ent));
+		rt->elmcnt = newest_asr->rt->elmcnt;
+		memcpy(rt->ent, newest_asr->rt->ent,
+			rt->elmcnt * sizeof(*rt->ent));
 	}
 
 	/* Increment the top level CL's raid count */
 	/* Fixme: What about the the FWLs in a FWL2 setting? */
-	cl = asr->rt->ent + find_toplevel(lc, asr);
+	cl = rt->ent + find_toplevel(lc, asr);
 	cl->raidseq++;
 
 	/* For each disk in the rs */
@@ -977,7 +989,7 @@
  */
 
 /* Retrieve the number of devices that should be in this set. */
-static unsigned int device_count(struct raid_dev *rd, void *context)
+static unsigned device_count(struct raid_dev *rd, void *context)
 {
 	/* Get the logical drive */
 	struct asr_raid_configline *cl = find_logical(META(rd, asr));
@@ -1052,10 +1064,10 @@
 /* Dump a raid config table */
 static void dump_rt(struct lib_context *lc, struct asr_raidtable *rt)
 {
-	unsigned int i;
+	unsigned i;
 
 	DP("ridcode:\t\t\t0x%X", rt, rt->ridcode);
-	DP("table ver:\t\t%d", rt, rt->rversion);
+	DP("rversion:\t\t%d", rt, rt->rversion);
 	DP("max configs:\t\t%d", rt, rt->maxelm);
 	DP("configs:\t\t\t%d", rt, rt->elmcnt);
 	DP("config sz:\t\t%d", rt, rt->elmsize);
@@ -1124,7 +1136,6 @@
 
 	if (!cl)
 		LOG_ERR(lc, 0, "%s: Could not find current disk!", handler);		
-
 	/* We need two metadata areas */
 	if (!(ma = rd->meta_areas = alloc_meta_areas(lc, rd, handler, 2)))
 		return 0;
--- dmraid/lib/format/ataraid/isw.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/isw.c	2008/04/02 13:35:31	1.3
@@ -364,21 +364,26 @@
 {
 	int ret;
 	struct isw *isw = META(rd, isw);
+	int large = div_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE) > 1;
 
 	to_disk(isw, FULL);
 
-	/*
-	 * Copy 1st metadata sector to after the extended ones
-	 * and increment metadata area pointer by one block, so
-	 * that the metadata is filed in the proper sequence.
-	 */
-	memcpy((void*) isw + rd->meta_areas->size, isw, ISW_DISK_BLOCK_SIZE);
-	rd->meta_areas->area += ISW_DISK_BLOCK_SIZE;
+	if (large) {
+		/*
+		 * Copy 1st metadata sector to after the extended ones
+		 * and increment metadata area pointer by one block, so
+		 * that the metadata is filed in the proper sequence.
+		 */
+		memcpy((void*) isw + rd->meta_areas->size, isw,
+		       ISW_DISK_BLOCK_SIZE);
+		rd->meta_areas->area += ISW_DISK_BLOCK_SIZE;
+	}
 
 	ret = write_metadata(lc, handler, rd, -1, erase);
 
 	/* Correct metadata area pointer. */
-	rd->meta_areas->area -= ISW_DISK_BLOCK_SIZE;
+	if (large)
+		rd->meta_areas->area -= ISW_DISK_BLOCK_SIZE;
 
 	to_cpu(isw, FULL);
 
@@ -504,7 +509,7 @@
 
 /* Add an Intel SW RAID device to a set */
 static struct raid_set *isw_group(struct lib_context *lc,
-				    struct raid_dev *rd_meta)
+				  struct raid_dev *rd_meta)
 {
 	struct raid_set *rs_group;
 
@@ -744,7 +749,7 @@
 static struct dmraid_format isw_format = {
 	.name	= HANDLER,
 	.descr	= "Intel Software RAID",
-	.caps	= "0,1",
+	.caps	= "0,1,5",
 	.format = FMT_RAID,
 	.read	= isw_read,
 	.write	= isw_write,
--- dmraid/lib/format/ataraid/jm.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/jm.c	2008/04/02 13:35:31	1.3
@@ -1,8 +1,8 @@
 /*
  * JMicron metadata format handler.
  *
- * Copyright (C) 2006  Heinz Mauelshagen, Red Hat GmbH.
- *                     All rights reserved.
+ * Copyright (C) 2006,2007  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
@@ -25,25 +25,27 @@
 static char *name(struct lib_context *lc, struct raid_dev *rd,
 		  unsigned int subset)
 {
+	int i;
 	size_t len;
 	struct jm *jm = META(rd, jm);
-	char buf[2], *ret, *name = (char *) jm->name;
+	char buf[JM_NAME_LEN + 1], *ret, *name = (char *) jm->name;
 
-	/* Name always 0 terminated ? */
-	if ((len = strlen(name)) > JM_NAME_LEN)
-		len = JM_NAME_LEN;
-
-	len += sizeof(HANDLER) + 2;
-	if (jm->mode == JM_T_RAID01)
-		len++;
+	/* Name always 0 terminated or whitespace at end ? */
+	strncpy(buf, name, JM_NAME_LEN);
+	len = strlen(buf);
+	i = len < JM_NAME_LEN ? len : JM_NAME_LEN;
+	buf[i] = 0;
+	while (i-- && isspace(buf[i]))
+		buf[i] = 0;
 
+	len = strlen(buf) + sizeof(HANDLER) + (jm->mode == JM_T_RAID01 ? 3 : 2);
 	if ((ret = dbg_malloc(len))) {
 		if (jm->mode == JM_T_RAID01 && subset)
 			sprintf(buf, "-%u", member(jm) / 2);
 		else
 			*buf = 0;
 
-		sprintf(ret, "%s_%s%s", HANDLER, name, buf);
+		sprintf(ret, "%s_%s%s", handler, name, buf);
 	}
 
 	return ret;
--- dmraid/lib/format/ataraid/lsi.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/lsi.c	2008/04/02 13:35:31	1.3
@@ -179,6 +179,10 @@
 {
 	struct lsi *lsi = META(rd, lsi);
 
+	/* Refuse to add drives that are not online */
+	if (get_disk(lsi)->offline)
+		return 0;
+
 	if (!init_raid_set(lc, rs, rd, lsi->stride, type(lsi), handler))
 		return 0;
 
@@ -300,8 +304,8 @@
 		  i, disk->disk_number);
 		P("disks[%u].set_number: %u", lsi, disk->set_number,
 		  i, disk->set_number);
-		P("disks[%u].unknown1: %u, 0x%u", lsi, disk->unknown1,
-		  i, disk->unknown1, disk->unknown1);
+		P("disks[%u].unknown1: %lu, 0x%lX", lsi, disk->unknown1,
+		  i, (uint64_t) disk->unknown1, (uint64_t) disk->unknown1);
 	}
 
 	DP("disk_number: %u", lsi, lsi->disk_number);
--- dmraid/lib/format/ataraid/lsi.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/lsi.h	2008/04/02 13:35:31	1.2
@@ -28,7 +28,8 @@
 	uint16_t magic_1;
 	uint8_t disk_number;
 	uint8_t set_number;
-	uint8_t unknown1[8];
+	uint8_t offline;
+	uint8_t unknown1[7];
 } __attribute__ ((packed));
 
 struct lsi {
@@ -47,8 +48,10 @@
 	uint8_t dummy4;		/* 0x11 */
 	uint16_t stride;		/* 0x12 - 0x13 */
 	uint8_t filler[0x20-0x14];	/* 0x14 - 0x1F */
+
 #define	LSI_MAX_DISKS	4
 	struct lsi_disk disks[LSI_MAX_DISKS];/* 0x20 - 0x5F */
+
 #define	LSI_DISK(lsi)		(lsi->set_number * 2 + lsi->disk_number)
 #define LSI_MAGIC_0(lsi)	(lsi->disks[LSI_DISK(lsi)].magic_0)
 #define LSI_MAGIC_1(lsi)	(lsi->disks[LSI_DISK(lsi)].magic_1)
--- dmraid/lib/format/ataraid/nv.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/nv.c	2008/04/02 13:35:31	1.3
@@ -155,7 +155,7 @@
 	CVT32(nv->unitFlags);
 	CVT32(array->version);
 
-	while (i--);
+	while (i--)
 		CVT32(array->signature[i]);
 
 	CVT32(array->raidLevel);
--- dmraid/lib/format/ataraid/pdc.c	2008/02/22 17:06:00	1.3
+++ dmraid/lib/format/ataraid/pdc.c	2008/04/02 13:35:31	1.4
@@ -1,7 +1,7 @@
 /*
  * Promise FastTrak ATARAID metadata format handler.
  *
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -27,26 +27,25 @@
 /*
  * Make up Promise RAID device name.
  */
-static unsigned int set_number(struct pdc *pdc)
+static unsigned set_number(struct pdc *pdc)
 {
 	return pdc->raid.disk_number >= (pdc->raid.total_disks / 2);
 }
 
-static size_t _name(struct pdc *pdc, char *str, size_t len, int subset)
+static size_t __name(struct pdc *pdc, char *str, size_t len, int subset)
 {
 	return snprintf(str, len, subset ? "pdc_%u-%u" : "pdc_%u",
 			pdc->raid.magic_1, set_number(pdc));
 }
 
-static char *name(struct lib_context *lc, struct raid_dev *rd,
-		  unsigned int subset)
+static char *_name(struct lib_context *lc, struct pdc *pdc,
+		  unsigned subset)
 {
-	struct pdc *pdc = META(rd, pdc);
 	size_t len;
 	char *ret = NULL;
 
-	if ((ret = dbg_malloc((len = _name(pdc, ret, 0, subset) + 1)))) {
-		_name(pdc, ret, len, subset);
+	if ((ret = dbg_malloc((len = __name(pdc, ret, 0, subset) + 1)))) {
+		__name(pdc, ret, len, subset);
 		mk_alpha(lc, ret + HANDLER_LEN,
 			 len - HANDLER_LEN - (subset ? 2 : 0));
 	} else
@@ -55,6 +54,12 @@
 	return ret;
 }
 
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned subset)
+{
+	return _name(lc, META(rd, pdc), subset);
+}
+
 /*
  * Retrieve status of device.
  *
@@ -87,13 +92,13 @@
 	if (is_raid10(pdc))
 		pdc->raid.type = PDC_T_RAID10;
 
-	return rd_type(types, (unsigned int) pdc->raid.type);
+	return rd_type(types, (unsigned) pdc->raid.type);
 }
 
 /* Calculate checksum on Promise metadata. */
 static uint32_t checksum(struct pdc *pdc)
 {
-	unsigned int i = 511, sum = 0;
+	unsigned i = 511, sum = 0;
 	uint32_t *p = (uint32_t*) pdc;
 
 	while (i--)
@@ -133,32 +138,79 @@
 }
 #endif
 
+/* Check for Promis signature. */
+static int is_signature(struct pdc *pdc)
+{
+	return !strncmp((const char*) pdc->promise_id,
+			PDC_MAGIC, PDC_ID_LENGTH);
+}
+
 /* Read and try to discover Promise signature. */
 static void *pdc_read_metadata(struct lib_context *lc, struct dev_info *di,
 			       size_t *size, uint64_t *offset,
 			       union read_info *info)
 {
+	struct pdc *ret;
+	unsigned ma, sub;
+	unsigned pdc_sectors_max = di->sectors - div_up(sizeof(*ret), 512);
+
 	/* Assume certain sectors off the end of the RAID device. */
-	static unsigned int *s, sectors[] = {
+	static unsigned end_sectors[] = {
 		PDC_CONFIGOFFSETS, 0,
 	};
-	struct pdc *ret;
+	/* ...or beginning of large RAID device. */
+	static unsigned begin_sectors[] = {
+		268435377, 0,
+	};
+	unsigned *s = end_sectors;
+	uint64_t sector;
 
-	if ((ret = alloc_private(lc, handler, sizeof(*ret)))) {
-		for (s = sectors; *s; s++) {
-			if (read_file(lc, handler, di->path, ret, sizeof(*ret),
-				      (di->sectors - *s) << 9) &&
-			    !strncmp((const char*) ret->promise_id, PDC_MAGIC,
-				     PDC_ID_LENGTH)) {
-				info->u32 = *s;
-				return (void*) ret;
+	if (!(ret = alloc_private(lc, handler,
+				  PDC_MAX_META_AREAS * sizeof(*ret))))
+		return NULL;
+
+	info->u32 = 0;
+	sub = 1;
+	do {
+		/* Check all sector offsets for metadata signature. */
+		for (; *s && !info->u32; s++) {
+			sector = sub ? di->sectors - *s : *s;
+	
+			/* ...and all possible optional metadata signatures. */
+			for (ma = 0;
+			     ma < PDC_MAX_META_AREAS &&
+			     sector <= pdc_sectors_max;
+			     ma++, sector += PDC_META_OFFSET) {
+				if (read_file(lc, handler, di->path,
+					      ret + ma, sizeof(*ret),
+					      sector << 9)) {
+					/* No signature? */
+					if (!is_signature(ret + ma)) {
+						if (info->u32)
+							goto out;
+						else
+							break;
+
+					/* Memorize main metadata sector. */
+					} else if (!info->u32)
+						info->u32 = *s;
+				}
 			}
 		}
 
+		/* Retry relative to beginning of device if none... */
+		if (!info->u32)
+			s = begin_sectors;
+	} while (!info->u32 && sub--);
+
+   out:
+	/* No metadata signature(s) found. */
+	if (!info->u32) {
 		dbg_free(ret);
+		ret = NULL;
 	}
 
-	return NULL;
+	return ret;
 }
 
 /* Magic check. */
@@ -224,7 +276,7 @@
 /*
  * Group the RAID disk into a Promise set.
  */
-static unsigned int stride(struct pdc *pdc)
+static unsigned stride(struct pdc *pdc)
 {
 	return pdc->raid.raid0_shift ? 1 << pdc->raid.raid0_shift : 0;
 }
@@ -235,12 +287,85 @@
 	super->stride = stride(META((private), pdc));
 }
 
-/* Add a PDC RAID device to a set. */
-static int group_rd(struct lib_context *lc, struct raid_set *rs,
-		    struct raid_set **ss, struct raid_dev *rd)
+/* Calculate RAID device size in sectors depending on RAID type. */
+static uint64_t sectors(struct raid_dev *rd, unsigned meta_sector)
 {
 	struct pdc *pdc = META(rd, pdc);
 
+	switch (pdc->raid.type) {
+	case PDC_T_RAID10:
+               return pdc->raid.total_secs / (pdc->raid.total_disks / 2);
+
+	case PDC_T_RAID1:
+               return pdc->raid.total_secs;
+
+	case PDC_T_RAID0:
+               return pdc->raid.total_secs / pdc->raid.total_disks;
+
+	case PDC_T_SPAN:
+	       return rd->di->sectors - meta_sector;
+	}
+
+	return 0;
+}
+
+static struct raid_dev *_create_rd(struct lib_context *lc, struct raid_dev *rd,
+				   struct pdc *pdc, unsigned idx)
+{
+	struct raid_dev *r;
+
+	if (!is_pdc(lc, rd->di, pdc) ||
+	    !(r = alloc_raid_dev(lc, handler)))
+		return NULL;
+
+	if ((r->type = type(pdc)) == t_undef) {
+		log_err(lc, "%s: RAID type %u not supported",
+			handler, (unsigned) pdc->raid.type);
+		goto bad_free;
+	}
+
+        if (!(r->name = _name(lc, pdc, is_raid10(pdc))))
+		goto bad_free;
+
+	/* Allocate meta_areas for devices() to work. */
+	if (!(r->meta_areas = alloc_meta_areas(lc, r, handler, 1)))
+		goto bad_free;
+
+	/* Allocate private metadata area so that free_raid_dev() succeeds. */
+	r->meta_areas->area = alloc_private(lc, handler, sizeof(*pdc));
+	if (!r->meta_areas->area)
+		goto bad_free;
+
+	memcpy(r->meta_areas->area, pdc, sizeof(*pdc));
+	r->meta_areas->size = sizeof(*pdc);
+	r->meta_areas->offset = rd->meta_areas->offset + idx * PDC_META_OFFSET;
+
+	r->di = rd->di;
+	r->fmt = rd->fmt;
+	r->status = status(pdc);
+
+	/*
+	 * Type needs to be set before sectors(), because we need
+	 * to set the RAID10 type used there!
+	 */
+	r->type = type(pdc);
+
+	r->offset = pdc->raid.start;
+	if ((r->sectors = sectors(r, 0)))
+		goto out;
+
+	log_zero_sectors(lc, r->di->path, handler);
+
+   bad_free:
+	free_raid_dev(lc, &r);
+   out:
+	return r;
+}
+
+/* Add a PDC RAID device to a set. */
+static int _group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd, struct pdc *pdc)
+{
 	if (!init_raid_set(lc, rs, rd, stride(pdc), pdc->raid.type, handler))
 		return 0;
 
@@ -271,6 +396,52 @@
 	return 1;
 }
 
+static inline unsigned count_meta_areas(struct pdc *pdc)
+{
+	unsigned r;
+
+	/* Count metadata signatures discovered by pdc_read_metadata(). */
+	for (r = 0; r < PDC_MAX_META_AREAS; r++) {
+		if (!is_signature(pdc + r))
+			break;
+	}
+
+	return r;
+}
+
+/* FIXME: different super sets possible with multiple metadata areas ? */
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	int r;
+	struct pdc *pdc = META(rd, pdc);
+	unsigned idx = 0, ma = count_meta_areas(pdc);
+	struct raid_dev *rd_tmp;
+	struct raid_set *rs_tmp;
+
+
+	/* Group the one we already have. */
+	r = _group_rd(lc, rs, ss, rd, META(rd, pdc));
+
+	/* Group any additional ones. */
+	while (r && --ma) {
+		if (!(rd_tmp = _create_rd(lc, rd, ++pdc, ++idx)))
+			return 0;
+
+		if (!(rs_tmp = find_or_alloc_raid_set(lc, rd_tmp->name,
+						      FIND_ALL, rd_tmp,
+						      NO_LIST, NO_CREATE,
+						      NO_CREATE_ARG))) {
+			free_raid_dev(lc, &rd_tmp);
+			return 0;
+		}
+
+		r = _group_rd(lc, rs_tmp, ss, rd_tmp, pdc);
+	}
+
+	return r;
+}
+
 static struct raid_set *pdc_group(struct lib_context *lc, struct raid_dev *rd)
 {
 	struct raid_set *rs, *ss = NULL;
@@ -290,7 +461,7 @@
  *
  * FIXME: more sanity checks.
  */
-static unsigned int devices(struct raid_dev *rd, void *context)
+static unsigned devices(struct raid_dev *rd, void *context)
 {
 	struct pdc *pdc = META(rd, pdc);
 
@@ -344,30 +515,38 @@
 
 #ifdef DMRAID_NATIVE_LOG
 /* Log native information about a Promise RAID device. */
-static void pdc_log(struct lib_context *lc, struct raid_dev *rd)
+static void _pdc_log(struct lib_context *lc, struct dev_info *di,
+		     struct pdc *pdc)
 {
-	unsigned int i;
-	struct pdc *pdc = META(rd, pdc);
+	unsigned i;
 	struct pdc_disk *disk;
 
-	log_print(lc, "%s (%s):", rd->di->path, handler);
+	log_print(lc, "%s (%s):", di->path, handler);
 	DP("promise_id: \"%s\"", pdc, pdc->promise_id);
-	DP("unknown_0: 0x%x", pdc, pdc->unknown_0);
+	P("unknown_0: 0x%x %u",
+	  pdc, pdc->unknown_0, pdc->unknown_0, pdc->unknown_0);
 	DP("magic_0: 0x%x", pdc, pdc->magic_0);
-	DP("unknown_1: 0x%x", pdc, pdc->unknown_1);
+	P("unknown_1: 0x%x %u",
+	  pdc, pdc->unknown_1, pdc->unknown_1, pdc->unknown_1);
 	DP("magic_1: 0x%x", pdc, pdc->magic_1);
-	DP("unknown_2: 0x%x", pdc, pdc->unknown_2);
+	P("unknown_2: 0x%x %u",
+	  pdc, pdc->unknown_2, pdc->unknown_2, pdc->unknown_2);
 	DP("raid.flags: 0x%x", pdc, pdc->raid.flags);
-	DP("raid.unknown_0: 0x%x", pdc, pdc->raid.unknown_0);
+	P("raid.unknown_0: 0x%x %d",
+	  pdc, pdc->raid.unknown_0, pdc->raid.unknown_0, pdc->raid.unknown_0);
 	DP("raid.disk_number: %u", pdc, pdc->raid.disk_number);
 	DP("raid.channel: %u", pdc, pdc->raid.channel);
 	DP("raid.device: %u", pdc, pdc->raid.device);
 	DP("raid.magic_0: 0x%x", pdc, pdc->raid.magic_0);
-	DP("raid.unknown_1: 0x%x", pdc, pdc->raid.unknown_1);
-	DP("raid.unknown_2: 0x%x", pdc, pdc->raid.unknown_2);
+	P("raid.unknown_1: 0x%x %u",
+	   pdc, pdc->raid.unknown_1, pdc->raid.unknown_1, pdc->raid.unknown_1);
+	P("raid.start: 0x%x %u",
+	  pdc, pdc->raid.start, pdc->raid.start, pdc->raid.start);
 	DP("raid.disk_secs: %u", pdc, pdc->raid.disk_secs);
-	DP("raid.unknown_3: 0x%x", pdc, pdc->raid.unknown_3);
-	DP("raid.unknown_4: 0x%x", pdc, pdc->raid.unknown_4);
+	P("raid.unknown_3: 0x%x %u",
+	  pdc, pdc->raid.unknown_3, pdc->raid.unknown_3, pdc->raid.unknown_3);
+	P("raid.unknown_4: 0x%x %u",
+	  pdc, pdc->raid.unknown_4, pdc->raid.unknown_4, pdc->raid.unknown_4);
 	DP("raid.status: 0x%x", pdc, pdc->raid.status);
 	DP("raid.type: 0x%x", pdc, pdc->raid.type);
 	DP("raid.total_disks: %u", pdc, pdc->raid.total_disks);
@@ -379,7 +558,8 @@
 	DP("raid.heads: %u", pdc, pdc->raid.heads);
 	DP("raid.sectors: %u", pdc, pdc->raid.sectors);
 	DP("raid.magic_1: 0x%x", pdc, pdc->raid.magic_1);
-	DP("raid.unknown_5: 0x%x", pdc, pdc->raid.unknown_5);
+	P("raid.unknown_5: 0x%x %u",
+	  pdc, pdc->raid.unknown_5, pdc->raid.unknown_5, pdc->raid.unknown_5);
 
 	for (disk = pdc->raid.disk, i = 0;
 	     i < pdc->raid.total_disks;
@@ -394,6 +574,11 @@
 	P("checksum: 0x%x %s", pdc, pdc->checksum, pdc->checksum,
 	   checksum(pdc) ? "Ok" : "BAD");
 }
+
+static void pdc_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	_pdc_log(lc, rd->di, META(rd, pdc));
+}
 #endif
 
 static struct dmraid_format pdc_format = {
@@ -417,33 +602,11 @@
 	return register_format_handler(lc, &pdc_format);
 }
 
-/* Calculate RAID device size in sectors depending on RAID type. */
-static uint64_t sectors(struct raid_dev *rd, unsigned int meta_sector)
-{
-	struct pdc *pdc = META(rd, pdc);
-
-	switch (pdc->raid.type) {
-	case PDC_T_RAID10:
-               return pdc->raid.total_secs / (pdc->raid.total_disks / 2);
-
-	case PDC_T_RAID1:
-               return pdc->raid.total_secs;
-
-	case PDC_T_RAID0:
-               return pdc->raid.total_secs / pdc->raid.total_disks;
-
-	case PDC_T_SPAN:
-	       return rd->di->sectors - meta_sector;
-	}
-
-	return 0;
-}
-
 /* Set the RAID device contents up derived from the PDC ones */
 static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 		    struct dev_info *di, void *meta, union read_info *info)
 {
-	unsigned int meta_sector;
+	unsigned meta_sector;
 	struct pdc *pdc = meta;
 
 	if (!checksum(pdc))
@@ -455,21 +618,21 @@
 	meta_sector = info->u32;
 	rd->meta_areas->offset = di->sectors - meta_sector;
 	rd->meta_areas->size = sizeof(*pdc);
-	rd->meta_areas->area = (void*) pdc;
+	rd->meta_areas->area = pdc;
 
         rd->di = di;
 	rd->fmt = &pdc_format;
-
 	rd->status = status(pdc);
+
 	/*
 	 * Type needs to be set before sectors(), because we need
 	 * to set the RAID10 type used there!
 	 */
-	rd->type   = type(pdc);
+	rd->type = type(pdc);
 
 	rd->offset = PDC_DATAOFFSET;
 	if (!(rd->sectors = sectors(rd, meta_sector)))
 		return log_zero_sectors(lc, di->path, handler);
 
-        return (rd->name = name(lc, rd, is_raid10(pdc))) ? 1 : 0;
+        return (rd->name = _name(lc, pdc, is_raid10(pdc))) ? 1 : 0;
 }
--- dmraid/lib/format/ataraid/pdc.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/format/ataraid/pdc.h	2008/04/02 13:35:31	1.2
@@ -13,9 +13,16 @@
 
 #include <stdint.h>
 
-#define PDC_CONFIGOFFSETS	63,255,256,16,399,735
+#define PDC_CONFIGOFFSETS	63,255,256,16,399,675,735,974,991
 #define	PDC_DATAOFFSET 0
 
+/*
+ * Maximum metadata areas checked for and offset of
+ * those relative to PDC_CONFIGOFFSETS value in sectors.
+ */
+#define	PDC_MAX_META_AREAS	4
+#define	PDC_META_OFFSET		14
+
 /* Ondisk metadata for Promise Fastrack */
 struct pdc {
 #define PDC_ID_LENGTH	24
@@ -36,7 +43,8 @@
 		uint8_t device;			/* 0x207 */
 		uint32_t magic_0;		/* 0x208 - 0x20B */
 		uint32_t unknown_1;		/* 0x20C - 0x20F */
-		uint32_t unknown_2;		/* 0x210 - 0x213 */
+		// uint32_t unknown_2;		/* 0x210 - 0x213 */
+		uint32_t start;			/* 0x210 - 0x213 */
 		uint32_t disk_secs;		/* 0x214 - 0x217 */
 		uint32_t unknown_3;		/* 0x218 - 0x21B */
 		uint16_t unknown_4;		/* 0x21C - 0x21D */
--- dmraid/lib/format/ddf/ddf1.c	2008/02/22 17:06:54	1.2
+++ dmraid/lib/format/ddf/ddf1.c	2008/04/02 13:35:31	1.3
@@ -19,6 +19,18 @@
 #include "ddf1_cvt.h"
 #include "ddf1_dump.h"
 
+#define GRP_RD(rd) \
+	(((struct ddf1_group_info *) (rd)->private.ptr)->rd_group)
+
+/*
+ * Helper struct to squirrel a group set reference to the check method
+ * in order to avoid, that premature deallocation in metadata.c
+ * removes the group set.
+ */
+struct ddf1_group_info {
+	struct raid_dev *rd_group;
+};
+
 static const char *handler = HANDLER;
 
 #define	DDF1_SPARES	".ddf1_spares"
@@ -595,8 +607,10 @@
 /* Sort DDF1 devices by offset entry within a RAID set. */
 static int dev_sort(struct list_head *pos, struct list_head *new)
 {
-	return compose_id(META(RD(new)->private.ptr, ddf1), RD(new)) <
-	       compose_id(META(RD(pos)->private.ptr, ddf1), RD(pos));
+	struct raid_dev *rd_pos = RD(pos), *rd_new = RD(new);
+
+	return compose_id(META(GRP_RD(rd_new), ddf1), rd_new) <
+	       compose_id(META(GRP_RD(rd_pos), ddf1), rd_pos);
 }
 
 /*
@@ -705,6 +719,7 @@
 	struct raid_dev *rd;
 	struct ddf1_config_record *cr;
 	struct ddf1_phys_drive *pd;
+	struct ddf1_group_info *gi;
 	unsigned int devs, i;
 	
 	if (!(pd = get_phys_drive(ddf1)))
@@ -746,8 +761,14 @@
 			return NULL;
 		}
 
+		if (!(gi = alloc_private(lc, handler, sizeof(*gi)))) {
+			free_raid_dev(lc, &rd);
+			return NULL;
+		}
+
 		/* Keep reference to the entire device for ddf1_check() */
-		rd->private.ptr = rd_group;
+		rd->private.ptr = gi;
+		GRP_RD(rd) = rd_group;
 
 		/* Add rest of subset state */
 		rs->stride = stride(cr);
@@ -825,13 +846,8 @@
 {
 	/* Get the logical drive */
 	struct ddf1_config_record *cr =
-		get_this_config(META(rd->private.ptr, ddf1), rd->offset);
+		get_this_config(META(GRP_RD(rd), ddf1), rd->offset);
 
-	/*
-	 * Release reference after check, so that core
-	 * doesn't try to free it multiple times.
-	 */
-	rd->private.ptr = NULL;
 	return cr ? cr->primary_element_count : 0;
 }
 
--- dmraid/lib/format/ddf/ddf1_crc.c	2008/02/22 17:06:54	1.2
+++ dmraid/lib/format/ddf/ddf1_crc.c	2008/04/02 13:35:31	1.3
@@ -16,6 +16,7 @@
 #include "ddf1.h"
 #include "ddf1_crc.h"
 #include "ddf1_lib.h"
+#include "zlib.h"
 
 #define DM_BYTEORDER_SWAB
 #include <datastruct/byteorder.h>
--- dmraid/lib/format/partition/dos.c	2008/02/22 17:04:36	1.2
+++ dmraid/lib/format/partition/dos.c	2008/04/02 13:35:31	1.3
@@ -29,8 +29,11 @@
 		    unsigned short partition, char *str, size_t len,
 		    unsigned char type)
 {
-	return snprintf(str, len, type ? "%s%u" : "%s",
-			get_basename(lc, rd->di->path), partition);
+	const char *base = get_basename(lc, rd->di->path);
+
+	return type ? snprintf(str, len, "%s%s%u", base, OPT_STR_PARTCHAR(lc),
+			       partition) :
+		      snprintf(str, len, "%s", base);
 }
 
 static char *name(struct lib_context *lc, struct raid_dev *rd,
--- dmraid/lib/metadata/metadata.c	2008/02/22 17:06:00	1.3
+++ dmraid/lib/metadata/metadata.c	2008/04/02 13:35:31	1.4
@@ -799,8 +799,21 @@
 
 		if (len2 > len1 ||
 		    strncmp(rs->name, name, min(len1, len2))) {
+			struct dmraid_format *fmt = get_format(rs);
+
 			log_notice(lc, "dropping unwanted RAID set \"%s\"",
 				   rs->name);
+
+			/*
+			 * ddf1 carries a private pointer to it's contianing
+			 * set which is cleared as part of the check. So we
+			 * must call it's check method before freeing the
+			 * set. Whats more, it looks like ddf1 check can
+			 * only be called once, yoweee !!!!
+			 */
+			if (fmt)
+				fmt->check(lc, rs);
+
 			free_raid_set(lc, rs);
 		}
 	}
@@ -838,6 +851,7 @@
 	struct dmraid_format *fmt;
 
 	list_for_each_safe(elem, tmp, LC_RS(lc)) {
+		/* Some metadata format handlers may not have a check method. */
 		if (!(fmt = get_format((rs = RS(elem)))))
 			continue;
 
@@ -864,11 +878,13 @@
 {
 	struct raid_dev *rd;
 	struct raid_set *rs;
+	struct list_head *elem, *tmp;
 
 	if (name && find_set(lc, NULL, name, FIND_TOP))
 		LOG_ERR(lc, 0, "RAID set %s already exists", name);
 
-	list_for_each_entry(rd, LC_RD(lc), list) {
+	list_for_each_safe(elem, tmp, LC_RD(lc)) {
+		rd = list_entry(elem, struct raid_dev, list);
 		/* FIXME: optimize dropping of unwanted RAID sets. */
 		if ((rs = dmraid_group(lc, rd))) {
 			log_notice(lc, "added %s to RAID set \"%s\"",
@@ -1039,22 +1055,20 @@
  * File RAID metadata and offset on device for analysis.
  */
 /* FIXME: all files into one directory ? */
-static size_t __name(struct lib_context *lc, char *str, size_t len, char *path,
-		     const char *suffix, const char *handler)
+static size_t __name(struct lib_context *lc, char *str, size_t len,
+		     const char *path, const char *suffix)
 {
-	return snprintf(str, len, "%s_%s.%s",
-			get_basename(lc, path), handler, suffix) + 1;
+	return snprintf(str, len, "%s.%s",
+			get_basename(lc, (char*) path), suffix) + 1;
 }
 
-static char *_name(struct lib_context *lc, char *path,
-		  const char *suffix, const char *handler)
+static char *_name(struct lib_context *lc, const char *path, const char *suffix)
 {
 	size_t len;
 	char *ret;
 
-	if ((ret = dbg_malloc((len = __name(lc, NULL, 0, path,
-					    suffix, handler)))))
-		__name(lc, ret, len, path, suffix, handler);
+	if ((ret = dbg_malloc((len = __name(lc, NULL, 0, path, suffix)))))
+		__name(lc, ret, len, path, suffix);
 	else
 		log_alloc_err(lc, __func__);
 
@@ -1067,7 +1081,7 @@
 	int ret = 0;
 	char *name;
 
-	if ((name = _name(lc, path, "dat", handler))) {
+	if ((name = _name(lc, path, "dat"))) {
 		log_notice(lc, "writing metadata file \"%s\"", name);
 		ret = write_file(lc, handler, name, data, size, 0);
 		dbg_free(name);
@@ -1081,25 +1095,64 @@
 {
 	char *name, s_number[32];
 	
-	if ((name = _name(lc, path, suffix, handler))) {
+	if ((name = _name(lc, path, suffix))) {
 		log_notice(lc, "writing %s to file \"%s\"", suffix, name);
 		write_file(lc, handler, name, (void*) s_number,
 		           snprintf(s_number, sizeof(s_number),
-			   "%" PRIu64 "\n", number),
-				 0);
+			   "%" PRIu64 "\n", number), 0);
 		dbg_free(name);
 	}
 }
 
+static int _chdir(struct lib_context *lc, const char *dir)
+{
+	if (chdir(dir)) {
+		log_err(lc, "changing directory to %s", dir);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static char *_dir(struct lib_context *lc, const char *handler)
+{
+	char *dir = _name(lc, lc->cmd, handler);
+
+	if (!dir) {
+		log_err(lc, "allocating directory name for %s", handler);
+		return NULL;
+	}
+
+	if (!mk_dir(lc, dir))
+		goto out;
+
+	if (!_chdir(lc, dir))
+		return dir;
+
+   out:
+	dbg_free(dir);
+	return NULL;
+}
+
 /*
  * File vendor RAID metadata.
  */
 void file_metadata(struct lib_context *lc, const char *handler,
 		   char *path, void *data, size_t size, uint64_t offset)
 {
-	if (OPT_DUMP(lc) &&
-	    file_data(lc, handler, path, data, size))
-		file_number(lc, handler, path, offset, "offset");
+	if (OPT_DUMP(lc)) {
+		char *dir = _dir(lc, handler);
+
+		if (dir)
+			dbg_free(dir);
+		else
+			return;
+
+		if (file_data(lc, handler, path, data, size))
+			file_number(lc, handler, path, offset, "offset");
+
+		_chdir(lc, "..");
+	}
 }
 
 /*
@@ -1108,6 +1161,15 @@
 void file_dev_size(struct lib_context *lc, const char *handler,
 		   struct dev_info *di)
 {
-	if (OPT_DUMP(lc))
+	if (OPT_DUMP(lc)) {
+		char *dir = _dir(lc, handler);
+
+		if (dir)
+			dbg_free(dir);
+		else
+			return;
+
 		file_number(lc, handler, di->path, di->sectors, "size");
+		_chdir(lc, "..");
+	}
 }
--- dmraid/lib/misc/lib_context.c	2008/02/22 16:57:36	1.1
+++ dmraid/lib/misc/lib_context.c	2008/04/02 13:35:32	1.2
@@ -94,6 +94,9 @@
 {
 	lc_inc_opt(lc, LC_SEPARATOR);
 	lc->options[LC_SEPARATOR].arg.str = dbg_strdup((char*) ",");
+
+	lc_inc_opt(lc, LC_PARTCHAR);
+	lc->options[LC_PARTCHAR].arg.str = dbg_strdup((char*) "p");
 }
 
 static void init_cmd(struct lib_context *lc, void *arg)
--- dmraid/man/dmraid.8	2008/02/22 16:57:37	1.1
+++ dmraid/man/dmraid.8	2008/04/02 13:35:32	1.2
@@ -6,6 +6,7 @@
  {-a|--activate} {y|n|yes|no} 
  [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
  [-f|--format FORMAT[,FORMAT...]]
+ [{-P|--partchar} CHAR]
  [-p|--no_partitions]
  [--separator SEPARATOR]
  [-t|--test]
@@ -176,6 +177,10 @@
 is restricted to those listed.
 
 .TP
+.I [{-P|--partchar} CHAR]
+Use CHAR as the separator between the device name and the partition number.
+
+.TP
 .I {-r|--raid_devices} [device-path...]
 List all discovered RAID devices with format, RAID level, sectors used
 and data offset into the device.
@@ -187,10 +192,11 @@
 .B -D
 is added to
 .B -r
-the RAID metadata gets dumped into files named devicename_formatname.dat.
-The offset in sectors where the metadata is located on the device is written
-into files named devicename_formatname.offset and the size of the device
-into files named devicename_formatname.size.
+the RAID metadata gets dumped into a subdirectory named dmraid.format_name
+(eg. format_name = isw) in files named devicename.dat.
+The byte offset where the metadata is located on the device is written
+into files named devicename.offset and the size of the device in sectors
+into files named devicename.size.
 
 If 
 .B -E
@@ -214,7 +220,7 @@
 .br
 do
 .br
-	dd if=$f of=/dev/${f%%_*} \\
+	dd if=$f of=/dev/${f%%.dat} \\
 .br
 	seek=`cat ${f%%dat}offset` bs=1
 .br
--- dmraid/tools/VERSION	2008/02/22 17:06:54	1.4
+++ dmraid/tools/VERSION	2008/04/02 13:35:32	1.5
@@ -1 +1 @@
-1.0.0.rc14 (2006.11.08)
+1.0.0.rc15 (2008.04.02)
--- dmraid/tools/commands.c	2008/02/22 16:57:37	1.1
+++ dmraid/tools/commands.c	2008/04/02 13:35:32	1.2
@@ -24,7 +24,7 @@
 /*
  * Command line options.
  */
-static char const *short_opts = "a:hip"
+static char const *short_opts = "a:hipP:"
 #ifndef	DMRAID_MINI
 				"bc::dDEf:gl"
 #ifdef	DMRAID_NATIVE_LOG
@@ -38,6 +38,7 @@
 static struct option long_opts[] = {
 	{"activate", required_argument, NULL, 'a'},
 	{"format", required_argument, NULL, 'f'},
+	{"partchar", required_argument, NULL, 'P'},
 	{"no_partitions", no_argument, NULL, 'p'},
 # ifndef DMRAID_MINI
 	{"block_devices", no_argument, NULL, 'b'},
@@ -148,6 +149,14 @@
 }
 #endif
 
+/* Check and store option for partition separator. */
+static int check_part_separator(struct lib_context *lc, int arg)
+{
+	/* We're not actually checking that it's only one character... if
+	   somebody wants to use more, it shouldn't hurt anything. */
+	return lc_stralloc_opt(lc, LC_PARTCHAR, optarg) ? 1 : 0;
+}
+
 /* Display help information */
 static int help(struct lib_context *lc, int arg)
 {
@@ -158,6 +167,7 @@
 		  "[Early Boot Version]\n", c);
 	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} [-i|--ignorelocking]\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[-P|--partchar CHAR]\n"
 		  "\t[-p|--no_partitions]\n"
 		  "\t[--separator SEPARATOR]\n"
 		  "\t[RAID-set...]\n", c);
@@ -168,6 +178,7 @@
 	log_print(lc, "* = [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]\n");
 	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} *\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[-P|--partchar CHAR]\n"
 		  "\t[-p|--no_partitions]\n"
 		  "\t[--separator SEPARATOR]\n"
 		  "\t[-t|--test]\n"
@@ -249,6 +260,19 @@
 	  LC_FORMAT,
 	},
 
+	/* Partition separator. */
+	{ 'P',
+	  PARTCHAR,
+	  ACTIVATE|DEACTIVATE,
+	  FORMAT|HELP|IGNORELOCKING|SEPARATOR
+#ifndef DMRAID_MINI
+	  |DBG|TEST|VERBOSE
+#endif
+	  , ARGS,
+	  check_part_separator,
+	  0,
+	},
+
 	/* Partition option. */
 	{ 'p',
 	  NOPARTITIONS,
--- dmraid/tools/commands.h	2008/02/22 16:57:37	1.1
+++ dmraid/tools/commands.h	2008/04/02 13:35:32	1.2
@@ -46,6 +46,7 @@
 #endif
 	VERSION		= 0x100000,
 	IGNORELOCKING	= 0x200000,
+	PARTCHAR	= 0x400000,
 };
 
 #define	ALL_FLAGS	((enum action) -1)
