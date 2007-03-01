From: Dan Smith <danms@us.ibm.com>
Subject: [PATCH 2/2] Add dm-userspace support to libdevmapper
Date: Thu, 01 Mar 2007 13:47:25 -0800
Message-ID: <m3d53sws9e.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Here are my latest changes to libdevmapper that match part one of this
set.

To my knowledge, this interface has never been commented upon by
anyone other than me, so feedback would be appreciated (as always).

- --=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

Signed-off-by: Dan Smith <danms@us.ibm.com>
diff -r 4b8428722a88 -r 436987ea3cbf configure
- --- a/configure	Wed Feb 14 15:12:14 2007 +0000
+++ b/configure	Wed Feb 21 14:05:10 2007 -0800
@@ -310,7 +310,7 @@ ac_includes_default=3D"\
 #endif"
=20
 ac_default_prefix=3D/usr
- -ac_subst_vars=3D'SHELL PATH_SEPARATOR PACKAGE_NAME PACKAGE_TARNAME PAC=
KAGE_VERSION PACKAGE_STRING PACKAGE_BUGREPORT exec_prefix prefix program_=
transform_name bindir sbindir libexecdir datadir sysconfdir sharedstatedi=
r localstatedir libdir includedir oldincludedir infodir mandir build_alia=
s host_alias target_alias DEFS ECHO_C ECHO_N ECHO_T LIBS build build_cpu =
build_vendor build_os host host_cpu host_vendor host_os target target_cpu=
 target_vendor target_os AWK CC CFLAGS LDFLAGS CPPFLAGS ac_ct_CC EXEEXT O=
BJEXT CPP EGREP INSTALL_PROGRAM INSTALL_SCRIPT INSTALL_DATA LN_S SET_MAKE=
 RANLIB ac_ct_RANLIB LIBOBJS MSGFMT usrlibdir JOBS STATIC_LINK OWNER GROU=
P interface kerneldir missingkernel kernelvsn tmpdir COPTIMISE_FLAG CLDFL=
AGS LDDEPS LIB_SUFFIX DEBUG DM_LIB_VERSION COMPAT DMIOCTLS LOCALEDIR INTL=
_PACKAGE INTL DEVICE_UID DEVICE_GID DEVICE_MODE DMEVENTD PKGCONFIG LTLIBO=
BJS'
+ac_subst_vars=3D'SHELL PATH_SEPARATOR PACKAGE_NAME PACKAGE_TARNAME PACKA=
GE_VERSION PACKAGE_STRING PACKAGE_BUGREPORT exec_prefix prefix program_tr=
ansform_name bindir sbindir libexecdir datadir sysconfdir sharedstatedir =
localstatedir libdir includedir oldincludedir infodir mandir build_alias =
host_alias target_alias DEFS ECHO_C ECHO_N ECHO_T LIBS build build_cpu bu=
ild_vendor build_os host host_cpu host_vendor host_os target target_cpu t=
arget_vendor target_os AWK CC CFLAGS LDFLAGS CPPFLAGS ac_ct_CC EXEEXT OBJ=
EXT CPP EGREP INSTALL_PROGRAM INSTALL_SCRIPT INSTALL_DATA LN_S SET_MAKE R=
ANLIB ac_ct_RANLIB LIBOBJS MSGFMT usrlibdir JOBS STATIC_LINK OWNER GROUP =
interface kerneldir missingkernel kernelvsn tmpdir COPTIMISE_FLAG CLDFLAG=
S LDDEPS LIB_SUFFIX DEBUG DM_LIB_VERSION COMPAT DMIOCTLS LOCALEDIR INTL_P=
ACKAGE INTL DEVICE_UID DEVICE_GID DEVICE_MODE DMEVENTD PKGCONFIG DMU LTLI=
BOBJS'
 ac_subst_files=3D''
=20
 # Initialize some variables set by options.
@@ -856,6 +856,7 @@ Optional Features:
                           statically.  Default is dynamic linking
   --disable-selinux       Disable selinux support
   --enable-nls            Enable Native Language Support
+  --disable-dmu        Disable dm-userspace support
=20
 Optional Packages:
   --with-PACKAGE[=3DARG]    use PACKAGE [ARG=3Dyes]
