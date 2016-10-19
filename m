From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] device mapper ioctl
Date: Wed, 19 Oct 2016 16:31:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610191626360.628@file01.intranet.prod.int.rdu2.redhat.com>
References: <20161005.192828.566127461630656590.yamato@redhat.com>
	<20161011223803.GA30714@obsidian>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161011223803.GA30714@obsidian>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: dm-devel.ids



On Wed, 12 Oct 2016, Eugene Syromyatnikov wrote:

> Hello.
> 
> Aside from additional checks themselves, this patchset also contains two
> notable changes:
>  * Fix for the previous patchset - misplaced comma printing ("dm: Fix comma
>    printing for the case when dm_target_msg structure is inaccessible").
>  * Update of printstr_ex call, which enables proper handling of
>    QUOTE_0_TERMINATED user style (it prints cropped string without ellipsis
>    otherwise).

Hi

Here I'm sending the device mapper ioctl patch with these changes merged.

In this piece of code:
+       dm_arg_open3->target3.next = 0xdeadbeef;
+       dm_arg_open3->param3[0] = '\1';
+       dm_arg_open3->param3[1] = '\2';
+       dm_arg_open3->param1[2] = '\0';
there should be "dm_arg_open3->param3[2]" instead of 
"dm_arg_open3->param1[2]". "dm_arg_open3->param1[2]" produces a warning 
about access beyond the end of array.


Mikulas


 Makefile.am           |    1 
 configure.ac          |    1 
 defs.h                |    1 
 dm.c                  |  552 ++++++++++++++++++++++++++++++++++++++
 ioctl.c               |    4 
 tests/.gitignore      |    2 
 tests/Makefile.am     |    4 
 tests/ioctl_dm-v.c    |    2 
 tests/ioctl_dm-v.test |   12 
 tests/ioctl_dm.c      |  726 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ioctl_dm.test   |   12 
 util.c                |   18 +
 xlat/dm_flags.in      |   19 +
 13 files changed, 1351 insertions(+), 3 deletions(-)

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
@@ -636,6 +636,7 @@ extern void print_struct_statfs64(struct
 
 extern void print_ifindex(unsigned int);
 
+extern int dm_ioctl(struct tcb *, const unsigned int, long);
 extern int file_ioctl(struct tcb *, const unsigned int, long);
 extern int fs_x_ioctl(struct tcb *, const unsigned int, long);
 extern int loop_ioctl(struct tcb *, const unsigned int, long);
Index: strace/dm.c
===================================================================
--- /dev/null
+++ strace/dm.c
@@ -0,0 +1,552 @@
+#include "defs.h"
+
+#ifdef HAVE_LINUX_DM_IOCTL_H
+
+# include <inttypes.h>
+# include <linux/dm-ioctl.h>
+# include <sys/ioctl.h>
+
+# if DM_VERSION_MAJOR == 4
+
+/* Definitions for command which have been added later */
+
+#  ifndef DM_LIST_VERSIONS
+#   define DM_LIST_VERSIONS    _IOWR(DM_IOCTL, 0xd, struct dm_ioctl)
+#  endif
+#  ifndef DM_TARGET_MSG
+#   define DM_TARGET_MSG       _IOWR(DM_IOCTL, 0xe, struct dm_ioctl)
+#  endif
+#  ifndef DM_DEV_SET_GEOMETRY
+#   define DM_DEV_SET_GEOMETRY _IOWR(DM_IOCTL, 0xf, struct dm_ioctl)
+#  endif
+
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
+			tprintf(", target_count=%" PRIu32,
+				ioc->target_count);
+			break;
+		case DM_DEV_SUSPEND:
+			if (ioc->flags & DM_SUSPEND_FLAG)
+				break;
+			/* Fall through */
+		case DM_DEV_RENAME:
+		case DM_DEV_REMOVE:
+		case DM_DEV_WAIT:
+			tprintf(", event_nr=%" PRIu32,
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
+			tprintf(", target_count=%" PRIu32,
+				ioc->target_count);
+			tprintf(", open_count=%" PRIu32,
+				ioc->open_count);
+			tprintf(", event_nr=%" PRIu32,
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
+dm_decode_dm_target_spec(struct tcb *tcp, unsigned long addr,
+			 const struct dm_ioctl *ioc)
+{
+	static const uint32_t target_spec_size =
+		sizeof(struct dm_target_spec);
+	uint32_t i;
+	uint32_t offset = ioc->data_start;
+
+	if (abbrev(tcp)) {
+		if (ioc->target_count)
+			tprints(", ...");
+
+		return;
+	}
+
+	for (i = 0; i < ioc->target_count; i++) {
+		struct dm_target_spec s;
+		uint32_t new_offset;
+
+		if ((offset + target_spec_size) <= offset ||
+		    (offset + target_spec_size) > ioc->data_size)
+			goto misplaced;
+
+		tprints(", ");
+
+		if (i >= max_strlen) {
+			tprints("...");
+			break;
+		}
+
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			break;
+
+		tprintf("{sector_start=%" PRI__u64 ", length=%" PRI__u64,
+			s.sector_start, s.length);
+
+		if (!entering(tcp))
+			tprintf(", status=%" PRId32, s.status);
+
+		tprints(", target_type=");
+		print_quoted_string(s.target_type, DM_MAX_TYPE_NAME,
+				    QUOTE_0_TERMINATED);
+
+		tprints(", string=");
+		printstr_ex(tcp, addr + offset + target_spec_size,
+			     ioc->data_size - (offset + target_spec_size),
+			     QUOTE_0_TERMINATED);
+		tprintf("}");
+
+		if (entering(tcp))
+			new_offset = offset + s.next;
+		else
+			new_offset = ioc->data_start + s.next;
+
+		if (new_offset <= offset + target_spec_size)
+			goto misplaced;
+
+		offset = new_offset;
+	}
+
+	return;
+
+misplaced:
+	tprints(", /* misplaced struct dm_target_spec */ ...");
+}
+
+bool
+dm_print_dev(struct tcb *tcp, void *dev_ptr, size_t dev_size, void *dummy)
+{
+	uint64_t *dev = (uint64_t *) dev_ptr;
+
+	tprintf("makedev(%u, %u)", major(*dev), minor(*dev));
+
+	return 1;
+}
+
+static void
+dm_decode_dm_target_deps(struct tcb *tcp, unsigned long addr,
+			 const struct dm_ioctl *ioc)
+{
+	static const uint32_t target_deps_dev_offs =
+		offsetof(struct dm_target_deps, dev);
+	uint64_t dev_buf;
+	struct dm_target_deps s;
+	uint32_t offset = ioc->data_start;
+	uint32_t space;
+
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
+
+	tprints(", ");
+
+	if (offset + target_deps_dev_offs <= offset ||
+	    offset + target_deps_dev_offs > ioc->data_size)
+		goto misplaced;
+
+	if (umove_or_printaddr(tcp, addr + offset, &s))
+		return;
+
+	space = (ioc->data_size - offset - target_deps_dev_offs) / sizeof(__u64);
+
+	if (s.count > space)
+		goto misplaced;
+
+	tprintf("{count=%" PRIu32 ", deps=", s.count);
+
+	print_array(tcp, addr + offset + target_deps_dev_offs, s.count,
+		    &dev_buf, sizeof(dev_buf), umoven_or_printaddr,
+		    dm_print_dev, NULL);
+
+	tprints("}");
+
+	return;
+
+misplaced:
+	tprints("/* misplaced struct dm_target_deps */ ...");
+}
+
+static void
+dm_decode_dm_name_list(struct tcb *tcp, unsigned long addr,
+		       const struct dm_ioctl *ioc)
+{
+	static const uint32_t name_list_name_offs =
+		offsetof(struct dm_name_list, name);
+	struct dm_name_list s;
+	uint32_t offset = ioc->data_start;
+	uint32_t count;
+
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
+
+	for (count = 0;; count++) {
+		if (offset + name_list_name_offs <= offset ||
+		    offset + name_list_name_offs > ioc->data_size)
+			goto misplaced;
+
+		tprints(", ");
+
+		if (count >= max_strlen) {
+			tprints("...");
+			break;
+		}
+
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			break;
+		if (!count && !s.dev) {
+			tprints("/* no devices present */");
+			break;
+		}
+
+		tprintf("{dev=makedev(%u, %u), name=", major(s.dev),
+			minor(s.dev));
+		printstr_ex(tcp, addr + offset + name_list_name_offs,
+			    ioc->data_size - (offset + name_list_name_offs),
+			    QUOTE_0_TERMINATED);
+		tprints("}");
+
+		if (!s.next)
+			break;
+		if (offset + s.next <= offset + name_list_name_offs)
+			goto misplaced;
+		offset = offset + s.next;
+	}
+
+	return;
+
+misplaced:
+	tprints(", /* misplaced struct dm_name_list */ ...");
+}
+
+static void
+dm_decode_dm_target_versions(struct tcb *tcp, unsigned long addr,
+			     const struct dm_ioctl *ioc)
+{
+	static const uint32_t target_vers_name_offs =
+		offsetof(struct dm_target_versions, name);
+	struct dm_target_versions s;
+	uint32_t offset = ioc->data_start;
+	uint32_t count;
+
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
+
+	for (count = 0;; count++) {
+		if (offset + target_vers_name_offs <= offset ||
+		    offset + target_vers_name_offs > ioc->data_size)
+			goto misplaced;
+
+		tprints(", ");
+
+		if (count >= max_strlen) {
+			tprints("...");
+			break;
+		}
+
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			break;
+
+		tprints("{name=");
+		printstr_ex(tcp, addr + offset + target_vers_name_offs,
+			    ioc->data_size - (offset + target_vers_name_offs),
+			    QUOTE_0_TERMINATED);
+		tprintf(", version=%" PRIu32 ".%" PRIu32 ".%" PRIu32 "}",
+			s.version[0], s.version[1], s.version[2]);
+
+		if (!s.next)
+			break;
+		if (offset + s.next <= offset + target_vers_name_offs)
+			goto misplaced;
+		offset = offset + s.next;
+	}
+
+	return;
+
+misplaced:
+	tprints(", /* misplaced struct dm_target_versions */ ...");
+}
+
+static void
+dm_decode_dm_target_msg(struct tcb *tcp, unsigned long addr,
+			const struct dm_ioctl *ioc)
+{
+	static const uint32_t target_msg_message_offs =
+		offsetof(struct dm_target_msg, message);
+	uint32_t offset = ioc->data_start;
+
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
+
+	if (offset + target_msg_message_offs > offset &&
+	    offset + target_msg_message_offs <= ioc->data_size) {
+		struct dm_target_msg s;
+
+		tprints(", ");
+
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			return;
+
+		tprintf("{sector=%" PRI__u64 ", message=", s.sector);
+		printstr_ex(tcp, addr + offset + target_msg_message_offs,
+			    ioc->data_size - offset - target_msg_message_offs,
+			    QUOTE_0_TERMINATED);
+		tprints("}");
+	} else {
+		tprints(", /* misplaced struct dm_target_msg */");
+	}
+}
+
+static void
+dm_decode_string(struct tcb *tcp, unsigned long addr,
+		 const struct dm_ioctl *ioc)
+{
+	uint32_t offset = ioc->data_start;
+
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
+
+	if (offset < ioc->data_size) {
+		tprints(", string=");
+		printstr_ex(tcp, addr + offset, ioc->data_size - offset,
+			    QUOTE_0_TERMINATED);
+	} else {
+		tprints(", /* misplaced string */");
+	}
+}
+
+static inline bool
+dm_ioctl_has_params(const unsigned int code)
+{
+	switch (code) {
+	case DM_VERSION:
+	case DM_REMOVE_ALL:
+	case DM_DEV_CREATE:
+	case DM_DEV_REMOVE:
+	case DM_DEV_SUSPEND:
+	case DM_DEV_STATUS:
+	case DM_TABLE_CLEAR:
+		return false;
+	}
+
+	return true;
+}
+
+static int
+dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
+{
+	struct dm_ioctl *ioc = NULL;
+	struct dm_ioctl *entering_ioc = NULL;
+	bool ioc_changed = false;
+
+	ioc = malloc(sizeof(* ioc));
+	if (!ioc)
+		return 0;
+
+	if ((umoven(tcp, arg, sizeof(*ioc) - sizeof(ioc->data), ioc) < 0) ||
+	    (ioc->data_size < offsetof(struct dm_ioctl, data_size))) {
+		free(ioc);
+		return 0;
+	}
+	if (entering(tcp))
+		set_tcb_priv_data(tcp, ioc, free);
+	else {
+		entering_ioc = get_tcb_priv_data(tcp);
+
+		/*
+		 * retrieve_status, __dev_status called only in case of success,
+		 * so it looks like there's no need to check open_count,
+		 * event_nr, target_count, dev fields for change (they are
+		 * printed only in case of absence of errors).
+		 */
+		if (!entering_ioc ||
+		    (ioc->version[0] != entering_ioc->version[0]) ||
+		    (ioc->version[1] != entering_ioc->version[1]) ||
+		    (ioc->version[2] != entering_ioc->version[2]) ||
+		    (ioc->data_size != entering_ioc->data_size) ||
+		    (ioc->data_start != entering_ioc->data_start) ||
+		    (ioc->flags != entering_ioc->flags))
+			ioc_changed = true;
+	}
+
+	if (exiting(tcp) && syserror(tcp) && !ioc_changed) {
+		free(ioc);
+		return 1;
+	}
+
+	/*
+	 * device mapper code uses %d in some places and %u in another, but
+	 * fields themselves are declared as __u32.
+	 */
+	tprintf("%s{version=%" PRIu32 ".%" PRIu32 ".%" PRIu32,
+		entering(tcp) ? ", " : " => ",
+		ioc->version[0], ioc->version[1], ioc->version[2]);
+	/*
+	 * if we use a different version of ABI, do not attempt to decode
+	 * ioctl fields
+	 */
+	if (ioc->version[0] != DM_VERSION_MAJOR) {
+		tprints(", /* Unsupported device mapper ABI version */ ...");
+		goto skip;
+	}
+
+	tprintf(", data_size=%" PRIu32, ioc->data_size);
+
+	if (dm_ioctl_has_params(code))
+		tprintf(", data_start=%" PRIu32, ioc->data_start);
+
+	if (ioc->data_size < (sizeof(*ioc) - sizeof(ioc->data))) {
+		tprints(", /* Incorrect data_size */ ...");
+		goto skip;
+	}
+
+	dm_decode_device(code, ioc);
+	dm_decode_values(tcp, code, ioc);
+	dm_decode_flags(ioc);
+
+	switch (code) {
+	case DM_DEV_WAIT:
+	case DM_TABLE_STATUS:
+		if (entering(tcp) || syserror(tcp))
+			break;
+		dm_decode_dm_target_spec(tcp, arg, ioc);
+		break;
+	case DM_TABLE_LOAD:
+		if (!entering(tcp))
+			break;
+		dm_decode_dm_target_spec(tcp, arg, ioc);
+		break;
+	case DM_TABLE_DEPS:
+		if (entering(tcp) || syserror(tcp))
+			break;
+		dm_decode_dm_target_deps(tcp, arg, ioc);
+		break;
+	case DM_LIST_DEVICES:
+		if (entering(tcp) || syserror(tcp))
+			break;
+		dm_decode_dm_name_list(tcp, arg, ioc);
+		break;
+	case DM_LIST_VERSIONS:
+		if (entering(tcp) || syserror(tcp))
+			break;
+		dm_decode_dm_target_versions(tcp, arg, ioc);
+		break;
+	case DM_TARGET_MSG:
+		if (entering(tcp))
+			dm_decode_dm_target_msg(tcp, arg, ioc);
+		else if (!syserror(tcp) && ioc->flags & DM_DATA_OUT_FLAG)
+			dm_decode_string(tcp, arg, ioc);
+		break;
+	case DM_DEV_RENAME:
+	case DM_DEV_SET_GEOMETRY:
+		if (!entering(tcp))
+			break;
+		dm_decode_string(tcp, arg, ioc);
+		break;
+	}
+
+ skip:
+	tprints("}");
+	if (exiting(tcp))
+		free(ioc);
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
+# else /* !(DM_VERSION_MAJOR == 4) */
+
+int
+dm_ioctl(struct tcb *tcp, const unsigned int code, long arg)
+{
+	return 0;
+}
+
+# endif /* DM_VERSION_MAJOR == 4 */
+#endif /* HAVE_LINUX_DM_IOCTL_H */
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
@@ -162,6 +162,8 @@ check_PROGRAMS = \
 	inet-cmsg \
 	ioctl \
 	ioctl_block \
+	ioctl_dm \
+	ioctl_dm-v \
 	ioctl_evdev \
 	ioctl_evdev-v \
 	ioctl_mtd \
@@ -507,6 +509,8 @@ DECODER_TESTS = \
 	inet-cmsg.test \
 	ioctl.test \
 	ioctl_block.test \
+	ioctl_dm.test \
+	ioctl_dm-v.test \
 	ioctl_evdev.test \
 	ioctl_evdev-v.test \
 	ioctl_mtd.test \
Index: strace/tests/ioctl_dm.c
===================================================================
--- /dev/null
+++ strace/tests/ioctl_dm.c
@@ -0,0 +1,726 @@
+#include "tests.h"
+
+#ifdef HAVE_LINUX_DM_IOCTL_H
+
+# include <errno.h>
+# include <inttypes.h>
+# include <stdbool.h>
+# include <stdio.h>
+# include <stddef.h>
+# include <string.h>
+# include <sys/ioctl.h>
+# include <linux/dm-ioctl.h>
+
+# ifndef VERBOSE
+#  define VERBOSE 0
+# endif
+
+# define STR32 "AbCdEfGhIjKlMnOpQrStUvWxYz012345"
+
+static const char str129[] = STR32 STR32 STR32 STR32 "6";
+
+static const __u64 dts_sector_base = (__u64) 0xdeadca75facef157ULL;
+static const __u64 dts_sector_step = (__u64) 0x100000001ULL;
+static const __u64 dts_length_base = (__u64) 0xbadc0dedda7a1057ULL;
+static const __u64 dts_length_step = (__u64) 0x700000007ULL;
+static const __s32 dts_status_base = (__s32) 3141592653U;
+static const __s32 dts_status_step = 0x1234;
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
+struct dm_table_open_test {
+	struct dm_ioctl ioc;
+	struct dm_target_spec target0;
+	char param0[1];
+	struct dm_target_spec target1;
+	char param1[2];
+	struct dm_target_spec target2;
+	char param2[3];
+	struct dm_target_spec target3;
+	char param3[4];
+	struct dm_target_spec target4;
+	char param4[5];
+	struct dm_target_spec target5;
+	char param5[6];
+	struct dm_target_spec target6;
+	char param6[7];
+	struct dm_target_spec target7;
+	char param7[8];
+	struct dm_target_spec target8;
+	char param8[9];
+	struct dm_target_spec target9;
+	char param9[10];
+};
+
+struct dm_target_msg_test {
+	struct dm_ioctl ioc;
+	struct dm_target_msg msg;
+};
+
+struct args {
+	unsigned int arg;
+	const char *str;
+	bool has_params;
+	bool has_event_nr;
+};
+
+
+static void
+init_s(struct dm_ioctl *s, size_t size, size_t offs)
+{
+	memset(s, 0, size);
+	s->version[0] = DM_VERSION_MAJOR;
+	s->version[1] = 1;
+	s->version[2] = 2;
+	s->data_size = size;
+	s->data_start = offs;
+	s->dev = 0x1234;
+	strcpy(s->name, "nnn");
+	strcpy(s->uuid, "uuu");
+}
+
+static void
+init_dm_target_spec(struct dm_target_spec *ptr, uint32_t id)
+{
+	ptr->sector_start = dts_sector_base + dts_sector_step * id;
+	ptr->length       = dts_length_base + dts_length_step * id;
+	ptr->status       = dts_status_base + dts_status_step * id;
+
+	strncpy(ptr->target_type, str129 +
+		id % (sizeof(str129) - sizeof(ptr->target_type)),
+		id % (sizeof(ptr->target_type) + 1));
+	if (id % (sizeof(ptr->target_type) + 1) < sizeof(ptr->target_type))
+		ptr->target_type[id % (sizeof(ptr->target_type) + 1)] = '\0';
+}
+
+# if VERBOSE
+static void
+print_dm_target_spec(struct dm_target_spec *ptr, uint32_t id)
+{
+	printf("{sector_start=%" PRI__u64 ", length=%" PRI__u64 ", "
+	       "target_type=\"%.*s\", string=",
+	       dts_sector_base + dts_sector_step * id,
+	       dts_length_base + dts_length_step * id,
+	       (int) (id % (sizeof(ptr->target_type) + 1)),
+	       str129 + id % (sizeof(str129) - sizeof(ptr->target_type)));
+}
+# endif /* VERBOSE */
+
+# define ARG_STR(_arg) (_arg), #_arg
+
+int
+main(void)
+{
+	/* We can't check these properly for now */
+	static struct args dummy_check_cmds_nodev[] = {
+		{ ARG_STR(DM_REMOVE_ALL),    false },
+		{ ARG_STR(DM_LIST_DEVICES),  true  },
+		{ ARG_STR(DM_LIST_VERSIONS), true  },
+	};
+	static struct args dummy_check_cmds[] = {
+		{ ARG_STR(DM_DEV_CREATE),    false },
+		{ ARG_STR(DM_DEV_REMOVE),    false, true },
+		{ ARG_STR(DM_DEV_STATUS),    false },
+		{ ARG_STR(DM_DEV_WAIT),      true,  true },
+		{ ARG_STR(DM_TABLE_CLEAR),   false },
+		{ ARG_STR(DM_TABLE_DEPS),    true  },
+		{ ARG_STR(DM_TABLE_STATUS),  true  },
+	};
+
+	struct dm_ioctl *dm_arg =
+		tail_alloc(sizeof(*dm_arg) - sizeof(dm_arg->data));
+	struct dm_table_open_test *dm_arg_open1 =
+		tail_alloc(offsetof(struct dm_table_open_test, target1));
+	struct dm_table_open_test *dm_arg_open2 =
+		tail_alloc(offsetof(struct dm_table_open_test, param1));
+	struct dm_table_open_test *dm_arg_open3 =
+		tail_alloc(offsetof(struct dm_table_open_test, target9));
+	struct dm_target_msg_test *dm_arg_msg =
+		tail_alloc(sizeof(*dm_arg_msg));
+
+	int saved_errno;
+	unsigned int i;
+
+
+	/* Incorrect operation */
+	ioctl(-1, _IOW(DM_IOCTL, 0xde, int), dm_arg);
+	printf("ioctl(-1, _IOC(_IOC_WRITE, %#04x, 0xde, %#04zx), %p) = "
+		"-1 EBADF (%m)\n",
+		DM_IOCTL, sizeof(int), dm_arg);
+
+
+	/* DM_VERSION */
+	/* Incorrect pointer */
+	ioctl(-1, DM_VERSION, dm_arg + 1);
+	printf("ioctl(-1, DM_VERSION, %p) = -1 EBADF (%m)\n", dm_arg + 1);
+
+	/* Incorrect data_size */
+	init_s(dm_arg, 0, 0);
+	ioctl(-1, DM_VERSION, &s);
+	printf("ioctl(-1, DM_VERSION, %p) = -1 EBADF (%m)\n", &s);
+
+	/* Incorrect version */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->version[0] = 0xbadc0ded;
+	dm_arg->version[1] = 0xbadc0dee;
+	dm_arg->version[2] = 0xbadc0def;
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, {version=%u.%u.%u, "
+	       "/* Unsupported device mapper ABI version */ ...}) = "
+	       "-1 EBADF (%m)\n", 0xbadc0ded, 0xbadc0dee, 0xbadc0def);
+
+	/* Incorrect data_size */
+	init_s(dm_arg, 14, 64);
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, {version=4.1.2, data_size=14, "
+	       "/* Incorrect data_size */ ...}) = -1 EBADF (%m)\n");
+
+	/* Unterminated name/uuid */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	strncpy(dm_arg->name, str129, sizeof(dm_arg->name));
+	strncpy(dm_arg->uuid, str129, sizeof(dm_arg->uuid));
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, {version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"%.127s\", uuid=\"%.128s\", "
+	       "flags=0}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg) - sizeof(dm_arg->data), str129, str129);
+
+	/* Normal call */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = "
+	       "-1 EBADF (%m)\n", sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Zero dev, name, uuid */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->data_size = 0xfacefeed;
+	dm_arg->dev = 0;
+	dm_arg->name[0] = '\0';
+	dm_arg->uuid[0] = '\0';
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, data_size=%u, flags=0}) = "
+	       "-1 EBADF (%m)\n", 0xfacefeed);
+
+	/* Flag */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->flags = 0xffffffff;
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags="
+	       "DM_READONLY_FLAG|DM_SUSPEND_FLAG|DM_EXISTS_FLAG|"
+	       "DM_PERSISTENT_DEV_FLAG|DM_STATUS_TABLE_FLAG|"
+	       "DM_ACTIVE_PRESENT_FLAG|DM_INACTIVE_PRESENT_FLAG|"
+	       "DM_BUFFER_FULL_FLAG|DM_SKIP_BDGET_FLAG|DM_SKIP_LOCKFS_FLAG|"
+	       "DM_NOFLUSH_FLAG|DM_QUERY_INACTIVE_TABLE_FLAG|"
+	       "DM_UEVENT_GENERATED_FLAG|DM_UUID_FLAG|DM_SECURE_DATA_FLAG|"
+	       "DM_DATA_OUT_FLAG|DM_DEFERRED_REMOVE|DM_INTERNAL_SUSPEND_FLAG|"
+	       "0xfff80080}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Normal call */
+	init_s(&s.ioc, sizeof(s.ioc), 0);
+	ioctl(-1, DM_VERSION, &s);
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = "
+	       "-1 EBADF (%m)\n", sizeof(s.ioc));
+
+
+	/* DM_REMOVE_ALL */
+	/* DM_LIST_DEVICES */
+	/* DM_LIST_VERSIONS */
+	for (i = 0; i < ARRAY_SIZE(dummy_check_cmds_nodev); i++) {
+		init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+		ioctl(-1, dummy_check_cmds_nodev[i].arg, dm_arg);
+		printf("ioctl(-1, %s, {version=4.1.2, data_size=%zu%s, "
+		       "flags=0}) = -1 EBADF (%m)\n",
+		       dummy_check_cmds_nodev[i].str,
+		       sizeof(*dm_arg) - sizeof(dm_arg->data),
+		       dummy_check_cmds_nodev[i].has_params ?
+		       ", data_start=0" : "");
+	}
+
+
+	/* DM_DEV_CREATE */
+	/* DM_DEV_REMOVE */
+	/* DM_DEV_STATUS */
+	/* DM_DEV_WAIT */
+	/* DM_TABLE_CLEAR */
+	/* DM_TABLE_DEPS */
+	/* DM_TABLE_STATUS */
+	for (i = 0; i < ARRAY_SIZE(dummy_check_cmds); i++) {
+		init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+		ioctl(-1, dummy_check_cmds[i].arg, dm_arg);
+		printf("ioctl(-1, %s, {version=4.1.2, data_size=%zu%s, "
+		       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\"%s, "
+		       "flags=0}) = -1 EBADF (%m)\n", dummy_check_cmds[i].str,
+		       sizeof(*dm_arg) - sizeof(dm_arg->data),
+		       dummy_check_cmds[i].has_params ? ", data_start=0" : "",
+		       dummy_check_cmds[i].has_event_nr ? ", event_nr=0" : "");
+	}
+
+
+	/* DM_DEV_SUSPEND */
+	init_s(&s.ioc, sizeof(s.ioc), 0);
+	s.ioc.flags = DM_SUSPEND_FLAG;
+	s.ioc.event_nr = 0xbadc0ded;
+	ioctl(-1, DM_DEV_SUSPEND, &s);
+	printf("ioctl(-1, DM_DEV_SUSPEND, "
+	       "{version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "flags=DM_SUSPEND_FLAG}) = -1 EBADF (%m)\n", sizeof(s.ioc));
+
+	init_s(&s.ioc, sizeof(s.ioc), 0);
+	s.ioc.event_nr = 0xbadc0ded;
+	ioctl(-1, DM_DEV_SUSPEND, &s);
+	printf("ioctl(-1, DM_DEV_SUSPEND, "
+	       "{version=4.1.2, data_size=%zu, dev=makedev(18, 52), "
+	       "name=\"nnn\", uuid=\"uuu\", event_nr=3134983661, "
+	       "flags=0}) = -1 EBADF (%m)\n", sizeof(s.ioc));
+
+
+	/* DM_TABLE_LOAD */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	s.ioc.target_count = 1;
+	s.u.ts.target_spec.sector_start = 0x10;
+	s.u.ts.target_spec.length = 0x20;
+	s.u.ts.target_spec.next =
+		sizeof(s.u.ts.target_spec) + sizeof(s.u.ts.target_params);
+	strcpy(s.u.ts.target_spec.target_type, "tgt");
+	strcpy(s.u.ts.target_params, "tparams");
+	ioctl(-1, DM_TABLE_LOAD, &s);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=1, flags=0, "
+# if VERBOSE
+	       "{sector_start=16, length=32, target_type=\"tgt\", "
+	       "string=\"tparams\"}"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n", s.ioc.data_size, s.ioc.data_start);
+
+	/* No targets */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data),
+		sizeof(*dm_arg) - sizeof(dm_arg->data));
+	dm_arg->data_size = sizeof(*dm_arg);
+	dm_arg->target_count = 0;
+	ioctl(-1, DM_TABLE_LOAD, dm_arg);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=0, flags=0}) = -1 EBADF (%m)\n", sizeof(*dm_arg),
+	       sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Invalid data_start */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0xfffffff8);
+	dm_arg->data_size = sizeof(*dm_arg);
+	dm_arg->target_count = 1234;
+	ioctl(-1, DM_TABLE_LOAD, dm_arg);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=1234, flags=0, "
+# if VERBOSE
+	       "/* misplaced struct dm_target_spec */ ..."
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n", sizeof(*dm_arg), 0xfffffff8);
+
+	/* Inaccessible pointer */
+	init_s(&dm_arg_open1->ioc, offsetof(struct dm_table_open_test, target1),
+	       offsetof(struct dm_table_open_test, target1));
+	dm_arg_open1->ioc.data_size = sizeof(*dm_arg_open1);
+	dm_arg_open1->ioc.target_count = 0xdeaddea1;
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open1);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=3735936673, flags=0, "
+# if VERBOSE
+	       "%p"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n", sizeof(*dm_arg_open1),
+	       offsetof(struct dm_table_open_test, target1)
+# if VERBOSE
+	       , (char *) dm_arg_open1 +
+	       offsetof(struct dm_table_open_test, target1)
+# endif /* VERBOSE */
+	       );
+
+	/* Inaccessible string */
+	init_s(&dm_arg_open2->ioc, offsetof(struct dm_table_open_test, param1),
+	       offsetof(struct dm_table_open_test, target1));
+	dm_arg_open2->ioc.data_size = sizeof(*dm_arg_open2);
+	dm_arg_open2->ioc.target_count = 2;
+	init_dm_target_spec(&dm_arg_open2->target1, 7);
+	dm_arg_open2->target1.next =
+		offsetof(struct dm_table_open_test, target3) -
+		offsetof(struct dm_table_open_test, target1);
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open2);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=2, flags=0, ",
+	       sizeof(*dm_arg_open2),
+	       offsetof(struct dm_table_open_test, target1));
+# if VERBOSE
+	print_dm_target_spec(&dm_arg_open2->target1, 7);
+	printf("%p}, %p",
+	       (char *) dm_arg_open2 +
+	       offsetof(struct dm_table_open_test, param1),
+	       (char *) dm_arg_open2 +
+	       offsetof(struct dm_table_open_test, target3));
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
+
+	/* Incorrect next */
+	init_s(&dm_arg_open3->ioc, offsetof(struct dm_table_open_test, target5),
+	       offsetof(struct dm_table_open_test, target0));
+	dm_arg_open3->ioc.target_count = 4;
+
+	init_dm_target_spec(&dm_arg_open3->target0, 9);
+	dm_arg_open3->target0.next =
+		offsetof(struct dm_table_open_test, target1) -
+		offsetof(struct dm_table_open_test, target0);
+	dm_arg_open3->param0[0] = '\0';
+
+	init_dm_target_spec(&dm_arg_open3->target1, 15);
+	dm_arg_open3->target1.next =
+		offsetof(struct dm_table_open_test, target3) -
+		offsetof(struct dm_table_open_test, target1);
+	dm_arg_open3->param1[0] = '\377';
+	dm_arg_open3->param1[1] = '\0';
+
+	init_dm_target_spec(&dm_arg_open3->target3, 42);
+	dm_arg_open3->target3.next = 0xdeadbeef;
+	dm_arg_open3->param3[0] = '\1';
+	dm_arg_open3->param3[1] = '\2';
+	dm_arg_open3->param3[2] = '\0';
+
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open3);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=4, flags=0, ",
+	       offsetof(struct dm_table_open_test, target5),
+	       offsetof(struct dm_table_open_test, target0));
+# if VERBOSE
+	print_dm_target_spec(&dm_arg_open3->target0, 9);
+	printf("\"\"}, ");
+	print_dm_target_spec(&dm_arg_open3->target1, 15);
+	printf("\"\\377\"}, ");
+	print_dm_target_spec(&dm_arg_open3->target1, 42);
+	errno = saved_errno;
+	printf("\"\\1\\2\"}, /* misplaced struct dm_target_spec */ ...");
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
+
+	#define FILL_DM_TARGET(id, id_next) \
+		do { \
+			init_dm_target_spec(&dm_arg_open3->target##id, id); \
+			dm_arg_open3->target##id.next = \
+				offsetof(struct dm_table_open_test, \
+					target##id_next) - \
+				offsetof(struct dm_table_open_test, \
+					target##id); \
+			strncpy(dm_arg_open3->param##id, str129 + id * 2, id); \
+			dm_arg_open3->param##id[id] = '\0'; \
+		} while (0)
+	#define PRINT_DM_TARGET(id) \
+		do { \
+			print_dm_target_spec(&dm_arg_open3->target##id, id); \
+			printf("\"%.*s\"}, ", id, str129 + id * 2); \
+		} while (0)
+
+	/* max_strlen limit */
+	init_s(&dm_arg_open3->ioc, offsetof(struct dm_table_open_test, target9),
+	       offsetof(struct dm_table_open_test, target0));
+	dm_arg_open3->ioc.data_size = sizeof(*dm_arg_open3);
+	dm_arg_open3->ioc.target_count = 0xbadc0ded;
+	FILL_DM_TARGET(0, 1);
+	FILL_DM_TARGET(1, 2);
+	FILL_DM_TARGET(2, 3);
+	FILL_DM_TARGET(3, 4);
+	FILL_DM_TARGET(4, 5);
+	FILL_DM_TARGET(5, 6);
+	FILL_DM_TARGET(6, 7);
+	FILL_DM_TARGET(7, 8);
+	FILL_DM_TARGET(8, 9);
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open3);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=3134983661, flags=0, ",
+	       sizeof(*dm_arg_open3),
+	       offsetof(struct dm_table_open_test, target0));
+# if VERBOSE
+	PRINT_DM_TARGET(0);
+	PRINT_DM_TARGET(1);
+	PRINT_DM_TARGET(2);
+	PRINT_DM_TARGET(3);
+	PRINT_DM_TARGET(4);
+	PRINT_DM_TARGET(5);
+	PRINT_DM_TARGET(6);
+	PRINT_DM_TARGET(7);
+	PRINT_DM_TARGET(8);
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("...}) = -1 EBADF (%m)\n");
+
+
+	/* DM_TARGET_MSG */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	s.u.tm.target_msg.sector = 0x1234;
+	strcpy(s.u.string + offsetof(struct dm_target_msg, message),
+		"long target msg");
+	ioctl(-1, DM_TARGET_MSG, &s);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+# if VERBOSE
+	       "{sector=4660, message=\"long targ\"...}"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
+
+	/* Invalid data_start */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data),
+		sizeof(*dm_arg) - sizeof(dm_arg->data));
+	dm_arg->data_size = sizeof(*dm_arg);
+	ioctl(-1, DM_TARGET_MSG, dm_arg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+# if VERBOSE
+	       "/* misplaced struct dm_target_msg */"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Invalid data_start */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0xffffffff);
+	dm_arg->data_size = sizeof(*dm_arg);
+	ioctl(-1, DM_TARGET_MSG, dm_arg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+# if VERBOSE
+	       "/* misplaced struct dm_target_msg */"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), 0xffffffff);
+
+	/* Inaccessible pointer */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->data_size = sizeof(*dm_arg) + sizeof(struct dm_target_msg);
+	dm_arg->data_start = sizeof(*dm_arg);
+	ioctl(-1, DM_TARGET_MSG, dm_arg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+# if VERBOSE
+	       "%p"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg) + sizeof(struct dm_target_msg),
+	       sizeof(*dm_arg)
+# if VERBOSE
+	       , (char *) dm_arg + sizeof(*dm_arg)
+# endif /* VERBOSE */
+	       );
+
+	/* Inaccessible string */
+	init_s(&dm_arg_msg->ioc, sizeof(*dm_arg_msg),
+		offsetof(struct dm_target_msg_test, msg));
+	dm_arg_msg->ioc.data_size = sizeof(*dm_arg_msg) + 1;
+	dm_arg_msg->msg.sector = (__u64) 0xdeadbeeffacef157ULL;
+	ioctl(-1, DM_TARGET_MSG, dm_arg_msg);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, ",
+	       sizeof(*dm_arg_msg) + 1,
+	       offsetof(struct dm_target_msg_test, msg));
+# if VERBOSE
+	printf("{sector=%" PRI__u64 ", message=%p}",
+	       (__u64) 0xdeadbeeffacef157ULL,
+	       (char *) dm_arg_msg +
+	       offsetof(struct dm_target_msg_test, msg.message));
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
+
+	/* Zero-sied string */
+	init_s(&dm_arg_msg->ioc, sizeof(*dm_arg_msg),
+		offsetof(struct dm_target_msg_test, msg));
+	dm_arg_msg->msg.sector = (__u64) 0xdeadbeeffacef157ULL;
+	ioctl(-1, DM_TARGET_MSG, dm_arg_msg);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, ",
+	       sizeof(*dm_arg_msg), offsetof(struct dm_target_msg_test, msg));
+# if VERBOSE
+	printf("{sector=%" PRI__u64 ", message=\"\"}",
+	       (__u64) 0xdeadbeeffacef157ULL);
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
+
+
+	/* DM_DEV_SET_GEOMETRY */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	strcpy(s.u.string, "10 20 30 40");
+	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
+	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+# if VERBOSE
+	       "string=\"10 20 30 \"..."
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
+
+
+	/* DM_DEV_RENAME */
+	/* Inaccessible data */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data),
+		sizeof(*dm_arg) - sizeof(dm_arg->data));
+	dm_arg->data_size = sizeof(*dm_arg);
+	ioctl(-1, DM_DEV_RENAME, dm_arg);
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, "
+# if VERBOSE
+	       "string=%p"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), sizeof(*dm_arg) - sizeof(dm_arg->data)
+# if VERBOSE
+	       , (char *) dm_arg + sizeof(*dm_arg) - sizeof(dm_arg->data)
+# endif /* VERBOSE */
+	       );
+
+	/* Incorrect data_start data */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	s.ioc.data_start = 0xdeadbeef;
+	ioctl(-1, DM_DEV_RENAME, &s);
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, data_size=%u, data_start=3735928559, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, "
+# if VERBOSE
+	       "/* misplaced string */"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size);
+
+	/* Strange but still valid data_start */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	/* Curiously, this is a valid structure */
+	s.ioc.data_start = offsetof(struct dm_ioctl, name) + 1;
+	ioctl(-1, DM_DEV_RENAME, &s);
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, data_size=%u, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, "
+# if VERBOSE
+	       "string=\"nn\""
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size,
+	       offsetof(struct dm_ioctl, name) + 1);
+
+	/* Correct data */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	strcpy(s.u.string, "new long name");
+	ioctl(-1, DM_DEV_RENAME, &s);
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, "
+# if VERBOSE
+	       "string=\"new long \"..."
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
+
+
+	/* DM_TABLE_LOAD */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	s.ioc.target_count = -1U;
+	ioctl(-1, DM_TABLE_LOAD, &s);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=4294967295, flags=0, "
+# if VERBOSE
+	       "{sector_start=0, length=0, target_type=\"\", string=\"\"}, "
+	       "/* misplaced struct dm_target_spec */ "
+# endif /* VERBOSE */
+	       "...}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
+
+	puts("+++ exited with 0 +++");
+	return 0;
+}
+
+#else /* !HAVE_LINUX_DM_IOCTL_H */
+
+SKIP_MAIN_UNDEFINED("HAVE_LINUX_DM_IOCTL_H")
+
+#endif /* HAVE_LINUX_DM_IOCTL_H */
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
+run_strace -a16 -s9 -eioctl $args > "$EXP"
+check_prog grep
+grep -v '^ioctl([012],' < "$LOG" > "$OUT"
+match_diff "$OUT" "$EXP"
+rm -f "$EXP" "$OUT"
Index: strace/xlat/dm_flags.in
===================================================================
--- /dev/null
+++ strace/xlat/dm_flags.in
@@ -0,0 +1,19 @@
+DM_READONLY_FLAG		(1 << 0)
+DM_SUSPEND_FLAG			(1 << 1)
+/* Defined in lvm2/libdm/ioctl/libdm-iface.c */
+DM_EXISTS_FLAG			(1 << 2)
+DM_PERSISTENT_DEV_FLAG		(1 << 3)
+DM_STATUS_TABLE_FLAG		(1 << 4)
+DM_ACTIVE_PRESENT_FLAG		(1 << 5)
+DM_INACTIVE_PRESENT_FLAG	(1 << 6)
+DM_BUFFER_FULL_FLAG		(1 << 8)
+DM_SKIP_BDGET_FLAG		(1 << 9)
+DM_SKIP_LOCKFS_FLAG		(1 << 10)
+DM_NOFLUSH_FLAG			(1 << 11)
+DM_QUERY_INACTIVE_TABLE_FLAG	(1 << 12)
+DM_UEVENT_GENERATED_FLAG	(1 << 13)
+DM_UUID_FLAG			(1 << 14)
+DM_SECURE_DATA_FLAG		(1 << 15)
+DM_DATA_OUT_FLAG		(1 << 16)
+DM_DEFERRED_REMOVE		(1 << 17)
+DM_INTERNAL_SUSPEND_FLAG	(1 << 18)
Index: strace/util.c
===================================================================
--- strace.orig/util.c
+++ strace/util.c
@@ -820,13 +820,13 @@ printstr_ex(struct tcb *tcp, long addr,
 		outstr = xmalloc(outstr_size);
 	}
 
