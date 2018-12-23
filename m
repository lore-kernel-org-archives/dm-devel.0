From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/20] libmultipath: propsel: don't print
	undefined values
Date: Sun, 23 Dec 2018 23:21:09 +0100
Message-ID: <20181223222126.30882-4-mwilck@suse.com>
References: <20181223222126.30882-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181223222126.30882-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

print_off_int_undef() may return 0 if passed NU_UNDEF,
in which case the buffer contents are undefined.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 970a3b5c..7b19fed0 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -855,8 +855,9 @@ int select_delay_watch_checks(struct config *conf, struct multipath *mp)
 	mp_set_conf(delay_watch_checks);
 	mp_set_default(delay_watch_checks, DEFAULT_DELAY_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->delay_watch_checks);
-	condlog(3, "%s: delay_watch_checks = %s %s", mp->alias, buff, origin);
+	if (print_off_int_undef(buff, 12, mp->delay_watch_checks) != 0)
+		condlog(3, "%s: delay_watch_checks = %s %s",
+			mp->alias, buff, origin);
 	return 0;
 }
 
@@ -871,8 +872,9 @@ int select_delay_wait_checks(struct config *conf, struct multipath *mp)
 	mp_set_conf(delay_wait_checks);
 	mp_set_default(delay_wait_checks, DEFAULT_DELAY_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->delay_wait_checks);
-	condlog(3, "%s: delay_wait_checks = %s %s", mp->alias, buff, origin);
+	if (print_off_int_undef(buff, 12, mp->delay_wait_checks) != 0)
+		condlog(3, "%s: delay_wait_checks = %s %s",
+			mp->alias, buff, origin);
 	return 0;
 
 }
@@ -888,9 +890,10 @@ int select_marginal_path_err_sample_time(struct config *conf, struct multipath *
 	mp_set_conf(marginal_path_err_sample_time);
 	mp_set_default(marginal_path_err_sample_time, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->marginal_path_err_sample_time);
-	condlog(3, "%s: marginal_path_err_sample_time = %s %s", mp->alias, buff,
-			origin);
+	if (print_off_int_undef(buff, 12, mp->marginal_path_err_sample_time)
+	    != 0)
+		condlog(3, "%s: marginal_path_err_sample_time = %s %s",
+			mp->alias, buff, origin);
 	return 0;
 }
 
@@ -905,9 +908,10 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_err_rate_threshold);
 	mp_set_default(marginal_path_err_rate_threshold, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->marginal_path_err_rate_threshold);
-	condlog(3, "%s: marginal_path_err_rate_threshold = %s %s", mp->alias, buff,
-			origin);
+	if (print_off_int_undef(buff, 12, mp->marginal_path_err_rate_threshold)
+	    != 0)
+		condlog(3, "%s: marginal_path_err_rate_threshold = %s %s",
+			mp->alias, buff, origin);
 	return 0;
 }
 
@@ -922,9 +926,10 @@ int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multip
 	mp_set_conf(marginal_path_err_recheck_gap_time);
 	mp_set_default(marginal_path_err_recheck_gap_time, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->marginal_path_err_recheck_gap_time);
-	condlog(3, "%s: marginal_path_err_recheck_gap_time = %s %s", mp->alias, buff,
-			origin);
+	if (print_off_int_undef(buff, 12,
+				mp->marginal_path_err_recheck_gap_time) != 0)
+		condlog(3, "%s: marginal_path_err_recheck_gap_time = %s %s",
+			mp->alias, buff, origin);
 	return 0;
 }
 
@@ -939,9 +944,10 @@ int select_marginal_path_double_failed_time(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_double_failed_time);
 	mp_set_default(marginal_path_double_failed_time, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->marginal_path_double_failed_time);
-	condlog(3, "%s: marginal_path_double_failed_time = %s %s", mp->alias, buff,
-			origin);
+	if (print_off_int_undef(buff, 12, mp->marginal_path_double_failed_time)
+	    != 0)
+		condlog(3, "%s: marginal_path_double_failed_time = %s %s",
+			mp->alias, buff, origin);
 	return 0;
 }
 
@@ -993,8 +999,8 @@ int select_ghost_delay (struct config *conf, struct multipath * mp)
 	mp_set_conf(ghost_delay);
 	mp_set_default(ghost_delay, DEFAULT_GHOST_DELAY);
 out:
-	print_off_int_undef(buff, 12, mp->ghost_delay);
-	condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
+	if (print_off_int_undef(buff, 12, mp->ghost_delay) != 0)
+		condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
 	return 0;
 }
 
-- 
2.19.2
