From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 45/78] Return error when receiving CLI packet
Date: Mon, 16 Mar 2015 13:36:32 +0100
Message-ID: <1426509425-15978-46-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When receiving a packet from the CLI we should be returning
an error code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmpathpersist/mpath_updatepr.c | 20 ++++++++++++--------
 libmultipath/configure.c         |  2 +-
 libmultipath/defaults.h          |  1 +
 libmultipath/uxsock.c            | 30 +++++++++++++++++++-----------
 libmultipath/uxsock.h            |  4 ++--
 multipathd/main.c                |  4 ++--
 multipathd/uxclnt.c              | 26 +++++++++++++++++---------
 multipathd/uxclnt.h              |  2 +-
 multipathd/uxlsnr.c              |  3 ++-
 9 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 8597d40..dce580f 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -35,15 +35,19 @@ int update_prflag(char * arg1, char * arg2, int noisy)
 	snprintf(str,sizeof(str),"map %s %s", arg1, arg2);
 	condlog (2, "%s: pr flag message=%s", arg1, str);
 	send_packet(fd, str, strlen(str) + 1);
-	recv_packet(fd, &reply, &len);
-
-	condlog (2, "%s: message=%s reply=%s", arg1, str, reply);
-	if (!reply || strncmp(reply,"ok", 2) == 0)
-		ret = -1;
-	else if (strncmp(reply, "fail", 4) == 0)
+	ret = recv_packet(fd, &reply, &len, DEFAULT_UXSOCK_TIMEOUT);
+	if (ret < 0) {
+		condlog(2, "%s: message=%s error=%d", arg1, str, -ret);
 		ret = -2;
-	else{
-		ret = atoi(reply);
+	} else {
+		condlog (2, "%s: message=%s reply=%s", arg1, str, reply);
+		if (!reply || strncmp(reply,"ok", 2) == 0)
+			ret = -1;
+		else if (strncmp(reply, "fail", 4) == 0)
+			ret = -2;
+		else{
+			ret = atoi(reply);
+		}
 	}
 
 	free(reply);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3c230a1..720d074 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -714,7 +714,7 @@ int check_daemon(void)
 
 	if (send_packet(fd, "show daemon", 12) != 0)
 		goto out;
-	if (recv_packet(fd, &reply, &len) != 0)
+	if (recv_packet(fd, &reply, &len, DEFAULT_UXSOCK_TIMEOUT) != 0)
 		goto out;
 
 	if (strstr(reply, "shutdown"))
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 878da14..8902f40 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -20,6 +20,7 @@
 #define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF
 #define DEFAULT_UEVENT_STACKSIZE 256
+#define DEFAULT_UXSOCK_TIMEOUT  1000
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index aff7a62..af0798c 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -128,7 +128,7 @@ size_t write_all(int fd, const void *buf, size_t len)
 /*
  * keep reading until its all read
  */
-size_t read_all(int fd, void *buf, size_t len)
+ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
 {
 	size_t total = 0;
 	ssize_t n;
@@ -138,21 +138,20 @@ size_t read_all(int fd, void *buf, size_t len)
 	while (len) {
 		pfd.fd = fd;
 		pfd.events = POLLIN;
-		ret = poll(&pfd, 1, 1000);
+		ret = poll(&pfd, 1, timeout);
 		if (!ret) {
-			errno = ETIMEDOUT;
-			return total;
+			return -ETIMEDOUT;
 		} else if (ret < 0) {
 			if (errno == EINTR)
 				continue;
-			return total;
+			return -errno;
 		} else if (!pfd.revents & POLLIN)
 			continue;
 		n = read(fd, buf, len);
 		if (n < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
-			return total;
+			return -errno;
 		}
 		if (!n)
 			return total;
@@ -190,12 +189,20 @@ int send_packet(int fd, const char *buf, size_t len)
 /*
  * receive a packet in length prefix format
  */
-int recv_packet(int fd, char **buf, size_t *len)
+int recv_packet(int fd, char **buf, size_t *len, unsigned int timeout)
 {
-	if (read_all(fd, len, sizeof(*len)) != sizeof(*len)) {
+	ssize_t ret;
+
+	ret = read_all(fd, len, sizeof(*len), timeout);
+	if (ret < 0) {
 		(*buf) = NULL;
 		*len = 0;
-		return -1;
+		return ret;
+	}
+	if (ret < sizeof(*len)) {
+		(*buf) = NULL;
+		*len = 0;
+		return -EIO;
 	}
 	if (len == 0) {
 		(*buf) = NULL;
@@ -204,11 +211,12 @@ int recv_packet(int fd, char **buf, size_t *len)
 	(*buf) = MALLOC(*len);
 	if (!*buf)
 		return -1;
-	if (read_all(fd, *buf, *len) != *len) {
+	ret = read_all(fd, *buf, *len, timeout);
+	if (ret != *len) {
 		FREE(*buf);
 		(*buf) = NULL;
 		*len = 0;
-		return -1;
+		return ret < 0 ? ret : -EIO;
 	}
 	return 0;
 }
diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h
index fd82552..94af8d8 100644
--- a/libmultipath/uxsock.h
+++ b/libmultipath/uxsock.h
@@ -2,6 +2,6 @@
 int ux_socket_connect(const char *name);
 int ux_socket_listen(const char *name);
 int send_packet(int fd, const char *buf, size_t len);
-int recv_packet(int fd, char **buf, size_t *len);
+int recv_packet(int fd, char **buf, size_t *len, unsigned int timeout);
 size_t write_all(int fd, const void *buf, size_t len);
-size_t read_all(int fd, void *buf, size_t len);
+ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout);
diff --git a/multipathd/main.c b/multipathd/main.c
index ffe4326..9db2e55 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2023,7 +2023,7 @@ main (int argc, char *argv[])
 			logsink = -1;
 			break;
 		case 'k':
-			uxclnt(optarg);
+			uxclnt(optarg, DEFAULT_UXSOCK_TIMEOUT);
 			exit(0);
 		case 'B':
 			conf->bindings_read_only = 1;
@@ -2045,7 +2045,7 @@ main (int argc, char *argv[])
 			optind++;
 		}
 		c += snprintf(c, s + CMDSIZE - c, "\n");
-		uxclnt(s);
+		uxclnt(s, DEFAULT_UXSOCK_TIMEOUT);
 		exit(0);
 	}
 
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index e86be21..536579f 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -9,6 +9,7 @@
 #include <unistd.h>
 #include <stdarg.h>
 #include <fcntl.h>
+#include <errno.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -63,10 +64,11 @@ static int need_quit(char *str, size_t len)
 /*
  * process the client
  */
-static void process(int fd)
+static void process(int fd, unsigned int timeout)
 {
 	char *line;
 	char *reply;
+	int ret;
 
 	cli_init();
 	rl_readline_name = "multipathd";
@@ -84,7 +86,8 @@ static void process(int fd)
 			break;
 
 		if (send_packet(fd, line, llen + 1) != 0) break;
-		if (recv_packet(fd, &reply, &len) != 0) break;
+		ret = recv_packet(fd, &reply, &len, timeout);
+		if (ret != 0) break;
 
 		print_reply(reply);
 
@@ -96,18 +99,23 @@ static void process(int fd)
 	}
 }
 
-static void process_req(int fd, char * inbuf)
+static void process_req(int fd, char * inbuf, unsigned int timeout)
 {
 	char *reply;
 	size_t len;
+	int ret;
 
 	if (send_packet(fd, inbuf, strlen(inbuf) + 1) != 0) {
 		printf("cannot send packet\n");
 		return;
 	}
-	if (recv_packet(fd, &reply, &len) != 0)
-		printf("error receiving packet\n");
-	else {
+	ret = recv_packet(fd, &reply, &len, timeout);
+	if (ret < 0) {
+		if (ret == -ETIMEDOUT)
+			printf("timeout receiving packet\n");
+		else
+			printf("error %d receiving packet\n", ret);
+	} else {
 		printf("%s", reply);
 		FREE(reply);
 	}
@@ -116,7 +124,7 @@ static void process_req(int fd, char * inbuf)
 /*
  * entry point
  */
-int uxclnt(char * inbuf)
+int uxclnt(char * inbuf, unsigned int timeout)
 {
 	int fd;
 
@@ -125,9 +133,9 @@ int uxclnt(char * inbuf)
 		exit(1);
 
 	if (inbuf)
-		process_req(fd, inbuf);
+		process_req(fd, inbuf, timeout);
 	else
-		process(fd);
+		process(fd, timeout);
 
 	return 0;
 }
diff --git a/multipathd/uxclnt.h b/multipathd/uxclnt.h
index 0667a24..8e2cdce 100644
--- a/multipathd/uxclnt.h
+++ b/multipathd/uxclnt.h
@@ -1 +1 @@
-int uxclnt(char * inbuf);
+int uxclnt(char * inbuf, unsigned int timeout);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index ed8e012..624d4eb 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -158,7 +158,8 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 			struct client *next = c->next;
 
 			if (polls[i].revents & POLLIN) {
-				if (recv_packet(c->fd, &inbuf, &len) != 0) {
+				if (recv_packet(c->fd, &inbuf, &len,
+						DEFAULT_UXSOCK_TIMEOUT) != 0) {
 					dead_client(c);
 				} else {
 					inbuf[len - 1] = 0;
-- 
1.8.4.5