@@ -1445,7 +1446,8 @@ case "$host_os" in
 		LDDEPS=3D"$LDDEPS .export.sym"
 		LIB_SUFFIX=3D"so"
 		DMIOCTLS=3D"yes"
- -		SELINUX=3D"yes" ;;
+		SELINUX=3D"yes"
+		DMU=3D"yes" ;;
 	darwin*)
 		CFLAGS=3D"$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG=3D"-O2"
@@ -1453,7 +1455,8 @@ case "$host_os" in
 		LDDEPS=3D"$LDDEPS"
 		LIB_SUFFIX=3D"dylib"
 		DMIOCTLS=3D"no"
- -		SELINUX=3D"no" ;;
+		SELINUX=3D"no"
+		DMU=3D"no" ;;
 esac
=20
 ########################################################################=
########
@@ -5963,6 +5966,26 @@ fi
 fi
=20
 ########################################################################=
########
+echo "$as_me:$LINENO: checking whether to enable dm-userspace" >&5
+echo $ECHO_N "checking whether to enable dm-userspace... $ECHO_C" >&6
+# Check whether --enable-dmu or --disable-dmu was given.
+if test "${enable_dmu+set}" =3D set; then
+  enableval=3D"$enable_dmu"
+  DMU=3D$enableval
+fi;
+echo "$as_me:$LINENO: result: $DMU" >&5
+echo "${ECHO_T}$DMU" >&6
+
+if test "x${DMU}" =3D "xyes"; then
+	if test "x${missingkernel}" =3D xyes; then
+		{ { echo "$as_me:$LINENO: error: \"Kernel source required to build dm-=
userspace tools\"" >&5
+echo "$as_me: error: \"Kernel source required to build dm-userspace tool=
s\"" >&2;}
+   { (exit 1); exit 1; }; }
+	fi
+fi
+
+
+########################################################################=
########
 echo "$as_me:$LINENO: checking for kernel version" >&5
 echo $ECHO_N "checking for kernel version... $ECHO_C" >&6
=20
@@ -6044,6 +6067,7 @@ _ACEOF
=20
=20
 ########################################################################=
########
+
=20
=20
 if test "$DMEVENTD" =3D yes; then
@@ -6799,6 +6823,7 @@ s,@DEVICE_MODE@,$DEVICE_MODE,;t t
 s,@DEVICE_MODE@,$DEVICE_MODE,;t t
 s,@DMEVENTD@,$DMEVENTD,;t t
 s,@PKGCONFIG@,$PKGCONFIG,;t t
+s,@DMU@,$DMU,;t t
 s,@LTLIBOBJS@,$LTLIBOBJS,;t t
 CEOF
=20
diff -r 4b8428722a88 -r 436987ea3cbf configure.in
- --- a/configure.in	Wed Feb 14 15:12:14 2007 +0000
+++ b/configure.in	Wed Feb 21 14:05:10 2007 -0800
@@ -38,7 +38,8 @@ case "$host_os" in
 		LDDEPS=3D"$LDDEPS .export.sym"
 		LIB_SUFFIX=3D"so"
 		DMIOCTLS=3D"yes"
- -		SELINUX=3D"yes" ;;
+		SELINUX=3D"yes"
+		DMU=3D"yes" ;;
 	darwin*)
 		CFLAGS=3D"$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG=3D"-O2"
@@ -46,7 +47,8 @@ case "$host_os" in
 		LDDEPS=3D"$LDDEPS"
 		LIB_SUFFIX=3D"dylib"
 		DMIOCTLS=3D"no"
- -		SELINUX=3D"no" ;;
+		SELINUX=3D"no"
+		DMU=3D"no" ;;
 esac
=20
 ########################################################################=
########
@@ -296,6 +298,20 @@ else
 else
   test -d "${kerneldir}" || { AC_MSG_WARN(kernel dir $kerneldir not foun=
d); missingkernel=3Dyes ; }
 fi
+
+########################################################################=
########
+dnl -- Disable dm-userspace
+AC_MSG_CHECKING(whether to enable dm-userspace)
+AC_ARG_ENABLE(dmu, [  --disable-dmu        Disable dm-userspace support]=
,
+DMU=3D$enableval)
+AC_MSG_RESULT($DMU)
+
+if test "x${DMU}" =3D "xyes"; then
+	if test "x${missingkernel}" =3D xyes; then
+		AC_ERROR("Kernel source required to build dm-userspace tools")
+	fi
+fi
+=09
=20
 ########################################################################=
