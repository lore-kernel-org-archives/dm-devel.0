From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH] Add blkzonecmd and blkreport ZAC/ZBC drives
Date: Mon, 21 Nov 2016 15:43:15 -0600
Message-ID: <20161121214315.31023-1-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Karel Zak <kzak@redhat.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, dm-devel <dm-devel@redhat.com>, Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Michael T Lombardi <michael.t.lombardi@seagate.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

This patch adds:
 - blkreset to issue Reset (Write Pointer) zone commands
 - blkreport to retrieve drive zone information

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Signed-off-by: Shaun Tancheff <shaun@tancheff.com>
---
 .gitignore              |   2 +
 configure.ac            |  10 ++
 include/strutils.h      |   1 +
 lib/strutils.c          |   8 +-
 sys-utils/Makemodule.am |  17 ++
 sys-utils/blkreport.8   |  69 +++++++
 sys-utils/blkreport.c   | 470 ++++++++++++++++++++++++++++++++++++++++++++++++
 sys-utils/blkreset.8    |  63 +++++++
 sys-utils/blkreset.c    | 295 ++++++++++++++++++++++++++++++
 9 files changed, 933 insertions(+), 2 deletions(-)
 create mode 100644 sys-utils/blkreport.8
 create mode 100644 sys-utils/blkreport.c
 create mode 100644 sys-utils/blkreset.8
 create mode 100644 sys-utils/blkreset.c

diff --git a/.gitignore b/.gitignore
index 064010b..4c87bac 100644
--- a/.gitignore
+++ b/.gitignore
@@ -62,6 +62,8 @@ update.log
 /addpart
 /agetty
 /blkdiscard
+/blkreport
+/blkreset
 /blkid
 /blockdev
 /cal
diff --git a/configure.ac b/configure.ac
index 1bd7d2e..aac597f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -275,6 +275,8 @@ AC_CHECK_HEADERS([security/pam_misc.h],
 #endif
 ])
 
