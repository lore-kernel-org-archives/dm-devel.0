From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 13/15] multipathd: Add delayed path reintegration
Date: Sat,  7 Mar 2015 21:31:44 -0600
Message-ID: <1425785506-20419-14-git-send-email-bmarzins@redhat.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch adds two configuration parameters, "delay_watch_checks" and
"delay_wait_checks". delay_watch_checks sets the number of checks that
a path will be watched for, after coming back from a failure. If the
path fails again within this number of checks, when it comes back up
the next time, it will not be used until it has remained up for
delay_wait_checks checks, assuming that there are other paths to the
device.  If it is the only available path, it will immediately be
reintegrated.

This helps setups were a path either won't stay up, or takes some time
to stabilize before it should be used.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c    |  1 +
 libmultipath/checkers.h    |  9 ++++++
 libmultipath/config.c      |  2 ++
 libmultipath/config.h      |  6 ++++
 libmultipath/configure.c   |  2 ++
 libmultipath/defaults.h    |  1 +
 libmultipath/dict.c        | 60 +++++++++++++++++++++++++++++++++++++++
 libmultipath/dict.h        |  1 +
 libmultipath/print.c       |  2 ++
 libmultipath/propsel.c     | 32 +++++++++++++++++++++
 libmultipath/propsel.h     |  2 ++
 libmultipath/structs.h     |  9 ++++++
 multipath.conf.annotated   | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 multipath.conf.defaults    |  2 ++
 multipath/multipath.conf.5 | 31 ++++++++++++++++++++
 multipathd/main.c          | 34 ++++++++++++++++++----
 16 files changed, 258 insertions(+), 6 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 4a4cd7c..1dd5525 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -19,6 +19,7 @@ char *checker_state_names[] = {
       "pending",
       "timeout",
       "removed",
+      "delayed",
 };
 
 static LIST_HEAD(checkers);
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index e62b52f..a935b3f 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -54,6 +54,14 @@
  * PATH REMOVED:
  * - Use: All checkers
  * - Description: Device has been removed from the system
