From: Gris Ge <fge@redhat.com>
Subject: [PATCH] multipath-tools: Perform socket client uid check
	on IPC commands.
Date: Mon, 18 Jul 2016 14:26:19 +0800
Message-ID: <20160718062619.39837-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

Problem:
    A non-root user could send and execute 'shutdown' IPC command to
    multipathd.

Fix:
    Use getsockopt() to find out socket client uid, only query (list or
    show) command are allowed for non-root(uid != 0) socket connection.
    An error message "permission deny: need to be root" will be sent
    otherwise.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 multipathd/main.c   | 13 +++++++++++--
 multipathd/uxlsnr.c | 19 +++++++++++++++++++
 multipathd/uxlsnr.h |  4 +++-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c129298..97843bb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1008,7 +1008,8 @@ map_discovery (struct vectors * vecs)
 }
 
 int
-uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
+uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
+		void * trigger_data)
 {
 	struct vectors * vecs;
 	int r;
@@ -1017,6 +1018,14 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	*len = 0;
 	vecs = (struct vectors *)trigger_data;
 
+	if ((str != NULL) && (is_root == false) &&
+	    (strncmp(str, "list", strlen("list")) != 0) &&
+	    (strncmp(str, "show", strlen("show")) != 0)) {
+		*reply = STRDUP("permission deny: need to be root");
+		*len = strlen(*reply) + 1;
+		return 1;
+	}
+
 	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
 
 	if (r > 0) {
@@ -1520,7 +1529,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			} else if (ret == PATHINFO_SKIPPED) {
 				put_multipath_config(conf);
 				return -1;
-			} 
+			}
 			put_multipath_config(conf);
 		}
 		return 0;
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index abd1486..347dd13 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -32,6 +32,7 @@
 #include <defaults.h>
 #include <config.h>
 #include <mpath_cmd.h>
+#include <stdbool.h>
 
 #include "main.h"
 #include "cli.h"
@@ -52,6 +53,23 @@ struct pollfd *polls;
 volatile sig_atomic_t reconfig_sig = 0;
 volatile sig_atomic_t log_reset_sig = 0;
 
+static bool _socket_client_is_root(int fd);
+
+static bool _socket_client_is_root(int fd)
+{
+	socklen_t len = 0;
+	struct ucred uc;
+
+	len = sizeof(struct ucred);
+	if ((fd >= 0) &&
+	    (getsockopt(fd, SOL_SOCKET, SO_PEERCRED, &uc, &len) == 0) &&
+	    (uc.uid == 0))
+			return true;
+
+	/* Treat error as not root client */
+	return false;
+}
+
 /*
  * handle a new client joining
  */
@@ -242,6 +260,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				condlog(4, "cli[%d]: Got request [%s]",
 					i, inbuf);
 				uxsock_trigger(inbuf, &reply, &rlen,
+					       _socket_client_is_root(c->fd),
 					       trigger_data);
 				if (reply) {
 					if (send_packet(c->fd,
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index d274b04..f53c7b9 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -1,7 +1,9 @@
 #ifndef _UXLSNR_H
 #define _UXLSNR_H
 
-typedef int (uxsock_trigger_fn)(char *, char **, int *, void *);
+#include <stdbool.h>
+
+typedef int (uxsock_trigger_fn)(char *, char **, int *, bool, void *);
 
 void * uxsock_listen(uxsock_trigger_fn uxsock_trigger,
 		     void * trigger_data);
-- 
2.9.0
