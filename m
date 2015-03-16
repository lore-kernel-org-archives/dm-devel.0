From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 62/78] Skip USB devices during discovery
Date: Mon, 16 Mar 2015 13:36:49 +0100
Message-ID: <1426509425-15978-63-git-send-email-hare@suse.de>
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

Some USB devices even present VPD pages, but they still remain
USB devices, and we shouldn't run multipath on those.
So detect USB devices properly and skip them during discovery.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index a9962d1..c4aee1c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -275,6 +275,19 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 		}
 	}
 
+	/* Check for USB */
+	tgtdev = udev_device_get_parent(parent);
+	while (tgtdev) {
+		value = udev_device_get_subsystem(tgtdev);
+		if (value && !strcmp(value, "usb")) {
+			pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
+			tgtname = udev_device_get_sysname(tgtdev);
+			strncpy(node, tgtname, strlen(tgtname));
+			condlog(3, "%s: skip USB device %s", pp->dev, node);
+			return 1;
+		}
+		tgtdev = udev_device_get_parent(tgtdev);
+	}
 	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_target");
 	if (!parent)
 		return 1;
-- 
1.8.4.5
