From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: [PATCH 1/1] multipathd: deterministic io throughput in
 multipath
Date: Mon, 6 Feb 2017 06:12:24 +0000
Message-ID: <42125645d5d647c3a028bbaf6082a13f@HQ1WP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7367649010214218121=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7367649010214218121==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_42125645d5d647c3a028bbaf6082a13fHQ1WPEXMB12corpbrocadec_"

--_000_42125645d5d647c3a028bbaf6082a13fHQ1WPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

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


diff --git a/libmultipath/config.c b/libmultipath/config.c
index 15ddbd8..5837dc6 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -348,6 +348,9 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
        merge_num(delay_wait_checks);
        merge_num(skip_kpartx);
        merge_num(max_sectors_kb);
+       merge_num(san_path_err_threshold);
+       merge_num(san_path_err_forget_rate);
+       merge_num(san_path_err_recovery_time);

        /*
         * Make sure features is consistent with
@@ -621,6 +624,9 @@ load_config (char * file)
        conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
        conf->remove_retries = 0;
        conf->max_sectors_kb = DEFAULT_MAX_SECTORS_KB;
+       conf->san_path_err_threshold = DEFAULT_ERR_CHECKS;
+       conf->san_path_err_forget_rate = DEFAULT_ERR_CHECKS;
+       conf->san_path_err_recovery_time = DEFAULT_ERR_CHECKS;

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
+       int san_path_err_threshold;
+       int san_path_err_forget_rate;
+       int san_path_err_recovery_time;
        int skip_kpartx;
        int max_sectors_kb;
        char * bl_product;
@@ -93,6 +96,9 @@ struct mpentry {
        int deferred_remove;
        int delay_watch_checks;
        int delay_wait_checks;
+       int san_path_err_threshold;
+       int san_path_err_forget_rate;
+       int san_path_err_recovery_time;
        int skip_kpartx;
        int max_sectors_kb;
        uid_t uid;
@@ -138,6 +144,9 @@ struct config {
        int processed_main_config;
        int delay_watch_checks;
        int delay_wait_checks;
+       int san_path_err_threshold;
+       int san_path_err_forget_rate;
+       int san_path_err_recovery_time;
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
+       select_san_path_err_threshold(conf, mpp);
+       select_san_path_err_forget_rate(conf, mpp);
+       select_san_path_err_recovery_time(conf, mpp);
        select_skip_kpartx(conf, mpp);
        select_max_sectors_kb(conf, mpp);

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index b9b0a37..3ef1579 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -23,7 +23,8 @@
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
 #define DEFAULT_DETECT_PRIO    DETECT_PRIO_ON
 #define DEFAULT_DEFERRED_REMOVE        DEFERRED_REMOVE_OFF
-#define DEFAULT_DELAY_CHECKS   DELAY_CHECKS_OFF
+#define DEFAULT_DELAY_CHECKS   NU_NO
+#define DEFAULT_ERR_CHECKS     NU_NO
 #define DEFAULT_UEVENT_STACKSIZE 256
 #define DEFAULT_RETRIGGER_DELAY        10
 #define DEFAULT_RETRIGGER_TRIES        3
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
-               *int_ptr = DELAY_CHECKS_OFF;
+               *int_ptr = NU_NO;
        else if ((*int_ptr = atoi(buff)) < 1)
-               *int_ptr = DELAY_CHECKS_UNDEF;
+               *int_ptr = NU_UNDEF;

        FREE(buff);
        return 0;
 }

 int
-print_delay_checks(char * buff, int len, void *ptr)
+print_off_int_undef(char * buff, int len, void *ptr)
 {
        int *int_ptr = (int *)ptr;

        switch(*int_ptr) {
-       case DELAY_CHECKS_UNDEF:
+       case NU_UNDEF:
                return 0;
-       case DELAY_CHECKS_OFF:
-               return snprintf(buff, len, "\"off\"");
+       case NU_NO:
+               return snprintf(buff, len, "\"no\"");
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
+       install_keyword("san_path_err_threshold", &mp_san_path_err_threshold_handler, &snprint_mp_san_path_err_threshold);
+       install_keyword("san_path_err_forget_rate", &mp_san_path_err_forget_rate_handler, &snprint_mp_san_path_err_forget_rate);
+       install_keyword("san_path_err_recovery_time", &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_recovery_time);
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
-       print_delay_checks(buff, 12, &mp->delay_watch_checks);
+       print_off_int_undef(buff, 12, &mp->delay_watch_checks);
        condlog(3, "%s: delay_watch_checks = %s %s", mp->alias, buff, origin);
        return 0;
 }
@@ -638,12 +638,56 @@ int select_delay_wait_checks(struct config *conf, struct multipath *mp)
        mp_set_conf(delay_wait_checks);
        mp_set_default(delay_wait_checks, DEFAULT_DELAY_CHECKS);
 out:
-       print_delay_checks(buff, 12, &mp->delay_wait_checks);
+       print_off_int_undef(buff, 12, &mp->delay_wait_checks);
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
-       DELAY_CHECKS_OFF = -1,
-       DELAY_CHECKS_UNDEF = 0,
+enum no_undef_states {
+       NU_NO = -1,
+       NU_UNDEF = 0,
 };

 enum initialized_states {
@@ -223,7 +223,10 @@ struct path {
        int initialized;
        int retriggers;
        int wwid_changed;
-
+       unsigned int path_failures;
+       time_t dis_reinstate_time;
+       int disable_reinstate;
+       int san_path_err_forget_rate;
        /* configlet pointers */
        struct hwentry * hwe;
 };
