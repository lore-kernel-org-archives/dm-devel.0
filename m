From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/7] multipathd: open client socket early
Date: Wed, 24 Oct 2018 00:05:49 +0200
Message-ID: <20181023220552.1306-5-mwilck@suse.com>
References: <20181023220552.1306-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181023220552.1306-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Open the unix socket in multipathd code and pass the fd to
uxsock_listen(). This will enable us to make the main thread
wait for successful socket initialization in a follow-up patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   | 17 ++++++++++++++---
 multipathd/uxlsnr.c | 11 ++---------
 multipathd/uxlsnr.h |  2 +-
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 083abf28..50f69171 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -66,6 +66,7 @@ static int use_watchdog;
 #include "pgpolicies.h"
 #include "uevent.h"
 #include "log.h"
+#include "uxsock.h"
 
 #include "mpath_cmd.h"
 #include "mpath_persist.h"
@@ -1494,12 +1495,22 @@ uevqloop (void * ap)
 static void *
 uxlsnrloop (void * ap)
 {
+	int ux_sock;
+
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
+
+	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
+	if (ux_sock == -1)  {
+		condlog(1, "could not create uxsock: %d", errno);
+		exit_daemon();
+		return NULL;
+	}
+
 	if (cli_init()) {
 		condlog(1, "Failed to init uxsock listener");
 		return NULL;
 	}
-	pthread_cleanup_push(rcu_unregister, NULL);
-	rcu_register_thread();
 	set_handler_callback(LIST+PATHS, cli_list_paths);
 	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
 	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
@@ -1554,7 +1565,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(UNSETPRKEY+MAP, cli_unsetprkey);
 
 	umask(077);
-	uxsock_listen(&uxsock_trigger, ap);
+	uxsock_listen(&uxsock_trigger, ux_sock, ap);
 	pthread_cleanup_pop(1);
 	return NULL;
 }
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 6f666663..04967e9a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -165,22 +165,15 @@ void uxsock_cleanup(void *arg)
 /*
  * entry point
  */
-void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
+void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
+		     void * trigger_data)
 {
-	long ux_sock;
 	int rlen;
 	char *inbuf;
 	char *reply;
 	sigset_t mask;
 	int old_clients = MIN_POLLS;
 
-	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
-
-	if (ux_sock == -1) {
-		condlog(1, "could not create uxsock: %d", errno);
-		exit_daemon();
-	}
-
 	pthread_cleanup_push(uxsock_cleanup, (void *)ux_sock);
 
 	condlog(3, "uxsock: startup listener");
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index d51a8f99..c7f25b2b 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -5,7 +5,7 @@
 
 typedef int (uxsock_trigger_fn)(char *, char **, int *, bool, void *);
 
-void * uxsock_listen(uxsock_trigger_fn uxsock_trigger,
+void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 		     void * trigger_data);
 
 #endif
-- 
2.19.1
