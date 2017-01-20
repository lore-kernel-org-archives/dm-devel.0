From: Gris Ge <fge@redhat.com>
Subject: [PATCH 5/5] multipath-tools: Perform socket client uid
	check on IPC commands.
Date: Fri, 20 Jan 2017 21:39:02 +0800
Message-ID: <1484919542-11087-6-git-send-email-fge@redhat.com>
References: <1484919542-11087-1-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484919542-11087-1-git-send-email-fge@redhat.com>
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
 multipathd/main.c   | 12 +++++++++++-
 multipathd/uxlsnr.c | 19 +++++++++++++++++++
 multipathd/uxlsnr.h |  4 +++-
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index adc3258..1e64afc 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -23,6 +23,7 @@
 #endif
 #include <semaphore.h>
 #include <time.h>
+#include <stdbool.h>
 
 /*
  * libmultipath
@@ -1048,7 +1049,8 @@ map_discovery (struct vectors * vecs)
 }
 
 int
-uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
+uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
+		void * trigger_data)
 {
 	struct vectors * vecs;
 	int r;
@@ -1057,6 +1059,14 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
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
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 6ca62af..98ac25a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -22,6 +22,7 @@
 #include <poll.h>
 #include <sys/time.h>
 #include <signal.h>
+#include <stdbool.h>
 #include "checkers.h"
 #include "memory.h"
 #include "debug.h"
@@ -51,6 +52,23 @@ LIST_HEAD(clients);
 pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 struct pollfd *polls;
 
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
@@ -255,6 +273,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				condlog(4, "cli[%d]: Got request [%s]",
 					i, inbuf);
 				uxsock_trigger(inbuf, &reply, &rlen,
+					       _socket_client_is_root(c->fd),
 					       trigger_data);
 				if (reply) {
 					if (send_packet(c->fd,
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index 4ef47d5..d51a8f9 100644
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
1.8.3.1
