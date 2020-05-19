From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 3/6] multipath: centralize validation code
Date: Mon, 18 May 2020 23:57:05 -0500
Message-ID: <1589864228-1363-4-git-send-email-bmarzins@redhat.com>
References: <1589864228-1363-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589864228-1363-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This code pulls the multipath path validation code out of configure(),
and puts it into its own function, check_path_valid(). This function
calls a new libmultipath function, is_path_valid() to check just path
requested. This seperation exists so that is_path_valid() can be reused
by future code. This code will give almost the same answer as the
existing code, with the exception that now, if a device is currently
multipathed, it will always be a valid multipath path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile    |   3 +-
 libmultipath/devmapper.c |  45 ++++++
 libmultipath/devmapper.h |   1 +
 libmultipath/structs.h   |  24 +---
 libmultipath/valid.c     | 118 ++++++++++++++++
 libmultipath/valid.h     |  42 ++++++
 libmultipath/wwids.c     |  10 +-
 multipath/main.c         | 296 +++++++++++++++++----------------------
 8 files changed, 344 insertions(+), 195 deletions(-)
 create mode 100644 libmultipath/valid.c
 create mode 100644 libmultipath/valid.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index ad690a49..436f479d 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -47,7 +47,8 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
-	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o
+	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o \
+	valid.o
 
 all: $(LIBS)
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 7ed494a1..27d52398 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -770,6 +770,51 @@ out:
 	return r;
 }
 
+/*
+ * Return
+ *   1 : map with uuid exists
+ *   0 : map with uuid doesn't exist
+ *  -1 : error
+ */
+int
+dm_map_present_by_uuid(const char *uuid)
+{
+	struct dm_task *dmt;
+	struct dm_info info;
+	char prefixed_uuid[WWID_SIZE + UUID_PREFIX_LEN];
+	int r = -1;
+
+	if (!uuid || uuid[0] == '\0')
+		return 0;
+
+	if (safe_sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid))
+		goto out;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		goto out;
+
+	dm_task_no_open_count(dmt);
+
+	if (!dm_task_set_uuid(dmt, prefixed_uuid))
+		goto out_task;
+
+	if (!dm_task_run(dmt))
+		goto out_task;
+
+	if (!dm_task_get_info(dmt, &info))
+		goto out_task;
+
+	r = !!info.exists;
+
+out_task:
+	dm_task_destroy(dmt);
+out:
+	if (r < 0)
+		condlog(3, "%s: dm command failed in %s: %s", uuid,
+			__FUNCTION__, strerror(errno));
+	return r;
+}
+
 static int
 dm_dev_t (const char * mapname, char * dev_t, int len)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 17fc9faf..5ed7edc5 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -39,6 +39,7 @@ int dm_simplecmd_noflush (int, const char *, uint16_t);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present (const char *);
+int dm_map_present_by_uuid(const char *uuid);
 int dm_get_map(const char *, unsigned long long *, char *);
 int dm_get_status(const char *, char *);
 int dm_type(const char *, char *);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9bd39eb1..d69bc2e9 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -101,29 +101,13 @@ enum yes_no_undef_states {
 	YNU_YES,
 };
 
