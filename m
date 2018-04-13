From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 16/22] multipath -u : set
	FIND_MULTIPATHS_WAIT_UNTIL from /dev/shm
Date: Sat, 14 Apr 2018 00:00:09 +0200
Message-ID: <20180413220015.7032-17-mwilck@suse.com>
References: <20180413220015.7032-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

In "find_multipaths smart" mode, use time stamps under
/dev/shm/multipath/find_multipaths to track waiting for multipath
siblings. When a path is first encountered and is "maybe" multipath, create
a file under /dev/shm, set its modification time to the expiry time of the
timer, and set the FIND_MULTIPATHS_WAIT_UNTIL variable. On later calls,
also set FIND_MULTIPATHS_WAIT_UNTIL to the expiry time (but don't change
the time stamp) if it's not expired yet, or 0 if it is expired. Set
FIND_MULTIPATHS_WAIT_UNTIL even if enough evidence becomes available to
decide if the path needs to be multipathed - this enables the udev rules to
detect that this is a device a timer has been started for, and stop it. By
using /dev/shm, we share information about "smart" timers between initrd
and root file system, and thus only calculate the timeout once.

Because we use major:minor to identify the devices in /dev/shm, and because
a removed device might be replaced by a different one with the same
major/minor number, add a rule to multipath.rules to remove the
find_multipaths marker on remove uevents.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/file.c       |   2 +-
 libmultipath/file.h       |   1 +
 multipath/main.c          | 132 ++++++++++++++++++++++++++++++++++++++++++++++
 multipath/multipath.rules |   4 +-
 4 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/libmultipath/file.c b/libmultipath/file.c
index d5165ec6..8727f160 100644
--- a/libmultipath/file.c
+++ b/libmultipath/file.c
@@ -36,7 +36,7 @@
  * See the file COPYING included with this distribution for more details.
  */
 
-static int
+int
 ensure_directories_exist(const char *str, mode_t dir_mode)
 {
 	char *pathname;
diff --git a/libmultipath/file.h b/libmultipath/file.h
index 70bffa53..29520c74 100644
--- a/libmultipath/file.h
+++ b/libmultipath/file.h
@@ -6,6 +6,7 @@
 #define _FILE_H
 
 #define FILE_TIMEOUT 30
+int ensure_directories_exist(const char *str, mode_t dir_mode);
 int open_file(const char *file, int *can_write, const char *header);
 
 #endif /* _FILE_H */
diff --git a/multipath/main.c b/multipath/main.c
index f62e18a9..5d847f08 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -29,6 +29,7 @@
 #include <ctype.h>
 #include <libudev.h>
 #include <syslog.h>
+#include <fcntl.h>
 
 #include "checkers.h"
 #include "prio.h"
@@ -60,6 +61,9 @@
 #include "uxsock.h"
 #include "mpath_cmd.h"
 #include "foreign.h"
+#include "propsel.h"
+#include "time-util.h"
+#include "file.h"
 
 int logsink;
 struct udev *udev;
@@ -350,14 +354,142 @@ out:
 	return r;
 }
 
