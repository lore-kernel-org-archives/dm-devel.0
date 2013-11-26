From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/9] Clarify uxsock logging
Date: Tue, 26 Nov 2013 12:41:22 +0100
Message-ID: <1385466090-24290-2-git-send-email-hare@suse.de>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1385466090-24290-1-git-send-email-hare@suse.de>
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

Socket creation might fail on various stages, so print out a
proper logging message.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uxsock.c | 11 +++++++++--
 multipathd/uxclnt.c   |  4 +---
 multipathd/uxlsnr.c   |  4 +---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index fcad56e..e93edff 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -19,6 +19,7 @@
 
 #include "memory.h"
 #include "uxsock.h"
+#include "debug.h"
 
 /*
  * connect to a unix domain socket
@@ -36,10 +37,12 @@ int ux_socket_connect(const char *name)
 
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1) {
+		condlog(3, "Couldn't create ux_socket, error %d", errno);
 		return -1;
 	}
 
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
+		condlog(3, "Couldn't connect to ux_socket, error %d", errno);
 		close(fd);
 		return -1;
 	}
@@ -57,7 +60,10 @@ int ux_socket_listen(const char *name)
 	struct sockaddr_un addr;
 
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
-	if (fd == -1) return -1;
+	if (fd == -1) {
+		condlog(3, "Couldn't create ux_socket, error %d", errno);
+		return -1;
+	}
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
@@ -66,15 +72,16 @@ int ux_socket_listen(const char *name)
 	strncpy(&addr.sun_path[1], name, len);
 
 	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
+		condlog(3, "Couldn't bind to ux_socket, error %d", errno);
 		close(fd);
 		return -1;
 	}
 
 	if (listen(fd, 10) == -1) {
+		condlog(3, "Couldn't listen to ux_socket, error %d", errno);
 		close(fd);
 		return -1;
 	}
-
 	return fd;
 }
 
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 3e4e381..e86be21 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -121,10 +121,8 @@ int uxclnt(char * inbuf)
 	int fd;
 
 	fd = ux_socket_connect(DEFAULT_SOCKET);
-	if (fd == -1) {
-		perror("ux_socket_connect");
+	if (fd == -1)
 		exit(1);
-	}
 
 	if (inbuf)
 		process_req(fd, inbuf);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index c0ddd8d..ed8e012 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -112,10 +112,8 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 
 	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
 
-	if (ux_sock == -1) {
-		condlog(0, "ux_socket_listen error");
+	if (ux_sock == -1)
 		exit(1);
-	}
 
 	pthread_cleanup_push(uxsock_cleanup, NULL);
 
-- 
1.8.1.4
