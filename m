From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/13] Set recovery_tmo for iSCSI devices
Date: Wed, 16 Jan 2013 13:14:14 +0100
Message-ID: <1358338456-1234-12-git-send-email-hare@suse.de>
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

iSCSI has a 'recovery_tmo' value, which works similar to the
'fast_io_fail' mechanism on FibreChannel.
So we should be setting it from multipath, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   59 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b6bce22..a099996 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -254,19 +254,22 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	targetid = NULL;
 	while (parent) {
 		targetid = udev_device_get_sysname(parent);
-		if (!strncmp(targetid , "session", 6))
+		if (targetid && sscanf(targetid , "session%d", &rport_id) == 1)
 			break;
 		parent = udev_device_get_parent(parent);
 		targetid = NULL;
+		rport_id = -1;
 	}
-	if (parent) {
-		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev, "iscsi_session", targetid);
+	if (parent && targetid) {
+		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev,
+				"iscsi_session", targetid);
 		if (tgtdev) {
 			const char *value;
 
 			value = udev_device_get_sysattr_value(tgtdev, "targetname");
 			if (value) {
 				pp->sg_id.proto_id = SCSI_PROTOCOL_ISCSI;
+				pp->sg_id.transport_id = rport_id;
 				strncpy(node, value, NODE_NAME_SIZE);
 				udev_device_unref(tgtdev);
 				return 0;
@@ -302,10 +305,6 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	char value[11];
 	char rport_id[32];
 
-	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP) {
-		condlog(3, "%s: Not a FCP device", pp->dev);
-		return;
-	}
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
 	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev,
@@ -351,6 +350,47 @@ out:
 	udev_device_unref(rport_dev);
 }
 
+static void
+sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
+{
+	struct udev_device *session_dev = NULL;
+	char session_id[64];
+	char value[11];
+
+	sprintf(session_id, "session%d", pp->sg_id.transport_id);
+	session_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+				"iscsi_session", session_id);
+	if (!session_dev) {
+		condlog(1, "%s: No iscsi session for '%s'", pp->dev,
+			session_id);
+		return;
+	}
+	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
+		pp->sg_id.channel, pp->sg_id.scsi_id, session_id);
+
+	if (mpp->dev_loss) {
+		condlog(3, "%s: ignoring dev_loss_tmo on iSCSI", pp->dev);
+	}
+	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
+		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF) {
+			condlog(3, "%s: can't switch off fast_io_fail_tmo "
+				"on iSCSI", pp->dev);
+		} else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO) {
+			condlog(3, "%s: can't set fast_io_fail_tmo to '0'"
+				"on iSCSI", pp->dev);
+		} else {
+			snprintf(value, 11, "%u", mpp->fast_io_fail);
+			if (sysfs_attr_set_value(session_dev, "recovery_tmo",
+						 value, 11)) {
+				condlog(3, "%s: Failed to set recovery_tmo, "
+					" error %d", pp->dev, errno);
+			}
+		}
+	}
+	udev_device_unref(session_dev);
+	return;
+}
+
 int
 sysfs_set_scsi_tmo (struct multipath *mpp)
 {
@@ -382,7 +422,10 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 		return 0;
 
 	vector_foreach_slot(mpp->paths, pp, i) {
-		sysfs_set_rport_tmo(mpp, pp);
+		if (pp->sg_id.proto_id == SCSI_PROTOCOL_FCP)
+			sysfs_set_rport_tmo(mpp, pp);
+		if (pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
+			sysfs_set_session_tmo(mpp, pp);
 	}
 	return 0;
 }
-- 
1.7.4.2
