From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add queue_without_daemon config
	parameter
Date: Tue, 23 Mar 2010 17:04:00 -0500
Message-ID: <20100323220400.GE23952@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

This patch adds a new multipath.conf default paramter, queue_without_daemon.
If this is set to "no", when multipathd stops, queueing will be turned off for
all devices.  This is useful for devices that set no_path_retry.  If a machine
is shut down while all paths to a device are down, it is possible to hang
waiting for IO to return from the device after multipathd has been stopped.
Without multipathd running, access to the paths cannot be restored, and the
kernel cannot be told to stop queueing IO. Setting queue_without_daemon to "no"
makes multipathd turn off queueing on all devices when it stops, avoiding the
problem.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
:100644 100644 50a728c... 86b1320... M	libmultipath/config.h
:100644 100644 ee4de68... 7888e8e... M	libmultipath/dict.c
:100644 100644 afd1246... 2e7a0d1... M	libmultipath/structs.h
:100644 100644 c222da4... 9afa615... M	multipath.conf.annotated
:100644 100644 3e0fd6e... 44d1329... M	multipath.conf.synthetic
:100644 100644 41a9bd0... 90de6df... M	multipathd/main.c
 libmultipath/config.h      |    1 +
 libmultipath/dict.c        |   35 +++++++++++++++++++++++++++++++++++
 libmultipath/structs.h     |    6 ++++++
 multipath.conf.annotated   |    9 +++++++++
 multipath.conf.synthetic   |    1 +
 multipath/multipath.conf.5 |   13 +++++++++++++
 multipathd/main.c          |    5 +++++
 7 files changed, 70 insertions(+)

Index: multipath-tools-100322/libmultipath/config.h
===================================================================
--- multipath-tools-100322.orig/libmultipath/config.h
+++ multipath-tools-100322/libmultipath/config.h
@@ -74,6 +74,7 @@ struct config {
 	int pg_timeout;
 	int max_fds;
 	int force_reload;
+	int queue_without_daemon;
 	int daemon;
 	int flush_on_last_del;
 	int attribute_flags;
Index: multipath-tools-100322/libmultipath/dict.c
===================================================================
--- multipath-tools-100322.orig/libmultipath/dict.c
+++ multipath-tools-100322/libmultipath/dict.c
@@ -362,6 +362,28 @@ def_no_path_retry_handler(vector strvec)
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
@@ -1944,6 +1966,18 @@ snprint_def_no_path_retry (char * buff, 
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
@@ -2029,6 +2063,7 @@ init_keywords(void)
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
 	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
+	install_keyword("queue_without_daemon", &def_queue_without_daemon, &snprint_def_queue_without_daemon);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
Index: multipath-tools-100322/libmultipath/structs.h
===================================================================
--- multipath-tools-100322.orig/libmultipath/structs.h
+++ multipath-tools-100322/libmultipath/structs.h
@@ -63,6 +63,12 @@ enum pgstates {
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
Index: multipath-tools-100322/multipath.conf.annotated
===================================================================
--- multipath-tools-100322.orig/multipath.conf.annotated
+++ multipath-tools-100322/multipath.conf.annotated
@@ -153,6 +153,15 @@
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
Index: multipath-tools-100322/multipath.conf.synthetic
===================================================================
--- multipath-tools-100322.orig/multipath.conf.synthetic
+++ multipath-tools-100322/multipath.conf.synthetic
@@ -16,6 +16,7 @@
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
+#	queue_without_daemon    no
 #	user_friendly_names	no
 #	mode			644
 #	uid			0
Index: multipath-tools-100322/multipathd/main.c
===================================================================
--- multipath-tools-100322.orig/multipathd/main.c
+++ multipath-tools-100322/multipathd/main.c
@@ -1359,6 +1359,8 @@ child (void * param)
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t log_attr, misc_attr;
 	struct vectors * vecs;
+	struct multipath * mpp;
+	int i;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 
@@ -1448,6 +1450,9 @@ child (void * param)
 	 */
 	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
+		vector_foreach_slot(vecs->mpvec, mpp, i)
+			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps_and_stop_waiters(vecs);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 
Index: multipath-tools-100322/multipath/multipath.conf.5
===================================================================
--- multipath-tools-100322.orig/multipath/multipath.conf.5
+++ multipath-tools-100322/multipath/multipath.conf.5
@@ -251,6 +251,19 @@ will disable the timeout.
 .B dev_loss_tmo
 Specify the number of seconds the scsi layer will wait after a problem has
 been detected on a FC remote port before removing it from the system.
+.TP
+.B queue_without_daemon
+If set to
+.I no
+, when multipathd stops, queueing will be turned off for all devices.
+This is useful for devices that set no_path_retry.  If a machine is
+shut down while all paths to a device are down, it is possible to hang waiting
+for IO to return from the device after multipathd has been stopped. Without
+multipathd running, access to the paths cannot be restored, and the kernel
+cannot be told to stop queueing IO. Setting queue_without_daemon to
+.I no
+, avoids this problem. Default is
+.I yes
 .
 .SH "blacklist section"
 The
