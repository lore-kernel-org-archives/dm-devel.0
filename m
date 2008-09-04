From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 4 Sep 2008 20:09:50 -0000
Message-ID: <20080904200950.13373.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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
Changes by:	bmarzins@sourceware.org	2008-09-04 20:09:48

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.synthetic 
	libmultipath   : config.c config.h dict.c propsel.c propsel.h 
	                 structs.h structs_vec.c 
	multipathd     : cli.c cli.h cli_handlers.c cli_handlers.h 
	                 main.c 

Log message:
	Fix fox bz #238421.  You can now set flush_on_last_del in /etc/multipath.conf,
	which turns off queue_if_no_path when the last path is deleted from a multipath map.  You can also manually disable and restore queueing with the multipathd
	interactive disablequeueing and restorequeueing commands.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.7&r2=1.18.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.4&r2=1.11.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.6&r2=1.19.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.5&r2=1.18.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.6&r2=1.17.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.1&r2=1.11.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.4&r2=1.18.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs_vec.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.1&r2=1.6.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.1&r2=1.3.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.9&r2=1.69.2.10

--- multipath-tools/multipath.conf.annotated	2008/08/29 21:30:34	1.18.2.7
+++ multipath-tools/multipath.conf.annotated	2008/09/04 20:09:48	1.18.2.8
@@ -121,6 +121,15 @@
 #	#
 #	#no_path_retry  queue
 #
+#	# name    : flush_on_last_del
+#	# scope   : multipathd
+#	# desc    : If set to "yes", multipathd will disable queueing when the
+#	#           last path to a device has been deleted.
+#	# values  : yes|no
+#	# default : no
+#	#
+#	flush_on_last_del       yes
+#
 #	#
 #	# name    : user_friendly_names
 #	# scope   : multipath
@@ -284,6 +293,16 @@
 #		#no_path_retry  queue
 #
 #		#
+#		# name    : flush_on_last_del
+#		# scope   : multipathd
+#		# desc    : If set to "yes", multipathd will disable queueing
+#		#           when the last path to a device has been deleted.
+#		# values  : yes|no
+#		# default : no
+#		#
+#		flush_on_last_del       yes
+#
+#		#
 #		# name    : rr_min_io
 #		# scope   : multipath
 #		# desc    : the number of IO to route to a path before switching
@@ -422,6 +441,16 @@
 #		rr_min_io	100
 #
 #		#
+#		# name    : flush_on_last_del
+#		# scope   : multipathd
+#		# desc    : If set to "yes", multipathd will disable queueing
+#		#           when the last path to a device has been deleted.
+#		# values  : yes|no
+#		# default : no
+#		#
+#              flush_on_last_del       yes
+#
+#		#
 #		# name    : product_blacklist
 #		# scope   : multipath & multipathd
 #		# desc    : product strings to blacklist for this vendor
--- multipath-tools/multipath.conf.synthetic	2008/08/25 20:59:05	1.11.2.4
+++ multipath-tools/multipath.conf.synthetic	2008/09/04 20:09:48	1.11.2.5
@@ -16,6 +16,7 @@
 #	failback		immediate
 #	no_path_retry		fail
 #	user_friendly_names	no
+#	flush_on_last_del	no
 #	mode			0666
 #	uid			0
 #	gid			0
--- multipath-tools/libmultipath/config.c	2008/08/25 20:59:06	1.19.2.6
+++ multipath-tools/libmultipath/config.c	2008/09/04 20:09:48	1.19.2.7
@@ -413,6 +413,7 @@
 	conf->minio = 1000;
 	conf->max_fds = 0;
 	conf->attribute_flags = 0;
