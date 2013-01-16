From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/13] Rename variables in sysfs_get_tgt_nodename
Date: Wed, 16 Jan 2013 13:14:16 +0100
Message-ID: <1358338456-1234-14-git-send-email-hare@suse.de>
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

For consistency.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   54 +++++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 65f9c57..3fbc181 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -205,9 +205,9 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 int
 sysfs_get_tgt_nodename (struct path *pp, char * node)
 {
-	const char *targetid, *value;
+	const char *tgtname, *value;
 	struct udev_device *parent, *tgtdev;
-	int host, channel, rport_id = -1, ata_id = -1;
+	int host, channel, tgtid = -1;
 
 	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_device");
 	if (!parent)
@@ -217,16 +217,16 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	if (value) {
 		tgtdev = udev_device_get_parent(parent);
 		while (tgtdev) {
-			targetid = udev_device_get_sysname(tgtdev);
-			if (sscanf(targetid, "end_device-%d:%d",
-				   &host, &rport_id) == 2)
+			tgtname = udev_device_get_sysname(tgtdev);
+			if (sscanf(tgtname, "end_device-%d:%d",
+				   &host, &tgtid) == 2)
 				break;
 			tgtdev = udev_device_get_parent(tgtdev);
-			rport_id = -1;
+			tgtid = -1;
 		}
-		if (rport_id >= 0) {
+		if (tgtid >= 0) {
 			pp->sg_id.proto_id = SCSI_PROTOCOL_SAS;
-			pp->sg_id.transport_id = rport_id;
+			pp->sg_id.transport_id = tgtid;
 			strncpy(node, value, NODE_NAME_SIZE);
 			return 0;
 		}
@@ -239,7 +239,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	tgtdev = udev_device_get_parent(parent);
 	value = udev_device_get_sysname(tgtdev);
 	if (sscanf(value, "rport-%d:%d-%d",
-		   &host, &channel, &rport_id) == 3) {
+		   &host, &channel, &tgtid) == 3) {
 		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev,
 				"fc_remote_ports", value);
 		if (tgtdev) {
@@ -247,12 +247,12 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 				"FC rport %d:%d-%d",
 				pp->sg_id.host_no, pp->sg_id.channel,
 				pp->sg_id.scsi_id, host, channel,
-				rport_id);
+				tgtid);
 			value = udev_device_get_sysattr_value(tgtdev,
 							      "node_name");
 			if (value) {
 				pp->sg_id.proto_id = SCSI_PROTOCOL_FCP;
-				pp->sg_id.transport_id = rport_id;
+				pp->sg_id.transport_id = tgtid;
 				strncpy(node, value, NODE_NAME_SIZE);
 				udev_device_unref(tgtdev);
 				return 0;
@@ -263,25 +263,25 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 
 	/* Check for iSCSI */
 	parent = pp->udev;
-	targetid = NULL;
+	tgtname = NULL;
 	while (parent) {
-		targetid = udev_device_get_sysname(parent);
-		if (targetid && sscanf(targetid , "session%d", &rport_id) == 1)
+		tgtname = udev_device_get_sysname(parent);
+		if (tgtname && sscanf(tgtname , "session%d", &tgtid) == 1)
 			break;
 		parent = udev_device_get_parent(parent);
-		targetid = NULL;
-		rport_id = -1;
+		tgtname = NULL;
+		tgtid = -1;
 	}
-	if (parent && targetid) {
+	if (parent && tgtname) {
 		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev,
-				"iscsi_session", targetid);
+				"iscsi_session", tgtname);
 		if (tgtdev) {
 			const char *value;
 
-			value = udev_device_get_sysattr_value(tgtdev, "targetname");
+			value = udev_device_get_sysattr_value(tgtdev, "tgtname");
 			if (value) {
 				pp->sg_id.proto_id = SCSI_PROTOCOL_ISCSI;
-				pp->sg_id.transport_id = rport_id;
+				pp->sg_id.transport_id = tgtid;
 				strncpy(node, value, NODE_NAME_SIZE);
 				udev_device_unref(tgtdev);
 				return 0;
@@ -292,18 +292,18 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	}
 	/* Check for libata */
 	parent = pp->udev;
-	targetid = NULL;
+	tgtname = NULL;
 	while (parent) {
-		targetid = udev_device_get_sysname(parent);
-		if (targetid && sscanf(targetid, "ata%d", &ata_id) == 1)
+		tgtname = udev_device_get_sysname(parent);
+		if (tgtname && sscanf(tgtname, "ata%d", &tgtid) == 1)
 			break;
 		parent = udev_device_get_parent(parent);
-		targetid = NULL;
+		tgtname = NULL;
 	}
-	if (targetid) {
+	if (tgtname) {
 		pp->sg_id.proto_id = SCSI_PROTOCOL_ATA;
-		pp->sg_id.transport_id = ata_id;
-		snprintf(node, NODE_NAME_SIZE, "ata-%d.00", ata_id);
+		pp->sg_id.transport_id = tgtid;
+		snprintf(node, NODE_NAME_SIZE, "ata-%d.00", tgtid);
 		return 0;
 	}
 	pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
-- 
1.7.4.2
