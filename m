From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/20] libmultipath: functions to indicate
	mapping failure in /dev/shm
Date: Mon, 19 Mar 2018 16:01:44 +0100
Message-ID: <20180319150155.5363-10-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Create a simple API that indicates failure to create a map for a
certain WWID. This will allow multipathd to indicate to other tools
(in particular, "multipath -u" during udev processing) that
an attempt to create a map for a certain wwid failed.

The indicator is simply the existence of a file under /dev/shm/multipath/failed_wwids.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/wwids.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/wwids.h |   4 +-
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 5a2e86dcd7e2..e0fdcb34dbc6 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -5,6 +5,7 @@
 #include <limits.h>
 #include <stdio.h>
 #include <sys/types.h>
+#include <sys/stat.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -331,3 +332,104 @@ remember_wwid(char *wwid)
 		condlog(4, "wwid %s already in wwids file", wwid);
 	return ret;
 }
+
+static const char shm_dir[] = "/dev/shm/multipath/failed_wwids";
+static const char shm_lock[] = ".lock";
+static const char shm_header[] = "multipath shm lock file, don't edit";
+static char _shm_lock_path[sizeof(shm_dir)+sizeof(shm_lock)];
+static const char *shm_lock_path = &_shm_lock_path[0];
+
+static int multipath_shm_open(bool rw)
+{
+	int fd;
+	int can_write;
+
+	if (shm_lock_path[0] == '\0')
+		snprintf(_shm_lock_path, sizeof(_shm_lock_path),
+			 "%s/%s", shm_dir, shm_lock);
+	fd = open_file(shm_lock_path, &can_write, shm_header);
+
+	if (fd == 0 && rw && !can_write) {
+		close(fd);
+		condlog(1, "failed to open %s for writing", shm_dir);
+		return -1;
+	}
+
+	return fd;
+}
+
+void multipath_shm_close(void *arg)
+{
+	long fd = (long)arg;
+
+	close(fd);
+	unlink(shm_lock_path);
+}
+
+static int _failed_wwid_op(const char *wwid, bool rw,
+			   int(*func)(const char*), const char *msg)
+{
+	char path[PATH_MAX];
+	long lockfd;
+	int r = -1;
+
+	if (snprintf(path, sizeof(path), "%s/%s", shm_dir, wwid)
+	    >= sizeof(path)) {
+		condlog(1, "%s: path name overflow", __func__);
+		return -1;
+	}
+
+	lockfd = multipath_shm_open(rw);
+	if (lockfd == -1)
+		return -1;
+
+	pthread_cleanup_push(multipath_shm_close, (void*)lockfd);
+	r = func(path);
+	pthread_cleanup_pop(1);
+
+	if (r == -1)
+		condlog(1, "%s: %s: %s", msg, wwid, strerror(errno));
+	else if (rw && r == 1) /* r == 0 means nothing changed */
+		condlog(3, "%s: %s", msg, wwid);
+	else if (!rw)
+		condlog(4, "%s: %s is %s", msg, wwid, r ? "failed" : "good");
+
+	return r;
+}
+
+static int _is_failed(const char *path)
+{
+	struct stat st;
+
+	if (lstat(path, &st) == 0)
+		return 1;
+	else if (errno == ENOENT)
+		return 0;
+	else
+		return -1;
+}
+
+static int _mark_failed(const char *path)
+{
+	/* Called from _failed_wwid_op: we know that shm_lock_path exists */
+	if (_is_failed(path) == 1)
+		return 0;
+	return (link(shm_lock_path, path) == 0 ? 1 : -1);
+}
+
+static int _unmark_failed(const char *path)
+{
+	if (_is_failed(path) == 0)
+		return 0;
+	return (unlink(path) == 0 ? 1 : -1);
+}
+
+#define declare_failed_wwid_op(op, rw) \
+int op ## _wwid(const char *wwid) \
+{ \
+	return _failed_wwid_op(wwid, (rw), _ ## op, #op); \
+}
+
+declare_failed_wwid_op(is_failed, false)
+declare_failed_wwid_op(mark_failed, true)
+declare_failed_wwid_op(unmark_failed, true)
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index d9a78b38ccf8..d00e1f58137c 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -17,5 +17,7 @@ int remember_wwid(char *wwid);
 int check_wwids_file(char *wwid, int write_wwid);
 int remove_wwid(char *wwid);
 int replace_wwids(vector mp);
-
+int is_failed_wwid(const char *wwid);
+int mark_failed_wwid(const char *wwid);
+int unmark_failed_wwid(const char *wwid);
 #endif /* _WWIDS_H */
-- 
2.16.1
