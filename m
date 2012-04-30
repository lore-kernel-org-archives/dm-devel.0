From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/16] Use udev devices during discovery
Date: Mon, 30 Apr 2012 12:26:03 +0200
Message-ID: <1335781568-13299-13-git-send-email-hare@suse.de>
References: <1335781568-13299-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335781568-13299-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

Remove all hand-crafted sysfs access code and replace it with
libudev functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |  309 +++++++++++++--------------------------------
 1 files changed, 89 insertions(+), 220 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 452c709..7adda2a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -192,127 +192,126 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 }
 
 int
-sysfs_get_size (struct path *pp, unsigned long long * size)
+sysfs_get_tgt_nodename (struct path *pp, char * node)
 {
-	const char * attr;
-	int r;
-
-	if (!pp->udev)
-		return 1;
-
-	attr = udev_device_get_sysattr_value(pp->udev, "size");
-	if (!attr) {
-		condlog(3, "%s: No size attribute in sysfs", pp->dev);
-		return 1;
-	}
-
-	r = sscanf(attr, "%llu\n", size);
+	const char *targetid, *value;
+	struct udev_device *parent, *tgtdev;
 
-	if (r != 1) {
-		condlog(3, "%s: Cannot parse size attribute '%s'",
-			pp->dev, attr);
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_device");
+	if (!parent)
 		return 1;
+	/* Check for SAS */
+	value = udev_device_get_sysattr_value(parent, "sas_address");
+	if (value) {
+		strncpy(node, value, NODE_NAME_SIZE);
+		return 0;
 	}
 
-	return 0;
-}
-
-int
-sysfs_get_tgt_nodename (struct path *pp, char * node)
-{
-	const char * targetid;
-	struct udev_device *parent;
-	char attr_path[SYSFS_PATH_SIZE];
-	size_t len;
-
-	parent = pp->udev;
-	while (parent) {
-		targetid = udev_device_get_sysname(parent);
-		if (!strncmp(targetid , "target", 6))
-			break;
-		parent = udev_device_get_parent(parent);
-	}
-	/* 'target' needs to exist */
-	if (!parent || !targetid)
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_target");
+	if (!parent)
 		return 1;
+	tgtdev = udev_device_new_from_subsystem_sysname(conf->udev, "fc_transport", udev_device_get_sysname(parent));
 	/* Check if it's FibreChannel */
-	if (safe_sprintf(attr_path,
-			 "/class/fc_transport/%s", targetid)) {
-		condlog(0, "attr_path too small");
-		return 1;
-	}
+	if (tgtdev) {
+		const char *value;
 
-	len = sysfs_attr_get_value(attr_path, "node_name",
-				   node, NODE_NAME_SIZE);
-	if (len)
-		return 0;
+		value = udev_device_get_sysattr_value(tgtdev, "node_name");
+		if (value) {
+			strncpy(node, value, NODE_NAME_SIZE);
+			return 0;
+		}
+		udev_device_unref(tgtdev);
+	}
 
 	/* Check for iSCSI */
 	parent = pp->udev;
+	targetid = NULL;
 	while (parent) {
 		targetid = udev_device_get_sysname(parent);
 		if (!strncmp(targetid , "session", 6))
 			break;
 		parent = udev_device_get_parent(parent);
+		targetid = NULL;
 	}
 	if (parent) {
-		if (safe_sprintf(attr_path, "/class/iscsi_session/%s",
-				 targetid)) {
-			condlog(0, "attr_path too small");
-			return 1;
+		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev, "iscsi_session", targetid);
+		if (node) {
+			const char *value;
+
+			value = udev_device_get_sysattr_value(tgtdev, "targetname");
+			if (value) {
+				strncpy(node, value, NODE_NAME_SIZE);
+				return 0;
+			}
+			udev_device_unref(tgtdev);
 		}
-		len = sysfs_attr_get_value(attr_path, "targetname", node,
-					   NODE_NAME_SIZE);
-		if (len)
-			return 0;
 	}
-
 	return 1;
 }
 
-static int
-find_rport_id(struct path *pp)
+static void
+sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
-	char attr_path[SYSFS_PATH_SIZE];
-	char *dir, *base;
-	int host, channel, rport_id = -1;
-
-	if (safe_sprintf(attr_path,
-			 "/class/fc_transport/target%i:%i:%i",
-			 pp->sg_id.host_no, pp->sg_id.channel,
-			 pp->sg_id.scsi_id)) {
-		condlog(0, "attr_path too small for target");
-		return 1;
-	}
-
-	if (sysfs_resolve_link(attr_path, SYSFS_PATH_SIZE))
-		return -1;
-
-	condlog(4, "target%d:%d:%d -> path %s", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id, attr_path);
-	dir = attr_path;
-	do {
-		base = basename(dir);
-		dir = dirname(dir);
+	struct udev_device *parent = pp->udev;
+	struct udev_device *rport_dev = NULL;
+	char value[11];
+	const char *rport_id = NULL;
 
-		if (sscanf((const char *)base, "rport-%d:%d-%d", &host, &channel, &rport_id) == 3)
+	while (parent) {
+		rport_id = udev_device_get_sysname(parent);
+		if (!strncmp(rport_id, "rport-", 6))
 			break;
-	} while (strcmp((const char *)dir, "/"));
-
-	if (rport_id < 0)
-		return -1;
-
-	condlog(4, "target%d:%d:%d -> rport_id %d", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id, rport_id);
-	return rport_id;
+		parent = udev_device_get_parent(parent);
+		rport_id = NULL;
+	}
+	if (!parent || !rport_id) {
+		condlog(0, "%s: rport id not found", pp->dev);
+		return;
+	}
+	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev, "fc_remote_ports", rport_id);
+	if (!rport_dev) {
+		condlog(3, "%s: No fc_remote_port device for '%s'", pp->dev,
+			rport_id);
+		return;
+	}
+	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
+		pp->sg_id.channel, pp->sg_id.scsi_id, rport_id);
+
+	snprintf(value, 11, "%u", mpp->dev_loss);
+	if (sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11) < 0) {
+		if ((!mpp->fast_io_fail ||
+		     mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
+		    && mpp->dev_loss > 600) {
+			condlog(3, "%s: limiting dev_loss_tmo to 600, since "
+				"fast_io_fail is not set", mpp->alias);
+			snprintf(value, 11, "%u", 600);
+			if (sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
+						 value, 11) < 0)
+				condlog(0, "%s failed to set dev_loss_tmo",
+					mpp->alias);
+			return;
+		}
+	}
+	if (mpp->fast_io_fail){
+		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
+			sprintf(value, "off");
+		else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
+			sprintf(value, "0");
+		else
+			snprintf(value, 11, "%u", mpp->fast_io_fail);
+		if (sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
+					 value, 11) < 0) {
+			condlog(0, "%s failed to set fast_io_fail_tmo",
+				mpp->alias);
+		}
+	}
 }
 
 int
 sysfs_set_scsi_tmo (struct multipath *mpp)
 {
-	char attr_path[SYSFS_PATH_SIZE];
 	struct path *pp;
 	int i;
-	char value[11];
-	int rport_id;
 	int dev_loss_tmo = mpp->dev_loss;
 
 	if (mpp->no_path_retry > 0) {
@@ -339,75 +338,11 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 		return 0;
 
 	vector_foreach_slot(mpp->paths, pp, i) {
-		rport_id = find_rport_id(pp);
-		if (rport_id < 0) {
-			condlog(3, "failed to find rport_id for target%d:%d:%d", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id);
-			return 1;
-		}
-
-		if (safe_snprintf(attr_path, SYSFS_PATH_SIZE,
-				  "/class/fc_remote_ports/rport-%d:%d-%d",
-				  pp->sg_id.host_no, pp->sg_id.channel,
-				  rport_id)) {
-			condlog(0, "attr_path '/class/fc_remote_ports/rport-%d:%d-%d' too large", pp->sg_id.host_no, pp->sg_id.channel, rport_id);
-			return 1;
-		}
-		if (mpp->dev_loss){
-			snprintf(value, 11, "%u", mpp->dev_loss);
-			if (sysfs_attr_set_value(attr_path, "dev_loss_tmo",
-						 value, 11) < 0) {
-				int err = 1;
-				if ((!mpp->fast_io_fail || mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF) && mpp->dev_loss > 600) {
-					strncpy(value, "600", 4);
-					condlog(3, "%s: limiting dev_loss_tmo to 600, since fast_io_fail is not set", mpp->alias);
-					if (sysfs_attr_set_value(attr_path, "dev_loss_tmo", value, 11) >= 0)
-						err = 0;
-				}
-				if (err) {
-					condlog(0, "%s failed to set %s/dev_loss_tmo", mpp->alias, attr_path);
-					return 1;
-				}
-			}
-		}
-		if (mpp->fast_io_fail){
-			if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-				sprintf(value, "off");
-			else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
-				sprintf(value, "0");
-			else
-				snprintf(value, 11, "%u", mpp->fast_io_fail);
-			if (sysfs_attr_set_value(attr_path, "fast_io_fail_tmo",
-						 value, 11) < 0) {
-				condlog(0,
-					"%s failed to set %s/fast_io_fail_tmo", 
-					mpp->alias, attr_path);
-				return 1;
-			}
-		}
+		sysfs_set_rport_tmo(mpp, pp);
 	}
 	return 0;
 }
 
-static int
-opennode (char * dev, int mode)
-{
-	char devpath[FILE_NAME_SIZE], *ptr;
-
-	if (safe_sprintf(devpath, "%s/%s", conf->udev_dir, dev)) {
-		condlog(0, "devpath too small");
-		return -1;
-	}
-	/*
-	 * Translate '!' into '/'
-	 */
-	ptr = devpath;
-	while ((ptr = strchr(ptr, '!'))) {
-		*ptr = '/';
-		ptr++;
-	}
-	return open(devpath, mode);
-}
-
 int
 do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
        void *resp, int mx_resp_len)
