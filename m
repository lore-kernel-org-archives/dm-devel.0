From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 61/78] Ignore devices when sysfs_get_tgt_nodename
	fails
Date: Mon, 16 Mar 2015 13:36:48 +0100
Message-ID: <1426509425-15978-62-git-send-email-hare@suse.de>
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

If sysfs_get_tgt_nodename fails we should not try to use this
device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b1db00f..a9962d1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -349,8 +349,9 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 		snprintf(node, NODE_NAME_SIZE, "ata-%d.00", tgtid);
 		return 0;
 	}
+	/* Unknown SCSI transport. Keep fingers crossed */
 	pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
-	return 1;
+	return 0;
 }
 
 int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name)
@@ -807,10 +808,11 @@ scsi_sysfs_pathinfo (struct path * pp)
 	/*
 	 * target node name
 	 */
-	if(!sysfs_get_tgt_nodename(pp, pp->tgt_node_name)) {
-		condlog(3, "%s: tgt_node_name = %s",
-			pp->dev, pp->tgt_node_name);
-	}
+	if(sysfs_get_tgt_nodename(pp, pp->tgt_node_name))
+		return 1;
+
+	condlog(3, "%s: tgt_node_name = %s",
+		pp->dev, pp->tgt_node_name);
 
 	return 0;
 }
-- 
1.8.4.5