+ *
+ * PATH_DELAYED:
+ * - Use: None of the checkers (returned if the path is being delayed before
+ *   reintegration.
+ * - Description: If a path fails after being up for less than
+ *   delay_watch_checks checks, when it comes back up again, it will not
+ *   be marked as up until it has been up for delay_wait_checks checks.
+ *   During this time, it is marked as "delayed"
  */
 enum path_check_state {
 	PATH_WILD,
@@ -65,6 +73,7 @@ enum path_check_state {
 	PATH_PENDING,
 	PATH_TIMEOUT,
 	PATH_REMOVED,
+	PATH_DELAYED,
 	PATH_MAX_STATE
 };
 
diff --git a/libmultipath/config.c b/libmultipath/config.c
index c36e9db..e88bae0 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -344,6 +344,8 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(retain_hwhandler);
 	merge_num(detect_prio);
 	merge_num(deferred_remove);
+	merge_num(delay_watch_checks);
+	merge_num(delay_wait_checks);
 
 	/*
 	 * Make sure features is consistent with
diff --git a/libmultipath/config.h b/libmultipath/config.h
index cb3be62..9b1d9a1 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -60,6 +60,8 @@ struct hwentry {
 	int retain_hwhandler;
 	int detect_prio;
 	int deferred_remove;
+	int delay_watch_checks;
+	int delay_wait_checks;
 	char * bl_product;
 };
 
@@ -84,6 +86,8 @@ struct mpentry {
 	int attribute_flags;
 	int user_friendly_names;
 	int deferred_remove;
+	int delay_watch_checks;
+	int delay_wait_checks;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -128,6 +132,8 @@ struct config {
 	int force_sync;
 	int deferred_remove;
 	int processed_main_config;
+	int delay_watch_checks;
+	int delay_wait_checks;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a22d16a..6c96633 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -290,6 +290,8 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_reservation_key(mpp);
 	select_retain_hwhandler(mpp);
 	select_deferred_remove(mpp);
+	select_delay_watch_checks(mpp);
+	select_delay_wait_checks(mpp);
 
 	sysfs_set_scsi_tmo(mpp);
 	/*
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index a7f1c11..23a0871 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -17,6 +17,7 @@
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
 #define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
 #define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
+#define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7350231..4a79445 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -979,6 +979,58 @@ declare_def_snprint(reservation_key, print_reservation_key)
 declare_mp_handler(reservation_key, set_reservation_key)
 declare_mp_snprint(reservation_key, print_reservation_key)
 
+static int
+set_delay_checks(vector strvec, void *ptr)
+{
+	int *int_ptr = (int *)ptr;
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (!strcmp(buff, "no") || !strcmp(buff, "0"))
+		*int_ptr = DELAY_CHECKS_OFF;
+	else if ((*int_ptr = atoi(buff)) < 1)
+		*int_ptr = DELAY_CHECKS_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
+int
+print_delay_checks(char * buff, int len, void *ptr)
+{
+	int *int_ptr = (int *)ptr;
+
+	switch(*int_ptr) {
+	case DELAY_CHECKS_UNDEF:
+		return 0;
+	case DELAY_CHECKS_OFF:
+		return snprintf(buff, len, "\"off\"");
+	default:
+		return snprintf(buff, len, "%i", *int_ptr);
+	}
+}
+
+declare_def_handler(delay_watch_checks, set_delay_checks)
+declare_def_snprint(delay_watch_checks, print_delay_checks)
+declare_ovr_handler(delay_watch_checks, set_delay_checks)
+declare_ovr_snprint(delay_watch_checks, print_delay_checks)
+declare_hw_handler(delay_watch_checks, set_delay_checks)
+declare_hw_snprint(delay_watch_checks, print_delay_checks)
+declare_mp_handler(delay_watch_checks, set_delay_checks)
+declare_mp_snprint(delay_watch_checks, print_delay_checks)
+
+declare_def_handler(delay_wait_checks, set_delay_checks)
+declare_def_snprint(delay_wait_checks, print_delay_checks)
+declare_ovr_handler(delay_wait_checks, set_delay_checks)
+declare_ovr_snprint(delay_wait_checks, print_delay_checks)
+declare_hw_handler(delay_wait_checks, set_delay_checks)
+declare_hw_snprint(delay_wait_checks, print_delay_checks)
+declare_mp_handler(delay_wait_checks, set_delay_checks)
+declare_mp_snprint(delay_wait_checks, print_delay_checks)
+
 /*
  * blacklist block handlers
  */
@@ -1277,6 +1329,8 @@ init_keywords(void)
 	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
 	install_keyword("partition_delimiter", &def_partition_delim_handler, &snprint_def_partition_delim);
 	install_keyword("config_dir", &def_config_dir_handler, &snprint_def_config_dir);
+	install_keyword("delay_watch_checks", &def_delay_watch_checks_handler, &snprint_def_delay_watch_checks);
+	install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &snprint_def_delay_wait_checks);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
@@ -1345,6 +1399,8 @@ init_keywords(void)
 	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
+	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
+	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
 	install_sublevel_end();
 
 	install_keyword_root("overrides", &overrides_handler);
@@ -1370,6 +1426,8 @@ init_keywords(void)
 	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
+	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
+	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
@@ -1394,5 +1452,7 @@ init_keywords(void)
 	install_keyword("reservation_key", &mp_reservation_key_handler, &snprint_mp_reservation_key);
 	install_keyword("user_friendly_names", &mp_user_friendly_names_handler, &snprint_mp_user_friendly_names);
 	install_keyword("deferred_remove", &mp_deferred_remove_handler, &snprint_mp_deferred_remove);
+	install_keyword("delay_watch_checks", &mp_delay_watch_checks_handler, &snprint_mp_delay_watch_checks);
+	install_keyword("delay_wait_checks", &mp_delay_wait_checks_handler, &snprint_mp_delay_wait_checks);
 	install_sublevel_end();
 }
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 84b6180..4fdd576 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -14,5 +14,6 @@ int print_no_path_retry(char * buff, int len, void *ptr);
 int print_fast_io_fail(char * buff, int len, void *ptr);
 int print_dev_loss(char * buff, int len, void *ptr);
 int print_reservation_key(char * buff, int len, void * ptr);
