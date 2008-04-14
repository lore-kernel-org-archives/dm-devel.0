From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 14 Apr 2008 22:40:11 -0000
Message-ID: <20080414224011.19654.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2008-04-14 22:40:09

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.synthetic 
	libmultipath   : config.c config.h dict.c propsel.c propsel.h 
	                 structs.h 
	multipathd     : cli.c cli.h cli_handlers.c cli_handlers.h 
	                 main.c 

Log message:
	Fix for bz #430494.  I added another multipath.conf parameter,
	"flush_on_last_del" that, if set, turns off queueing when the last path for a
	mutipath device is deleted.  It is also possible to disable and restore queueing
	via multipathd -k commands.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.5&r2=1.16.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.10.2.2&r2=1.10.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.3&r2=1.17.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.3&r2=1.17.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.4&r2=1.16.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.9.2.2&r2=1.9.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4.2.2&r2=1.4.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.7&r2=1.17.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.3&r2=1.66.2.4

--- multipath-tools/multipath.conf.annotated	2008/04/14 22:32:03	1.16.2.5
+++ multipath-tools/multipath.conf.annotated	2008/04/14 22:40:08	1.16.2.6
@@ -140,6 +140,16 @@
 #	no_path_retry  queue
 #
 #	#
+#	# name    : flush_on_last_del
+#	# scope   : multipathd
+#	# desc    : If set to "yes", multipathd will disable queueing when the
+#	#           last path to a device has been deleted.
+#	# values  : yes|no
+#	# default : no
+#	#
+#	flush_on_last_del	yes
+#
+#	#
 #	# name    : user_friendly_names
 #	# scope   : multipath
 #	# desc    : If set to "yes", using the bindings file, by default
@@ -282,7 +292,17 @@
 #		# values  : queue|fail|n (>0)
 #		#
 #		no_path_retry  queue
+#
 #		#
+#		# name    : flush_on_last_del
+#		# scope   : multipathd
+#		# desc    : If set to "yes", multipathd will disable queueing
+#		#           when the last path to a device has been deleted.
+#		# values  : yes|no
+#		# default : no
+#		#
+#		flush_on_last_del	yes
+#
 #		# name    : mode
 #		# scope   : multipath
 #		# desc    : The mode to use for the multipath device node,
@@ -447,6 +467,16 @@
 #		# values  : queue|fail|n (>0)
 #		#
 #		no_path_retry  queue
+#
+#		#
+#		# name    : flush_on_last_del
+#		# scope   : multipathd
+#		# desc    : If set to "yes", multipathd will disable queueing
+#		#           when the last path to a device has been deleted.
+#		# values  : yes|no
+#		# default : no
+#		#
+#		flush_on_last_del	yes
 #	}
 #	device {
 #		vendor			"COMPAQ  "
--- multipath-tools/multipath.conf.synthetic	2008/04/14 22:32:03	1.10.2.2
+++ multipath-tools/multipath.conf.synthetic	2008/04/14 22:40:08	1.10.2.3
@@ -15,6 +15,7 @@
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
+#	flush_on_last_del	no
 #	user_friendly_name	yes
 #	mode			0666
 #	uid			0
--- multipath-tools/libmultipath/config.c	2008/04/14 22:32:04	1.17.2.3
+++ multipath-tools/libmultipath/config.c	2008/04/14 22:40:08	1.17.2.4
@@ -408,6 +408,7 @@
 	conf->rr_min_io = DEFAULT_RR_MIN_IO;
 	conf->max_fds = 0;
 	conf->attribute_flags = 0;
