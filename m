From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/39] libmultipath/discovery.c: handle errors
	from sscanf()
Date: Thu, 16 Jun 2016 11:47:19 +0200
Message-ID: <1466070465-1021-14-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index db82b00..5d5441d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1179,16 +1179,17 @@ ccw_sysfs_pathinfo (struct path * pp)
 	 */
 	attr_path = udev_device_get_sysname(parent);
 	pp->sg_id.lun = 0;
-	sscanf(attr_path, "%i.%i.%x",
-			&pp->sg_id.host_no,
-			&pp->sg_id.channel,
-			&pp->sg_id.scsi_id);
-	condlog(3, "%s: h:b:t:l = %i:%i:%i:%i",
+	if (sscanf(attr_path, "%i.%i.%x",
+		   &pp->sg_id.host_no,
+		   &pp->sg_id.channel,
+		   &pp->sg_id.scsi_id) == 3) {
+		condlog(3, "%s: h:b:t:l = %i:%i:%i:%i",
 			pp->dev,
 			pp->sg_id.host_no,
 			pp->sg_id.channel,
 			pp->sg_id.scsi_id,
 			pp->sg_id.lun);
+	}
 
 	return 0;
 }
-- 
2.6.6
