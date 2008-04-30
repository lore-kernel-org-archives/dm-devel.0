From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] [libmultipath] block SIGPIPE before writing to a
	pipe
Date: Wed, 30 Apr 2008 11:01:04 +0200
Message-ID: <20080430090104.58EC718C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


We have to block SIGPIPE before we're writing to the communication
pipe otherwise the daemon will be killed if the listening program
terminates prematurely.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uxsock.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index abb9f85..cdc3dbc 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -14,6 +14,7 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <sys/poll.h>
+#include <signal.h>
 #include <errno.h>
 
 #include "memory.h"
@@ -127,9 +128,25 @@ size_t read_all(int fd, void *buf, size_t len)
  */
 int send_packet(int fd, const char *buf, size_t len)
 {
-	if (write_all(fd, &len, sizeof(len)) != sizeof(len)) return -1;
-	if (write_all(fd, buf, len) != len) return -1;	
-	return 0;
+	int ret = 0;
+#ifdef DAEMON
+	sigset_t set, old;
+
+	/* Block SIGPIPE */
+	sigemptyset(&set);
+	sigaddset(&set, SIGPIPE);
+	pthread_sigmask(SIG_BLOCK, &set, &old);
+#endif	
+	if (write_all(fd, &len, sizeof(len)) != sizeof(len)) 
+		ret = -1;
+	if (!ret && write_all(fd, buf, len) != len)
+		ret = -1;	
+
+#ifdef DAEMON
+	/* And unblock it again */
+	pthread_sigmask(SIG_SETMASK, &old, NULL);
+#endif	
+	return ret;
 }
 
 /*
-- 
1.5.2.4
