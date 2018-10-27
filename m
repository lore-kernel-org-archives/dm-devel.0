From: s90006763 <sunao.sun@huawei.com>
Subject: [PATCH] multipathd: display the host WWNN fields When
	the iSCSI path information is displayed using the multipath command,
	the host WWNN in the path information is not fully displayed,
	as follows: Multipathd show paths format "%N %n" Host WWNN Target
	WWNN [undef] iqn.xxx-xx.com.xx:oceanstor:xxxx:: xx:x.x
	[undef] iqn.xxx-xx.com.xx:oceanstor:xxxx:: xx:x.x
Date: Sat, 27 Oct 2018 12:40:38 +0800
Message-ID: <20181027044038.10192-1-sunao.sun@huawei.com>
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
Cc: wangke16@huawei.com, guanjunxiong@huawei.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, lixiaoying@huawei.com, sunao.sun@huawei.com
List-Id: dm-devel.ids

This patch solves this problem and gets the complete display of host
WWNN related fields,as follows:multipathd show paths format "%N %n"
Host WWNN Target WWPN
Iqn.xx-x.com.redhat:86329 iqn.xxx-xx.com.xx:oceanstor:xxxx::xx:x.x
Iqn.xx-x.com.redhat:86329 iqn.xxx-xx.com.xx:oceanstor:xxxx::xx:x.x
---
 libmultipath/print.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7b610b94..956d705d 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -525,15 +525,13 @@ snprint_path_mpp (char * buff, size_t len, const struct path * pp)
 }
 
 static int
-snprint_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
+snprint_fc_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
 {
 	struct udev_device *host_dev = NULL;
 	char host_id[32];
 	const char *value = NULL;
 	int ret;
 
-	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
-		return snprintf(buff, len, "[undef]");
 	sprintf(host_id, "host%d", pp->sg_id.host_no);
 	host_dev = udev_device_new_from_subsystem_sysname(udev, "fc_host",
 							  host_id);
@@ -551,16 +549,54 @@ out:
 	return ret;
 }
 
+static int
+snprint_iscsi_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
+{
+        struct udev_device *host_dev = NULL;
+        char host_id[32];
+        const char *value = NULL;
+        int ret;
+
+        sprintf(host_id, "session%d", pp->sg_id.transport_id);
+        host_dev = udev_device_new_from_subsystem_sysname(udev, "iscsi_session",
+                                                          host_id);
+        if (!host_dev) {
+                condlog(1, "%s: No iscsi_host device for '%s'", pp->dev, host_id);
+                goto out;
+        }
+        value = udev_device_get_sysattr_value(host_dev, attr);
+        if (value)
+                ret = snprint_str(buff, len, value);
+        udev_device_unref(host_dev);
+out:
+	if (!value)
+		ret = snprintf(buff, len, "[unknown]");
+	return ret;
+}
+
 int
 snprint_host_wwnn (char * buff, size_t len, const struct path * pp)
 {
-	return snprint_host_attr(buff, len, pp, "node_name");
+	if(pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
+	{
+		return snprint_iscsi_host_attr(buff, len, pp, "initiatorname");
+	}
+	else if (pp->sg_id.proto_id == SCSI_PROTOCOL_FCP)
+	{
+		return snprint_fc_host_attr(buff, len, pp, "node_name");
+	}
+	return snprintf(buff, len, "[undef]");
 }
 
 int
 snprint_host_wwpn (char * buff, size_t len, const struct path * pp)
 {
-	return snprint_host_attr(buff, len, pp, "port_name");
+	
+	if (pp->sg_id.proto_id == SCSI_PROTOCOL_FCP)
+	{
+		return snprint_fc_host_attr(buff, len, pp, "port_name");
+	}
+	return snprintf(buff, len, "[undef]");	
 }
 
 int
-- 
2.12.0.windows.1
