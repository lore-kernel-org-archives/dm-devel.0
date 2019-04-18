From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC PATCH] multipath: check on multipathd without
	starting it
Date: Thu, 18 Apr 2019 12:49:46 -0500
Message-ID: <1555609786-25156-1-git-send-email-bmarzins@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When "multipath -u" is run, it checks if multipathd is running.
Currently it does this by trying to connect to the mutipathd socket.
This can cause problems during boot.  The multipathd.socket systemd unit
file will cause "multipath -u" to wait until multipathd has been started
before continuing.  If there is a lot of activity on the system,
multipathd may not start up immediately, causing block device
initialization to be delayed, potentially until after systemd times
waiting for the device.  To avoid this, multipath now checks if
multipathd is running by reading /run/multipathd.pid and checking the
/proc/<pid>/comm to verify that multipathd is really running with this
pid. This avoids forcing "multipath -u" to wait on multipathd starting
up.

As an alternative to this patch, multipath could simply switch the order
of the calls to systemd_service_enabled() and mpath_connect(). This would
make multipath only try to connect with multipathd if it wasn't enabled in
systemd, so that it wouldn't autostart.

Another alternative is to do away with multipathd.socket. Since multipathd
needs to always be running in order to get uevents, there isn't much value
in having it autoactivate when it gets an interactive command.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 60 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 6 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 69141dbc..008e3d3f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -850,6 +850,58 @@ out:
 	return r;
 }
 
+int is_multipathd_running(void)
+{
+	FILE *f = NULL;
+	char buf[16];
+	char path[PATH_MAX];
+	int pid;
+	char *end;
+
+	f = fopen(DEFAULT_PIDFILE, "r");
+	if (!f) {
+		if (errno != ENOENT)
+			condlog(4, "can't open " DEFAULT_PIDFILE ": %s",
+				strerror(errno));
+		return 0;
+	}
+	if (!fgets(buf, sizeof(buf), f)) {
+		if (ferror(f))
+			condlog(4, "read of " DEFAULT_PIDFILE " failed: %s",
+				strerror(errno));
+		fclose(f);
+		return 0;
+	}
+	fclose(f);
+	errno = 0;
+	strchop(buf);
+	pid = strtol(buf, &end, 10);
+	if (errno != 0 || pid <= 0 || *end != '\0') {
+		condlog(4, "invalid contents in " DEFAULT_PIDFILE ": '%s'",
+			buf);
+		return 0;
+	}
+	snprintf(path, sizeof(path), "/proc/%d/comm", pid);
+	f = fopen(path, "r");
+	if (!f) {
+		if (errno != ENOENT)
+			condlog(4, "can't open %s: %s", path, strerror(errno));
+		return 0;
+	}
+	if (!fgets(buf, sizeof(buf), f)) {
+		if (ferror(f))
+			condlog(4, "read of %s failed: %s", path,
+				strerror(errno));
+		fclose(f);
+		return 0;
+	}
+	fclose(f);
+	strchop(buf);
+	if (strcmp(buf, "multipathd") != 0)
+		return 0;
+	return 1;
+}
+
 int
 main (int argc, char *argv[])
 {
@@ -1028,17 +1080,13 @@ main (int argc, char *argv[])
 	}
 	if (cmd == CMD_VALID_PATH &&
 	    dev_type == DEV_UEVENT) {
-		int fd;
-
-		fd = mpath_connect();
-		if (fd == -1) {
+		if (!is_multipathd_running()) {
 			condlog(3, "%s: daemon is not running", dev);
 			if (!systemd_service_enabled(dev)) {
 				r = print_cmd_valid(RTVL_NO, NULL, conf);
 				goto out;
 			}
-		} else
-			mpath_disconnect(fd);
+		}
 	}
 
 	if (cmd == CMD_REMOVE_WWID && !dev) {
-- 
2.17.2
