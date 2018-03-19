From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/2] libmultipath: Fix recently introduced
	inconsistencies
Date: Mon, 19 Mar 2018 09:23:51 -0700
Message-ID: <20180319162351.28950-3-bart.vanassche@wdc.com>
References: <20180319162351.28950-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319162351.28950-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Commit 48e9fd9f67bb changed libmultipath such that an int is passed
as the second argument to some print_*() calls and a pointer to
other print_*() calls. Fix these inconsistencies by changing all
call-by-reference calls into call-by-value calls.

Fixes: 48e9fd9f67bb ("libmultipath: parser: use call-by-value for "snprint" methods")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c  |  4 ++--
 libmultipath/dict.h    | 14 +++++++-------
 libmultipath/propsel.c | 44 ++++++++++++++++++++++----------------------
 libmultipath/propsel.h |  4 ++--
 4 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 085a3e12d0a0..a4343b95172c 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -355,8 +355,8 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 
 	snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst->product);
 	reconcile_features_with_options(id, &dst->features,
-					&dst->no_path_retry,
-					&dst->retain_hwhandler);
+					dst->no_path_retry,
+					dst->retain_hwhandler);
 	return 0;
 }
 
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 044222736de7..756489217cff 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -9,12 +9,12 @@
 
 void init_keywords(vector keywords);
 int get_sys_max_fds(int *);
-int print_rr_weight (char * buff, int len, void *ptr);
-int print_pgfailback (char * buff, int len, void *ptr);
-int print_pgpolicy(char * buff, int len, void *ptr);
-int print_no_path_retry(char * buff, int len, void *ptr);
-int print_fast_io_fail(char * buff, int len, void *ptr);
-int print_dev_loss(char * buff, int len, void *ptr);
+int print_rr_weight(char *buff, int len, long v);
+int print_pgfailback(char *buff, int len, long v);
+int print_pgpolicy(char *buff, int len, long v);
+int print_no_path_retry(char *buff, int len, long v);
+int print_fast_io_fail(char *buff, int len, long v);
+int print_dev_loss(char *buff, int len, unsigned long v);
 int print_reservation_key(char * buff, int len, struct be64 key, int source);
-int print_off_int_undef(char * buff, int len, void *ptr);
+int print_off_int_undef(char *buff, int len, long v);
 #endif /* _DICT_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 06f2fd538835..683fefd94dee 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -150,7 +150,7 @@ int select_rr_weight(struct config *conf, struct multipath * mp)
 	mp_set_conf(rr_weight);
 	mp_set_default(rr_weight, DEFAULT_RR_WEIGHT);
 out:
-	print_rr_weight(buff, 13, &mp->rr_weight);
+	print_rr_weight(buff, 13, mp->rr_weight);
 	condlog(3, "%s: rr_weight = %s %s", mp->alias, buff, origin);
 	return 0;
 }
@@ -165,7 +165,7 @@ int select_pgfailback(struct config *conf, struct multipath * mp)
 	mp_set_conf(pgfailback);
 	mp_set_default(pgfailback, DEFAULT_FAILBACK);
 out:
-	print_pgfailback(buff, 13, &mp->pgfailback);
+	print_pgfailback(buff, 13, mp->pgfailback);
 	condlog(3, "%s: failback = %s %s", mp->alias, buff, origin);
 	return 0;
 }
@@ -283,8 +283,8 @@ out:
 	return mp->alias ? 0 : 1;
 }
 
-void reconcile_features_with_options(const char *id, char **features, int* no_path_retry,
-		  int *retain_hwhandler)
+void reconcile_features_with_options(const char *id, char **features, int no_path_retry,
+		  int retain_hwhandler)
 {
 	static const char q_i_n_p[] = "queue_if_no_path";
 	static const char r_a_h_h[] = "retain_attached_hw_handler";
@@ -307,15 +307,15 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 		condlog(0, "%s: option 'features \"1 %s\"' is deprecated, "
 			"please use 'no_path_retry queue' instead",
 			id, q_i_n_p);
-		if (*no_path_retry == NO_PATH_RETRY_UNDEF) {
-			*no_path_retry = NO_PATH_RETRY_QUEUE;
+		if (no_path_retry == NO_PATH_RETRY_UNDEF) {
+			no_path_retry = NO_PATH_RETRY_QUEUE;
 			print_no_path_retry(buff, sizeof(buff),
 					    no_path_retry);
 			condlog(3, "%s: no_path_retry = %s (inherited setting from feature '%s')",
 				id, buff, q_i_n_p);
 		};
 		/* Warn only if features string is overridden */
-		if (*no_path_retry != NO_PATH_RETRY_QUEUE) {
+		if (no_path_retry != NO_PATH_RETRY_QUEUE) {
 			print_no_path_retry(buff, sizeof(buff),
 					    no_path_retry);
 			condlog(2, "%s: ignoring feature '%s' because no_path_retry is set to '%s'",
@@ -326,11 +326,11 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 	if (strstr(*features, r_a_h_h)) {
 		condlog(0, "%s: option 'features \"1 %s\"' is deprecated",
 			id, r_a_h_h);
-		if (*retain_hwhandler == RETAIN_HWHANDLER_UNDEF) {
+		if (retain_hwhandler == RETAIN_HWHANDLER_UNDEF) {
 			condlog(3, "%s: %s = on (inherited setting from feature '%s')",
 				id, r_a_h_h, r_a_h_h);
-			*retain_hwhandler = RETAIN_HWHANDLER_ON;
-		} else if (*retain_hwhandler == RETAIN_HWHANDLER_OFF)
+			retain_hwhandler = RETAIN_HWHANDLER_ON;
+		} else if (retain_hwhandler == RETAIN_HWHANDLER_OFF)
 			condlog(2, "%s: ignoring feature '%s' because %s is set to 'off'",
 				id, r_a_h_h, r_a_h_h);
 		remove_feature(features, r_a_h_h);
@@ -350,8 +350,8 @@ out:
 	mp->features = STRDUP(mp->features);
 
 	reconcile_features_with_options(mp->alias, &mp->features,
-					&mp->no_path_retry,
-					&mp->retain_hwhandler);
+					mp->no_path_retry,
+					mp->retain_hwhandler);
 	condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features, origin);
 	return 0;
 }
@@ -566,7 +566,7 @@ int select_no_path_retry(struct config *conf, struct multipath *mp)
 	mp_set_hwe(no_path_retry);
 	mp_set_conf(no_path_retry);
 out:
-	print_no_path_retry(buff, 12, &mp->no_path_retry);
+	print_no_path_retry(buff, 12, mp->no_path_retry);
 	if (origin)
 		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
 			origin);
@@ -625,7 +625,7 @@ int select_fast_io_fail(struct config *conf, struct multipath *mp)
 	mp_set_conf(fast_io_fail);
 	mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
 out:
-	print_fast_io_fail(buff, 12, &mp->fast_io_fail);
+	print_fast_io_fail(buff, 12, mp->fast_io_fail);
 	condlog(3, "%s: fast_io_fail_tmo = %s %s", mp->alias, buff, origin);
 	return 0;
 }
@@ -640,7 +640,7 @@ int select_dev_loss(struct config *conf, struct multipath *mp)
 	mp->dev_loss = 0;
 	return 0;
 out:
-	print_dev_loss(buff, 12, &mp->dev_loss);
+	print_dev_loss(buff, 12, mp->dev_loss);
 	condlog(3, "%s: dev_loss_tmo = %s %s", mp->alias, buff, origin);
 	return 0;
 }