@@ -255,6 +258,9 @@ struct multipath {
        int deferred_remove;
        int delay_watch_checks;
        int delay_wait_checks;
+       int san_path_err_threshold;
+       int san_path_err_forget_rate;
+       int san_path_err_recovery_time;
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
+       struct timespec curr_time;
+       if (!((pp->mpp->san_path_err_threshold > 0) &&
+                               (pp->mpp->san_path_err_forget_rate > 0) &&
+                               (pp->mpp->san_path_err_recovery_time >0))) {
+               return 0;
+       }
+
+       if (pp->disable_reinstate) {
+               /* If we don't know how much time has passed, automatically
+                * reinstate the path, just to be safe. Also, if there are
+                * no other usable paths, reinstate the path
+                */
+               if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0 ||
+                               pp->mpp->nr_active == 0) {
+                       condlog(2, "%s : reinstating path early", pp->dev);
+                       goto reinstate_path;
+               }
+               if ((curr_time.tv_sec - pp->dis_reinstate_time ) > pp->mpp->san_path_err_recovery_time) {
+                       condlog(2,"%s : reinstate the path after err recovery time", pp->dev);
+                       goto reinstate_path;
+               }
+               return 1;
+       }
+       /* forget errors on a working path */
+       if ((pp->state == PATH_UP || pp->state == PATH_GHOST) &&
+                       pp->path_failures > 0) {
+               if (pp->san_path_err_forget_rate > 0){
+                       pp->san_path_err_forget_rate--;
+               } else {
+                       /* for every san_path_err_forget_rate number of
+                        * successful path checks decrement path_failures by 1
+                        */
+                       pp->path_failures--;
+                       pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
+               }
+               return 0;
+       }
+
+       /* If the path isn't recovering from a failed state, do nothing */
+       if (pp->state != PATH_DOWN && pp->state != PATH_SHAKY &&
+                       pp->state != PATH_TIMEOUT)
+               return 0;
+
+       if (pp->path_failures == 0)
+               pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
+
+       pp->path_failures++;
+
+       /* if we don't know the currently time, we don't know how long to
+        * delay the path, so there's no point in checking if we should
+        */
+
+       if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+               return 0;
+       /* when path failures has exceeded the san_path_err_threshold
+        * place the path in delayed state till san_path_err_recovery_time
+        * so that the cutomer can rectify the issue within this time. After
+        * the completion of san_path_err_recovery_time it should
+        * automatically reinstate the path
+        */
+       if (pp->path_failures > pp->mpp->san_path_err_threshold) {
+               condlog(2, "%s : hit error threshold. Delaying path reinstatement", pp->dev);
+               pp->dis_reinstate_time = curr_time.tv_sec;
+               pp->disable_reinstate = 1;
+               return 1;
+       } else {
+               return 0;
+       }
+
+reinstate_path:
+       pp->path_failures = 0;
+       pp->disable_reinstate = 0;
+       pp->san_path_err_forget_rate = 0;
+       return 0;
+}
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1601,6 +1678,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
                return 0;

        if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