+	conf->flush_on_last_del = 0;
 
 	/*
 	 * read the config file
--- multipath-tools/libmultipath/config.h	2008/08/25 20:59:06	1.18.2.5
+++ multipath-tools/libmultipath/config.h	2008/09/04 20:09:48	1.18.2.6
@@ -29,6 +29,7 @@
 	int no_path_retry;
 	int minio;
 	int pg_timeout;
+	int flush_on_last_del;
 	struct checker * checker;
 	char * bl_product;
 };
@@ -46,6 +47,7 @@
 	int minio;
 	int pg_timeout;
 	int attribute_flags;
+	int flush_on_last_del;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -72,6 +74,7 @@
 	int max_fds;
 	int force_reload;
 	int attribute_flags;
+	int flush_on_last_del;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2008/08/29 21:30:34	1.17.2.6
+++ multipath-tools/libmultipath/dict.c	2008/09/04 20:09:48	1.17.2.7
@@ -297,6 +297,26 @@
 }
 
 static int
+def_flush_on_last_del_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (!strncmp(buff, "no", 2) || !strncmp(buff, "0", 1))
+		conf->flush_on_last_del = FLUSH_DISABLED;
+	else if (!strncmp(buff, "yes", 2) || !strncmp(buff, "1", 1))
+		conf->flush_on_last_del = FLUSH_ENABLED;
+	else
+		conf->flush_on_last_del = FLUSH_UNDEF;
+
+	free(buff);
+	return 0;
+}
+
+static int
 def_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -791,6 +811,30 @@
 }
 
 static int
+hw_flush_on_last_del_handler(vector strvec)
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
+	if (!strncmp(buff, "no", 2) || !strncmp(buff, "0", 1))
+		hwe->flush_on_last_del = FLUSH_DISABLED;
+	else if (!strncmp(buff, "yes", 2) || !strncmp(buff, "1", 1))
+		hwe->flush_on_last_del = FLUSH_ENABLED;
+	else
+		hwe->flush_on_last_del = FLUSH_UNDEF;
+
+	free(buff);
+	return 0;
+}
+
+static int
 hw_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -1013,6 +1057,30 @@
 }
 
 static int
+mp_flush_on_last_del_handler(vector strvec)
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
+	if (!strncmp(buff, "no", 2) || !strncmp(buff, "0", 1))
+		mpe->flush_on_last_del = FLUSH_DISABLED;
+	else if (!strncmp(buff, "yes", 2) || !strncmp(buff, "1", 1))
+		mpe->flush_on_last_del = FLUSH_ENABLED;
+	else
+		mpe->flush_on_last_del = FLUSH_UNDEF;
+
+	free(buff);
+	return 0;
+}
+
+static int
 mp_mode_handler(vector strvec)
 {
 	mode_t mode;
@@ -1272,6 +1340,20 @@
 }
 
 static int
+snprint_mp_flush_on_last_del (char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	switch (mpe->flush_on_last_del) {
+	case FLUSH_DISABLED:
+		return snprintf(buff, len, "no");
+	case FLUSH_ENABLED:
+		return snprintf(buff, len, "yes");
+	}
+	return 0;
+}
+
+static int
 snprint_mp_pg_timeout (char * buff, int len, void * data)
 {
 	struct mpentry * mpe = (struct mpentry *)data;
@@ -1489,6 +1571,20 @@
 }
 
 static int
+snprint_hw_flush_on_last_del (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	switch (hwe->flush_on_last_del) {
+	case FLUSH_DISABLED:
+		return snprintf(buff, len, "no");
+	case FLUSH_ENABLED:
+		return snprintf(buff, len, "yes");
+	}
+	return 0;
+}
+
+static int
 snprint_hw_pg_timeout (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -1716,6 +1812,18 @@
 }
 
 static int
+snprint_def_flush_on_last_del (char * buff, int len, void * data)
+{
+	switch (conf->flush_on_last_del) {
+	case FLUSH_DISABLED:
+		return snprintf(buff, len, "no");
+	case FLUSH_ENABLED:
+		return snprintf(buff, len, "yes");
+	}
+	return 0;
+}
+
+static int
 snprint_def_pg_timeout (char * buff, int len, void * data)
 {
 	if (conf->pg_timeout == DEFAULT_PGTIMEOUT)
@@ -1798,6 +1906,7 @@
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
 	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
+	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
@@ -1856,6 +1965,7 @@
 	install_keyword("rr_weight", &hw_weight_handler, &snprint_hw_rr_weight);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
 	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_rr_min_io);
+	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_keyword("pg_timeout", &hw_pg_timeout_handler, &snprint_hw_pg_timeout);
 	install_sublevel_end();
 
@@ -1870,6 +1980,7 @@
 	install_keyword("rr_weight", &mp_weight_handler, &snprint_mp_rr_weight);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_rr_min_io);
+	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
 	install_keyword("pg_timeout", &mp_pg_timeout_handler, &snprint_mp_pg_timeout);
 	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
 	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
--- multipath-tools/libmultipath/propsel.c	2008/08/25 20:59:06	1.11.2.1
+++ multipath-tools/libmultipath/propsel.c	2008/09/04 20:09:48	1.11.2.2
@@ -279,6 +279,10 @@
 extern int
 select_no_path_retry(struct multipath *mp)
 {
+	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
+		condlog(0, "flush_on_last_del in progress");
+		mp->no_path_retry = NO_PATH_RETRY_FAIL;
+	}
 	if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
 		mp->no_path_retry = mp->mpe->no_path_retry;
 		condlog(3, "%s: no_path_retry = %i (multipath setting)",
@@ -385,6 +389,34 @@
 }
 
 extern int
+select_flush_on_last_del(struct multipath *mp)
+{
+	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
+		return 0;
+	if (mp->mpe && mp->mpe->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = mp->mpe->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (multipath setting)",
+				mp->flush_on_last_del);
+		return 0;
+	}
+	if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = mp->hwe->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (controler setting)",
+				mp->flush_on_last_del);
+		return 0;
+	}
+	if (conf->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = conf->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (config file default)",
+				mp->flush_on_last_del);
+		return 0;
+	}
+	mp->flush_on_last_del = FLUSH_UNDEF;
+	condlog(3, "flush_on_last_del = DISABLED (internal default)");
+	return 0;
+}
+
+extern int
 select_pg_timeout(struct multipath *mp)
 {
 	if (mp->mpe && mp->mpe->pg_timeout != PGTIMEOUT_UNDEF) {
--- multipath-tools/libmultipath/propsel.h	2008/08/25 20:59:06	1.5.2.1
+++ multipath-tools/libmultipath/propsel.h	2008/09/04 20:09:48	1.5.2.2
@@ -14,3 +14,4 @@
 int select_mode(struct multipath *mp);
 int select_uid(struct multipath *mp);
 int select_gid(struct multipath *mp);
+int select_flush_on_last_del(struct multipath *mp);
--- multipath-tools/libmultipath/structs.h	2008/08/29 21:30:34	1.18.2.4
+++ multipath-tools/libmultipath/structs.h	2008/09/04 20:09:48	1.18.2.5
@@ -71,6 +71,13 @@
 	ATTR_MODE,
 };
 
+enum flush_states {
+	FLUSH_UNDEF,
+	FLUSH_DISABLED,
+	FLUSH_ENABLED,
+	FLUSH_IN_PROGRESS,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
@@ -145,6 +152,7 @@
 	int minio;
 	int pg_timeout;
 	int attribute_flags;
+	int flush_on_last_del;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/structs_vec.c	2008/08/25 20:59:06	1.1.2.2
+++ multipath-tools/libmultipath/structs_vec.c	2008/09/04 20:09:48	1.1.2.3
@@ -290,6 +290,7 @@
 	select_pgfailback(mpp);
 	set_no_path_retry(mpp);
 	select_pg_timeout(mpp);
+	select_flush_on_last_del(mpp);
 
 	return 0;
 out:
--- multipath-tools/multipathd/cli.c	2007/01/10 20:08:09	1.5.2.1
+++ multipath-tools/multipathd/cli.c	2008/09/04 20:09:48	1.5.2.2
@@ -129,6 +129,8 @@
 	r += add_key(keys, "resume", RESUME, 0);
 	r += add_key(keys, "reinstate", REINSTATE, 0);
 	r += add_key(keys, "fail", FAIL, 0);
+	r += add_key(keys, "disablequeueing", DISABLEQ, 0);
+	r += add_key(keys, "restorequeueing", RESTOREQ, 0);
 	r += add_key(keys, "paths", PATHS, 0);
 	r += add_key(keys, "maps", MAPS, 0);
 	r += add_key(keys, "multipaths", MAPS, 0);
--- multipath-tools/multipathd/cli.h	2007/01/10 20:08:09	1.5.2.1
+++ multipath-tools/multipathd/cli.h	2008/09/04 20:09:48	1.5.2.2
@@ -7,6 +7,8 @@
 	__RESUME,
 	__REINSTATE,
 	__FAIL,
+	__DISABLEQ,
+	__RESTOREQ,
 	__PATHS,
 	__MAPS,
 	__PATH,
@@ -29,6 +31,8 @@
 #define RESUME		(1 << __RESUME)
 #define REINSTATE	(1 << __REINSTATE)
 #define FAIL		(1 << __FAIL)
+#define DISABLEQ	(1 << __DISABLEQ)
+#define RESTOREQ	(1 << __RESTOREQ)
 #define PATHS		(1 << __PATHS)
 #define MAPS		(1 << __MAPS)
 #define PATH		(1 << __PATH)
--- multipath-tools/multipathd/cli_handlers.c	2007/01/10 20:08:09	1.6.2.1
+++ multipath-tools/multipathd/cli_handlers.c	2008/09/04 20:09:48	1.6.2.2
@@ -336,6 +336,48 @@
 }
 
 int
+cli_restore_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * mapname = get_keyparam(v, MAP);
+	struct multipath *mpp;
+	int minor;
+
+	if (sscanf(mapname, "dm-%d", &minor) == 1)
+		mpp = find_mp_by_minor(vecs->mpvec, minor);
+	else
+		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+
+	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+			mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
+		dm_queue_if_no_path(mpp->alias, 1);
+		if (mpp->nr_active > 0)
+			mpp->retry_tick = 0;
+		else
+			mpp->retry_tick = mpp->no_path_retry * conf->checkint;
+	}
+	return 0;
+}
+
+int
+cli_disable_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * mapname = get_keyparam(v, MAP);
+	struct multipath *mpp;
+	int minor;
+
+	if (sscanf(mapname, "dm-%d", &minor) == 1)
+		mpp = find_mp_by_minor(vecs->mpvec, minor);
+	else
+		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+
+	mpp->retry_tick = 0;
+	dm_queue_if_no_path(mpp->alias, 0);
+	return 0;
+}
+
+int
 cli_switch_group(void * v, char ** reply, int * len, void * data)
 {
 	char * mapname = get_keyparam(v, MAP);
--- multipath-tools/multipathd/cli_handlers.h	2007/01/10 20:08:09	1.3.2.1
+++ multipath-tools/multipathd/cli_handlers.h	2008/09/04 20:09:48	1.3.2.2
@@ -13,6 +13,8 @@
 int cli_del_map (void * v, char ** reply, int * len, void * data);
 int cli_switch_group(void * v, char ** reply, int * len, void * data);
 int cli_reconfigure(void * v, char ** reply, int * len, void * data);
+int cli_disable_queueing(void * v, char ** reply, int * len, void * data);
+int cli_restore_queueing(void * v, char ** reply, int * len, void * data);
 int cli_suspend(void * v, char ** reply, int * len, void * data);
 int cli_resume(void * v, char ** reply, int * len, void * data);
 int cli_reinstate(void * v, char ** reply, int * len, void * data);
--- multipath-tools/multipathd/main.c	2008/08/29 21:30:34	1.69.2.9
+++ multipath-tools/multipathd/main.c	2008/09/04 20:09:48	1.69.2.10
@@ -406,6 +406,7 @@
 			return 1; /* leave path added to pathvec */
 
 		verify_paths(mpp, vecs, NULL);