@@ -484,72 +419,6 @@ get_serial (char * str, int maxlen, int fd)
 }
 
 static int
-get_inq (char * dev, char * vendor, char * product, char * rev, int fd)
-{
-	unsigned char buff[MX_ALLOC_LEN + 1] = {0};
-	int len;
-
-	if (fd < 0)
-		return 1;
-
-	if (0 != do_inq(fd, 0, 0, 0, buff, MX_ALLOC_LEN))
-		return 1;
-
-	/* Check peripheral qualifier */
-	if ((buff[0] >> 5) != 0) {
-		int pqual = (buff[0] >> 5);
-		switch (pqual) {
-		case 1:
-			condlog(3, "%s: INQUIRY failed, LU not connected", dev);
-			break;
-		case 3:
-			condlog(3, "%s: INQUIRY failed, LU not supported", dev);
-			break;
-		default:
-			condlog(3, "%s: INQUIRY failed, Invalid PQ %x",
-				dev, pqual);
-			break;
-		}
-
-		return 1;
-	}
-
-	len = buff[4] + 4;
-
-	if (len < 8) {
-		condlog(3, "%s: INQUIRY response too short (len %d)",
-			dev, len);
-		return 1;
-	}
-
-	len -= 8;
-	memset(vendor, 0x0, 8);
-	memcpy(vendor, buff + 8, len > 8 ? 8 : len);
-	vendor[8] = '\0';
-	strchop(vendor);
-	if (len <= 8)
-		return 0;
-
-	len -= 8;
-
-	memset(product, 0x0, 16);
-	memcpy(product, buff + 16, len > 16 ? 16 : len);
-	product[16] = '\0';
-	strchop(product);
-	if (len <= 16)
-		return 0;
-
-	len -= 16;
-
-	memset(rev, 0x0, 4);
-	memcpy(rev, buff + 32, 4);
-	rev[4] = '\0';
-	strchop(rev);
-
-	return 0;
-}
-
-static int
 get_geometry(struct path *pp)
 {
 	if (pp->fd < 0)
@@ -980,7 +849,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	 * fetch info not available through sysfs
 	 */
 	if (pp->fd < 0)
-		pp->fd = opennode(pp->dev, O_RDWR);
+		pp->fd = open(udev_device_get_devnode(pp->udev), O_RDWR);
 
 	if (pp->fd < 0) {
 		condlog(4, "Couldn't open node for %s: %s",
-- 
1.7.3.4