+                       check_path_reinstate_state(pp)) {
+               pp->state = PATH_DELAYED;
+               return 1;
+       }
+
+       if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
             pp->wait_checks > 0) {
                if (pp->mpp->nr_active > 0) {
                        pp->state = PATH_DELAYED;
--
1.8.3.1


--_000_42125645d5d647c3a028bbaf6082a13fHQ1WPEXMB12corpbrocadec_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt;">
<div>This patch adds three configuration parameters, &quot;san_path_err_thr=
eshold&quot;,</div>
<div>&quot;san_path_err_recovery_time&quot; and &quot;san_path_err_forget_r=
ate&quot;.</div>
<div>multipathd will watch paths and check how many times a path has been f=
ailed due</div>
<div>to errors.If the number of failures on a particular path is greater th=
en the</div>
<div>san_path_err_threshold then the path will not&nbsp; reinstante till</d=
iv>
<div>san_path_err_recovery_time.These path failures should occur within a</=
div>
<div>san_path_err_forget_rate checks, if not we will consider the path is g=
ood enough</div>
<div>to reinstantate.If it is the only available path, it will immediately =
be</div>
<div>reintegrated.</div>
<div>&nbsp;</div>
<div>This helps us to place the path in failed state if we hit lot of error=
s on a particular path</div>
<div>due to network /target issues and allow the admin to rectify the error=
s on a path.</div>
<div>&nbsp;</div>
<div>Signed-off-by: M Muneendra Kumar &lt;mmandala@brocade.com&gt;</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>diff --git a/libmultipath/config.c b/libmultipath/config.c</div>
<div>index 15ddbd8..5837dc6 100644</div>
<div>--- a/libmultipath/config.c</div>
<div>&#43;&#43;&#43; b/libmultipath/config.c</div>
<div>@@ -348,6 &#43;348,9 @@ merge_hwe (struct hwentry * dst, struct hwentr=
y * src)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; merge_num(delay_wait_=
checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; merge_num(skip_kpartx=
);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; merge_num(max_sectors=
_kb);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; merge_num(san_path_err_thres=
hold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; merge_num(san_path_err_forge=
t_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; merge_num(san_path_err_recov=
ery_time);</div>
<div>&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Make sure fea=
tures is consistent with</div>
<div>@@ -621,6 &#43;624,9 @@ load_config (char * file)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; conf-&gt;disable_chan=
ged_wwids =3D DEFAULT_DISABLE_CHANGED_WWIDS;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; conf-&gt;remove_retri=
es =3D 0;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; conf-&gt;max_sectors_=
kb =3D DEFAULT_MAX_SECTORS_KB;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; conf-&gt;san_path_err_thresh=
old =3D DEFAULT_ERR_CHECKS;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; conf-&gt;san_path_err_forget=
_rate =3D DEFAULT_ERR_CHECKS;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; conf-&gt;san_path_err_recove=
ry_time =3D DEFAULT_ERR_CHECKS;</div>
<div>&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * preload defau=
lt hwtable</div>
<div>diff --git a/libmultipath/config.h b/libmultipath/config.h</div>
<div>index 9670020..9e47894 100644</div>
<div>--- a/libmultipath/config.h</div>
<div>&#43;&#43;&#43; b/libmultipath/config.h</div>
<div>@@ -65,6 &#43;65,9 @@ struct hwentry {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int deferred_remove;<=
/div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_watch_check=
s;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_wait_checks=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_threshold;<=
/div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_forget_rate=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_recovery_ti=
me;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int skip_kpartx;</div=
>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int max_sectors_kb;</=
div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char * bl_product;</d=
iv>
<div>@@ -93,6 &#43;96,9 @@ struct mpentry {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int deferred_remove;<=
/div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_watch_check=
s;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_wait_checks=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_threshold;<=
/div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_forget_rate=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_recovery_ti=
me;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int skip_kpartx;</div=
>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int max_sectors_kb;</=
div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uid_t uid;</div>
<div>@@ -138,6 &#43;144,9 @@ struct config {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int processed_main_co=
nfig;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_watch_check=
s;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_wait_checks=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_threshold;<=
/div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_forget_rate=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_recovery_ti=
me;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int uxsock_timeout;</=
div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int strict_timing;</d=
iv>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int retrigger_tries;<=
/div>
<div>diff --git a/libmultipath/configure.c b/libmultipath/configure.c</div>
<div>index a0fcad9..5ad3007 100644</div>
<div>--- a/libmultipath/configure.c</div>
<div>&#43;&#43;&#43; b/libmultipath/configure.c</div>
<div>@@ -294,6 &#43;294,9 @@ int setup_map(struct multipath *mpp, char *par=
ams, int params_size)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_deferred_remov=
e(conf, mpp);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_delay_watch_ch=
ecks(conf, mpp);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_delay_wait_che=
cks(conf, mpp);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_san_path_err_threshol=
d(conf, mpp);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_san_path_err_forget_r=
ate(conf, mpp);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_san_path_err_recovery=
_time(conf, mpp);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_skip_kpartx(co=
nf, mpp);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_max_sectors_kb=
(conf, mpp);</div>
<div>&nbsp;</div>
<div>diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h</div>
<div>index b9b0a37..3ef1579 100644</div>
<div>--- a/libmultipath/defaults.h</div>
<div>&#43;&#43;&#43; b/libmultipath/defaults.h</div>
<div>@@ -23,7 &#43;23,8 @@</div>
<div> #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON</div>
<div> #define DEFAULT_DETECT_PRIO&nbsp;&nbsp;&nbsp; DETECT_PRIO_ON</div>
<div> #define DEFAULT_DEFERRED_REMOVE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; DEFERRED_REMOVE_OFF</div>
<div>-#define DEFAULT_DELAY_CHECKS&nbsp;&nbsp; DELAY_CHECKS_OFF</div>
<div>&#43;#define DEFAULT_DELAY_CHECKS&nbsp;&nbsp; NU_NO</div>
<div>&#43;#define DEFAULT_ERR_CHECKS&nbsp;&nbsp;&nbsp;&nbsp; NU_NO</div>
<div> #define DEFAULT_UEVENT_STACKSIZE 256</div>
<div> #define DEFAULT_RETRIGGER_DELAY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 10</div>
<div> #define DEFAULT_RETRIGGER_TRIES&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 3</div>
<div>diff --git a/libmultipath/dict.c b/libmultipath/dict.c</div>
<div>index dc21846..ae94c88 100644</div>
<div>--- a/libmultipath/dict.c</div>
<div>&#43;&#43;&#43; b/libmultipath/dict.c</div>
<div>@@ -1023,7 &#43;1023,7 @@ declare_mp_handler(reservation_key, set_rese=
rvation_key)</div>
<div> declare_mp_snprint(reservation_key, print_reservation_key)</div>
<div>&nbsp;</div>
<div> static int</div>
<div>-set_delay_checks(vector strvec, void *ptr)</div>
<div>&#43;set_off_int_undef(vector strvec, void *ptr)</div>
<div> {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int *int_ptr =3D (int=
 *)ptr;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char * buff;</div>
<div>@@ -1033,47 &#43;1033,69 @@ set_delay_checks(vector strvec, void *ptr)=
</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; return 1;</div>
<div>&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!strcmp(buff, &qu=
ot;no&quot;) || !strcmp(buff, &quot;0&quot;))</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; *int_ptr =3D DELAY_CHECKS_OFF;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; *int_ptr =3D NU_NO;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else if ((*int_ptr =
=3D atoi(buff)) &lt; 1)</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; *int_ptr =3D DELAY_CHECKS_UNDEF;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; *int_ptr =3D NU_UNDEF;</div>
<div>&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FREE(buff);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div> }</div>
<div>&nbsp;</div>
<div> int</div>
<div>-print_delay_checks(char * buff, int len, void *ptr)</div>
<div>&#43;print_off_int_undef(char * buff, int len, void *ptr)</div>
<div> {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int *int_ptr =3D (int=
 *)ptr;</div>
<div>&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; switch(*int_ptr) {</d=
iv>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case DELAY_CHECKS_UNDEF:</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case NU_UNDEF:</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case DELAY_CHECKS_OFF:</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; return snprintf(buff, len, &quot;\&quot;off\&quot;&quot;);<=
/div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case NU_NO:</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return snprintf(buff, len, &quot;\&quot;no\&quot;&quot;=
);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; default:</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; return snprintf(buff, len, &quot;%i&quot;, *int_=
ptr);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div> }</div>
<div>&nbsp;</div>
<div>-declare_def_handler(delay_watch_checks, set_delay_checks)</div>
<div>-declare_def_snprint(delay_watch_checks, print_delay_checks)</div>
<div>-declare_ovr_handler(delay_watch_checks, set_delay_checks)</div>
<div>-declare_ovr_snprint(delay_watch_checks, print_delay_checks)</div>
<div>-declare_hw_handler(delay_watch_checks, set_delay_checks)</div>
<div>-declare_hw_snprint(delay_watch_checks, print_delay_checks)</div>
<div>-declare_mp_handler(delay_watch_checks, set_delay_checks)</div>
<div>-declare_mp_snprint(delay_watch_checks, print_delay_checks)</div>
<div>-</div>
<div>-declare_def_handler(delay_wait_checks, set_delay_checks)</div>
<div>-declare_def_snprint(delay_wait_checks, print_delay_checks)</div>
<div>-declare_ovr_handler(delay_wait_checks, set_delay_checks)</div>
<div>-declare_ovr_snprint(delay_wait_checks, print_delay_checks)</div>
<div>-declare_hw_handler(delay_wait_checks, set_delay_checks)</div>
<div>-declare_hw_snprint(delay_wait_checks, print_delay_checks)</div>
<div>-declare_mp_handler(delay_wait_checks, set_delay_checks)</div>
<div>-declare_mp_snprint(delay_wait_checks, print_delay_checks)</div>
<div>-</div>
<div>&#43;declare_def_handler(delay_watch_checks, set_off_int_undef)</div>
<div>&#43;declare_def_snprint(delay_watch_checks, print_off_int_undef)</div=
>
<div>&#43;declare_ovr_handler(delay_watch_checks, set_off_int_undef)</div>
<div>&#43;declare_ovr_snprint(delay_watch_checks, print_off_int_undef)</div=
>
<div>&#43;declare_hw_handler(delay_watch_checks, set_off_int_undef)</div>
<div>&#43;declare_hw_snprint(delay_watch_checks, print_off_int_undef)</div>
<div>&#43;declare_mp_handler(delay_watch_checks, set_off_int_undef)</div>
<div>&#43;declare_mp_snprint(delay_watch_checks, print_off_int_undef)</div>
<div>&#43;declare_def_handler(delay_wait_checks, set_off_int_undef)</div>
<div>&#43;declare_def_snprint(delay_wait_checks, print_off_int_undef)</div>
<div>&#43;declare_ovr_handler(delay_wait_checks, set_off_int_undef)</div>
<div>&#43;declare_ovr_snprint(delay_wait_checks, print_off_int_undef)</div>
<div>&#43;declare_hw_handler(delay_wait_checks, set_off_int_undef)</div>
<div>&#43;declare_hw_snprint(delay_wait_checks, print_off_int_undef)</div>
<div>&#43;declare_mp_handler(delay_wait_checks, set_off_int_undef)</div>
<div>&#43;declare_mp_snprint(delay_wait_checks, print_off_int_undef)</div>
<div>&#43;declare_def_handler(san_path_err_threshold, set_off_int_undef)</d=
iv>
<div>&#43;declare_def_snprint(san_path_err_threshold, print_off_int_undef)<=
/div>
<div>&#43;declare_ovr_handler(san_path_err_threshold, set_off_int_undef)</d=
iv>
<div>&#43;declare_ovr_snprint(san_path_err_threshold, print_off_int_undef)<=
/div>
<div>&#43;declare_hw_handler(san_path_err_threshold, set_off_int_undef)</di=
v>
<div>&#43;declare_hw_snprint(san_path_err_threshold, print_off_int_undef)</=
div>
<div>&#43;declare_mp_handler(san_path_err_threshold, set_off_int_undef)</di=
v>
<div>&#43;declare_mp_snprint(san_path_err_threshold, print_off_int_undef)</=
div>
<div>&#43;declare_def_handler(san_path_err_forget_rate, set_off_int_undef)<=
/div>
<div>&#43;declare_def_snprint(san_path_err_forget_rate, print_off_int_undef=
)</div>
<div>&#43;declare_ovr_handler(san_path_err_forget_rate, set_off_int_undef)<=
/div>
<div>&#43;declare_ovr_snprint(san_path_err_forget_rate, print_off_int_undef=
)</div>
<div>&#43;declare_hw_handler(san_path_err_forget_rate, set_off_int_undef)</=
div>
<div>&#43;declare_hw_snprint(san_path_err_forget_rate, print_off_int_undef)=
</div>
<div>&#43;declare_mp_handler(san_path_err_forget_rate, set_off_int_undef)</=
div>
<div>&#43;declare_mp_snprint(san_path_err_forget_rate, print_off_int_undef)=
</div>
<div>&#43;declare_def_handler(san_path_err_recovery_time, set_off_int_undef=
)</div>
<div>&#43;declare_def_snprint(san_path_err_recovery_time, print_off_int_und=
ef)</div>
<div>&#43;declare_ovr_handler(san_path_err_recovery_time, set_off_int_undef=
)</div>
<div>&#43;declare_ovr_snprint(san_path_err_recovery_time, print_off_int_und=
ef)</div>
<div>&#43;declare_hw_handler(san_path_err_recovery_time, set_off_int_undef)=
</div>
<div>&#43;declare_hw_snprint(san_path_err_recovery_time, print_off_int_unde=
f)</div>
<div>&#43;declare_mp_handler(san_path_err_recovery_time, set_off_int_undef)=
</div>
<div>&#43;declare_mp_snprint(san_path_err_recovery_time, print_off_int_unde=
f)</div>
<div> static int</div>
<div> def_uxsock_timeout_handler(struct config *conf, vector strvec)</div>
<div> {</div>
<div>@@ -1404,6 &#43;1426,10 @@ init_keywords(vector keywords)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;config_dir&quot;, &amp;def_config_dir_handler, &amp;snprint_def_config_dir=
);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_watch_checks&quot;, &amp;def_delay_watch_checks_handler, &amp;snprin=
t_def_delay_watch_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_wait_checks&quot;, &amp;def_delay_wait_checks_handler, &amp;snprint_=
def_delay_wait_checks);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_threshold&quot;, &amp;def_san_path_err_threshold_handler, &amp=
;snprint_def_san_path_err_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_forget_rate&quot;, &amp;def_san_path_err_forget_rate_handler, =
&amp;snprint_def_san_path_err_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_recovery_time&quot;, &amp;def_san_path_err_recovery_time_handl=
er, &amp;snprint_def_san_path_err_recovery_time);</div>
<div>&#43;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;find_multipaths&quot;, &amp;def_find_multipaths_handler, &amp;snprint_def_=
find_multipaths);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;uxsock_timeout&quot;, &amp;def_uxsock_timeout_handler, &amp;snprint_def_ux=
sock_timeout);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;retrigger_tries&quot;, &amp;def_retrigger_tries_handler, &amp;snprint_def_=
retrigger_tries);</div>
<div>@@ -1486,6 &#43;1512,9 @@ init_keywords(vector keywords)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;deferred_remove&quot;, &amp;hw_deferred_remove_handler, &amp;snprint_hw_de=
ferred_remove);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_watch_checks&quot;, &amp;hw_delay_watch_checks_handler, &amp;snprint=
_hw_delay_watch_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_wait_checks&quot;, &amp;hw_delay_wait_checks_handler, &amp;snprint_h=
w_delay_wait_checks);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_threshold&quot;, &amp;hw_san_path_err_threshold_handler, &amp;=
snprint_hw_san_path_err_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_forget_rate&quot;, &amp;hw_san_path_err_forget_rate_handler, &=
amp;snprint_hw_san_path_err_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_recovery_time&quot;, &amp;hw_san_path_err_recovery_time_handle=
r, &amp;snprint_hw_san_path_err_recovery_time);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;skip_kpartx&quot;, &amp;hw_skip_kpartx_handler, &amp;snprint_hw_skip_kpart=
x);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;max_sectors_kb&quot;, &amp;hw_max_sectors_kb_handler, &amp;snprint_hw_max_=
sectors_kb);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_sublevel_end(=
);</div>
<div>@@ -1515,6 &#43;1544,10 @@ init_keywords(vector keywords)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;deferred_remove&quot;, &amp;ovr_deferred_remove_handler, &amp;snprint_ovr_=
deferred_remove);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_watch_checks&quot;, &amp;ovr_delay_watch_checks_handler, &amp;snprin=
t_ovr_delay_watch_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_wait_checks&quot;, &amp;ovr_delay_wait_checks_handler, &amp;snprint_=
ovr_delay_wait_checks);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_threshold&quot;, &amp;ovr_san_path_err_threshold_handler, &amp=
;snprint_ovr_san_path_err_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_forget_rate&quot;, &amp;ovr_san_path_err_forget_rate_handler, =
&amp;snprint_ovr_san_path_err_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;=
san_path_err_recovery_time&quot;, &amp;ovr_san_path_err_recovery_time_handl=
er, &amp;snprint_ovr_san_path_err_recovery_time);</div>
<div>&#43;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;skip_kpartx&quot;, &amp;ovr_skip_kpartx_handler, &amp;snprint_ovr_skip_kpa=
rtx);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;max_sectors_kb&quot;, &amp;ovr_max_sectors_kb_handler, &amp;snprint_ovr_ma=
x_sectors_kb);</div>
<div>&nbsp;</div>
<div>@@ -1543,6 &#43;1576,9 @@ init_keywords(vector keywords)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;deferred_remove&quot;, &amp;mp_deferred_remove_handler, &amp;snprint_mp_de=
ferred_remove);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_watch_checks&quot;, &amp;mp_delay_watch_checks_handler, &amp;snprint=
_mp_delay_watch_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;delay_wait_checks&quot;, &amp;mp_delay_wait_checks_handler, &amp;snprint_m=
p_delay_wait_checks);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;san_pa=
th_err_threshold&quot;, &amp;mp_san_path_err_threshold_handler, &amp;snprin=
t_mp_san_path_err_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;san_pa=
th_err_forget_rate&quot;, &amp;mp_san_path_err_forget_rate_handler, &amp;sn=
print_mp_san_path_err_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot;san_pa=
th_err_recovery_time&quot;, &amp;mp_san_path_err_recovery_time_handler, &am=
p;snprint_mp_san_path_err_recovery_time);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;skip_kpartx&quot;, &amp;mp_skip_kpartx_handler, &amp;snprint_mp_skip_kpart=
x);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_keyword(&quot=
;max_sectors_kb&quot;, &amp;mp_max_sectors_kb_handler, &amp;snprint_mp_max_=
sectors_kb);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_sublevel_end(=
);</div>
<div>diff --git a/libmultipath/dict.h b/libmultipath/dict.h</div>
<div>index 4cd03c5..2d6097d 100644</div>
<div>--- a/libmultipath/dict.h</div>
<div>&#43;&#43;&#43; b/libmultipath/dict.h</div>
<div>@@ -14,6 &#43;14,5 @@ int print_no_path_retry(char * buff, int len, vo=
id *ptr);</div>
<div> int print_fast_io_fail(char * buff, int len, void *ptr);</div>
<div> int print_dev_loss(char * buff, int len, void *ptr);</div>
<div> int print_reservation_key(char * buff, int len, void * ptr);</div>
<div>-int print_delay_checks(char * buff, int len, void *ptr);</div>
<div>-</div>
<div>&#43;int print_off_int_undef(char * buff, int len, void *ptr);</div>
<div> #endif /* _DICT_H */</div>
<div>diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c</div>
<div>index c0bc616..e4afef7 100644</div>
<div>--- a/libmultipath/propsel.c</div>
<div>&#43;&#43;&#43; b/libmultipath/propsel.c</div>
<div>@@ -623,7 &#43;623,7 @@ int select_delay_watch_checks(struct config *c=
onf, struct multipath *mp)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_conf(delay_wat=
ch_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_default(delay_=
watch_checks, DEFAULT_DELAY_CHECKS);</div>
<div> out:</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_delay_checks(buff, 12, &am=
p;mp-&gt;delay_watch_checks);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_off_int_undef(buff, 12=
, &amp;mp-&gt;delay_watch_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog(3, &quot;%s: =
delay_watch_checks =3D %s %s&quot;, mp-&gt;alias, buff, origin);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div> }</div>
<div>@@ -638,12 &#43;638,56 @@ int select_delay_wait_checks(struct config *=
conf, struct multipath *mp)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_conf(delay_wai=
t_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_default(delay_=
wait_checks, DEFAULT_DELAY_CHECKS);</div>
<div> out:</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_delay_checks(buff, 12, &am=
p;mp-&gt;delay_wait_checks);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_off_int_undef(buff, 12=
, &amp;mp-&gt;delay_wait_checks);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog(3, &quot;%s: =
delay_wait_checks =3D %s %s&quot;, mp-&gt;alias, buff, origin);</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&nbsp;</div>
<div> }</div>
<div>&#43;int select_san_path_err_threshold(struct config *conf, struct mul=
tipath *mp)</div>
<div>&#43;{</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char *origin, buff[12]=
;</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_mpe(san_path_er=
r_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_ovr(san_path_er=
r_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_hwe(san_path_er=
r_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_conf(san_path_e=
rr_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_default(san_pat=
h_err_threshold, DEFAULT_ERR_CHECKS);</div>
<div>&#43;out:</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_off_int_undef(bu=
ff, 12, &amp;mp-&gt;san_path_err_threshold);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog(3, &quot;%s: s=
an_path_err_threshold =3D %s %s&quot;, mp-&gt;alias, buff, origin);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;}</div>
<div>&#43;</div>
<div>&#43;int select_san_path_err_forget_rate(struct config *conf, struct m=
ultipath *mp)</div>
<div>&#43;{</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char *origin, buff[12]=
;</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_mpe(san_path_er=
r_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_ovr(san_path_er=
r_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_hwe(san_path_er=
r_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_conf(san_path_e=
rr_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_default(san_pat=
h_err_forget_rate, DEFAULT_ERR_CHECKS);</div>
<div>&#43;out:</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_off_int_undef(bu=
ff, 12, &amp;mp-&gt;san_path_err_forget_rate);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog(3, &quot;%s: s=
an_path_err_forget_rate =3D %s %s&quot;, mp-&gt;alias, buff, origin);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;</div>
<div>&#43;}</div>
<div>&#43;int select_san_path_err_recovery_time(struct config *conf, struct=
 multipath *mp)</div>
<div>&#43;{</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char *origin, buff[12]=
;</div>
<div>&nbsp;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_mpe(san_path_er=
r_recovery_time);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_ovr(san_path_er=
r_recovery_time);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_hwe(san_path_er=
r_recovery_time);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_conf(san_path_e=
rr_recovery_time);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mp_set_default(san_pat=
h_err_recovery_time, DEFAULT_ERR_CHECKS);</div>
<div>&#43;out:</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_off_int_undef(bu=
ff, 12, &amp;mp-&gt;san_path_err_recovery_time);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog(3, &quot;%s: s=
an_path_err_recovery_time =3D %s %s&quot;, mp-&gt;alias, buff, origin);</di=
v>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;</div>
<div>&#43;}</div>
<div> int select_skip_kpartx (struct config *conf, struct multipath * mp)</=
div>
<div> {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char *origin;</div>
<div>diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h</div>
<div>index ad98fa5..e5b6f93 100644</div>
<div>--- a/libmultipath/propsel.h</div>
<div>&#43;&#43;&#43; b/libmultipath/propsel.h</div>
<div>@@ -24,3 &#43;24,6 @@ int select_delay_watch_checks (struct config *co=
nf, struct multipath * mp);</div>
<div> int select_delay_wait_checks (struct config *conf, struct multipath *=
 mp);</div>
<div> int select_skip_kpartx (struct config *conf, struct multipath * mp);<=
/div>
<div> int select_max_sectors_kb (struct config *conf, struct multipath * mp=
);</div>
<div>&#43;int select_san_path_err_forget_rate(struct config *conf, struct m=
ultipath *mp);</div>
<div>&#43;int select_san_path_err_threshold(struct config *conf, struct mul=
tipath *mp);</div>
<div>&#43;int select_san_path_err_recovery_time(struct config *conf, struct=
 multipath *mp);</div>
