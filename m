From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/11] libmultipath: proactively remove path
Date: Fri, 13 Dec 2013 13:14:08 +0100
Message-ID: <1386936854-8399-6-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
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

When path_offline() detects a removed path we really do not need
to wait for any uevent to arrive, but can remove the path
straightaway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers.c  |  1 +
 libmultipath/checkers.h  |  5 +++++
 libmultipath/discovery.c | 15 ++++++++++++---
 libmultipath/sysfs.c     |  2 +-
 multipathd/main.c        |  5 +++++
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 47f5c68..4a4cd7c 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -18,6 +18,7 @@ char *checker_state_names[] = {
       "ghost",
       "pending",
       "timeout",
+      "removed",
 };
 
 static LIST_HEAD(checkers);
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 1b6c22d..e62b52f 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -50,6 +50,10 @@
  * PATH_TIMEOUT:
  * - Use: Only tur checker
  * - Description: Command timed out
+ *
+ * PATH REMOVED:
+ * - Use: All checkers
+ * - Description: Device has been removed from the system
  */
 enum path_check_state {
 	PATH_WILD,
@@ -60,6 +64,7 @@ enum path_check_state {
 	PATH_GHOST,
 	PATH_PENDING,
 	PATH_TIMEOUT,
+	PATH_REMOVED,
 	PATH_MAX_STATE
 };
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d519c02..ccd3b62 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -839,6 +839,7 @@ path_offline (struct path * pp)
 {
 	struct udev_device * parent;
 	char buff[SCSI_STATE_SIZE];
+	int err;
 
 	if (pp->bus != SYSFS_BUS_SCSI)
 		return PATH_UP;
@@ -853,12 +854,18 @@ path_offline (struct path * pp)
 
 	if (!parent) {
 		condlog(1, "%s: failed to get sysfs information", pp->dev);
-		return PATH_DOWN;
+		return PATH_REMOVED;
 	}
 
 	memset(buff, 0x0, SCSI_STATE_SIZE);
-	if (sysfs_attr_get_value(parent, "state", buff, SCSI_STATE_SIZE) <= 0)
-		return PATH_DOWN;
+	err = sysfs_attr_get_value(parent, "state", buff, SCSI_STATE_SIZE);
+	if (err <= 0) {
+		if (err == -ENXIO)
+			return PATH_REMOVED;
+		else
+			return PATH_DOWN;
+	}
+
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
@@ -1084,6 +1091,8 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	}
 
 	path_state = path_offline(pp);
+	if (path_state == PATH_REMOVED)
+		goto blank;
 
 	/*
 	 * fetch info not available through sysfs
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 8ba27d4..e5834f9 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -59,7 +59,7 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	condlog(4, "open '%s'", devpath);
 	if (stat(devpath, &statbuf) != 0) {
 		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
-		return -errno;
+		return -ENXIO;
 	}
 
 	/* skip directories */
diff --git a/multipathd/main.c b/multipathd/main.c
index 2633da9..96564f8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1122,6 +1122,11 @@ check_path (struct vectors * vecs, struct path * pp)
 	pp->tick = conf->checkint;
 
 	newstate = path_offline(pp);
+	if (newstate == PATH_REMOVED) {
+		condlog(2, "%s: remove path (checker)", pp->dev);
+		ev_remove_path(pp, vecs);
+		return;
+	}
 	if (newstate == PATH_UP)
 		newstate = get_state(pp, 1);
 	else
-- 
1.8.1.4
