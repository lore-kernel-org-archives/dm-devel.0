From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH V4 2/2] multipath-tools: discard san_path_err_XXX
	feature
Date: Sun, 17 Sep 2017 11:40:38 +0800
Message-ID: <1505619638-20912-3-git-send-email-guanjunxiong@huawei.com>
References: <1505619638-20912-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505619638-20912-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, mwilck@suse.com
Cc: guanjunxiong@huawei.com, chengjike.cheng@huawei.com, mmandala@brocade.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Even the san_path_err_threshold , san_path_err_forget_rate and
san_path_err_recovery_time is turned on, the detect sample interval of
that path checkers is so big/coarse that it doesn't see what happens
in the middle of the sample interval.

Now we have new method  of detecting path state of IO erros
especially for intermittent IO errors in the previous patch.

Therefore, discard the original commit "c3705a12b893cc302a89587c4d37".

Cc: M Muneendra Kumar <mmandala@brocade.com>
Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/config.c      |  3 --
 libmultipath/config.h      |  9 -----
 libmultipath/configure.c   |  3 --
 libmultipath/dict.c        | 39 ---------------------
 libmultipath/propsel.c     | 47 --------------------------
 libmultipath/propsel.h     |  3 --
 libmultipath/structs.h     |  7 ----
 multipath/multipath.conf.5 | 57 -------------------------------
 multipathd/main.c          | 84 ----------------------------------------------
 9 files changed, 252 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index b21a3aa1..d85ba7cc 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -351,9 +351,6 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(delay_wait_checks);
 	merge_num(skip_kpartx);
 	merge_num(max_sectors_kb);