<div>diff --git a/libmultipath/structs.h b/libmultipath/structs.h</div>
<div>index 396f69d..6edd927 100644</div>
<div>--- a/libmultipath/structs.h</div>
<div>&#43;&#43;&#43; b/libmultipath/structs.h</div>
<div>@@ -152,9 &#43;152,9 @@ enum scsi_protocol {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SCSI_PROTOCOL_UNSPEC =
=3D 0xf, /* No specific protocol */</div>
<div> };</div>
<div>&nbsp;</div>
<div>-enum delay_checks_states {</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DELAY_CHECKS_OFF =3D -1,</div>
<div>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DELAY_CHECKS_UNDEF =3D 0,</div>
<div>&#43;enum no_undef_states {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NU_NO =3D -1,</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NU_UNDEF =3D 0,</div>
<div> };</div>
<div>&nbsp;</div>
<div> enum initialized_states {</div>
<div>@@ -223,7 &#43;223,10 @@ struct path {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int initialized;</div=
>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int retriggers;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int wwid_changed;</di=
v>
<div>-</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int path_failures;<=
/div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; time_t dis_reinstate_time;</=
div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int disable_reinstate;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_forget_rate=
;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* configlet pointers=
 */</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct hwentry * hwe;=
</div>
<div> };</div>
<div>@@ -255,6 &#43;258,9 @@ struct multipath {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int deferred_remove;<=
/div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_watch_check=
s;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int delay_wait_checks=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_threshold;<=
/div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_forget_rate=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int san_path_err_recovery_ti=
me;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int skip_kpartx;</div=
>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int max_sectors_kb;</=
div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int dev_loss=
;</div>
<div>diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5</=
div>
<div>index 36589f5..3c564ad 100644</div>
<div>--- a/multipath/multipath.conf.5</div>
<div>&#43;&#43;&#43; b/multipath/multipath.conf.5</div>
<div>@@ -751,6 &#43;751,45 @@ The default is: \fB/etc/multipath/conf.d/\fR<=
/div>
<div> .</div>
<div> .</div>
<div> .TP</div>
<div>&#43;.B san_path_err_threshold</div>
<div>&#43;If set to a value greater than 0, multipathd will watch paths and=
 check how many</div>
