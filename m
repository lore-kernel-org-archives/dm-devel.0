From: Gris Ge <fge@redhat.com>
Subject: [PATCH 3/5] multipath-tools: New way to limit the IPC
	command length.
Date: Fri, 20 Jan 2017 21:39:00 +0800
Message-ID: <1484919542-11087-4-git-send-email-fge@redhat.com>
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

    mpath_recv_reply() from libmpathcmd return -EINVAL on command 'show
    maps json' with 2k paths.  No error will be triggered for command
    `multipathd -k'show maps json` as multipathd is using their own
    implementation on recv_packet() which does not have size limitation.

Root cause:

    Commit 174e717d351789a3cb29e1417f8e910baabcdb16 introduced the
    limitation on max bytes(65535) of reply string from multipathd.
    With 2k paths(1k mpaths) simulated by scsi_debug, the 'show maps json'
    requires 2066784 bytes which trigged the EINVAL error.

Fix:
    * Remove the limitation of MAX_REPLY_LEN in libmpathcmd.

    * New functions `recv_packet_from_client()` in uxsock.h of libmultipath
      which enforce the limitation of buffer size to 512(_MAX_CMD_LEN).

    * Change multipathd socket listener to use
      `recv_packet_from_client()`.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmpathcmd/mpath_cmd.c |  2 --
 libmultipath/uxsock.c   | 39 ++++++++++++++++++++++++++++++---------
 libmultipath/uxsock.h   |  9 +++++++++
 multipathd/uxlsnr.c     |  8 +++++---
 4 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index d9c5790..7fc9e98 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -142,8 +142,6 @@ int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
 	len = mpath_recv_reply_len(fd, timeout);
 	if (len <= 0)
 		return len;
-	if (len > MAX_REPLY_LEN)
-		return -EINVAL;
 	*reply = malloc(len);
 	if (!*reply)
 		return -1;
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 0ca9e50..492f4b9 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -24,6 +24,16 @@
 #include "memory.h"
 #include "uxsock.h"
 #include "debug.h"
+
+/*
+ * Code is similar with mpath_recv_reply() with data size limitation
+ * and debug-able malloc.
+ * When limit == 0, it means no limit on data size, used for socket client
+ * to receiving data from multipathd.
+ */
+static int _recv_packet(int fd, char **buf, unsigned int timeout,
+			ssize_t limit);
+
 /*
  * create a unix domain socket and start listening on it
  * return a file descriptor open on the socket
@@ -81,26 +91,37 @@ int send_packet(int fd, const char *buf)
 	return mpath_send_cmd(fd, buf);
 }
 
-/*
- * receive a packet in length prefix format
- */
-int recv_packet(int fd, char **buf, unsigned int timeout)
+static int _recv_packet(int fd, char **buf, unsigned int timeout, ssize_t limit)
 {
-	int err;
-	ssize_t len;
+	int err = 0;
+	ssize_t len = 0;
 
 	*buf = NULL;
 	len = mpath_recv_reply_len(fd, timeout);
 	if (len <= 0)
 		return len;
+	if ((limit > 0) && (len > limit))
+		return -EINVAL;
 	(*buf) = MALLOC(len);
 	if (!*buf)
 		return -ENOMEM;
 	err = mpath_recv_reply_data(fd, *buf, len, timeout);
-	if (err) {
+	if (err != 0) {
 		FREE(*buf);
 		(*buf) = NULL;
-		return err;
 	}
-	return 0;
+	return err;
+}
+
+/*
+ * receive a packet in length prefix format
+ */
+int recv_packet(int fd, char **buf, unsigned int timeout)
+{
+	return _recv_packet(fd, buf, timeout, 0 /* no limit */);
+}
+
+int recv_packet_from_client(int fd, char **buf, unsigned int timeout)
+{
+	return _recv_packet(fd, buf, timeout, _MAX_CMD_LEN);
 }
diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h
index 442b564..8e7401d 100644
--- a/libmultipath/uxsock.h
+++ b/libmultipath/uxsock.h
@@ -2,3 +2,12 @@
 int ux_socket_listen(const char *name);
 int send_packet(int fd, const char *buf);
 int recv_packet(int fd, char **buf, unsigned int timeout);
+
+#define _MAX_CMD_LEN		512
+
+/*
+ * Used for receiving socket command from untrusted socket client where data
+ * size is restricted to 512(_MAX_CMD_LEN) at most.
+ * Return -EINVAL if data length requested by client exceeded the _MAX_CMD_LEN.
+ */
+int recv_packet_from_client(int fd, char **buf, unsigned int timeout);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index dfef03e..6ca62af 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -241,13 +241,15 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				if (clock_gettime(CLOCK_MONOTONIC, &start_time)
 				    != 0)
 					start_time.tv_sec = 0;
-				if (recv_packet(c->fd, &inbuf,
-						uxsock_timeout) != 0) {
+				if (recv_packet_from_client(c->fd, &inbuf,
+							    uxsock_timeout)
+				    != 0) {
 					dead_client(c);
 					continue;
 				}
 				if (!inbuf) {
-					condlog(4, "recv_packet get null request");
+					condlog(4, "recv_packet_from_client "
+						"get null request");
 					continue;
 				}
 				condlog(4, "cli[%d]: Got request [%s]",
-- 
1.8.3.1
