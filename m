From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 8 Sep 2008 22:01:21 -0000
Message-ID: <20080908220121.11216.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-09-08 22:01:20

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.synthetic 
	libmultipath   : config.h dict.c structs.h waiter.c 
	multipathd     : main.c 

Log message:
	Fix for bz #419581. There is a new default multipath.conf option,
	queue_without_daemon. It defaults to 'yes'.  If it is set to 'no', when
	multipathd is stopped, queue_if_no_path is disabled.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.8&r2=1.18.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.5&r2=1.11.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.6&r2=1.18.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.7&r2=1.17.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.5&r2=1.18.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/waiter.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.11&r2=1.69.2.12

--- multipath-tools/multipath.conf.annotated	2008/09/04 20:09:48	1.18.2.8
+++ multipath-tools/multipath.conf.annotated	2008/09/08 22:01:19	1.18.2.9
@@ -121,6 +121,7 @@
 #	#
 #	#no_path_retry  queue
 #
+#	#
 #	# name    : flush_on_last_del
 #	# scope   : multipathd
 #	# desc    : If set to "yes", multipathd will disable queueing when the
@@ -131,6 +132,16 @@
 #	flush_on_last_del       yes
 #
 #	#
+#	# name    : queue_without_daemon
+#	# scope   : multipathd
+#	# desc    : If set to "no", multipathd will disable queueing for all
+#	#           devices when it is shut down.
+#	# values  : yes|no
+#	# default : yes
+#	#
+#	flush_on_last_del       no
+#
+#	#
 #	# name    : user_friendly_names
 #	# scope   : multipath
 #	# desc    : If set to "yes", using the bindings file
--- multipath-tools/multipath.conf.synthetic	2008/09/04 20:09:48	1.11.2.5
+++ multipath-tools/multipath.conf.synthetic	2008/09/08 22:01:19	1.11.2.6
@@ -17,6 +17,7 @@
 #	no_path_retry		fail
 #	user_friendly_names	no
 #	flush_on_last_del	no
+#	queue_without_daemon    no
 #	mode			0666
 #	uid			0
 #	gid			0
--- multipath-tools/libmultipath/config.h	2008/09/04 20:09:48	1.18.2.6
+++ multipath-tools/libmultipath/config.h	2008/09/08 22:01:20	1.18.2.7
@@ -75,6 +75,7 @@
 	int force_reload;
 	int attribute_flags;
 	int flush_on_last_del;
+	int queue_without_daemon;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2008/09/04 20:09:48	1.17.2.7
+++ multipath-tools/libmultipath/dict.c	2008/09/08 22:01:20	1.17.2.8
@@ -317,6 +317,28 @@
 }
 
 static int
+def_queue_without_daemon(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1; 
+
+	if (!strncmp(buff, "off", 3) || !strncmp(buff, "no", 2) ||
+	    !strncmp(buff, "0", 1))
+		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
+	else if (!strncmp(buff, "on", 2) || !strncmp(buff, "yes", 3) ||
+	    !strncmp(buff, "1", 1))
+		conf->queue_without_daemon = QUE_NO_DAEMON_ON;
+	else
+		conf->queue_without_daemon = QUE_NO_DAEMON_UNDEF;
+
+	free(buff);
+	return 0;
+}
+
+static int
 def_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -1812,6 +1834,18 @@
 }
 
 static int
+snprint_def_queue_without_daemon (char * buff, int len, void * data)
+{
+	switch (conf->queue_without_daemon) {
+	case QUE_NO_DAEMON_OFF:
+		return snprintf(buff, len, "no");
+	case QUE_NO_DAEMON_ON:
+		return snprintf(buff, len, "yes");
+	}
+	return 0;
+}
+
+static int
 snprint_def_flush_on_last_del (char * buff, int len, void * data)
 {
 	switch (conf->flush_on_last_del) {
@@ -1906,6 +1940,7 @@
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
 	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
+	install_keyword("queue_without_daemon", &def_queue_without_daemon, &snprint_def_queue_without_daemon);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
--- multipath-tools/libmultipath/structs.h	2008/09/04 20:09:48	1.18.2.5
+++ multipath-tools/libmultipath/structs.h	2008/09/08 22:01:20	1.18.2.6
@@ -78,6 +78,12 @@
 	FLUSH_IN_PROGRESS,
 };
 
+enum queue_without_daemon_states {
+	QUE_NO_DAEMON_UNDEF,
+	QUE_NO_DAEMON_OFF,
+	QUE_NO_DAEMON_ON,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
--- multipath-tools/libmultipath/waiter.c	2008/08/27 19:14:57	1.1.2.2
+++ multipath-tools/libmultipath/waiter.c	2008/09/08 22:01:20	1.1.2.3
@@ -182,6 +182,8 @@
 	waiter = (struct event_thread *)et;
 	pthread_cleanup_push(free_waiter, et);
 
+	block_signal(SIGUSR1, NULL);
+	block_signal(SIGHUP, NULL);
 	while (1) {
 		r = waiteventloop(waiter);
 
--- multipath-tools/multipathd/main.c	2008/09/04 23:31:39	1.69.2.11
+++ multipath-tools/multipathd/main.c	2008/09/08 22:01:20	1.69.2.12
@@ -1470,6 +1470,8 @@
 #ifdef CLONE_NEWNS
 	unsigned int new_ns = (unsigned long)param & NEW_NS;
 #endif
+	struct multipath * mpp;
+	int i;
 
 	if (daemon)
 		setup_daemon();
@@ -1555,6 +1557,9 @@
 	 */
 	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
+		vector_foreach_slot(vecs->mpvec, mpp, i)
+			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps(vecs, stop_waiter_thread);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 
