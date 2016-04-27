From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 43/57] multipathd: set uxsock_timeout after
	reconfiguration
Date: Wed, 27 Apr 2016 13:10:44 +0200
Message-ID: <1461755458-29225-44-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

We should be setting the global variable 'uxsock_timeout' after
reconfiguration, not from within the uxsock_listen() function.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c   |  5 +++++
 multipathd/main.h   |  1 +
 multipathd/uxlsnr.c | 15 ++++-----------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c56672a..ebb9a50 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -34,6 +34,8 @@
 static int use_watchdog;
 #endif
 
+int uxsock_timeout;
+
 /*
  * libmultipath
  */
@@ -1700,6 +1702,7 @@ reconfigure (struct vectors * vecs)
 	} else {
 		conf = old;
 	}
+	uxsock_timeout = conf->uxsock_timeout;
 
 	running_state = DAEMON_RUNNING;
 
@@ -1933,6 +1936,8 @@ child (void * param)
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		goto failed;
 
+	uxsock_timeout = conf->uxsock_timeout;
+
 	dm_drv_version(conf->version, TGT_MPATH);
 	if (init_checkers()) {
 		condlog(0, "failed to initialize checkers");
diff --git a/multipathd/main.h b/multipathd/main.h
index 2f706d2..d1a6d71 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -15,6 +15,7 @@ struct prout_param_descriptor;
 struct prin_resp;
 
 extern pid_t daemon_pid;
+extern int uxsock_timeout;
 
 void exit_daemon(void);
 const char * daemon_status(void);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 77efa8a..9912e00 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -131,7 +131,7 @@ void uxsock_cleanup(void *arg)
 void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 {
 	int ux_sock;
-	int rlen, timeout;
+	int rlen;
 	char *inbuf;
 	char *reply;
 	sigset_t mask;
@@ -164,14 +164,6 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		struct client *c, *tmp;
 		int i, poll_count, num_clients;
 
-		/*
-		 * Store configuration timeout;
-		 * configuration might change during
-		 * the call to 'reconfigure'.
-		 */
-		if (conf)
-			timeout = conf->uxsock_timeout;
-
 		/* setup for a poll */
 		pthread_mutex_lock(&client_lock);
 		num_clients = 0;
@@ -247,7 +239,8 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				}
 				if (gettimeofday(&start_time, NULL) != 0)
 					start_time.tv_sec = 0;
-				if (recv_packet(c->fd, &inbuf, timeout) != 0) {
+				if (recv_packet(c->fd, &inbuf,
+						uxsock_timeout) != 0) {
 					dead_client(c);
 					continue;
 				}
@@ -268,7 +261,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 					reply = NULL;
 				}
 				check_timeout(start_time, inbuf,
-					      timeout);
+					      uxsock_timeout);
 				FREE(inbuf);
 			}
 		}
-- 
2.6.6
