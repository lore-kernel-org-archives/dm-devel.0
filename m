From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] libmultipath: fix discovery of devices with
	sysfs attr containing only spaces
Date: Sat, 11 Apr 2015 12:18:20 -0300
Message-ID: <1428765500-11719-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

commit 43c61e979521b17d9f50ea8e722682c33d0b7d69 causes sysfs_get_<attr>() to
return 0 if attr contains only spaces, and scsi_sysfs_pathinfo() to return 1
in 'if (sysfs_get_<attr>() <= 0)'; this breaks the device's discovery.

Changing the comparison operator '<=' to '<' allows discovery to continue.

This affects some IPR controllers (rev sysfs attr):

	# grep . /sys/block/sda/device/{vendor,model,rev} | tr ' ' '#'
	/sys/block/sda/device/vendor:IBM#####
	/sys/block/sda/device/model:IPR-0###5EC99A00
	/sys/block/sda/device/rev:####

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 libmultipath/discovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4582a20..dde57c0 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1095,7 +1095,7 @@ scsi_sysfs_pathinfo (struct path * pp)
 
 	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 
-	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) <= 0)
+	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) < 0)
 		return 1;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
-- 
1.7.1