+enum {
+	FIND_MULTIPATHS_WAIT_DONE = 0,
+	FIND_MULTIPATHS_WAITING = 1,
+	FIND_MULTIPATHS_ERROR = -1,
+	FIND_MULTIPATHS_NEVER = -2,
+};
+
+static const char shm_find_mp_dir[] = MULTIPATH_SHM_BASE "find_multipaths";
+static void close_fd(void *arg)
+{
+	close((long)arg);
+}
+
+/**
+ * find_multipaths_check_timeout(wwid, tmo)
+ * Helper for "find_multipaths smart"
+ *
+ * @param[in] pp: path to check / record
+ * @param[in] tmo: configured timeout for this WWID, or value <= 0 for checking
+ * @param[out] until: timestamp until we must wait, CLOCK_REALTIME, if return
+ *             value is FIND_MULTIPATHS_WAITING
+ * @returns: FIND_MULTIPATHS_WAIT_DONE, if waiting has finished
+ * @returns: FIND_MULTIPATHS_ERROR, if internal error occurred
+ * @returns: FIND_MULTIPATHS_NEVER, if tmo is 0 and we didn't wait for this
+ *           device
+ * @returns: FIND_MULTIPATHS_WAITING, if timeout hasn't expired
+ */
+static int find_multipaths_check_timeout(const struct path *pp, long tmo,
+					 struct timespec *until)
+{
+	char path[PATH_MAX];
+	struct timespec now, ftimes[2], tdiff;
+	struct stat st;
+	long fd;
+	int r, err, retries = 0;
+
+	clock_gettime(CLOCK_REALTIME, &now);
+
+	if (snprintf(path, sizeof(path), "%s/%s", shm_find_mp_dir, pp->dev_t)
+	    >= sizeof(path)) {
+		condlog(1, "%s: path name overflow", __func__);
+		return FIND_MULTIPATHS_ERROR;
+	}
+
+	if (ensure_directories_exist(path, 0700)) {
+		condlog(1, "%s: error creating directories", __func__);
+		return FIND_MULTIPATHS_ERROR;
+	}
+
+retry:
+	fd = open(path, O_RDONLY);
+	if (fd != -1) {
+		pthread_cleanup_push(close_fd, (void *)fd);
+		r = fstat(fd, &st);
+		if (r != 0)
+			err = errno;
+		pthread_cleanup_pop(1);
+
+	} else if (tmo > 0) {
+		if (errno == ENOENT)
+			fd = open(path, O_RDWR|O_EXCL|O_CREAT, 0644);
+		if (fd == -1) {
+			if (errno == EEXIST && !retries++)
+				/* We could have raced with another process */
+				goto retry;
+			condlog(1, "%s: error opening %s: %s",
+				__func__, path, strerror(errno));
+			return FIND_MULTIPATHS_ERROR;
+		};
+
+		pthread_cleanup_push(close_fd, (void *)fd);
+		/*
+		 * We just created the file. Set st_mtim to our desired
+		 * expiry time.
+		 */
+		ftimes[0].tv_sec = 0;
+		ftimes[0].tv_nsec = UTIME_OMIT;
+		ftimes[1].tv_sec = now.tv_sec + tmo;
+		ftimes[1].tv_nsec = now.tv_nsec;
+		if (futimens(fd, ftimes) != 0) {
+			condlog(1, "%s: error in futimens(%s): %s", __func__,
+				path, strerror(errno));
+		}
+		r = fstat(fd, &st);
+		if (r != 0)
+			err = errno;
+		pthread_cleanup_pop(1);
+	} else
+		return FIND_MULTIPATHS_NEVER;
+
+	if (r != 0) {
+		condlog(1, "%s: error in fstat for %s: %s", __func__,
+			path, strerror(err));
+		return FIND_MULTIPATHS_ERROR;
+	}
+
+	timespecsub(&st.st_mtim, &now, &tdiff);
+
+	if (tdiff.tv_sec <= 0)
+		return FIND_MULTIPATHS_WAIT_DONE;
+
+	*until = tdiff;
+	return FIND_MULTIPATHS_WAITING;
+}
+
 static int print_cmd_valid(int k, const vector pathvec,
 			   struct config *conf)
 {
 	static const int vals[] = { 1, 0, 2 };
+	int wait = FIND_MULTIPATHS_NEVER;
+	struct timespec until;
+	struct path *pp;
 
 	if (k < 0 || k >= sizeof(vals))
 		return 1;
 
+	if (k == 2) {
+		/*
+		 * Caller ensures that pathvec[0] is the path to
+		 * examine.
+		 */
+		pp = VECTOR_SLOT(pathvec, 0);
+		select_find_multipaths_timeout(conf, pp);
+		wait = find_multipaths_check_timeout(
+			pp, pp->find_multipaths_timeout, &until);
+		if (wait != FIND_MULTIPATHS_WAITING)
+			k = 1;
+	} else if (pathvec != NULL) {
+		pp = VECTOR_SLOT(pathvec, 0);
+		wait = find_multipaths_check_timeout(pp, 0, &until);
+	}
+	if (wait == FIND_MULTIPATHS_WAITING)
+		printf("FIND_MULTIPATHS_WAIT_UNTIL=\"%ld.%06ld\"\n",
+			       until.tv_sec, until.tv_nsec/1000);
+	else if (wait == FIND_MULTIPATHS_WAIT_DONE)
+		printf("FIND_MULTIPATHS_WAIT_UNTIL=\"0\"\n");
 	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n", vals[k]);
 	return k == 1;
 }
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index aab64dc7..37f4f6d8 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -1,7 +1,9 @@
 # Set DM_MULTIPATH_DEVICE_PATH if the device should be handled by multipath
 SUBSYSTEM!="block", GOTO="end_mpath"
-ACTION!="add|change", GOTO="end_mpath"
 KERNEL!="sd*|dasd*|nvme*", GOTO="end_mpath"
+ACTION=="remove", TEST=="/dev/shm/multipath/find_multipaths/$major:$minor", \
+	RUN+="/usr/bin/rm -f /dev/shm/multipath/find_multipaths/$major:$minor"
+ACTION!="add|change", GOTO="end_mpath"
 
 IMPORT{cmdline}="nompath"
 ENV{nompath}=="?*", GOTO="end_mpath"
-- 
2.16.1
