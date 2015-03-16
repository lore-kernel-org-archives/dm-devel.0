From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 65/78] Use sysfs attribute vpd_pg80 to read
	serial number
Date: Mon, 16 Mar 2015 13:36:52 +0100
Message-ID: <1426509425-15978-66-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

There is no need to issue an ioctl to read the serial number
as it's already present in sysfs. And we should not print
out the serial number unconditionally but rather check
the discovery mask.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b1cd6a0..f8a0503 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1026,9 +1026,6 @@ scsi_sysfs_pathinfo (struct path * pp)
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
-	if (get_vpd(parent, 0x80, pp->serial, SERIAL_SIZE) >= 0)
-		condlog(3, "%s: serial = %s", pp->dev, pp->serial);
-
 	/*
 	 * set the hwe configlet pointer
 	 */
@@ -1276,13 +1273,36 @@ sysfs_pathinfo(struct path * pp)
 static int
 scsi_ioctl_pathinfo (struct path * pp, int mask)
 {
-	if (mask & DI_SERIAL) {
-		if (strlen(pp->serial) == 0)
-			get_serial(pp->serial, SERIAL_SIZE, pp->fd);
-		condlog(3, "%s: serial = %s", pp->dev, pp->serial);
+	struct udev_device *parent;
+	const char *attr_path = NULL;
+
+	if (!(mask & DI_SERIAL))
+		return 0;
+
+	parent = pp->udev;
+	while (parent) {
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "scsi", 4)) {
+			attr_path = udev_device_get_sysname(parent);
+			if (!attr_path)
+				break;
+			if (sscanf(attr_path, "%i:%i:%i:%i",
+				   &pp->sg_id.host_no,
+				   &pp->sg_id.channel,
+				   &pp->sg_id.scsi_id,
+				   &pp->sg_id.lun) == 4)
+				break;
+		}
+		parent = udev_device_get_parent(parent);
 	}
+	if (!attr_path || pp->sg_id.host_no == -1)
+		return -ENODEV;
 
-	return 0;
+	if (get_vpd(parent, 0x80, pp->serial, SERIAL_SIZE) > 0)
+		condlog(3, "%s: serial = %s",
+			pp->dev, pp->serial);
+
+	return strlen(pp->serial) ? 0 : -EIO;
 }
 
 static int
-- 
1.8.4.5
