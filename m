From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/19] multipathd: marginal_path overrides
	san_path_err
Date: Wed, 19 Dec 2018 00:19:17 +0100
Message-ID: <20181218231931.10762-6-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
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
Cc: Guan Junxiong <guanjunxiong@huawei.com>, dm-devel@redhat.com, M Muneendra Kumar <mmandala@brocade.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

disable san_path_err_XY if marginal path checking is
enabled. Also warn about san_path_err_XY being deprecated,
and warn if any of the two is used in combination with
delay_XY_checks.

Add some minor fixes to the san_path_err code, and a comment
that explains a part of the code that was not immediately obvious
to me.

Cc: Guan Junxiong <guanjunxiong@huawei.com>
Cc: M Muneendra Kumar <mmandala@brocade.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 24 ++++++++++++++------
 libmultipath/propsel.c   | 49 ++++++++++++++++++++++++++++++++--------
 libmultipath/structs.h   | 21 +++++++++++++++++
 multipathd/main.c        | 10 ++++++++
 4 files changed, 88 insertions(+), 16 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 60a98873..5af4a189 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -309,13 +309,13 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	select_deferred_remove(conf, mpp);
 	select_delay_watch_checks(conf, mpp);
 	select_delay_wait_checks(conf, mpp);
-	select_san_path_err_threshold(conf, mpp);
-	select_san_path_err_forget_rate(conf, mpp);
-	select_san_path_err_recovery_time(conf, mpp);
 	select_marginal_path_err_sample_time(conf, mpp);
 	select_marginal_path_err_rate_threshold(conf, mpp);
 	select_marginal_path_err_recheck_gap_time(conf, mpp);
 	select_marginal_path_double_failed_time(conf, mpp);
+	select_san_path_err_threshold(conf, mpp);
+	select_san_path_err_forget_rate(conf, mpp);
+	select_san_path_err_recovery_time(conf, mpp);
 	select_skip_kpartx(conf, mpp);
 	select_max_sectors_kb(conf, mpp);
 	select_ghost_delay(conf, mpp);
@@ -324,11 +324,21 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
 	pthread_cleanup_pop(1);
 
-	if (mpp->marginal_path_double_failed_time > 0 &&
-	    mpp->marginal_path_err_sample_time > 0 &&
-	    mpp->marginal_path_err_recheck_gap_time > 0 &&
-	    mpp->marginal_path_err_rate_threshold >= 0)
+	if (marginal_path_check_enabled(mpp)) {
+		if (delay_check_enabled(mpp)) {
+			condlog(1, "%s: WARNING: both marginal_path and delay_checks error detection selected",
+				mpp->alias);
+			condlog(0, "%s: unexpected behavior may occur!",
+				mpp->alias);
+		}
 		start_io_err_stat_thread(vecs);
+	}
+	if (san_path_check_enabled(mpp) && delay_check_enabled(mpp)) {
+		condlog(1, "%s: WARNING: both san_path_err and delay_checks error detection selected",
+			mpp->alias);
+		condlog(0, "%s: unexpected behavior may occur!",
+			mpp->alias);
+	}
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a4d114c0..f5d87786 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -74,6 +74,8 @@ static const char cmdline_origin[] =
 	"(setting: multipath command line [-p] flag)";
 static const char autodetect_origin[] =
 	"(setting: storage device autodetected)";
+static const char marginal_path_origin[] =
+	"(setting: implied by marginal_path check)";
 
 #define do_default(dest, value)						\
 do {									\
@@ -879,20 +881,37 @@ out:
 
 }
 
+static int san_path_deprecated_warned;
+#define warn_san_path_deprecated(v, x)					\
+	do {								\
+		if (v->x > 0 && !san_path_deprecated_warned) {		\
+		san_path_deprecated_warned = 1;				\
+		condlog(1, "WARNING: option %s is deprecated, "		\
+			"please use marginal_path options instead",	\
+			#x);						\
+		}							\
+	} while(0)
+
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
 	char buff[12];
 
+	if (marginal_path_check_enabled(mp)) {
+		mp->san_path_err_threshold = NU_NO;
+		origin = marginal_path_origin;
+		goto out;
+	}
 	mp_set_mpe(san_path_err_threshold);
 	mp_set_ovr(san_path_err_threshold);
 	mp_set_hwe(san_path_err_threshold);
 	mp_set_conf(san_path_err_threshold);
 	mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->san_path_err_threshold);