+	conf->flush_on_last_del = 0;
 	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 
 	/*
--- multipath-tools/libmultipath/config.h	2008/04/14 22:32:04	1.17.2.3
+++ multipath-tools/libmultipath/config.h	2008/04/14 22:40:08	1.17.2.4
@@ -23,6 +23,7 @@
 	int rr_weight;
 	int no_path_retry;
 	int pg_timeout;
+	int flush_on_last_del;
 
 	char * vendor;
 	char * product;
@@ -44,6 +45,7 @@
 	int no_path_retry;
 	int pg_timeout;
 	int attribute_flags;
+	int flush_on_last_del;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -75,6 +77,7 @@
 	int pg_timeout;
 	int max_fds;
 	int attribute_flags;
+	int flush_on_last_del;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2008/04/14 22:32:04	1.16.2.4
+++ multipath-tools/libmultipath/dict.c	2008/04/14 22:40:08	1.16.2.5
@@ -294,6 +294,26 @@
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
 default_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -659,6 +679,30 @@
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
@@ -857,6 +901,30 @@
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
@@ -987,6 +1055,7 @@
 	install_keyword("max_fds", &max_fds_handler);
 	install_keyword("rr_weight", &def_weight_handler);
 	install_keyword("no_path_retry", &def_no_path_retry_handler);
+	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler);
 	install_keyword("pg_timeout", &default_pg_timeout_handler);
 	install_keyword("user_friendly_names", &names_handler);
 	install_keyword("bindings_file", &bindings_file_handler);
@@ -1024,6 +1093,7 @@
 	install_keyword("failback", &hw_failback_handler);
 	install_keyword("rr_weight", &hw_weight_handler);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler);
+	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler);
 	install_keyword("pg_timeout", &hw_pg_timeout_handler);
 	install_sublevel_end();
 
@@ -1037,6 +1107,7 @@
 	install_keyword("failback", &mp_failback_handler);
 	install_keyword("rr_weight", &mp_weight_handler);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler);
+	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler);
 	install_keyword("pg_timeout", &mp_pg_timeout_handler);
 	install_keyword("mode",	&mp_mode_handler);
 	install_keyword("uid", &mp_uid_handler);
--- multipath-tools/libmultipath/propsel.c	2008/04/14 22:32:04	1.9.2.2
+++ multipath-tools/libmultipath/propsel.c	2008/04/14 22:40:08	1.9.2.3
@@ -322,6 +322,32 @@
 }
 
 extern int
+select_flush_on_last_del(struct multipath *mp)
+{
+	if (mp->mpe && mp->mpe->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = mp->mpe->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (multipath setting)",
+			mp->flush_on_last_del);
+		return 0;
+	}
+	if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = mp->hwe->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (controler setting)",
+			mp->flush_on_last_del);
+		return 0;
+	}
+	if (conf->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = conf->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (config file default)",
+			mp->flush_on_last_del);
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
--- multipath-tools/libmultipath/propsel.h	2008/04/14 22:32:04	1.4.2.2
+++ multipath-tools/libmultipath/propsel.h	2008/04/14 22:40:08	1.4.2.3
@@ -14,3 +14,4 @@
 int select_mode(struct multipath *mp);
 int select_uid(struct multipath *mp);
 int select_gid(struct multipath *mp);
+int select_flush_on_last_del(struct multipath *mp);
--- multipath-tools/libmultipath/structs.h	2008/04/14 22:32:04	1.17.2.7
+++ multipath-tools/libmultipath/structs.h	2008/04/14 22:40:08	1.17.2.8
@@ -71,6 +71,12 @@
 	ATTR_MODE,
 };
 
+enum flush_states {
+	FLUSH_UNDEF,
+	FLUSH_DISABLED,
+	FLUSH_ENABLED,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
@@ -142,6 +148,7 @@
 	int retry_tick;    /* remaining times for retries */
 	int pg_timeout;
 	int attribute_flags;
+	int flush_on_last_del;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/multipathd/cli.c	2005/11/16 20:24:58	1.4
+++ multipath-tools/multipathd/cli.c	2008/04/14 22:40:09	1.4.2.1
@@ -124,6 +124,8 @@
 	r += add_key(keys, "del", DEL, 0);
 	r += add_key(keys, "switch", SWITCH, 0);
 	r += add_key(keys, "switchgroup", SWITCH, 0);
+	r += add_key(keys, "disablequeueing", DISABLEQ, 0);
+	r += add_key(keys, "restorequeueing", RESTOREQ, 0);
 	r += add_key(keys, "paths", PATHS, 0);
 	r += add_key(keys, "maps", MAPS, 0);
 	r += add_key(keys, "path", PATH, 1);
--- multipath-tools/multipathd/cli.h	2005/11/16 20:24:58	1.4
+++ multipath-tools/multipathd/cli.h	2008/04/14 22:40:09	1.4.2.1
@@ -3,6 +3,8 @@
 	__ADD,
 	__DEL,
 	__SWITCH,
