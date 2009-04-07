From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] add queue_without_daemon config option for
	multipathd
Date: Tue, 7 Apr 2009 17:23:48 -0500
Message-ID: <20090407222348.GA15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Once you stop multipathd, if you've lost all your paths, you aren't going to
have them restored, and any queued IO will just sit there. This can be
especially problematic on shutdown. This patch adds a queue_without_daemon
option to the defaults section of multipath.conf. If this is set to "no",
when multipathd stops, queue_if_no_path is turned off for all devices. If
multipathd is restarted, queue_if_no_path is reset appropriately for all
devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h    |    1 +
 libmultipath/dict.c      |   35 +++++++++++++++++++++++++++++++++++
 libmultipath/structs.h   |    6 ++++++
 multipath.conf.annotated |    9 +++++++++
 multipath.conf.synthetic |    1 +
 multipathd/main.c        |    5 +++++
 6 files changed, 57 insertions(+)

Index: multipath-tools-090407/libmultipath/config.h
===================================================================
--- multipath-tools-090407.orig/libmultipath/config.h	2009-04-07 15:21:34.000000000 -0500
+++ multipath-tools-090407/libmultipath/config.h	2009-04-07 09:16:31.000000000 -0500
@@ -66,6 +66,7 @@ struct config {
 	int pg_timeout;
 	int max_fds;
 	int force_reload;
+	int queue_without_daemon;
 	int daemon;
 	int flush_on_last_del;
 
Index: multipath-tools-090407/libmultipath/dict.c
===================================================================
--- multipath-tools-090407.orig/libmultipath/dict.c	2009-04-07 15:21:35.000000000 -0500
+++ multipath-tools-090407/libmultipath/dict.c	2009-04-07 09:16:31.000000000 -0500
@@ -221,6 +221,28 @@ def_no_path_retry_handler(vector strvec)
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
+		 !strncmp(buff, "1", 1))
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
@@ -1594,6 +1616,18 @@ snprint_def_no_path_retry (char * buff, 
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
 snprint_def_pg_timeout (char * buff, int len, void * data)
 {
 	if (conf->pg_timeout == DEFAULT_PGTIMEOUT)
@@ -1678,6 +1712,7 @@ init_keywords(void)
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
 	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
+	install_keyword("queue_without_daemon", &def_queue_without_daemon, &snprint_def_queue_without_daemon);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
Index: multipath-tools-090407/libmultipath/structs.h
===================================================================
--- multipath-tools-090407.orig/libmultipath/structs.h	2009-04-07 15:21:35.000000000 -0500
+++ multipath-tools-090407/libmultipath/structs.h	2009-04-07 09:16:31.000000000 -0500
@@ -62,6 +62,12 @@ enum pgstates {
 	PGSTATE_ACTIVE
 };
 
+enum queue_without_daemon_states {
+	QUE_NO_DAEMON_UNDEF,
+	QUE_NO_DAEMON_OFF,
+	QUE_NO_DAEMON_ON,
+};
+
 enum pgtimeouts {
 	PGTIMEOUT_UNDEF,
 	PGTIMEOUT_NONE
Index: multipath-tools-090407/multipath.conf.annotated
===================================================================
--- multipath-tools-090407.orig/multipath.conf.annotated	2009-04-07 15:21:35.000000000 -0500
+++ multipath-tools-090407/multipath.conf.annotated	2009-04-07 10:28:56.000000000 -0500
@@ -151,6 +151,15 @@
 #	no_path_retry  queue
 #
 #	#
+#	# name    : queue_without_daemon
+#	# scope   : multipathd
+#	# desc    : If set to "no", multipathd will disable queueing for all
+#	#           devices when it is shut down.
+#	# values  : yes|no
+#	# default : yes
+#	queue_without_daemon	no
+#
+#	#
 #	# name    : user_friendly_names
 #	# scope   : multipath
 #	# desc    : If set to "yes", using the bindings file
Index: multipath-tools-090407/multipath.conf.synthetic
===================================================================
--- multipath-tools-090407.orig/multipath.conf.synthetic	2009-04-07 15:21:35.000000000 -0500
+++ multipath-tools-090407/multipath.conf.synthetic	2009-04-07 10:28:56.000000000 -0500
@@ -16,6 +16,7 @@
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
+#	queue_without_daemon    no
 #	user_friendly_names	no
 #}
 #blacklist {
Index: multipath-tools-090407/multipathd/main.c
===================================================================
--- multipath-tools-090407.orig/multipathd/main.c	2009-04-07 15:21:35.000000000 -0500
+++ multipath-tools-090407/multipathd/main.c	2009-04-07 09:16:31.000000000 -0500
@@ -1318,6 +1318,8 @@ child (void * param)
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t log_attr, misc_attr;
 	struct vectors * vecs;
+	struct multipath * mpp;
+	int i;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 
@@ -1411,6 +1413,9 @@ child (void * param)
 	 */
 	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
+		vector_foreach_slot(vecs->mpvec, mpp, i)
+			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps_and_stop_waiters(vecs);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 
