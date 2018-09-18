From: "Sunao (A)" <sunao.sun@huawei.com>
Subject: Re: [PATCH] This patch filled the host WWNN. when using
 the command of multipathd to list the isscsi paths informartion,
 the host WWNN of paths informartion is not exist. like this: multipathd show
 paths format "%N %R" host WWNN host WWPN [undef] iqn.20
Date: Tue, 18 Sep 2018 09:09:22 +0000
Message-ID: <AD49694D3F7B7B4D96C353DCB55098B888110F20@dggeml524-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "hare@suse.de" <hare@suse.de>, "mwilck@suse.com" <mwilck@suse.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: "wangke (U)" <wangke16@huawei.com>, dingwenyi <dingwenyi@huawei.com>, guanjunxiong <guanjunxiong@huawei.com>, "Chengjike (ISSP)" <chengjike.cheng@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>, lixiaoying <lixiaoying@huawei.com>
List-Id: dm-devel.ids

this patch solved this problem and filled the host WWNN.
like this:
multipathd show paths format "%N %R"
host WWNN                           host WWPN
iqn.1994-05.com.redhat:86329aefccdb iqn.2006-08.com.huawei:oceanstor:21000022a10beb2a::1020002:129.13.100.240
iqn.1994-05.com.redhat:86329aefccdb iqn.2006-08.com.huawei:oceanstor:21000022a10beb2a::20003:129.13.100.241
---
 libmultipath/print.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c index 9da6a77c..e2b90301 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -539,20 +539,39 @@ snprint_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
 	char host_id[32];
 	const char *value = NULL;
 	int ret;
-
-	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
+    
+	if ((pp->sg_id.proto_id != SCSI_PROTOCOL_FCP) && (pp->sg_id.proto_id 
+!= SCSI_PROTOCOL_ISCSI) )
 		return snprintf(buff, len, "[undef]");
-	sprintf(host_id, "host%d", pp->sg_id.host_no);
-	host_dev = udev_device_new_from_subsystem_sysname(udev, "fc_host",
-							  host_id);
-	if (!host_dev) {
-		condlog(1, "%s: No fc_host device for '%s'", pp->dev, host_id);
-		goto out;
+	if((pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI) && strcmp(buff, wwid) 
+== 0)
+		
+    if(pp->sg_id.proto_id == SCSI_PROTOCOL_FCP)
+    {
+		sprintf(host_id, "host%d", pp->sg_id.host_no);
+		host_dev = udev_device_new_from_subsystem_sysname(udev, "fc_host",
+								  host_id);
+		if (!host_dev) {
+			condlog(1, "%s: No fc_host device for '%s'", pp->dev, host_id);
+			goto out;
+		}
+		value = udev_device_get_sysattr_value(host_dev, attr);
+		if (value)
+			ret = snprint_str(buff, len, value);
+		udev_device_unref(host_dev);
+    }
+	else if(pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
+	{
+	    sprintf(host_id, "session%d", pp->sg_id.transport_id);
+		host_dev = udev_device_new_from_subsystem_sysname(udev, "iscsi_session",
+								  host_id);
+		if (!host_dev) {
+			condlog(3, "%s: No iscsi_session for '%s'", pp->dev, host_id);
+			goto out;
+		}
+		value = udev_device_get_sysattr_value(host_dev, attr);
+		if (value)
+			ret = snprint_str(buff, len, value);
+		udev_device_unref(host_dev);
 	}
-	value = udev_device_get_sysattr_value(host_dev, attr);
-	if (value)
-		ret = snprint_str(buff, len, value);
-	udev_device_unref(host_dev);
 out:
 	if (!value)
 		ret = snprintf(buff, len, "[unknown]"); @@ -562,7 +581,14 @@ out:
 int
 snprint_host_wwnn (char * buff, size_t len, const struct path * pp)  {
-	return snprint_host_attr(buff, len, pp, "node_name");
+	if(pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
+	{
+	    return snprint_host_attr(buff, len, pp, "initiatorname");
+	}
+	else
+	{
+		return snprint_host_attr(buff, len, pp, "node_name");
+	}
 }
 
could you agree with this solution or have a better solution?


I am looking forward to your reply.
Best wishes to you.
