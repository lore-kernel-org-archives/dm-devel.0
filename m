From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 19/22] multipath -u: don't grab devices
	already passed to system
Date: Sat, 14 Apr 2018 00:00:12 +0200
Message-ID: <20180413220015.7032-20-mwilck@suse.com>
References: <20180413220015.7032-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-1-mwilck@suse.com>
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

Setting SYSTEMD_READY=0 on a device that has previously been passed to
systemd is dangerous - already mounted file systems might be unmounted by
systemd.

Avoid that by checking for previously set DM_MULTIPATH_DEVICE_PATH
environment variable.

This requires to change the exit status of multipath -u - it needs to exit
with status 0 even if the path is not a multipath device path, otherwise
udev doesn't import the printed key-value pairs. We do this only for
"multipath -u"; legacy "multipath -c", which is more likely to be run in user
scripts, still exits with 1 for non-multipath devices.

The condition ENV{DM_MULTIPATH_DEVICE_PATH}!="1" before the "multipath -u"
statement in multipath.rules needs to be removed. This condition was
pointless anyway, because until this patch, DM_MULTIPATH_DEVICE_PATH hadn't
been imported from the db and thus was never set, and "multipath -u" was
always invoked. We want to keep this behavior.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c          | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 multipath/multipath.rules |  5 ++++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 96e37a7a..573d94f9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -25,6 +25,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <ctype.h>
 #include <libudev.h>
@@ -494,6 +495,25 @@ static int print_cmd_valid(int k, const vector pathvec,
 	return k == 1;
 }
 
+/*
+ * Returns true if this device has been handled before,
+ * and released to systemd.
+ *
+ * This must be called before get_refwwid(),
+ * otherwise udev_device_new_from_environment() will have
+ * destroyed environ(7).
+ */
+static bool released_to_systemd(void)
+{
+	static const char dmdp[] = "DM_MULTIPATH_DEVICE_PATH";
+	const char *dm_mp_dev_path = getenv(dmdp);
+	bool ret;
+
+	ret = dm_mp_dev_path != NULL && !strcmp(dm_mp_dev_path, "0");
+	condlog(4, "%s: %s=%s -> %d", __func__, dmdp, dm_mp_dev_path, ret);
+	return ret;
+}
+
 /*
  * Return value:
  *  -1: Retry
@@ -511,6 +531,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
+	bool released = released_to_systemd();
 
 	/*
 	 * allocate core vectors to store paths and multipaths
@@ -602,6 +623,20 @@ configure (struct config *conf, enum mpath_cmds cmd,
 				r = 0;
 				goto print_valid;
 			}
+
+			/*
+			 * DM_MULTIPATH_DEVICE_PATH=="0" means that we have
+			 * been called for this device already, and have
+			 * released it to systemd. Unless the device is now
+			 * already multipathed (see above), we can't try to
+			 * grab it, because setting SYSTEMD_READY=0 would
+			 * cause file systems to be unmounted.
+			 * Leave DM_MULTIPATH_DEVICE_PATH="0".
+			 */
+			if (released) {
+				r = 1;
+				goto print_valid;
+			}
 			if (r == 0)
 				goto print_valid;
 			/* find_multipaths_on: Fall through to path detection */
@@ -641,7 +676,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 	if (cmd == CMD_VALID_PATH) {
 		/* This only happens if find_multipaths and
-		 * ignore_wwids is set.
+		 * ignore_wwids is set, and the path is not in WWIDs
+		 * file, not currently multipathed, and has
+		 * never been released to systemd.
 		 * If there is currently a multipath device matching
 		 * the refwwid, or there is more than one path matching
 		 * the refwwid, then the path is valid */
@@ -1064,6 +1101,13 @@ out:
 	cleanup_prio();
 	cleanup_checkers();
 
+	/*
+	 * multipath -u must exit with status 0, otherwise udev won't
+	 * import its output.
+	 */
+	if (cmd == CMD_VALID_PATH && dev_type == DEV_UEVENT && r == 1)
+		r = 0;
+
 	if (dev_type == DEV_UEVENT)
 		closelog();
 
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 37f4f6d8..ef857271 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -21,8 +21,11 @@ LABEL="test_dev"
 ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
+# multipath -u needs to know if this device has ever been exported
+IMPORT{db}="DM_MULTIPATH_DEVICE_PATH"
+
 # multipath -u sets DM_MULTIPATH_DEVICE_PATH
-ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
+IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
 ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
 	ENV{SYSTEMD_READY}="0"
 
-- 
2.16.1