+int print_delay_checks(char * buff, int len, void *ptr);
 
 #endif /* _DICT_H */
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 9762f1c..130a9af 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -340,6 +340,8 @@ snprint_chk_state (char * buff, size_t len, struct path * pp)
 		return snprintf(buff, len, "i/o pending");
 	case PATH_TIMEOUT:
 		return snprintf(buff, len, "i/o timeout");
+	case PATH_DELAYED:
+		return snprintf(buff, len, "delayed");
 	default:
 		return snprintf(buff, len, "undef");
 	}
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f5c158b..46f8f63 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -616,3 +616,35 @@ out:
 		origin);
 	return 0;
 }
+
+extern int
+select_delay_watch_checks(struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(delay_watch_checks);
+	mp_set_ovr(delay_watch_checks);
+	mp_set_hwe(delay_watch_checks);
+	mp_set_conf(delay_watch_checks);
+	mp_set_default(delay_watch_checks, DEFAULT_DELAY_CHECKS);
+out:
+	print_delay_checks(buff, 12, &mp->delay_watch_checks);
+	condlog(3, "%s: delay_watch_checks = %s %s", mp->alias, buff, origin);
+	return 0;
+}
+
+extern int
+select_delay_wait_checks(struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(delay_wait_checks);
+	mp_set_ovr(delay_wait_checks);
+	mp_set_hwe(delay_wait_checks);
+	mp_set_conf(delay_wait_checks);
+	mp_set_default(delay_wait_checks, DEFAULT_DELAY_CHECKS);
+out:
+	print_delay_checks(buff, 12, &mp->delay_wait_checks);
+	condlog(3, "%s: delay_wait_checks = %s %s", mp->alias, buff, origin);
+	return 0;
+}
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index ffb58a5..f9598e7 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -20,3 +20,5 @@ int select_reservation_key(struct multipath *mp);
 int select_retain_hwhandler (struct multipath * mp);
 int select_detect_prio(struct path * pp);
 int select_deferred_remove(struct multipath *mp);
