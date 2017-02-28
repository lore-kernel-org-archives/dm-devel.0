From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/33] Invalid error code when using multipathd
	CLI
Date: Tue, 28 Feb 2017 17:23:01 +0100
Message-ID: <20170228162329.14517-6-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When calling the multipathd CLI we're getting the message

error -1 receiving packet

instead of the actual error number.
Problem is a confusion about the return values between
libmpathcmd and uxsock.c.
uxsock.c is assuming a negative return value to be the errno,
but libmpathcmd is returning -1 on error and setting errno.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathcmd/mpath_cmd.c | 4 ++++
 libmultipath/uxsock.c   | 9 +++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 856e6b48..1496b682 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -141,7 +141,11 @@ int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
 	*reply = NULL;
 	len = mpath_recv_reply_len(fd, timeout);
 	if (len <= 0)
+		return len;
+	if (len > MAX_REPLY_LEN) {
+		errno = EINVAL;
 		return -1;
+	}
 	*reply = malloc(len);
 	if (!*reply)
 		return -1;
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 492f4b9c..7e5a1449 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -88,7 +88,9 @@ int ux_socket_listen(const char *name)
  */
 int send_packet(int fd, const char *buf)
 {
-	return mpath_send_cmd(fd, buf);
+	if (mpath_send_cmd(fd, buf) < 0)
+		return -errno;
+	return 0;
 }
 
 static int _recv_packet(int fd, char **buf, unsigned int timeout, ssize_t limit)
@@ -98,8 +100,10 @@ static int _recv_packet(int fd, char **buf, unsigned int timeout, ssize_t limit)
 
 	*buf = NULL;
 	len = mpath_recv_reply_len(fd, timeout);
-	if (len <= 0)
+	if (len == 0)
 		return len;
+	if (len < 0)
+		return -errno;
 	if ((limit > 0) && (len > limit))
 		return -EINVAL;
 	(*buf) = MALLOC(len);
@@ -109,6 +113,7 @@ static int _recv_packet(int fd, char **buf, unsigned int timeout, ssize_t limit)
 	if (err != 0) {
 		FREE(*buf);
 		(*buf) = NULL;
+		return -errno;
 	}
 	return err;
 }
-- 
2.11.0
