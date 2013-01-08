From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/42] multipathd: Ignore errors when creating
	pidfile
Date: Tue,  8 Jan 2013 14:54:15 +0100
Message-ID: <1357653259-62650-38-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

We can use CLI commands to communicate with the daemon,
so we don't need the pidfile for correct operation.
Hence any errors from creating the pidfile can be safely
ignored.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7fe9c5b..6c5e243 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1560,7 +1560,7 @@ child (void * param)
 	struct vectors * vecs;
 	struct multipath * mpp;
 	int i;
-	int rc;
+	int rc, pid_rc;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 
@@ -1667,9 +1667,8 @@ child (void * param)
 
 	pthread_mutex_lock(&exit_mutex);
 	/* Startup complete, create logfile */
-	if (pidfile_create(DEFAULT_PIDFILE, daemon_pid))
-		/* Ignore errors, we can live without */
-		condlog(1, "failed to create pidfile");
+	pid_rc = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
+	/* Ignore errors, we can live without */
 
 	running_state = DAEMON_RUNNING;
 	pthread_cond_wait(&exit_cond, &exit_mutex);
@@ -1715,8 +1714,10 @@ child (void * param)
 	dm_lib_exit();
 
 	/* We're done here */
-	condlog(3, "unlink pidfile");
-	unlink(DEFAULT_PIDFILE);
+	if (!pid_rc) {
+		condlog(3, "unlink pidfile");
+		unlink(DEFAULT_PIDFILE);
+	}
 
 	condlog(2, "--------shut down-------");
 
-- 
1.7.4.2
