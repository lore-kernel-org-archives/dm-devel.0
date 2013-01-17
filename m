From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/11] multipathd: switch to abstract sockets for
	CLI commands
Date: Thu, 17 Jan 2013 15:59:29 +0100
Message-ID: <1358434773-2002-8-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
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

Instead of using file-based sockets we should be switching to
abstract sockets. Otherwise multipathd won't be able to start
if the directory is not available.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/defaults.h |    2 +-
 libmultipath/uxsock.c   |   27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 32948d8..b83d9fb 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -24,7 +24,7 @@
 
 #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
 #define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
-#define DEFAULT_SOCKET		"/var/run/multipathd.sock"
+#define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index e786899..f3e8dec 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -25,19 +25,21 @@
  */
 int ux_socket_connect(const char *name)
 {
-	int fd;
+	int fd, len;
 	struct sockaddr_un addr;
 
 	memset(&addr, 0, sizeof(addr));
-	addr.sun_family = AF_UNIX;
-	strncpy(addr.sun_path, name, sizeof(addr.sun_path));
+	addr.sun_family = AF_LOCAL;
+	addr.sun_path[0] = '\0';
+	len = strlen(name) + 1;
+	strncpy(&addr.sun_path[1], name, len);
 
-	fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1) {
 		return -1;
 	}
 
-	if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
+	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
 		close(fd);
 		return -1;
 	}
@@ -51,20 +53,19 @@ int ux_socket_connect(const char *name)
  */
 int ux_socket_listen(const char *name)
 {
-	int fd;
+	int fd, len;
 	struct sockaddr_un addr;
 
-	/* get rid of any old socket */
-	unlink(name);
-
-	fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1) return -1;
 
 	memset(&addr, 0, sizeof(addr));
-	addr.sun_family = AF_UNIX;
-	strncpy(addr.sun_path, name, sizeof(addr.sun_path));
+	addr.sun_family = AF_LOCAL;
+	addr.sun_path[0] = '\0';
+	len = strlen(name) + 1;
+	strncpy(&addr.sun_path[1], name, len);
 
-	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
+	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
 		close(fd);
 		return -1;
 	}
-- 
1.7.10.4
