From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/2] remove delay_(watch|wait)_checks
Date: Wed, 13 Dec 2017 12:08:06 -0600
Message-ID: <1513188487-31852-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>
List-Id: dm-devel.ids

These configuration options do essentially the same thing as the
marginal paths options do, but since they don't do the increased IO
testing, they are less likely to find the marginal paths. Guan, if you
left these in for a reason (such as to deal with devices that don't do
well with IO testing, such as passive paths) I'm open to keeping them.
But it seems like the marginal paths options options do a better job
than they do, and if there are cases that they doesn't handle well, they
should be expanded to do so.

Cc: Guan Junxiong <guanjunxiong@huawei.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.h    | 11 +----------
 libmultipath/config.c      |  2 --
 libmultipath/config.h      |  6 ------
 libmultipath/configure.c   |  2 --
 libmultipath/defaults.h    |  1 -
 libmultipath/dict.c        | 24 ------------------------
 libmultipath/print.c       |  2 --
 libmultipath/propsel.c     | 31 -------------------------------
 libmultipath/propsel.h     |  2 --
 libmultipath/structs.h     |  4 ----
 libmultipath/structs_vec.c |  3 +--
 multipath/multipath.conf.5 | 36 ------------------------------------
 multipathd/main.c          | 30 ++++--------------------------
 13 files changed, 6 insertions(+), 148 deletions(-)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 52154ca..3da1ed9 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -33,7 +33,7 @@
  * - Description: Path is up and I/O can be sent to it
  *
  * PATH_SHAKY:
- * - Use: Only emc_clariion
+ * - Use: Used by emc_clariion and the marginal path code
  * - Description: Indicates path not available for "normal" operations
  *
  * PATH_GHOST:
@@ -55,14 +55,6 @@
  * PATH REMOVED:
  * - Use: All checkers
  * - Description: Device has been removed from the system
