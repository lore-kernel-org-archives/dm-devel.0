From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 5/7] multipathd: Do not perform POSIX mutex
 operations inside a signal handler
Date: Wed, 27 Jul 2016 14:13:46 -0700
Message-ID: <6c9f14ff-89da-55cd-0cda-9bec5788d17a@sandisk.com>
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

According to the POSIX standard, only functions that are async-signal-safe
may be invoked from inside a signal handler. The only POSIX thread functions
that are async-signal-safe are pthread_kill(), pthread_self() and
pthread_sigmask(). See also
http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_04_03.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/main.c   | 12 +++++++++++-
 multipathd/uxlsnr.c |  2 --
 multipathd/uxlsnr.h |  3 ---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0cd822b..429921c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -117,6 +117,11 @@ struct udev * udev;
 
 struct config *multipath_conf;
 
+/* Local variables */
+static volatile sig_atomic_t exit_sig;
+static volatile sig_atomic_t reconfig_sig;
+static volatile sig_atomic_t log_reset_sig;
+
 const char *
 daemon_status(void)
 {
@@ -2070,6 +2075,10 @@ signal_set(int signo, void (*func) (int))
 void
 handle_signals(void)
 {
+	if (exit_sig) {
+		condlog(2, "exit (signal)");
+		exit_daemon();
+	}
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
 		set_config_state(DAEMON_CONFIGURE);
@@ -2080,6 +2089,7 @@ handle_signals(void)
 		log_reset("multipathd");
 		pthread_mutex_unlock(&logq_lock);
 	}
+	exit_sig = 0;
 	reconfig_sig = 0;
 	log_reset_sig = 0;
 }
@@ -2093,7 +2103,7 @@ sighup (int sig)
 static void
 sigend (int sig)
 {
-	exit_daemon();
+	exit_sig = 1;
 }
 
 static void
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 0159648..d2ef0b8 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -49,8 +49,6 @@ struct client {
 LIST_HEAD(clients);
 pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 struct pollfd *polls;
-volatile sig_atomic_t reconfig_sig = 0;
-volatile sig_atomic_t log_reset_sig = 0;
 
 /*
  * handle a new client joining
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index 7839fce..4ef47d5 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -6,7 +6,4 @@ typedef int (uxsock_trigger_fn)(char *, char **, int *, void *);
 void * uxsock_listen(uxsock_trigger_fn uxsock_trigger,
 		     void * trigger_data);
 
-extern volatile sig_atomic_t reconfig_sig;
-extern volatile sig_atomic_t log_reset_sig;
-
 #endif
-- 
2.9.2
