From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/7] multipathd: Ensure that SIGINT, SIGTERM,
 SIGHUP and SIGUSR1 are delivered to the uxsock thread
Date: Wed, 27 Jul 2016 14:14:08 -0700
Message-ID: <3aaf112e-4c52-71a8-c76f-aa211e335789@sandisk.com>
References: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The POSIX standard mentions that the only way to guarantee that signals
are delivered to a specific thread is:
* Block all signals before the first pthread_create() call.
* Unblock signals from the thread that should receive signals.

Implement that approach in multipathd. And since ppoll() can return 0
if interrupted, also call handle_signals() if ppoll() returns 0.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/main.c   |  7 ++-----
 multipathd/uxlsnr.c | 12 ++++++++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 429921c..f4c8245 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2124,11 +2124,8 @@ signal_init(void)
 	sigset_t set;
 
 	sigemptyset(&set);
-	sigaddset(&set, SIGHUP);
-	sigaddset(&set, SIGUSR1);
-	sigaddset(&set, SIGUSR2);
-	sigaddset(&set, SIGALRM);
-	pthread_sigmask(SIG_BLOCK, &set, NULL);
+	sigaddset(&set, SIGPIPE);
+	pthread_sigmask(SIG_SETMASK, &set, NULL);
 
 	signal_set(SIGHUP, sighup);
 	signal_set(SIGUSR1, sigusr1);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index d2ef0b8..f114e59 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -150,9 +150,11 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		condlog(0, "uxsock: failed to allocate poll fds");
 		return NULL;
 	}
-	pthread_sigmask(SIG_SETMASK, NULL, &mask);
-	sigdelset(&mask, SIGHUP);
-	sigdelset(&mask, SIGUSR1);
+	sigemptyset(&mask);
+	sigaddset(&mask, SIGINT);
+	sigaddset(&mask, SIGTERM);
+	sigaddset(&mask, SIGHUP);
+	sigaddset(&mask, SIGUSR1);
 	while (1) {
 		struct client *c, *tmp;
 		int i, poll_count, num_clients;
@@ -208,8 +210,10 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 			break;
 		}
 
-		if (poll_count == 0)
+		if (poll_count == 0) {
+			handle_signals();
 			continue;
+		}
 
 		/* see if a client wants to speak to us */
 		for (i = 1; i < num_clients + 1; i++) {
-- 
2.9.2
