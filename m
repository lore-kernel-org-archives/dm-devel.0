From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.c libmulti ...
Date: 11 Jul 2012 23:03:37 -0000
Message-ID: <20120711230337.23611.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2012-07-11 23:03:35

Modified files:
	libmultipath   : config.c config.h dict.c hwtable.c propsel.c 
	                 structs.h 
	multipathd     : cli.c cli.h cli_handlers.c cli_handlers.h 
	                 main.c multipathd.init.redhat 
	path_priority/pp_alua: mpath_prio_alua.8 

Log message:
	Fix for bzs #644989, #799847, #833193, and #744231
	
	Backport RHEL6 config changes.
	Yet another fix to the ramfs.
	Fixup mpath_prio_alua man page
	
	Not applicable upstream

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.11&r2=1.19.2.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.17&r2=1.18.2.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.22&r2=1.17.2.23
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.38&r2=1.20.2.39
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.7&r2=1.11.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.10&r2=1.18.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.4&r2=1.5.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.3&r2=1.5.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.4&r2=1.6.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.3&r2=1.3.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.41&r2=1.69.2.42
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.4.6&r2=1.2.4.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/mpath_prio_alua.8.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.2.1

--- multipath-tools/libmultipath/config.c	2011/10/27 21:36:19	1.19.2.11
+++ multipath-tools/libmultipath/config.c	2012/07/11 23:03:34	1.19.2.12
@@ -332,6 +332,11 @@
 	hwe->no_path_retry = dhwe->no_path_retry;
 	hwe->minio = dhwe->minio;
 	hwe->checker = dhwe->checker;
+	hwe->pg_timeout = dhwe->pg_timeout;
+	hwe->flush_on_last_del = dhwe->flush_on_last_del;
+	hwe->fast_io_fail = dhwe->fast_io_fail;
+	hwe->dev_loss = dhwe->dev_loss;
+	hwe->user_friendly_names = dhwe->user_friendly_names;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
@@ -415,7 +420,7 @@
 
 	conf->dev_type = DEV_NONE;
 	conf->minio = 1000;
-	conf->max_fds = 0;
+	conf->max_fds = MAX_FDS_MAX;
 	conf->attribute_flags = 0;
 	conf->flush_on_last_del = 0;
 	conf->file_timeout = DEFAULT_FILE_TIMEOUT;
--- multipath-tools/libmultipath/config.h	2012/06/14 21:56:47	1.18.2.17
+++ multipath-tools/libmultipath/config.h	2012/07/11 23:03:34	1.18.2.18
@@ -32,6 +32,7 @@
 	int flush_on_last_del;
 	int fast_io_fail;
 	unsigned int dev_loss;
+	int user_friendly_names;
 	struct checker * checker;
 	char * bl_product;
 };
@@ -51,6 +52,7 @@
 	int pg_timeout;
 	int attribute_flags;
 	int flush_on_last_del;
+	int user_friendly_names;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2011/10/27 21:36:20	1.17.2.22
+++ multipath-tools/libmultipath/dict.c	2012/07/11 23:03:34	1.17.2.23
@@ -455,7 +455,7 @@
 }
 
 static int
-names_handler(vector strvec)
+def_names_handler(vector strvec)
 {
 	char * buff;
 
@@ -466,10 +466,12 @@
 
 	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
 	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		conf->user_friendly_names = 0;
+		conf->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
 	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
 		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		conf->user_friendly_names = 1;
+		conf->user_friendly_names = USER_FRIENDLY_NAMES_ON;
+	else
+		conf->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
 
 	FREE(buff);
 	return 0;
@@ -1072,6 +1074,32 @@
 	return 0;
 }
 
+static int
+hw_names_handler(vector strvec)
+{
+	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	char * buff;
+
+	if (!hwe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
+			(strlen(buff) == 1 && strcmp(buff, "0") == 0))
+		hwe->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
+	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+			(strlen(buff) == 1 && strcmp(buff, "1") == 0))
+		hwe->user_friendly_names = USER_FRIENDLY_NAMES_ON;
+	else
+		hwe->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * multipaths block handlers
  */
@@ -1426,6 +1454,32 @@
 	return 0;
 }
 
+static int
+mp_names_handler(vector strvec)
+{
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+	char * buff;
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
+			(strlen(buff) == 1 && strcmp(buff, "0") == 0))
+		mpe->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
+	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+			(strlen(buff) == 1 && strcmp(buff, "1") == 0))
+		mpe->user_friendly_names = USER_FRIENDLY_NAMES_ON;
+	else
+		mpe->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * config file keywords printing
  */
@@ -1613,6 +1667,19 @@
 }
 
 static int