########
 dnl -- Kernel version string
@@ -413,6 +429,7 @@ AC_SUBST(DEVICE_MODE)
 AC_SUBST(DEVICE_MODE)
 AC_SUBST(DMEVENTD)
 AC_SUBST(PKGCONFIG)
+AC_SUBST(DMU)
=20
 ########################################################################=
########
 dnl -- First and last lines should not contain files to generate in orde=
r to=20
diff -r 4b8428722a88 -r 436987ea3cbf lib/.exported_symbols
- --- a/lib/.exported_symbols	Wed Feb 14 15:12:14 2007 +0000
+++ b/lib/.exported_symbols	Wed Feb 21 14:05:10 2007 -0800
@@ -127,3 +127,26 @@ dm_report_field_uint32
 dm_report_field_uint32
 dm_report_field_uint64
 dm_report_field_set_value
+dmu_async_map
+dmu_async_map_done
+dmu_ctl_close
+dmu_ctl_open
+dmu_ctl_send_queue
+dmu_events_pending
+dmu_get_ctl_fd
+dmu_kill_mapping
+dmu_make_mapping
+dmu_map_dup
+dmu_map_get_block
+dmu_map_get_id
+dmu_map_is_write
+dmu_map_set_block
+dmu_map_set_copy_src_dev
+dmu_map_set_dest_dev
+dmu_map_set_offset
+dmu_map_set_origin_block
+dmu_map_set_sync
+dmu_map_set_writable
+dmu_process_events
+dmu_register_map_done_handler
+dmu_register_map_handler
\ No newline at end of file
diff -r 4b8428722a88 -r 436987ea3cbf lib/Makefile.in
- --- a/lib/Makefile.in	Wed Feb 14 15:12:14 2007 +0000
+++ b/lib/Makefile.in	Wed Feb 21 14:05:10 2007 -0800
@@ -16,6 +16,7 @@ top_srcdir =3D @top_srcdir@
 top_srcdir =3D @top_srcdir@
 VPATH =3D @srcdir@
 interface =3D @interface@
+kerneldir =3D @kerneldir@
=20
 SOURCES =3D\
 	datastruct/bitset.c \
@@ -30,6 +31,11 @@ SOURCES =3D\
 	$(interface)/libdm-iface.c
=20
 INCLUDES =3D -I$(interface)
+
+ifeq ("@DMU@", "yes")
+  INCLUDES +=3D -I$(kerneldir)/include
+  SOURCES +=3D dmu.c
+endif
=20
 LIB_STATIC =3D $(interface)/libdevmapper.a
