From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 14/16] libmutipath: deprecate delay_*_checks
Date: Fri,  2 Aug 2019 11:33:40 -0500
Message-ID: <1564763622-31752-15-git-send-email-bmarzins@redhat.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Muneendra Kumar <mkumar@redhat.com>
List-Id: dm-devel.ids

The delay_checks shaky paths detection method works the same way as the
san_path_err method, but not as well, with less configurability, and
with the code spread all over check_path(). The only real difference is
that marks the path as marginal for a certain number of path checks
instead of for a specific time. This patch deprecates the delay_checks
method and maps it to the the san_path_err method.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   | 17 +----------
 libmultipath/propsel.c     | 62 +++++++++++++++++++++++++++++---------
 libmultipath/propsel.h     |  2 --
 libmultipath/structs.h     | 10 ------
 multipath/multipath.conf.5 | 41 ++++++++++++++-----------
 multipathd/main.c          | 34 +++------------------
 6 files changed, 76 insertions(+), 90 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3238d485..9443389f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -342,8 +342,6 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	select_dev_loss(conf, mpp);
 	select_reservation_key(conf, mpp);
 	select_deferred_remove(conf, mpp);
-	select_delay_watch_checks(conf, mpp);
-	select_delay_wait_checks(conf, mpp);
 	select_marginal_path_err_sample_time(conf, mpp);
 	select_marginal_path_err_rate_threshold(conf, mpp);
 	select_marginal_path_err_recheck_gap_time(conf, mpp);
@@ -360,21 +358,8 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	marginal_pathgroups = conf->marginal_pathgroups;
 	pthread_cleanup_pop(1);
 
-	if (marginal_path_check_enabled(mpp)) {
-		if (delay_check_enabled(mpp)) {
-			condlog(1, "%s: WARNING: both marginal_path and delay_checks error detection selected",
-				mpp->alias);
-			condlog(0, "%s: unexpected behavior may occur!",
-				mpp->alias);
-		}
+	if (marginal_path_check_enabled(mpp))
 		start_io_err_stat_thread(vecs);
-	}
-	if (san_path_check_enabled(mpp) && delay_check_enabled(mpp)) {
-		condlog(1, "%s: WARNING: both san_path_err and delay_checks error detection selected",
-			mpp->alias);
-		condlog(0, "%s: unexpected behavior may occur!",
-			mpp->alias);
-	}
 
 	n_paths = VECTOR_SIZE(mpp->paths);
         /*
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 6af2513d..894a52e3 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -85,6 +85,10 @@ static const char autodetect_origin[] =
 	"(setting: storage device autodetected)";
 static const char marginal_path_origin[] =
 	"(setting: implied by marginal_path check)";
+static const char delay_watch_origin[] =
+	"(setting: implied by delay_watch_checks)";
+static const char delay_wait_origin[] =
+	"(setting: implied by delay_wait_checks)";
 
 #define do_default(dest, value)						\
 do {									\
@@ -877,37 +881,59 @@ out:
 	return 0;
 }
 
-int select_delay_watch_checks(struct config *conf, struct multipath *mp)
+static int
+use_delay_watch_checks(struct config *conf, struct multipath *mp)
 {
+	int value = NU_UNDEF;
 	const char *origin;
 	char buff[12];
 
-	mp_set_mpe(delay_watch_checks);
-	mp_set_ovr(delay_watch_checks);
-	mp_set_hwe(delay_watch_checks);
-	mp_set_conf(delay_watch_checks);
-	mp_set_default(delay_watch_checks, DEFAULT_DELAY_CHECKS);
+	do_set(delay_watch_checks, mp->mpe, value, multipaths_origin);
+	do_set(delay_watch_checks, conf->overrides, value, overrides_origin);
+	do_set_from_hwe(delay_watch_checks, mp, value, hwe_origin);
+	do_set(delay_watch_checks, conf, value, conf_origin);
 out:
-	if (print_off_int_undef(buff, 12, mp->delay_watch_checks) != 0)
+	if (value > 0) {
+		mp->san_path_err_forget_rate = value;
+		print_off_int_undef(buff, 12, value);
 		condlog(3, "%s: delay_watch_checks = %s %s",
 			mp->alias, buff, origin);
+		if (mp->san_path_err_threshold == NU_NO) {
+			mp->san_path_err_threshold = 1;
+			condlog(3, "%s: san_path_err_threshold = 1 %s",
+				mp->alias, delay_watch_origin);
+		}
+		return 1;
+	}
 	return 0;
 }
 
-int select_delay_wait_checks(struct config *conf, struct multipath *mp)
+static int
+use_delay_wait_checks(struct config *conf, struct multipath *mp)
 {
+	int value = NU_UNDEF;
 	const char *origin;
 	char buff[12];
 
-	mp_set_mpe(delay_wait_checks);
-	mp_set_ovr(delay_wait_checks);
-	mp_set_hwe(delay_wait_checks);
-	mp_set_conf(delay_wait_checks);
-	mp_set_default(delay_wait_checks, DEFAULT_DELAY_CHECKS);
+	do_set(delay_wait_checks, mp->mpe, value, multipaths_origin);
+	do_set(delay_wait_checks, conf->overrides, value, overrides_origin);
+	do_set_from_hwe(delay_wait_checks, mp, value, hwe_origin);
+	do_set(delay_wait_checks, conf, value, conf_origin);
 out:
-	if (print_off_int_undef(buff, 12, mp->delay_wait_checks) != 0)
+	if (value > 0) {
+		/* this isn't exactly the same length of time as
+		 * delay_wait_checks, but it's a close enough approximation */
+		mp->san_path_err_recovery_time = value * conf->max_checkint;
+		print_off_int_undef(buff, 12, value);
 		condlog(3, "%s: delay_wait_checks = %s %s",
 			mp->alias, buff, origin);