- *
- * PATH_DELAYED:
- * - Use: None of the checkers (returned if the path is being delayed before
- *   reintegration.
- * - Description: If a path fails after being up for less than
- *   delay_watch_checks checks, when it comes back up again, it will not
- *   be marked as up until it has been up for delay_wait_checks checks.
- *   During this time, it is marked as "delayed"
  */
 enum path_check_state {
 	PATH_WILD,
@@ -74,7 +66,6 @@ enum path_check_state {
 	PATH_PENDING,
 	PATH_TIMEOUT,
 	PATH_REMOVED,
-	PATH_DELAYED,
 	PATH_MAX_STATE
 };
 
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 3d6a24c..2828abe 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -347,8 +347,6 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(detect_prio);
 	merge_num(detect_checker);
 	merge_num(deferred_remove);
-	merge_num(delay_watch_checks);
-	merge_num(delay_wait_checks);
 	merge_num(skip_kpartx);
 	merge_num(max_sectors_kb);
 	merge_num(ghost_delay);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index a20ac2a..9acb9af 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -73,8 +73,6 @@ struct hwentry {
 	int detect_prio;
 	int detect_checker;
 	int deferred_remove;
-	int delay_watch_checks;
-	int delay_wait_checks;
 	int marginal_path_err_sample_time;
 	int marginal_path_err_rate_threshold;
 	int marginal_path_err_recheck_gap_time;
@@ -107,8 +105,6 @@ struct mpentry {
 	int attribute_flags;
 	int user_friendly_names;
 	int deferred_remove;
-	int delay_watch_checks;
-	int delay_wait_checks;
 	int marginal_path_err_sample_time;
 	int marginal_path_err_rate_threshold;
 	int marginal_path_err_recheck_gap_time;
@@ -158,8 +154,6 @@ struct config {
 	int force_sync;
 	int deferred_remove;
 	int processed_main_config;
-	int delay_watch_checks;
-	int delay_wait_checks;
 	int marginal_path_err_sample_time;
 	int marginal_path_err_rate_threshold;
 	int marginal_path_err_recheck_gap_time;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b94e7ea..bfa5048 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -295,8 +295,6 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_dev_loss(conf, mpp);
 	select_reservation_key(conf, mpp);
 	select_deferred_remove(conf, mpp);
-	select_delay_watch_checks(conf, mpp);
-	select_delay_wait_checks(conf, mpp);
 	select_marginal_path_err_sample_time(conf, mpp);
 	select_marginal_path_err_rate_threshold(conf, mpp);
 	select_marginal_path_err_recheck_gap_time(conf, mpp);
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index c9e3411..8293f8a 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -24,7 +24,6 @@
 #define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
 #define DEFAULT_DETECT_CHECKER	DETECT_CHECKER_ON
 #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
-#define DEFAULT_DELAY_CHECKS	NU_NO
 #define DEFAULT_ERR_CHECKS	NU_NO
 #define DEFAULT_UEVENT_STACKSIZE 256
 #define DEFAULT_RETRIGGER_DELAY	10
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e52f1f7..d022130 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1067,22 +1067,6 @@ print_off_int_undef(char * buff, int len, void *ptr)
 	}
 }
 
-declare_def_handler(delay_watch_checks, set_off_int_undef)
-declare_def_snprint(delay_watch_checks, print_off_int_undef)
-declare_ovr_handler(delay_watch_checks, set_off_int_undef)
-declare_ovr_snprint(delay_watch_checks, print_off_int_undef)
-declare_hw_handler(delay_watch_checks, set_off_int_undef)
-declare_hw_snprint(delay_watch_checks, print_off_int_undef)
-declare_mp_handler(delay_watch_checks, set_off_int_undef)
-declare_mp_snprint(delay_watch_checks, print_off_int_undef)
-declare_def_handler(delay_wait_checks, set_off_int_undef)
-declare_def_snprint(delay_wait_checks, print_off_int_undef)
-declare_ovr_handler(delay_wait_checks, set_off_int_undef)
-declare_ovr_snprint(delay_wait_checks, print_off_int_undef)
-declare_hw_handler(delay_wait_checks, set_off_int_undef)
-declare_hw_snprint(delay_wait_checks, print_off_int_undef)
-declare_mp_handler(delay_wait_checks, set_off_int_undef)
-declare_mp_snprint(delay_wait_checks, print_off_int_undef)
 declare_def_handler(marginal_path_err_sample_time, set_off_int_undef)
 declare_def_snprint_defint(marginal_path_err_sample_time, print_off_int_undef,
 			   DEFAULT_ERR_CHECKS)
@@ -1461,8 +1445,6 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
 	install_keyword("partition_delimiter", &def_partition_delim_handler, &snprint_def_partition_delim);
 	install_keyword("config_dir", &def_config_dir_handler, &snprint_def_config_dir);
-	install_keyword("delay_watch_checks", &def_delay_watch_checks_handler, &snprint_def_delay_watch_checks);
-	install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &snprint_def_delay_wait_checks);
 	install_keyword("marginal_path_err_sample_time", &def_marginal_path_err_sample_time_handler, &snprint_def_marginal_path_err_sample_time);
 	install_keyword("marginal_path_err_rate_threshold", &def_marginal_path_err_rate_threshold_handler, &snprint_def_marginal_path_err_rate_threshold);
 	install_keyword("marginal_path_err_recheck_gap_time", &def_marginal_path_err_recheck_gap_time_handler, &snprint_def_marginal_path_err_recheck_gap_time);
@@ -1550,8 +1532,6 @@ init_keywords(vector keywords)
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
 	install_keyword("detect_checker", &hw_detect_checker_handler, &snprint_hw_detect_checker);
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
-	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
-	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
 	install_keyword("marginal_path_err_sample_time", &hw_marginal_path_err_sample_time_handler, &snprint_hw_marginal_path_err_sample_time);
 	install_keyword("marginal_path_err_rate_threshold", &hw_marginal_path_err_rate_threshold_handler, &snprint_hw_marginal_path_err_rate_threshold);
 	install_keyword("marginal_path_err_recheck_gap_time", &hw_marginal_path_err_recheck_gap_time_handler, &snprint_hw_marginal_path_err_recheck_gap_time);
@@ -1585,8 +1565,6 @@ init_keywords(vector keywords)
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
 	install_keyword("detect_checker", &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
-	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
-	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
 	install_keyword("marginal_path_err_sample_time", &ovr_marginal_path_err_sample_time_handler, &snprint_ovr_marginal_path_err_sample_time);
 	install_keyword("marginal_path_err_rate_threshold", &ovr_marginal_path_err_rate_threshold_handler, &snprint_ovr_marginal_path_err_rate_threshold);
 	install_keyword("marginal_path_err_recheck_gap_time", &ovr_marginal_path_err_recheck_gap_time_handler, &snprint_ovr_marginal_path_err_recheck_gap_time);
@@ -1619,8 +1597,6 @@ init_keywords(vector keywords)
 	install_keyword("reservation_key", &mp_reservation_key_handler, &snprint_mp_reservation_key);
 	install_keyword("user_friendly_names", &mp_user_friendly_names_handler, &snprint_mp_user_friendly_names);
 	install_keyword("deferred_remove", &mp_deferred_remove_handler, &snprint_mp_deferred_remove);
-	install_keyword("delay_watch_checks", &mp_delay_watch_checks_handler, &snprint_mp_delay_watch_checks);
-	install_keyword("delay_wait_checks", &mp_delay_wait_checks_handler, &snprint_mp_delay_wait_checks);
 	install_keyword("marginal_path_err_sample_time", &mp_marginal_path_err_sample_time_handler, &snprint_mp_marginal_path_err_sample_time);
 	install_keyword("marginal_path_err_rate_threshold", &mp_marginal_path_err_rate_threshold_handler, &snprint_mp_marginal_path_err_rate_threshold);
 	install_keyword("marginal_path_err_recheck_gap_time", &mp_marginal_path_err_recheck_gap_time_handler, &snprint_mp_marginal_path_err_recheck_gap_time);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 65a9824..f9ad4ea 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -428,8 +428,6 @@ snprint_chk_state (char * buff, size_t len, struct path * pp)
 		return snprintf(buff, len, "i/o pending");
 	case PATH_TIMEOUT:
 		return snprintf(buff, len, "i/o timeout");
-	case PATH_DELAYED:
-		return snprintf(buff, len, "delayed");
 	default:
 		return snprintf(buff, len, "undef");
 	}
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index be371fc..233a8ba 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -730,37 +730,6 @@ out:
 	return 0;
 }
 
-int select_delay_watch_checks(struct config *conf, struct multipath *mp)
-{
-	char *origin, buff[12];
-
-	mp_set_mpe(delay_watch_checks);
-	mp_set_ovr(delay_watch_checks);
-	mp_set_hwe(delay_watch_checks);
-	mp_set_conf(delay_watch_checks);
-	mp_set_default(delay_watch_checks, DEFAULT_DELAY_CHECKS);
-out:
-	print_off_int_undef(buff, 12, &mp->delay_watch_checks);
-	condlog(3, "%s: delay_watch_checks = %s %s", mp->alias, buff, origin);
-	return 0;
-}
-
-int select_delay_wait_checks(struct config *conf, struct multipath *mp)
-{
-	char *origin, buff[12];
-
-	mp_set_mpe(delay_wait_checks);
-	mp_set_ovr(delay_wait_checks);
-	mp_set_hwe(delay_wait_checks);
-	mp_set_conf(delay_wait_checks);
-	mp_set_default(delay_wait_checks, DEFAULT_DELAY_CHECKS);
-out:
-	print_off_int_undef(buff, 12, &mp->delay_wait_checks);
-	condlog(3, "%s: delay_wait_checks = %s %s", mp->alias, buff, origin);
-	return 0;
-
-}
-
 int select_marginal_path_err_sample_time(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 136f906..aea973b 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -21,8 +21,6 @@ int select_retain_hwhandler (struct config *conf, struct multipath * mp);
 int select_detect_prio(struct config *conf, struct path * pp);
 int select_detect_checker(struct config *conf, struct path * pp);
 int select_deferred_remove(struct config *conf, struct multipath *mp);
-int select_delay_watch_checks (struct config *conf, struct multipath * mp);
-int select_delay_wait_checks (struct config *conf, struct multipath * mp);
 int select_skip_kpartx (struct config *conf, struct multipath * mp);
 int select_max_sectors_kb (struct config *conf, struct multipath * mp);
 int select_marginal_path_err_sample_time(struct config *conf, struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index bfa660a..f141558 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -231,8 +231,6 @@ struct path {
 	int pgindex;
 	int detect_prio;
 	int detect_checker;
-	int watch_checks;
-	int wait_checks;
 	int tpgs;
 	char * uid_attribute;
 	char * getuid;
@@ -278,8 +276,6 @@ struct multipath {
 	int fast_io_fail;
 	int retain_hwhandler;
 	int deferred_remove;
-	int delay_watch_checks;
-	int delay_wait_checks;
 	int marginal_path_err_sample_time;
 	int marginal_path_err_rate_threshold;
 	int marginal_path_err_recheck_gap_time;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index fbab61f..ee3670d 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -390,8 +390,7 @@ sync_map_state(struct multipath *mpp)
 	vector_foreach_slot (mpp->pg, pgp, i){
 		vector_foreach_slot (pgp->paths, pp, j){
 			if (pp->state == PATH_UNCHECKED ||
-			    pp->state == PATH_WILD ||
-			    pp->state == PATH_DELAYED)
+			    pp->state == PATH_WILD)
 				continue;
 			if (mpp->ghost_delay_tick > 0)
 				continue;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ab151e7..fee3cbe 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -909,30 +909,6 @@ The default is: \fBno\fR
 .
 .
 .TP
-.B delay_watch_checks
-If set to a value greater than 0, multipathd will watch paths that have
-recently become valid for this many checks. If they fail again while they are
-being watched, when they next become valid, they will not be used until they
-have stayed up for \fIdelay_wait_checks\fR checks.
-.RS
-.TP
-The default is: \fBno\fR
-.RE
-.
-.
-.TP
-.B delay_wait_checks
-If set to a value greater than 0, when a device that has recently come back
-online fails again within \fIdelay_watch_checks\fR checks, the next time it
-comes back online, it will marked and delayed, and not used until it has passed
-\fIdelay_wait_checks\fR checks.
-.RS
-.TP
-The default is: \fBno\fR
-.RE
-.
-.
-.TP
 .B find_multipaths
 If set to
 .I yes
@@ -1194,10 +1170,6 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .TP
 .B marginal_path_double_failed_time
 .TP
-.B delay_watch_checks
-.TP
-.B delay_wait_checks
-.TP
 .B skip_kpartx
 .TP
 .B max_sectors_kb
@@ -1325,10 +1297,6 @@ section:
 .TP
 .B marginal_path_double_failed_time
 .TP
-.B delay_watch_checks
-.TP
-.B delay_wait_checks
-.TP
 .B skip_kpartx
 .TP
 .B max_sectors_kb
@@ -1401,10 +1369,6 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B marginal_path_double_failed_time
 .TP
-.B delay_watch_checks
-.TP
-.B delay_wait_checks
-.TP
 .B skip_kpartx
 .TP
 .B ghost_delay
diff --git a/multipathd/main.c b/multipathd/main.c
index 0703ca0..8004867 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1633,16 +1633,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		return 1;
 	}
 
-	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
-	     pp->wait_checks > 0) {
-		if (pp->mpp->nr_active > 0) {
-			pp->state = PATH_DELAYED;
-			pp->wait_checks--;
-			return 1;
-		} else
-			pp->wait_checks = 0;
-	}
-
 	/*
 	 * don't reinstate failed path, if its in stand-by
 	 * and if target supports only implicit tpgs mode.
@@ -1673,14 +1663,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			 * proactively fail path in the DM
 			 */
 			if (oldstate == PATH_UP ||
-			    oldstate == PATH_GHOST) {
+			    oldstate == PATH_GHOST)
 				fail_path(pp, 1);
-				if (pp->mpp->delay_wait_checks > 0 &&
-				    pp->watch_checks > 0) {
-					pp->wait_checks = pp->mpp->delay_wait_checks;
-					pp->watch_checks = 0;
-				}
-			}else
+			else
 				fail_path(pp, 0);
 
 			/*
@@ -1708,15 +1693,10 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		 * reinstate this path
 		 */
 		if (oldstate != PATH_UP &&
-		    oldstate != PATH_GHOST) {
-			if (pp->mpp->delay_watch_checks > 0)
-				pp->watch_checks = pp->mpp->delay_watch_checks;
+		    oldstate != PATH_GHOST)
 			add_active = 1;
-		} else {
-			if (pp->watch_checks > 0)
-				pp->watch_checks--;
+		else
 			add_active = 0;
-		}
 		if (!disable_reinstate && reinstate_path(pp, add_active)) {
 			condlog(3, "%s: reload map", pp->dev);
 			ev_add_path(pp, vecs, 1);
@@ -1765,8 +1745,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 				condlog(4, "%s: delay next check %is",
 					pp->dev_t, pp->checkint);
 			}
-			if (pp->watch_checks > 0)
-				pp->watch_checks--;
 			pp->tick = pp->checkint;
 		}
 	}
-- 
2.7.4