=20
diff -r 4b8428722a88 -r 436987ea3cbf lib/dmu.c
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/lib/dmu.c	Wed Feb 21 14:05:10 2007 -0800
@@ -0,0 +1,638 @@
+/*
+ * Copyright IBM Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * This file is subject to the terms and conditions of the GNU Lesser
+ * General Public License. See the file COPYING in the main directory
+ * of this archive for more details.
+ *
+ */
+
+#include <stdio.h>
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <errno.h>
+#include <stdint.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <libdevmapper.h>
+#include <linux/dm-userspace.h>
+#include <sys/mman.h>
+
+#define PAGE_SHIFT 12
+#define PAGE_SIZE (1UL << PAGE_SHIFT)
+
+#define MAX_MAJ_VER 0
+#define MAX_MIN_VER 1
+
+#define DMU_MSG_DEBUG 0
+
+struct uring {
+        uint32_t idx;
+        char *buf;
+        int size;
+};
+
+#if DMU_MSG_DEBUG
+#define DPRINTF( s, arg... ) fprintf(stderr, s, ##arg)
+#else
+#define DPRINTF( s, arg... )
+#endif
+
+struct dmu_events {
+	map_done_handler_t map_done_fn;
+	map_req_handler_t map_fn;
+};
+
+struct dmu_event_data {
+	void *map_done_user_data;
+	void *map_user_data;
+};
+
+struct dmu_context {
+	int fd;
+	uint32_t id_ctr;
+	struct dmu_events events;
+	struct dmu_event_data event_data;
+=09
+	struct uring ukring;
+	struct uring kuring;
+
+	uint32_t pending;
+};
+
+struct dmu_map_data {
+	uint64_t org_block;
+	uint64_t block;
+	int64_t offset;
+	uint32_t id;
+	uint32_t flags;
+	dev_t dest_dev;
+	dev_t copy_src_dev;
+};
+
+void dmu_map_set_origin_block(struct dmu_map_data *data, uint64_t block)
+{
+	data->org_block =3D block;
+}
+
+void dmu_map_set_writable(struct dmu_map_data *data, int rw)
+{
+	dmu_set_flag(&data->flags, DMU_FLAG_WR);
+}
+
+void dmu_map_set_block(struct dmu_map_data *data, uint64_t block)
+{
+	data->block =3D block;
+}
+
+uint64_t dmu_map_get_block(struct dmu_map_data *data)
+{
+	return data->block;
+}
+
+void dmu_map_set_offset(struct dmu_map_data *data, int64_t offset)
+{
+	data->offset =3D offset;
+}
+
+uint32_t dmu_map_get_id(struct dmu_map_data *data)
+{
+	return data->id;
+}
+
+void dmu_map_set_dest_dev(struct dmu_map_data *data, dev_t dev)
+{
+	data->dest_dev =3D dev;
+}
+
+void dmu_map_set_copy_src_dev(struct dmu_map_data *data, dev_t dev)
+{
+	data->copy_src_dev =3D dev;
+	dmu_set_flag(&data->flags, DMU_FLAG_COPY_FIRST);
+}
+
+int dmu_map_is_write(struct dmu_map_data *data)
+{
+	return dmu_get_flag(&data->flags, DMU_FLAG_WR);
+}
+
+void dmu_map_set_sync(struct dmu_map_data *data)
+{
+	dmu_set_flag(&data->flags, DMU_FLAG_SYNC);
+}
+
+struct dmu_map_data *dmu_map_dup(struct dmu_map_data *data)
+{
+	struct dmu_map_data *dup;
+
+	dup =3D malloc(sizeof(*dup));
+	if (!dup)
+		return NULL;
+
+	if (data)
+		memcpy(dup, data, sizeof(*dup));
+
+	return dup;
+}
+
+/*
+ * Get the major/minor of the character control device that @dm_device
+ * has exported for us.  We do this by looking at the device status
+ * string.
+ */
+static int get_dm_control_dev(char *dm_device,
+			       unsigned *maj, unsigned *min)
+{
+	struct dm_task *task;
+	int ret;
+	void *next =3D NULL;
+	uint64_t start, length;
+	char *ttype =3D NULL, *params =3D NULL;
+
+	task =3D dm_task_create(DM_DEVICE_STATUS);
+
+	ret =3D dm_task_set_name(task, dm_device);
+	if (!ret) {
+		DPRINTF("Failed to set device-mapper target name\n");
+		dm_task_destroy(task);
+		return -1;
+	}
+
+	ret =3D dm_task_run(task);
+	if (!ret) {
+		DPRINTF("Failed to run device-mapper task\n");
+		dm_task_destroy(task);
+		return -1;
+	}
+
+	ret =3D 0;
+	do {
+		next =3D dm_get_next_target(task, next, &start, &length,
+					  &ttype, &params);
+
+		if (strcmp(ttype, "userspace") =3D=3D 0) {
+			ret =3D sscanf(params, "%x:%x", maj, min);
+			if (ret =3D=3D 2)
+				break;
+		}
+
+	} while (next);
+
+	return 0;
+}
+
+/*
+ * Create the character device node for our control channel
+ */
+static int make_device_node(unsigned major, unsigned minor)
+{
+	char path[256];
+
+	sprintf(path, "/dev/dmu%i", minor);
+
+	return mknod(path, S_IFCHR, makedev(major, minor));
+}
+
+static char *dmu_get_ctl_device(char *dm_device)
+{
+	unsigned ctl_major, ctl_minor;
+	static char path[256];
+
+	if (get_dm_control_dev(dm_device, &ctl_major, &ctl_minor) < 0)
+		return NULL;
+
+	if (ctl_major =3D=3D 0) {
+		DPRINTF("Unable to get device number\n");
+		return NULL;
+	}
+
+	sprintf(path, "/dev/dmu%i", ctl_minor);
+
+	if (access(path, R_OK | W_OK)) {
+		if (make_device_node(ctl_major, ctl_minor)) {
+			DPRINTF("Failed to create device node: %s",
+				strerror(errno));
+			return NULL;
+		}
+	}
+
+	return path;
+}
+
+static void dmu_split_dev(dev_t dev, uint32_t *maj, uint32_t *min)
+{
+	*maj =3D (dev & 0xFF00) >> 8;
+	*min =3D (dev & 0x00FF);
+}
+
+static inline void ring_index_inc(struct uring *ring)
+{
+        ring->idx =3D (ring->idx =3D=3D DMU_MAX_EVENTS - 1) ? 0 : ring->=
idx + 1;
+}
+
+static inline struct dmu_msg *head_ring_hdr(struct uring *ring)
+{
+        uint32_t pidx, off, pos;
+
+        pidx =3D ring->idx / DMU_EVENT_PER_PAGE;
+        off =3D ring->idx % DMU_EVENT_PER_PAGE;
+        pos =3D pidx * PAGE_SIZE + off * sizeof(struct dmu_msg);
+
+        return (struct dmu_msg *) (ring->buf + pos);
+}
+
+/* Queue a message for sending */
+static int dmu_ctl_queue_msg(struct dmu_context *ctx, int type, void *ms=
gbuf)
+{
+	struct dmu_msg *msg;
+
+	msg =3D (struct dmu_msg *)head_ring_hdr(&ctx->ukring);
+	if (msg->hdr.status) {
+		DPRINTF("No room in ring, flushing...\n");
+		dmu_ctl_send_queue(ctx);
+
+		/* FIXME: Need a better way to wait for space to free up */
+		usleep(50000);
+
+		msg =3D (struct dmu_msg *)head_ring_hdr(&ctx->ukring);
+		if (msg->hdr.status) {
+			printf("#################### Still no room!\n");
+			return -ENOMEM;
+		}
+	}
+
+	msg->hdr.msg_type =3D type;
+	msg->hdr.id =3D ctx->id_ctr++;
+
+	memcpy(&msg->payload, msgbuf, sizeof(msg->payload));
+
+	ring_index_inc(&ctx->ukring);
+	msg->hdr.status =3D 1;
+	ctx->pending++;
+
+	return 1;
+}
+
+/* Flush queue of messages to the kernel */
+int dmu_ctl_send_queue(struct dmu_context *ctx)
+{
+	int r;
+
+	DPRINTF("Flushing outgoing queue\n");
+
+	r =3D write(ctx->fd, &r, 1);
+
+	ctx->pending =3D 0;
+
+	return r;
+}
+
+static int check_version(char *dev)
+{
+	struct dm_task *task;
+	struct dm_versions *target, *last;
+	int ret;
+
+	task =3D dm_task_create(DM_DEVICE_LIST_VERSIONS);
+
+	ret =3D dm_task_set_name(task, dev);
+	if (!ret) {
+		DPRINTF("Failed to set device-mapper target name\n");
+		dm_task_destroy(task);
+		return -1;
+	}
+
+	ret =3D dm_task_run(task);
+	if (!ret) {
+		DPRINTF("Failed to run device-mapper task\n");
+		dm_task_destroy(task);
+		return -1;
+	}
+
+	target =3D dm_task_get_versions(task);
+
+	do {
+		last =3D target;
+	=09
+		if (strcmp(target->name, "userspace") =3D=3D 0) {
+			DPRINTF("%s version: %i.%i.%i\n",
+				target->name,
+				target->version[0],
+				target->version[1],
+				target->version[2]);
+			break;
+		}
+
+		target =3D (void *) target + target->next;
+	} while (last !=3D target);
+
+	if (!target) {
+		DPRINTF("userspace target not found\n");
+		return -1;
+	}
+=09
+	if ((target->version[0] =3D=3D MAX_MAJ_VER) &&=20
+	    (target->version[1] =3D=3D MAX_MIN_VER))
+		return 1;
+	else
+		return 0; /* Unsupported */
+}
+
+struct dmu_context *dmu_ctl_open(char *dev, int flags)
+{
+	int fd, r;
+	struct dmu_context *ctx =3D NULL;
+	char *ctl_dev;
+	char *ringbuf;
+
+	r =3D check_version(dev);
+	if (r <=3D 0) {
+		return NULL;
+	}
+=09
+	ctl_dev =3D dmu_get_ctl_device(dev);
+	if (ctl_dev =3D=3D NULL)
+		return NULL;
+	else if (access(ctl_dev, R_OK | W_OK))
+		return NULL;
+
+	fd =3D open(ctl_dev, O_RDWR | flags);
+	if (fd < 0)
+		goto out;
+
+	ctx =3D calloc(sizeof(*ctx), 1);
+	if (!ctx)
+		goto out;
+
+	ctx->fd =3D fd;
+	ctx->id_ctr =3D 0;
+	memset(&ctx->events, 0, sizeof(ctx->events));
+	memset(&ctx->event_data, 0, sizeof(ctx->event_data));
+
+	ringbuf =3D mmap(NULL, DMU_RING_SIZE * 2, PROT_READ | PROT_WRITE,
+		       MAP_SHARED, fd, 0);
+        if (ringbuf =3D=3D MAP_FAILED) {
+                printf("fail to mmap, %m\n");
+                return NULL;
+        }
+
+	ctx->kuring.idx =3D ctx->ukring.idx =3D 0;
+	ctx->kuring.buf =3D ringbuf;
+	ctx->ukring.buf =3D ringbuf + DMU_RING_SIZE;
+
+	return ctx;
+
+ out:
+	if (ctx)
+		free(ctx);
+
+	return NULL;
+}
+
+int dmu_ctl_close(struct dmu_context *ctx)
+{
+	return close(ctx->fd);
+}
+
+void dmu_register_map_done_handler(struct dmu_context *ctx,
+				   map_done_handler_t handler,
+				   void *data)
+{
+	ctx->events.map_done_fn =3D handler;
+	ctx->event_data.map_done_user_data =3D data;
+}
+
+void dmu_register_map_handler(struct dmu_context *ctx,
+			      map_req_handler_t handler,
+			      void *data)
+{
+	ctx->events.map_fn =3D handler;
+	ctx->event_data.map_user_data =3D data;
+}
+
+int dmu_make_mapping(struct dmu_context *ctx,
+		     struct dmu_map_data *data)
+{
+	struct dmu_msg_make_mapping msg;
+	int r;
+
+	msg.org_block =3D data->org_block;
+	msg.new_block =3D data->block;
+	msg.offset =3D data->offset;
+	dmu_split_dev(data->dest_dev, &msg.dev_maj, &msg.dev_min);
+	msg.flags =3D 0;
+	dmu_cpy_flag(&msg.flags, data->flags, DMU_FLAG_WR);
+
+	r =3D dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAKE_MAPPING, &msg);
+
+	return r;
+}
+
+int dmu_kill_mapping(struct dmu_context *ctx,
+		     struct dmu_map_data *data)
+{
+	struct dmu_msg_make_mapping msg;
+	int r;
+
+	msg.org_block =3D data->org_block;
+
+	r =3D dmu_ctl_queue_msg(ctx, DM_USERSPACE_KILL_MAPPING, &msg);
+
+	return r;
+}
+
+int dmu_async_map_done(struct dmu_context *ctx, uint64_t id, int fail)
+{
+	struct dmu_msg_map_done msg;
+	int r;
+
+	msg.org_block =3D 0;
+	msg.flags =3D 0;
+	msg.id_of_op =3D id;
+
+	if (fail)
+		r =3D dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAP_DONE_FAILED, &msg);
+	else
+		r =3D dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAP_DONE, &msg);
+
+	return r;
+}
+
+int dmu_async_map(struct dmu_context *ctx,=20
+		  struct dmu_map_data *data,
+		  int fail)
+{
+	struct dmu_msg_map_response msg;
+	int r;
+
+	msg.new_block =3D data->block;
+	msg.offset =3D data->offset;
+	msg.flags =3D data->flags;
+	msg.id_of_req =3D data->id;
+
+	dmu_split_dev(data->copy_src_dev, &msg.src_maj, &msg.src_min);
+	dmu_split_dev(data->dest_dev, &msg.dst_maj, &msg.dst_min);
+
+	if (fail)
+		r =3D dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAP_FAILED, &msg);
+	else
+		r =3D dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAP_BLOCK_RESP, &msg);
+
+	return r;
+}
+
+int dmu_events_pending(struct dmu_context *ctx, unsigned int msec)
+{
+	fd_set fds;
+	struct timeval tv;
+
+	FD_ZERO(&fds);
+	FD_SET(ctx->fd, &fds);
+
+	tv.tv_sec =3D msec / 1000;
+	tv.tv_usec =3D (msec % 1000) * 1000;
+
+	if (select(ctx->fd + 1, &fds, NULL, NULL, &tv) < 0)
+		return 0;
+
+	if (FD_ISSET(ctx->fd, &fds))
+		return 1;
+	else
+		return 0;
+}
+
+static int fire_map_req_event(struct dmu_context *ctx,
+			      struct dmu_msg_map_request *req,
+			      uint64_t id)
+{
+	struct dmu_map_data data;
+	int ret;
+
+	if (!ctx->events.map_fn)
+		return 1;
+
+	DPRINTF("Map event for %llu %c\n",
+		req->org_block,
+		dmu_get_flag(&req->flags, DMU_FLAG_WR) ? 'W':'R');
+
+	data.block =3D req->org_block;
+	data.offset =3D 0;
+	data.id =3D id;
+	data.flags =3D req->flags;
+	data.dest_dev =3D data.copy_src_dev =3D 0;
+
+	dmu_clr_flag(&data.flags, DMU_FLAG_COPY_FIRST);
+	dmu_clr_flag(&data.flags, DMU_FLAG_SYNC);
+
+	ret =3D ctx->events.map_fn(ctx->event_data.map_user_data, &data);
+
+	if (ret !=3D 0) {
+		/* If the handler returns 0, we assume they will
+		 * complete the operation later=20
+		 */
+		dmu_async_map(ctx, &data, ret < 0);
+		DPRINTF("Mapped %llu\n", data.block);
+	}
+
+	return ret !=3D 0;
+}
+
+static int fire_map_done_event(struct dmu_context *ctx,
+			       struct dmu_msg_map_done *msg,
+			       uint64_t id)
+{
+	struct dmu_map_data data;
+	int ret =3D 1;
+
+	if (ctx->events.map_done_fn) {
+		data.block =3D msg->org_block;
+		data.offset =3D 0;
+		data.id =3D msg->id_of_op;
+		data.flags =3D msg->flags;
+		data.dest_dev =3D data.copy_src_dev =3D 0;
+	=09
+		ret =3D ctx->events.map_done_fn(ctx->event_data.map_done_user_data,=20
+					      &data);
+	}
+
+	if (ret > 0) {
+		/* If the handler returns 0, we assume they will
+		 * complete the operation later=20
+		 */
+		dmu_async_map_done(ctx, msg->id_of_op, ret < 0);
+		DPRINTF("Completed %llu (%llu)\n",=20
+			msg->org_block, msg->id_of_op);
+	}
+
+	return ret !=3D 0;
+}
+
+static int decode_message(struct dmu_context *ctx, int type, uint64_t id=
,
+			  uint8_t *msg)
+{
+	switch (type) {
+	case DM_USERSPACE_MAP_BLOCK_REQ:
+		DPRINTF("Request event: %u\n", id);
+		return fire_map_req_event(ctx,
+					  (struct dmu_msg_map_request *)msg,
+					  id);
+	case DM_USERSPACE_MAP_DONE:
+		DPRINTF("Map Done event\n");
+		return fire_map_done_event(ctx,
+					 (struct dmu_msg_map_done *)msg,
+					 id);
+	default:
+		printf("Unknown message type: %i\n", type);
+		return -1; /* Unknown message type */
+	};
+}
+
+static int dmu_process_event(struct dmu_context *ctx)
+{
+	struct dmu_msg *msg;
+	int ret;
+
+	msg =3D head_ring_hdr(&ctx->kuring);
+	if (!msg->hdr.status)
+		return -1;
+
+	ret =3D decode_message(ctx, msg->hdr.msg_type, msg->hdr.id,
+			     (uint8_t *)&msg->payload);
+
+	msg->hdr.status =3D 0;
+	ring_index_inc(&ctx->kuring);
+
+	return ret;
+}
+
+int dmu_process_events(struct dmu_context *ctx)
+{
+	int ret, do_flush =3D 1;
+	uint32_t count;
+
+	//DPRINTF("Processing events\n");
+
+	for (count =3D 0; count < DMU_MAX_EVENTS; count++) {
+		ret =3D dmu_process_event(ctx);
+	=09
+		if (ret > 0)
+			do_flush =3D 1;
+	}
+
+	DPRINTF("Pending events: %u\n", ctx->pending);
+	if (ctx->pending)
+		dmu_ctl_send_queue(ctx);
+
+	//DPRINTF("Finished processing events\n");
+
+	return 1;
+}
+
+int dmu_get_ctl_fd(struct dmu_context *ctx)
+{
+	return ctx->fd;
+}
diff -r 4b8428722a88 -r 436987ea3cbf lib/libdevmapper.h
- --- a/lib/libdevmapper.h	Wed Feb 14 15:12:14 2007 +0000
+++ b/lib/libdevmapper.h	Wed Feb 21 14:05:10 2007 -0800
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
  * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright IBM Corp., 2006
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -27,6 +28,7 @@
 #include <limits.h>
 #include <string.h>
 #include <stdlib.h>
