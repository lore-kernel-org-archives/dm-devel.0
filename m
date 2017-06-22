From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 03/11] libmultipath: clarify option conflicts
	for "features"
Date: Thu, 22 Jun 2017 16:59:05 +0200
Message-ID: <20170622145913.23714-4-mwilck@suse.com>
References: <20170622145913.23714-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622145913.23714-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

The "features" option in multipath.conf can possibly conflict
with "no_path_retry" and "retain_attached_hw_handler".

Currently, "no_path_retry" takes precedence, unless it is set to
"fail", in which case it's overridden by "queue_if_no_path".
This is odd, either "features" or "no_path_retry" should take
precedence.
No precedence rules are defined for "retain_attached_hw_handler".

Make this behavior more consistent by always giving precedence
to the explicit config file options, and improve logging.

Put this logic into a separate function, which can be used
from other places in the code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c |  6 ++---
 libmultipath/propsel.c   | 68 +++++++++++++++++++++++++++++++++++++-----------
 libmultipath/propsel.h   |  3 +++
 3 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index bd090d9a..a7f2b443 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -280,18 +280,18 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_pgfailback(conf, mpp);
 	select_pgpolicy(conf, mpp);
 	select_selector(conf, mpp);
-	select_features(conf, mpp);
 	select_hwhandler(conf, mpp);
+	select_no_path_retry(conf, mpp);
+	select_retain_hwhandler(conf, mpp);
+	select_features(conf, mpp);
 	select_rr_weight(conf, mpp);
 	select_minio(conf, mpp);
-	select_no_path_retry(conf, mpp);
 	select_mode(conf, mpp);
 	select_uid(conf, mpp);
 	select_gid(conf, mpp);
 	select_fast_io_fail(conf, mpp);
 	select_dev_loss(conf, mpp);
 	select_reservation_key(conf, mpp);
-	select_retain_hwhandler(conf, mpp);
 	select_deferred_remove(conf, mpp);
 	select_delay_watch_checks(conf, mpp);
 	select_delay_wait_checks(conf, mpp);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index c8ccede5..bc9e130b 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -269,6 +269,55 @@ out:
 	return mp->alias ? 0 : 1;
 }
 
+void reconcile_features_with_options(const char *id, char **features, int* no_path_retry,
+		  int *retain_hwhandler)
+{
+	static const char q_i_n_p[] = "queue_if_no_path";
+	static const char r_a_h_h[] = "retain_attached_hw_handler";
+	char buff[12];
+
+	if (*features == NULL)
+		return;
+	if (id == NULL)
+		id = "UNKNOWN";
+
+	/*
+	 * We only use no_path_retry internally. The "queue_if_no_path"
+	 * device-mapper feature is derived from it when the map is loaded.
+	 * For consistency, "queue_if_no_path" is removed from the
+	 * internal libmultipath features string.
+	 * For backward compatibility we allow 'features "1 queue_if_no_path"';
+	 * it's translated into "no_path_retry queue" here.
+	 */
+	if (strstr(*features, q_i_n_p)) {
+		if (*no_path_retry == NO_PATH_RETRY_UNDEF) {
+			*no_path_retry = NO_PATH_RETRY_QUEUE;
+			print_no_path_retry(buff, sizeof(buff),
+					    no_path_retry);
+			condlog(3, "%s: no_path_retry = %s (inherited setting from feature '%s')",
+				id, buff, q_i_n_p);
+		};
+		/* Warn only if features string is overridden */
+		if (*no_path_retry != NO_PATH_RETRY_QUEUE) {
+			print_no_path_retry(buff, sizeof(buff),
+					    no_path_retry);
+			condlog(2, "%s: ignoring feature '%s' because no_path_retry is set to '%s'",
+				id, q_i_n_p, buff);
+		}
+		remove_feature(features, q_i_n_p);
+	}
+	if (strstr(*features, r_a_h_h)) {
+		if (*retain_hwhandler == RETAIN_HWHANDLER_UNDEF) {
+			condlog(3, "%s: %s = on (inherited setting from feature '%s')",
+				id, r_a_h_h, r_a_h_h);
+			*retain_hwhandler = RETAIN_HWHANDLER_ON;
+		} else if (*retain_hwhandler == RETAIN_HWHANDLER_OFF)
+			condlog(2, "%s: ignoring feature '%s' because %s is set to 'off'",
+				id, r_a_h_h, r_a_h_h);
+		remove_feature(features, r_a_h_h);
+	}
+}
+
 int select_features(struct config *conf, struct multipath *mp)
 {
 	char *origin;
@@ -280,19 +329,11 @@ int select_features(struct config *conf, struct multipath *mp)
 	mp_set_default(features, DEFAULT_FEATURES);
 out:
 	mp->features = STRDUP(mp->features);
-	condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features, origin);
 
-	if (strstr(mp->features, "queue_if_no_path")) {
-		if (mp->no_path_retry == NO_PATH_RETRY_UNDEF)
-			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
-		else if (mp->no_path_retry == NO_PATH_RETRY_FAIL) {
-			condlog(1, "%s: config ERROR (setting: overriding 'no_path_retry' value)",
-				mp->alias);
-			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
-		} else if (mp->no_path_retry != NO_PATH_RETRY_QUEUE)
-			condlog(1, "%s: config ERROR (setting: ignoring 'queue_if_no_path' because no_path_retry = %d)",
-				mp->alias, mp->no_path_retry);
-	}
+	reconcile_features_with_options(mp->alias, &mp->features,
+					&mp->no_path_retry,
+					&mp->retain_hwhandler);
+	condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features, origin);
 	return 0;
 }
 
@@ -469,9 +510,6 @@ out:
 	if (origin)
 		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
 			origin);
-	else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
-		condlog(3, "%s: no_path_retry = %s (setting: inherited value)",
-			mp->alias, buff);
 	else
 		condlog(3, "%s: no_path_retry = undef (setting: multipath internal)",
 			mp->alias);
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 58a32f3c..f8e96d85 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -28,3 +28,6 @@ int select_max_sectors_kb (struct config *conf, struct multipath * mp);
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp);
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp);
+void reconcile_features_with_options(const char *id, char **features,
+				     int* no_path_retry,
+				     int *retain_hwhandler);
-- 
2.13.1
