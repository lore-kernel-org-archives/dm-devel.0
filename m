From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/57] libmultipath: call get_uid() for all paths
Date: Wed, 27 Apr 2016 13:10:17 +0200
Message-ID: <1461755458-29225-17-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When we're reading the device UID off uevents we don't have to
check the path state as we're not actually doing I/O.
So pass in the path_state to get_uid() and evaluate it only
if ->getuid is selected.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 83cc4f7..2fa0907 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1513,7 +1513,7 @@ get_vpd_uid(struct path * pp)
 }
 
 static int
-get_uid (struct path * pp)
+get_uid (struct path * pp, int path_state)
 {
 	char *c;
 	const char *origin = "unknown";
@@ -1533,13 +1533,14 @@ get_uid (struct path * pp)
 
 		/* Use 'getuid' callout, deprecated */
 		condlog(1, "%s: using deprecated getuid callout", pp->dev);
-		if (apply_format(pp->getuid, &buff[0], pp)) {
+		if (path_state != PATH_UP) {
+			condlog(3, "%s: path inaccessible", pp->dev);
+			len = -EWOULDBLOCK;
+		} else if (apply_format(pp->getuid, &buff[0], pp)) {
 			condlog(0, "error formatting uid callout command");
-			memset(pp->wwid, 0, WWID_SIZE);
 			len = -EINVAL;
 		} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
 			condlog(3, "error calling out %s", buff);
-			memset(pp->wwid, 0, WWID_SIZE);
 			len = -EIO;
 		} else
 			len = strlen(pp->wwid);
@@ -1559,7 +1560,7 @@ get_uid (struct path * pp)
 			len = get_vpd_uid(pp);
 			origin = "sysfs";
 			pp->uid_attribute = NULL;
-			if (len < 0) {
+			if (len < 0 && path_state == PATH_UP) {
 				condlog(1, "%s: failed to get sysfs uid: %s",
 					pp->dev, strerror(-len));
 				len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
@@ -1659,7 +1660,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	}
 
 	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
-		get_uid(pp);
+		get_uid(pp, path_state);
 		if (!strlen(pp->wwid)) {
 			pp->initialized = INIT_MISSING_UDEV;
 			pp->tick = conf->retrigger_delay;
-- 
2.6.6