+int select_delay_watch_checks (struct multipath * mp);
+int select_delay_wait_checks (struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b6cfff8..c02c76d 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -140,6 +140,11 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
+enum delay_checks_states {
+	DELAY_CHECKS_OFF = -1,
+	DELAY_CHECKS_UNDEF = 0,
+};
+
 struct sg_id {
 	int host_no;
 	int channel;
@@ -186,6 +191,8 @@ struct path {
 	int priority;
 	int pgindex;
 	int detect_prio;
+	int watch_checks;
+	int wait_checks;
 	char * uid_attribute;
 	char * getuid;
 	struct prio prio;
@@ -221,6 +228,8 @@ struct multipath {
 	int fast_io_fail;
 	int retain_hwhandler;
 	int deferred_remove;
+	int delay_watch_checks;
+	int delay_wait_checks;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 2b148ac..0be034d 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -314,6 +314,30 @@
 #	#           files, just as if it was in /etc/multipath.conf
 #	# values  : "" or a fully qualified pathname
 #	# default : "/etc/multipath/conf.d"
+#
+#	#
+#	# name    : delay_watch_checks
+#	# scope   : multipathd
+#	# desc    : If set to a value greater than 0, multipathd will watch
+#	#           paths that have recently become valid for this many
+#	#           checks.  If they fail again while they are being watched,
+#	#           when they next become valid, they will not be used until
+#	#           they have stayed up for delay_wait_checks checks.
+#	# values  : no|<n> > 0
+#	# default : no
+#	delay_watch_checks 12
+#
+#	#
+#	# name    : delay_wait_checks
+#	# scope   : multipathd
+#	# desc    : If set to a value greater than 0, when a device that has
+#	#           recently come back online fails again within
+#	#           delay_watch_checks checks, the next time it comes back
+#	#           online, it will marked and delayed, and not used until
+#	#           it has passed delay_wait_checks checks.
+#	# values  : no|<n> > 0
+#	# default : no
+#	delay_wait_checks 12
 #}
 #	
 ##
@@ -482,6 +506,28 @@
 #		# default : determined by the process
 #		gid 0
 #
+#		#
+#		# name    : delay_watch_checks
+#		# scope   : multipathd
+#		# desc    : If set to a value greater than 0, multipathd will
+#		#           watch paths that have recently become valid for
+#		#           this many checks.  If they fail again while they
+#		#           are being watched, when they next become valid,
+#		#           they will not be used until they have stayed up for
+#		#           delay_wait_checks checks.
+#		# values  : no|<n> > 0
+#		delay_watch_checks 12
+#
+#		#
+#		# name    : delay_wait_checks
+#		# scope   : multipathd
+#		# desc    : If set to a value greater than 0, when a device
+#		#           that has recently come back online fails again
+#		#           within delay_watch_checks checks, the next time it
+#		#           comes online, it will marked and delayed, and not
+#		#           used until it has passed delay_wait_checks checks.
+#		# values  : no|<n> > 0
+#		delay_wait_checks 12
 #	}
 #	multipath {
 #		wwid	1DEC_____321816758474
@@ -653,6 +699,30 @@
 #		#           before removing it from the system.
 #		# values  : n > 0
 #		dev_loss_tmo 600
+#
+#		#
+#		# name    : delay_watch_checks
+#		# scope   : multipathd
+#		# desc    : If set to a value greater than 0, multipathd will
+#		#           watch paths that have recently become valid for
+#		#           this many checks.  If they fail again while they
+#		#           are being watched, when they next become valid,
+#		#           they will not be used until they have stayed up for
+#		#           delay_wait_checks checks.
+#		# values  : no|<n> > 0
+#		delay_watch_checks 12
+#
+#		#
+#		# name    : delay_wait_checks
+#		# scope   : multipathd
+#		# desc    : If set to a value greater than 0, when a device
+#		#           that has recently come back online fails again
+#		#           within delay_watch_checks checks, the next time it
+#		#           comes online, it will marked and delayed, and not
+#		#           used until it has passed delay_wait_checks checks.
+#		# values  : no|<n> > 0
+#		delay_wait_checks 12
+#
 #	}
 #	device {
 #		vendor			"COMPAQ  "
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index 9244f71..5f43c57 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -27,6 +27,8 @@
 #	retain_attached_hw_handler no
 #	detect_prio no
 #	config_dir "/etc/multipath/conf.d"
+#	delay_watch_checks no
+#	delay_wait_checks no
 #}
 #blacklist {
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 4eb238d..3fe56bc 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -439,6 +439,25 @@ alphabetically for file ending in ".conf" and it will read configuration
 information from them, just as if it was in /etc/multipath.conf.  config_dir
 must either be "" or a fully qualified directory name. Default is
 .I "/etc/multipath/conf.d"
+.TP
+.B delay_watch_checks
+If set to a value greater than 0, multipathd will watch paths that have
+recently become valid for this many checks.  If they fail again while they are
+being watched, when they next become valid, they will not be used until they
+have stayed up for
+.I delay_wait_checks
+checks. Default is
+.I no
+.TP
+.B delay_wait_checks
+If set to a value greater than 0, when a device that has recently come back
+online fails again within
+.I delay_watch_checks
+checks, the next time it comes back online, it will marked and delayed, and not
+used until it has passed
+.I delay_wait_checks
+checks. Default is
+.I no
 .
 .SH "blacklist section"
 The
@@ -559,6 +578,10 @@ section:
 .B reservation_key
 .TP
 .B deferred_remove
+.TP
+.B delay_watch_checks
+.TP
+.B delay_wait_checks
 .RE
 .PD
 .LP
@@ -651,6 +674,10 @@ section:
 .B detect_prio
 .TP
 .B deferred_remove
+.TP
+.B delay_watch_checks
+.TP
+.B delay_wait_checks
 .RE
 .PD
 .LP
@@ -706,6 +733,10 @@ sections:
 .B detect_prio
 .TP
 .B deferred_remove
+.TP
+.B delay_watch_checks
+.TP
+.B delay_wait_checks
 .RE
 .PD
 .LP
diff --git a/multipathd/main.c b/multipathd/main.c
index 7429f66..aac8a19 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -192,7 +192,8 @@ sync_map_state(struct multipath *mpp)
 	vector_foreach_slot (mpp->pg, pgp, i){
 		vector_foreach_slot (pgp->paths, pp, j){
 			if (pp->state == PATH_UNCHECKED || 
-			    pp->state == PATH_WILD)
+			    pp->state == PATH_WILD ||
+			    pp->state == PATH_DELAYED)
 				continue;
 			if ((pp->dmstate == PSTATE_FAILED ||
 			     pp->dmstate == PSTATE_UNDEF) &&
@@ -1184,6 +1185,16 @@ check_path (struct vectors * vecs, struct path * pp)
 	if (!pp->mpp)
 		return 0;
 
+	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
+	     pp->wait_checks > 0) {
+		if (pp->mpp && pp->mpp->nr_active > 0) {
+			pp->state = PATH_DELAYED;
+			pp->wait_checks--;
+			return 1;
+		} else
+			pp->wait_checks = 0;
+	}
+
 	pp->chkrstate = newstate;
 	if (newstate != pp->state) {
 		int oldstate = pp->state;
@@ -1203,9 +1214,14 @@ check_path (struct vectors * vecs, struct path * pp)
 			 * proactively fail path in the DM
 			 */
 			if (oldstate == PATH_UP ||
-			    oldstate == PATH_GHOST)
+			    oldstate == PATH_GHOST) {
 				fail_path(pp, 1);
-			else
+				if (pp->mpp->delay_wait_checks > 0 &&
+				    pp->watch_checks > 0) {
+					pp->wait_checks = pp->mpp->delay_wait_checks;
+					pp->watch_checks = 0;
+				}
+			}else
 				fail_path(pp, 0);
 
 			/*
@@ -1232,11 +1248,15 @@ check_path (struct vectors * vecs, struct path * pp)
 		 * reinstate this path
 		 */
 		if (oldstate != PATH_UP &&
-		    oldstate != PATH_GHOST)
+		    oldstate != PATH_GHOST) {
+			if (pp->mpp->delay_watch_checks > 0)
+				pp->watch_checks = pp->mpp->delay_watch_checks;
 			reinstate_path(pp, 1);
-		else
+		} else {
+			if (pp->watch_checks > 0)
+				pp->watch_checks--;
 			reinstate_path(pp, 0);
-
+		}
 		new_path_up = 1;
 
 		if (oldchkrstate != PATH_UP && oldchkrstate != PATH_GHOST)
@@ -1269,6 +1289,8 @@ check_path (struct vectors * vecs, struct path * pp)
 				condlog(4, "%s: delay next check %is",
 					pp->dev_t, pp->checkint);
 			}
+			if (pp->watch_checks > 0)
+				pp->watch_checks--;
 			pp->tick = pp->checkint;
 		}
 	}
-- 
1.8.3.1
