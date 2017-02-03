From: M Muneendra Kumar <mmandala@brocade.com>
Subject: [PATCH 1/1] multipathd: deterministic io throughput in
	multipath
Date: Fri,  3 Feb 2017 20:16:57 +0530
Message-ID: <1486133217-19098-2-git-send-email-mmandala@brocade.com>
References: <1486133217-19098-1-git-send-email-mmandala@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1486133217-19098-1-git-send-email-mmandala@brocade.com>
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
List-Id: dm-devel.ids

This patch adds three configuration parameters, "san_path_err_threshold",
"san_path_err_recovery_time" and "san_path_err_forget_rate".
multipathd will watch paths and check how many times a path has been failed due
to errors.If the number of failures on a particular path is greater then the
san_path_err_threshold then the path will not  reinstante till
san_path_err_recovery_time.These path failures should occur within a
san_path_err_forget_rate checks, if not we will consider the path is good enough
to reinstantate.If it is the only available path, it will immediately be
reintegrated.

This helps us to place the path in failed state if we hit lot of errors on a particular path
due to network /target issues and allow the admin to rectify the errors on a path.

Signed-off-by: M Muneendra Kumar <mmandala@brocade.com>
---
 libmultipath/config.c      |  6 ++++
 libmultipath/config.h      |  9 +++++
 libmultipath/configure.c   |  3 ++
 libmultipath/defaults.h    |  3 +-
 libmultipath/dict.c        | 86 ++++++++++++++++++++++++++++++++--------------
 libmultipath/dict.h        |  3 +-
 libmultipath/propsel.c     | 48 ++++++++++++++++++++++++--
 libmultipath/propsel.h     |  3 ++
 libmultipath/structs.h     | 14 +++++---
 multipath/multipath.conf.5 | 57 ++++++++++++++++++++++++++++++
 multipathd/main.c          | 83 ++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 281 insertions(+), 34 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 15ddbd8..5837dc6 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -348,6 +348,9 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(delay_wait_checks);
 	merge_num(skip_kpartx);
 	merge_num(max_sectors_kb);
