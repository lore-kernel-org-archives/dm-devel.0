From: Gris Ge <fge@redhat.com>
Subject: [PATCH 2/5] multipath-tools: libmultipath: Removed
	unused functions.
Date: Fri, 20 Jan 2017 21:38:59 +0800
Message-ID: <1484919542-11087-3-git-send-email-fge@redhat.com>
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

 * Removed these unused functions from libmultipath:
    * write_all()
    * read_all()

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmultipath/uxsock.c | 60 ---------------------------------------------------
 libmultipath/uxsock.h |  2 --
 2 files changed, 62 deletions(-)

diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index b158a56..0ca9e50 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -74,66 +74,6 @@ int ux_socket_listen(const char *name)
 }
 
 /*
- * keep writing until it's all sent
- */
-size_t write_all(int fd, const void *buf, size_t len)
-{
-	size_t total = 0;
-
-	while (len) {
-		ssize_t n = send(fd, buf, len, MSG_NOSIGNAL);
-		if (n < 0) {
-			if ((errno == EINTR) || (errno == EAGAIN))
-				continue;
-			return total;
-		}
-		if (!n)
-			return total;
-		buf = n + (char *)buf;
-		len -= n;
-		total += n;
-	}
-	return total;
-}
-
-/*
- * keep reading until its all read
- */
-ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
-{
-	size_t total = 0;
-	ssize_t n;
-	int ret;
-	struct pollfd pfd;
-
-	while (len) {
-		pfd.fd = fd;
-		pfd.events = POLLIN;
-		ret = poll(&pfd, 1, timeout);
-		if (!ret) {
-			return -ETIMEDOUT;
-		} else if (ret < 0) {
-			if (errno == EINTR)
-				continue;
-			return -errno;
-		} else if (!(pfd.revents & POLLIN))
-			continue;
-		n = read(fd, buf, len);
-		if (n < 0) {
-			if ((errno == EINTR) || (errno == EAGAIN))
-				continue;
-			return -errno;
-		}
-		if (!n)
-			return total;
-		buf = n + (char *)buf;
-		len -= n;
-		total += n;
-	}
-	return total;
-}
-
-/*
  * send a packet in length prefix format
  */
 int send_packet(int fd, const char *buf)
diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h
index c1cf81f..442b564 100644
--- a/libmultipath/uxsock.h
+++ b/libmultipath/uxsock.h
@@ -2,5 +2,3 @@
 int ux_socket_listen(const char *name);
 int send_packet(int fd, const char *buf);
 int recv_packet(int fd, char **buf, unsigned int timeout);
-size_t write_all(int fd, const void *buf, size_t len);
-ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout);
-- 
1.8.3.1
