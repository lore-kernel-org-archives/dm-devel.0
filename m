From: Dan Smith <danms@us.ibm.com>
Subject: [PATCH] Add dm-userspace support to libdevmapper
Date: Thu, 27 Jul 2006 14:49:41 -0700
Message-ID: <m3bqrak9ai.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

This patch against device-mapper-1.02.07 adds dm-userspace support to
libdevmapper.  Comments on the interface it provides would be
appreciated.  The patch also adds an example program to contrib/ that
demonstrates simple usage of the dm-userspace functions provided.

I added a copyright line at the top of libdevmapper.h, as is customary
in the Xen community.  Please advise if this is not appropriate.

Signed-off-by: Dan Smith <danms@us.ibm.com>
Signed-off-by: Ryan Grimm <grimm@us.ibm.com>

diff -r 625e2e3552be -r 1a82e8ce64bc configure
--- a/configure	Mon Jul 17 09:10:04 2006 -0700
+++ b/configure	Thu Jul 27 10:30:09 2006 -0700
@@ -310,7 +310,7 @@ ac_includes_default="\
 #endif"
 
 ac_default_prefix=/usr
-ac_subst_vars='SHELL PATH_SEPARATOR PACKAGE_NAME PACKAGE_TARNAME PACKAGE_VERSION PACKAGE_STRING PACKAGE_BUGREPORT exec_prefix prefix program_transform_name bindir sbindir libexecdir datadir sysconfdir sharedstatedir localstatedir libdir includedir oldincludedir infodir mandir build_alias host_alias target_alias DEFS ECHO_C ECHO_N ECHO_T LIBS build build_cpu build_vendor build_os host host_cpu host_vendor host_os target target_cpu target_vendor target_os AWK CC CFLAGS LDFLAGS CPPFLAGS ac_ct_CC EXEEXT OBJEXT CPP EGREP INSTALL_PROGRAM INSTALL_SCRIPT INSTALL_DATA LN_S SET_MAKE RANLIB ac_ct_RANLIB LIBOBJS MSGFMT usrlibdir JOBS STATIC_LINK OWNER GROUP interface kerneldir missingkernel kernelvsn tmpdir COPTIMISE_FLAG CLDFLAGS LDDEPS LIB_SUFFIX DEBUG DM_LIB_VERSION COMPAT DMIOCTLS LOCALEDIR INTL_PACKAGE INTL DEVICE_UID DEVICE_GID DEVICE_MODE DMEVENTD PKGCONFIG LTLIBOBJS'
+ac_subst_vars='SHELL PATH_SEPARATOR PACKAGE_NAME PACKAGE_TARNAME PACKAGE_VERSION PACKAGE_STRING PACKAGE_BUGREPORT exec_prefix prefix program_transform_name bindir sbindir libexecdir datadir sysconfdir sharedstatedir localstatedir libdir includedir oldincludedir infodir mandir build_alias host_alias target_alias DEFS ECHO_C ECHO_N ECHO_T LIBS build build_cpu build_vendor build_os host host_cpu host_vendor host_os target target_cpu target_vendor target_os AWK CC CFLAGS LDFLAGS CPPFLAGS ac_ct_CC EXEEXT OBJEXT CPP EGREP INSTALL_PROGRAM INSTALL_SCRIPT INSTALL_DATA LN_S SET_MAKE RANLIB ac_ct_RANLIB LIBOBJS MSGFMT usrlibdir JOBS STATIC_LINK OWNER GROUP interface kerneldir missingkernel kernelvsn tmpdir COPTIMISE_FLAG CLDFLAGS LDDEPS LIB_SUFFIX DEBUG DM_LIB_VERSION COMPAT DMIOCTLS LOCALEDIR INTL_PACKAGE INTL DEVICE_UID DEVICE_GID DEVICE_MODE DMEVENTD PKGCONFIG DMU LTLIBOBJS'
 ac_subst_files=''
 
 # Initialize some variables set by options.
@@ -856,6 +856,7 @@ Optional Features:
                           statically.  Default is dynamic linking
   --disable-selinux       Disable selinux support
   --enable-nls            Enable Native Language Support
+  --disable-dmu        Disable dm-userspace support
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -1443,7 +1444,8 @@ case "$host_os" in
 		LDDEPS="$LDDEPS .export.sym"
 		LIB_SUFFIX="so"
 		DMIOCTLS="yes"
