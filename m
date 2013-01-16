From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/13] Discover target ids for ATA
Date: Wed, 16 Jan 2013 13:14:13 +0100
Message-ID: <1358338456-1234-11-git-send-email-hare@suse.de>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-1-git-send-email-hare@suse.de>
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

libata devices now have a separate sysfs entry, so we should be
discovering them properly, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3fd33a3..b6bce22 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -207,7 +207,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 {
 	const char *targetid, *value;
 	struct udev_device *parent, *tgtdev;
-	int host, channel, rport_id = -1;
+	int host, channel, rport_id = -1, ata_id = -1;
 
 	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_device");
 	if (!parent)
@@ -275,6 +275,23 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 				udev_device_unref(tgtdev);
 		}
 	}
+	/* Check for libata */
+	parent = pp->udev;
+	targetid = NULL;
+	while (parent) {
+		targetid = udev_device_get_sysname(parent);
+		if (targetid && sscanf(targetid, "ata%d", &ata_id) == 1)
+			break;
+		parent = udev_device_get_parent(parent);
+		targetid = NULL;
+	}
+	if (targetid) {
+		pp->sg_id.proto_id = SCSI_PROTOCOL_ATA;
+		pp->sg_id.transport_id = ata_id;
+		snprintf(node, NODE_NAME_SIZE, "ata-%d.00", ata_id);
+		return 0;
+	}
+	pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
 	return 1;
 }
 
-- 
1.7.4.2
