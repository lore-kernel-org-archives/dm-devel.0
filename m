From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Re: your dm patch for strace
Date: Sun, 2 Oct 2016 17:59:06 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610021751280.29417@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1608221155410.17400@file01.intranet.prod.int.rdu2.redhat.com>
	<20160822170920.GA5147@altlinux.org>
	<alpine.LRH.2.02.1608231303510.7049@file01.intranet.prod.int.rdu2.redhat.com>
	<20160824.233543.198328104871315294.yamato@redhat.com>
	<alpine.LRH.2.02.1608250823130.24332@file01.intranet.prod.int.rdu2.redhat.com>
	<20160912171029.GA5263@altlinux.org>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160912171029.GA5263-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: dm-devel.ids



On Mon, 12 Sep 2016, Dmitry V. Levin wrote:

> > +			tprintf("}");
> > +			if (entering(tcp))
> > +				offset = offset + s->next;
> > +			else
> > +				offset = ioc->data_start + s->next;
> 
> This code trusts s->next; unfortunately, strace cannot trust syscall
> arguments, otherwise anything may happen, e.g.
> 
> $ cat ioctl_dm.c
> #include <sys/ioctl.h>
> #include <linux/dm-ioctl.h>
> int main(void)
> {
> 	struct {
> 		struct dm_ioctl ioc;
> 		struct dm_target_spec spec;
> 		int i;
> 	} s = {
> 		.spec = { 0 },
> 		.ioc = {
> 			.version[0] = DM_VERSION_MAJOR,
> 			.data_size = sizeof(s),
> 			.data_start = sizeof(s.ioc),
> 			.target_count = -1U
> 		}
> 	};
> 	return !ioctl(-1, DM_TABLE_LOAD, &s);
> }
> $ strace -veioctl ./ioctl_dm
> 
> btw, this parser lacks tests.  How one can easily verify that it works
> correctly?  For example how a test for strace ioctl parser may look like
> see tests/ioctl_* files.
> 
> 
> -- 
> ldv

Here I'm sending new patch. It fixes the possible loop with s->next and 
adds tests:

 Makefile.am         |    1 
 configure.ac        |    1 
 defs.h              |    1 
 dm.c                |  356 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.c             |    4 
 tests/Makefile.am   |    2 
 tests/ioctl_dm.c    |   78 +++++++++++
 tests/ioctl_dm.test |   12 +
 xlat/dm_flags.in    |   17 ++
 9 files changed, 472 insertions(+)

Index: strace/Makefile.am
===================================================================
--- strace.orig/Makefile.am
+++ strace/Makefile.am
@@ -97,6 +97,7 @@ strace_SOURCES =	\
 	desc.c		\
 	dirent.c	\
 	dirent64.c	\
+	dm.c		\
 	empty.h		\
 	epoll.c		\
 	evdev.c		\
