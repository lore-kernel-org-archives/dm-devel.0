From: agk@sourceware.org
Subject: device-mapper dmeventd/dmeventd.c dmeventd/lib ...
Date: 16 Jan 2007 21:13:08 -0000
Message-ID: <20070116211308.10387.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-16 21:13:08

Modified files:
	dmeventd       : dmeventd.c libdevmapper-event.c 
	dmsetup        : dmsetup.c 
	lib            : libdm-report.c 

Log message:
	more little fixes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.37&r2=1.38
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.16&r2=1.17
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.75&r2=1.76
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.1&r2=1.2

--- device-mapper/dmeventd/dmeventd.c	2007/01/16 20:27:07	1.37
+++ device-mapper/dmeventd/dmeventd.c	2007/01/16 21:13:07	1.38
@@ -246,7 +246,7 @@
  */
 /* FIXME? move to libdevmapper to share with the client lib (need to
    make delimiter a parameter then) */
-static int _fetch_string(char **ptr, char **src, const char delimiter)
+static int _fetch_string(char **ptr, char **src, const int delimiter)
 {
 	int ret = 0;
 	char *p;
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/16 18:03:40	1.16
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/16 21:13:07	1.17
@@ -262,6 +262,7 @@
 	const char *dso = dso_name ? dso_name : "";
 	const char *dev = dev_name ? dev_name : "";
 	const char *fmt = "%s %s %u %" PRIu32;
+	int msg_size;
 	memset(msg, 0, sizeof(*msg));
 
 	/*
@@ -269,10 +270,12 @@
 	 * into ASCII message string.
 	 */
 	msg->cmd = cmd;
-	if ((msg->size = dm_asprintf(&(msg->data), fmt, dso, dev, evmask,
+	if ((msg_size = dm_asprintf(&(msg->data), fmt, dso, dev, evmask,
 				     timeout)) < 0) {
 		log_error("_daemon_talk: message allocation failed");
+		return -ENOMEM;
 	}
+	msg->size = msg_size;
 
 	/*
 	 * Write command and message to and
@@ -535,7 +538,7 @@
 
 /* Fetch a string off src and duplicate it into *dest. */
 /* FIXME: move to separate module to share with the daemon. */
-static char *_fetch_string(char **src, const char delimiter)
+static char *_fetch_string(char **src, const int delimiter)
 {
 	char *p, *ret;
 
--- device-mapper/dmsetup/dmsetup.c	2007/01/15 22:05:50	1.75
+++ device-mapper/dmsetup/dmsetup.c	2007/01/16 21:13:07	1.76
@@ -1673,7 +1673,7 @@
 	char *buf;
 	char *device;
 
-	if (!(buf = dm_malloc(PATH_MAX)));
+	if (!(buf = dm_malloc(PATH_MAX)))
 		return NULL;
 
 	if (dev[0] == '/') {
--- device-mapper/lib/libdm-report.c	2007/01/16 18:04:15	1.1
+++ device-mapper/lib/libdm-report.c	2007/01/16 21:13:07	1.2
@@ -60,7 +60,7 @@
 	struct list list;
 	uint32_t field_num;
 	uint32_t sort_posn;
-	int width;
+	unsigned width;
 	const struct dm_report_object_type *type;
 	uint32_t flags;
 };
@@ -667,7 +667,7 @@
 	const struct row *rowa = *(const struct row **) a;
 	const struct row *rowb = *(const struct row **) b;
 	const struct dm_report_field *sfa, *sfb;
-	int32_t cnt = -1;
+	uint32_t cnt;
 
 	for (cnt = 0; cnt < rowa->rh->keys_count; cnt++) {
 		sfa = (*rowa->sort_fields)[cnt];
@@ -739,7 +739,7 @@
 	struct dm_report_field *field;
 	const char *repstr;
 	char buf[4096];
-	int width;
+	unsigned width;
 
 	if (list_empty(&rh->rows))
 		return 1;
