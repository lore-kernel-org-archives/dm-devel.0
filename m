From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 07/16] Fix some socket issues
Date: Thu,  2 May 2013 16:46:28 -0500
Message-ID: <1367531197-8987-8-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

multipath wasn't acutally using /org/kernel/linux/storage/multipathd
for its local socket because when it created and bound to that
socket, it didn't include the size of the structure in the length
it passed with the call.  The result was a trucnated name. Also,
mpathpersist wasn't updated to use the new socket name. This patch
fixes both.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_updatepr.c | 3 ++-
 libmultipath/uxsock.c            | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 2982947..8597d40 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -14,6 +14,7 @@
 #include <debug.h>
 #include "memory.h"
 #include "../libmultipath/uxsock.h"
+#include "../libmultipath/defaults.h"
 
 unsigned long mem_allocated;    /* Total memory used in Bytes */
 
@@ -25,7 +26,7 @@ int update_prflag(char * arg1, char * arg2, int noisy)
 	size_t len;
 	int ret = 0;
 
-	fd = ux_socket_connect("/var/run/multipathd.sock");
+	fd = ux_socket_connect(DEFAULT_SOCKET);
 	if (fd == -1) {
 		condlog (0, "ux socket connect error");
 		return 1 ;
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index f3e8dec..ce89428 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -31,7 +31,7 @@ int ux_socket_connect(const char *name)
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
 	addr.sun_path[0] = '\0';
-	len = strlen(name) + 1;
+	len = strlen(name) + 1 + sizeof(sa_family_t);
 	strncpy(&addr.sun_path[1], name, len);
 
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
@@ -62,7 +62,7 @@ int ux_socket_listen(const char *name)
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
 	addr.sun_path[0] = '\0';
-	len = strlen(name) + 1;
+	len = strlen(name) + 1 + sizeof(sa_family_t);
 	strncpy(&addr.sun_path[1], name, len);
 
 	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
-- 
1.8.2
