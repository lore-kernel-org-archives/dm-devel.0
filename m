From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/13] Set I_T_nexus_loss_timeout on SAS devices
Date: Wed, 16 Jan 2013 13:14:15 +0100
Message-ID: <1358338456-1234-13-git-send-email-hare@suse.de>
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

Some SAS driver have an I_T_nexus_loss setting, which works
similar to the 'dev_loss_tmo' setting on FibreChannel.
So update it with the current values, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   51 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index a099996..65f9c57 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -215,9 +215,21 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	/* Check for SAS */
 	value = udev_device_get_sysattr_value(parent, "sas_address");
 	if (value) {
-		pp->sg_id.proto_id = SCSI_PROTOCOL_SAS;
-		strncpy(node, value, NODE_NAME_SIZE);
-		return 0;
+		tgtdev = udev_device_get_parent(parent);
+		while (tgtdev) {
+			targetid = udev_device_get_sysname(tgtdev);
+			if (sscanf(targetid, "end_device-%d:%d",
+				   &host, &rport_id) == 2)
+				break;
+			tgtdev = udev_device_get_parent(tgtdev);
+			rport_id = -1;
+		}
+		if (rport_id >= 0) {
+			pp->sg_id.proto_id = SCSI_PROTOCOL_SAS;
+			pp->sg_id.transport_id = rport_id;
+			strncpy(node, value, NODE_NAME_SIZE);
+			return 0;
+		}
 	}
 
 	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_target");
@@ -391,6 +403,37 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 	return;
 }
 
+static void
+sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
+{
+	struct udev_device *sas_dev = NULL;
+	char end_dev_id[64];
+	char value[11];
+
+	sprintf(end_dev_id, "end_device-%d:%d",
+		pp->sg_id.host_no, pp->sg_id.transport_id);
+	sas_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+				"sas_end_device", end_dev_id);
+	if (!sas_dev) {
+		condlog(1, "%s: No SAS end device for '%s'", pp->dev,
+			end_dev_id);
+		return;
+	}
+	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
+		pp->sg_id.channel, pp->sg_id.scsi_id, end_dev_id);
+
+	if (mpp->dev_loss) {
+		snprintf(value, 11, "%u", mpp->dev_loss);
+		if (sysfs_attr_set_value(sas_dev, "I_T_nexus_loss_timeout",
+					 value, 11) <= 0)
+			condlog(3, "%s: failed to update "
+				"I_T Nexus loss timeout, error %d",
+				pp->dev, errno);
+	}
+	udev_device_unref(sas_dev);
+	return;
+}
+
 int
 sysfs_set_scsi_tmo (struct multipath *mpp)
 {
@@ -426,6 +469,8 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 			sysfs_set_rport_tmo(mpp, pp);
 		if (pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
 			sysfs_set_session_tmo(mpp, pp);
+		if (pp->sg_id.proto_id == SCSI_PROTOCOL_SAS)
+			sysfs_set_nexus_loss_tmo(mpp, pp);
 	}
 	return 0;
 }
-- 
1.7.4.2