-	size = max_strlen;
+	size = max_strlen + 1;
 	if (len == -1) {
 		/*
 		 * Treat as a NUL-terminated string: fetch one byte more
 		 * because string_quote may look one byte ahead.
 		 */
-		if (umovestr(tcp, addr, size + 1, str) < 0) {
+		if (umovestr(tcp, addr, size, str) < 0) {
 			printaddr(addr);
 			return;
 		}
@@ -844,11 +844,23 @@ printstr_ex(struct tcb *tcp, long addr,
 
 	style |= user_style;
 
+	if (style & QUOTE_0_TERMINATED) {
+		if (size) {
+			--size;
+		} else {
+			tprints((len == -1) || (len == 0) ? "\"\"" : "\"\"...");
+			return;
+		}
+	}
+	if (size > max_strlen)
+		size = max_strlen;
+
 	/* If string_quote didn't see NUL and (it was supposed to be ASCIZ str
 	 * or we were requested to print more than -s NUM chars)...
 	 */
 	ellipsis = (string_quote(str, outstr, size, style) &&
-			(len < 0 || (unsigned long) len > max_strlen));
+			((style & QUOTE_0_TERMINATED) ||
+				(unsigned long) len > max_strlen));
 
 	tprints(outstr);
 	if (ellipsis)
Index: strace/tests/.gitignore
===================================================================
--- strace.orig/tests/.gitignore
+++ strace/tests/.gitignore
@@ -103,6 +103,8 @@ getxxid
 inet-cmsg
 ioctl
 ioctl_block
+ioctl_dm
+ioctl_dm-v
 ioctl_evdev
 ioctl_evdev-v
 ioctl_mtd
Index: strace/tests/ioctl_dm-v.c
===================================================================
--- /dev/null
+++ strace/tests/ioctl_dm-v.c
@@ -0,0 +1,2 @@
+#define VERBOSE 1
+#include "ioctl_dm.c"
Index: strace/tests/ioctl_dm-v.test
===================================================================
--- /dev/null
+++ strace/tests/ioctl_dm-v.test
@@ -0,0 +1,12 @@
+#!/bin/sh
+
+# Check abbreviated decoding of DM* ioctls.
+
+. "${srcdir=.}/init.sh"
+
+run_prog > /dev/null
+run_strace -a16 -s9 -veioctl $args > "$EXP"
+check_prog grep
+grep -v '^ioctl([012],' < "$LOG" > "$OUT"
+match_diff "$OUT" "$EXP"
+rm -f "$EXP" "$OUT"

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