<div>&#43;times a path has been failed due to errors.If the number of failu=
res on a particular</div>
<div>&#43;path is greater then the san_path_err_threshold then the path wil=
l not&nbsp; reinstante</div>
<div>&#43;till san_path_err_recovery_time.These path failures should occur =
within a </div>
<div>&#43;san_path_err_forget_rate checks, if not we will consider the path=
 is good enough</div>
<div>&#43;to reinstantate.</div>
<div>&#43;.RS</div>
<div>&#43;.TP</div>
<div>&#43;The default is: \fBno\fR</div>
<div>&#43;.RE</div>
<div>&#43;.</div>
<div>&#43;.</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_forget_rate</div>
<div>&#43;If set to a value greater than 0, multipathd will check whether t=
he path failures</div>
<div>&#43;has exceeded&nbsp; the san_path_err_threshold within this many ch=
ecks i.e </div>
<div>&#43;san_path_err_forget_rate . If so we will not reinstante the path =
till</div>
<div>&#43;san_path_err_recovery_time.</div>
<div>&#43;.RS</div>
<div>&#43;.TP</div>
<div>&#43;The default is: \fBno\fR</div>
<div>&#43;.RE</div>
<div>&#43;.</div>
<div>&#43;.</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_recovery_time</div>
<div>&#43;If set to a value greater than 0, multipathd will make sure that =
when path failures</div>
<div>&#43;has exceeded the san_path_err_threshold within san_path_err_forge=
t_rate then the path</div>
<div>&#43;will be placed in failed state for san_path_err_recovery_time dur=
ation.Once san_path_err_recovery_time</div>
<div>&#43;has timeout&nbsp; we will reinstante the failed path .</div>
<div>&#43;san_path_err_recovery_time value should be in secs.</div>
<div>&#43;.RS</div>
<div>&#43;.TP</div>
<div>&#43;The default is: \fBno\fR</div>
<div>&#43;.RE</div>
<div>&#43;.</div>
<div>&#43;.</div>
<div>&#43;.TP</div>
<div> .B delay_watch_checks</div>
<div> If set to a value greater than 0, multipathd will watch paths that ha=
ve</div>
<div> recently become valid for this many checks. If they fail again while =
they are</div>
<div>@@ -1015,6 &#43;1054,12 @@ are taken from the \fIdefaults\fR or \fIdev=
ices\fR section:</div>
<div> .TP</div>
<div> .B deferred_remove</div>
<div> .TP</div>
<div>&#43;.B san_path_err_threshold</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_forget_rate</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_recovery_time</div>
<div>&#43;.TP</div>
<div> .B delay_watch_checks</div>
<div> .TP</div>
<div> .B delay_wait_checks</div>
<div>@@ -1128,6 &#43;1173,12 @@ section:</div>
<div> .TP</div>
<div> .B deferred_remove</div>
<div> .TP</div>
<div>&#43;.B san_path_err_threshold</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_forget_rate</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_recovery_time</div>
<div>&#43;.TP</div>
<div> .B delay_watch_checks</div>
<div> .TP</div>
<div> .B delay_wait_checks</div>
<div>@@ -1192,6 &#43;1243,12 @@ the values are taken from the \fIdevices\fR=
 or \fIdefaults\fR sections:</div>
