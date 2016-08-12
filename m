From: Gris Ge <fge@redhat.com>
Subject: [PATCH V7 1/4] libmpathcmd: Block SIGPIPE when write()
Date: Fri, 12 Aug 2016 20:12:37 +0800
Message-ID: <20160812121240.47796-2-fge@redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160812121240.47796-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160812121240.47796-1-fge@redhat.com>
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

 * Just block SIGPIPE when write() and restore it when done.
 * Use 'errno_save()' to preserve the errno of write().

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmpathcmd/mpath_cmd.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 2290ecb..0daaf53 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -7,6 +7,7 @@
 #include <poll.h>
 #include <string.h>
 #include <errno.h>
+#include <signal.h>
 
 #include "mpath_cmd.h"
 
@@ -54,20 +55,33 @@ static ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
 static size_t write_all(int fd, const void *buf, size_t len)
 {
 	size_t total = 0;
+	sigset_t set, old;
+	int errno_save = 0;
+
+	/* Block SIGPIPE */
+	sigemptyset(&set);
+	sigaddset(&set, SIGPIPE);
+	pthread_sigmask(SIG_BLOCK, &set, &old);
 
 	while (len) {
 		ssize_t n = write(fd, buf, len);
+		errno_save = errno;
 		if (n < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
-			return total;
+			goto out;
 		}
 		if (!n)
-			return total;
+			goto out;
 		buf = n + (char *)buf;
 		len -= n;
 		total += n;
 	}
+out:
+	/* And unblock it again */
+	pthread_sigmask(SIG_SETMASK, &old, NULL);
+	errno = errno_save;
+
 	return total;
 }
 
-- 
2.9.2
