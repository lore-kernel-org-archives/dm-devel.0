From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 27 Apr 2007 14:52:41 -0000
Message-ID: <20070427145241.3512.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-04-27 15:52:41

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : libdevmapper.h libdm-string.c 
	lib/datastruct : hash.c 
	lib/ioctl      : libdm-iface.c 

Log message:
	Deal with some more compiler warnings.  Hope this doesn't break anything...

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.176&r2=1.177
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.87&r2=1.88
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.68&r2=1.69
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-string.c.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/hash.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.41&r2=1.42

--- device-mapper/WHATS_NEW	2007/04/23 15:06:03	1.176
+++ device-mapper/WHATS_NEW	2007/04/27 14:52:40	1.177
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Deal with some more compiler warnings.
   Introduce _add_field() and _is_same_field() to libdm-report.c.
   Fix some libdevmapper-event and dmeventd memory leaks.
   Remove unnecessary memset() return value checks.
--- device-mapper/dmsetup/dmsetup.c	2007/02/14 15:12:16	1.87
+++ device-mapper/dmsetup/dmsetup.c	2007/04/27 14:52:40	1.88
@@ -749,7 +749,7 @@
 	if (!_set_task_device(dmt, name, 0))
 		goto error;
 
-	if (!dm_task_add_target(dmt, 0, size, "error", ""))
+	if (!dm_task_add_target(dmt, UINT64_C(0), size, "error", ""))
 		goto error;
 
 	if (_switches[READ_ONLY] && !dm_task_set_ro(dmt))
@@ -1261,10 +1261,10 @@
 	}
 }
 
-static void _out_string(const unsigned char *str)
+static void _out_string(const char *str)
 {
 	while (*str)
-		_out_char(*str++);
+		_out_char((unsigned char) *str++);
 }
 
 /* non-negative integers only */
@@ -1502,7 +1502,7 @@
 			 struct dm_report_field *field, const void *data,
 			 void *private __attribute((unused)))
 {
-	const char *name = dm_task_get_name((struct dm_task *) data);
+	const char *name = dm_task_get_name((const struct dm_task *) data);
 
 	return dm_report_field_string(rh, field, &name);
 }
