From: agk@sourceware.org
Subject: device-mapper/lib libdm-common.c
Date: 30 Nov 2007 16:42:27 -0000
Message-ID: <20071130164227.9098.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-11-30 16:42:26

Modified files:
	lib            : libdm-common.c 

Log message:
	readahead support completed - untested

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.49&r2=1.50

--- device-mapper/lib/libdm-common.c	2007/11/30 14:59:57	1.49
+++ device-mapper/lib/libdm-common.c	2007/11/30 16:42:26	1.50
@@ -21,9 +21,14 @@
 
 #include <stdarg.h>
 #include <sys/param.h>
+#include <fcntl.h>
 
 #include <linux/dm-ioctl.h>
 
+#ifdef linux
+#  include <linux/fs.h>
+#endif
+
 #ifdef HAVE_SELINUX
 #  include <selinux/selinux.h>
 #endif
@@ -356,16 +361,61 @@
 	return 1;
 }
 
+#ifdef linux
+static int _open_dev_node(const char *dev_name)
+{
+	int fd = -1;
+	char path[PATH_MAX];
+
+	_build_dev_path(path, sizeof(path), dev_name);
+
+	if ((fd = open(path, O_RDONLY, 0)) < 0)
+		log_sys_error("open", path);
+
+	return fd;
+}
+
 int get_dev_node_read_ahead(const char *dev_name, uint32_t *read_ahead)
 {
+	int r = 1;
+	int fd;
+
+	if ((fd = _open_dev_node(dev_name)) < 0)
+		; // return_0;
+
 	*read_ahead = 0;
 
-	return 1;
+	if (!ioctl(fd, BLKRAGET, read_ahead)) {
+		log_sys_error("BLKRAGET", dev_name);
+		r = 0;
+	}  else
+		log_debug("%s: read ahead is %" PRIu32, dev_name, *read_ahead);
+
+	if (!close(fd))
+		stack;
+
+	return r;
 }
 
 static int _set_read_ahead(const char *dev_name, uint32_t read_ahead)
 {
-	return 1;
+	int r = 1;
+	int fd;
+
+	if ((fd = _open_dev_node(dev_name)) < 0)
+		return_0;
+
+	log_debug("%s: Setting read ahead to %" PRIu32, dev_name, read_ahead);
+
+	if (ioctl(fd, BLKRASET, read_ahead)) {
+		log_sys_error("BLKRASET", dev_name);
+		r = 0;
+	}
+
+	if (!close(fd))
+		stack;
+
+	return r;
 }
 
 static int _set_dev_node_read_ahead(const char *dev_name, uint32_t read_ahead,
@@ -394,6 +444,22 @@
 	return _set_read_ahead(dev_name, read_ahead);
 }
 
+#else
+
+int get_dev_node_read_ahead(const char *dev_name, uint32_t *read_ahead)
+{
+	*read_ahead = 0;
+
+	return 1;
+}
+
+static int _set_dev_node_read_ahead(const char *dev_name, uint32_t read_ahead,
+				    uint32_t read_ahead_flags)
+{
+	return 1;
+}
+#endif
+
 typedef enum {
 	NODE_ADD,
 	NODE_DEL,