-#define _FIND_MULTIPATHS_F (1 << 1)
-#define _FIND_MULTIPATHS_I (1 << 2)
-#define _FIND_MULTIPATHS_N (1 << 3)
-/*
- * _FIND_MULTIPATHS_F must have the same value as YNU_YES.
- * Generate a compile time error if that isn't the case.
- */
-extern char ___error1___[-(_FIND_MULTIPATHS_F != YNU_YES)];
-
-#define find_multipaths_on(conf) \
-	(!!((conf)->find_multipaths & _FIND_MULTIPATHS_F))
-#define ignore_wwids_on(conf) \
-	(!!((conf)->find_multipaths & _FIND_MULTIPATHS_I))
-#define ignore_new_devs_on(conf) \
-	(!!((conf)->find_multipaths & _FIND_MULTIPATHS_N))
-
 enum find_multipaths_states {
 	FIND_MULTIPATHS_UNDEF = YNU_UNDEF,
 	FIND_MULTIPATHS_OFF = YNU_NO,
-	FIND_MULTIPATHS_ON = _FIND_MULTIPATHS_F,
-	FIND_MULTIPATHS_GREEDY = _FIND_MULTIPATHS_I,
-	FIND_MULTIPATHS_SMART = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_I,
-	FIND_MULTIPATHS_STRICT = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_N,
+	FIND_MULTIPATHS_ON = YNU_YES,
+	FIND_MULTIPATHS_GREEDY,
+	FIND_MULTIPATHS_SMART,
+	FIND_MULTIPATHS_STRICT,
 	__FIND_MULTIPATHS_LAST,
 };
 
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
new file mode 100644
index 00000000..456b1f6e
--- /dev/null
+++ b/libmultipath/valid.c
@@ -0,0 +1,118 @@
+/*
+  Copyright (c) 2020 Benjamin Marzinski, IBM
+
+  This program is free software; you can redistribute it and/or
+  modify it under the terms of the GNU General Public License
+  as published by the Free Software Foundation; either version 2
+  of the License, or (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
+ */
+#include <stddef.h>
+#include <errno.h>
+#include <libudev.h>
+
+#include "vector.h"
+#include "config.h"
+#include "debug.h"
+#include "util.h"
+#include "devmapper.h"
+#include "discovery.h"
+#include "wwids.h"
+#include "sysfs.h"
+#include "blacklist.h"
+#include "mpath_cmd.h"
+#include "valid.h"
+
+int
+is_path_valid(const char *name, struct config *conf, struct path *pp,
+	      bool check_multipathd)
+{
+	int r;
+	int fd;
+
+	if (!pp || !name || !conf)
+		return PATH_IS_ERROR;
+
+	if (conf->find_multipaths <= FIND_MULTIPATHS_UNDEF ||
+	    conf->find_multipaths >= __FIND_MULTIPATHS_LAST)
+		return PATH_IS_ERROR;
+
+	if (safe_sprintf(pp->dev, "%s", name))
+		return PATH_IS_ERROR;
+
+	if (sysfs_is_multipathed(pp, true)) {
+		if (pp->wwid[0] == '\0')
+			return PATH_IS_ERROR;
+		return PATH_IS_VALID_NO_CHECK;
+	}
+
+	/*
+	 * "multipath -u" may be run before the daemon is started. In this
+	 * case, systemd might own the socket but might delay multipathd
+	 * startup until some other unit (udev settle!)  has finished
+	 * starting. With many LUNs, the listen backlog may be exceeded, which
+	 * would cause connect() to block. This causes udev workers calling
+	 * "multipath -u" to hang, and thus creates a deadlock, until "udev
+	 * settle" times out.  To avoid this, call connect() in non-blocking
+	 * mode here, and take EAGAIN as indication for a filled-up systemd
+	 * backlog.
+	 */
+
+	if (check_multipathd) {
+		fd = __mpath_connect(1);
+		if (fd < 0) {
+			if (errno != EAGAIN && !systemd_service_enabled(name)) {
+				condlog(3, "multipathd not running or enabled");
+				return PATH_IS_NOT_VALID;
+			}
+		} else
+			mpath_disconnect(fd);
+	}
+
+	pp->udev = udev_device_new_from_subsystem_sysname(udev, "block", name);
+	if (!pp->udev)
+		return PATH_IS_ERROR;
+
+	r = pathinfo(pp, conf, DI_SYSFS | DI_WWID | DI_BLACKLIST);
+	if (r == PATHINFO_SKIPPED)
+		return PATH_IS_NOT_VALID;
+	else if (r)
+		return PATH_IS_ERROR;
+
+	if (pp->wwid[0] == '\0')
+		return PATH_IS_NOT_VALID;
+
+	if (pp->udev && pp->uid_attribute &&
+	    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
+		return PATH_IS_NOT_VALID;
+
+	r = is_failed_wwid(pp->wwid);
+	if (r != WWID_IS_NOT_FAILED) {
+		if (r == WWID_IS_FAILED)
+			return PATH_IS_NOT_VALID;
+		return PATH_IS_ERROR;
+	}
+
+	if (conf->find_multipaths == FIND_MULTIPATHS_GREEDY)
+		return PATH_IS_VALID;
+
+	if (check_wwids_file(pp->wwid, 0) == 0)
+		return PATH_IS_VALID_NO_CHECK;
+
+	if (dm_map_present_by_uuid(pp->wwid) == 1)
+		return PATH_IS_VALID;
+
+	/* all these act like FIND_MULTIPATHS_STRICT for finding if a
+	 * path is valid */
+	if (conf->find_multipaths != FIND_MULTIPATHS_SMART)
+		return PATH_IS_NOT_VALID;
+
+	return PATH_IS_MAYBE_VALID;
+}
diff --git a/libmultipath/valid.h b/libmultipath/valid.h
new file mode 100644
index 00000000..ce1c7cbf
--- /dev/null
+++ b/libmultipath/valid.h
@@ -0,0 +1,42 @@
+/*
+  Copyright (c) 2020 Benjamin Marzinski, IBM
+
+  This program is free software; you can redistribute it and/or
+  modify it under the terms of the GNU General Public License
+  as published by the Free Software Foundation; either version 2
+  of the License, or (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
+ */
+#ifndef _VALID_H
+#define _VALID_H
+
+/*
+ * PATH_IS_VALID_NO_CHECK is returned when multipath should claim
+ * the path, regardless of whether is has been released to systemd
+ * already.
+ * PATH_IS_VALID is returned by is_path_valid, when the path is
+ * valid only if it hasn't been released to systemd already.
+ * PATH_IS_MAYBE_VALID is returned when the the path would be valid
+ * if other paths with the same wwid existed. It is up to the caller
+ * to check for these other paths.
+ */
+enum is_path_valid_result {
+	PATH_IS_ERROR = -1,
+	PATH_IS_NOT_VALID,
+	PATH_IS_VALID,
+	PATH_IS_VALID_NO_CHECK,
+	PATH_IS_MAYBE_VALID,
+	PATH_MAX_VALID_RESULT, /* only for bounds checking */
+};
+
+int is_path_valid(const char *name, struct config *conf, struct path *pp,
+		  bool check_multipathd);
+
+#endif /* _VALID_D */
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index fab6fc8f..397f6e54 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -289,19 +289,19 @@ out:
 int
 should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 {
-	int i, ignore_new_devs, find_multipaths;
+	int i, find_multipaths;
 	struct path *pp2;
 	struct config *conf;
 
 	conf = get_multipath_config();
-	ignore_new_devs = ignore_new_devs_on(conf);
-	find_multipaths = find_multipaths_on(conf);
+	find_multipaths = conf->find_multipaths;
 	put_multipath_config(conf);
-	if (!find_multipaths && !ignore_new_devs)
+	if (find_multipaths == FIND_MULTIPATHS_OFF ||
+	    find_multipaths == FIND_MULTIPATHS_GREEDY)
 		return 1;
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
-	if (!ignore_new_devs) {
+	if (find_multipaths != FIND_MULTIPATHS_STRICT) {
 		char tmp_wwid[WWID_SIZE];
 		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
 
diff --git a/multipath/main.c b/multipath/main.c
index f25b8693..5eac757a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -63,21 +63,18 @@
 #include "propsel.h"
 #include "time-util.h"
 #include "file.h"
+#include "valid.h"
 
 int logsink;
 struct udev *udev;
 struct config *multipath_conf;
 
 /*
- * Return values of configure(), print_cmd_valid(), and main().
- * RTVL_{YES,NO} are synonyms for RTVL_{OK,FAIL} for the CMD_VALID_PATH case.
+ * Return values of configure(), check_path_valid(), and main().
  */
 enum {
 	RTVL_OK = 0,
-	RTVL_YES = RTVL_OK,
 	RTVL_FAIL = 1,
-	RTVL_NO = RTVL_FAIL,
-	RTVL_MAYBE, /* only used internally, never returned */
 	RTVL_RETRY, /* returned by configure(), not by main() */
 };
 
@@ -271,9 +268,6 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 			continue;
 		}
 
-		if (cmd == CMD_VALID_PATH)
-			continue;
-
 		dm_get_map(mpp->alias, &mpp->size, params);
 		condlog(3, "params = %s", params);
 		dm_get_status(mpp->alias, status);
@@ -493,10 +487,11 @@ static int print_cmd_valid(int k, const vector pathvec,
 	struct timespec until;
 	struct path *pp;
 
-	if (k != RTVL_YES && k != RTVL_NO && k != RTVL_MAYBE)
-		return RTVL_NO;
+	if (k != PATH_IS_VALID && k != PATH_IS_NOT_VALID &&
+	    k != PATH_IS_MAYBE_VALID)
+		return PATH_IS_NOT_VALID;
 
-	if (k == RTVL_MAYBE) {
+	if (k == PATH_IS_MAYBE_VALID) {
 		/*
 		 * Caller ensures that pathvec[0] is the path to
 		 * examine.
@@ -506,7 +501,7 @@ static int print_cmd_valid(int k, const vector pathvec,
 		wait = find_multipaths_check_timeout(
 			pp, pp->find_multipaths_timeout, &until);
 		if (wait != FIND_MULTIPATHS_WAITING)
-			k = RTVL_NO;
+			k = PATH_IS_NOT_VALID;
 	} else if (pathvec != NULL && (pp = VECTOR_SLOT(pathvec, 0)))
 		wait = find_multipaths_check_timeout(pp, 0, &until);
 	if (wait == FIND_MULTIPATHS_WAITING)
@@ -515,9 +510,9 @@ static int print_cmd_valid(int k, const vector pathvec,
 	else if (wait == FIND_MULTIPATHS_WAIT_DONE)
 		printf("FIND_MULTIPATHS_WAIT_UNTIL=\"0\"\n");
 	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n",
-	       k == RTVL_MAYBE ? 2 : k == RTVL_YES ? 1 : 0);
+	       k == PATH_IS_MAYBE_VALID ? 2 : k == PATH_IS_VALID ? 1 : 0);
 	/* Never return RTVL_MAYBE */
-	return k == RTVL_NO ? RTVL_NO : RTVL_YES;
+	return k == PATH_IS_NOT_VALID ? PATH_IS_NOT_VALID : PATH_IS_VALID;
 }
 
 /*
@@ -550,7 +545,6 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
-	bool released = released_to_systemd();
 
 	/*
 	 * allocate core vectors to store paths and multipaths
@@ -575,7 +569,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	    cmd != CMD_REMOVE_WWID &&
 	    (filter_devnode(conf->blist_devnode,
 			    conf->elist_devnode, dev) > 0)) {
-		goto print_valid;
+		goto out;
 	}
 
 	/*
@@ -583,14 +577,10 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	 * failing the translation is fatal (by policy)
 	 */
 	if (devpath) {
-		int failed = get_refwwid(cmd, devpath, dev_type,
-					 pathvec, &refwwid);
+		get_refwwid(cmd, devpath, dev_type, pathvec, &refwwid);
 		if (!refwwid) {
 			condlog(4, "%s: failed to get wwid", devpath);
-			if (failed == 2 && cmd == CMD_VALID_PATH)
-				goto print_valid;
-			else
-				condlog(3, "scope is null");
+			condlog(3, "scope is null");
 			goto out;
 		}
 		if (cmd == CMD_REMOVE_WWID) {
@@ -616,53 +606,6 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			goto out;
 		}
 		condlog(3, "scope limited to %s", refwwid);
-		/* If you are ignoring the wwids file and find_multipaths is
-		 * set, you need to actually check if there are two available
-		 * paths to determine if this path should be multipathed. To
-		 * do this, we put off the check until after discovering all
-		 * the paths.
-		 * Paths listed in the wwids file are always considered valid.
-		 */
-		if (cmd == CMD_VALID_PATH) {
-			if (is_failed_wwid(refwwid) == WWID_IS_FAILED) {
-				r = RTVL_NO;
-				goto print_valid;
-			}
-			if ((!find_multipaths_on(conf) &&
-				    ignore_wwids_on(conf)) ||
-				   check_wwids_file(refwwid, 0) == 0)
-				r = RTVL_YES;
-			if (!ignore_wwids_on(conf))
-				goto print_valid;
-			/* At this point, either r==0 or find_multipaths_on. */
-
-			/*
-			 * Shortcut for find_multipaths smart:
-			 * Quick check if path is already multipathed.
-			 */
-			if (sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0),
-						 false)) {
-				r = RTVL_YES;
-				goto print_valid;
-			}
-
-			/*
-			 * DM_MULTIPATH_DEVICE_PATH=="0" means that we have
-			 * been called for this device already, and have
-			 * released it to systemd. Unless the device is now
-			 * already multipathed (see above), we can't try to
-			 * grab it, because setting SYSTEMD_READY=0 would
-			 * cause file systems to be unmounted.
-			 * Leave DM_MULTIPATH_DEVICE_PATH="0".
-			 */
-			if (released) {
-				r = RTVL_NO;
-				goto print_valid;
-			}
-			if (r == RTVL_YES)
-				goto print_valid;
-			/* find_multipaths_on: Fall through to path detection */
-		}
 	}
 
 	/*
@@ -703,59 +646,6 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		goto out;
 	}
 
-	if (cmd == CMD_VALID_PATH) {
-		struct path *pp;
-		int fd;
-
-		/* This only happens if find_multipaths and
-		 * ignore_wwids is set, and the path is not in WWIDs
-		 * file, not currently multipathed, and has
-		 * never been released to systemd.
-		 * If there is currently a multipath device matching
-		 * the refwwid, or there is more than one path matching
-		 * the refwwid, then the path is valid */
-		if (VECTOR_SIZE(curmp) != 0) {
-			r = RTVL_YES;
-			goto print_valid;
-		} else if (VECTOR_SIZE(pathvec) > 1)
-			r = RTVL_YES;
-		else
-			r = RTVL_MAYBE;
-
-		/*
-		 * If opening the path with O_EXCL fails, the path
-		 * is in use (e.g. mounted during initramfs processing).
-		 * We know that it's not used by dm-multipath.
-		 * We may not set SYSTEMD_READY=0 on such devices, it
-		 * might cause systemd to umount the device.
-		 * Use O_RDONLY, because udevd would trigger another
-		 * uevent for close-after-write.
-		 *
-		 * The O_EXCL check is potentially dangerous, because it may
-		 * race with other tasks trying to access the device. Therefore
-		 * this code is only executed if the path hasn't been released
-		 * to systemd earlier (see above).
-		 *
-		 * get_refwwid() above stores the path we examine in slot 0.
-		 */
-		pp = VECTOR_SLOT(pathvec, 0);
-		fd = open(udev_device_get_devnode(pp->udev),
-			  O_RDONLY|O_EXCL);
-		if (fd >= 0)
-			close(fd);
-		else {
-			condlog(3, "%s: path %s is in use: %s",
-				__func__, pp->dev,
-				strerror(errno));
-			/*
-			 * Check if we raced with multipathd
-			 */
-			r = sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0),
-						 false) ? RTVL_YES : RTVL_NO;
-		}
-		goto print_valid;
-	}
-
 	if (cmd != CMD_CREATE && cmd != CMD_DRY_RUN) {
 		r = RTVL_OK;
 		goto out;
@@ -768,10 +658,6 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			   conf->force_reload, cmd);
 	r = rc == CP_RETRY ? RTVL_RETRY : rc == CP_OK ? RTVL_OK : RTVL_FAIL;
 