-	merge_num(san_path_err_threshold);
-	merge_num(san_path_err_forget_rate);
-	merge_num(san_path_err_recovery_time);
 
 	snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst->product);
 	reconcile_features_with_options(id, &dst->features,
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 215d29e9..4aa944d0 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -72,9 +72,6 @@ struct hwentry {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
-	int san_path_err_threshold;
-	int san_path_err_forget_rate;
-	int san_path_err_recovery_time;
 	int path_io_err_sample_time;
 	int path_io_err_rate_threshold;
 	int path_io_err_recovery_time;
@@ -106,9 +103,6 @@ struct mpentry {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
-	int san_path_err_threshold;
-	int san_path_err_forget_rate;
-	int san_path_err_recovery_time;
 	int path_io_err_sample_time;
 	int path_io_err_rate_threshold;
 	int path_io_err_recovery_time;
@@ -158,9 +152,6 @@ struct config {
 	int processed_main_config;
 	int delay_watch_checks;
 	int delay_wait_checks;
-	int san_path_err_threshold;
-	int san_path_err_forget_rate;
-	int san_path_err_recovery_time;
 	int path_io_err_sample_time;
 	int path_io_err_rate_threshold;
 	int path_io_err_recovery_time;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 81dc97d9..44e61864 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -295,9 +295,6 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_deferred_remove(conf, mpp);
 	select_delay_watch_checks(conf, mpp);
 	select_delay_wait_checks(conf, mpp);
-	select_san_path_err_threshold(conf, mpp);
-	select_san_path_err_forget_rate(conf, mpp);
-	select_san_path_err_recovery_time(conf, mpp);
 	select_path_io_err_sample_time(conf, mpp);
 	select_path_io_err_rate_threshold(conf, mpp);
 	select_path_io_err_recovery_time(conf, mpp);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 18b1fdb1..d42c7ba9 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1081,33 +1081,6 @@ declare_hw_handler(delay_wait_checks, set_off_int_undef)
 declare_hw_snprint(delay_wait_checks, print_off_int_undef)
 declare_mp_handler(delay_wait_checks, set_off_int_undef)
 declare_mp_snprint(delay_wait_checks, print_off_int_undef)
-declare_def_handler(san_path_err_threshold, set_off_int_undef)
-declare_def_snprint_defint(san_path_err_threshold, print_off_int_undef,
-			   DEFAULT_ERR_CHECKS)
-declare_ovr_handler(san_path_err_threshold, set_off_int_undef)
-declare_ovr_snprint(san_path_err_threshold, print_off_int_undef)
-declare_hw_handler(san_path_err_threshold, set_off_int_undef)
-declare_hw_snprint(san_path_err_threshold, print_off_int_undef)
-declare_mp_handler(san_path_err_threshold, set_off_int_undef)
-declare_mp_snprint(san_path_err_threshold, print_off_int_undef)
-declare_def_handler(san_path_err_forget_rate, set_off_int_undef)
-declare_def_snprint_defint(san_path_err_forget_rate, print_off_int_undef,
-			   DEFAULT_ERR_CHECKS)
-declare_ovr_handler(san_path_err_forget_rate, set_off_int_undef)
-declare_ovr_snprint(san_path_err_forget_rate, print_off_int_undef)
-declare_hw_handler(san_path_err_forget_rate, set_off_int_undef)
-declare_hw_snprint(san_path_err_forget_rate, print_off_int_undef)
-declare_mp_handler(san_path_err_forget_rate, set_off_int_undef)
-declare_mp_snprint(san_path_err_forget_rate, print_off_int_undef)
-declare_def_handler(san_path_err_recovery_time, set_off_int_undef)
-declare_def_snprint_defint(san_path_err_recovery_time, print_off_int_undef,
-			   DEFAULT_ERR_CHECKS)
-declare_ovr_handler(san_path_err_recovery_time, set_off_int_undef)
-declare_ovr_snprint(san_path_err_recovery_time, print_off_int_undef)
-declare_hw_handler(san_path_err_recovery_time, set_off_int_undef)
-declare_hw_snprint(san_path_err_recovery_time, print_off_int_undef)
-declare_mp_handler(san_path_err_recovery_time, set_off_int_undef)
-declare_mp_snprint(san_path_err_recovery_time, print_off_int_undef)
 declare_def_handler(path_io_err_sample_time, set_off_int_undef)
 declare_def_snprint_defint(path_io_err_sample_time, print_off_int_undef,
 			   DEFAULT_ERR_CHECKS)
@@ -1469,9 +1442,6 @@ init_keywords(vector keywords)
 	install_keyword("config_dir", &def_config_dir_handler, &snprint_def_config_dir);
 	install_keyword("delay_watch_checks", &def_delay_watch_checks_handler, &snprint_def_delay_watch_checks);
 	install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &snprint_def_delay_wait_checks);
-	install_keyword("san_path_err_threshold", &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
-	install_keyword("san_path_err_forget_rate", &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_forget_rate);
-	install_keyword("san_path_err_recovery_time", &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_recovery_time);
 	install_keyword("path_io_err_sample_time", &def_path_io_err_sample_time_handler, &snprint_def_path_io_err_sample_time);
 	install_keyword("path_io_err_rate_threshold", &def_path_io_err_rate_threshold_handler, &snprint_def_path_io_err_rate_threshold);
 	install_keyword("path_io_err_recovery_time", &def_path_io_err_recovery_time_handler, &snprint_def_path_io_err_recovery_time);
@@ -1559,9 +1529,6 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
-	install_keyword("san_path_err_threshold", &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
-	install_keyword("san_path_err_forget_rate", &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_forget_rate);
-	install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
 	install_keyword("path_io_err_sample_time", &hw_path_io_err_sample_time_handler, &snprint_hw_path_io_err_sample_time);
 	install_keyword("path_io_err_rate_threshold", &hw_path_io_err_rate_threshold_handler, &snprint_hw_path_io_err_rate_threshold);
 	install_keyword("path_io_err_recovery_time", &hw_path_io_err_recovery_time_handler, &snprint_hw_path_io_err_recovery_time);
@@ -1595,9 +1562,6 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
-	install_keyword("san_path_err_threshold", &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
-	install_keyword("san_path_err_forget_rate", &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_forget_rate);
-	install_keyword("san_path_err_recovery_time", &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_recovery_time);
 	install_keyword("path_io_err_sample_time", &ovr_path_io_err_sample_time_handler, &snprint_ovr_path_io_err_sample_time);
 	install_keyword("path_io_err_rate_threshold", &ovr_path_io_err_rate_threshold_handler, &snprint_ovr_path_io_err_rate_threshold);
 	install_keyword("path_io_err_recovery_time", &ovr_path_io_err_recovery_time_handler, &snprint_ovr_path_io_err_recovery_time);
@@ -1630,9 +1594,6 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &mp_deferred_remove_handler, &snprint_mp_deferred_remove);
 	install_keyword("delay_watch_checks", &mp_delay_watch_checks_handler, &snprint_mp_delay_watch_checks);
 	install_keyword("delay_wait_checks", &mp_delay_wait_checks_handler, &snprint_mp_delay_wait_checks);
-	install_keyword("san_path_err_threshold", &mp_san_path_err_threshold_handler, &snprint_mp_san_path_err_threshold);
-	install_keyword("san_path_err_forget_rate", &mp_san_path_err_forget_rate_handler, &snprint_mp_san_path_err_forget_rate);
-	install_keyword("san_path_err_recovery_time", &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_recovery_time);
 	install_keyword("path_io_err_sample_time", &mp_path_io_err_sample_time_handler, &snprint_mp_path_io_err_sample_time);
 	install_keyword("path_io_err_rate_threshold", &mp_path_io_err_rate_threshold_handler, &snprint_mp_path_io_err_rate_threshold);
 	install_keyword("path_io_err_recovery_time", &mp_path_io_err_recovery_time_handler, &snprint_mp_path_io_err_recovery_time);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 9d2c3c09..9aab9805 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -732,53 +732,6 @@ out:
 
 }
 
-int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
-{
-	char *origin, buff[12];
-
-	mp_set_mpe(san_path_err_threshold);
-	mp_set_ovr(san_path_err_threshold);
-	mp_set_hwe(san_path_err_threshold);
-	mp_set_conf(san_path_err_threshold);
-	mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
-out:
-	print_off_int_undef(buff, 12, &mp->san_path_err_threshold);
-	condlog(3, "%s: san_path_err_threshold = %s %s", mp->alias, buff, origin);
-	return 0;
-}
-
-int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
-{
-	char *origin, buff[12];
-
-	mp_set_mpe(san_path_err_forget_rate);
-	mp_set_ovr(san_path_err_forget_rate);
-	mp_set_hwe(san_path_err_forget_rate);
-	mp_set_conf(san_path_err_forget_rate);
-	mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
-out:
-	print_off_int_undef(buff, 12, &mp->san_path_err_forget_rate);
-	condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias, buff, origin);
-	return 0;
-
-}
-
-int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
-{
-	char *origin, buff[12];
-
-	mp_set_mpe(san_path_err_recovery_time);
-	mp_set_ovr(san_path_err_recovery_time);
-	mp_set_hwe(san_path_err_recovery_time);
-	mp_set_conf(san_path_err_recovery_time);
-	mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
-out:
-	print_off_int_undef(buff, 12, &mp->san_path_err_recovery_time);
-	condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias, buff, origin);
-	return 0;
-
-}
-
 int select_path_io_err_sample_time(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 1b2b5714..16a890eb 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -25,9 +25,6 @@ int select_delay_watch_checks (struct config *conf, struct multipath * mp);
 int select_delay_wait_checks (struct config *conf, struct multipath * mp);
 int select_skip_kpartx (struct config *conf, struct multipath * mp);
 int select_max_sectors_kb (struct config *conf, struct multipath * mp);
-int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
-int select_san_path_err_threshold(struct config *conf, struct multipath *mp);
-int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp);
 int select_path_io_err_sample_time(struct config *conf, struct multipath *mp);
 int select_path_io_err_rate_threshold(struct config *conf, struct multipath *mp);
 int select_path_io_err_recovery_time(struct config *conf, struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 1ab8cb9b..9da33d5a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -231,10 +231,6 @@ struct path {
 	int initialized;
 	int retriggers;
 	int wwid_changed;
-	unsigned int path_failures;
-	time_t dis_reinstate_time;
-	int disable_reinstate;
-	int san_path_err_forget_rate;
 	time_t io_err_dis_reinstate_time;
 	int io_err_disable_reinstate;
 	int io_err_pathfail_cnt;
@@ -270,9 +266,6 @@ struct multipath {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
-	int san_path_err_threshold;
-	int san_path_err_forget_rate;
-	int san_path_err_recovery_time;
 	int path_io_err_sample_time;
 	int path_io_err_rate_threshold;
 	int path_io_err_recovery_time;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f49ede66..41f698c0 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -810,45 +810,6 @@ The default is: \fB/etc/multipath/conf.d/\fR
 .
 .
 .TP
-.B san_path_err_threshold
-If set to a value greater than 0, multipathd will watch paths and check how many
-times a path has been failed due to errors.If the number of failures on a particular
-path is greater then the san_path_err_threshold then the path will not  reinstante
-till san_path_err_recovery_time.These path failures should occur within a
-san_path_err_forget_rate checks, if not we will consider the path is good enough
-to reinstantate.
-.RS
-.TP
-The default is: \fBno\fR
-.RE
-.
-.
-.TP
-.B san_path_err_forget_rate
-If set to a value greater than 0, multipathd will check whether the path failures
-has exceeded  the san_path_err_threshold within this many checks i.e
-san_path_err_forget_rate . If so we will not reinstante the path till
-san_path_err_recovery_time.
-.RS
-.TP
-The default is: \fBno\fR
-.RE
-.
-.
-.TP
-.B san_path_err_recovery_time
-If set to a value greater than 0, multipathd will make sure that when path failures
-has exceeded the san_path_err_threshold within san_path_err_forget_rate then the path
-will be placed in failed state for san_path_err_recovery_time duration.Once san_path_err_recovery_time
-has timeout  we will reinstante the failed path .
-san_path_err_recovery_time value should be in secs.
-.RS
-.TP
-The default is: \fBno\fR
-.RE
-.
-.
-.TP
 .B path_io_err_sample_time
 One of the three parameters of supporting path check based on accounting IO
 error such as intermittent error. If it is set to a value no less than 120,
@@ -1160,12 +1121,6 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .TP
 .B deferred_remove
 .TP
-.B san_path_err_threshold
-.TP
-.B san_path_err_forget_rate
-.TP
-.B san_path_err_recovery_time
-.TP
 .B path_io_err_sample_time
 .TP
 .B path_io_err_rate_threshold
@@ -1293,12 +1248,6 @@ section:
 .TP
 .B deferred_remove
 .TP
-.B san_path_err_threshold
-.TP
-.B san_path_err_forget_rate
-.TP
-.B san_path_err_recovery_time
-.TP
 .B path_io_err_sample_time
 .TP
 .B path_io_err_rate_threshold
@@ -1371,12 +1320,6 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B deferred_remove
 .TP
-.B san_path_err_threshold
-.TP
-.B san_path_err_forget_rate
-.TP
-.B san_path_err_recovery_time
-.TP
 .B path_io_err_sample_time
 .TP
 .B path_io_err_rate_threshold
diff --git a/multipathd/main.c b/multipathd/main.c
index 38158006..001a03e2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1525,84 +1525,6 @@ void repair_path(struct path * pp)
 	LOG_MSG(1, checker_message(&pp->checker));
 }
 
-static int check_path_reinstate_state(struct path * pp) {
-	struct timespec curr_time;
-	if (!((pp->mpp->san_path_err_threshold > 0) &&
-				(pp->mpp->san_path_err_forget_rate > 0) &&
-				(pp->mpp->san_path_err_recovery_time >0))) {
-		return 0;
-	}
-
-	if (pp->disable_reinstate) {
-		/* If we don't know how much time has passed, automatically
-		 * reinstate the path, just to be safe. Also, if there are
-		 * no other usable paths, reinstate the path
-		 */
-		if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0 ||
-				pp->mpp->nr_active == 0) {
-			condlog(2, "%s : reinstating path early", pp->dev);
-			goto reinstate_path;
-		}
-		if ((curr_time.tv_sec - pp->dis_reinstate_time ) > pp->mpp->san_path_err_recovery_time) {
-			condlog(2,"%s : reinstate the path after err recovery time", pp->dev);
-			goto reinstate_path;
-		}
-		return 1;
-	}
-	/* forget errors on a working path */
-	if ((pp->state == PATH_UP || pp->state == PATH_GHOST) &&
-			pp->path_failures > 0) {
-		if (pp->san_path_err_forget_rate > 0){
-			pp->san_path_err_forget_rate--;
-		} else {
-			/* for every san_path_err_forget_rate number of
-			 * successful path checks decrement path_failures by 1
-			 */
-			pp->path_failures--;
-			pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
-		}
-		return 0;
-	}
-
-	/* If the path isn't recovering from a failed state, do nothing */
-	if (pp->state != PATH_DOWN && pp->state != PATH_SHAKY &&
-			pp->state != PATH_TIMEOUT)
-		return 0;
-
-	if (pp->path_failures == 0)
-		pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
-
-	pp->path_failures++;
-
-	/* if we don't know the currently time, we don't know how long to
-	 * delay the path, so there's no point in checking if we should
-	 */
-
-	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
-		return 0;
-	/* when path failures has exceeded the san_path_err_threshold
-	 * place the path in delayed state till san_path_err_recovery_time
-	 * so that the cutomer can rectify the issue within this time. After
-	 * the completion of san_path_err_recovery_time it should
-	 * automatically reinstate the path
-	 */
-	if (pp->path_failures > pp->mpp->san_path_err_threshold) {
-		condlog(2, "%s : hit error threshold. Delaying path reinstatement", pp->dev);
-		pp->dis_reinstate_time = curr_time.tv_sec;
-		pp->disable_reinstate = 1;
-
-		return 1;
-	} else {
-		return 0;
-	}
-
-reinstate_path:
-	pp->path_failures = 0;
-	pp->disable_reinstate = 0;
-	pp->san_path_err_forget_rate = 0;
-	return 0;
-}
-
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1716,12 +1638,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (!pp->mpp)
 		return 0;
 
-	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
-			check_path_reinstate_state(pp)) {
-		pp->state = PATH_DELAYED;
-		return 1;
-	}
-
 	if (pp->io_err_disable_reinstate && hit_io_err_recheck_time(pp)) {
 		pp->state = PATH_DELAYED;
 		/*
-- 
2.11.1
