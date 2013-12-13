From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] multipathd: Implement systemd watchdog
	integration
Date: Fri, 13 Dec 2013 10:11:19 +0100
Message-ID: <1386925879-31225-4-git-send-email-hare@suse.de>
References: <1386925879-31225-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386925879-31225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

In the past there have been several instances where multipathd
would hang with the checkerloop as some path checker might not
be able to return in time.
This patch now activates the watchdog feature from systemd
to shutdown (and possibly restart) multipathd in these
situations.
Due to a bug in systemd watchdog integration only works
correctly with later version (> 206), so watchdog integration
has been disabled per default.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.h      |  3 +++
 multipath/multipath.conf.5 |  7 +++++--
 multipathd/main.c          | 23 ++++++++++++++++++++++-
 multipathd/multipathd.8    | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 9c467e8..445525b 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -98,6 +98,9 @@ struct config {
 	int queue_without_daemon;
 	int checker_timeout;
 	int daemon;
+#ifdef USE_SYSTEMD
+	int watchdog;
+#endif
 	int flush_on_last_del;
 	int attribute_flags;
 	int fast_io_fail;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0fd3035..cf5bec0 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -71,8 +71,11 @@ section recognizes the following keywords:
 .B polling_interval
 interval between two path checks in seconds. For properly functioning paths,
 the interval between checks will gradually increase to
-.B max_polling_interval;
-default is
+.B max_polling_interval.
+This value will be overridden by the
+.B WatchdogSec
+setting in the multipathd.service definition if systemd is used.
+Default is
 .I 5
 .TP
 .B max_polling_interval
diff --git a/multipathd/main.c b/multipathd/main.c
index 49e74a6..3219511 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1294,7 +1294,10 @@ checkerloop (void *ap)
 		lock(vecs->lock);
 		pthread_testcancel();
 		condlog(4, "tick");
-
+#ifdef USE_SYSTEMD
+		if (conf->watchdog)
+			sd_notify(0, "WATCHDOG=1");
+#endif
 		if (vecs->pathvec) {
 			vector_foreach_slot (vecs->pathvec, pp, i) {
 				num_paths += check_path(vecs, pp);
@@ -1616,6 +1619,9 @@ child (void * param)
 	struct vectors * vecs;
 	struct multipath * mpp;
 	int i;
+#ifdef USE_SYSTEMD
+	unsigned long checkint;
+#endif
 	int rc, pid_rc;
 	char *envp;
 
@@ -1696,6 +1702,21 @@ child (void * param)
 
 	conf->daemon = 1;
 	udev_set_sync_support(0);
+#ifdef USE_SYSTEMD
+	envp = getenv("WATCHDOG_USEC");
+	if (envp && sscanf(envp, "%lu", &checkint) == 1) {
+		/* Value is in microseconds */
+		conf->max_checkint = checkint / 1000000;
+		/* Rescale checkint */
+		if (conf->checkint > conf->max_checkint)
+			conf->checkint = conf->max_checkint;
+		else
+			conf->checkint = conf->max_checkint / 4;
+		condlog(3, "enabling watchdog, interval %d max %d",
+			conf->checkint, conf->max_checkint);
+		conf->watchdog = conf->checkint;
+	}
+#endif
 	/*
 	 * Start uevent listener early to catch events
 	 */
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 2aea150..5e35665 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -128,10 +128,53 @@ Restore queuing on multipahted map $map
 .B quit|exit
 End interactive session.
 
+.SH "SYSTEMD INTEGRATION"
+When compiled with systemd support two systemd service files are
+installed,
+.I multipathd.service
+and
+.I multipathd.socket
+The
+.I multipathd.socket
+service instructs systemd to intercept the CLI command socket, so
+that any call to the CLI interface will start-up the daemon if
+required.
+The
+.I multipathd.service
+file carries the definitions for controlling the multipath daemon.
+The daemon itself uses the
+.B sd_notify(3)
+interface to communicate with systemd. The following unit keywords are
+recognized:
+.TP
+.I WatchdogSec=
+Enables the internal watchdog from systemd. multipath will send a
+notification via
+.B sd_notify(3)
+to systemd to reset the watchdog. If specified the
+.I polling_interval
+and
+.I max_polling_interval
+settings will be overridden by the watchdog settings.
+
+Please note that systemd prior to version 207 has issues which prevent
+the systemd-provided watchdog from working correctly. So the watchdog
+is not enabled per default, but has to be enabled manually by updating
+the multipathd.service file.
+.TP
+.I OOMScoreAdjust=
+Overrides the internal OOM adjust mechanism
+.TP
+.I LimitNOFILE=
+Overrides the
+.I max_fds
+configuration setting.
+
 .SH "SEE ALSO"
 .BR multipath (8)
 .BR kpartx (8)
-.BR hotplug (8)
+.BR sd_notify (3)
+.BR system.service (5)
 .SH "AUTHORS"
 .B multipathd
 was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
-- 
1.8.1.4
