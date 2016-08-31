From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 4/4] rbd: fixup log messages
Date: Wed, 31 Aug 2016 16:44:30 -0500
Message-ID: <1472679870-25654-5-git-send-email-mchristi@redhat.com>
References: <1472679870-25654-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1472679870-25654-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Add rbd device prefix to condlog messages that was missing it, and drop
it in RBD_MSG because it is already added by caller.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/rbd.c | 67 +++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 175c4a6..ea3e95c 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -113,8 +113,8 @@ int libcheck_init(struct checker * c)
 
 	addr = udev_device_get_sysattr_value(bus_dev, "client_addr");
 	if (!addr) {
-		condlog(0, "Could not find client_addr in rbd sysfs. Try "
-			"updating kernel");
+		condlog(0, "rbd%d: Could not find client_addr in rbd sysfs. "
+			"Try updating kernel", ct->rbd_bus_id);
 		goto free_dev;
 	}
 
@@ -127,7 +127,7 @@ int libcheck_init(struct checker * c)
 		goto free_addr;
 	features = strtoll(features_str, NULL, 16);
 	if (!(features & RBD_FEATURE_EXCLUSIVE_LOCK)) {
-		condlog(3, "Exclusive lock not set.");
+		condlog(3, "rbd%d: Exclusive lock not set.", ct->rbd_bus_id);
 		goto free_addr;
 	}
 
@@ -136,7 +136,8 @@ int libcheck_init(struct checker * c)
 		goto free_addr;
 
 	if (!strstr(config_info, "noshare")) {
-		condlog(3, "Only nonshared clients supported.");
+		condlog(3, "rbd%d: Only nonshared clients supported.",
+			ct->rbd_bus_id);
 		goto free_addr;
 	}
 
@@ -189,18 +190,20 @@ int libcheck_init(struct checker * c)
 	}
 
 	if (rados_create(&ct->cluster, NULL) < 0) {
-		condlog(0, "Could not create rados cluster");
+		condlog(0, "rbd%d: Could not create rados cluster",
+			ct->rbd_bus_id);
 		goto free_snap;
 	}
 
 	if (rados_conf_read_file(ct->cluster, NULL) < 0) {
-		condlog(0, "Could not read rados conf");
+		condlog(0, "rbd%d: Could not read rados conf", ct->rbd_bus_id);
 		goto shutdown_rados;
 	}
 
 	ret = rados_connect(ct->cluster);
 	if (ret < 0) {
-		condlog(0, "Could not connect to rados cluster");
+		condlog(0, "rbd%d: Could not connect to rados cluster",
+			ct->rbd_bus_id);
 		goto shutdown_rados;
 	}
 
@@ -291,8 +294,7 @@ static int rbd_is_blacklisted(struct rbd_checker_context *ct, char *msg)
 	ret = rados_mon_command(ct->cluster, (const char **)cmd, 1, "", 0,
 				&blklist, &blklist_len, &stat, &stat_len);
 	if (ret < 0) {
-		RBD_MSG(msg, "rbd checker failed: mon command failed %d",
-			ret);
+		RBD_MSG(msg, "checker failed: mon command failed %d", ret);
 		return ret;
 	}
 
@@ -313,16 +315,15 @@ static int rbd_is_blacklisted(struct rbd_checker_context *ct, char *msg)
 
 		end = strchr(addr_tok, ' ');
 		if (!end) {
-			RBD_MSG(msg, "rbd%d checker failed: invalid blacklist %s",
-				 ct->rbd_bus_id, addr_tok);
+			RBD_MSG(msg, "checker failed: invalid blacklist %s",
+				 addr_tok);
 			break;
 		}
 		*end = '\0';
 
 		if (!strcmp(addr_tok, ct->client_addr)) {
 			ct->blacklisted = 1;
-			RBD_MSG(msg, "rbd%d checker: %s is blacklisted",
-				ct->rbd_bus_id, ct->client_addr);
+			RBD_MSG(msg, "%s is blacklisted", ct->client_addr);
 			ret = 1;
 			break;
 		}
@@ -339,7 +340,7 @@ int rbd_check(struct rbd_checker_context *ct, char *msg)
 	if (ct->blacklisted || rbd_is_blacklisted(ct, msg) == 1)
 		return PATH_DOWN;
 
