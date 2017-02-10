From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: Remove trailing and leading
	whitespaces
Date: Fri, 10 Feb 2017 14:43:59 +0100
Message-ID: <20170210134359.6969-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/kpartx_id           |  6 +++---
 libmultipath/dict.c        | 18 ++++++++--------
 libmultipath/propsel.c     | 54 +++++++++++++++++++++++-----------------------
 multipath/multipath.conf.5 |  4 ++--
 multipathd/main.c          |  2 +-
 5 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index df0e6b9..b7f802d 100755
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -74,16 +74,16 @@ fi
 if [ -n "$dmdeps" ] ; then
     case "$dmdeps" in
 	*\(94,*)
-            echo "DM_TYPE=ccw"
+	    echo "DM_TYPE=ccw"
 	    ;;
 	*\(104,* | *\(105,* | *\(106,* | *\(107,* | *\(108,* | *\(109,* | *\(110,* | *\(112,*)
 	    echo "DM_TYPE=cciss"
 	    ;;
 	*\(9*)
-            echo "DM_TYPE=raid"
+	    echo "DM_TYPE=raid"
 	    ;;
 	*)
-            echo "DM_TYPE=scsi"
+	    echo "DM_TYPE=scsi"
 	    echo "DM_WWN=0x${dmname#?}"
 	    ;;
     esac
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ae94c88..3521c78 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1426,9 +1426,9 @@ init_keywords(vector keywords)
 	install_keyword("config_dir", &def_config_dir_handler, &snprint_def_config_dir);
 	install_keyword("delay_watch_checks", &def_delay_watch_checks_handler, &snprint_def_delay_watch_checks);
 	install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &snprint_def_delay_wait_checks);
-        install_keyword("san_path_err_threshold", &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
-        install_keyword("san_path_err_forget_rate", &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_forget_rate);
-        install_keyword("san_path_err_recovery_time", &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_recovery_time);
+	install_keyword("san_path_err_threshold", &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
+	install_keyword("san_path_err_forget_rate", &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_forget_rate);
+	install_keyword("san_path_err_recovery_time", &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_recovery_time);
 
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
@@ -1512,9 +1512,9 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
-        install_keyword("san_path_err_threshold", &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
-        install_keyword("san_path_err_forget_rate", &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_forget_rate);
-        install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
+	install_keyword("san_path_err_threshold", &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
+	install_keyword("san_path_err_forget_rate", &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_forget_rate);
+	install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_sublevel_end();
@@ -1544,9 +1544,9 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
-        install_keyword("san_path_err_threshold", &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
-        install_keyword("san_path_err_forget_rate", &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_forget_rate);
-        install_keyword("san_path_err_recovery_time", &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_recovery_time);
+	install_keyword("san_path_err_threshold", &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
+	install_keyword("san_path_err_forget_rate", &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_forget_rate);
+	install_keyword("san_path_err_recovery_time", &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_recovery_time);
 
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index e4afef7..1b27476 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -645,47 +645,47 @@ out:
 }
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 {
-        char *origin, buff[12];
+	char *origin, buff[12];
 
-        mp_set_mpe(san_path_err_threshold);
-        mp_set_ovr(san_path_err_threshold);
-        mp_set_hwe(san_path_err_threshold);
-        mp_set_conf(san_path_err_threshold);
-        mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
+	mp_set_mpe(san_path_err_threshold);
+	mp_set_ovr(san_path_err_threshold);
+	mp_set_hwe(san_path_err_threshold);
+	mp_set_conf(san_path_err_threshold);
+	mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
 out:
-        print_off_int_undef(buff, 12, &mp->san_path_err_threshold);
-        condlog(3, "%s: san_path_err_threshold = %s %s", mp->alias, buff, origin);
-        return 0;
+	print_off_int_undef(buff, 12, &mp->san_path_err_threshold);
+	condlog(3, "%s: san_path_err_threshold = %s %s", mp->alias, buff, origin);
+	return 0;
 }
 
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 {
-        char *origin, buff[12];
+	char *origin, buff[12];
 
-        mp_set_mpe(san_path_err_forget_rate);
-        mp_set_ovr(san_path_err_forget_rate);
-        mp_set_hwe(san_path_err_forget_rate);
-        mp_set_conf(san_path_err_forget_rate);
-        mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
+	mp_set_mpe(san_path_err_forget_rate);
+	mp_set_ovr(san_path_err_forget_rate);
+	mp_set_hwe(san_path_err_forget_rate);
+	mp_set_conf(san_path_err_forget_rate);
+	mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
 out:
-        print_off_int_undef(buff, 12, &mp->san_path_err_forget_rate);
-        condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias, buff, origin);
-        return 0;
+	print_off_int_undef(buff, 12, &mp->san_path_err_forget_rate);
+	condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias, buff, origin);
+	return 0;
 
 }
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 {
-        char *origin, buff[12];
+	char *origin, buff[12];
 
-        mp_set_mpe(san_path_err_recovery_time);
-        mp_set_ovr(san_path_err_recovery_time);
-        mp_set_hwe(san_path_err_recovery_time);
-        mp_set_conf(san_path_err_recovery_time);
-        mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
+	mp_set_mpe(san_path_err_recovery_time);
+	mp_set_ovr(san_path_err_recovery_time);
+	mp_set_hwe(san_path_err_recovery_time);
+	mp_set_conf(san_path_err_recovery_time);
+	mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
 out:
-        print_off_int_undef(buff, 12, &mp->san_path_err_recovery_time);
-        condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias, buff, origin);
-        return 0;
+	print_off_int_undef(buff, 12, &mp->san_path_err_recovery_time);
+	condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias, buff, origin);
+	return 0;
 
 }
 int select_skip_kpartx (struct config *conf, struct multipath * mp)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 3c564ad..7de8bc7 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -755,7 +755,7 @@ The default is: \fB/etc/multipath/conf.d/\fR
 If set to a value greater than 0, multipathd will watch paths and check how many
 times a path has been failed due to errors.If the number of failures on a particular
 path is greater then the san_path_err_threshold then the path will not  reinstante
-till san_path_err_recovery_time.These path failures should occur within a 
+till san_path_err_recovery_time.These path failures should occur within a
 san_path_err_forget_rate checks, if not we will consider the path is good enough
 to reinstantate.
 .RS
@@ -767,7 +767,7 @@ The default is: \fBno\fR
 .TP
 .B san_path_err_forget_rate
 If set to a value greater than 0, multipathd will check whether the path failures
-has exceeded  the san_path_err_threshold within this many checks i.e 
+has exceeded  the san_path_err_threshold within this many checks i.e
 san_path_err_forget_rate . If so we will not reinstante the path till
 san_path_err_recovery_time.
 .RS
diff --git a/multipathd/main.c b/multipathd/main.c
index 1b44e4d..0f32b2c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1504,7 +1504,7 @@ static int check_path_reinstate_state(struct path * pp) {
 				(pp->mpp->san_path_err_recovery_time >0))) {
 		return 0;
 	}
-	
+
 	if (pp->disable_reinstate) {
 		/* If we don't know how much time has passed, automatically
 		 * reinstate the path, just to be safe. Also, if there are
-- 
2.11.1
