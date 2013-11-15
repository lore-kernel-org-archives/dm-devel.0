From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/13] libmultipath: do not stall on recv_packet()
Date: Fri, 15 Nov 2013 11:29:36 +0100
Message-ID: <1384511384-27642-6-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The CLI socket might have been closed or the daemon might have
been terminated by systemd without closing the CLI socket.
Hence we need to poll the socket if further data is avalailable,
otherwise the read() call will hang.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uxsock.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index ce89428..fcad56e 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -107,9 +107,24 @@ size_t write_all(int fd, const void *buf, size_t len)
 size_t read_all(int fd, void *buf, size_t len)
 {
 	size_t total = 0;
+	ssize_t n;
+	int ret;
+	struct pollfd pfd;
 
 	while (len) {
-		ssize_t n = read(fd, buf, len);
+		pfd.fd = fd;
+		pfd.events = POLLIN;
+		ret = poll(&pfd, 1, 1000);
+		if (!ret) {
+			errno = ETIMEDOUT;
+			return total;
+		} else if (ret < 0) {
+			if (errno == EINTR)
+				continue;
+			return total;
+		} else if (!pfd.revents & POLLIN)
+			continue;
+		n = read(fd, buf, len);
 		if (n < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
-- 
1.8.1.4
