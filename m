From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 5/6] libmultipath: simplify failed wwid code
Date: Tue, 19 May 2020 12:08:44 -0500
Message-ID: <1589908125-7456-6-git-send-email-bmarzins@redhat.com>
References: <1589908125-7456-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589908125-7456-1-git-send-email-bmarzins@redhat.com>
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

The (is|mark|unmark)_failed_wwid code is needlessly complicated.
Locking a file is necssary if multiple processes could otherwise be
writing to it at the same time. That is not the case with the
failed_wwids files. They can simply be empty files in a directory.  Even
with all the locking in place, two processes accessing or modifying a
file at the same time will still race. And even without the locking, if
two processes try to access or modify a file at the same time, they will
both see a reasonable result, and will leave the files in a valid state
afterwards.

Instead of doing all the locking work (which made it necessary to write
a file, even just to check if a file existed), simply check for files
with lstat(), create them with open(), and remove them with unlink().

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/wwids.c | 131 ++++++++++++++++++-------------------------
 1 file changed, 56 insertions(+), 75 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 637cb0ab..aab5da8a 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -6,6 +6,7 @@
 #include <stdio.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <fcntl.h>
 
 #include "util.h"
 #include "checkers.h"
@@ -348,109 +349,89 @@ remember_wwid(char *wwid)
 }
 
 static const char shm_dir[] = MULTIPATH_SHM_BASE "failed_wwids";
-static const char shm_lock[] = ".lock";
-static const char shm_header[] = "multipath shm lock file, don't edit";
-static char _shm_lock_path[sizeof(shm_dir)+sizeof(shm_lock)];
-static const char *shm_lock_path = &_shm_lock_path[0];
 
-static void init_shm_paths(void)
+static void print_failed_wwid_result(const char * msg, const char *wwid, int r)
 {
-	snprintf(_shm_lock_path, sizeof(_shm_lock_path),
-		 "%s/%s", shm_dir, shm_lock);
+	switch(r) {
+	case WWID_FAILED_ERROR:
+		condlog(1, "%s: %s: %m", msg, wwid);
+		return;
+	case WWID_IS_FAILED:
+	case WWID_IS_NOT_FAILED:
+		condlog(4, "%s: %s is %s", msg, wwid,
+			r == WWID_IS_FAILED ? "failed" : "good");
+		return;
+	case WWID_FAILED_CHANGED:
+		condlog(3, "%s: %s", msg, wwid);
+	}
 }
 
-static pthread_once_t shm_path_once = PTHREAD_ONCE_INIT;
-
-static int multipath_shm_open(bool rw)
+int is_failed_wwid(const char *wwid)
 {
-	int fd;
-	int can_write;
-
-	pthread_once(&shm_path_once, init_shm_paths);
-	fd = open_file(shm_lock_path, &can_write, shm_header);
+	struct stat st;
+	char path[PATH_MAX];
+	int r;
 
-	if (fd >= 0 && rw && !can_write) {
-		close(fd);
-		condlog(1, "failed to open %s for writing", shm_dir);
+	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
+		condlog(1, "%s: path name overflow", __func__);
 		return -1;
 	}
 
-	return fd;
-}
-
-static void multipath_shm_close(void *arg)
-{
-	long fd = (long)arg;
+	if (lstat(path, &st) == 0)
+		r = WWID_IS_FAILED;
+	else if (errno == ENOENT)
+		r = WWID_IS_NOT_FAILED;
+	else
+		r = WWID_FAILED_ERROR;
 
-	close(fd);
-	unlink(shm_lock_path);
+	print_failed_wwid_result("is_failed", wwid, r);
+	return r;
 }
 
-static int _failed_wwid_op(const char *wwid, bool rw,
-			   int (*func)(const char *), const char *msg)
+int mark_failed_wwid(const char *wwid)
 {
 	char path[PATH_MAX];
-	long lockfd;
-	int r = -1;
+	int r, fd;
 
 	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
 		condlog(1, "%s: path name overflow", __func__);
 		return -1;
 	}
-
-	lockfd = multipath_shm_open(rw);
-	if (lockfd == -1)
+	if (ensure_directories_exist(path, 0700) < 0) {
+		condlog(1, "%s: can't setup directories", __func__);
 		return -1;
+	}
 
-	pthread_cleanup_push(multipath_shm_close, (void *)lockfd);
-	r = func(path);
-	pthread_cleanup_pop(1);
-
-	if (r == WWID_FAILED_ERROR)
-		condlog(1, "%s: %s: %s", msg, wwid, strerror(errno));
-	else if (r == WWID_FAILED_CHANGED)
-		condlog(3, "%s: %s", msg, wwid);
-	else if (!rw)
-		condlog(4, "%s: %s is %s", msg, wwid,
-			r == WWID_IS_FAILED ? "failed" : "good");
+	fd = open(path, O_RDONLY | O_CREAT | O_EXCL, S_IRUSR);
+	if (fd >= 0) {
+		close(fd);
+		r = WWID_FAILED_CHANGED;
+	} else if (errno == EEXIST)
+		r = WWID_FAILED_UNCHANGED;
+	else
+		r = WWID_FAILED_ERROR;
 
+	print_failed_wwid_result("mark_failed", wwid, r);
 	return r;
 }
 
-static int _is_failed(const char *path)
+int unmark_failed_wwid(const char *wwid)
 {
-	struct stat st;
+	char path[PATH_MAX];
+	int r;
 
-	if (lstat(path, &st) == 0)
-		return WWID_IS_FAILED;
+	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
+		condlog(1, "%s: path name overflow", __func__);
+		return -1;
+	}
+
+	if (unlink(path) == 0)
+		r = WWID_FAILED_CHANGED;
 	else if (errno == ENOENT)
-		return WWID_IS_NOT_FAILED;
+		r = WWID_FAILED_UNCHANGED;
 	else
-		return WWID_FAILED_ERROR;
-}
-
-static int _mark_failed(const char *path)
-{
-	/* Called from _failed_wwid_op: we know that shm_lock_path exists */
-	if (_is_failed(path) == WWID_IS_FAILED)
-		return WWID_FAILED_UNCHANGED;
-	return (link(shm_lock_path, path) == 0 ? WWID_FAILED_CHANGED :
-		WWID_FAILED_ERROR);
-}
+		r = WWID_FAILED_ERROR;
 
-static int _unmark_failed(const char *path)
-{
-	if (_is_failed(path) == WWID_IS_NOT_FAILED)
-		return WWID_FAILED_UNCHANGED;
-	return (unlink(path) == 0 ? WWID_FAILED_CHANGED : WWID_FAILED_ERROR);
-}
-
-#define declare_failed_wwid_op(op, rw) \
-int op ## _wwid(const char *wwid) \
-{ \
-	return _failed_wwid_op(wwid, (rw), _ ## op, #op); \
+	print_failed_wwid_result("unmark_failed", wwid, r);
+	return r;
 }
-
-declare_failed_wwid_op(is_failed, false)
-declare_failed_wwid_op(mark_failed, true)
-declare_failed_wwid_op(unmark_failed, true)
-- 
2.17.2