+AC_CHECK_HEADERS([linux/blkzoned.h])
+
 AC_CHECK_HEADERS([security/openpam.h], [], [], [
 #ifdef HAVE_SECURITY_PAM_APPL_H
 #include <security/pam_appl.h>
@@ -1533,6 +1535,14 @@ UL_BUILD_INIT([blkdiscard], [check])
 UL_REQUIRES_LINUX([blkdiscard])
 AM_CONDITIONAL([BUILD_BLKDISCARD], [test "x$build_blkdiscard" = xyes])
 
+UL_BUILD_INIT([blkreport], [check])
+UL_REQUIRES_LINUX([blkreport])
+AM_CONDITIONAL([BUILD_BLKREPORT], [test "x$build_blkreport" = xyes])
+
+UL_BUILD_INIT([blkreset], [check])
+UL_REQUIRES_LINUX([blkreset])
+AM_CONDITIONAL([BUILD_BLKZONECMD], [test "x$build_blkreset" = xyes])
+
 UL_BUILD_INIT([ldattach], [check])
 UL_REQUIRES_LINUX([ldattach])
 AM_CONDITIONAL([BUILD_LDATTACH], [test "x$build_ldattach" = xyes])
diff --git a/include/strutils.h b/include/strutils.h
index 51d9c9f..7da0cd4 100644
--- a/include/strutils.h
+++ b/include/strutils.h
@@ -27,6 +27,7 @@ extern uint32_t strtou32_or_err(const char *str, const char *errmesg);
 
 extern int64_t strtos64_or_err(const char *str, const char *errmesg);
 extern uint64_t strtou64_or_err(const char *str, const char *errmesg);
+extern uint64_t strtou64_base_or_err(int base, const char *str, const char *errmesg);
 
 extern double strtod_or_err(const char *str, const char *errmesg);
 
diff --git a/lib/strutils.c b/lib/strutils.c
index d3b998f..861df77 100644
--- a/lib/strutils.c
+++ b/lib/strutils.c
@@ -329,7 +329,7 @@ err:
 	errx(STRTOXX_EXIT_CODE, "%s: '%s'", errmesg, str);
 }
 
-uint64_t strtou64_or_err(const char *str, const char *errmesg)
+uint64_t strtou64_base_or_err(int base, const char *str, const char *errmesg)
 {
 	uintmax_t num;
 	char *end = NULL;
@@ -337,7 +337,7 @@ uint64_t strtou64_or_err(const char *str, const char *errmesg)
 	errno = 0;
 	if (str == NULL || *str == '\0')
 		goto err;
-	num = strtoumax(str, &end, 10);
+	num = strtoumax(str, &end, base);
 
 	if (errno || str == end || (end && *end))
 		goto err;
@@ -350,6 +350,10 @@ err:
 	errx(STRTOXX_EXIT_CODE, "%s: '%s'", errmesg, str);
 }
 
+uint64_t strtou64_or_err(const char *str, const char *errmesg)
+{
+	return strtou64_base_or_err(10, str, errmesg);
+}
 
 double strtod_or_err(const char *str, const char *errmesg)
 {
diff --git a/sys-utils/Makemodule.am b/sys-utils/Makemodule.am
index 9400303..4fa7243 100644
--- a/sys-utils/Makemodule.am
+++ b/sys-utils/Makemodule.am
@@ -111,6 +111,23 @@ blkdiscard_SOURCES = sys-utils/blkdiscard.c lib/monotonic.c
 blkdiscard_LDADD = $(LDADD) libcommon.la $(REALTIME_LIBS)
 endif
 
+if BUILD_BLKREPORT
+sbin_PROGRAMS += blkreport
+dist_man_MANS += sys-utils/blkreport.8
+blkreport_SOURCES = sys-utils/blkreport.c
+blkreport_LDADD = $(LDADD) libcommon.la $(REALTIME_LIBS)
+endif
+
+if BUILD_BLKZONECMD
+sbin_PROGRAMS += blkreset
+dist_man_MANS += sys-utils/blkreset.8
+blkreset_SOURCES = sys-utils/blkreset.c
+blkreset_LDADD = $(LDADD) libcommon.la $(REALTIME_LIBS)
+if HAVE_UDEV
+blkreset_LDADD += -ludev
+endif
+endif
+
 if BUILD_LDATTACH
 usrsbin_exec_PROGRAMS += ldattach
 dist_man_MANS += sys-utils/ldattach.8
diff --git a/sys-utils/blkreport.8 b/sys-utils/blkreport.8
new file mode 100644
index 0000000..9225958
--- /dev/null
+++ b/sys-utils/blkreport.8
@@ -0,0 +1,69 @@
+.TH BLKREPORT 5 "March 2016" "util-linux" "System Administration"
+.SH NAME
+blkreport \- report zones on a device
+.SH SYNOPSIS
+.B blkreport
+[options]
+.RB [ \-o
+.IR offset ]
+.RB [ \-l
+.IR report length ]
+.I device
+.SH DESCRIPTION
+.B blkreport
+is used to report device zone information.  This is useful for
+zoned devices that support the ZAC or ZBC command set.
+.PP
+By default,
+.B blkreport
+will report from the start of the block device upto 512k bytes of the
+zone report (~8160 zones].  Options may be used to modify
+this behavior based on the starting zone or size of the report,
+as explained below.
+.PP
+The
+.I device
+argument is the pathname of the block device.
+.PP
+.SH OPTIONS
+The
+.I zone
+and
+.I length
+arguments may be followed by the multiplicative suffixes KiB (=1024),
+MiB (=1024*1024), and so on for GiB, TiB, PiB, EiB, ZiB and YiB (the "iB" is
+optional, e.g., "K" has the same meaning as "KiB") or the suffixes
+KB (=1000), MB (=1000*1000), and so on for GB, TB, PB, EB, ZB and YB.
+.TP
+.BR \-z , " \-\-zone \fIoffset"
+The starting zone to be reported on on specified as a sector offset.
+The provided offset in sector units should match the start of a zone.
+The default value is zero.
+.TP
+.BR \-l , " \-\-length \fIlength"
+The number of bytes to allocate for the report from the block device.
+The provided value will be aligned to the device sector size.
+If the specified value will be limited to the range of 512 bytes to 512 k-bytes.
+.TP
+.BR \-v , " \-\-verbose"
+Display the aligned values of
+.I offset
+and
+.IR length .
+.TP
+.BR \-V , " \-\-version"
+Display version information and exit.
+.TP
+.BR \-h , " \-\-help"
+Display help text and exit.
+.SH AUTHOR
+.MT shaun@tancheff.com
+Shaun Tancheff
+.ME
+.SH SEE ALSO
+.BR sg_rep_zones (8)
+.SH AVAILABILITY
+The blkreport command is part of the util-linux package and is available
+.UR ftp://\:ftp.kernel.org\:/pub\:/linux\:/utils\:/util-linux/
+Linux Kernel Archive
+.UE .
diff --git a/sys-utils/blkreport.c b/sys-utils/blkreport.c
new file mode 100644
index 0000000..a386bb3
--- /dev/null
+++ b/sys-utils/blkreport.c
@@ -0,0 +1,470 @@
+/*
+ * blkreport.c -- request a zone report on part (or all) of the block device.
+ *
+ * Copyright (C) 2015,2016 Seagate Technology PLC
+ * Written by Shaun Tancheff <shaun.tancheff@seagate.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * This program uses BLKREPORT ioctl to query zone information about part of
+ * or a whole block device, if the device supports it.
+ * You can specify range (start and length) to be queried.
+ */
+
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <getopt.h>
+#include <time.h>
+
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <linux/fs.h>
+
+#ifdef HAVE_LINUX_BLKZONED_H
+#include <linux/blkzoned.h>
+#endif
+
+#define ENABLE_REPORTING_OPTION 0 /* future */
+
+#include "nls.h"
+#include "strutils.h"
+#include "c.h"
+#include "closestream.h"
+#include "monotonic.h"
+
+#ifndef HAVE_LINUX_BLKZONED_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/**
+ * enum blk_zone_type - Types of zones allowed in a zoned device.
+ *
+ * @BLK_ZONE_TYPE_CONVENTIONAL: The zone has no write pointer and can be writen
+ *                              randomly. Zone reset has no effect on the zone.
+ * @BLK_ZONE_TYPE_SEQWRITE_REQ: The zone must be written sequentially
+ * @BLK_ZONE_TYPE_SEQWRITE_PREF: The zone can be written non-sequentially
+ *
+ * Any other value not defined is reserved and must be considered as invalid.
+ */
+enum blk_zone_type {
+	BLK_ZONE_TYPE_CONVENTIONAL	= 0x1,
+	BLK_ZONE_TYPE_SEQWRITE_REQ	= 0x2,
+	BLK_ZONE_TYPE_SEQWRITE_PREF	= 0x3,
+};
+
+/**
+ * enum blk_zone_cond - Condition [state] of a zone in a zoned device.
+ *
+ * @BLK_ZONE_COND_NOT_WP: The zone has no write pointer, it is conventional.
+ * @BLK_ZONE_COND_EMPTY: The zone is empty.
+ * @BLK_ZONE_COND_IMP_OPEN: The zone is open, but not explicitly opened.
+ * @BLK_ZONE_COND_EXP_OPEN: The zones was explicitly opened by an
+ *                          OPEN ZONE command.
+ * @BLK_ZONE_COND_CLOSED: The zone was [explicitly] closed after writing.
+ * @BLK_ZONE_COND_FULL: The zone is marked as full, possibly by a zone
+ *                      FINISH ZONE command.
+ * @BLK_ZONE_COND_READONLY: The zone is read-only.
+ * @BLK_ZONE_COND_OFFLINE: The zone is offline (sectors cannot be read/written).
+ *
+ * The Zone Condition state machine in the ZBC/ZAC standards maps the above
+ * deinitions as:
+ *   - ZC1: Empty         | BLK_ZONE_EMPTY
+ *   - ZC2: Implicit Open | BLK_ZONE_COND_IMP_OPEN
+ *   - ZC3: Explicit Open | BLK_ZONE_COND_EXP_OPEN
+ *   - ZC4: Closed        | BLK_ZONE_CLOSED
+ *   - ZC5: Full          | BLK_ZONE_FULL
+ *   - ZC6: Read Only     | BLK_ZONE_READONLY
+ *   - ZC7: Offline       | BLK_ZONE_OFFLINE
+ *
+ * Conditions 0x5 to 0xC are reserved by the current ZBC/ZAC spec and should
+ * be considered invalid.
+ */
+enum blk_zone_cond {
+	BLK_ZONE_COND_NOT_WP	= 0x0,
+	BLK_ZONE_COND_EMPTY	= 0x1,
+	BLK_ZONE_COND_IMP_OPEN	= 0x2,
+	BLK_ZONE_COND_EXP_OPEN	= 0x3,
+	BLK_ZONE_COND_CLOSED	= 0x4,
+	BLK_ZONE_COND_READONLY	= 0xD,
+	BLK_ZONE_COND_FULL	= 0xE,
+	BLK_ZONE_COND_OFFLINE	= 0xF,
+};
+
+/**
+ * struct blk_zone - Zone descriptor for BLKREPORTZONE ioctl.
+ *
+ * @start: Zone start in 512 B sector units
+ * @len: Zone length in 512 B sector units
+ * @wp: Zone write pointer location in 512 B sector units
+ * @type: see enum blk_zone_type for possible values
+ * @cond: see enum blk_zone_cond for possible values
+ * @non_seq: Flag indicating that the zone is using non-sequential resources
+ *           (for host-aware zoned block devices only).
+ * @reset: Flag indicating that a zone reset is recommended.
+ * @reserved: Padding to 64 B to match the ZBC/ZAC defined zone descriptor size.
+ *
+ * start, len and wp use the regular 512 B sector unit, regardless of the
+ * device logical block size. The overall structure size is 64 B to match the
+ * ZBC/ZAC defined zone descriptor and allow support for future additional
+ * zone information.
+ */
+struct blk_zone {
+	__u64	start;		/* Zone start sector */
+	__u64	len;		/* Zone length in number of sectors */
+	__u64	wp;		/* Zone write pointer position */
+	__u8	type;		/* Zone type */
+	__u8	cond;		/* Zone condition */
+	__u8	non_seq;	/* Non-sequential write resources active */
+	__u8	reset;		/* Reset write pointer recommended */
+	__u8	reserved[36];
+};
+
+/**
+ * struct blk_zone_report - BLKREPORTZONE ioctl request/reply
+ *
+ * @sector: starting sector of report
+ * @nr_zones: IN maximum / OUT actual
+ * @reserved: padding to 16 byte alignment
+ * @zones: Space to hold @nr_zones @zones entries on reply.
+ *
+ * The array of at most @nr_zones must follow this structure in memory.
+ */
+struct blk_zone_report {
+	__u64		sector;
+	__u32		nr_zones;
+	__u8		reserved[4];
+	struct blk_zone zones[0];
+} __attribute__((packed));
+
+/**
+ * Zoned block device ioctl's:
+ *
+ * @BLKREPORTZONE: Get zone information. Takes a zone report as argument.
+ *                 The zone report will start from the zone containing the
+ *                 sector specified in the report request structure.
+ */
+#define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
+
+#endif /* ! HAVE_BLKZONED_H */
+
+#if ENABLE_REPORTING_OPTION
+
+#define ZBC_REPORT_OPTION_MASK  0x3f
+#define ZBC_REPORT_ZONE_PARTIAL 0x80
+
+/**
+ * enum zone_report_option - Report Zones types to be included.
+ *
+ * @ZOPT_NON_SEQ_AND_RESET: Default (all zones).
+ * @ZOPT_ZC1_EMPTY: Zones which are empty.
+ * @ZOPT_ZC2_OPEN_IMPLICIT: Zones open but not explicitly opened
+ * @ZOPT_ZC3_OPEN_EXPLICIT: Zones opened explicitly
+ * @ZOPT_ZC4_CLOSED: Zones closed for writing.
+ * @ZOPT_ZC5_FULL: Zones that are full.
+ * @ZOPT_ZC6_READ_ONLY: Zones that are read-only
+ * @ZOPT_ZC7_OFFLINE: Zones that are offline
+ * @ZOPT_RESET: Zones with Reset WP Recommended
+ * @ZOPT_NON_SEQ: Zones that with Non-Sequential Write Resources Active
+ * @ZOPT_NON_WP_ZONES: Zones that do not have Write Pointers (conventional)
+ * @ZOPT_PARTIAL_FLAG: Modifies the definition of the Zone List Length field.
+ *
+ * Used by Report Zones in bdev_zone_get_report: report_option
+ */
+enum zbc_zone_reporting_options {
+	ZBC_ZONE_REPORTING_OPTION_ALL = 0,
+	ZBC_ZONE_REPORTING_OPTION_EMPTY,
+	ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_CLOSED,
+	ZBC_ZONE_REPORTING_OPTION_FULL,
+	ZBC_ZONE_REPORTING_OPTION_READONLY,
+	ZBC_ZONE_REPORTING_OPTION_OFFLINE,
+	ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP = 0x10,
+	ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE,
+	ZBC_ZONE_REPORTING_OPTION_NON_WP = 0x3f,
+	ZBC_ZONE_REPORTING_OPTION_RESERVED = 0x40,
+	ZBC_ZONE_REPORTING_OPTION_PARTIAL = ZBC_REPORT_ZONE_PARTIAL
+};
+
+static inline int is_report_option_valid(uint64_t ropt)
+{
+	uint8_t _opt = ropt & ZBC_REPORT_OPTION_MASK;
+
+	if (ropt & ZBC_ZONE_REPORTING_OPTION_RESERVED) {
+		fprintf(stderr, "Illegal report option %x is reserved.\n",
+			ZBC_ZONE_REPORTING_OPTION_RESERVED);
+		return 0;
+	}
+
+	if (_opt <= ZBC_ZONE_REPORTING_OPTION_OFFLINE)
+		return 1;
+	
+	switch (_opt) {
+	case ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP:
+	case ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE:
+	case ZBC_ZONE_REPORTING_OPTION_NON_WP:
+		return 1;
+	default:
+		fprintf(stderr, "Illegal report option %x is unknown.\n",
+			ZBC_ZONE_REPORTING_OPTION_RESERVED);
+		return 0;
+	}
+}
+
+# define ZBC_REPORT_OPT "r:"
+
+#else
+
+# define ZBC_ZONE_REPORTING_OPTION_ALL		0
+# define ZBC_REPORT_OPT				""
+static inline int is_report_option_valid(uint64_t ropt)
+{
+	return (ropt == ZBC_ZONE_REPORTING_OPTION_ALL);
+}
+
+#endif /* ENABLE_REPORTING_OPTION */
+
+static const char * type_text[] = {
+	"RESERVED",
+	"CONVENTIONAL",
+	"SEQ_WRITE_REQUIRED",
+	"SEQ_WRITE_PREFERRED",
+};
+
+#define ARRAY_COUNT(x) (sizeof((x))/sizeof((*x)))
+
+const char * condition_str[] = {
+	"cv", /* conventional zone */
+	"e0", /* empty */
+	"Oi", /* open implicit */
+	"Oe", /* open explicit */
+	"Cl", /* closed */
+	"x5", "x6", "x7", "x8", "x9", "xA", "xB", /* xN: reserved */
+	"ro", /* read only */
+	"fu", /* full */
+	"OL"  /* offline */
+	};
+
+static const char * zone_condition_str(uint8_t cond)
+{
+	return condition_str[cond & 0x0f];
+}
+
+static void print_zones(struct blk_zone *info, uint32_t count)
+{
+	uint32_t iter;
+	const char *fmtx = "  start: %9lx, len %6lx, wptr %6lx"
+		           " reset:%u non-seq:%u, zcond:%2u(%s) [type: %u(%s)]\n";
+
+	fprintf(stdout, "Zones returned: %u\n", count);
+
+	for (iter = 0; iter < count; iter++ ) {
+		struct blk_zone * entry = &info[iter];
+		unsigned int type  = entry->type;
+		uint64_t start = entry->start;
+		uint64_t wp = entry->wp;
+		uint8_t cond = entry->cond;
+		uint64_t len = entry->len;
+		const char *fmt = fmtx;
+
+		if (!len) {
+			break;
+		}
+
+		fprintf(stdout, fmt, start, len, wp - start,
+			entry->reset, entry->non_seq,
+			cond, zone_condition_str(cond),
+			type, type_text[type]);
+	}
+}
+
+static int do_report(int fd, uint64_t lba, uint64_t len, uint8_t ropt, int verbose)
+{
+	int rc = -4;
+	struct blk_zone_report *zi;
+
+	zi = malloc(len + sizeof(struct blk_zone_report));
+	if (zi) {
+		zi->nr_zones = len / sizeof(struct blk_zone);
+		zi->sector = lba; /* maybe shift 4Kn -> 512e */
+		zi->reserved[0] = ropt;
+		rc = ioctl(fd, BLKREPORTZONE, zi);
+		if (rc != -1) {
+			if (verbose)
+				printf("Found %d zones\n", zi->nr_zones);
+			print_zones(zi->zones, zi->nr_zones);
+		} else {
+			fprintf(stderr, "ERR: %d -> %s\n\n", errno, strerror(errno));
+		}
+		free(zi);
+	}
+	return rc;
+}
+
+static void __attribute__((__noreturn__)) usage(FILE *out)
+{
+	fputs(USAGE_HEADER, out);
+	fprintf(out,
+	      _(" %s [options] <device>\n"), program_invocation_short_name);
+
+	fputs(USAGE_SEPARATOR, out);
+	fputs(_("Discard the content of sectors on a device.\n"), out);
+
+	fputs(USAGE_OPTIONS, out);
+	fputs(_(" -z, --zone <num>  zone lba in 512 byte sectors\n"
+		" -l, --length <num>  length of report (512 bytes to 512k bytes)\n"
+#if ENABLE_REPORTING_OPTION
+		" -r, --option <report> report option\n"
+		"    report is the numeric value from \"enum zone_report_option\".\n"
+		"             0 - non seq. and reset (default)\n"
+		"             1 - empty\n"
+		"             2 - open implicit\n"
+		"             3 - open explicit\n"
+		"             4 - closed\n"
+		"             5 - full\n"
+		"             6 - read only\n"
+		"             7 - offline\n"
+		"          0x10 - reset\n"
+		"          0x11 - non sequential\n"
+		"          0x3f - non write pointer zones\n"
+#endif
+		" -v, --verbose       print aligned length and offset"),
+		out);
+	fputs(USAGE_SEPARATOR, out);
+	fputs(USAGE_HELP, out);
+	fputs(USAGE_VERSION, out);
+	fprintf(out, USAGE_MAN_TAIL("blkreport(8)"));
+	exit(out == stderr ? EXIT_FAILURE : EXIT_SUCCESS);
+}
+
+
+#define MAX_REPORT_LEN		(1 << 19) /* 512k */
+#define MAX_REPORT_LEN_SAT	(1 << 18) /* 512k */
+
+int main(int argc, char **argv)
+{
+	char *path;
+	int c;
+	int fd;
+	int secsize;
+	uint64_t blksize;
+	struct stat sb;
+	int verbose = 0;
+	uint64_t ropt = ZBC_ZONE_REPORTING_OPTION_ALL;
+	uint64_t offset = 0ul;
+	uint32_t length = MAX_REPORT_LEN;
+	static const struct option longopts[] = {
+	    { "help",      0, 0, 'h' },
+	    { "version",   0, 0, 'V' },
+	    { "zone",      1, 0, 'z' }, /* starting LBA */
+	    { "length",    1, 0, 'l' }, /* max #of bytes for result */
+#if ENABLE_REPORTING_OPTION
+	    { "option",    1, 0, 'r' }, /* report option */
+#endif
+	    { "verbose",   0, 0, 'v' },
+	    { NULL,        0, 0, 0 }
+	};
+	const char *options = "hVl:z:v" ZBC_REPORT_OPT;
+
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+	atexit(close_stdout);
+
+	while ((c = getopt_long(argc, argv, options, longopts, NULL)) != -1) {
+		switch(c) {
+		case 'h':
+			usage(stdout);
+			break;
+		case 'V':
+			printf(UTIL_LINUX_VERSION);
+			return EXIT_SUCCESS;
+		case 'l':
+			length = strtou64_base_or_err(0, optarg,
+					_("failed to parse length"));
+			break;
+		case 'z':
+			offset = strtou64_base_or_err(0, optarg,
+					_("failed to parse offset"));
+			break;
+#if ENABLE_REPORTING_OPTION
+		case 'r':
+			ropt = strtou64_base_or_err(0, optarg,
+					_("failed to parse report option"));
+			break;
+#endif
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			usage(stderr);
+			break;
+		}
+	}
+
+	if (optind == argc)
+		errx(EXIT_FAILURE, _("no device specified"));
+
+	path = argv[optind++];
+
+	if (optind != argc) {
+		warnx(_("unexpected number of arguments"));
+		usage(stderr);
+	}
+
+	fd = open(path, O_RDWR);
+	if (fd < 0)
+		err(EXIT_FAILURE, _("cannot open %s"), path);
+
+	if (fstat(fd, &sb) == -1)
+		err(EXIT_FAILURE, _("stat of %s failed"), path);
+	if (!S_ISBLK(sb.st_mode))
+		errx(EXIT_FAILURE, _("%s: not a block device"), path);
+
+	if (ioctl(fd, BLKGETSIZE64, &blksize))
+		err(EXIT_FAILURE, _("%s: BLKGETSIZE64 ioctl failed"), path);
+	if (ioctl(fd, BLKSSZGET, &secsize))
+		err(EXIT_FAILURE, _("%s: BLKSSZGET ioctl failed"), path);
+
+	/* check offset alignment to the sector size */
+	if (offset % secsize)
+		errx(EXIT_FAILURE, _("%s: offset %" PRIu64 " is not aligned "
+			 "to sector size %i"), path, offset, secsize);
+
+	/* is the range end behind the end of the device ?*/
+	if (offset > blksize)
+		errx(EXIT_FAILURE, _("%s: offset is greater than device size"), path);
+
+	length = (length / 512) * 512;
+	if (length < 512)
+		length = 512;
+	if (length > MAX_REPORT_LEN)
+		length = MAX_REPORT_LEN;
+
+	if (!is_report_option_valid(ropt))
+		errx(EXIT_FAILURE, _("%s: invalid report option for device"), path);
+
+	if (do_report(fd, offset, length, ropt & 0xFF, verbose))
+		 err(EXIT_FAILURE, _("%s: BLKREPORTZONE ioctl failed"), path);
+
+	close(fd);
+	return EXIT_SUCCESS;
+}
diff --git a/sys-utils/blkreset.8 b/sys-utils/blkreset.8
new file mode 100644
index 0000000..7658d58
--- /dev/null
+++ b/sys-utils/blkreset.8
@@ -0,0 +1,63 @@
+.TH BLKRESET 5 "October 2016" "util-linux" "System Administration"
+.SH NAME
+blkreset \- Reset a range of zones
+.SH SYNOPSIS
+.B blkreset
+[options]
+.RB [ \-z
+.IR zone ]
+.RB [ \-c
+.IR number of zones ]
+.SH DESCRIPTION
+.B blkreset
+is used to reset a zone.  This is useful for
+zoned devices that support the ZAC or ZBC command set.
+Unlike
+.BR sg_reset_wp (8) ,
+this command operates from the block layer and can reset a range of zones.
+.PP
+By default,
+.B blkreset
+will operate on the zone at device logical sector 0. Options may be used to
+modify this behavior as well as specify the operation to be performed on
+the zone, as explained below.
+.PP
+The
+.I device
+argument is the pathname of the block device.
+.PP
+.SH OPTIONS
+The
+.I zone
+argument may be followed by the multiplicative suffixes KiB (=1024),
+MiB (=1024*1024), and so on for GiB, TiB, PiB, EiB, ZiB and YiB (the "iB" is
+optional, e.g., "K" has the same meaning as "KiB") or the suffixes
+KB (=1000), MB (=1000*1000), and so on for GB, TB, PB, EB, ZB and YB.
+As zones were originally required to be sized as a power of 2 logical
+sectors this still is the most common layout. The 0x prefix can also be
+used to specify the zone to be operated on.
+.TP
+.BR \-z , " \-\-zone \fIoffset"
+The zone to be operated on specified as a sector offset.
+The provided offset in sector units should match the start of a zone.
+The default value is zero.
+.TP
+.BR \-c , " \-\-count \fIzones"
+The number of zones to be reset starting from offset.
+.TP
+.BR \-V , " \-\-version"
+Display version information and exit.
+.TP
+.BR \-h , " \-\-help"
+Display help text and exit.
+.SH AUTHOR
+.MT shaun@tancheff.com
+Shaun Tancheff
+.ME
+.SH SEE ALSO
+.BR sg_reset_wp (8)
+.SH AVAILABILITY
+The blkreset command is part of the util-linux package and is available
+.UR ftp://\:ftp.kernel.org\:/pub\:/linux\:/utils\:/util-linux/
+Linux Kernel Archive
+.UE .
diff --git a/sys-utils/blkreset.c b/sys-utils/blkreset.c
new file mode 100644
index 0000000..1a6ed78
--- /dev/null
+++ b/sys-utils/blkreset.c
@@ -0,0 +1,295 @@
+/*
+ * blkreset.c -- Reset the WP on a range of zones.
+ *
+ * Copyright (C) 2015,2016 Seagate Technology PLC
+ * Written by Shaun Tancheff <shaun.tancheff@seagate.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * This program uses BLKREPORT ioctl to query zone information about part of
+ * or a whole block device, if the device supports it.
+ * You can specify range (start and length) to be queried.
+ */
+
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <getopt.h>
+#include <time.h>
+#include <ctype.h>
+
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <linux/fs.h>
+#include <linux/major.h>
+
+#ifdef HAVE_LINUX_BLKZONED_H
+#include <linux/blkzoned.h>
+#endif
+
+#ifdef HAVE_LIBUDEV
+#include <libudev.h> // udev to find sysfs entries
+#endif
+
+#include "nls.h"
+#include "strutils.h"
+#include "c.h"
+#include "closestream.h"
+#include "monotonic.h"
+
+#ifndef HAVE_LINUX_BLKZONED_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/**
+ * struct blk_zone_range - BLKRESETZONE ioctl request
+ * @sector: starting sector of the first zone to issue reset write pointer
+ * @nr_sectors: Total number of sectors of 1 or more zones to reset
+ */
+struct blk_zone_range {
+	__u64		sector;
+	__u64		nr_sectors;
+};
+
+#define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
+#endif /* HAVE_BLKZONED_H */
+
+static unsigned long read_chunk_size(const char * syspath)
+{
+	FILE *fp;
+	char pathbuf[1024];
+	char fbuf[1024];
+	unsigned long zoned = 0;
+
+	snprintf(pathbuf, sizeof(pathbuf), "%s/queue/chunk_sectors", syspath);
+	fp = fopen(pathbuf, "r");
+	if (fp) {
+		if (fread(fbuf, 1, sizeof(fbuf), fp) > 0) {
+			zoned = strtoul(fbuf, NULL, 10);
+		} else {
+			perror("read failure.");
+		}
+		fclose(fp);
+	} else {
+		perror(pathbuf);
+	}
+	return zoned;
+}
+
+#ifdef HAVE_LIBUDEV
+
+#define DT_BLOCK 0x62 /* pfm? */
+
+/*
+ * Mapping /dev/sdXn -> /sys/block/sdX to read the
+ *    zoned, and chunk_size files
+ *
+ *  fstat() -> S_ISBLK()
+ *    -> st_dev -> 12 bits major, 20 bits minor
+ *
+ *  int major_no = major(stat.st_dev);
+ *  int minor_no = minor(stat.st_dev);
+ *  int block_no = minor_no & ~0x0f
+ *
+ *  dev_t dev_no makedev(major_no, block_no);
+ *
+ *  udev_device_new_from_devnum(udev,
+ *
+ */
+static unsigned long get_zone_size(const char *dname)
+{
+	unsigned long chunk_size = 0;
+	struct stat st_buf;
+
+	if (stat(dname, &st_buf) == 0) {
+		if (S_ISBLK(st_buf.st_mode)) {
+			int major_no = major(st_buf.st_rdev);
+			int minor_no = minor(st_buf.st_rdev);
+			int block_no = minor_no & ~0x0f;
+			dev_t dev_no = makedev(major_no, block_no);
+			struct udev *udev;
+			struct udev_device *dev;
+			const char *syspath;
+
+			/* Create the udev object */
+			udev = udev_new();
+			if (!udev) {
+				printf("Can't create udev\n");
+				return 0;
+			}
+
+			dev = udev_device_new_from_devnum(udev, DT_BLOCK, dev_no);
+			if (dev) {
+				syspath = udev_device_get_syspath(dev);
+				chunk_size = read_chunk_size(syspath);
+
+				udev_device_unref(dev);
+			}
+			udev_unref(udev);
+		}
+	}
+	return chunk_size;
+}
+
+#else
+#warning "No libudev. Guessing sysfs mounted at /sys"
+
+static unsigned long get_zone_size(const char *dname)
+{
+	unsigned long zsize = 0;
+	char *zname;
+	char *part_no;
+	char sysfs[1024];
+	
+	zname = strrchr(dname, '/');
+	if (zname) {
+		if (*zname == '/')
+			zname++;
+		part_no = zname;
+		while (*part_no && !isdigit(*part_no))
+			part_no++;
+
+		snprintf(sysfs, sizeof(sysfs), "/sys/block/%*.*s",
+			part_no - zname, part_no - zname, zname);
+		zsize = read_chunk_size(sysfs);
+	}
+	return zsize;
+}
+#endif
+
+static void __attribute__((__noreturn__)) usage(FILE *out)
+{
+	fputs(USAGE_HEADER, out);
+	fprintf(out,
+	      _(" %s [options] <device>\n"), program_invocation_short_name);
+
+	fputs(USAGE_SEPARATOR, out);
+	fputs(_("Discard the content of sectors on a device.\n"), out);
+
+	fputs(USAGE_OPTIONS, out);
+	fputs(_(" -z, --zone <num>  lba of start of zone to act upon\n"
+		" -c, --count       number of zones to reset (default = 1)"),
+		out);
+	fputs(USAGE_SEPARATOR, out);
+	fputs(USAGE_HELP, out);
+	fputs(USAGE_VERSION, out);
+	fprintf(out, USAGE_MAN_TAIL("blkreset(8)"));
+	exit(out == stderr ? EXIT_FAILURE : EXIT_SUCCESS);
+}
+
+
+int main(int argc, char **argv)
+{
+	char *path;
+	int c, fd;
+	uint64_t blksize;
+	uint64_t blksectors;
+	struct stat sb;
+	struct blk_zone_range za;
+	uint64_t zsector = 0ul;
+	uint64_t zlen = 0;
+	uint64_t zcount = 1;
+	unsigned long zsize;
+	int rc = 0;
+
+	static const struct option longopts[] = {
+	    { "help",      0, 0, 'h' },
+	    { "version",   0, 0, 'V' },
+	    { "zone",      1, 0, 'z' },
+	    { "count",     1, 0, 'c' },
+	    { NULL,        0, 0, 0 }
+	};
+
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+	atexit(close_stdout);
+
+	while ((c = getopt_long(argc, argv, "hVz:c:v", longopts, NULL)) != -1) {
+		switch(c) {
+		case 'h':
+			usage(stdout);
+			break;
+		case 'V':
+			printf(UTIL_LINUX_VERSION);
+			return EXIT_SUCCESS;
+		case 'z':
+			zsector = strtou64_base_or_err(0, optarg,
+					_("failed to parse zone"));
+			break;
+		case 'c':
+			zcount = strtou64_base_or_err(0, optarg,
+					_("failed to parse number of zones"));
+			break;
+		default:
+			usage(stderr);
+			break;
+		}
+	}
+
+	if (optind == argc)
+		errx(EXIT_FAILURE, _("no device specified"));
+
+	path = argv[optind++];
+
+	if (optind != argc) {
+		warnx(_("unexpected number of arguments"));
+		usage(stderr);
+	}
+
+	zsize = get_zone_size(path);
+	if (zsize == 0)
+		err(EXIT_FAILURE, _("%s: Unable to determine zone size"), path);
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		err(EXIT_FAILURE, _("cannot open %s"), path);
+
+	if (fstat(fd, &sb) == -1)
+		err(EXIT_FAILURE, _("stat of %s failed"), path);
+	if (!S_ISBLK(sb.st_mode))
+		errx(EXIT_FAILURE, _("%s: not a block device"), path);
+
+	if (ioctl(fd, BLKGETSIZE64, &blksize))
+		err(EXIT_FAILURE, _("%s: BLKGETSIZE64 ioctl failed"), path);
+
+	blksectors = blksize << 9;
+
+	/* check offset alignment to the chunk size */
+	if (zsector & (zsize - 1))
+		errx(EXIT_FAILURE, _("%s: zone %" PRIu64 " is not aligned "
+			 "to zone size %" PRIu64), path, zsector, zsize);
+	if (zsector > blksectors)
+		errx(EXIT_FAILURE, _("%s: zone %" PRIu64 " is too large "
+			 "for device %" PRIu64), path, zsector, blksectors);
+
+	zlen = zcount * zsize;
+	if (zsector + zlen > blksectors)
+		zlen = blksectors - zsector;
+
+	za.sector = zsector;
+	za.nr_sectors = zlen;
+	rc = ioctl(fd, BLKRESETZONE, &za);
+	if (rc == -1)
+		err(EXIT_FAILURE, _("%s: BLKRESETZONE ioctl failed"), path);
+
+	close(fd);
+	return EXIT_SUCCESS;
+}
-- 
2.10.2
