From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/8] libmultipath: scsi_ioctl_pathinfo doesn't
	fail
Date: Wed, 10 Oct 2018 22:05:00 +0200
Message-ID: <20181010200506.15796-3-mwilck@suse.com>
References: <20181010200506.15796-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010200506.15796-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This function never returns error, so make a void.
Move the mask test to pathinfo() where it belongs.
The error message about the serial number isn't important
any more, reduce its level to v3.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b267f07c..8381d982 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1496,7 +1496,7 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
 	}
 }
 
-static int
+static void
 scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
 {
 	struct udev_device *parent;
@@ -1506,7 +1506,7 @@ scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
 		detect_alua(pp, conf);
 
 	if (!(mask & DI_SERIAL))
-		return 0;
+		return;
 
 	parent = pp->udev;
 	while (parent) {
@@ -1525,17 +1525,17 @@ scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
 		parent = udev_device_get_parent(parent);
 	}
 	if (!attr_path || pp->sg_id.host_no == -1)
-		return 0;
+		return;
 
 	if (get_vpd_sysfs(parent, 0x80, pp->serial, SERIAL_SIZE) <= 0) {
 		if (get_serial(pp->serial, SERIAL_SIZE, pp->fd)) {
-			condlog(2, "%s: fail to get serial", pp->dev);
-			return 0;
+			condlog(3, "%s: fail to get serial", pp->dev);
+			return;
 		}
 	}
 
 	condlog(3, "%s: serial = %s", pp->dev, pp->serial);
-	return 0;
+	return;
 }
 
 static int
@@ -1937,9 +1937,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	if (mask & DI_SERIAL)
 		get_geometry(pp);
 
-	if (path_state == PATH_UP && pp->bus == SYSFS_BUS_SCSI &&
-	    scsi_ioctl_pathinfo(pp, conf, mask))
-		goto blank;
+	if (path_state == PATH_UP && pp->bus == SYSFS_BUS_SCSI)
+		scsi_ioctl_pathinfo(pp, conf, mask);
 
 	if (pp->bus == SYSFS_BUS_CCISS &&
 	    cciss_ioctl_pathinfo(pp, mask))
-- 
2.19.0
