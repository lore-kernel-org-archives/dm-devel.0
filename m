From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/57] libmultipath: finally fix dev_loss_tmo
	setting
Date: Wed, 27 Apr 2016 13:10:11 +0200
Message-ID: <1461755458-29225-11-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

We need to take the current value when comparing
'dev_loss_tmo' and 'fast_io_fail', otherwise we still
might be getting an error as we might comparing wrong
values.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/defaults.h    |  1 +
 libmultipath/discovery.c   | 72 ++++++++++++++++++++++++----------------------
 multipath/multipath.conf.5 |  2 +-
 3 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index bce8bcc..96f5a2c 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -15,6 +15,7 @@
 #define DEFAULT_REASSIGN_MAPS	0
 #define DEFAULT_FIND_MULTIPATHS	0
 #define DEFAULT_FAST_IO_FAIL	5
+#define DEFAULT_DEV_LOSS_TMO   600
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
 #define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
 #define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 324e217..83cc4f7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -504,6 +504,22 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 		pp->sg_id.channel, pp->sg_id.scsi_id, rport_id);
 
 	/*
+	 * read the current dev_loss_tmo value from sysfs
+	 */
+	ret = sysfs_attr_get_value(rport_dev, "dev_loss_tmo", value, 16);
+	if (ret <= 0) {
+		condlog(0, "%s: failed to read dev_loss_tmo value, "
+			"error %d", rport_id, -ret);
+		goto out;
+	}
+	tmo = strtoull(value, &eptr, 0);
+	if (value == eptr || tmo == ULLONG_MAX) {
+		condlog(0, "%s: Cannot parse dev_loss_tmo "
+			"attribute '%s'", rport_id, value);
+		goto out;
+	}
+
+	/*
 	 * This is tricky.
 	 * dev_loss_tmo will be limited to 600 if fast_io_fail
 	 * is _not_ set.
@@ -514,45 +530,31 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	 * then set fast_io_fail, and _then_ set dev_loss_tmo
 	 * to the correct value.
 	 */
-	memset(value, 0, 16);
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
 		/* Check if we need to temporarily increase dev_loss_tmo */
-		ret = sysfs_attr_get_value(rport_dev, "dev_loss_tmo",
-					   value, 16);
-		if (ret <= 0) {
-			condlog(0, "%s: failed to read dev_loss_tmo value, "
-				"error %d", rport_id, -ret);
-			goto out;
-		}
-		tmo = strtoull(value, &eptr, 0);
-		if (value == eptr || tmo == ULLONG_MAX) {
-			condlog(0, "%s: Cannot parse dev_loss_tmo "
-				"attribute '%s'", rport_id, value);
-			goto out;
-		}
 		if (mpp->fast_io_fail >= tmo) {
+			/* Increase dev_loss_tmo temporarily */
 			snprintf(value, 16, "%u", mpp->fast_io_fail + 1);
+			ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
+						   value, strlen(value));
+			if (ret <= 0) {
+				if (ret == -EBUSY)
+					condlog(3, "%s: rport blocked",
+						rport_id);
+				else
+					condlog(0, "%s: failed to set "
+						"dev_loss_tmo to %s, error %d",
+						rport_id, value, -ret);
+				goto out;
+			}
 		}
-	} else if (mpp->dev_loss > 600) {
-		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
-			"fast_io_fail is not set", rport_id);
-		snprintf(value, 16, "%u", 600);
-	} else {
-		snprintf(value, 16, "%u", mpp->dev_loss);
-	}
-	if (strlen(value)) {
-		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
-					   value, strlen(value));
-		if (ret <= 0) {
-			if (ret == -EBUSY)
-				condlog(3, "%s: rport blocked", rport_id);
-			else
-				condlog(0, "%s: failed to set dev_loss_tmo to %s, error %d",
-					rport_id, value, -ret);
-			goto out;
-		}
+	} else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO) {
+		condlog(3, "%s: limiting dev_loss_tmo to %d, since "
+			"fast_io_fail is not set",
+			rport_id, DEFAULT_DEV_LOSS_TMO);
+		mpp->dev_loss = DEFAULT_DEV_LOSS_TMO;
 	}
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
@@ -571,7 +573,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 					rport_id, value, -ret);
 		}
 	}
-	if (tmo > 0) {
+	if (mpp->dev_loss > 0) {
 		snprintf(value, 16, "%u", mpp->dev_loss);
 		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
 					   value, strlen(value));
@@ -673,11 +675,11 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
 		if (no_path_retry_tmo > dev_loss_tmo)
 			dev_loss_tmo = no_path_retry_tmo;
-		condlog(3, "%s: update dev_loss_tmo to %d",
+		condlog(3, "%s: update dev_loss_tmo to %u",
 			mpp->alias, dev_loss_tmo);
 	} else if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE) {
 		dev_loss_tmo = MAX_DEV_LOSS_TMO;
-		condlog(3, "%s: update dev_loss_tmo to %d",
+		condlog(3, "%s: update dev_loss_tmo to %u",
 			mpp->alias, dev_loss_tmo);
 	}
 	mpp->dev_loss = dev_loss_tmo;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0d4df0f..b21279e 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -394,7 +394,7 @@ retry interval
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
 The linux kernel will cap this value to \fI300\fR if \fBfast_io_fail_tmo\fR
-is not set.
+is not set. Default is 600.
 .TP
 .B queue_without_daemon
 If set to
-- 
2.6.6