+	merge_num(san_path_err_threshold);
+	merge_num(san_path_err_forget_rate);
+	merge_num(san_path_err_recovery_time);
 
 	/*
 	 * Make sure features is consistent with
@@ -621,6 +624,9 @@ load_config (char * file)
 	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
 	conf->remove_retries = 0;
 	conf->max_sectors_kb = DEFAULT_MAX_SECTORS_KB;
+	conf->san_path_err_threshold = DEFAULT_ERR_CHECKS;
+	conf->san_path_err_forget_rate = DEFAULT_ERR_CHECKS;
+	conf->san_path_err_recovery_time = DEFAULT_ERR_CHECKS;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 9670020..9e47894 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -65,6 +65,9 @@ struct hwentry {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int san_path_err_threshold;
+	int san_path_err_forget_rate;
+	int san_path_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	char * bl_product;
@@ -93,6 +96,9 @@ struct mpentry {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int san_path_err_threshold;
+	int san_path_err_forget_rate;
+	int san_path_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	uid_t uid;
@@ -138,6 +144,9 @@ struct config {
 	int processed_main_config;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int san_path_err_threshold;
+	int san_path_err_forget_rate;
+	int san_path_err_recovery_time;
 	int uxsock_timeout;
 	int strict_timing;
 	int retrigger_tries;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a0fcad9..5ad3007 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -294,6 +294,9 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_deferred_remove(conf, mpp);
 	select_delay_watch_checks(conf, mpp);
 	select_delay_wait_checks(conf, mpp);
+	select_san_path_err_threshold(conf, mpp);
+	select_san_path_err_forget_rate(conf, mpp);
+	select_san_path_err_recovery_time(conf, mpp);
 	select_skip_kpartx(conf, mpp);
 	select_max_sectors_kb(conf, mpp);
 
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index b9b0a37..3ef1579 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -23,7 +23,8 @@
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
 #define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
 #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
-#define DEFAULT_DELAY_CHECKS	DELAY_CHECKS_OFF
+#define DEFAULT_DELAY_CHECKS	NU_NO
+#define DEFAULT_ERR_CHECKS	NU_NO
 #define DEFAULT_UEVENT_STACKSIZE 256
 #define DEFAULT_RETRIGGER_DELAY	10
 #define DEFAULT_RETRIGGER_TRIES	3
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index dc21846..ae94c88 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1023,7 +1023,7 @@ declare_mp_handler(reservation_key, set_reservation_key)
 declare_mp_snprint(reservation_key, print_reservation_key)
 
 static int
-set_delay_checks(vector strvec, void *ptr)
+set_off_int_undef(vector strvec, void *ptr)
 {
 	int *int_ptr = (int *)ptr;
 	char * buff;
@@ -1033,47 +1033,69 @@ set_delay_checks(vector strvec, void *ptr)
 		return 1;
 
 	if (!strcmp(buff, "no") || !strcmp(buff, "0"))
-		*int_ptr = DELAY_CHECKS_OFF;
+		*int_ptr = NU_NO;
 	else if ((*int_ptr = atoi(buff)) < 1)
-		*int_ptr = DELAY_CHECKS_UNDEF;
+		*int_ptr = NU_UNDEF;
 
 	FREE(buff);
 	return 0;
 }
 
 int
-print_delay_checks(char * buff, int len, void *ptr)
+print_off_int_undef(char * buff, int len, void *ptr)
 {
 	int *int_ptr = (int *)ptr;
 
 	switch(*int_ptr) {
-	case DELAY_CHECKS_UNDEF:
+	case NU_UNDEF:
 		return 0;
-	case DELAY_CHECKS_OFF:
-		return snprintf(buff, len, "\"off\"");
+	case NU_NO:
+		return snprintf(buff, len, "\"no\"");
 	default:
 		return snprintf(buff, len, "%i", *int_ptr);
 	}
 }
 
-declare_def_handler(delay_watch_checks, set_delay_checks)
-declare_def_snprint(delay_watch_checks, print_delay_checks)
-declare_ovr_handler(delay_watch_checks, set_delay_checks)
-declare_ovr_snprint(delay_watch_checks, print_delay_checks)
-declare_hw_handler(delay_watch_checks, set_delay_checks)
-declare_hw_snprint(delay_watch_checks, print_delay_checks)
-declare_mp_handler(delay_watch_checks, set_delay_checks)
-declare_mp_snprint(delay_watch_checks, print_delay_checks)
-
-declare_def_handler(delay_wait_checks, set_delay_checks)
-declare_def_snprint(delay_wait_checks, print_delay_checks)
-declare_ovr_handler(delay_wait_checks, set_delay_checks)
-declare_ovr_snprint(delay_wait_checks, print_delay_checks)
-declare_hw_handler(delay_wait_checks, set_delay_checks)
-declare_hw_snprint(delay_wait_checks, print_delay_checks)
-declare_mp_handler(delay_wait_checks, set_delay_checks)
-declare_mp_snprint(delay_wait_checks, print_delay_checks)
-
+declare_def_handler(delay_watch_checks, set_off_int_undef)
+declare_def_snprint(delay_watch_checks, print_off_int_undef)
+declare_ovr_handler(delay_watch_checks, set_off_int_undef)
+declare_ovr_snprint(delay_watch_checks, print_off_int_undef)
+declare_hw_handler(delay_watch_checks, set_off_int_undef)
+declare_hw_snprint(delay_watch_checks, print_off_int_undef)
+declare_mp_handler(delay_watch_checks, set_off_int_undef)
+declare_mp_snprint(delay_watch_checks, print_off_int_undef)
+declare_def_handler(delay_wait_checks, set_off_int_undef)
+declare_def_snprint(delay_wait_checks, print_off_int_undef)
+declare_ovr_handler(delay_wait_checks, set_off_int_undef)
+declare_ovr_snprint(delay_wait_checks, print_off_int_undef)
+declare_hw_handler(delay_wait_checks, set_off_int_undef)
+declare_hw_snprint(delay_wait_checks, print_off_int_undef)
+declare_mp_handler(delay_wait_checks, set_off_int_undef)
+declare_mp_snprint(delay_wait_checks, print_off_int_undef)
+declare_def_handler(san_path_err_threshold, set_off_int_undef)
+declare_def_snprint(san_path_err_threshold, print_off_int_undef)
+declare_ovr_handler(san_path_err_threshold, set_off_int_undef)
+declare_ovr_snprint(san_path_err_threshold, print_off_int_undef)
+declare_hw_handler(san_path_err_threshold, set_off_int_undef)
+declare_hw_snprint(san_path_err_threshold, print_off_int_undef)
+declare_mp_handler(san_path_err_threshold, set_off_int_undef)
+declare_mp_snprint(san_path_err_threshold, print_off_int_undef)
+declare_def_handler(san_path_err_forget_rate, set_off_int_undef)
+declare_def_snprint(san_path_err_forget_rate, print_off_int_undef)
+declare_ovr_handler(san_path_err_forget_rate, set_off_int_undef)
+declare_ovr_snprint(san_path_err_forget_rate, print_off_int_undef)
+declare_hw_handler(san_path_err_forget_rate, set_off_int_undef)
+declare_hw_snprint(san_path_err_forget_rate, print_off_int_undef)
+declare_mp_handler(san_path_err_forget_rate, set_off_int_undef)
+declare_mp_snprint(san_path_err_forget_rate, print_off_int_undef)
+declare_def_handler(san_path_err_recovery_time, set_off_int_undef)
+declare_def_snprint(san_path_err_recovery_time, print_off_int_undef)
+declare_ovr_handler(san_path_err_recovery_time, set_off_int_undef)
+declare_ovr_snprint(san_path_err_recovery_time, print_off_int_undef)
+declare_hw_handler(san_path_err_recovery_time, set_off_int_undef)
+declare_hw_snprint(san_path_err_recovery_time, print_off_int_undef)
+declare_mp_handler(san_path_err_recovery_time, set_off_int_undef)
+declare_mp_snprint(san_path_err_recovery_time, print_off_int_undef)
 static int
 def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
@@ -1404,6 +1426,10 @@ init_keywords(vector keywords)
 	install_keyword("config_dir", &def_config_dir_handler, &snprint_def_config_dir);
 	install_keyword("delay_watch_checks", &def_delay_watch_checks_handler, &snprint_def_delay_watch_checks);
 	install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &snprint_def_delay_wait_checks);
+        install_keyword("san_path_err_threshold", &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
+        install_keyword("san_path_err_forget_rate", &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_forget_rate);
+        install_keyword("san_path_err_recovery_time", &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_recovery_time);
+
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
 	install_keyword("retrigger_tries", &def_retrigger_tries_handler, &snprint_def_retrigger_tries);
@@ -1486,6 +1512,9 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
+        install_keyword("san_path_err_threshold", &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
+        install_keyword("san_path_err_forget_rate", &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_forget_rate);
+        install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_sublevel_end();
@@ -1515,6 +1544,10 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
+        install_keyword("san_path_err_threshold", &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
+        install_keyword("san_path_err_forget_rate", &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_forget_rate);
+        install_keyword("san_path_err_recovery_time", &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_recovery_time);
+
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
 
@@ -1543,6 +1576,9 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &mp_deferred_remove_handler, &snprint_mp_deferred_remove);
 	install_keyword("delay_watch_checks", &mp_delay_watch_checks_handler, &snprint_mp_delay_watch_checks);
 	install_keyword("delay_wait_checks", &mp_delay_wait_checks_handler, &snprint_mp_delay_wait_checks);
+	install_keyword("san_path_err_threshold", &mp_san_path_err_threshold_handler, &snprint_mp_san_path_err_threshold);
+	install_keyword("san_path_err_forget_rate", &mp_san_path_err_forget_rate_handler, &snprint_mp_san_path_err_forget_rate);
+	install_keyword("san_path_err_recovery_time", &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_recovery_time);
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
 	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
 	install_sublevel_end();
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 4cd03c5..2d6097d 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -14,6 +14,5 @@ int print_no_path_retry(char * buff, int len, void *ptr);
 int print_fast_io_fail(char * buff, int len, void *ptr);
 int print_dev_loss(char * buff, int len, void *ptr);
 int print_reservation_key(char * buff, int len, void * ptr);
-int print_delay_checks(char * buff, int len, void *ptr);
-
+int print_off_int_undef(char * buff, int len, void *ptr);
 #endif /* _DICT_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index c0bc616..e4afef7 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -623,7 +623,7 @@ int select_delay_watch_checks(struct config *conf, struct multipath *mp)
 	mp_set_conf(delay_watch_checks);
 	mp_set_default(delay_watch_checks, DEFAULT_DELAY_CHECKS);
 out:
-	print_delay_checks(buff, 12, &mp->delay_watch_checks);
+	print_off_int_undef(buff, 12, &mp->delay_watch_checks);
 	condlog(3, "%s: delay_watch_checks = %s %s", mp->alias, buff, origin);
 	return 0;
 }
@@ -638,12 +638,56 @@ int select_delay_wait_checks(struct config *conf, struct multipath *mp)
 	mp_set_conf(delay_wait_checks);
 	mp_set_default(delay_wait_checks, DEFAULT_DELAY_CHECKS);
 out:
-	print_delay_checks(buff, 12, &mp->delay_wait_checks);
+	print_off_int_undef(buff, 12, &mp->delay_wait_checks);
 	condlog(3, "%s: delay_wait_checks = %s %s", mp->alias, buff, origin);
 	return 0;
 
 }
+int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
+{
+        char *origin, buff[12];
+
+        mp_set_mpe(san_path_err_threshold);
+        mp_set_ovr(san_path_err_threshold);
+        mp_set_hwe(san_path_err_threshold);
+        mp_set_conf(san_path_err_threshold);
+        mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
+out:
+        print_off_int_undef(buff, 12, &mp->san_path_err_threshold);
+        condlog(3, "%s: san_path_err_threshold = %s %s", mp->alias, buff, origin);
+        return 0;
+}
+
+int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
+{
+        char *origin, buff[12];
+
+        mp_set_mpe(san_path_err_forget_rate);
+        mp_set_ovr(san_path_err_forget_rate);
+        mp_set_hwe(san_path_err_forget_rate);
+        mp_set_conf(san_path_err_forget_rate);
+        mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
+out:
+        print_off_int_undef(buff, 12, &mp->san_path_err_forget_rate);
+        condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias, buff, origin);
+        return 0;
+
+}
+int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
+{
+        char *origin, buff[12];
 
+        mp_set_mpe(san_path_err_recovery_time);
+        mp_set_ovr(san_path_err_recovery_time);
+        mp_set_hwe(san_path_err_recovery_time);
+        mp_set_conf(san_path_err_recovery_time);
+        mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
+out:
+        print_off_int_undef(buff, 12, &mp->san_path_err_recovery_time);
+        condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias, buff, origin);
+        return 0;
+
+}
 int select_skip_kpartx (struct config *conf, struct multipath * mp)
 {
 	char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index ad98fa5..e5b6f93 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -24,3 +24,6 @@ int select_delay_watch_checks (struct config *conf, struct multipath * mp);
 int select_delay_wait_checks (struct config *conf, struct multipath * mp);
 int select_skip_kpartx (struct config *conf, struct multipath * mp);
 int select_max_sectors_kb (struct config *conf, struct multipath * mp);
+int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
+int select_san_path_err_threshold(struct config *conf, struct multipath *mp);
+int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 396f69d..6edd927 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -152,9 +152,9 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
-enum delay_checks_states {
-	DELAY_CHECKS_OFF = -1,
-	DELAY_CHECKS_UNDEF = 0,
+enum no_undef_states {
+	NU_NO = -1,
+	NU_UNDEF = 0,
 };
 
 enum initialized_states {
@@ -223,7 +223,10 @@ struct path {
 	int initialized;
 	int retriggers;
 	int wwid_changed;
-
+	unsigned int path_failures;
+	time_t dis_reinstate_time;
+	int disable_reinstate;
+	int san_path_err_forget_rate;
 	/* configlet pointers */
 	struct hwentry * hwe;
 };