-	RBD_MSG(msg, "rbd checker reports path is up");
+	RBD_MSG(msg, "checker reports path is up");
 	/*
 	 * Path may have issues, but the ceph cluster is at least
 	 * accepting IO, so we can attempt to do IO.
@@ -411,10 +412,12 @@ static int rbd_remap(struct rbd_checker_context *ct)
 		argv[i] = NULL;
 
 		ret = execvp(argv[0], argv);
-		condlog(0, "Error executing rbd: %s", strerror(errno));
+		condlog(0, "rbd%d: Error executing rbd: %s", ct->rbd_bus_id,
+			strerror(errno));
 		exit(-1);
 	case -1:
-		condlog(0, "fork failed: %s", strerror(errno));
+		condlog(0, "rbd%d: fork failed: %s", ct->rbd_bus_id,
+			strerror(errno));
 		return -1;
 	default:
 		ret = -1;
@@ -424,7 +427,8 @@ static int rbd_remap(struct rbd_checker_context *ct)
 			if (status == 0)
 				ret = 0;
 			else
-				condlog(0, "rbd failed with %d", status);
+				condlog(0, "rbd%d: failed with %d",
+					ct->rbd_bus_id, status);
 		}
 	}
 
@@ -454,12 +458,12 @@ static int rbd_rm_blacklist(struct rbd_checker_context *ct)
 	ret = rados_mon_command(ct->cluster, (const char **)cmd, 1, "", 0,
 				NULL, 0, &stat, &stat_len);
 	if (ret < 0) {
-		condlog(1, "rbd%d repair failed to remove blacklist for %s %d",
+		condlog(1, "rbd%d: repair failed to remove blacklist for %s %d",
 			ct->rbd_bus_id, ct->client_addr, ret);
 		goto free_cmd;
 	}
 
-	condlog(1, "rbd%d repair rm blacklist for %s",
+	condlog(1, "rbd%d: repair rm blacklist for %s",
 	       ct->rbd_bus_id, ct->client_addr);
 	free(stat);
 free_cmd:
@@ -478,8 +482,7 @@ static int rbd_repair(struct rbd_checker_context *ct, char *msg)
 	if (!ct->remapped) {
 		ret = rbd_remap(ct);
 		if (ret) {
-			RBD_MSG(msg, "rbd%d repair failed to remap. Err %d",
-				ct->rbd_bus_id, ret);
+			RBD_MSG(msg, "repair failed to remap. Err %d", ret);
 			return PATH_DOWN;
 		}
 	}
@@ -488,22 +491,21 @@ static int rbd_repair(struct rbd_checker_context *ct, char *msg)
 	snprintf(del, sizeof(del), "%d force", ct->rbd_bus_id);
 	ret = sysfs_write_rbd_remove(del, strlen(del) + 1);
 	if (ret) {
-		RBD_MSG(msg, "rbd%d repair failed to clean up. Err %d",
-			ct->rbd_bus_id, ret);
+		RBD_MSG(msg, "repair failed to clean up. Err %d", ret);
 		return PATH_DOWN;
 	}
 
 	ret = rbd_rm_blacklist(ct);
 	if (ret) {
-		RBD_MSG(msg, "rbd%d repair could not remove blacklist entry. Err %d",
-			ct->rbd_bus_id, ret);
+		RBD_MSG(msg, "repair could not remove blacklist entry. Err %d",
+			ret);
 		return PATH_DOWN;
 	}
 
 	ct->remapped = 0;
 	ct->blacklisted = 0;
 
-	RBD_MSG(msg, "rbd%d has been repaired", ct->rbd_bus_id);
+	RBD_MSG(msg, "has been repaired");
 	return PATH_UP;
 }
 
@@ -528,7 +530,7 @@ void *rbd_thread(void *ctx)
 	struct rbd_checker_context *ct = ctx;
 	int state;
 
-	condlog(3, "rbd%d thread starting up", ct->rbd_bus_id);
+	condlog(3, "rbd%d: thread starting up", ct->rbd_bus_id);
 
 	ct->message[0] = '\0';
 	/* This thread can be canceled, so setup clean up */
@@ -547,7 +549,7 @@ void *rbd_thread(void *ctx)
 	pthread_mutex_unlock(&ct->lock);
 	pthread_cond_signal(&ct->active);
 
-	condlog(3, "rbd%d thead finished, state %s", ct->rbd_bus_id,
+	condlog(3, "rbd%d: thead finished, state %s", ct->rbd_bus_id,
 		checker_state_name(state));
 	rbd_thread_cleanup_pop(ct);
 	return ((void *)0);
@@ -577,16 +579,17 @@ static int rbd_exec_fn(struct checker *c, thread_fn *fn)
 	 */
 	r = pthread_mutex_lock(&ct->lock);
 	if (r != 0) {
-		condlog(2, "rbd%d mutex lock failed with %d", ct->rbd_bus_id,
+		condlog(2, "rbd%d: mutex lock failed with %d", ct->rbd_bus_id,
 			r);
-		MSG(c, "rbd%d thread failed to initialize", ct->rbd_bus_id);
+		MSG(c, "rbd%d: thread failed to initialize", ct->rbd_bus_id);
 		return PATH_WILD;
 	}
 
 	if (ct->running) {
 		/* Check if checker is still running */
 		if (ct->thread) {
-			condlog(3, "rbd%d thread not finished", ct->rbd_bus_id);
+			condlog(3, "rbd%d: thread not finished",
+				ct->rbd_bus_id);
 			rbd_status = PATH_PENDING;
 		} else {
 			/* checker done */
@@ -623,7 +626,7 @@ static int rbd_exec_fn(struct checker *c, thread_fn *fn)
 
 		if (ct->thread &&
 		    (rbd_status == PATH_PENDING || rbd_status == PATH_UNCHECKED)) {
-			condlog(3, "rbd%d thread still running",
+			condlog(3, "rbd%d: thread still running",
 				ct->rbd_bus_id);
 			ct->running = 1;
 			rbd_status = PATH_PENDING;
-- 
2.7.2
