From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 39/42] multipathd deadlocks during restart
Date: Tue,  8 Jan 2013 14:54:16 +0100
Message-ID: <1357653259-62650-39-git-send-email-hare@suse.de>
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

During restart multipathd might deadlock as the uevent handler
is missing a cleanup handler. Thus the thread might be terminated
while it still holds the vector lock.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6c5e243..3a6e88f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -895,13 +895,11 @@ exit_daemon (int status)
 	if (status != 0)
 		fprintf(stderr, "bad exit status. see daemon.log\n");
 
-	condlog(3, "unlink pidfile");
-	unlink(DEFAULT_PIDFILE);
-
-	pthread_mutex_lock(&exit_mutex);
-	pthread_cond_signal(&exit_cond);
-	pthread_mutex_unlock(&exit_mutex);
-
+	if (running_state != DAEMON_SHUTDOWN) {
+		pthread_mutex_lock(&exit_mutex);
+		pthread_cond_signal(&exit_cond);
+		pthread_mutex_unlock(&exit_mutex);
+	}
 	return status;
 }
 
@@ -1560,6 +1558,7 @@ child (void * param)
 	struct vectors * vecs;
 	struct multipath * mpp;
 	int i;
+	sigset_t set;
 	int rc, pid_rc;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
@@ -1672,11 +1671,17 @@ child (void * param)
 
 	running_state = DAEMON_RUNNING;
 	pthread_cond_wait(&exit_cond, &exit_mutex);
+	/* Need to block these to avoid deadlocking */
+	sigemptyset(&set);
+	sigaddset(&set, SIGTERM);
+	sigaddset(&set, SIGINT);
+	pthread_sigmask(SIG_BLOCK, &set, NULL);
 
 	/*
 	 * exit path
 	 */
 	running_state = DAEMON_SHUTDOWN;
+	pthread_sigmask(SIG_UNBLOCK, &set, NULL);
 	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
-- 
1.7.4.2