+		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 	}
 	else {
@@ -511,6 +512,13 @@
 				 * flush_map will fail if the device is open
 				 */
 				strncpy(alias, mpp->alias, WWID_SIZE);
+				if (mpp->flush_on_last_del == FLUSH_ENABLED) {
+					condlog(2, "%s Last path deleted, disabling queueing", mpp->alias);
+					mpp->retry_tick = 0;
+					mpp->no_path_retry = NO_PATH_RETRY_FAIL;
+					mpp->flush_on_last_del == FLUSH_IN_PROGRESS;
+					dm_queue_if_no_path(mpp->alias, 0);
+				}
 				if (flush_map(mpp, vecs))
 					rm_path = 0;
 				else
@@ -563,6 +571,13 @@
 			 * flush_map will fail if the device is open
 			 */
 			strncpy(alias, mpp->alias, WWID_SIZE);
+			if (mpp->flush_on_last_del == FLUSH_ENABLED) {
+				condlog(2, "%s Last path deleted, disabling queueing", mpp->alias);
+				mpp->retry_tick = 0;
+				mpp->no_path_retry = NO_PATH_RETRY_FAIL;
+				mpp->flush_on_last_del == FLUSH_IN_PROGRESS;
+				dm_queue_if_no_path(mpp->alias, 0);
+			}
 			if (flush_map(mpp, vecs))
 				rm_path = 0;
 			else
@@ -746,6 +761,8 @@
 	add_handler(RESUME+MAP, cli_resume);
 	add_handler(REINSTATE+PATH, cli_reinstate);
 	add_handler(FAIL+PATH, cli_fail);
+	add_handler(DISABLEQ+MAP, cli_disable_queueing);
+	add_handler(RESTOREQ+MAP, cli_restore_queueing);
 
 	uxsock_listen(&uxsock_trigger, ap);
 
