From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/13] Use transport identifiers when detecting
	devices
Date: Wed, 16 Jan 2013 13:14:12 +0100
Message-ID: <1358338456-1234-10-git-send-email-hare@suse.de>
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

This patch stores the transport identifiers, allowing
for a simplified dev_loss_tmo setting.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   59 ++++++++++++++++++++++++++-------------------
 libmultipath/structs.h   |   17 +++++++++++-
 2 files changed, 49 insertions(+), 27 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 8b6f74d..3fd33a3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -207,6 +207,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 {
 	const char *targetid, *value;
 	struct udev_device *parent, *tgtdev;
+	int host, channel, rport_id = -1;
 
 	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_device");
 	if (!parent)
@@ -214,6 +215,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	/* Check for SAS */
 	value = udev_device_get_sysattr_value(parent, "sas_address");
 	if (value) {
+		pp->sg_id.proto_id = SCSI_PROTOCOL_SAS;
 		strncpy(node, value, NODE_NAME_SIZE);
 		return 0;
 	}
@@ -221,19 +223,30 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_target");
 	if (!parent)
 		return 1;
-	tgtdev = udev_device_new_from_subsystem_sysname(conf->udev, "fc_transport", udev_device_get_sysname(parent));
-	/* Check if it's FibreChannel */
-	if (tgtdev) {
-		const char *value;
-
-		value = udev_device_get_sysattr_value(tgtdev, "node_name");
-		if (value) {
-			strncpy(node, value, NODE_NAME_SIZE);
-			udev_device_unref(tgtdev);
-			return 0;
+	/* Check for FibreChannel */
+	tgtdev = udev_device_get_parent(parent);
+	value = udev_device_get_sysname(tgtdev);
+	if (sscanf(value, "rport-%d:%d-%d",
+		   &host, &channel, &rport_id) == 3) {
+		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev,
+				"fc_remote_ports", value);
+		if (tgtdev) {
+			condlog(3, "SCSI target %d:%d:%d -> "
+				"FC rport %d:%d-%d",
+				pp->sg_id.host_no, pp->sg_id.channel,
+				pp->sg_id.scsi_id, host, channel,
+				rport_id);
+			value = udev_device_get_sysattr_value(tgtdev,
+							      "node_name");
+			if (value) {
+				pp->sg_id.proto_id = SCSI_PROTOCOL_FCP;
+				pp->sg_id.transport_id = rport_id;
+				strncpy(node, value, NODE_NAME_SIZE);
+				udev_device_unref(tgtdev);
+				return 0;
+			} else
+				udev_device_unref(tgtdev);
 		}
-		else
-			udev_device_unref(tgtdev);
 	}
 
 	/* Check for iSCSI */
@@ -253,6 +266,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 
 			value = udev_device_get_sysattr_value(tgtdev, "targetname");
 			if (value) {
+				pp->sg_id.proto_id = SCSI_PROTOCOL_ISCSI;
 				strncpy(node, value, NODE_NAME_SIZE);
 				udev_device_unref(tgtdev);
 				return 0;
@@ -267,25 +281,20 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 static void
 sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
-	struct udev_device *parent = pp->udev;
 	struct udev_device *rport_dev = NULL;
 	char value[11];
-	const char *rport_id = NULL;
+	char rport_id[32];
 
-	while (parent) {
-		rport_id = udev_device_get_sysname(parent);
-		if (!strncmp(rport_id, "rport-", 6))
-			break;
-		parent = udev_device_get_parent(parent);
-		rport_id = NULL;
-	}
-	if (!parent || !rport_id) {
-		condlog(0, "%s: rport id not found", pp->dev);
+	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP) {
+		condlog(3, "%s: Not a FCP device", pp->dev);
 		return;
 	}
-	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev, "fc_remote_ports", rport_id);
+	sprintf(rport_id, "rport-%d:%d-%d",
+		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
+	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+				"fc_remote_ports", rport_id);
 	if (!rport_dev) {
-		condlog(3, "%s: No fc_remote_port device for '%s'", pp->dev,
+		condlog(1, "%s: No fc_remote_port device for '%s'", pp->dev,
 			rport_id);
 		return;
 	}
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 4085900..ab05a78 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -113,6 +113,19 @@ enum detect_prio_states {
 	DETECT_PRIO_ON,
 };
 
+enum scsi_protocol {
+	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
+	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
+	SCSI_PROTOCOL_SSA = 2,	/* Serial Storage Architecture - Obsolete */
+	SCSI_PROTOCOL_SBP = 3,	/* firewire */
+	SCSI_PROTOCOL_SRP = 4,	/* Infiniband RDMA */
+	SCSI_PROTOCOL_ISCSI = 5,
+	SCSI_PROTOCOL_SAS = 6,
+	SCSI_PROTOCOL_ADT = 7,	/* Media Changers */
+	SCSI_PROTOCOL_ATA = 8,
+	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
+};
+
 struct sg_id {
 	int host_no;
 	int channel;
@@ -120,8 +133,8 @@ struct sg_id {
 	int lun;
 	short h_cmd_per_lun;
 	short d_queue_depth;
-	int unused1;
-	int unused2;
+	enum scsi_protocol proto_id;
+	int transport_id;
 };
 
 # ifndef HDIO_GETGEO
-- 
1.7.4.2