-		SELINUX="yes" ;;
+		SELINUX="yes"
+		DMU="yes" ;;
 	darwin*)
 		CFLAGS="$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG="-O2"
@@ -1451,7 +1453,8 @@ case "$host_os" in
 		LDDEPS="$LDDEPS"
 		LIB_SUFFIX="dylib"
 		DMIOCTLS="no"
-		SELINUX="no" ;;
+		SELINUX="no"
+		DMU="no" ;;
 esac
 
 ################################################################################
@@ -5885,6 +5888,26 @@ fi
 fi
 
 ################################################################################
+echo "$as_me:$LINENO: checking whether to enable dm-userspace" >&5
+echo $ECHO_N "checking whether to enable dm-userspace... $ECHO_C" >&6
+# Check whether --enable-dmu or --disable-dmu was given.
+if test "${enable_dmu+set}" = set; then
+  enableval="$enable_dmu"
+  DMU=$enableval
+fi;
+echo "$as_me:$LINENO: result: $DMU" >&5
+echo "${ECHO_T}$DMU" >&6
+
+if test "x${DMU}" = "xyes"; then
+	if test "x${missingkernel}" = xyes; then
+		{ { echo "$as_me:$LINENO: error: \"Kernel source required to build dm-userspace tools\"" >&5
+echo "$as_me: error: \"Kernel source required to build dm-userspace tools\"" >&2;}
+   { (exit 1); exit 1; }; }
+	fi
+fi
+
+
+################################################################################
 echo "$as_me:$LINENO: checking for kernel version" >&5
 echo $ECHO_N "checking for kernel version... $ECHO_C" >&6
 
@@ -5961,6 +5984,7 @@ fi
 
 
 ################################################################################
+
 
 
 
@@ -6672,6 +6696,7 @@ s,@DEVICE_MODE@,$DEVICE_MODE,;t t
 s,@DEVICE_MODE@,$DEVICE_MODE,;t t
 s,@DMEVENTD@,$DMEVENTD,;t t
 s,@PKGCONFIG@,$PKGCONFIG,;t t
+s,@DMU@,$DMU,;t t
 s,@LTLIBOBJS@,$LTLIBOBJS,;t t
 CEOF
 
diff -r 625e2e3552be -r 1a82e8ce64bc configure.in
--- a/configure.in	Mon Jul 17 09:10:04 2006 -0700
+++ b/configure.in	Thu Jul 27 10:30:09 2006 -0700
@@ -38,7 +38,8 @@ case "$host_os" in
 		LDDEPS="$LDDEPS .export.sym"
 		LIB_SUFFIX="so"
 		DMIOCTLS="yes"
-		SELINUX="yes" ;;
+		SELINUX="yes"
+		DMU="yes" ;;
 	darwin*)
 		CFLAGS="$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG="-O2"
@@ -46,7 +47,8 @@ case "$host_os" in
 		LDDEPS="$LDDEPS"
 		LIB_SUFFIX="dylib"
 		DMIOCTLS="no"
-		SELINUX="no" ;;
+		SELINUX="no"
+		DMU="no" ;;
 esac
 
 ################################################################################
@@ -291,6 +293,20 @@ else
 else
   test -d "${kerneldir}" || { AC_MSG_WARN(kernel dir $kerneldir not found); missingkernel=yes ; }
 fi
+
+################################################################################
+dnl -- Disable dm-userspace
+AC_MSG_CHECKING(whether to enable dm-userspace)
+AC_ARG_ENABLE(dmu, [  --disable-dmu        Disable dm-userspace support],
+DMU=$enableval)
+AC_MSG_RESULT($DMU)
+
+if test "x${DMU}" = "xyes"; then
+	if test "x${missingkernel}" = xyes; then
+		AC_ERROR("Kernel source required to build dm-userspace tools")
+	fi
+fi
+	
 
 ################################################################################
 dnl -- Kernel version string
@@ -383,6 +399,7 @@ AC_SUBST(DEVICE_MODE)
 AC_SUBST(DEVICE_MODE)
 AC_SUBST(DMEVENTD)
 AC_SUBST(PKGCONFIG)
+AC_SUBST(DMU)
 
 ################################################################################
 dnl -- First and last lines should not contain files to generate in order to 