Index: strace/configure.ac
===================================================================
--- strace.orig/configure.ac
+++ strace/configure.ac
@@ -354,6 +354,7 @@ AC_CHECK_HEADERS(m4_normalize([
 	elf.h
 	inttypes.h
 	linux/bsg.h
+	linux/dm-ioctl.h
 	linux/dqblk_xfs.h
 	linux/falloc.h
 	linux/fiemap.h
Index: strace/defs.h
===================================================================
--- strace.orig/defs.h
+++ strace/defs.h
@@ -640,6 +640,7 @@ extern void print_struct_statfs64(struct
 
 extern void print_ifindex(unsigned int);
 
+extern int dm_ioctl(struct tcb *, const unsigned int, long);
 extern int file_ioctl(struct tcb *, const unsigned int, long);
 extern int fs_x_ioctl(struct tcb *, const unsigned int, long);
 extern int loop_ioctl(struct tcb *, const unsigned int, long);
Index: strace/dm.c
===================================================================
--- /dev/null
+++ strace/dm.c
@@ -0,0 +1,356 @@
+#include "defs.h"
+
+#ifdef HAVE_LINUX_DM_IOCTL_H
+
+#include <sys/ioctl.h>
+#include <linux/dm-ioctl.h>
+
+static void
+dm_decode_device(const unsigned int code, const struct dm_ioctl *ioc)
+{
+	switch (code) {
+	case DM_REMOVE_ALL:
+	case DM_LIST_DEVICES:
+	case DM_LIST_VERSIONS:
+		break;
+	default:
+		if (ioc->dev)
+			tprintf(", dev=makedev(%u, %u)",
+				major(ioc->dev), minor(ioc->dev));
+		if (ioc->name[0]) {
+			tprints(", name=");
+			print_quoted_string(ioc->name, DM_NAME_LEN,
+					    QUOTE_0_TERMINATED);
+		}
+		if (ioc->uuid[0]) {
+			tprints(", uuid=");
+			print_quoted_string(ioc->uuid, DM_UUID_LEN,
+					    QUOTE_0_TERMINATED);
+		}
+		break;
+	}
+}
+
+static void
+dm_decode_values(struct tcb *tcp, const unsigned int code,
+		 const struct dm_ioctl *ioc)
+{
+	if (entering(tcp)) {
+		switch (code) {
+		case DM_TABLE_LOAD:
+			tprintf(", target_count=%"PRIu32"",
+				ioc->target_count);
+			break;
+		case DM_DEV_SUSPEND:
+			if (ioc->flags & DM_SUSPEND_FLAG)
+				break;
+		case DM_DEV_RENAME:
+		case DM_DEV_REMOVE:
+		case DM_DEV_WAIT:
+			tprintf(", event_nr=%"PRIu32"",
+				ioc->event_nr);
+			break;
+		}
+	} else if (!syserror(tcp)) {
+		switch (code) {
+		case DM_DEV_CREATE:
+		case DM_DEV_RENAME:
+		case DM_DEV_SUSPEND:
+		case DM_DEV_STATUS:
+		case DM_DEV_WAIT:
+		case DM_TABLE_LOAD:
+		case DM_TABLE_CLEAR:
+		case DM_TABLE_DEPS:
+		case DM_TABLE_STATUS:
+		case DM_TARGET_MSG:
+			tprintf(", target_count=%"PRIu32"",
+				ioc->target_count);
+			tprintf(", open_count=%"PRIu32"",
+				ioc->open_count);
+			tprintf(", event_nr=%"PRIu32"",
+				ioc->event_nr);
+			break;
+		}
+	}
+}
+
+#include "xlat/dm_flags.h"
+
+static void
+dm_decode_flags(const struct dm_ioctl *ioc)
+{
+	tprints(", flags=");
+	printflags(dm_flags, ioc->flags, "DM_???");
+}
+
+static void
+dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
+			 const char *extra, uint32_t extra_size)
+{
+	uint32_t i;
+	uint32_t offset = ioc->data_start;
+	for (i = 0; i < ioc->target_count; i++) {
+		if (offset + (uint32_t)sizeof(struct dm_target_spec) >= offset &&
+		    offset + (uint32_t)sizeof(struct dm_target_spec) < extra_size) {
+			uint32_t new_offset;
+			const struct dm_target_spec *s =
+				(const struct dm_target_spec *)(extra + offset);
+			tprintf(", {sector_start=%"PRIu64", length=%"PRIu64"",
+				(uint64_t)s->sector_start, (uint64_t)s->length);
+			if (!entering(tcp))
+				tprintf(", status=%"PRId32"", s->status);
+			tprints(", target_type=");
+			print_quoted_string(s->target_type, DM_MAX_TYPE_NAME,
+					    QUOTE_0_TERMINATED);
+			tprints(", string=");
+			print_quoted_string((const char *)(s + 1), extra_size -
+					    (offset +
+					    sizeof(struct dm_target_spec)),
+					    QUOTE_0_TERMINATED);
+			tprintf("}");
+			if (entering(tcp))
+				new_offset = offset + s->next;
+			else
+				new_offset = ioc->data_start + s->next;
+			if (new_offset <= offset + (uint32_t)sizeof(struct dm_target_spec))
+				goto misplaced;
+			offset = new_offset;
+		} else {
+misplaced:
+			tprints(", misplaced struct dm_target_spec");
+			break;
+		}
+	}
+}
+
+static void
+dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra,
+			 uint32_t extra_size)
+{
+	uint32_t offset = ioc->data_start;
+	if (offset + (uint32_t)offsetof(struct dm_target_deps, dev) >= offset &&
+	    offset + (uint32_t)offsetof(struct dm_target_deps, dev) <= extra_size) {
+		uint32_t i;
+		uint32_t space = (extra_size - (offset +
+			offsetof(struct dm_target_deps, dev))) / sizeof(__u64);
+		const struct dm_target_deps *s =
+			(const struct dm_target_deps *)(extra + offset);
+		if (s->count > space)
+			goto misplaced;
+		tprints(", deps={");
+		for (i = 0; i < s->count; i++) {
+			tprintf("%smakedev(%u, %u)", i ? ", " : "",
+				major(s->dev[i]), minor(s->dev[i]));
+		}
+		tprints("}");
+	} else {
+ misplaced:
+		tprints(", misplaced struct dm_target_deps");
+	}
+}
+
+static void
+dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra,
+		       uint32_t extra_size)
+{
+	uint32_t offset = ioc->data_start;
+	while (1) {
+		if (offset + (uint32_t)offsetof(struct dm_name_list, name) >= offset &&
+		    offset + (uint32_t)offsetof(struct dm_name_list, name) < extra_size) {
+			const struct dm_name_list *s =
+				(const struct dm_name_list *)(extra + offset);
+			if (!s->dev)
+				break;
+			tprintf(", {dev=makedev(%u, %u), name=", major(s->dev), minor(s->dev));
+			print_quoted_string(s->name, extra_size - (offset +
+					    offsetof(struct dm_name_list,
+					    name)), QUOTE_0_TERMINATED);
+			tprints("}");
+			if (!s->next)
+				break;
+			if (offset + s->next <= offset + (uint32_t)offsetof(struct dm_name_list, name))
+				goto misplaced;
+			offset = offset + s->next;
+		} else {
+ misplaced:
+			tprints(", misplaced struct dm_name_list");
+			break;
+		}
+	}
+}
+
+static void
+dm_decode_dm_target_versions(const struct dm_ioctl *ioc, const char *extra,
+			     uint32_t extra_size)
+{
+	uint32_t offset = ioc->data_start;
+	while (1) {
+		if (offset + (uint32_t)offsetof(struct dm_target_versions, name) >=
+		    offset &&
+		    offset + (uint32_t)offsetof(struct dm_target_versions, name) <
+		    extra_size) {
+			const struct dm_target_versions *s =
+			    (const struct dm_target_versions *)(extra + offset);
+			tprints(", {name=");
+			print_quoted_string(s->name, extra_size - (offset +
+					    offsetof(struct dm_target_versions,
+					    name)), QUOTE_0_TERMINATED);
+			tprintf(", version=%"PRIu32".%"PRIu32".%"PRIu32"}",
+				s->version[0], s->version[1], s->version[2]);
+			if (!s->next)
+				break;
+			if (offset + s->next <= offset + (uint32_t)offsetof(struct dm_target_versions, name))
+				goto misplaced;
+			offset = offset + s->next;
+		} else {
+ misplaced:
+			tprints(", misplaced struct dm_target_versions");
+			break;
+		}
+	}
+}
+
+static void
+dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra,
+			uint32_t extra_size)
+{
+	uint32_t offset = ioc->data_start;
+	if (offset + (uint32_t)offsetof(struct dm_target_msg, message) >= offset &&
+	    offset + (uint32_t)offsetof(struct dm_target_msg, message) < extra_size) {
+		const struct dm_target_msg *s =
+			(const struct dm_target_msg *)(extra + offset);
+		tprintf(", {sector=%"PRIu64", message=", (uint64_t)s->sector);
+		print_quoted_string(s->message, extra_size -
+				    offsetof(struct dm_target_msg, message),
+				    QUOTE_0_TERMINATED);
+		tprints("}");
+	} else {
+		tprints(", misplaced struct dm_target_msg");
+	}
+}
+
+static void
+dm_decode_string(const struct dm_ioctl *ioc, const char *extra,
+		 uint32_t extra_size)
+{
+	uint32_t offset = ioc->data_start;
+	if (offset < extra_size) {
+		tprints(", string=");
+		print_quoted_string(extra + offset, extra_size - offset,
+				    QUOTE_0_TERMINATED);
+	} else {
+		tprints(", misplaced string");
+	}
+}
+
+static int
+dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
+{
+	struct dm_ioctl ioc;
+	char *extra = NULL;
+	uint32_t extra_size = 0;
+
+	if (umoven(tcp, arg, sizeof(ioc) - sizeof(ioc.data), (char *)&ioc) < 0)
+		return 0;
+	tprintf(", {version=%d.%d.%d", ioc.version[0], ioc.version[1],
+		ioc.version[2]);
+
+	/*
+	 * if we use a different version of ABI, do not attempt to decode
+	 * ioctl fields
+	 */
+	if (ioc.version[0] != DM_VERSION_MAJOR)
+		goto skip;
+
+	if (ioc.data_size > sizeof(ioc)) {
+		extra = malloc(ioc.data_size);
+		if (extra) {
+			extra_size = ioc.data_size;
+			if (umoven(tcp, arg, extra_size, extra) < 0) {
+				free(extra);
+				extra = NULL;
+				extra_size = 0;
+			}
+		}
+	}
+	dm_decode_device(code, &ioc);
+	dm_decode_values(tcp, code, &ioc);
+	dm_decode_flags(&ioc);
+	if (!abbrev(tcp)) switch (code) {
+		case DM_DEV_WAIT:
+		case DM_TABLE_STATUS:
+			if (entering(tcp) || syserror(tcp))
+				break;
+			dm_decode_dm_target_spec(tcp, &ioc, extra, extra_size);
+			break;
+		case DM_TABLE_LOAD:
+			if (!entering(tcp))
+				break;
+			dm_decode_dm_target_spec(tcp, &ioc, extra, extra_size);
+			break;
+		case DM_TABLE_DEPS:
+			if (entering(tcp) || syserror(tcp))
+				break;
+			dm_decode_dm_target_deps(&ioc, extra, extra_size);
+			break;
+		case DM_LIST_DEVICES:
+			if (entering(tcp) || syserror(tcp))
+				break;
+			dm_decode_dm_name_list(&ioc, extra, extra_size);
+			break;
+		case DM_LIST_VERSIONS:
+			if (entering(tcp) || syserror(tcp))
+				break;
+			dm_decode_dm_target_versions(&ioc, extra, extra_size);
+			break;
+		case DM_TARGET_MSG:
+			if (entering(tcp)) {
+				dm_decode_dm_target_msg(&ioc, extra,
+							extra_size);
+			} else if (!syserror(tcp) &&
+				   ioc.flags & DM_DATA_OUT_FLAG) {
+				dm_decode_string(&ioc, extra, extra_size);
+			}
+			break;
+		case DM_DEV_RENAME:
+		case DM_DEV_SET_GEOMETRY:
+			if (!entering(tcp))
+				break;
+			dm_decode_string(&ioc, extra, extra_size);
+			break;
+	}
+
+ skip:
+	tprints("}");
+	if (extra)
+		free(extra);
+	return 1;
+}
+
+int
+dm_ioctl(struct tcb *tcp, const unsigned int code, long arg)
+{
+	switch (code) {
+	case DM_VERSION:
+	case DM_REMOVE_ALL:
+	case DM_LIST_DEVICES:
+	case DM_DEV_CREATE:
+	case DM_DEV_REMOVE:
+	case DM_DEV_RENAME:
+	case DM_DEV_SUSPEND:
+	case DM_DEV_STATUS:
+	case DM_DEV_WAIT:
+	case DM_TABLE_LOAD:
+	case DM_TABLE_CLEAR:
+	case DM_TABLE_DEPS:
+	case DM_TABLE_STATUS:
+	case DM_LIST_VERSIONS:
+	case DM_TARGET_MSG:
+	case DM_DEV_SET_GEOMETRY:
+		return dm_known_ioctl(tcp, code, arg);
+	default:
+		return 0;
+	}
+}
+
+#endif
Index: strace/ioctl.c
===================================================================
--- strace.orig/ioctl.c
+++ strace/ioctl.c
@@ -282,6 +282,10 @@ ioctl_decode(struct tcb *tcp)
 	case 0x94:
 		return btrfs_ioctl(tcp, code, arg);
 #endif
