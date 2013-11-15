From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/13] multipathd: Implement systemd watchdog
	integration
Date: Fri, 15 Nov 2013 11:29:40 +0100
Message-ID: <1384511384-27642-10-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.conf.5    |  7 +++++--
 multipathd/main.c             | 15 ++++++++++++++-
 multipathd/multipathd.service |  1 +
 3 files changed, 20 insertions(+), 3 deletions(-)

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
index 72b3740..abeebc2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1286,6 +1286,7 @@ checkerloop (void *ap)
 		lock(vecs->lock);
 		pthread_testcancel();
 		condlog(4, "tick");
+		sd_notify(0, "WATCHDOG=1");
 
 		if (vecs->pathvec) {
 			vector_foreach_slot (vecs->pathvec, pp, i) {
@@ -1585,7 +1586,8 @@ child (void * param)
 	pthread_attr_t log_attr, misc_attr, uevent_attr;
 	struct vectors * vecs;
 	struct multipath * mpp;
-	int i;
+	char *envp;
+	int i, checkint;
 	int rc, pid_rc;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
@@ -1658,6 +1660,17 @@ child (void * param)
 
 	conf->daemon = 1;
 	udev_set_sync_support(0);
+	envp = getenv("WATCHDOG_USEC");
+	if (envp && sscanf(envp, "%d", &checkint) == 1) {
+		/* Value is in microseconds */
+		checkint = checkint / 1000000;
+		if (checkint > conf->max_checkint)
+			conf->max_checkint = checkint;
+		conf->checkint = checkint;
+		condlog(3, "set checkint to %d max %d",
+			conf->checkint, conf->max_checkint);
+	}
+
 	/*
 	 * Start uevent listener early to catch events
 	 */
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index fb84025..848a231 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -10,6 +10,7 @@ Type=notify
 NotifyAccess=main
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
+WatchdogSec=5s
 
 [Install]
 WantedBy=sysinit.target
-- 
1.8.1.4