+snprint_mp_user_friendly_names (char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
+		return 0;
+	else if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
+		return snprintf(buff, len, "no");
+	else
+		return snprintf(buff, len, "yes");
+}
+
+static int
 snprint_hw_fast_io_fail(char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -1851,6 +1918,19 @@
 }
 
 static int
+snprint_hw_user_friendly_names (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
+		return 0;
+	else if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
+		return snprintf(buff, len, "no");
+	else
+		return snprintf(buff, len, "yes");
+}
+
+static int
 snprint_def_polling_interval (char * buff, int len, void * data)
 {
 	return snprintf(buff, len, "%i", conf->checkint);
@@ -2053,10 +2133,12 @@
 {
 	switch (conf->queue_without_daemon) {
 	case QUE_NO_DAEMON_OFF:
-		return snprintf(buff, len, "no");
 	case QUE_NO_DAEMON_UNDEF:
+		return snprintf(buff, len, "no");
 	case QUE_NO_DAEMON_ON:
 		return snprintf(buff, len, "yes");
+	case QUE_NO_DAEMON_FORCE:
+		return snprintf(buff, len, "forced");
 	}
 	return 0;
 }
@@ -2103,10 +2185,10 @@
 static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
-	if (!conf->user_friendly_names)
+	if (conf->user_friendly_names == USER_FRIENDLY_NAMES_ON)
+		return snprintf(buff, len, "yes");
+	else
 		return snprintf(buff, len, "no");
-
-	return snprintf(buff, len, "yes");
 }
 
 static int
@@ -2194,7 +2276,7 @@
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
-	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
+	install_keyword("user_friendly_names", &def_names_handler, &snprint_def_user_friendly_names);
 	install_keyword("pg_prio_calc", &def_pg_prio_calc_handler, &snprint_def_pg_prio_calc);
 	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
@@ -2261,6 +2343,7 @@
 	install_keyword("pg_timeout", &hw_pg_timeout_handler, &snprint_hw_pg_timeout);
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
+	install_keyword("user_friendly_names", &hw_names_handler, &snprint_hw_user_friendly_names);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
@@ -2280,5 +2363,6 @@
 	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
 	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
 	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
+	install_keyword("user_friendly_names", &mp_names_handler, &snprint_mp_user_friendly_names);
 	install_sublevel_end();
 }
--- multipath-tools/libmultipath/hwtable.c	2012/06/14 21:56:47	1.20.2.38
+++ multipath-tools/libmultipath/hwtable.c	2012/07/11 23:03:34	1.20.2.39
@@ -716,7 +716,7 @@
 		.product       = "LUN.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_ontap /dev/%n",
