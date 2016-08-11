From: tang.junhui@zte.com.cn
Subject: [PATCH] multipathd: fix some small bugs for cli socket
Date: Thu, 11 Aug 2016 19:01:20 +0800
Message-ID: <1470913280-1820-1-git-send-email-tang.junhui@zte.com.cn>
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

1) mpath_recv_reply_len() should return error when the length which received by read_all() is wrong;
2) The buffer which *reply point to maybe null when mpath_recv_reply() return with success,
   so the caller needs to determine whether it is null, and then to use
   it.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmpathcmd/mpath_cmd.c | 2 +-
 multipathd/uxclnt.c     | 3 +++
 multipathd/uxlsnr.c     | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 2290ecb..c058479 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -112,7 +112,7 @@ ssize_t mpath_recv_reply_len(int fd, unsigned int timeout)
 		return ret;
 	if (ret != sizeof(len)) {
 		errno = EIO;
-		return ret;
+		return -1;
 	}
 	return len;
 }
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 62ff6f4..c5c32ea 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -28,6 +28,9 @@
 
 static void print_reply(char *s)
 {
+	if (!s)
+		return;
+
 	if (isatty(1)) {
 		printf("%s", s);
 		return;
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index fa29b2a..7a9faf3 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -243,6 +243,10 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 					dead_client(c);
 					continue;
 				}
+				if (!inbuf) {
+					condlog(4, "recv_packet get null request");
+					continue;
+				}
 				condlog(4, "cli[%d]: Got request [%s]",
 					i, inbuf);
 				uxsock_trigger(inbuf, &reply, &rlen,
-- 
2.8.1.windows.1
