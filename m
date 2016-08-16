From: tang.junhui@zte.com.cn
Subject: [PATCH] libmultipath: fix multipath -q command logic
Date: Tue, 16 Aug 2016 19:32:18 +0800
Message-ID: <1471347138-12032-1-git-send-email-tang.junhui@zte.com.cn>
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

multipath judged whether multipathd service in running by check_daemon() when executing
mutipath commands, check_daemon() try to connect to the multipathd service and execute
"show dameon" command. The expected result is that the command will be failed when the
service is not running, however, mpath_connect() will activate the multipathd service when
the service is not running, so check_daemon() always return with true. Another problem is that
multipath command with -q parameter is not processed in coalesce_paths(). This patch fix for
those two problems.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/configure.c | 85 +++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 37 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 707e6be..d8a17a6 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -715,36 +715,36 @@ deadmap (struct multipath * mpp)
 	return 1; /* dead */
 }
 
-int check_daemon(void)
+static int
+check_daemon(void)
 {
 	int fd;
-	char *reply;
-	int ret = 0;
-	unsigned int timeout;
-	struct config *conf;
-
-	fd = mpath_connect();
-	if (fd == -1)
-		return 0;
+	struct flock lock;
 
-	if (send_packet(fd, "show daemon") != 0)
-		goto out;
-	conf = get_multipath_config();
-	timeout = conf->uxsock_timeout;
-	put_multipath_config(conf);
-	if (recv_packet(fd, &reply, timeout) != 0)
-		goto out;
-
-	if (strstr(reply, "shutdown"))
-		goto out_free;
-
-	ret = 1;
+	fd = open(DEFAULT_PIDFILE, O_RDONLY);
+	if (fd < 0) {
+		if (errno == ENOENT)
+			return 0;
+		if (errno == EMFILE)
+			condlog(0, "failed to open file, increase max_fds at %s", DEFAULT_CONFIGFILE);
+		else
+			condlog(0, "can not open pidfile %s: %s", DEFAULT_PIDFILE, strerror(errno));
+		return -1;
+	}
 
-out_free:
-	FREE(reply);
-out:
-	mpath_disconnect(fd);
-	return ret;
+	lock.l_type = F_WRLCK;
+	lock.l_start = 0;
+	lock.l_whence = SEEK_SET;
+	lock.l_len = 0;
+	if (fcntl(fd, F_GETLK, &lock) < 0) {
+		condlog(0, "can not get file locker, %s: %s", DEFAULT_PIDFILE, strerror(errno));
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	if (lock.l_type == F_UNLCK)
+		return 0;
+	return 1;
 }
 
 extern int
@@ -873,17 +873,28 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		if (r == DOMAP_DRY)
 			continue;
 
-		conf = get_multipath_config();
-		allow_queueing = conf->allow_queueing;
-		put_multipath_config(conf);
-		if (!is_daemon && !allow_queueing && !check_daemon()) {
-			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
-			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
-				condlog(3, "%s: multipathd not running, unset "
-					"queue_if_no_path feature", mpp->alias);
-			if (!dm_queue_if_no_path(mpp->alias, 0))
-				remove_feature(&mpp->features,
-					       "queue_if_no_path");
+		/* run as multipath command and the service is not running */
+		if (!is_daemon && !check_daemon()) {
+			conf = get_multipath_config();
+			allow_queueing = conf->allow_queueing;
+			put_multipath_config(conf);
+			/* no -q choice */
+			if (!allow_queueing) {
+				if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+					mpp->no_path_retry != NO_PATH_RETRY_FAIL)
+					condlog(3, "%s: multipathd not running, unset "
+						"queue_if_no_path feature", mpp->alias);
+				if (!dm_queue_if_no_path(mpp->alias, 0))
+					remove_feature(&mpp->features,
+							"queue_if_no_path");
+			} else { /* with -q choice */
+				if (mpp->no_path_retry == NO_PATH_RETRY_UNDEF ||
+					mpp->no_path_retry == NO_PATH_RETRY_FAIL)
+					condlog(3, "%s: multipathd not running, set "
+						"queue_if_no_path feature", mpp->alias);
+				if (!dm_queue_if_no_path(mpp->alias, 1))
+					add_feature(&mpp->features, "queue_if_no_path");
+			}
 		}
 		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
 			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL) {
-- 
2.8.1.windows.1
