From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/directio.c libchec ...
Date: 27 Oct 2010 18:55:57 -0000
Message-ID: <20101027185557.10625.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2010-10-27 18:55:56

Modified files:
	libcheckers    : directio.c path_state.h 
	libmultipath   : config.h dict.c discovery.c hwtable.c structs.h 
	multipathd     : main.c 

Log message:
	Fixes for bz #488921, #500580, #511034, #623468
	Ported the queue_without_daemon code from RHEL5 (488921).  Changed the directio
	path checker to wait asychronously in multipathd and added the PATH_PENDING
	state like in RHEL5 (500580).  Change the sysfs wait time from 5 seconds to
	a minute, but make it quit early if it notices that the sys/block/<devname>
	directory doesn't exist, like in RHEL 5 (511034). Add autoconfiguration for
	the HP HSVX700 (623468).

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/directio.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2.2.1&r2=1.2.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/path_state.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.5&r2=1.17.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.7&r2=1.16.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.9&r2=1.28.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.17&r2=1.16.2.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.10&r2=1.17.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.8&r2=1.66.2.9

--- multipath-tools/libcheckers/directio.c	2007/07/26 19:27:13	1.2.2.1
+++ multipath-tools/libcheckers/directio.c	2010/10/27 18:55:55	1.2.2.2
@@ -20,9 +20,12 @@
 #include "checkers.h"
 #include "../libmultipath/debug.h"
 
+#define DIRECTIO_TIMEOUT       30
+
 #define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
 #define MSG_DIRECTIO_UP		"directio checker reports path is up"
 #define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
+#define MSG_DIRECTIO_PENDING   "directio checker waits for I/O"
 
 struct directio_context {
 	int             running;
@@ -34,11 +37,11 @@
 };
 
 static int
-check_state(int fd, struct directio_context *ct)
+check_state(int fd, struct directio_context *ct, int sync)
 {
 	long flags;
 	int reset_flags = 0;
-	struct timespec timeout = { .tv_sec = 2 };
+	struct timespec timeout = { .tv_sec = 1 };
 	struct io_event event;
 	struct stat     sb;
 	int             rc = PATH_UNCHECKED;
@@ -59,6 +62,11 @@
 		condlog(4, "directio: called for %x", (unsigned) sb.st_rdev);
 	}
 
+	if (sync) {
+		condlog(4, "directio: synchronous mode");
+		timeout.tv_sec = DIRECTIO_TIMEOUT;
+	}
+
 	if (!ct->running) {
 		struct iocb *ios[1] = { &ct->io };
 
@@ -71,10 +79,14 @@
 			goto out;
 		}
 	}
-	ct->running = 1;
+	ct->running++;
 
 	r = syscall(__NR_io_getevents, ct->ioctx, 1L, 1L, &event, &timeout);
 	if (r < 1L) {
+		if (ct->running < DIRECTIO_TIMEOUT && !sync)
+			return PATH_PENDING;
+		ct->running = DIRECTIO_TIMEOUT;
+
 		condlog(3, "directio: timeout r=%li errno=%i", r, errno);
 		rc = PATH_DOWN;
 	} else {
@@ -163,7 +175,7 @@
 		ret = -1;
 		goto out;
 	}
-	ret = check_state(fd, ctxt);
+	ret = check_state(fd, ctxt, (context == NULL));
 
 	switch (ret)
 	{
@@ -176,6 +188,9 @@
 	case PATH_UP:
 		MSG(MSG_DIRECTIO_UP);
 		break;
+	case PATH_PENDING:
+		MSG(MSG_DIRECTIO_PENDING);
+		break;
 	default:
 		break;
 	}
--- multipath-tools/libcheckers/Attic/path_state.h	2005/07/20 19:44:54	1.2
+++ multipath-tools/libcheckers/Attic/path_state.h	2010/10/27 18:55:55	1.2.2.1
@@ -3,3 +3,4 @@
 #define PATH_UP		2
 #define PATH_SHAKY	3
 #define PATH_GHOST	4
+#define PATH_PENDING	5
--- multipath-tools/libmultipath/config.h	2010/04/07 06:37:49	1.17.2.5
+++ multipath-tools/libmultipath/config.h	2010/10/27 18:55:55	1.17.2.6
@@ -79,6 +79,7 @@
 	int attribute_flags;
 	int flush_on_last_del;
 	int override_queueing;
+	int queue_without_daemon;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2009/01/17 00:46:51	1.16.2.7
+++ multipath-tools/libmultipath/dict.c	2010/10/27 18:55:55	1.16.2.8
@@ -314,6 +314,28 @@
 }
 
 static int
+def_queue_without_daemon(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (!strncmp(buff, "off", 3) || !strncmp(buff, "no", 2) ||
+	    !strncmp(buff, "0", 1))
+		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
+	else if (!strncmp(buff, "on", 2) || !strncmp(buff, "yes", 3) ||
+		 !strncmp(buff, "1", 1))
+		conf->queue_without_daemon = QUE_NO_DAEMON_ON;
+	else
+		conf->queue_without_daemon = QUE_NO_DAEMON_UNDEF;
+
+	free(buff);
+	return 0;
+}
+
+static int
 default_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -1097,6 +1119,7 @@
 	install_keyword("no_path_retry", &def_no_path_retry_handler);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler);
 	install_keyword("pg_timeout", &default_pg_timeout_handler);