+		if (mp->san_path_err_threshold == NU_NO) {
+			mp->san_path_err_threshold = 1;
+			condlog(3, "%s: san_path_err_threshold = 1 %s",
+				mp->alias, delay_wait_origin);
+		}
+		return 1;
+	}
 	return 0;
 
 }
@@ -960,6 +986,10 @@ int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 	mp_set_ovr(san_path_err_forget_rate);
 	mp_set_hwe(san_path_err_forget_rate);
 	mp_set_conf(san_path_err_forget_rate);
+	if (use_delay_watch_checks(conf, mp)) {
+		origin = delay_watch_origin;
+		goto out;
+	}
 	mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
 out:
 	if (print_off_int_undef(buff, 12, mp->san_path_err_forget_rate) != 0)
@@ -984,6 +1014,10 @@ int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 	mp_set_ovr(san_path_err_recovery_time);
 	mp_set_hwe(san_path_err_recovery_time);
 	mp_set_conf(san_path_err_recovery_time);
+	if (use_delay_wait_checks(conf, mp)) {
+		origin = delay_wait_origin;
+		goto out;
+	}
 	mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
 out:
 	if (print_off_int_undef(buff, 12, mp->san_path_err_recovery_time) != 0)
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index b352c16a..b99652f0 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -22,8 +22,6 @@ int select_retain_hwhandler (struct config *conf, struct multipath * mp);
 int select_detect_prio(struct config *conf, struct path * pp);
 int select_detect_checker(struct config *conf, struct path * pp);
 int select_deferred_remove(struct config *conf, struct multipath *mp);