@@ -255,6 +258,9 @@ struct multipath {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int san_path_err_threshold;
+	int san_path_err_forget_rate;
+	int san_path_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	unsigned int dev_loss;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 36589f5..3c564ad 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -751,6 +751,45 @@ The default is: \fB/etc/multipath/conf.d/\fR
 .
 .
 .TP
+.B san_path_err_threshold
+If set to a value greater than 0, multipathd will watch paths and check how many
+times a path has been failed due to errors.If the number of failures on a particular
+path is greater then the san_path_err_threshold then the path will not  reinstante
+till san_path_err_recovery_time.These path failures should occur within a 
+san_path_err_forget_rate checks, if not we will consider the path is good enough
+to reinstantate.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B san_path_err_forget_rate
+If set to a value greater than 0, multipathd will check whether the path failures
+has exceeded  the san_path_err_threshold within this many checks i.e 
+san_path_err_forget_rate . If so we will not reinstante the path till
+san_path_err_recovery_time.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B san_path_err_recovery_time
+If set to a value greater than 0, multipathd will make sure that when path failures
+has exceeded the san_path_err_threshold within san_path_err_forget_rate then the path
+will be placed in failed state for san_path_err_recovery_time duration.Once san_path_err_recovery_time
+has timeout  we will reinstante the failed path .
+san_path_err_recovery_time value should be in secs.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
 .B delay_watch_checks
 If set to a value greater than 0, multipathd will watch paths that have
 recently become valid for this many checks. If they fail again while they are
@@ -1015,6 +1054,12 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .TP
 .B deferred_remove
 .TP
+.B san_path_err_threshold
+.TP
+.B san_path_err_forget_rate
+.TP
+.B san_path_err_recovery_time
+.TP
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
@@ -1128,6 +1173,12 @@ section:
 .TP
 .B deferred_remove
 .TP
+.B san_path_err_threshold
+.TP
+.B san_path_err_forget_rate
+.TP
+.B san_path_err_recovery_time
+.TP
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
@@ -1192,6 +1243,12 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B deferred_remove
 .TP
+.B san_path_err_threshold
+.TP
+.B san_path_err_forget_rate
+.TP
+.B san_path_err_recovery_time
+.TP
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
diff --git a/multipathd/main.c b/multipathd/main.c
index adc3258..4a1a7ef 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1487,6 +1487,83 @@ void repair_path(struct path * pp)
 	LOG_MSG(1, checker_message(&pp->checker));
 }
 