+#ifdef HAVE_LINUX_DM_IOCTL_H
+	case 0xfd:
+		return dm_ioctl(tcp, code, arg);
+#endif
 	default:
 		break;
 	}
Index: strace/tests/Makefile.am
===================================================================
--- strace.orig/tests/Makefile.am
+++ strace/tests/Makefile.am
@@ -161,6 +161,7 @@ check_PROGRAMS = \
 	inet-cmsg \
 	ioctl \
 	ioctl_block \
+	ioctl_dm \
 	ioctl_evdev \
 	ioctl_evdev-v \
 	ioctl_mtd \
@@ -503,6 +504,7 @@ DECODER_TESTS = \
 	inet-cmsg.test \
 	ioctl.test \
 	ioctl_block.test \
+	ioctl_dm.test \
 	ioctl_evdev.test \
 	ioctl_evdev-v.test \
 	ioctl_mtd.test \
Index: strace/tests/ioctl_dm.c
===================================================================
--- /dev/null
+++ strace/tests/ioctl_dm.c
@@ -0,0 +1,78 @@
+#include "tests.h"
+#include <stdio.h>
+#include <stddef.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <linux/dm-ioctl.h>
+
+static struct s {
+	struct dm_ioctl ioc;
+	union {
+		struct {
+			struct dm_target_spec target_spec;
+			char target_params[256];
+		} ts;
+		struct {
+			struct dm_target_msg target_msg;
+			char target_string[256];
+		} tm;
+		char string[256];
+	} u;
+} s;
+
+static void init_s(void)
+{
+	memset(&s, 0, sizeof s);
+	s.ioc.version[0] = DM_VERSION_MAJOR;
+	s.ioc.version[1] = 1;
+	s.ioc.version[2] = 2;
+	s.ioc.data_size = sizeof(s);
+	s.ioc.data_start = offsetof(struct s, u);
+	s.ioc.dev = 0x1234;
+	strcpy(s.ioc.name, "nnn");
+	strcpy(s.ioc.uuid, "uuu");
+}
+
+int
+main(void)
+{
+	init_s();
+	s.ioc.data_size = sizeof(s.ioc);
+	s.ioc.data_start = 0;
+	ioctl(-1, DM_VERSION, &s);
+	printf("ioctl(-1, DM_VERSION, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+
+	init_s();
+	s.ioc.target_count = 1;
+	s.u.ts.target_spec.sector_start = 0x10;
+	s.u.ts.target_spec.length = 0x20;
+	s.u.ts.target_spec.next = sizeof(s.u.ts.target_spec) + sizeof(s.u.ts.target_params);
+	strcpy(s.u.ts.target_spec.target_type, "tgt");
+	strcpy(s.u.ts.target_params, "tparams");
+	ioctl(-1, DM_TABLE_LOAD, &s);
+	printf("ioctl(-1, DM_TABLE_LOAD, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", target_count=1, flags=0, {sector_start=16, length=32, target_type=\"tgt\", string=\"tparams\"}}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+
+	init_s();
+	s.u.tm.target_msg.sector = 0x1234;
+	strcpy(s.u.tm.target_msg.message, "tmsg");
+	ioctl(-1, DM_TARGET_MSG, &s);
+	printf("ioctl(-1, DM_TARGET_MSG, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+
+	init_s();
+	strcpy(s.u.string, "10 20 30 40");
+	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
+	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, string=\"10 20 30 40\"}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+
+	init_s();
+	strcpy(s.u.string, "new-name");
+	ioctl(-1, DM_DEV_RENAME, &s);
+	printf("ioctl(-1, DM_DEV_RENAME, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+
+	init_s();
+	s.ioc.target_count = -1U;
+	ioctl(-1, DM_TABLE_LOAD, &s);
+	printf("ioctl(-1, DM_TABLE_LOAD, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", target_count=4294967295, flags=0, {sector_start=0, length=0, target_type=\"\", string=\"\"}, misplaced struct dm_target_spec}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+
+	puts("+++ exited with 0 +++");
+	return 0;
+}
Index: strace/tests/ioctl_dm.test
===================================================================
--- /dev/null
+++ strace/tests/ioctl_dm.test
@@ -0,0 +1,12 @@
+#!/bin/sh
+
+# Check decoding of DM* ioctls.
+
+. "${srcdir=.}/init.sh"
+
+run_prog > /dev/null
+run_strace -a16 -veioctl $args > "$EXP"
+check_prog grep
+grep -v '^ioctl([012],' < "$LOG" > "$OUT"
+match_diff "$OUT" "$EXP"
+rm -f "$EXP" "$OUT"
Index: strace/xlat/dm_flags.in
===================================================================
--- /dev/null
+++ strace/xlat/dm_flags.in
@@ -0,0 +1,17 @@
+DM_READONLY_FLAG
+DM_SUSPEND_FLAG
+DM_PERSISTENT_DEV_FLAG
+DM_STATUS_TABLE_FLAG
+DM_ACTIVE_PRESENT_FLAG
+DM_INACTIVE_PRESENT_FLAG
+DM_BUFFER_FULL_FLAG
+DM_SKIP_BDGET_FLAG
+DM_SKIP_LOCKFS_FLAG
+DM_NOFLUSH_FLAG
+DM_QUERY_INACTIVE_TABLE_FLAG
+DM_UEVENT_GENERATED_FLAG
+DM_UUID_FLAG
+DM_SECURE_DATA_FLAG
+DM_DATA_OUT_FLAG
+DM_DEFERRED_REMOVE
+DM_INTERNAL_SUSPEND_FLAG

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
