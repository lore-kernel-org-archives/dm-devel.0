From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/13] multipathd: use sd_notify() to inform
	systemd
Date: Fri, 15 Nov 2013 11:29:38 +0100
Message-ID: <1384511384-27642-8-git-send-email-hare@suse.de>
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

Implement sd_notify() to inform systemd about our internal state.
And we should be using the service type 'notify' so the systemd
doesn't try to flood multipathd if it's still in discovery.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c             | 7 ++++++-
 multipathd/multipathd.service | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 91d7bfc..b4146fd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -17,6 +17,7 @@
 #include <limits.h>
 #include <linux/oom.h>
 #include <libudev.h>
+#include <systemd/sd-daemon.h>
 #include <semaphore.h>
 #include <mpath_persist.h>
 
@@ -1604,7 +1605,7 @@ child (void * param)
 	}
 
 	running_state = DAEMON_START;
-
+	sd_notify(0, "STATUS=startup");
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
@@ -1672,6 +1673,7 @@ child (void * param)
 	/*
 	 * fetch and configure both paths and multipaths
 	 */
+	sd_notify(0, "STATUS=configure");
 	running_state = DAEMON_CONFIGURE;
 
 	lock(vecs->lock);
@@ -1700,11 +1702,14 @@ child (void * param)
 	/* Ignore errors, we can live without */
 
 	running_state = DAEMON_RUNNING;
+	sd_notify(0, "READY=1\nSTATUS=running");
 
 	/*
 	 * exit path
 	 */
 	while(sem_wait(&exit_sem) != 0); /* Do nothing */
+
+	sd_notify(0, "STATUS=shutdown");
 	running_state = DAEMON_SHUTDOWN;
 	lock(vecs->lock);
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index bc62bc5..03b4270 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -6,9 +6,10 @@ DefaultDependencies=no
 Conflicts=shutdown.target
 
 [Service]
+Type=notify
+NotifyAccess=main
 ExecStart=/sbin/multipathd -d
 ExecReload=/sbin/multipathd reconfigure
-ExecStop=/sbin/multipathd shutdown
 
 [Install]
 WantedBy=sysinit.target
-- 
1.8.1.4
