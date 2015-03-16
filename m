From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 72/78] libmultipath: make vpd page 0x80 optional
Date: Mon, 16 Mar 2015 13:36:59 +0100
Message-ID: <1426509425-15978-73-git-send-email-hare@suse.de>
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

VPD page 0x80 is optional, so we shouldn't return an error if
the page is not present.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d1a16e6..4582a20 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1370,13 +1370,13 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 		parent = udev_device_get_parent(parent);
 	}
 	if (!attr_path || pp->sg_id.host_no == -1)
-		return -ENODEV;
+		return 0;
 
 	if (get_vpd_sysfs(parent, 0x80, pp->serial, SERIAL_SIZE) > 0)
 		condlog(3, "%s: serial = %s",
 			pp->dev, pp->serial);
 
-	return strlen(pp->serial) ? 0 : -EIO;
+	return 0;
 }
 
 static int
-- 
1.8.4.5
