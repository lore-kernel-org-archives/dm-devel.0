From: s90006763 <sunao.sun@huawei.com>
Subject: [PATCH] multipatd: display the host WWNN fields.
Date: Thu, 18 Oct 2018 09:28:39 +0800
Message-ID: <20181018012839.13924-1-sunao.sun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: wangke16@huawei.com, guanjunxiong@huawei.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, lixiaoying@huawei.com, wangzhoumengjian@huawei.com, sunao.sun@huawei.com
List-Id: dm-devel.ids

When the iSCSI path information is displayed using the multipath command, the host WWNN in the path information is not fully displayed, as follows:
Multipathd show paths format "%N%R"
Host WWNN host WWPN
[undef] iqn.xxx-xx.com.xx:oceanstor:xxxx:: xx:x.x.x.x
[undef] iqn.xxx-xx.com.xx:oceanstor:xxxx:: xx:x.x.x.x

 This patch solves this problem and gets the complete display of host WWNN related fields,as follows:
 Multipathd show paths format "%N%R"
 Host WWNN host WWPN
 Iqn.xx-x.com.redhat:86329 iqn.xxx-xx.com.xx:oceanstor:xxxx:: xx:x.x.x.x
 Iqn.xx-x.com.redhat:86329 iqn.xxx-xx.com.xx:oceanstor:xxxx:: xx:x.x.x.x
---
 libmultipath/discovery.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.c     |  4 ++-
 libmultipath/structs.h   |  1 +
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 873035e5..a974c358 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -404,6 +404,71 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	return 0;
 }
 
+int
+sysfs_get_host_nodename (struct path *pp, char * node)
+{
+	const char *hostname, *value;
+	struct udev_device *parent, *hostdev;
+	int host, tgtid = -1;
+
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_host");
+	if (!parent)
+		return 1;
+	
+	/* Check for FibreChannel */
+	value = udev_device_get_sysname(parent);
+	if (sscanf(value, "host%d",
+		   &host) == 1) {
+		hostdev = udev_device_new_from_subsystem_sysname(udev,
+				"fc_host", value);
+		if (hostdev) {
+			condlog(0, "SCSI host %d -> "
+				"FC host %d",
+				pp->sg_id.host_no, host);
+			value = udev_device_get_sysattr_value(hostdev,
+							      "node_name");
+			if (value) {
+				strncpy(node, value, NODE_NAME_SIZE);
+				udev_device_unref(hostdev);
+				return 0;
+			} else
+				udev_device_unref(hostdev);
+		}
+	}
+
+	/* Check for iSCSI */
+	parent = pp->udev;
+	hostname = NULL;
+	while (parent) {
+		hostname = udev_device_get_sysname(parent);
+		if (hostname && sscanf(hostname , "session%d", &tgtid) == 1)
+			break;
+		parent = udev_device_get_parent(parent);
+		hostname = NULL;
+		tgtid = -1;
+	}
+	if (parent && hostname) {
+		hostdev = udev_device_new_from_subsystem_sysname(udev,
+				"iscsi_session", hostname);
+		if (hostdev) {
+			const char *value;
+
+			value = udev_device_get_sysattr_value(hostdev, "initiatorname");
+			if (value) {
+				strncpy(node, value, NODE_NAME_SIZE);
+				udev_device_unref(hostdev);
+				return 0;
+			}
+			else
+				udev_device_unref(hostdev);
+		}
+	}
+	
+	/* Unknown SCSI transport. Keep fingers crossed */
+	pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
+	return 0;
+}
+
 int sysfs_get_host_adapter_name(const struct path *pp, char *adapter_name)
 {
 	int proto_id;
@@ -1191,6 +1256,11 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 			pp->sg_id.channel,
 			pp->sg_id.scsi_id,
 			pp->sg_id.lun);
+	/*
+	 * host node name
+	 */
+	if(sysfs_get_host_nodename(pp, pp->host_node_name))
+		return PATHINFO_FAILED;
 
 	/*
 	 * target node name
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7b610b94..d512ce19 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -554,7 +554,9 @@ out:
 int
 snprint_host_wwnn (char * buff, size_t len, const struct path * pp)
 {
-	return snprint_host_attr(buff, len, pp, "node_name");
+	if (pp->host_node_name[0] == '\0')
+		return snprintf(buff, len, "[undef]");
+	return snprint_str(buff, len, pp->host_node_name);
 }
 
 int
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 0a2623a0..63bd3941 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -253,6 +253,7 @@ struct path {
 	char product_id[PATH_PRODUCT_SIZE];
 	char rev[PATH_REV_SIZE];
 	char serial[SERIAL_SIZE];
+	char host_node_name[NODE_NAME_SIZE];
 	char tgt_node_name[NODE_NAME_SIZE];
 	unsigned long long size;
 	unsigned int checkint;
-- 
2.12.0.windows.1