@@ -1512,7 +1512,7 @@
 			 struct dm_report_field *field,
 			 const void *data, void *private __attribute((unused)))
 {
-	const char *uuid = dm_task_get_uuid((struct dm_task *) data);
+	const char *uuid = dm_task_get_uuid((const struct dm_task *) data);
 
 	if (!uuid || !*uuid)
 		uuid = "";
@@ -1527,7 +1527,7 @@
 {
 	char buf[5];
 	const char *s = buf;
-	struct dm_info *info = (struct dm_info *) data;
+	const struct dm_info *info = data;
 
 	buf[0] = info->live_table ? 'L' : '-';
 	buf[1] = info->inactive_table ? 'I' : '-';
@@ -1767,7 +1767,7 @@
 {
 	const char *s, *end;
 	struct winsize winsz;
-	int len;
+	size_t len;
 
 	/* Symbol set default */
 	if (!strcmp(nl_langinfo(CODESET), "UTF-8"))
@@ -1823,7 +1823,7 @@
 
 	/* Truncation doesn't work well with vt100 drawing char */
 	if (_tsym != &_tsym_vt100)
-		if (ioctl(1, TIOCGWINSZ, &winsz) >= 0 && winsz.ws_col > 3)
+		if (ioctl(1, (unsigned long) TIOCGWINSZ, &winsz) >= 0 && winsz.ws_col > 3)
 			_termwidth = winsz.ws_col - 3;
 
 	return 1;
@@ -1860,13 +1860,13 @@
 		if (strncmp(device, DEV_PATH, strlen(DEV_PATH)))
 			goto error;
 
-		strncpy(buf, strrchr(device, '/') + 1, PATH_MAX);
+		strncpy(buf, strrchr(device, '/') + 1, (size_t) PATH_MAX);
 		dm_free(device);
 
 	} else {
 		/* check for device number */
 		if (!strncmp(dev, "loop", strlen("loop")))
-			strncpy(buf, dev, PATH_MAX);
+			strncpy(buf, dev, (size_t) PATH_MAX);
 		else
 			goto error;
 	}
@@ -1909,8 +1909,9 @@
 	sectors = size >> SECTOR_SHIFT;
 
 	if (_switches[VERBOSE_ARG])
-		fprintf(stderr, "losetup: set loop size to %llukB (%llu sectors)\n",
-			sectors >> 1, sectors);
+		fprintf(stderr, "losetup: set loop size to %llukB "
+			"(%llu sectors)\n", (long long unsigned) sectors >> 1,
+			(long long unsigned) sectors);
 
 #ifdef HAVE_SYS_STATVFS_H
 	if (fstatvfs(fd, &fsbuf))
@@ -2034,7 +2035,7 @@
 
 	/* FIXME Missing free */
 	_table = dm_malloc(LOOP_TABLE_SIZE);
-	if (!_loop_table(_table, LOOP_TABLE_SIZE, loop_file, device_name, offset)) {
+	if (!_loop_table(_table, (size_t) LOOP_TABLE_SIZE, loop_file, device_name, offset)) {
 		fprintf(stderr, "Could not build device-mapper table for %s\n", (*argv)[0]);
 		dm_free(device_name);
 		return 0;
--- device-mapper/lib/libdevmapper.h	2007/01/29 17:23:54	1.68
+++ device-mapper/lib/libdevmapper.h	2007/04/27 14:52:40	1.69
@@ -133,8 +133,8 @@
 int dm_get_library_version(char *version, size_t size);
 int dm_task_get_driver_version(struct dm_task *dmt, char *version, size_t size);
 int dm_task_get_info(struct dm_task *dmt, struct dm_info *dmi);
-const char *dm_task_get_name(struct dm_task *dmt);
-const char *dm_task_get_uuid(struct dm_task *dmt);
+const char *dm_task_get_name(const struct dm_task *dmt);
+const char *dm_task_get_uuid(const struct dm_task *dmt);
 
 struct dm_deps *dm_task_get_deps(struct dm_task *dmt);
 struct dm_names *dm_task_get_names(struct dm_task *dmt);
--- device-mapper/lib/libdm-string.c	2007/01/22 15:03:57	1.7
+++ device-mapper/lib/libdm-string.c	2007/04/27 14:52:40	1.8
@@ -117,7 +117,7 @@
 	n = vsnprintf(buf, bufsize, format, ap);
 	va_end(ap);
 
-	if (n < 0 || (n > bufsize - 1))
+	if (n < 0 || ((unsigned) n + 1 > bufsize))
 		return -1;
 
 	return n;
--- device-mapper/lib/datastruct/hash.c	2007/01/22 15:03:57	1.5
+++ device-mapper/lib/datastruct/hash.c	2007/04/27 14:52:40	1.6
@@ -68,14 +68,14 @@
 	return n;
 }
 
-static unsigned long _hash(const unsigned char *str, unsigned len)
+static unsigned long _hash(const char *str, unsigned len)
 {
 	unsigned long h = 0, g;
 	unsigned i;
 
 	for (i = 0; i < len; i++) {
 		h <<= 4;
-		h += _nums[*str++];
+		h += _nums[(unsigned char) *str++];
 		g = h & ((unsigned long) 0xf << 16u);
 		if (g) {
 			h ^= g >> 16u;
--- device-mapper/lib/ioctl/libdm-iface.c	2007/01/25 14:16:20	1.41
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/04/27 14:52:41	1.42
@@ -433,12 +433,12 @@
 	return 1;
 }
 
-static const char *_dm_task_get_name_v1(struct dm_task *dmt)
+static const char *_dm_task_get_name_v1(const struct dm_task *dmt)
 {
 	return (dmt->dmi.v1->name);
 }
 
-static const char *_dm_task_get_uuid_v1(struct dm_task *dmt)
+static const char *_dm_task_get_uuid_v1(const struct dm_task *dmt)
 {
 	return (dmt->dmi.v1->uuid);
 }
@@ -924,7 +924,7 @@
 	return 1;
 }
 
-const char *dm_task_get_name(struct dm_task *dmt)
+const char *dm_task_get_name(const struct dm_task *dmt)
 {
 #ifdef DM_COMPAT
 	if (_dm_version == 1)
@@ -934,7 +934,7 @@
 	return (dmt->dmi.v4->name);
 }
 
-const char *dm_task_get_uuid(struct dm_task *dmt)
+const char *dm_task_get_uuid(const struct dm_task *dmt)
 {
 #ifdef DM_COMPAT
 	if (_dm_version == 1)
@@ -1555,7 +1555,7 @@
 		dmi->flags |= DM_SKIP_BDGET_FLAG;
 
 	log_debug("dm %s %s %s%s%s %s%.0d%s%.0d%s"
-		  "%s%c%c%s %.0llu %s [%u]",
+		  "%s%c%c%s %.0" PRIu64 " %s [%u]",
 		  _cmd_data_v4[dmt->type].name,
 		  dmi->name, dmi->uuid, dmt->newname ? " " : "",
 		  dmt->newname ? dmt->newname : "",