diff -r 625e2e3552be -r 1a82e8ce64bc lib/.exported_symbols
--- a/lib/.exported_symbols	Mon Jul 17 09:10:04 2006 -0700
+++ b/lib/.exported_symbols	Thu Jul 27 10:30:09 2006 -0700
@@ -109,3 +109,21 @@ dm_hash_get_next
 dm_hash_get_next
 dm_set_selinux_context
 dm_task_set_geometry
+dmu_ctl_open
+dmu_ctl_close
+dmu_ctl_send_queue
+dmu_register_status_handler
+dmu_register_map_handler
+dmu_invalidate_block
+dmu_sync_complete
+dmu_events_pending
+dmu_process_events
+dmu_map_set_block
+dmu_map_get_block
+dmu_map_set_offset
+dmu_map_get_id
+dmu_map_set_dest_dev
+dmu_map_set_copy_src_dev
+dmu_map_set_writable
+dmu_map_is_write
+dmu_map_set_sync
diff -r 625e2e3552be -r 1a82e8ce64bc lib/Makefile.in
--- a/lib/Makefile.in	Mon Jul 17 09:10:04 2006 -0700
+++ b/lib/Makefile.in	Thu Jul 27 10:30:09 2006 -0700
@@ -16,6 +16,7 @@ top_srcdir = @top_srcdir@
 top_srcdir = @top_srcdir@
 VPATH = @srcdir@
 interface = @interface@
+kerneldir = @kerneldir@
 
 SOURCES =\
 	datastruct/bitset.c \
@@ -28,6 +29,11 @@ SOURCES =\
 	$(interface)/libdm-iface.c
 
 INCLUDES = -I$(interface)
+
+ifeq ("@DMU@", "yes")
+  INCLUDES += -I$(kerneldir)/include
+  SOURCES += dmu.c
+endif
 
 LIB_STATIC = $(interface)/libdevmapper.a
 