-		.features      = "1 queue_if_no_path",
+		.features      = "3 queue_if_no_path pg_init_retries 50",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -724,7 +724,7 @@
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
-		.checker_name  = DIRECTIO,
+		.checker_name  = TUR,
 	},
  	/*
 	 * IBM NSeries (NETAPP) controller family
--- multipath-tools/libmultipath/propsel.c	2012/06/14 21:56:47	1.11.2.7
+++ multipath-tools/libmultipath/propsel.c	2012/07/11 23:03:34	1.11.2.8
@@ -156,6 +156,18 @@
 	return 0;
 }
 
+static int
+want_user_friendly_names(struct multipath * mp)
+{
+	if (mp->mpe &&
+	    mp->mpe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
+		return (mp->mpe->user_friendly_names == USER_FRIENDLY_NAMES_ON);
+	if (mp->hwe &&
+	    mp->hwe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
+		return (mp->hwe->user_friendly_names == USER_FRIENDLY_NAMES_ON);
+	return (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON);
+}
+
 extern int
 select_alias (struct multipath * mp)
 {
@@ -163,7 +175,7 @@
 		mp->alias = mp->mpe->alias;
 	else {
 		mp->alias = NULL;
-		if (conf->user_friendly_names)
+		if (want_user_friendly_names(mp))
 			mp->alias = get_user_friendly_alias(mp->wwid,
 					conf->bindings_file,
 					conf->bindings_read_only);
--- multipath-tools/libmultipath/structs.h	2011/10/10 03:03:17	1.18.2.10
+++ multipath-tools/libmultipath/structs.h	2012/07/11 23:03:34	1.18.2.11
@@ -82,6 +82,7 @@
 	QUE_NO_DAEMON_UNDEF,
 	QUE_NO_DAEMON_OFF,
 	QUE_NO_DAEMON_ON,
+	QUE_NO_DAEMON_FORCE,
 };
 
 enum pg_prio_calc_states {
@@ -94,6 +95,12 @@
 	LOG_CHKR_ERR_ONCE,
 };
 
+enum user_friendly_names_states {
+	USER_FRIENDLY_NAMES_UNDEF,
+	USER_FRIENDLY_NAMES_OFF,
+	USER_FRIENDLY_NAMES_ON,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
--- multipath-tools/multipathd/cli.c	2009/05/06 17:26:44	1.5.2.4
+++ multipath-tools/multipathd/cli.c	2012/07/11 23:03:34	1.5.2.5
@@ -129,6 +129,7 @@
 	r += add_key(keys, "resume", RESUME, 0);
 	r += add_key(keys, "reinstate", REINSTATE, 0);
 	r += add_key(keys, "fail", FAIL, 0);
+	r += add_key(keys, "forcequeueing", FORCEQ, 0);
 	r += add_key(keys, "disablequeueing", DISABLEQ, 0);
 	r += add_key(keys, "restorequeueing", RESTOREQ, 0);
 	r += add_key(keys, "resize", RESIZE, 0);
@@ -140,6 +141,7 @@
 	r += add_key(keys, "multipath", MAP, 1);
 	r += add_key(keys, "group", GROUP, 1);
 	r += add_key(keys, "reconfigure", RECONFIGURE, 0);
+	r += add_key(keys, "daemon", MPATH_DAEMON, 0);
 	r += add_key(keys, "status", STATUS, 0);
 	r += add_key(keys, "stats", STATS, 0);
 	r += add_key(keys, "topology", TOPOLOGY, 0);
--- multipath-tools/multipathd/cli.h	2008/09/19 03:27:08	1.5.2.3
+++ multipath-tools/multipathd/cli.h	2012/07/11 23:03:34	1.5.2.4
@@ -7,6 +7,7 @@
 	__RESUME,
 	__REINSTATE,
 	__FAIL,
+	__FORCEQ,
 	__DISABLEQ,
 	__RESTOREQ,
 	__RESIZE,
@@ -16,6 +17,7 @@
 	__MAP,
 	__GROUP,
 	__RECONFIGURE,
+	__MPATH_DAEMON,
 	__STATUS,
 	__STATS,
 	__TOPOLOGY,
@@ -32,6 +34,7 @@
 #define RESUME		(1 << __RESUME)
 #define REINSTATE	(1 << __REINSTATE)
 #define FAIL		(1 << __FAIL)
+#define FORCEQ		(1 << __FORCEQ)
 #define DISABLEQ	(1 << __DISABLEQ)
 #define RESTOREQ	(1 << __RESTOREQ)
 #define RESIZE		(1 << __RESIZE)
@@ -41,6 +44,7 @@
 #define MAP		(1 << __MAP)
 #define GROUP		(1 << __GROUP)
 #define RECONFIGURE	(1 << __RECONFIGURE)
+#define MPATH_DAEMON	(1 << __MPATH_DAEMON)
 #define STATUS		(1 << __STATUS)
 #define STATS		(1 << __STATS)
 #define TOPOLOGY	(1 << __TOPOLOGY)
--- multipath-tools/multipathd/cli_handlers.c	2008/09/19 04:00:21	1.6.2.4
+++ multipath-tools/multipathd/cli_handlers.c	2012/07/11 23:03:34	1.6.2.5
@@ -338,6 +338,25 @@
 }
 
 int
+cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
+{
+	condlog(2, "force queue_without_daemon (operator)");
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF ||
+	    conf->queue_without_daemon == QUE_NO_DAEMON_UNDEF)
+		conf->queue_without_daemon = QUE_NO_DAEMON_FORCE;
+	return 0;
+}
+
+int
+cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
+{
+	condlog(2, "restore queue_without_daemon (operator)");
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_FORCE)
+		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
+	return 0;
+}
+
+int
 cli_restore_queueing(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
--- multipath-tools/multipathd/cli_handlers.h	2008/09/19 03:27:08	1.3.2.3
+++ multipath-tools/multipathd/cli_handlers.h	2012/07/11 23:03:34	1.3.2.4
@@ -15,6 +15,8 @@
 int cli_reconfigure(void * v, char ** reply, int * len, void * data);
 int cli_disable_queueing(void * v, char ** reply, int * len, void * data);
 int cli_disable_all_queueing(void * v, char ** reply, int * len, void * data);
+int cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data);
+int cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data);
 int cli_restore_queueing(void * v, char ** reply, int * len, void * data);
 int cli_restore_all_queueing(void * v, char ** reply, int * len, void * data);
 int cli_resize(void * v, char ** reply, int * len, void * data);
--- multipath-tools/multipathd/main.c	2012/06/14 21:56:47	1.69.2.41
+++ multipath-tools/multipathd/main.c	2012/07/11 23:03:34	1.69.2.42
@@ -790,6 +790,8 @@
 	add_handler(RESUME+MAP, cli_resume);
 	add_handler(REINSTATE+PATH, cli_reinstate);
 	add_handler(FAIL+PATH, cli_fail);
+	add_handler(FORCEQ+MPATH_DAEMON, cli_force_no_daemon_q);
+	add_handler(RESTOREQ+MPATH_DAEMON, cli_restore_no_daemon_q);
 	add_handler(DISABLEQ+MAP, cli_disable_queueing);
 	add_handler(RESTOREQ+MAP, cli_restore_queueing);
 	add_handler(DISABLEQ+MAPS, cli_disable_all_queueing);
@@ -1423,7 +1425,8 @@
 		    strcmp(mnt, "/usr") == 0 || strncmp(mnt, "/usr/lib", 8) == 0 ||
 		    strcmp(mnt, "/etc") == 0 || strncmp(mnt, "/proc", 5) == 0 ||
 		    strncmp(mnt, "/dev", 4) == 0 || strncmp(mnt, "/sys", 4) == 0 ||
-		    strcmp(mnt, "/var") == 0 || strncmp(mnt, "/var/lib", 8) == 0 ||
+		    strcmp(mnt, "/var") == 0 || strcmp(mnt, "/var/lib") == 0 ||
+		    strcmp(mnt, "/var/lib/multipath") == 0 ||
 		    strncmp(mnt, "/var/run", 8) == 0 || strncmp(mnt, "/lib", 4) == 0 ||
 		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0 ||
 		    strncmp(mnt, "/ram", 4) == 0)
@@ -1529,6 +1532,9 @@
 	free_strvec(conf->binvec);
 	conf->binvec = NULL;
 
+	if (unmount_extra_devs() < 0)
+		return -1;
+
 	/*
 	 * bind the ramfs to :
 	 * /sbin : default home of multipath ...
@@ -1550,8 +1556,6 @@
 		return -1;
 	}
 	condlog(4, "bind ramfs on /tmp");
-	if (unmount_extra_devs() < 0)
-		return -1;
 	return 0;
 }
 #endif
@@ -1784,7 +1788,8 @@
 	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
 	exitting = 1;
-	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF ||
+	    conf->queue_without_daemon == QUE_NO_DAEMON_UNDEF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps(vecs, stop_waiter_thread);
--- multipath-tools/multipathd/multipathd.init.redhat	2009/08/31 21:58:52	1.2.4.6
+++ multipath-tools/multipathd/multipathd.init.redhat	2012/07/11 23:03:34	1.2.4.7
@@ -70,14 +70,16 @@
 	echo
 }
 
-stop() {
+check_root() {
         root_dev=$(awk '{ if ($1 !~ /^[ \t]*#/ && $2 == "/") { print $1; }}' /etc/mtab)
 	dm_num=`dmsetup info -c --noheadings -o minor $root_dev 2> /dev/null`
 	if [ $? -eq 0 ]; then
 		root_dm_device="dm-$dm_num"
 		[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
 	fi
+}
 
+stop() {
 	echo -n $"Stopping $prog daemon: "
 	killproc $DAEMON
 	RETVAL=$?
@@ -85,7 +87,12 @@
 	echo
 }
 
+force_queue_without_daemon() {
+	$DAEMON -k"forcequeueing daemon"
+}
+
 restart() {
+	force_queue_without_daemon
 	stop
 	start
 }	
@@ -103,6 +110,7 @@
 	start
 	;;
 stop)
+	check_root
 	stop
 	;;
 reload)
--- multipath-tools/path_priority/pp_alua/mpath_prio_alua.8	2006/08/02 21:37:23	1.2
+++ multipath-tools/path_priority/pp_alua/mpath_prio_alua.8	2012/07/11 23:03:34	1.2.2.1
@@ -122,7 +122,7 @@
 group_by_prio
 .TP
 .B  prio_callout
-"/sbin/mpath_prio_alua -d/tmp %d"
+"/sbin/mpath_prio_alua /dev/%n"
 .TP
 .B  features
 "1 queue_if_no_path"
@@ -144,12 +144,6 @@
 .RB "characters long (for " vendor ") and 16 characters long (for " product ")."
 The strings have to be padded with blanks if necessary.
 .IP \(bu
-If you are working with hotpluggable devices whose device nodes are created
-by udev you should use the %d flag in the
-.BR prio_callout " statement."
-This is because a short time elapses between the devices being available
-and udev creating the device nodes.
-.IP \(bu
 If under certain circumstances your storage subsystem temporarily reports
 .RB "failures on all paths, you should use the " features " statement showed"
 in the example.