+	install_keyword("queue_without_daemon", &def_queue_without_daemon);
 	install_keyword("user_friendly_names", &names_handler);
 	install_keyword("bindings_file", &bindings_file_handler);
 	install_keyword("mode", &def_mode_handler);
--- multipath-tools/libmultipath/discovery.c	2010/05/28 04:53:25	1.28.2.9
+++ multipath-tools/libmultipath/discovery.c	2010/10/27 18:55:55	1.28.2.10
@@ -170,15 +170,18 @@
 	return r;
 }
 
-#define WAIT_MAX_SECONDS 5
+#define WAIT_MAX_SECONDS 60
 #define WAIT_LOOP_PER_SECOND 5
 
 static int
-wait_for_file (char * filename)
+wait_for_file (char * filename, char * sysfs_path, char * dev)
 {
 	int loop;
 	struct stat stats;
-	
+	char dev_dir[SYSFS_PATH_SIZE];
+
+	if (sysfs_path && safe_sprintf(dev_dir, "%s/block/%s", sysfs_path, dev))
+		return 1;
 	loop = WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
 	
 	while (--loop) {
@@ -188,6 +191,9 @@
 		if (errno != ENOENT)
 			return 1;
 
+		if (sysfs_path && stat(dev_dir, &stats) != 0)
+			return 1;
+
 		usleep(1000 * 1000 / WAIT_LOOP_PER_SECOND);
 	}
 	return 1;
@@ -204,7 +210,7 @@
 	if (safe_sprintf(attr_path, fmt, sysfs_path, dev)) \
 		return 1; \
 \
-	if (wait_for_file(attr_path)) \
+	if (wait_for_file(attr_path, sysfs_path, dev)) \
 		return 1; \
 \
 	if (0 > sysfs_read_attribute_value(attr_path, attr_buff, sizeof(attr_buff))) \
@@ -269,7 +275,7 @@
 		return -1;
 	}
 
-	if (wait_for_file(devpath)) {
+	if (wait_for_file(devpath, NULL, NULL)) {
 		condlog(3, "failed to open %s", devpath);
 		return -1;
 	}
--- multipath-tools/libmultipath/hwtable.c	2009/09/11 15:19:50	1.16.2.17
+++ multipath-tools/libmultipath/hwtable.c	2010/10/27 18:55:55	1.16.2.18
@@ -39,6 +39,10 @@
 			   GROUP_BY_PRIO, DEFAULT_GETUID,
 			   "/sbin/mpath_prio_alua /dev/%n", "0", "0", "tur",
 			   -FAILBACK_IMMEDIATE, NULL, 12, 0, 100);
+	r += store_hwe_ext(hw, "HP", "HSVX700", GROUP_BY_PRIO,
+                           DEFAULT_GETUID, "/sbin/mpath_prio_hp_sw /dev/%n",
+                           "0", "0", "hp_sw", -FAILBACK_IMMEDIATE, NULL, 12, 0,
+                           100);
 	r += store_hwe_ext(hw, "COMPAQ", "MSA|HSV1.0.*", GROUP_BY_PRIO,
                            DEFAULT_GETUID, "/sbin/mpath_prio_hp_sw /dev/%n",
                            "1 hp-sw", "0", "hp_sw", FAILBACK_UNDEF, NULL, 12, 0,
--- multipath-tools/libmultipath/structs.h	2010/05/28 04:53:25	1.17.2.10
+++ multipath-tools/libmultipath/structs.h	2010/10/27 18:55:55	1.17.2.11
@@ -77,6 +77,12 @@
 	FLUSH_ENABLED,
 };
 
+enum queue_without_daemon_states {
+	QUE_NO_DAEMON_UNDEF,
+	QUE_NO_DAEMON_OFF,
+	QUE_NO_DAEMON_ON,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
--- multipath-tools/multipathd/main.c	2009/09/11 15:19:50	1.66.2.8
+++ multipath-tools/multipathd/main.c	2010/10/27 18:55:56	1.66.2.9
@@ -1368,6 +1368,16 @@
 				continue;
 			}
 
+			/*
+			 * Async IO in flight. Keep the previous path state
+			 * and reschedule as soon as possible.
+			 */
+			if (newstate == PATH_PENDING) {
+				condlog(4, "%s: pending path", pp->dev);
+				pp->tick = 1;
+				continue;
+			}
+
 			if (newstate != pp->state) {
 				int oldstate = pp->state;
 				pp->state = newstate;
@@ -1621,6 +1631,8 @@
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t log_attr, misc_attr;
 	struct vectors * vecs;
+	struct multipath * mpp;
+	int i;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 
@@ -1702,6 +1714,9 @@
 	 * exit path
 	 */
 	lock(vecs->lock);
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
+		vector_foreach_slot(vecs->mpvec, mpp, i)
+			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps(vecs);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 