diff -r 625e2e3552be -r 1a82e8ce64bc lib/libdevmapper.h
--- a/lib/libdevmapper.h	Mon Jul 17 09:10:04 2006 -0700
+++ b/lib/libdevmapper.h	Thu Jul 27 10:30:09 2006 -0700
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
  * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) International Business Machines Corp., 2006
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -582,4 +583,49 @@ struct dm_hash_node *dm_hash_get_next(st
  *********/
 int dm_set_selinux_context(const char *path, mode_t mode);
 
+
+/**************
+ * dm-userspace
+ **************/
+
+enum {
+	DMU_STATUS_UNKNOWN = 0,
+	DMU_STATUS_BLOCK_FLUSHED,
+	DMU_STATUS_INVAL_COMPLETE,
+	DMU_STATUS_INVAL_FAILED,
+	DMU_STATUS_SYNC_COMPLETE
+};
+
+struct dmu_context;
+struct dmu_map_data;
+
+typedef int (*status_handler)(void *data, uint32_t id, uint32_t status);
+typedef int (*map_req_handler)(void *data, struct dmu_map_data *map_data);
+
+/* High-level control operations */
+struct dmu_context *dmu_ctl_open(char *dev, int flags);
+int dmu_ctl_close(struct dmu_context *ctx);
+int dmu_ctl_send_queue(struct dmu_context *ctx);
+void dmu_register_status_handler(struct dmu_context *ctx,
+				 status_handler handler,
+				 void *data);
+void dmu_register_map_handler(struct dmu_context *ctx,
+			      map_req_handler handler,
+			      void *data);
+int dmu_invalidate_block(struct dmu_context *ctx, uint64_t block);
+int dmu_sync_complete(struct dmu_context *ctx, uint32_t id);
+int dmu_events_pending(struct dmu_context *ctx, unsigned int msec);
+int dmu_process_events(struct dmu_context *ctx);
+
+/* Map manipulation functions */
+void dmu_map_set_block(struct dmu_map_data *data, uint64_t block);
+uint64_t dmu_map_get_block(struct dmu_map_data *data);
+void dmu_map_set_offset(struct dmu_map_data *data, int64_t offset);
+uint32_t dmu_map_get_id(struct dmu_map_data *data);
+void dmu_map_set_dest_dev(struct dmu_map_data *data, dev_t dev);
+void dmu_map_set_copy_src_dev(struct dmu_map_data *data, dev_t dev);
+void dmu_map_set_writable(struct dmu_map_data *data, int writable);
+int dmu_map_is_write(struct dmu_map_data *data);
+void dmu_map_set_sync(struct dmu_map_data *data);
+
 #endif				/* LIB_DEVICE_MAPPER_H */
diff -r 625e2e3552be -r 1a82e8ce64bc .hgtags
--- /dev/null	Thu Jan  1 00:00:00 1970 +0000
+++ b/.hgtags	Thu Jul 27 10:30:09 2006 -0700
@@ -0,0 +1,2 @@
+625e2e3552bec3a9efd9f7f87c6f5fc41d7cacb8 ORIG
+3bf96d9f87d98ee8c402fb4cf3ed503cc0577048 PRE_IO_COMP
diff -r 625e2e3552be -r 1a82e8ce64bc contrib/dmu-example.c
--- /dev/null	Thu Jan  1 00:00:00 1970 +0000
+++ b/contrib/dmu-example.c	Thu Jul 27 10:30:09 2006 -0700
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) International Business Machines Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * This file is subject to the terms and conditions of the GNU Lesser
+ * General Public License. See the file COPYING in the main directory
+ * of this archive for more details.
+ *
+ */
+/*
+ * This example program demonstrates a trivial use of the dmu pieces
+ * of the libdevmapper library for userspace orchestration of a
+ * device-mapper pseudo-device.  To compile:
+ *
+ *  # gcc -ldevmapper -o dmu-example dmu-example.c
+ *
+ * Here, we simply map all reads and writes to the device given as the
+ * first argument to the program.  For example:
+ *
+ *  # ./dmu-example /dev/ram0
+ *
+ * will create a device /dev/mapper/foo in which all accesses are
+ * redirected to /dev/ram0.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include <libdevmapper.h>
+
+dev_t destination_dev;
+
+int map_handler(void *data, struct dmu_map_data *map_data)
+{
+	dmu_map_set_writable(map_data, 1);
+
+	/* We leave block pointing to the original location, but
+	 * change the destination device 
+	 */
+	dmu_map_set_dest_dev(map_data, destination_dev);
+	
+	printf("[%u] Mapping %llu -> 0x%llx\n",
+	       dmu_map_get_id(map_data),
+	       dmu_map_get_block(map_data),
+	       destination_dev);
+	
+	/* Return nonzero to flush outgoing messages back to
+	 * dm-userspace after processing 
+	 */
+	return 1;
+}
+
+int main(int argc, char **argv)
+{
+	struct dmu_context *c;
+	struct stat s;
+	char cmd[256];
+
+	if (argc != 2) {
+		printf("Usage: %s <device>\n", argv[0]);
+		exit(1);
+	}
+
+	printf("I'm creating a device-mapper device called 'foo'.  \n"
+	       "Be sure to remove it when you're done with this example\n"
+	       "program! (run 'dmsetup remove foo')\n");
+
+	/* Determine and record our destination device for mappings */
+	stat(argv[1], &s);
+	destination_dev = s.st_rdev;
+
+	/* Create a very simple device-mapper device with a small
+	 * section of sectors mapped to dm-userspace, at 512-byte
+	 * blocks
+	 */
+	sprintf(cmd,
+		"echo 0 8192 userspace foo 4096 %i:%i | dmsetup create foo",
+		(unsigned)(destination_dev & 0xFF00) >> 8,
+		(unsigned)(destination_dev & 0x00FF));
+	system(cmd);
+
+	/* Open the control device for the device-mapper device 'foo' */
+	c = dmu_ctl_open("foo", 0);
+	if (!c) {
+		printf("Failed to get control device\n");
+		exit(1);
+	}
+
+	/* Register our callback function for handling map events */
+	dmu_register_map_handler(c, map_handler, NULL);
+
+	while (1) {
+		if (dmu_events_pending(c, 1000)) {
+			printf("Processing events...\n");
+			dmu_process_events(c);
+		} else {
+			printf("Nothing to do\n");
+		}
+	}
+}
diff -r 625e2e3552be -r 1a82e8ce64bc lib/dmu.c
--- /dev/null	Thu Jan  1 00:00:00 1970 +0000
+++ b/lib/dmu.c	Thu Jul 27 10:30:09 2006 -0700
@@ -0,0 +1,552 @@
+/*
+ * Copyright (C) International Business Machines Corp., 2006
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
+
+#define DMU_MSG_DEBUG 0
+
+#define QUEUE_SIZE_KB 4096
+
+#if DMU_MSG_DEBUG
+#define DPRINTF( s, arg... ) fprintf(stderr, s, ##arg)
+#else
+#define DPRINTF( s, arg... )
+#endif
+
+struct dmu_events {
+	status_handler status_fn;
+	map_req_handler map_fn;
+};
+
+struct dmu_event_data {
+	void *status_user_data;
+	void *map_user_data;
+};
+
+struct dmu_context {
+	int fd;
+	unsigned int buf_size;
+	unsigned int in_ptr;
+	unsigned int out_ptr;
+	uint8_t *in_buf;
+	uint8_t *out_buf;
+	uint32_t id_ctr;
+	struct dmu_events events;
+	struct dmu_event_data event_data;
+};
+
+struct dmu_map_data {
+	uint64_t block;
+	int64_t offset;
+	uint32_t id;
+	uint32_t flags;
+	dev_t dest_dev;
+	dev_t copy_src_dev;
+};
+
+void dmu_map_set_block(struct dmu_map_data *data, uint64_t block)
+{
+	data->block = block;
+}
+
+uint64_t dmu_map_get_block(struct dmu_map_data *data)
+{
+	return data->block;
+}
+
+void dmu_map_set_offset(struct dmu_map_data *data, int64_t offset)
+{
+	data->offset = offset;
+}
+
+uint32_t dmu_map_get_id(struct dmu_map_data *data)
+{
+	return data->id;
+}
+
+void dmu_map_set_dest_dev(struct dmu_map_data *data, dev_t dev)
+{
+	data->dest_dev = dev;
+}
+
+void dmu_map_set_copy_src_dev(struct dmu_map_data *data, dev_t dev)
+{
+	data->copy_src_dev = dev;
+	dmu_set_flag(&data->flags, DMU_FLAG_COPY_FIRST);
+}
+
+void dmu_map_set_writable(struct dmu_map_data *data, int writable)
+{
+	if (writable)
+		dmu_set_flag(&data->flags, DMU_FLAG_WR);
+	else
+		dmu_clr_flag(&data->flags, DMU_FLAG_WR);
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
+	void *next = NULL;
+	uint64_t start, length;
+	char *ttype = NULL, *params = NULL;
+
+	task = dm_task_create(DM_DEVICE_STATUS);
+
+	ret = dm_task_set_name(task, dm_device);
+	if (!ret) {
+		DPRINTF("Failed to set device-mapper target name\n");
+		dm_task_destroy(task);
+		return -1;
+	}
+
+	ret = dm_task_run(task);
+	if (!ret) {
+		DPRINTF("Failed to run device-mapper task\n");
+		dm_task_destroy(task);
+		return -1;
+	}
+
+	ret = 0;
+	do {
+		next = dm_get_next_target(task, next, &start, &length,
+					  &ttype, &params);
+
+		if (strcmp(ttype, "userspace") == 0) {
+			ret = sscanf(params, "%x:%x", maj, min);
+			if (ret == 2)
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
+	if (ctl_major == 0) {
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
+static uint32_t make_version(int maj, int min, int patch)
+{
+	return 0 | (maj << 16) | (min << 8) | patch;
+}
+
+static void dmu_split_dev(dev_t dev, uint32_t *maj, uint32_t *min)
+{
+	*maj = (dev & 0xFF00) >> 8;
+	*min = (dev & 0x00FF);
+}
+
+/* Queue a message for sending */
+static int dmu_ctl_queue_msg(struct dmu_context *ctx, int type, void *msg)
+{
+	struct dmu_msg_header hdr;
+
+	hdr.msg_type = type;
+	hdr.payload_len = dmu_get_msg_len(type);
+	hdr.id = ctx->id_ctr++;
+
+	if ((ctx->out_ptr + (sizeof(hdr) + hdr.payload_len)) > ctx->buf_size)
+		return 0; /* No room for this */
+
+	memcpy(ctx->out_buf+ctx->out_ptr, &hdr, sizeof(hdr));
+	ctx->out_ptr += sizeof(hdr);
+
+	memcpy(ctx->out_buf+ctx->out_ptr, msg, hdr.payload_len);
+	ctx->out_ptr += hdr.payload_len;
+
+	return 1;
+}
+
+int dmu_invalidate_block(struct dmu_context *ctx, uint64_t block)
+{
+	struct dmu_msg_invalidate_map inv_msg;
+
+	inv_msg.org_block = block;
+
+	DPRINTF("Queuing invalidation for block %llu\n", block);
+
+	return dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAP_INVALIDATE,
+				 &inv_msg);
+}
+
+int dmu_sync_complete(struct dmu_context *ctx, uint32_t id)
+{
+	struct dmu_msg_status status_msg;
+
+	status_msg.id_of_op = id;
+	status_msg.status = DM_USERSPACE_SYNC_COMPLETE;
+
+	DPRINTF("Queuing metadata written for block %llu\n", block);
+
+	return dmu_ctl_queue_msg(ctx, DM_USERSPACE_STATUS,
+				 &status_msg);
+}
+
+static int dmu_ctl_peek_queue(struct dmu_context *ctx,
+			      int *type, void **msg)
+{
+	struct dmu_msg_header *hdr;
+
+	if (ctx->in_ptr < sizeof(*hdr))
+		return 0;
+
+	hdr = (struct dmu_msg_header *)ctx->in_buf;
+
+	*type = hdr->msg_type;
+	*msg = ctx->in_buf + sizeof(*hdr);
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
+	r = write(ctx->fd, ctx->out_buf, ctx->out_ptr);
+
+	if (r == ctx->out_ptr)
+		r = 1;
+	else
+		r = 0;
+
+	ctx->out_ptr = 0;
+
+	DPRINTF("Finished flushing queue\n");
+
+	return r;
+}
+
+/* Fill the queue with requests from the kernel */
+static int dmu_ctl_recv_queue(struct dmu_context *ctx)
+{
+	int r;
+
+	r = read(ctx->fd, ctx->in_buf, ctx->buf_size);
+
+	ctx->in_ptr = r;
+
+	if (r >= 0)
+		r = 1;
+	else
+		r = 0;
+
+	return r;
+}
+
+struct dmu_context *dmu_ctl_open(char *dev, int flags)
+{
+	int fd, r, type = 0;
+	struct dmu_msg_version msg;
+	struct dmu_msg_version *response;
+	struct dmu_context *ctx = NULL;
+	char *ctl_dev;
+	
+	ctl_dev = dmu_get_ctl_device(dev);
+	if (ctl_dev == NULL)
+		return NULL;
+	else if (access(ctl_dev, R_OK | W_OK))
+		return NULL;
+
+	fd = open(ctl_dev, O_RDWR | flags);
+	if (fd < 0)
+		goto out;
+
+	ctx = calloc(sizeof(*ctx), 1);
+	if (!ctx)
+		goto out;
+
+	ctx->in_buf = malloc(QUEUE_SIZE_KB << 10);
+	if (!ctx->in_buf)
+		goto out;
+	ctx->out_buf = malloc(QUEUE_SIZE_KB << 10);
+	if (!ctx->out_buf)
+		goto out;
+
+	ctx->fd = fd;
+	ctx->in_ptr = ctx->out_ptr = 0;
+	ctx->id_ctr = 0;
+	ctx->buf_size = 4 << 20;
+	memset(&ctx->events, 0, sizeof(ctx->events));
+	memset(&ctx->event_data, 0, sizeof(ctx->event_data));
+
+	msg.userspace_ver = make_version(0, 1, 0);
+
+	r = dmu_ctl_queue_msg(ctx, DM_USERSPACE_GET_VERSION, &msg);
+	if (r < 0)
+		goto out;
+
+	dmu_ctl_send_queue(ctx);
+	dmu_ctl_recv_queue(ctx);
+
+	r = dmu_ctl_peek_queue(ctx, &type, (void**)&response);
+	if (r < 0)
+		goto out;
+
+	if (type != DM_USERSPACE_GET_VERSION) {
+		DPRINTF(stderr, "Got non-version ping back: %i\n", type);
+		goto out;
+	}
+
+	if (response->kernel_ver != msg.userspace_ver) {
+		DPRINTF(stderr, "Version mismatch: %x != %x\n",
+			msg.userspace_ver, response->kernel_ver);
+		goto out;
+	} else {
+		DPRINTF("Version match: %x == %x\n",
+			msg.userspace_ver, response->kernel_ver);
+	}
+
+	return ctx;
+
+ out:
+	if (ctx && ctx->in_buf)
+		free(ctx->in_buf);
+
+	if (ctx && ctx->out_buf)
+		free(ctx->out_buf);
+
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
+void dmu_register_status_handler(struct dmu_context *ctx,
+				 status_handler handler,
+				 void *data)
+{
+	ctx->events.status_fn = handler;
+	ctx->event_data.status_user_data = data;
+}
+
+void dmu_register_map_handler(struct dmu_context *ctx,
+			      map_req_handler handler,
+			      void *data)
+{
+	ctx->events.map_fn = handler;
+	ctx->event_data.map_user_data = data;
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
+	tv.tv_sec = msec / 1000;
+	tv.tv_usec = (msec % 1000) * 1000;
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
+			      uint32_t id)
+{
+	struct dmu_msg_map_response resp;
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
+	data.block = req->org_block;
+	data.offset = 0;
+	data.id = id;
+	data.flags = req->flags;
+	data.dest_dev = data.copy_src_dev = 0;
+
+	dmu_clr_flag(&data.flags, DMU_FLAG_COPY_FIRST);
+	dmu_clr_flag(&data.flags, DMU_FLAG_SYNC);
+
+	ret = ctx->events.map_fn(ctx->event_data.map_user_data, &data);
+
+	resp.org_block = req->org_block;
+	resp.new_block = data.block;
+	resp.offset = data.offset;
+	resp.flags = data.flags;
+	resp.id_of_req = data.id;
+
+	dmu_split_dev(data.copy_src_dev, &resp.src_maj, &resp.src_min);
+	dmu_split_dev(data.dest_dev, &resp.dst_maj, &resp.dst_min);
+
+	DPRINTF("Mapped %llu -> %llu\n", resp.org_block, resp.new_block);
+
+	if (ret < 0)
+		dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAP_FAILED, &resp);
+	else
+		dmu_ctl_queue_msg(ctx, DM_USERSPACE_MAP_BLOCK_RESP, &resp);
+
+	return ret;
+}
+
+static int fire_status_event(struct dmu_context *ctx,
+			     struct dmu_msg_status *status,
+			     uint32_t id)
+{
+	uint32_t user_code;
+
+	switch (status->status) {
+	case DM_USERSPACE_INVAL_COMPLETE:
+		user_code = DMU_STATUS_INVAL_COMPLETE;
+		break;
+	case DM_USERSPACE_INVAL_FAILED:
+		user_code = DMU_STATUS_INVAL_FAILED;
+		break;
+	case DM_USERSPACE_SYNC_COMPLETE:
+		user_code = DMU_STATUS_SYNC_COMPLETE;
+		break;
+	default:
+		user_code = DMU_STATUS_UNKNOWN;
+	};
+
+	if (ctx->events.status_fn)
+		ctx->events.status_fn(ctx->event_data.status_user_data,
+				      status->id_of_op, user_code);
+
+	return 0;
+}
+
+static int decode_message(struct dmu_context *ctx, int type, uint32_t id,
+			  uint8_t *msg)
+{
+	switch (type) {
+	case DM_USERSPACE_MAP_BLOCK_REQ:
+		DPRINTF("Request event: %u\n", id);
+		return fire_map_req_event(ctx,
+					  (struct dmu_msg_map_request *)msg,
+					  id);
+	case DM_USERSPACE_STATUS:
+		DPRINTF("Status event\n");
+		return fire_status_event(ctx,
+					 (struct dmu_msg_status *)msg,
+					 id);
+	default:
+		DPRINTF("Unknown message type: %i\n", type);
+		return -1; /* Unknown message type */
+	};
+}
+
+int dmu_process_events(struct dmu_context *ctx)
+{
+	struct dmu_msg_header *hdr;
+	int ptr = 0, ret, do_flush = 0;
+
+	if (!dmu_ctl_recv_queue(ctx))
+		return -1; /* Receive failed */
+
+	DPRINTF("Got %i bytes\n", ctx->in_ptr);
+
+	ptr = 0;
+	while (ptr < ctx->in_ptr) {
+		hdr = (struct dmu_msg_header *)&ctx->in_buf[ptr];
+		ptr += sizeof(*hdr);
+
+		ret = decode_message(ctx, hdr->msg_type, hdr->id,
+				     &ctx->in_buf[ptr]);
+		if (ret > 0)
+			do_flush = 1;
+
+		ptr += hdr->payload_len;
+	};
+
+	ctx->in_ptr = 0;
+
+	if (do_flush) {
+		DPRINTF("Flushing outgoing message queue as requested\n");
+		dmu_ctl_send_queue(ctx);
+	}
+
+	return 1;
+}
+

-- 
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
