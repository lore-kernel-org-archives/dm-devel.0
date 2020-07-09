From: mwilck@suse.com
Subject: [PATCH 54/74] libmultipath: protect use of pp->udev
Date: Thu,  9 Jul 2020 12:51:25 +0200
Message-ID: <20200709105145.9211-2-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

We could never be 100% certain that pp->udev was always set.
With the upcoming change, we can be even less certain. Always
check pp->udev before using it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c              | 11 +++++++++--
 libmultipath/prioritizers/alua_rtpg.c |  6 ++++--
 libmultipath/structs_vec.c            |  2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index caabfef..c202d58 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -339,7 +339,10 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 	struct udev_device *parent, *tgtdev;
 	int host, channel, tgtid = -1;
 
-	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_device");
+	if (!pp->udev)
+		return 1;
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev,
+							 "scsi", "scsi_device");
 	if (!parent)
 		return 1;
 	/* Check for SAS */
@@ -1378,7 +1381,8 @@ nvme_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 	const char *attr_path = NULL;
 	const char *attr;
 
-	attr_path = udev_device_get_sysname(pp->udev);
+	if (pp->udev)
+		attr_path = udev_device_get_sysname(pp->udev);
 	if (!attr_path)
 		return PATHINFO_FAILED;
 
@@ -1958,6 +1962,9 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 		}
 	} else if (pp->bus == SYSFS_BUS_NVME) {
 		char value[256];
+
+		if (!pp->udev)
+			return -1;
 		len = sysfs_attr_get_value(pp->udev, "wwid", value,
 					   sizeof(value));
 		if (len <= 0)
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index bbf5aac..420a2e3 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -188,9 +188,11 @@ retry:
 int do_inquiry(const struct path *pp, int evpd, unsigned int codepage,
 	       void *resp, int resplen, unsigned int timeout)
 {
-	struct udev_device *ud;
+	struct udev_device *ud = NULL;
 
-	ud = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi",
+	if (pp->udev)
+		ud = udev_device_get_parent_with_subsystem_devtype(pp->udev,
+								   "scsi",
 							   "scsi_device");
 	if (ud != NULL) {
 		int rc;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index bc47d1e..0b8c548 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -494,7 +494,7 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
 		/*
 		 * see if path is in sysfs
 		 */
-		if (sysfs_attr_get_value(pp->udev, "dev",
+		if (!pp->udev || sysfs_attr_get_value(pp->udev, "dev",
 					 pp->dev_t, BLK_DEV_SIZE) < 0) {
 			if (pp->state != PATH_DOWN) {
 				condlog(1, "%s: removing valid path %s in state %d",
-- 
2.26.2