@@ -776,7 +776,7 @@ int select_delay_watch_checks(struct config *conf, struct multipath *mp)
 	mp_set_conf(delay_watch_checks);
 	mp_set_default(delay_watch_checks, DEFAULT_DELAY_CHECKS);
 out:
-	print_off_int_undef(buff, 12, &mp->delay_watch_checks);
+	print_off_int_undef(buff, 12, mp->delay_watch_checks);
 	condlog(3, "%s: delay_watch_checks = %s %s", mp->alias, buff, origin);
 	return 0;
 }
@@ -791,7 +791,7 @@ int select_delay_wait_checks(struct config *conf, struct multipath *mp)
 	mp_set_conf(delay_wait_checks);
 	mp_set_default(delay_wait_checks, DEFAULT_DELAY_CHECKS);
 out:
-	print_off_int_undef(buff, 12, &mp->delay_wait_checks);
+	print_off_int_undef(buff, 12, mp->delay_wait_checks);
 	condlog(3, "%s: delay_wait_checks = %s %s", mp->alias, buff, origin);
 	return 0;
 
@@ -807,7 +807,7 @@ int select_marginal_path_err_sample_time(struct config *conf, struct multipath *
 	mp_set_conf(marginal_path_err_sample_time);
 	mp_set_default(marginal_path_err_sample_time, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, &mp->marginal_path_err_sample_time);
+	print_off_int_undef(buff, 12, mp->marginal_path_err_sample_time);
 	condlog(3, "%s: marginal_path_err_sample_time = %s %s", mp->alias, buff,
 			origin);
 	return 0;
@@ -823,7 +823,7 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_err_rate_threshold);
 	mp_set_default(marginal_path_err_rate_threshold, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, &mp->marginal_path_err_rate_threshold);
+	print_off_int_undef(buff, 12, mp->marginal_path_err_rate_threshold);
 	condlog(3, "%s: marginal_path_err_rate_threshold = %s %s", mp->alias, buff,
 			origin);
 	return 0;
@@ -839,7 +839,7 @@ int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multip
 	mp_set_conf(marginal_path_err_recheck_gap_time);
 	mp_set_default(marginal_path_err_recheck_gap_time, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, &mp->marginal_path_err_recheck_gap_time);
+	print_off_int_undef(buff, 12, mp->marginal_path_err_recheck_gap_time);
 	condlog(3, "%s: marginal_path_err_recheck_gap_time = %s %s", mp->alias, buff,
 			origin);
 	return 0;
@@ -855,7 +855,7 @@ int select_marginal_path_double_failed_time(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_double_failed_time);
 	mp_set_default(marginal_path_double_failed_time, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, &mp->marginal_path_double_failed_time);
+	print_off_int_undef(buff, 12, mp->marginal_path_double_failed_time);
 	condlog(3, "%s: marginal_path_double_failed_time = %s %s", mp->alias, buff,
 			origin);
 	return 0;
@@ -908,7 +908,7 @@ int select_ghost_delay (struct config *conf, struct multipath * mp)
 	mp_set_conf(ghost_delay);
 	mp_set_default(ghost_delay, DEFAULT_GHOST_DELAY);
 out:
-	print_off_int_undef(buff, 12, &mp->ghost_delay);
+	print_off_int_undef(buff, 12, mp->ghost_delay);
 	condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
 	return 0;
 }
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 136f90605b91..ab7c358035bb 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -31,5 +31,5 @@ int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multip
 int select_marginal_path_double_failed_time(struct config *conf, struct multipath *mp);
 int select_ghost_delay(struct config *conf, struct multipath * mp);
 void reconcile_features_with_options(const char *id, char **features,
-				     int* no_path_retry,
-				     int *retain_hwhandler);
+				     int no_path_retry,
+				     int retain_hwhandler);
-- 
2.16.2
