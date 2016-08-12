From: tang.junhui@zte.com.cn
Subject: [PATCH] libmultipath: retry to get path serial number by
	get_serial() after failure by get_vpd_sysfs()
Date: Fri, 12 Aug 2016 11:43:56 +0800
Message-ID: <1470973436-11512-1-git-send-email-tang.junhui@zte.com.cn>
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

Some operating systems have no such file vpd_pg80 in sys directory
such as /sys/devices/platform/host23/session21/target23:0:0/23:0:0:33/,
so path serial number would be failed to get by get_vpd_sysfs(),
we need retry to get it by get_serial to avoid empty serial of the path.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/discovery.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0974c92..bb3116d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1435,10 +1435,14 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 	if (!attr_path || pp->sg_id.host_no == -1)
 		return 0;
 
-	if (get_vpd_sysfs(parent, 0x80, pp->serial, SERIAL_SIZE) > 0)
-		condlog(3, "%s: serial = %s",
-			pp->dev, pp->serial);
+	if (get_vpd_sysfs(parent, 0x80, pp->serial, SERIAL_SIZE) <= 0) {
+		if (get_serial(pp->serial, SERIAL_SIZE, pp->fd)) {
+			condlog(2, "%s: fail to get serial", pp->dev);
+			return 0;
+		}
+	}
 
+	condlog(3, "%s: serial = %s", pp->dev, pp->serial);
 	return 0;
 }
 
-- 
2.8.1.windows.1
