From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 34/39] multipathd: pid fd resource leak
Date: Thu, 16 Jun 2016 11:47:40 +0200
Message-ID: <1466070465-1021-35-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

We open a PID filedescriptor, but never close them.
While this is not an error per se coverity complains here.
So be a good guy and close the PID fd properly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c    | 6 +++++-
 multipathd/pidfile.c | 6 +++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0eadd70..8285f0d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2085,6 +2085,7 @@ child (void * param)
 	unsigned long checkint;
 #endif
 	int rc;
+	int pid_fd = -1;
 	char *envp;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
@@ -2101,7 +2102,8 @@ child (void * param)
 		log_thread_start(&log_attr);
 		pthread_attr_destroy(&log_attr);
 	}
-	if (pidfile_create(DEFAULT_PIDFILE, daemon_pid)) {
+	pid_fd = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
+	if (pid_fd < 0) {
 		condlog(1, "failed to create pidfile");
 		if (logsink == 1)
 			log_thread_stop();
@@ -2307,6 +2309,8 @@ failed:
 #ifdef USE_SYSTEMD
 	sd_notify(0, "ERRNO=1");
 #endif
+	if (pid_fd >= 0)
+		close(pid_fd);
 	exit(1);
 }
 
diff --git a/multipathd/pidfile.c b/multipathd/pidfile.c
index e3fb896..e911358 100644
--- a/multipathd/pidfile.c
+++ b/multipathd/pidfile.c
@@ -22,7 +22,7 @@ int pidfile_create(const char *pidFile, pid_t pid)
 		       (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH))) < 0) {
 		condlog(0, "Cannot open pidfile [%s], error was [%s]",
 			pidFile, strerror(errno));
-		return 1;
+		return -errno;
 	}
 	lock.l_type = F_WRLCK;
 	lock.l_start = 0;
@@ -60,8 +60,8 @@ int pidfile_create(const char *pidFile, pid_t pid)
 			"error was [%s]", pidFile, strerror(errno));
 		goto fail;
 	}
-	return 0;
+	return fd;
 fail:
 	close(fd);
-	return 1;
+	return -errno;
 }
-- 
2.6.6
