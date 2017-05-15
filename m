From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/12] kpartx: dm_remove_partmaps: support
	non-dm devices
Date: Mon, 15 May 2017 17:37:15 +0200
Message-ID: <20170515153722.11508-6-mwilck@suse.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Commit  3d709241 improved partition removal, but broke support
for handling partitions of non-dm devices such as loop devices
or RAM disks.

This requires passing the dev_t of the device down to
do_foreach_partmap(). Doing so, there's little use in trying
to derive major/minor numbers from the "mapname" any more
(which actually is the device name for non-DM devices).
But we can use this to find out whether the device in question
is a dm device.

The test for UUID match doesn't work for non-DM devices (this
shall be improved in a later patch in this series).

The test for equal name of parent dev and partition is only valid
for dm devices. For non-dm devices such as loop, "/dev/mapper/loop0"
could, theoretically, be a partition of "/dev/loop0"
(and we don't want to rely on map names).

Fixes: 3d709241 "kpartx: sanitize delete partitions"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 22 +++++++++++++++-------
 kpartx/devmapper.h |  2 +-
 kpartx/kpartx.c    |  3 ++-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 8b125be5..b7a7390c 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -8,6 +8,7 @@
 #include <libdevmapper.h>
 #include <ctype.h>
 #include <errno.h>
+#include <sys/sysmacros.h>
 #include "devmapper.h"
 
 #define _UUID_PREFIX "part"
@@ -438,6 +439,7 @@ struct remove_data {
 
 static int
 do_foreach_partmaps (const char * mapname, const char *uuid,
+		     dev_t devt,
 		     int (*partmap_func)(const char *, void *),
 		     void *data)
 {
@@ -449,6 +451,7 @@ do_foreach_partmaps (const char * mapname, const char *uuid,
 	int major, minor;
 	char dev_t[32];
 	int r = 1;
+	int is_dmdev = 1;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
 		return 1;
@@ -466,15 +469,20 @@ do_foreach_partmaps (const char * mapname, const char *uuid,
 		goto out;
 	}
 
-	if (dm_devn(mapname, &major, &minor))
-		goto out;
+	if (dm_devn(mapname, &major, &minor) ||
+	    (major != major(devt) || minor != minor(devt)))
+		/*
+		 * The latter could happen if a dm device "/dev/mapper/loop0"
+		 * exits while kpartx is called on "/dev/loop0".
+		 */
+		is_dmdev = 0;
 
-	sprintf(dev_t, "%d:%d", major, minor);
+	sprintf(dev_t, "%d:%d", major(devt), minor(devt));
 	do {
 		/*
 		 * skip our devmap
 		 */
-		if (!strcmp(names->name, mapname))
+		if (is_dmdev && !strcmp(names->name, mapname))
 			goto next;
 
 		/*
@@ -502,7 +510,7 @@ do_foreach_partmaps (const char * mapname, const char *uuid,
 		/*
 		 * skip if uuids don't match
 		 */
-		if (dm_compare_uuid(uuid, names->name)) {
+		if (is_dmdev && uuid && dm_compare_uuid(uuid, names->name)) {
 			if (rd->verbose)
 				printf("%s: is not a kpartx partition. Not removing\n",
 				       names->name);
@@ -543,8 +551,8 @@ remove_partmap(const char *name, void *data)
 }
 
 int
-dm_remove_partmaps (char * mapname, char *uuid, int verbose)
+dm_remove_partmaps (char * mapname, char *uuid, dev_t devt, int verbose)
 {
 	struct remove_data rd = { verbose };
-	return do_foreach_partmaps(mapname, uuid, remove_partmap, &rd);
+	return do_foreach_partmaps(mapname, uuid, devt, remove_partmap, &rd);
 }
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 9988ec0f..2e28c780 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -18,7 +18,7 @@ char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(const char *mapname);
 int dm_devn (const char * mapname, int *major, int *minor);
-int dm_remove_partmaps (char * mapname, char *uuid, int verbose);
+int dm_remove_partmaps (char * mapname, char *uuid, dev_t devt, int verbose);
 int dm_no_partitions(char * mapname);
 
 #endif /* _KPARTX_DEVMAPPER_H */
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index e0c105f4..ea728b42 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -446,7 +446,8 @@ main(int argc, char **argv){
 			break;
 
 		case DELETE:
-			r = dm_remove_partmaps(mapname, uuid, verbose);
+			r = dm_remove_partmaps(mapname, uuid, buf.st_rdev,
+					       verbose);
 			if (loopdev) {
 				if (del_loop(loopdev)) {
 					if (verbose)
-- 
2.12.2