+static int check_path_reinstate_state(struct path * pp) {
+	struct timespec curr_time;
+	if (!((pp->mpp->san_path_err_threshold > 0) &&
+				(pp->mpp->san_path_err_forget_rate > 0) &&
+				(pp->mpp->san_path_err_recovery_time >0))) {
+		return 0;
+	}
+	
+	if (pp->disable_reinstate) {
+		/* If we don't know how much time has passed, automatically
+		 * reinstate the path, just to be safe. Also, if there are
+		 * no other usable paths, reinstate the path 
+		 */
+		if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0 ||
+				pp->mpp->nr_active == 0) {
+			condlog(2, "%s : reinstating path early", pp->dev);
+			goto reinstate_path;
+		}
+		if ((curr_time.tv_sec - pp->dis_reinstate_time ) > pp->mpp->san_path_err_recovery_time) {
+			condlog(2,"%s : reinstate the path after err recovery time", pp->dev);
+			goto reinstate_path;
+		}
+		return 1;
+	}
+	/* forget errors on a working path */
+	if ((pp->state == PATH_UP || pp->state == PATH_GHOST) &&
+			pp->path_failures > 0) {
+		if (pp->san_path_err_forget_rate > 0){
+			pp->san_path_err_forget_rate--;
+		} else {
+			/* for every san_path_err_forget_rate number of 
+			 * successful path checks decrement path_failures by 1
+			 */
+			pp->path_failures--;
+			pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
+		}
+		return 0;
+	}
+
+	/* If the path isn't recovering from a failed state, do nothing */
+	if (pp->state != PATH_DOWN && pp->state != PATH_SHAKY &&
+			pp->state != PATH_TIMEOUT)
+		return 0;
+
+	if (pp->path_failures == 0)
+		pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
+
+	pp->path_failures++;
+
+	/* if we don't know the currently time, we don't know how long to
+	 * delay the path, so there's no point in checking if we should 
+	 */
+
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return 0;
+	/* when path failures has exceeded the san_path_err_threshold
+	 * place the path in delayed state till san_path_err_recovery_time
+	 * so that the cutomer can rectify the issue within this time. After
+	 * the completion of san_path_err_recovery_time it should
+	 * automatically reinstate the path 
+	 */
+	if (pp->path_failures > pp->mpp->san_path_err_threshold) {
+		condlog(2, "%s : hit error threshold. Delaying path reinstatement", pp->dev);
+		pp->dis_reinstate_time = curr_time.tv_sec;
+		pp->disable_reinstate = 1;
+		return 1;
+	} else {
+		return 0;
+	}
+
+reinstate_path:
+	pp->path_failures = 0;
+	pp->disable_reinstate = 0;
+	pp->san_path_err_forget_rate = 0;
+	return 0;
+}
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1601,6 +1678,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		return 0;
 
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
+			check_path_reinstate_state(pp)) {
+		pp->state = PATH_DELAYED;
+		return 1;
+	}
+
+	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	     pp->wait_checks > 0) {
 		if (pp->mpp->nr_active > 0) {
 			pp->state = PATH_DELAYED;
-- 
1.8.3.1
