From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device mapper support for strace
Date: Tue, 11 Aug 2015 13:11:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1508111310290.20408@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1507311043370.4689@file01.intranet.prod.int.rdu2.redhat.com>
	<20150731153520.GA20404@altlinux.org>
	<alpine.LRH.2.02.1507311202320.29679@file01.intranet.prod.int.rdu2.redhat.com>
	<20150801175400.GA3943@altlinux.org>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20150801175400.GA3943-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
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



On Sat, 1 Aug 2015, Dmitry V. Levin wrote:

> On Fri, Jul 31, 2015 at 12:04:48PM -0400, Mikulas Patocka wrote:
> > On Fri, 31 Jul 2015, Dmitry V. Levin wrote:
> > > On Fri, Jul 31, 2015 at 10:49:44AM -0400, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > Here I'm sending a patch that makes it possible to decode device mapper 
> > > > ioctls in strace.
> > > > 
> > > > How to apply the patch:
> > > > 
> > > > Download strace 4.10 from 
> > > > http://downloads.sourceforge.net/project/strace/strace/4.10/strace-4.10.tar.xz
> > > 
> > > Please rebase onto strace.git HEAD (v4.10-277-gd9fb450 at this moment).
> > > Use ./bootstrap to regenerate dev files.
> > 
> > This is the updated patch for strace.git.
> 
> Thanks.
> 
> Unfortunately, this one doesn't apply at all, you must be using a quite
> outdated strace.git repository.
> 
> The up to date strace.git is located at git://git.code.sf.net/p/strace/code.git,
> and when it is not available because of sf.net issues (which are quite
> often nowadays), one can use mirrors at https://github.com/ldv-alt/strace.git
> and git://git.altlinux.org/people/ldv/public/strace.git
> 
> Just a few comments after very cursory look at your patch:

Hi

Here I'm sending updated patch with your suggestions:

Index: strace/configure.ac
===================================================================
--- strace.orig/configure.ac
+++ strace/configure.ac
@@ -259,6 +259,7 @@ AC_CHECK_HEADERS(m4_normalize([
 	ioctls.h
 	linux/bsg.h
 	linux/falloc.h
+	linux/dm-ioctl.h
 	linux/filter.h
 	linux/hiddev.h
 	linux/mmtimer.h
Index: strace/dm.c
===================================================================
--- /dev/null
+++ strace/dm.c
@@ -0,0 +1,354 @@
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
+		case DM_REMOVE_ALL:
+		case DM_LIST_DEVICES:
+		case DM_LIST_VERSIONS:
+			break;
+		default:
+			if (ioc->dev)
+				tprintf(", dev=makedev(%u, %u)",
+					major(ioc->dev), minor(ioc->dev));
+			if (ioc->name[0]) {
+				tprints(", name=");
+				print_quoted_string(ioc->name, DM_NAME_LEN,
+						    QUOTE_0_TERMINATED);
+			}
+			if (ioc->uuid[0]) {
+				tprints(", uuid=");
+				print_quoted_string(ioc->uuid, DM_UUID_LEN,
+						    QUOTE_0_TERMINATED);
+			}
+			break;
+	}
+}
+
+static void
+dm_decode_values(struct tcb *tcp, const unsigned int code,
+		 const struct dm_ioctl *ioc)
+{
+	if (entering(tcp)) {
+		switch (code) {
+			case DM_TABLE_LOAD:
+				tprintf(", target_count=%u",
+					(unsigned)ioc->target_count);
+				break;
+			case DM_DEV_SUSPEND:
+				if (ioc->flags & DM_SUSPEND_FLAG)
+					break;
+			case DM_DEV_RENAME:
+			case DM_DEV_REMOVE:
+			case DM_DEV_WAIT:
+				tprintf(", event_nr=%u",
+					(unsigned)ioc->event_nr);
+				break;
+		}
+	} else if (!syserror(tcp)) {
+		switch (code) {
+			case DM_DEV_CREATE:
+			case DM_DEV_RENAME:
+			case DM_DEV_SUSPEND:
+			case DM_DEV_STATUS:
+			case DM_DEV_WAIT:
+			case DM_TABLE_LOAD:
+			case DM_TABLE_CLEAR:
+			case DM_TABLE_DEPS:
+			case DM_TABLE_STATUS:
+			case DM_TARGET_MSG:
+				tprintf(", target_count=%u",
+					(unsigned)ioc->target_count);
+				tprintf(", open_count=%u",
+					(unsigned)ioc->open_count);
+				tprintf(", event_nr=%u",
+					(unsigned)ioc->event_nr);
+				break;
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
+			 const char *extra, size_t extra_size)
+{
+	uint32_t i;
+	size_t offset = ioc->data_start;
+	for (i = 0; i < ioc->target_count; i++) {
+		if (offset + sizeof(struct dm_target_spec) >= offset &&
+		    offset + sizeof(struct dm_target_spec) < extra_size) {
+			const struct dm_target_spec *s =
+				(const struct dm_target_spec *)(extra + offset);
+			tprintf(", {sector_start=%llu, length=%llu",
+				(unsigned long long)s->sector_start,
+				(unsigned long long)s->length);
+			if (!entering(tcp))
+				tprintf(", status=%d", (int)s->status);
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
+				offset = offset + s->next;
+			else
+				offset = ioc->data_start + s->next;
+		} else {
+			tprints(", misplaced struct dm_target_spec");
+			break;
+		}
+	}
+}
+
+static void
+dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra,
+			 size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	if (offset + offsetof(struct dm_target_deps, dev) >= offset &&
+	    offset + offsetof(struct dm_target_deps, dev) <= extra_size) {
+		uint32_t i;
+		size_t space = (extra_size - (offset +
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
+misplaced:
+		tprints(", misplaced struct dm_target_deps");
+	}
+}
+
+static void
+dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra,
+		       size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	while (1) {
+		if (offset + offsetof(struct dm_name_list, name) >= offset &&
+		    offset + offsetof(struct dm_name_list, name) < extra_size) {
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
+			if (offset + s->next < offset)
+				goto misplaced;
+			offset = offset + s->next;
+		} else {
+misplaced:
+			tprints(", misplaced struct dm_name_list");
+			break;
+		}
+	}
+}
+
+static void
+dm_decode_dm_target_versions(const struct dm_ioctl *ioc, const char *extra,
+			     size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	while (1) {
+		if (offset + offsetof(struct dm_target_versions, name) >=
+		    offset &&
+		    offset + offsetof(struct dm_target_versions, name) <
+		    extra_size) {
+			const struct dm_target_versions *s =
+			    (const struct dm_target_versions *)(extra + offset);
+			tprints(", {name=");
+			print_quoted_string(s->name, extra_size - (offset +
+					    offsetof(struct dm_target_versions,
+					    name)), QUOTE_0_TERMINATED);
+			tprintf(", version=%u.%u.%u}", (unsigned)s->version[0],
+				(unsigned)s->version[1],
+				(unsigned)s->version[2]);
+			if (!s->next)
+				break;
+			if (offset + s->next < offset)
+				goto misplaced;
+			offset = offset + s->next;
+		} else {
+misplaced:
+			tprints(", misplaced struct dm_target_versions");
+			break;
+		}
+	}
+}
+
+static void
+dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra,
+			size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	if (offset + offsetof(struct dm_target_msg, message) >= offset &&
+	    offset + offsetof(struct dm_target_msg, message) < extra_size) {
+		const struct dm_target_msg *s =
+			(const struct dm_target_msg *)(extra + offset);
+		tprintf(", {sector=%llu, message=",
+			(unsigned long long)s->sector);
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
+		 size_t extra_size)
+{
+	size_t offset = ioc->data_start;
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
+	size_t extra_size = 0;
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
+skip:
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
+		case DM_VERSION:
+		case DM_REMOVE_ALL:
+		case DM_LIST_DEVICES:
+		case DM_DEV_CREATE:
+		case DM_DEV_REMOVE:
+		case DM_DEV_RENAME:
+		case DM_DEV_SUSPEND:
+		case DM_DEV_STATUS:
+		case DM_DEV_WAIT:
+		case DM_TABLE_LOAD:
+		case DM_TABLE_CLEAR:
+		case DM_TABLE_DEPS:
+		case DM_TABLE_STATUS:
+		case DM_LIST_VERSIONS:
+		case DM_TARGET_MSG:
+		case DM_DEV_SET_GEOMETRY:
+			return dm_known_ioctl(tcp, code, arg);
+		default:
+			return 0;
+	}
+}
+
+#endif
Index: strace/ioctl.c
===================================================================
--- strace.orig/ioctl.c
+++ strace/ioctl.c
@@ -263,6 +263,10 @@ ioctl_decode(struct tcb *tcp)
 	case 'E':
 		return evdev_ioctl(tcp, code, arg);
 #endif
+#ifdef HAVE_LINUX_DM_IOCTL_H
+	case 0xfd:
+		return dm_ioctl(tcp, code, arg);
+#endif
 	default:
 		break;
 	}
Index: strace/Makefile.am
===================================================================
--- strace.orig/Makefile.am
+++ strace/Makefile.am
@@ -42,6 +42,7 @@ strace_SOURCES =	\
 	count.c		\
 	desc.c		\
 	dirent.c	\
+	dm.c		\
 	epoll.c		\
 	evdev.c		\
 	eventfd.c	\
Index: strace/defs.h
===================================================================
--- strace.orig/defs.h
+++ strace/defs.h
@@ -587,6 +587,7 @@ extern void print_seccomp_filter(struct
 
 extern int block_ioctl(struct tcb *, const unsigned int, long);
 extern int evdev_ioctl(struct tcb *, const unsigned int, long);
+extern int dm_ioctl(struct tcb *, const unsigned int, long);
 extern int loop_ioctl(struct tcb *, const unsigned int, long);
 extern int mtd_ioctl(struct tcb *, const unsigned int, long);
 extern int ptp_ioctl(struct tcb *, const unsigned int, long);
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