-print_valid:
-	if (cmd == CMD_VALID_PATH)
-		r = print_cmd_valid(r, pathvec, conf);
-
 out:
 	if (refwwid)
 		FREE(refwwid);
@@ -782,6 +668,112 @@ out:
 	return r;
 }
 
+static int
+check_path_valid(const char *name, struct config *conf, bool is_uevent)
+{
+	int fd, r = PATH_IS_ERROR;
+	struct path *pp = NULL;
+	vector pathvec = NULL;
+
+	pp = alloc_path();
+	if (!pp)
+		return RTVL_FAIL;
+
+	r = is_path_valid(name, conf, pp, is_uevent);
+	if (r <= PATH_IS_ERROR || r >= PATH_MAX_VALID_RESULT)
+		goto fail;
+
+	/* set path values if is_path_valid() didn't */
+	if (!pp->udev)
+		pp->udev = udev_device_new_from_subsystem_sysname(udev, "block",
+								  name);
+	if (!pp->udev)
+		goto fail;
+
+	if (!strlen(pp->dev_t)) {
+		dev_t devt = udev_device_get_devnum(pp->udev);
+		if (major(devt) == 0 && minor(devt) == 0)
+			goto fail;
+		snprintf(pp->dev_t, BLK_DEV_SIZE, "%d:%d", major(devt),
+			 minor(devt));
+	}
+
+	pathvec = vector_alloc();
+	if (!pathvec)
+		goto fail;
+
+	if (store_path(pathvec, pp) != 0) {
+		free_path(pp);
+		goto fail;
+	}
+
+	if ((r == PATH_IS_VALID || r == PATH_IS_MAYBE_VALID) &&
+	    released_to_systemd())
+		r = PATH_IS_NOT_VALID;
+
+	/* This state is only used to skip the released_to_systemd() check */
+	if (r == PATH_IS_VALID_NO_CHECK)
+		r = PATH_IS_VALID;
+
+	if (r != PATH_IS_MAYBE_VALID)
+		goto out;
+
+	/*
+	 * If opening the path with O_EXCL fails, the path
+	 * is in use (e.g. mounted during initramfs processing).
+	 * We know that it's not used by dm-multipath.
+	 * We may not set SYSTEMD_READY=0 on such devices, it
+	 * might cause systemd to umount the device.
+	 * Use O_RDONLY, because udevd would trigger another
+	 * uevent for close-after-write.
+	 *
+	 * The O_EXCL check is potentially dangerous, because it may
+	 * race with other tasks trying to access the device. Therefore
+	 * this code is only executed if the path hasn't been released
+	 * to systemd earlier (see above).
+	 */
+	fd = open(udev_device_get_devnode(pp->udev), O_RDONLY|O_EXCL);
+	if (fd >= 0)
+		close(fd);
+	else {
+		condlog(3, "%s: path %s is in use: %m", __func__, pp->dev);
+		/* Check if we raced with multipathd */
+		if (sysfs_is_multipathed(pp, false))
+			r = PATH_IS_VALID;
+		else
+			r = PATH_IS_NOT_VALID;
+		goto out;
+	}
+
+	/* For find_multipaths = SMART, if there is more than one path
+	 * matching the refwwid, then the path is valid */
+	if (path_discovery(pathvec, DI_SYSFS | DI_WWID) < 0)
+		goto fail;
+	filter_pathvec(pathvec, pp->wwid);
+	if (VECTOR_SIZE(pathvec) > 1)
+		r = PATH_IS_VALID;
+	else
+		r = PATH_IS_MAYBE_VALID;
+
+out:
+	r = print_cmd_valid(r, pathvec, conf);
+	free_pathvec(pathvec, FREE_PATHS);
+	/*
+	 * multipath -u must exit with status 0, otherwise udev won't
+	 * import its output.
+	 */
+	if (!is_uevent && r == PATH_IS_NOT_VALID)
+		return RTVL_FAIL;
+	return RTVL_OK;
+
+fail:
+	if (pathvec)
+		free_pathvec(pathvec, FREE_PATHS);
+	else
+		free_path(pp);
+	return RTVL_FAIL;
+}
+
 static int
 get_dev_type(char *dev) {
 	struct stat buf;
@@ -863,32 +855,6 @@ out:
 	return r;
 }
 