+#include <stdint.h>
=20
 /*****************************************************************
  * The first section of this file provides direct access to the=20
@@ -711,4 +713,58 @@ void dm_report_field_set_value(struct dm
 void dm_report_field_set_value(struct dm_report_field *field, const void=
 *value,
 			       const void *sortvalue);
=20
+
+/**************
+ * dm-userspace
+ **************/
+
+struct dmu_context;
+struct dmu_map_data;
+
+/* Returns 1 to allow IO to complete, 0 to delay */
+typedef int (*map_done_handler_t)(void *data, struct dmu_map_data *map_d=
ata);
+
+/* Returns 1 to map IO, -1 to fail IO, 0 to delay */
+typedef int (*map_req_handler_t)(void *data, struct dmu_map_data *map_da=
ta);
+
+/* High-level control operations */
+struct dmu_context *dmu_ctl_open(char *dev, int flags);
+int dmu_ctl_close(struct dmu_context *ctx);
+int dmu_ctl_send_queue(struct dmu_context *ctx);
+void dmu_register_map_done_handler(struct dmu_context *ctx,
+				   map_done_handler_t handler,
+				   void *data);
+void dmu_register_map_handler(struct dmu_context *ctx,
+                              map_req_handler_t handler,
+                              void *data);
+int dmu_invalidate_block(struct dmu_context *ctx, uint64_t block);
+int dmu_events_pending(struct dmu_context *ctx, unsigned int msec);
+int dmu_process_events(struct dmu_context *ctx);
+int dmu_get_ctl_fd(struct dmu_context *ctx);
+
+/* Map manipulation functions */
+void dmu_map_set_block(struct dmu_map_data *data, uint64_t block);
+void dmu_map_set_origin_block(struct dmu_map_data *data, uint64_t block)=
;
+uint64_t dmu_map_get_block(struct dmu_map_data *data);
+void dmu_map_set_offset(struct dmu_map_data *data, int64_t offset);
+uint32_t dmu_map_get_id(struct dmu_map_data *data);
+void dmu_map_set_dest_dev(struct dmu_map_data *data, dev_t dev);
+void dmu_map_set_copy_src_dev(struct dmu_map_data *data, dev_t dev);
+int dmu_map_is_write(struct dmu_map_data *data);
+void dmu_map_set_sync(struct dmu_map_data *data);
+void dmu_map_set_writable(struct dmu_map_data *data, int rw);
+struct dmu_map_data *dmu_map_dup(struct dmu_map_data *data);
+
+/* Functions for submitting out-of-order events */
+int dmu_async_map(struct dmu_context *ctx,=20
+		  struct dmu_map_data *data,=20
+		  int fail);
+int dmu_async_map_done(struct dmu_context *ctx, uint64_t id, int fail);
+
+/* Functions to manipulate the kernel map cache */
+int dmu_make_mapping(struct dmu_context *ctx,
+		     struct dmu_map_data *data);
+int dmu_kill_mapping(struct dmu_context *ctx,
+		     struct dmu_map_data *data);
+
 #endif				/* LIB_DEVICE_MAPPER_H */
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF50nwwtEf7b4GJVQRAk2BAJ9pzHHGWm+aMg8c7pRkHHUdTLiSvQCfXZj/
U6hsxYh9wM+PzErWQE/ld+I=3D
=3DnoOb
-----END PGP SIGNATURE-----
