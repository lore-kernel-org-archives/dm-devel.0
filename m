From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/9] multipathd: use sd_notify() to inform systemd
Date: Tue, 26 Nov 2013 12:41:26 +0100
Message-ID: <1385466090-24290-6-git-send-email-hare@suse.de>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1385466090-24290-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Implement sd_notify() to inform systemd about our internal state.
And we should be using the service type 'notify' so the systemd
doesn't try to flood multipathd if it's still in discovery.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/Makefile           |  3 +++
 multipathd/main.c             | 43 ++++++++++++++++++++++++++++++++++---------
 multipathd/multipathd.service |  3 ++-
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/multipathd/Makefile b/multipathd/Makefile
index 3b9f2cf..781122a 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -6,6 +6,9 @@ include ../Makefile.inc
 # basic flags setting
 #
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
+ifdef SYSTEMD
+	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
+endif
 LDFLAGS += -lpthread -ldevmapper -lreadline
 ifdef SYSTEMD
 	LDFLAGS += -lsystemd-daemon
diff --git a/multipathd/main.c b/multipathd/main.c
index 78d9265..d8d1204 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -17,6 +17,9 @@
 #include <limits.h>
 #include <linux/oom.h>
 #include <libudev.h>
+#ifdef USE_SYSTEMD
+#include <systemd/sd-daemon.h>
+#endif
 #include <semaphore.h>
 #include <mpath_persist.h>
 
@@ -1605,19 +1608,22 @@ child (void * param)
 
 	running_state = DAEMON_START;
 
+#ifdef USE_SYSTEMD
+	sd_notify(0, "STATUS=startup");
+#endif
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
 	if (load_config(DEFAULT_CONFIGFILE, udev))
-		exit(1);
+		goto failed;
 
 	if (init_checkers()) {
 		condlog(0, "failed to initialize checkers");
-		exit(1);
+		goto failed;
 	}
 	if (init_prio()) {
 		condlog(0, "failed to initialize prioritizers");
-		exit(1);
+		goto failed;
 	}
 
 	setlogmask(LOG_UPTO(conf->verbosity + 3));
@@ -1650,7 +1656,7 @@ child (void * param)
 
 	vecs = gvecs = init_vecs();
 	if (!vecs)
-		exit(1);
+		goto failed;
 
 	setscheduler();
 	set_oom_adj();
@@ -1662,23 +1668,26 @@ child (void * param)
 	 */
 	if ((rc = pthread_create(&uevent_thr, &uevent_attr, ueventloop, udev))) {
 		condlog(0, "failed to create uevent thread: %d", rc);
-		exit(1);
+		goto failed;
 	}
 	pthread_attr_destroy(&uevent_attr);
 	if ((rc = pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs))) {
 		condlog(0, "failed to create cli listener: %d", rc);
-		exit(1);
+		goto failed;
 	}
 	/*
 	 * fetch and configure both paths and multipaths
 	 */
+#ifdef USE_SYSTEMD
+	sd_notify(0, "STATUS=configure");
+#endif
 	running_state = DAEMON_CONFIGURE;
 
 	lock(vecs->lock);
 	if (configure(vecs, 1)) {
 		unlock(vecs->lock);
 		condlog(0, "failure during configuration");
-		exit(1);
+		goto failed;
 	}
 	unlock(vecs->lock);
 
@@ -1687,11 +1696,11 @@ child (void * param)
 	 */
 	if ((rc = pthread_create(&check_thr, &misc_attr, checkerloop, vecs))) {
 		condlog(0,"failed to create checker loop thread: %d", rc);
-		exit(1);
+		goto failed;
 	}
 	if ((rc = pthread_create(&uevq_thr, &misc_attr, uevqloop, vecs))) {
 		condlog(0, "failed to create uevent dispatcher: %d", rc);
-		exit(1);
+		goto failed;
 	}
 	pthread_attr_destroy(&misc_attr);
 
@@ -1700,11 +1709,18 @@ child (void * param)
 	/* Ignore errors, we can live without */
 
 	running_state = DAEMON_RUNNING;
+#ifdef USE_SYSTEMD
+	sd_notify(0, "READY=1\nSTATUS=running");
+#endif
 
 	/*
 	 * exit path
 	 */
 	while(sem_wait(&exit_sem) != 0); /* Do nothing */
+
+#ifdef USE_SYSTEMD
+	sd_notify(0, "STATUS=shutdown");
+#endif
 	running_state = DAEMON_SHUTDOWN;
 	lock(vecs->lock);
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
@@ -1765,7 +1781,16 @@ child (void * param)
 	dbg_free_final(NULL);
 #endif
 
+#ifdef USE_SYSTEMD
+	sd_notify(0, "ERRNO=0");
+#endif
 	exit(0);
+
+failed:
+#ifdef USE_SYSTEMD
+	sd_notify(0, "ERRNO=1");
+#endif
+	exit(1);
 }
 
 static int
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index ec38ef1..3874bcb 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -6,10 +6,11 @@ DefaultDependencies=no
 Conflicts=shutdown.target
 
 [Service]
+Type=notify
+NotifyAccess=main
 ExecStartPre=/sbin/modprobe dm-multipath
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
-ExecStop=/sbin/multipathd shutdown
 
 [Install]
 WantedBy=sysinit.target
-- 
1.8.1.4