-static int test_multipathd_socket(void)
-{
-	int fd;
-	/*
-	 * "multipath -u" may be run before the daemon is started. In this
-	 * case, systemd might own the socket but might delay multipathd
-	 * startup until some other unit (udev settle!)  has finished
-	 * starting. With many LUNs, the listen backlog may be exceeded, which
-	 * would cause connect() to block. This causes udev workers calling
-	 * "multipath -u" to hang, and thus creates a deadlock, until "udev
-	 * settle" times out.  To avoid this, call connect() in non-blocking
-	 * mode here, and take EAGAIN as indication for a filled-up systemd
-	 * backlog.
-	 */
-
-	fd = __mpath_connect(1);
-	if (fd == -1) {
-		if (errno == EAGAIN)
-			condlog(3, "daemon backlog exceeded");
-		else
-			return 0;
-	} else
-		close(fd);
-	return 1;
-}
-
 int
 main (int argc, char *argv[])
 {
@@ -972,7 +938,11 @@ main (int argc, char *argv[])
 			conf->force_reload = FORCE_RELOAD_YES;
 			break;
 		case 'i':
-			conf->find_multipaths |= _FIND_MULTIPATHS_I;
+			if (conf->find_multipaths == FIND_MULTIPATHS_ON ||
+			    conf->find_multipaths == FIND_MULTIPATHS_STRICT)
+				conf->find_multipaths = FIND_MULTIPATHS_SMART;
+			else if (conf->find_multipaths == FIND_MULTIPATHS_OFF)
+				conf->find_multipaths = FIND_MULTIPATHS_GREEDY;
 			break;
 		case 't':
 			r = dump_config(conf, NULL, NULL) ? RTVL_FAIL : RTVL_OK;
@@ -1070,15 +1040,10 @@ main (int argc, char *argv[])
 		condlog(0, "the -c option requires a path to check");
 		goto out;
 	}
-	if (cmd == CMD_VALID_PATH &&
-	    dev_type == DEV_UEVENT) {
-		if (!test_multipathd_socket()) {
-			condlog(3, "%s: daemon is not running", dev);
-			if (!systemd_service_enabled(dev)) {
-				r = print_cmd_valid(RTVL_NO, NULL, conf);
-				goto out;
-			}
-		}
+	if (cmd == CMD_VALID_PATH) {
+		char * name = convert_dev(dev, (dev_type == DEV_DEVNODE));
+		r = check_path_valid(name, conf, dev_type == DEV_UEVENT);
+		goto out;
 	}
 
 	if (cmd == CMD_REMOVE_WWID && !dev) {
@@ -1142,13 +1107,6 @@ out:
 	cleanup_prio();
 	cleanup_checkers();
 
-	/*
-	 * multipath -u must exit with status 0, otherwise udev won't
-	 * import its output.
-	 */
-	if (cmd == CMD_VALID_PATH && dev_type == DEV_UEVENT && r == RTVL_NO)
-		r = RTVL_OK;
-
 	if (dev_type == DEV_UEVENT)
 		closelog();
 
-- 
2.17.2
