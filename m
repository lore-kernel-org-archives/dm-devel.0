From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Update path_offline() to return device status
Date: Wed, 03 Feb 2010 14:22:22 +0100
Message-ID: <20100203132222.4BF1329CC3@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


A SCSI device can have for more states than just 'offline' and
'running'. In fact, any device _not_ in state 'running' is
unaccessible to I/O, so running a path checker on these devices
will cause the checker to be delayed and hence stall the entire
daemon.

This patch updates the path_offline() function to return the
actual device state. Path checkers will only be run if the
state is PATH_UP. A 'blocked' device state will be translated
into PATH_PENDING, causing the checkerloop to skip this device
and recheck as soon as possible.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 98d1618..6b99d07 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -587,7 +587,7 @@ path_offline (struct path * pp)
 	pp->sysdev = sysfs_device_from_path(pp);
 	if (!pp->sysdev) {
 		condlog(1, "%s: failed to get sysfs information", pp->dev);
-		return 1;
+		return PATH_WILD;
 	}
 
 	parent = sysfs_device_get_parent(pp->sysdev);
@@ -597,20 +597,25 @@ path_offline (struct path * pp)
 		parent = sysfs_device_get_parent(parent);
 	if (!parent) {
 		condlog(1, "%s: failed to get parent", pp->dev);
-		return 1;
+		return PATH_WILD;
 	}
 
 	if (sysfs_get_state(parent, buff, SCSI_STATE_SIZE))
-		return 1;
+		return PATH_WILD;
 
 	condlog(3, "%s: state = %s", pp->dev, buff);
 
 	if (!strncmp(buff, "offline", 7)) {
 		pp->offline = 1;
-		return 1;
+		return PATH_DOWN;
 	}
 	pp->offline = 0;
-	return 0;
+	if (!strncmp(buff, "blocked", 7))
+		return PATH_PENDING;
+	else if (!strncmp(buff, "running", 7))
+		return PATH_UP;
+
+	return PATH_DOWN;
 }
 
 extern int
@@ -703,6 +708,7 @@ static int
 get_state (struct path * pp)
 {
 	struct checker * c = &pp->checker;
+	int sysfs_state;
 
 	condlog(3, "%s: get_state", pp->dev);
 
@@ -718,9 +724,10 @@ get_state (struct path * pp)
 			return 1;
 		}
 	}
-	if (path_offline(pp)) {
-		condlog(3, "%s: path offline", pp->dev);
-		pp->state = PATH_DOWN;
+	sysfs_state = path_offline(pp);
+	if (sysfs_state != PATH_UP) {
+		condlog(3, "%s: path inaccessible", pp->dev);
+		pp->state = sysfs_state;
 		return 0;
 	}
 	pp->state = checker_check(c);
diff --git a/multipathd/main.c b/multipathd/main.c
index 73b06cb..0d244ad 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -948,9 +948,8 @@ check_path (struct vectors * vecs, struct path * pp)
 	 */
 	checker_set_async(&pp->checker);
 
-	if (path_offline(pp))
-		newstate = PATH_DOWN;
-	else
+	newstate = path_offline(pp);
+	if (newstate == PATH_UP)
 		newstate = checker_check(&pp->checker);
 
 	if (newstate < 0) {