-	condlog(3, "%s: san_path_err_threshold = %s %s", mp->alias, buff,
-		origin);
+	if (print_off_int_undef(buff, 12, mp->san_path_err_threshold) != 0)
+		condlog(3, "%s: san_path_err_threshold = %s %s",
+			mp->alias, buff, origin);
+	warn_san_path_deprecated(mp, san_path_err_threshold);
 	return 0;
 }
 
@@ -901,15 +920,21 @@ int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 	const char *origin;
 	char buff[12];
 
+	if (marginal_path_check_enabled(mp)) {
+		mp->san_path_err_forget_rate = NU_NO;
+		origin = marginal_path_origin;
+		goto out;
+	}
 	mp_set_mpe(san_path_err_forget_rate);
 	mp_set_ovr(san_path_err_forget_rate);
 	mp_set_hwe(san_path_err_forget_rate);
 	mp_set_conf(san_path_err_forget_rate);
 	mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->san_path_err_forget_rate);
-	condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias,
-		buff, origin);
+	if (print_off_int_undef(buff, 12, mp->san_path_err_forget_rate) != 0)
+		condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias,
+			buff, origin);
+	warn_san_path_deprecated(mp, san_path_err_forget_rate);
 	return 0;
 
 }
@@ -919,15 +944,21 @@ int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 	const char *origin;
 	char buff[12];
 
+	if (marginal_path_check_enabled(mp)) {
+		mp->san_path_err_recovery_time = NU_NO;
+		origin = marginal_path_origin;
+		goto out;
+	}
 	mp_set_mpe(san_path_err_recovery_time);
 	mp_set_ovr(san_path_err_recovery_time);
 	mp_set_hwe(san_path_err_recovery_time);
 	mp_set_conf(san_path_err_recovery_time);
 	mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
 out:
-	print_off_int_undef(buff, 12, mp->san_path_err_recovery_time);
-	condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
-		buff, origin);
+	if (print_off_int_undef(buff, 12, mp->san_path_err_recovery_time) != 0)
+		condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
+			buff, origin);
+	warn_san_path_deprecated(mp, san_path_err_recovery_time);
 	return 0;
 
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 96df8c8a..375c7284 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -377,6 +377,27 @@ struct multipath {
 	struct gen_multipath generic_mp;
 };
 
+static inline int marginal_path_check_enabled(const struct multipath *mpp)
+{
+	return mpp->marginal_path_double_failed_time > 0 &&
+		mpp->marginal_path_err_sample_time > 0 &&
+		mpp->marginal_path_err_recheck_gap_time > 0 &&
+		mpp->marginal_path_err_rate_threshold >= 0;
+}
+
+static inline int san_path_check_enabled(const struct multipath *mpp)
+{
+	return mpp->san_path_err_threshold > 0 &&
+		mpp->san_path_err_forget_rate > 0 &&
+		mpp->san_path_err_recovery_time > 0;
+}
+
+static inline int delay_check_enabled(const struct multipath *mpp)
+{
+	return mpp->delay_watch_checks != NU_NO ||
+		mpp->delay_wait_checks != NU_NO;
+}
+
 struct pathgroup {
 	long id;
 	int status;
diff --git a/multipathd/main.c b/multipathd/main.c
index 57bb7143..aac32ac8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1835,6 +1835,16 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 
 static int check_path_reinstate_state(struct path * pp) {
 	struct timespec curr_time;
+
+	/*
+	 * This function is only called when the path state changes
+	 * from "bad" to "good". pp->state reflects the *previous* state.
+	 * If this was "bad", we know that a failure must have occured
+	 * beforehand, and count that.
+	 * Note that we count path state _changes_ this way. If a path
+	 * remains in "bad" state, failure count is not increased.
+	 */
+
 	if (!((pp->mpp->san_path_err_threshold > 0) &&
 				(pp->mpp->san_path_err_forget_rate > 0) &&
 				(pp->mpp->san_path_err_recovery_time >0))) {
-- 
2.19.2