-int select_delay_watch_checks (struct config *conf, struct multipath * mp);
-int select_delay_wait_checks (struct config *conf, struct multipath * mp);
 int select_skip_kpartx (struct config *conf, struct multipath * mp);
 int select_max_sectors_kb (struct config *conf, struct multipath * mp);
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a8b9d325..a3adf906 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -268,8 +268,6 @@ struct path {
 	int pgindex;
 	int detect_prio;
 	int detect_checker;
-	int watch_checks;
-	int wait_checks;
 	int tpgs;
 	char * uid_attribute;
 	char * getuid;
@@ -321,8 +319,6 @@ struct multipath {
 	int fast_io_fail;
 	int retain_hwhandler;
 	int deferred_remove;
-	int delay_watch_checks;
-	int delay_wait_checks;
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
@@ -393,12 +389,6 @@ static inline int san_path_check_enabled(const struct multipath *mpp)
 		mpp->san_path_err_recovery_time > 0;
 }
 
-static inline int delay_check_enabled(const struct multipath *mpp)
-{
-	return mpp->delay_watch_checks != NU_NO ||
-		mpp->delay_wait_checks != NU_NO;
-}
-
 struct pathgroup {
 	long id;
 	int status;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f7d21b4c..7fccf8f3 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1013,10 +1013,13 @@ The default is: \fBno\fR
 .
 .TP
 .B delay_watch_checks
-If set to a value greater than 0, multipathd will watch paths that have
-recently become valid for this many checks. If they fail again while they are
-being watched, when they next become valid, they will not be used until they
-have stayed up for \fIdelay_wait_checks\fR checks. See "Shaky paths detection" below.
+This option is \fBdeprecated\fR, and mapped to \fIsan_path_err_forget_rate\fR.
+If this is set to a value greater than 0 and \fIsan_path_err_forget_rate\fR
+isn't set, \fIsan_path_err_forget_rate\fR will be set to the value of
+\fIdelay_watch_checks\fR. Also, if \fIsan_path_err_threshold\fR isn't set, it
+will be set to 1. See the \fIsan_path_err_forget_rate\fR and
+\fIsan_path_err_threshold\fR options, and "Shaky paths detection" below for
+more information.
 .RS
 .TP
 The default is: \fBno\fR
@@ -1025,10 +1028,14 @@ The default is: \fBno\fR
 .
 .TP
 .B delay_wait_checks
-If set to a value greater than 0, when a device that has recently come back
-online fails again within \fIdelay_watch_checks\fR checks, the next time it
-comes back online, it will marked and delayed, and not used until it has passed
-\fIdelay_wait_checks\fR checks. See "Shaky paths detection" below.
+This option is \fBdeprecated\fR, and mapped to \fIsan_path_err_recovery_time\fR.
+If this is set to a value greater than 0 and \fIsan_path_err_recovery_time\fR
+isn't set, \fIsan_path_err_recovery_time\fR will be set to the value of
+\fIdelay_wait_checks\fR times \fImax_polling_interval\fR. This will give
+approximately the same wait time as delay_wait_checks previously did.
+Also, if \fIsan_path_err_threshold\fR isn't set, it will be set to 1.
+See the \fIsan_path_err_recovery_time\fR and \fIsan_path_err_threshold\fR
+options, and "Shaky paths detection" below for more information.
 .RS
 .TP
 The default is: \fBno\fR
@@ -1689,13 +1696,10 @@ if the healthy state appears to be stable. The logic of determining
 differs between the three methods.
 .TP 8
 .B \(dqdelay_checks\(dq failure tracking
-If a path fails again within a
-\fIdelay_watch_checks\fR interval after a failure, don't
-reinstate it until it passes a \fIdelay_wait_checks\fR interval
-in always good status.
-The intervals are measured in \(dqticks\(dq, i.e. the
-time between path checks by multipathd, which is variable and controlled by the
-\fIpolling_interval\fR and \fImax_polling_interval\fR parameters.
+This method is \fBdeprecated\fR and mapped to the \(dqsan_path_err\(dq method.
+See the \fIdelay_watch_checks\fR and \fIdelay_wait_checks\fR options above
+for more information.
+
 .TP
 .B \(dqmarginal_path\(dq failure tracking
 If a second failure event (good->bad transition) occurs within
@@ -1712,12 +1716,13 @@ in seconds.
 .B \(dqsan_path_err\(dq failure tracking
 multipathd counts path failures for each path. Once the number of failures
 exceeds the value given by \fIsan_path_err_threshold\fR, the path is not
-reinstated for \fIsan_path_err_recovery_time\fR ticks. While counting
+reinstated for \fIsan_path_err_recovery_time\fR seconds. While counting
 failures, multipathd \(dqforgets\(dq one past failure every
 \(dqsan_path_err_forget_rate\(dq ticks; thus if errors don't occur more
 often then once in the forget rate interval, the failure count doesn't
-increase and the threshold is never reached. As for the \fIdelay_xy\fR method,
-intervals are measured in \(dqticks\(dq.
+increase and the threshold is never reached. Ticks are the time between
+path checks by multipathd, which is variable and controlled by the
+\fIpolling_interval\fR and \fImax_polling_interval\fR parameters.
 .
 .RS 8
 .LP
diff --git a/multipathd/main.c b/multipathd/main.c
index 7db15736..dca2214c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2122,16 +2122,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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
@@ -2162,19 +2152,10 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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
-			} else {
+			else
 				fail_path(pp, 0);
-				if (pp->wait_checks > 0)
-					pp->wait_checks =
-						pp->mpp->delay_wait_checks;
-			}
 
 			/*
 			 * cancel scheduled failback
@@ -2200,15 +2181,10 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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
@@ -2253,8 +2229,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 				condlog(4, "%s: delay next check %is",
 					pp->dev_t, pp->checkint);
 			}
-			if (pp->watch_checks > 0)
-				pp->watch_checks--;
 			pp->tick = pp->checkint;
 		}
 	}
-- 
2.17.2
