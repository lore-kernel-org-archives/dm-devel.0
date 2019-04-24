From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2] multipath -u: test socket connection in
	non-blocking mode
Date: Wed, 24 Apr 2019 11:07:59 +0200
Message-ID: <20190424090759.29796-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Since commit d7188fcd "multipathd: start daemon after udev trigger",
multipathd startup is delayed during boot until after "udev settle"
terminates. But "multipath -u" is run by udev workers for storage devices,
and attempts to connect to the multipathd socket. This causes a start job
for multipathd to be scheduled by systemd, but that job won't be started
until "udev settle" finishes. This is not a problem on systems with 129 or
less storage units, because the connect() call of "multipath -u" will
succeed anyway. But on larger systems, the listen backlog of the systemd
socket can be exceeded, which causes connect() calls for the socket to
block until multipathd starts up and begins calling accept(). This creates
a deadlock situation, because "multipath -u" (called by udev workers)
blocks, and thus "udev settle" doesn't finish, delaying multipathd
startup. This situation then persists until either the workers or "udev
settle" time out. In the former case, path devices might be misclassified
as non-multipath devices by "multipath -u".

Fix this by using a non-blocking socket fd for connect() and interpret the
errno appropriately.

This patch reverts most of the changes from commit 8cdf6661 "multipath:
check on multipathd without starting it". Instead, "multipath -u" does
access the socket and start multipath again (which is what we want IMO),
but it is now able to detect and handle the "full backlog" situation.

Signed-off-by: Martin Wilck <mwilck@suse.com>

V2:

Use same error reporting convention in __mpath_connect() as in
mpath_connect() (Hannes Reinecke). We can't easily change the latter,
because it's part of the "public" libmpathcmd API. 

---
 libmpathcmd/mpath_cmd.c | 24 +++++++++++++-
 libmpathcmd/mpath_cmd.h | 15 +++++++++
 multipath/main.c        | 70 +++++++++++++----------------------------
 3 files changed, 60 insertions(+), 49 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index df4ca541..b681311b 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -26,6 +26,7 @@
 #include <poll.h>
 #include <string.h>
 #include <errno.h>
+#include <fcntl.h>
 
 #include "mpath_cmd.h"
 
@@ -93,10 +94,11 @@ static size_t write_all(int fd, const void *buf, size_t len)
 /*
  * connect to a unix domain socket
  */
-int mpath_connect(void)
+int __mpath_connect(int nonblocking)
 {
 	int fd, len;
 	struct sockaddr_un addr;
+	int flags = 0;
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
@@ -108,14 +110,34 @@ int mpath_connect(void)
 	if (fd == -1)
 		return -1;
 
+	if (nonblocking) {
+		flags = fcntl(fd, F_GETFL, 0);
+		if (flags != -1)
+			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
+	}
+
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
+		int err = errno;
+
 		close(fd);
+		errno = err;
 		return -1;
 	}
 
+	if (nonblocking && flags != -1)
+		(void)fcntl(fd, F_SETFL, flags);
+
 	return fd;
 }
 
+/*
+ * connect to a unix domain socket
+ */
+int mpath_connect(void)
+{
+	return __mpath_connect(0);
+}
+
 int mpath_disconnect(int fd)
 {
 	return close(fd);
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index 15aeb067..ccfd35f2 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -34,6 +34,21 @@ extern "C" {
 #define DEFAULT_REPLY_TIMEOUT	4000
 
 
+/*
+ * DESCRIPTION:
+ *	Same as mpath_connect() (see below) except for the "nonblocking"
+ *	parameter.
+ *	If "nonblocking" is set, connects in non-blocking mode. This is
+ *	useful to avoid blocking if the listening socket's backlog is
+ *	exceeded. In this case, errno will be set to EAGAIN.
+ *	In case of success, the returned file descriptor is in in blocking
+ *	mode, even if "nonblocking" was true.
+ *
+ * RETURNS:
+ *	A file descriptor on success. -1 on failure (with errno set).
+ */
+int __mpath_connect(int nonblocking);
+
 /*
  * DESCRIPTION:
  *	Connect to the running multipathd daemon. On systems with the
diff --git a/multipath/main.c b/multipath/main.c
index 008e3d3f..7933b07f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -850,55 +850,29 @@ out:
 	return r;
 }
 
-int is_multipathd_running(void)
+static int test_multipathd_socket(void)
 {
-	FILE *f = NULL;
-	char buf[16];
-	char path[PATH_MAX];
-	int pid;
-	char *end;
+	int fd;
+	/*
+	 * "multipath -u" may be run before the daemon is started. In this
+	 * case, systemd might own the socket but might delay multipathd
+	 * startup until some other unit (udev settle!)  has finished
+	 * starting. With many LUNs, the listen backlog may be exceeded, which
+	 * would cause connect() to block. This causes udev workers calling
+	 * "multipath -u" to hang, and thus creates a deadlock, until "udev
+	 * settle" times out.  To avoid this, call connect() in non-blocking
+	 * mode here, and take EAGAIN as indication for a filled-up systemd
+	 * backlog.
+	 */
 
-	f = fopen(DEFAULT_PIDFILE, "r");
-	if (!f) {
-		if (errno != ENOENT)
-			condlog(4, "can't open " DEFAULT_PIDFILE ": %s",
-				strerror(errno));
-		return 0;
-	}
-	if (!fgets(buf, sizeof(buf), f)) {
-		if (ferror(f))
-			condlog(4, "read of " DEFAULT_PIDFILE " failed: %s",
-				strerror(errno));
-		fclose(f);
-		return 0;
-	}
-	fclose(f);
-	errno = 0;
-	strchop(buf);
-	pid = strtol(buf, &end, 10);
-	if (errno != 0 || pid <= 0 || *end != '\0') {
-		condlog(4, "invalid contents in " DEFAULT_PIDFILE ": '%s'",
-			buf);
-		return 0;
-	}
-	snprintf(path, sizeof(path), "/proc/%d/comm", pid);
-	f = fopen(path, "r");
-	if (!f) {
-		if (errno != ENOENT)
-			condlog(4, "can't open %s: %s", path, strerror(errno));
-		return 0;
-	}
-	if (!fgets(buf, sizeof(buf), f)) {
-		if (ferror(f))
-			condlog(4, "read of %s failed: %s", path,
-				strerror(errno));
-		fclose(f);
-		return 0;
-	}
-	fclose(f);
-	strchop(buf);
-	if (strcmp(buf, "multipathd") != 0)
-		return 0;
+	fd = __mpath_connect(1);
+	if (fd == -1) {
+		if (errno == EAGAIN)
+			condlog(3, "daemon backlog exceeded");
+		else
+			return 0;
+	} else
+		close(fd);
 	return 1;
 }
 
@@ -1080,7 +1054,7 @@ main (int argc, char *argv[])
 	}
 	if (cmd == CMD_VALID_PATH &&
 	    dev_type == DEV_UEVENT) {
-		if (!is_multipathd_running()) {
+		if (!test_multipathd_socket()) {
 			condlog(3, "%s: daemon is not running", dev);
 			if (!systemd_service_enabled(dev)) {
 				r = print_cmd_valid(RTVL_NO, NULL, conf);
-- 
2.21.0
