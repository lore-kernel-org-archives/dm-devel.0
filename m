From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] device mapper support for strace
Date: Fri, 31 Jul 2015 10:49:44 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507311043370.4689@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, "Dmitry V. Levin" <ldv@altlinux.org>
Cc: dm-devel@redhat.com, strace-devel@lists.sourceforge.net
List-Id: dm-devel.ids

Hi

Here I'm sending a patch that makes it possible to decode device mapper 
ioctls in strace.


How to apply the patch:

Download strace 4.10 from 
http://downloads.sourceforge.net/project/strace/strace/4.10/strace-4.10.tar.xz

On the 4th line of configure.ac, change "m4_esyscmd([./git-version-gen 
.tarball-version])," to "4.10," (the tarball references some file 
git-version-gen that isn't present in the tarball, I think the maintainer 
should fix it)

Apply this patch

Regenerate configure and Makefile.in:
aclocal -I m4
autoheader
autoconf
automake

Compile it:
./configure
make

Mikulas


Index: strace-4.10/configure.ac
===================================================================
--- strace-4.10.orig/configure.ac
+++ strace-4.10/configure.ac
@@ -247,6 +247,7 @@ AC_CHECK_HEADERS(m4_normalize([
 	inttypes.h
 	ioctls.h
 	linux/bsg.h
+	linux/dm-ioctl.h
 	linux/falloc.h
 	linux/filter.h
 	linux/hiddev.h
Index: strace-4.10/defs.h
===================================================================
--- strace-4.10.orig/defs.h
+++ strace-4.10/defs.h
@@ -518,6 +518,7 @@ extern void ioctl_print_code(const unsig
 extern int ioctl_decode(struct tcb *, const unsigned int, long);
 extern int ioctl_decode_command_number(const unsigned int);
 extern int block_ioctl(struct tcb *, const unsigned int, long);
+extern int dm_ioctl(struct tcb *, const unsigned int, long);
 extern int evdev_ioctl(struct tcb *, const unsigned int, long);
 extern int loop_ioctl(struct tcb *, const unsigned int, long);
 extern int mtd_ioctl(struct tcb *, const unsigned int, long);
Index: strace-4.10/dm.c
===================================================================
--- /dev/null
+++ strace-4.10/dm.c
@@ -0,0 +1,335 @@
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
+	if (code != DM_REMOVE_ALL &&
+	    code != DM_LIST_DEVICES &&
+	    code != DM_LIST_VERSIONS) {
+		if (ioc->dev)
+			tprintf(", dev=makedev(%u, %u)", major(ioc->dev), minor(ioc->dev));
+		if (ioc->name[0]) {
+			tprints(", name=");
+			print_quoted_string(ioc->name, DM_NAME_LEN, QUOTE_0_TERMINATED);
+		}
+		if (ioc->uuid[0]) {
+			tprints(", uuid=");
+			print_quoted_string(ioc->uuid, DM_UUID_LEN, QUOTE_0_TERMINATED);
+		}
+	}
+}
+
+static void
+dm_decode_values(struct tcb *tcp, const unsigned int code, const struct dm_ioctl *ioc)
+{
+	if (entering(tcp)) {
+		if (code == DM_TABLE_LOAD)
+			tprintf(", target_count=%u", (unsigned)ioc->target_count);
+		if (code == DM_DEV_RENAME ||
+		    code == DM_DEV_REMOVE ||
+		    (code == DM_DEV_SUSPEND && !(ioc->flags & DM_SUSPEND_FLAG)) ||
+		    code == DM_DEV_WAIT)
+			tprintf(", event_nr=%u", (unsigned)ioc->event_nr);
+	} else if (!tcp->u_error) {
+		if (code == DM_DEV_CREATE ||
+		    code == DM_DEV_RENAME ||
+		    code == DM_DEV_SUSPEND ||
+		    code == DM_DEV_STATUS ||
+		    code == DM_DEV_WAIT ||
+		    code == DM_TABLE_LOAD ||
+		    code == DM_TABLE_CLEAR ||
+		    code == DM_TABLE_DEPS ||
+		    code == DM_TABLE_STATUS ||
+		    code == DM_TARGET_MSG) {
+			tprintf(", target_count=%u", (unsigned)ioc->target_count);
+			tprintf(", open_count=%u", (unsigned)ioc->open_count);
+			tprintf(", event_nr=%u", (unsigned)ioc->event_nr);
+		}
+	}
+}
+
+static void
+dm_decode_flags(const struct dm_ioctl *ioc)
+{
+	if (ioc->flags) {
+		static const struct {
+			uint32_t flag;
+			const char *string;
+		} dm_flags[] = {
+			{ DM_READONLY_FLAG, "DM_READONLY_FLAG" },
+			{ DM_SUSPEND_FLAG, "DM_SUSPEND_FLAG" },
+			{ DM_PERSISTENT_DEV_FLAG, "DM_PERSISTENT_DEV_FLAG" },
+			{ DM_STATUS_TABLE_FLAG, "DM_STATUS_TABLE_FLAG" },
+			{ DM_ACTIVE_PRESENT_FLAG, "DM_ACTIVE_PRESENT_FLAG" },
+			{ DM_INACTIVE_PRESENT_FLAG, "DM_INACTIVE_PRESENT_FLAG" },
+			{ DM_BUFFER_FULL_FLAG, "DM_BUFFER_FULL_FLAG" },
+			{ DM_SKIP_BDGET_FLAG, "DM_SKIP_BDGET_FLAG" },
+#ifdef DM_SKIP_LOCKFS_FLAG
+			{ DM_SKIP_LOCKFS_FLAG, "DM_SKIP_LOCKFS_FLAG" },
+#endif
+#ifdef DM_NOFLUSH_FLAG
+			{ DM_NOFLUSH_FLAG, "DM_NOFLUSH_FLAG" },
+#endif
+#ifdef DM_QUERY_INACTIVE_TABLE_FLAG
+			{ DM_QUERY_INACTIVE_TABLE_FLAG, "DM_QUERY_INACTIVE_TABLE_FLAG" },
+#endif
+#ifdef DM_UEVENT_GENERATED_FLAG
+			{ DM_UEVENT_GENERATED_FLAG, "DM_UEVENT_GENERATED_FLAG" },
+#endif
+#ifdef DM_UUID_FLAG
+			{ DM_UUID_FLAG, "DM_UUID_FLAG" },
+#endif
+#ifdef DM_SECURE_DATA_FLAG
+			{ DM_SECURE_DATA_FLAG, "DM_SECURE_DATA_FLAG" },
+#endif
+#ifdef DM_DATA_OUT_FLAG
+			{ DM_DATA_OUT_FLAG, "DM_DATA_OUT_FLAG" },
+#endif
+#ifdef DM_DEFERRED_REMOVE
+			{ DM_DEFERRED_REMOVE, "DM_DEFERRED_REMOVE" },
+#endif
+#ifdef DM_INTERNAL_SUSPEND_FLAG
+			{ DM_INTERNAL_SUSPEND_FLAG, "DM_INTERNAL_SUSPEND_FLAG" },
+#endif
+		};
+		uint32_t flags = ioc->flags;
+		bool first = true;
+		unsigned i;
+		tprints(", flags=");
+		for (i = 0; i < sizeof(dm_flags) / sizeof(*dm_flags); i++) {
+			if (flags & dm_flags[i].flag) {
+				if (!first)
+					tprints("|");
+				else
+					first = false;
+				tprints(dm_flags[i].string);
+				flags &= ~dm_flags[i].flag;
+			}
+		}
+		if (flags) {
+			if (!first)
+				tprints("|");
+			else
+				first = false;
+			tprintf("0x%x", (unsigned)flags);
+		}
+
+	}
+}
+
+static void
+dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc, const char *extra, size_t extra_size)
+{
+	uint32_t i;
+	size_t offset = ioc->data_start;
+	for (i = 0; i < ioc->target_count; i++) {
+		if (offset + sizeof(struct dm_target_spec) >= offset &&
+		    offset + sizeof(struct dm_target_spec) < extra_size) {
+			const struct dm_target_spec *s = (const struct dm_target_spec *)(extra + offset);
+			tprintf(", {sector_start=%llu, length=%llu", (unsigned long long)s->sector_start, (unsigned long long)s->length);
+			if (!entering(tcp))
+				tprintf(", status=%d", (int)s->status);
+			tprints(", target_type=");
+			print_quoted_string(s->target_type, DM_MAX_TYPE_NAME, QUOTE_0_TERMINATED);
+			tprints(", string=");
+			print_quoted_string((const char *)(s + 1), extra_size - (offset + sizeof(struct dm_target_spec)), QUOTE_0_TERMINATED);
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
+dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra, size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	if (offset + offsetof(struct dm_target_deps, dev) >= offset &&
+	    offset + offsetof(struct dm_target_deps, dev) <= extra_size) {
+		uint32_t i;
+		size_t space = (extra_size - (offset + offsetof(struct dm_target_deps, dev))) / sizeof(__u64);
+		const struct dm_target_deps *s = (const struct dm_target_deps *)(extra + offset);
+		if (s->count > space)
+			goto misplaced;
+		tprints(", deps={");
+		for (i = 0; i < s->count; i++) {
+			tprintf("%smakedev(%u, %u)", i ? ", " : "", major(s->dev[i]), minor(s->dev[i]));
+		}
+		tprints("}");
+	} else {
+misplaced:
+		tprints(", misplaced struct dm_target_deps");
+	}
+}
+
+static void
+dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra, size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	while (1) {
+		if (offset + offsetof(struct dm_name_list, name) >= offset &&
+		    offset + offsetof(struct dm_name_list, name) < extra_size) {
+			const struct dm_name_list *s = (const struct dm_name_list *)(extra + offset);
+			if (!s->dev)
+				break;
+			tprintf(", {dev=makedev(%u, %u), name=", major(s->dev), minor(s->dev));
+			print_quoted_string(s->name, extra_size - (offset + offsetof(struct dm_name_list, name)), QUOTE_0_TERMINATED);
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
+dm_decode_dm_target_versions(const struct dm_ioctl *ioc, const char *extra, size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	while (1) {
+		if (offset + offsetof(struct dm_target_versions, name) >= offset &&
+		    offset + offsetof(struct dm_target_versions, name) < extra_size) {
+			const struct dm_target_versions *s = (const struct dm_target_versions *)(extra + offset);
+			tprints(", {name=");
+			print_quoted_string(s->name, extra_size - (offset + offsetof(struct dm_target_versions, name)), QUOTE_0_TERMINATED);
+			tprintf(", version=%u.%u.%u}", (unsigned)s->version[0], (unsigned)s->version[1], (unsigned)s->version[2]);
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
+dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra, size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	if (offset + offsetof(struct dm_target_msg, message) >= offset &&
+	    offset + offsetof(struct dm_target_msg, message) < extra_size) {
+		const struct dm_target_msg *s = (const struct dm_target_msg *)(extra + offset);
+		tprintf(", {sector=%llu, message=", (unsigned long long)s->sector);
+		print_quoted_string(s->message, extra_size - offsetof(struct dm_target_msg, message), QUOTE_0_TERMINATED);
+		tprints("}");
+	} else {
+		tprints(", misplaced struct dm_target_msg");
+	}
+}
+
+static void
+dm_decode_string(const struct dm_ioctl *ioc, const char *extra, size_t extra_size)
+{
+	size_t offset = ioc->data_start;
+	if (offset < extra_size) {
+		tprints(", string=");
+		print_quoted_string(extra + offset, extra_size - offset, QUOTE_0_TERMINATED);
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
+	tprintf(", {version=%d.%d.%d", ioc.version[0], ioc.version[1], ioc.version[2]);
+
+	/* if we use a different version of ABI, do not attempt to decode ioctl fields */
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
+	if (!abbrev(tcp)) {
+		if ((code == DM_DEV_WAIT && !entering(tcp) && !tcp->u_error) ||
+		    (code == DM_TABLE_STATUS && !entering(tcp) && !tcp->u_error) ||
+		    (code == DM_TABLE_LOAD && entering(tcp)))
+			dm_decode_dm_target_spec(tcp, &ioc, extra, extra_size);
+		if (code == DM_TABLE_DEPS && !entering(tcp) && !tcp->u_error)
+			dm_decode_dm_target_deps(&ioc, extra, extra_size);
+		if (code == DM_LIST_DEVICES && !entering(tcp) && !tcp->u_error)
+			dm_decode_dm_name_list(&ioc, extra, extra_size);
+		if (code == DM_LIST_VERSIONS && !entering(tcp) && !tcp->u_error)
+			dm_decode_dm_target_versions(&ioc, extra, extra_size);
+		if (code == DM_TARGET_MSG && entering(tcp))
+			dm_decode_dm_target_msg(&ioc, extra, extra_size);
+		if (code == DM_TARGET_MSG && !entering(tcp) && !tcp->u_error && ioc.flags & DM_DATA_OUT_FLAG)
+			dm_decode_string(&ioc, extra, extra_size);
+		if (code == DM_DEV_RENAME && entering(tcp))
+			dm_decode_string(&ioc, extra, extra_size);
+		if (code == DM_DEV_SET_GEOMETRY && entering(tcp))
+			dm_decode_string(&ioc, extra, extra_size);
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
Index: strace-4.10/ioctl.c
===================================================================
--- strace-4.10.orig/ioctl.c
+++ strace-4.10/ioctl.c
@@ -258,6 +258,10 @@ ioctl_decode(struct tcb *tcp, unsigned i
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
Index: strace-4.10/Makefile.am
===================================================================
--- strace-4.10.orig/Makefile.am
+++ strace-4.10/Makefile.am
@@ -41,6 +41,7 @@ strace_SOURCES =	\
 	count.c		\
 	desc.c		\
 	dirent.c	\
+	dm.c		\
 	evdev.c		\
 	execve.c	\
 	exit.c		\