<div> .TP</div>
<div> .B deferred_remove</div>
<div> .TP</div>
<div>&#43;.B san_path_err_threshold</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_forget_rate</div>
<div>&#43;.TP</div>
<div>&#43;.B san_path_err_recovery_time</div>
<div>&#43;.TP</div>
<div> .B delay_watch_checks</div>
<div> .TP</div>
<div> .B delay_wait_checks</div>
<div>diff --git a/multipathd/main.c b/multipathd/main.c</div>
<div>index adc3258..4a1a7ef 100644</div>
<div>--- a/multipathd/main.c</div>
<div>&#43;&#43;&#43; b/multipathd/main.c</div>
<div>@@ -1487,6 &#43;1487,83 @@ void repair_path(struct path * pp)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LOG_MSG(1, checker_me=
ssage(&amp;pp-&gt;checker));</div>
<div> }</div>
<div>&nbsp;</div>
<div>&#43;static int check_path_reinstate_state(struct path * pp) {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct timespec curr_time;</=
div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!((pp-&gt;mpp-&gt;san_pa=
th_err_threshold &gt; 0) &amp;&amp;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (pp-&gt;mpp-&gt;san_path_err_forge=
t_rate &gt; 0) &amp;&amp;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (pp-&gt;mpp-&gt;san_path_err_recov=
ery_time &gt;0))) {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pp-&gt;disable_reinstate=
) {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; /* If we don't know how much time has passed, automatic=
ally</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; * reinstate the path, just to be safe. Also, if t=
here are</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; * no other usable paths, reinstate the path </div=
>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; */</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (clock_gettime(CLOCK_MONOTONIC, &amp;curr_time) !=3D=
 0 ||</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;mpp-&gt;nr_active =3D=3D 0)=
 {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog=
(2, &quot;%s : reinstating path early&quot;, pp-&gt;dev);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto re=
instate_path;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if ((curr_time.tv_sec - pp-&gt;dis_reinstate_time ) &gt=
; pp-&gt;mpp-&gt;san_path_err_recovery_time) {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog=
(2,&quot;%s : reinstate the path after err recovery time&quot;, pp-&gt;dev)=
;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto re=
instate_path;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 1;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* forget errors on a workin=
g path */</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((pp-&gt;state =3D=3D PAT=
H_UP || pp-&gt;state =3D=3D PATH_GHOST) &amp;&amp;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;=
path_failures &gt; 0) {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (pp-&gt;san_path_err_forget_rate &gt; 0){</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;=
san_path_err_forget_rate--;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; } else {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* for =
every san_path_err_forget_rate number of </div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *=
 successful path checks decrement path_failures by 1</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *=
/</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;=
path_failures--;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;=
san_path_err_forget_rate =3D pp-&gt;mpp-&gt;san_path_err_forget_rate;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* If the path isn't recover=
ing from a failed state, do nothing */</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pp-&gt;state !=3D PATH_D=
OWN &amp;&amp; pp-&gt;state !=3D PATH_SHAKY &amp;&amp;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;=
state !=3D PATH_TIMEOUT)</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pp-&gt;path_failures =3D=
=3D 0)</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; pp-&gt;san_path_err_forget_rate =3D pp-&gt;mpp-&gt;san_=
path_err_forget_rate;</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;path_failures&#43;&#4=
3;;</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* if we don't know the curr=
ently time, we don't know how long to</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * delay the path, so t=
here's no point in checking if we should </div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (clock_gettime(CLOCK_MONO=
TONIC, &amp;curr_time) !=3D 0)</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* when path failures has ex=
ceeded the san_path_err_threshold</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * place the path in de=
layed state till san_path_err_recovery_time</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * so that the cutomer =
can rectify the issue within this time. After</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * the completion of sa=
n_path_err_recovery_time it should</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * automatically reinst=
ate the path </div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pp-&gt;path_failures &gt=
; pp-&gt;mpp-&gt;san_path_err_threshold) {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; condlog(2, &quot;%s : hit error threshold. Delaying pat=
h reinstatement&quot;, pp-&gt;dev);</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; pp-&gt;dis_reinstate_time =3D curr_time.tv_sec;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; pp-&gt;disable_reinstate =3D 1;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 1;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;</div>
<div>&#43;reinstate_path:</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;path_failures =3D 0;<=
/div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;disable_reinstate =3D=
 0;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pp-&gt;san_path_err_forget_r=
ate =3D 0;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&#43;}</div>
<div>&#43;</div>
<div> /*</div>
<div>&nbsp; * Returns '1' if the path has been checked, '-1' if it was blac=
klisted</div>
<div>&nbsp; * and '0' otherwise</div>
<div>@@ -1601,6 &#43;1678,12 @@ check_path (struct vectors * vecs, struct p=
ath * pp, int ticks)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((newstate =3D=3D =
PATH_UP || newstate =3D=3D PATH_GHOST) &amp;&amp;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; check_p=
ath_reinstate_state(pp)) {</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; pp-&gt;state =3D PATH_DELAYED;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; return 1;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&#43;</div>
<div>&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((newstate =3D=3D PATH_UP=
 || newstate =3D=3D PATH_GHOST) &amp;&amp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; pp-&gt;wait_checks &gt; 0) {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; if (pp-&gt;mpp-&gt;nr_active &gt; 0) {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pp-&gt;state =3D PATH_DELAYED;</div>
<div>-- </div>
<div>1.8.3.1</div>
<div>&nbsp;</div>
</span></font>
</body>
</html>

--_000_42125645d5d647c3a028bbaf6082a13fHQ1WPEXMB12corpbrocadec_--


--===============7367649010214218121==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7367649010214218121==--
