From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 4/7] multipathd: open client socket early
Date: Fri,  2 Nov 2018 13:23:59 +0100
Message-ID: <20181102122402.31145-5-mwilck@suse.com>
References: <20181102122402.31145-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122402.31145-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Open the unix socket in multipathd code and pass the fd to
uxsock_listen(). This will enable us to make the main thread
wait for successful socket initialization in a follow-up patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   | 27 ++++++++++++++++++++++-----
 multipathd/uxlsnr.c | 14 ++------------
 multipathd/uxlsnr.h |  5 +++--
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index a022bdb5..a91a14c6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -66,6 +66,7 @@ static int use_watchdog;
 #include "pgpolicies.h"
 #include "uevent.h"
 #include "log.h"
+#include "uxsock.h"
 
 #include "mpath_cmd.h"
 #include "mpath_persist.h"
@@ -1496,12 +1497,24 @@ uevqloop (void * ap)
 static void *
 uxlsnrloop (void * ap)
 {
+	long ux_sock;
+
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
+
+	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
+	if (ux_sock == -1) {
+		condlog(1, "could not create uxsock: %d", errno);
+		exit_daemon();
+		goto out;
+	}
+	pthread_cleanup_push(uxsock_cleanup, (void *)ux_sock);
+
 	if (cli_init()) {
 		condlog(1, "Failed to init uxsock listener");
-		return NULL;
+		exit_daemon();
+		goto out_sock;
 	}
-	pthread_cleanup_push(rcu_unregister, NULL);
-	rcu_register_thread();
 	set_handler_callback(LIST+PATHS, cli_list_paths);
 	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
 	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
@@ -1556,8 +1569,12 @@ uxlsnrloop (void * ap)
 	set_handler_callback(UNSETPRKEY+MAP, cli_unsetprkey);
 
 	umask(077);
-	uxsock_listen(&uxsock_trigger, ap);
-	pthread_cleanup_pop(1);
+	uxsock_listen(&uxsock_trigger, ux_sock, ap);
+
+out_sock:
+	pthread_cleanup_pop(1); /* uxsock_cleanup */
+out:
+	pthread_cleanup_pop(1); /* rcu_unregister */
 	return NULL;
 }
 
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 6f666663..773bc878 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -165,24 +165,15 @@ void uxsock_cleanup(void *arg)
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
-	pthread_cleanup_push(uxsock_cleanup, (void *)ux_sock);
-
 	condlog(3, "uxsock: startup listener");
 	polls = (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct pollfd));
 	if (!polls) {
@@ -322,6 +313,5 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		}
 	}
 
-	pthread_cleanup_pop(1);
 	return NULL;
 }
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index d51a8f99..18f008d7 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -5,7 +5,8 @@
 
 typedef int (uxsock_trigger_fn)(char *, char **, int *, bool, void *);
 
-void * uxsock_listen(uxsock_trigger_fn uxsock_trigger,
-		     void * trigger_data);
+void uxsock_cleanup(void *arg);
+void *uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
+		    void * trigger_data);
 
 #endif
-- 
2.19.1