+	__DISABLEQ,
+	__RESTOREQ,
 	__PATHS,
 	__MAPS,
 	__PATH,
@@ -17,6 +19,8 @@
 #define ADD		(1 << __ADD)
 #define DEL		(1 << __DEL)
 #define SWITCH		(1 << __SWITCH)
+#define DISABLEQ	(1 << __DISABLEQ)
+#define RESTOREQ	(1 << __RESTOREQ)
 #define PATHS		(1 << __PATHS)
 #define MAPS		(1 << __MAPS)
 #define PATH		(1 << __PATH)
--- multipath-tools/multipathd/cli_handlers.c	2005/12/02 08:01:09	1.4
+++ multipath-tools/multipathd/cli_handlers.c	2008/04/14 22:40:09	1.4.2.1
@@ -74,6 +74,48 @@
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
+		mpp = find_mp(vecs->mpvec, mapname);
+
+	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+	    mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
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
+		mpp = find_mp(vecs->mpvec, mapname);
+
+	mpp->retry_tick = 0;
+	dm_queue_if_no_path(mpp->alias, 0);
+	return 0;
+}
+
+int
 cli_del_map (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
--- multipath-tools/multipathd/cli_handlers.h	2005/10/12 21:57:26	1.2
+++ multipath-tools/multipathd/cli_handlers.h	2008/04/14 22:40:09	1.2.2.1
@@ -7,3 +7,5 @@
 int cli_switch_group(void * v, char ** reply, int * len, void * data);
 int cli_dump_pathvec(void * v, char ** reply, int * len, void * data);
 int cli_reconfigure(void * v, char ** reply, int * len, void * data);
+int cli_disable_queueing(void * v, char ** reply, int * len, void * data);
+int cli_restore_queueing(void * v, char ** reply, int * len, void * data);
--- multipath-tools/multipathd/main.c	2008/01/25 22:30:00	1.66.2.3
+++ multipath-tools/multipathd/main.c	2008/04/14 22:40:09	1.66.2.4
@@ -416,6 +416,7 @@
 	adopt_paths(vecs, mpp);
 	mpp->hwe = extract_hwe_from_path(mpp);
 	select_pgfailback(mpp);
+	select_flush_on_last_del(mpp);
 	set_no_path_retry(mpp);
 
 	return 0;
@@ -837,6 +838,8 @@
 {
 	int i;
 	struct path * pp;
+	struct multipath * mpp;
+	int found = 0;
 
 	pp = find_path_by_dev(vecs->pathvec, devname);
 
@@ -844,14 +847,28 @@
 		condlog(3, "%s: not in pathvec", devname);
 		return 1;
 	}
+	
+	mpp = pp->mpp;
 
-	if (pp->mpp && (pp->state == PATH_UP || pp->state == PATH_GHOST))
-		update_queue_mode_del_path(pp->mpp);
+	if (mpp && (pp->state == PATH_UP || pp->state == PATH_GHOST))
+		update_queue_mode_del_path(mpp);
 
 	condlog(2, "remove %s path checker", devname);
 	i = find_slot(vecs->pathvec, (void *)pp);
 	vector_del_slot(vecs->pathvec, i);
 	free_path(pp);
+	vector_foreach_slot (vecs->pathvec, pp, i) {
+		if (pp->mpp == mpp){
+			found = 1;
+			break;
+		}
+	}
+	if (!found && mpp->flush_on_last_del == FLUSH_ENABLED) {	
+		condlog(1, "%s: Last path deleted, disabling queueing",
+		        mpp->alias);
+		mpp->retry_tick = 0;
+		dm_queue_if_no_path(mpp->alias, 0);
+	}
 
 	return 0;
 }
@@ -1166,6 +1183,8 @@
 	add_handler(SWITCH+MAP+GROUP, cli_switch_group);
 	add_handler(DUMP+PATHVEC, cli_dump_pathvec);
 	add_handler(RECONFIGURE, cli_reconfigure);
+	add_handler(DISABLEQ+MAP, cli_disable_queueing);
+	add_handler(RESTOREQ+MAP, cli_restore_queueing);
 
 	uxsock_listen(&uxsock_trigger, ap);
 
